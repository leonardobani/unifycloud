import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../l10n/l10n_extension.dart';
import '../../providers/cloud_accounts_provider.dart';
import '../../services/oauth_service.dart';
import '../../utils/token_utils.dart';
import '../theme/app_theme.dart';

/// Modal dialog allowing users to configure and connect a new cloud storage provider.
class AddCloudDialog extends ConsumerStatefulWidget {

  const AddCloudDialog({
    super.key,
    this.initialProvider,
    this.initialTargetRemote,
  });
  final String? initialProvider;
  final String? initialTargetRemote;

  @override
  ConsumerState<AddCloudDialog> createState() => _AddCloudDialogState();
}

class _AddCloudDialogState extends ConsumerState<AddCloudDialog> {
  String _selectedProvider = 'drive';
  String _authMethod = 'unifycloud'; // 'unifycloud', 'rclone', or 'custom'
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _clientIdController = TextEditingController();
  final _clientSecretController = TextEditingController();
  final _tokenController = TextEditingController();

  // SFTP / WebDAV / S3 controllers
  final _hostController = TextEditingController();
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  final _pathController = TextEditingController();

  // Crypt (E2E Encryption) controllers & state
  String? _cryptTargetRemote;
  final _cryptTargetPathController = TextEditingController();
  final _cryptPasswordController = TextEditingController();
  final _cryptConfirmPasswordController = TextEditingController();
  final _cryptSaltController = TextEditingController();
  String _filenameEncryption = 'standard';
  bool _directoryNameEncryption = true;
  bool _obscureCryptPassword = true;
  bool _obscureCryptConfirmPassword = true;
  bool _obscureCryptSalt = true;

  bool _isAuthenticating = false;
  bool _isAuthError = false;
  String? _statusMessage;
  String? _authUrl;
  bool _browserOpened = false;
  bool _isSaving = false;
  String? _discoveredDriveId;
  String? _discoveredDriveType;

  List<Map<String, String>> _getAvailableProviders(AppLocalizations l10n) => [
    {'type': 'drive', 'name': 'Google Drive', 'subtitle': l10n.providerSubtitleDrive},
    {'type': 'dropbox', 'name': 'Dropbox', 'subtitle': l10n.providerSubtitleDropbox},
    {'type': 'onedrive', 'name': 'Microsoft OneDrive', 'subtitle': l10n.providerSubtitleOneDrive},
    {'type': 'webdav', 'name': 'Nextcloud / WebDAV', 'subtitle': l10n.providerSubtitleWebdav},
    {'type': 'sftp', 'name': 'SSH / SFTP', 'subtitle': l10n.providerSubtitleSftp},
    {'type': 's3', 'name': 'Amazon S3 / MinIO', 'subtitle': l10n.providerSubtitleS3},
    {'type': 'local', 'name': l10n.providerLocalName, 'subtitle': l10n.providerSubtitleLocal},
    {'type': 'crypt', 'name': l10n.providerCryptName, 'subtitle': l10n.providerSubtitleCrypt},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialProvider != null) {
      _selectedProvider = widget.initialProvider!;
    }
    if (widget.initialTargetRemote != null) {
      _cryptTargetRemote = widget.initialTargetRemote;
    }
    _updateDefaultName(_selectedProvider);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _clientIdController.dispose();
    _clientSecretController.dispose();
    _tokenController.dispose();
    _hostController.dispose();
    _userController.dispose();
    _passController.dispose();
    _pathController.dispose();
    _cryptTargetPathController.dispose();
    _cryptPasswordController.dispose();
    _cryptConfirmPasswordController.dispose();
    _cryptSaltController.dispose();
    super.dispose();
  }

  void _onProviderChanged(String type) {
    setState(() {
      _selectedProvider = type;
      _discoveredDriveId = null;
      _discoveredDriveType = null;
      _updateDefaultName(type);
    });
  }

  void _updateDefaultName(String type) {
    switch (type) {
      case 'drive':
        _nameController.text = 'GoogleDrive';
      case 'dropbox':
        _nameController.text = 'Dropbox';
      case 'onedrive':
        _nameController.text = 'OneDrive';
      case 'webdav':
        _nameController.text = 'Nextcloud';
      case 'sftp':
        _nameController.text = 'ServerSFTP';
      case 's3':
        _nameController.text = 'BucketS3';
      case 'local':
        _nameController.text = 'LocalDisk';
      case 'crypt':
        _nameController.text = 'EncryptedVault';
    }
  }

  Future<void> _startOAuthFlow() async {
    final l10n = context.l10n;
    final String effectiveClientId;
    final String? effectiveClientSecret;

    if (_authMethod == 'unifycloud') {
      final ucId = OAuthService.getUnifyCloudClientId(_selectedProvider);
      final ucSecret = OAuthService.getUnifyCloudClientSecret(_selectedProvider);

      if (ucId == null || ucId.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.noUnifyCloudClientId),
          ),
        );
        return;
      }
      effectiveClientId = ucId;
      effectiveClientSecret = ucSecret;
    } else if (_authMethod == 'rclone') {
      final rcloneId = OAuthService.getRcloneClientId(_selectedProvider);
      final rcloneSecret =
          OAuthService.getRcloneClientSecret(_selectedProvider);

      if (rcloneId == null || rcloneId.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.noRcloneClientId),
          ),
        );
        return;
      }
      effectiveClientId = rcloneId;
      effectiveClientSecret = rcloneSecret;
    } else {
      effectiveClientId = _clientIdController.text.trim();
      effectiveClientSecret = _clientSecretController.text.trim().isNotEmpty
          ? _clientSecretController.text.trim()
          : null;

      if (effectiveClientId.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.enterClientIdForOauth),
          ),
        );
        return;
      }
    }

    setState(() {
      _isAuthenticating = true;
      _isAuthError = false;
      _authUrl = null;
      _browserOpened = false;
      _statusMessage = l10n.oauthStartingLocalServer;
    });

    try {
      final oauth = ref.read(oauthServiceProvider);
      final tokens = await oauth.authenticate(
        providerType: _selectedProvider,
        clientId: effectiveClientId,
        clientSecret: effectiveClientSecret,
        l10n: l10n,
        onAuthUrlReady: (authUrl, opened) {
          if (mounted) {
            setState(() {
              _authUrl = authUrl.toString();
              _browserOpened = opened;
              _isAuthError = false;
              if (opened) {
                _statusMessage = l10n.oauthBrowserOpened;
              } else {
                _statusMessage = l10n.oauthBrowserNotSupported;
              }
            });
          }
        },
      );

      if (mounted) {
        setState(() {
          if (tokens.containsKey('drive_id')) {
            _discoveredDriveId = tokens['drive_id']?.toString();
          }
          if (tokens.containsKey('drive_type')) {
            _discoveredDriveType = tokens['drive_type']?.toString();
          }
          _tokenController.text =
              TokenUtils.normalizeTokenJson(jsonEncode(tokens));
          _isAuthError = false;
          _statusMessage = l10n.oauthCompletedSuccess;
          _authUrl = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isAuthError = true;
          _statusMessage = l10n.oauthErrorPrefix(e.toString());
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAuthenticating = false;
        });
      }
    }
  }

  Future<void> _saveRemote() async {
    if (!_formKey.currentState!.validate()) return;

    final l10n = context.l10n;
    final remoteName = _nameController.text.trim();
    final options = <String, String>{};

    switch (_selectedProvider) {
      case 'drive':
      case 'dropbox':
      case 'onedrive':
        if (_authMethod == 'custom') {
          if (_clientIdController.text.trim().isNotEmpty) {
            options['client_id'] = _clientIdController.text.trim();
          }
          if (_clientSecretController.text.trim().isNotEmpty) {
            options['client_secret'] = _clientSecretController.text.trim();
          }
        }
        if (_tokenController.text.trim().isNotEmpty) {
          final normToken =
              TokenUtils.normalizeTokenJson(_tokenController.text.trim());
          options['token'] = normToken;

          // For onedrive, extract drive_id / drive_type from token JSON if present
          if (_selectedProvider == 'onedrive') {
            try {
              final decoded = jsonDecode(normToken);
              if (decoded is Map) {
                if (decoded.containsKey('drive_id')) {
                  options['drive_id'] = decoded['drive_id'].toString();
                }
                if (decoded.containsKey('drive_type')) {
                  options['drive_type'] = decoded['drive_type'].toString();
                }
              }
            } catch (_) {}
          }
        }
        if (_selectedProvider == 'onedrive') {
          if (_discoveredDriveId != null && _discoveredDriveId!.isNotEmpty) {
            options['drive_id'] = _discoveredDriveId!;
          }
          if (_discoveredDriveType != null &&
              _discoveredDriveType!.isNotEmpty) {
            options['drive_type'] = _discoveredDriveType!;
          }
        }
      case 'webdav':
        options['url'] = _hostController.text.trim();
        options['user'] = _userController.text.trim();
        options['pass'] = _passController.text.trim();
        options['vendor'] = 'nextcloud';
      case 'sftp':
        options['host'] = _hostController.text.trim();
        options['user'] = _userController.text.trim();
        options['pass'] = _passController.text.trim();
      case 's3':
        options['endpoint'] = _hostController.text.trim();
        options['access_key_id'] = _userController.text.trim();
        options['secret_access_key'] = _passController.text.trim();
      case 'local':
        options['copy_links'] = 'true';
      case 'crypt':
        if (_cryptTargetRemote == null || _cryptTargetRemote!.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.selectVaultDestination),
            ),
          );
          return;
        }
        if (_cryptPasswordController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.vaultPasswordRequired),
            ),
          );
          return;
        }
        if (_cryptPasswordController.text !=
            _cryptConfirmPasswordController.text) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.vaultPasswordsDoNotMatch),
            ),
          );
          return;
        }

        final targetPath = _cryptTargetPathController.text.trim();
        final cleanPath = targetPath.startsWith('/')
            ? targetPath.substring(1)
            : targetPath;
        final targetRemoteWithColon = _cryptTargetRemote!.contains(':')
            ? _cryptTargetRemote!
            : '${_cryptTargetRemote!}:';
        options['remote'] = '$targetRemoteWithColon$cleanPath';
        options['password'] = _cryptPasswordController.text;
        if (_cryptSaltController.text.trim().isNotEmpty) {
          options['password2'] = _cryptSaltController.text.trim();
        }
        options['filename_encryption'] = _filenameEncryption;
        options['directory_name_encryption'] =
            _directoryNameEncryption ? 'true' : 'false';
    }

    setState(() => _isSaving = true);
    try {
      await ref.read(cloudAccountsProvider.notifier).addRemote(
            name: remoteName,
            type: _selectedProvider,
            options: options,
          );
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorAddingRemote(e.toString()))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final availableProviders = _getAvailableProviders(l10n);
    final isOAuth = ['drive', 'dropbox', 'onedrive'].contains(_selectedProvider);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 550, maxHeight: 700),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      AppTheme.getProviderIcon(_selectedProvider),
                      color: AppTheme.getProviderColor(_selectedProvider),
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      l10n.connectNewCloud,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.selectCloudProvider,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: availableProviders.map((p) {
                            final isSelected = p['type'] == _selectedProvider;
                            return ChoiceChip(
                              label: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    AppTheme.getProviderIcon(p['type']!),
                                    size: 16,
                                    color: AppTheme.getProviderColor(p['type']!),
                                  ),
                                  const SizedBox(width: 6),
                                  Flexible(
                                    child: Text(
                                      p['name']!,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              selected: isSelected,
                              onSelected: (_) => _onProviderChanged(p['type']!),
                            );
                          }).toList(),
                        ),
                        const Divider(height: 32),
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: l10n.cloudAccountName,
                            helperText: l10n.cloudAccountNameHint,
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.label_outline),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return l10n.enterNameError;
                            }
                            if (value.contains(' ') || value.contains(':')) {
                              return l10n.noSpacesOrColons;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        if (isOAuth) ...[
                          DropdownButtonFormField<String>(
                            initialValue: _authMethod,
                            isExpanded: true,
                            decoration: InputDecoration(
                              labelText: l10n.oauthMode,
                              border: const OutlineInputBorder(),
                              prefixIcon: const Icon(Icons.vpn_key_outlined),
                            ),
                            items: [
                              DropdownMenuItem(
                                value: 'unifycloud',
                                child: Text(l10n.oauthOfficial),
                              ),
                              DropdownMenuItem(
                                value: 'rclone',
                                child: Text(l10n.oauthRclone),
                              ),
                              DropdownMenuItem(
                                value: 'custom',
                                child: Text(l10n.oauthCustom),
                              ),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  _authMethod = val;
                                });
                              }
                            },
                          ),
                          const SizedBox(height: 12),
                          if (_authMethod == 'unifycloud') ...[
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blue.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.blue.withValues(alpha: 0.25),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.verified_rounded,
                                    size: 20,
                                    color: Colors.blue,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          l10n.officialOauthTitle,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          l10n.officialOauthActionDesc,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ] else if (_authMethod == 'rclone') ...[
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.amber.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.amber.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.warning_amber_rounded,
                                    size: 20,
                                    color: Colors.amber,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          l10n.rcloneOauthTitle,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          l10n.rcloneOauthWarningDesc,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ] else ...[
                            Container(
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: Colors.teal.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.teal.withValues(alpha: 0.25),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.info_outline, size: 18, color: Colors.teal),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      l10n.customOauthGuideInfo,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            TextFormField(
                              controller: _clientIdController,
                              decoration: InputDecoration(
                                labelText: _selectedProvider == 'drive'
                                    ? l10n.customGoogleClientIdLabel
                                    : l10n.customOauthClientIdLabel,
                                hintText: _selectedProvider == 'drive'
                                    ? l10n.customGoogleClientIdHint
                                    : null,
                                border: const OutlineInputBorder(),
                                prefixIcon: const Icon(Icons.key_outlined),
                              ),
                              validator: (v) {
                                if (_authMethod == 'custom' &&
                                    (v == null || v.trim().isEmpty)) {
                                  return l10n.enterYourClientIdError;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _clientSecretController,
                              decoration: InputDecoration(
                                labelText: l10n.customClientSecretOptional,
                                border: const OutlineInputBorder(),
                                prefixIcon: const Icon(Icons.lock_outline),
                              ),
                              obscureText: true,
                            ),
                          ],
                          const SizedBox(height: 16),
                          OutlinedButton.icon(
                            onPressed: _isAuthenticating ? null : _startOAuthFlow,
                            icon: _isAuthenticating
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Icon(Icons.open_in_browser),
                            label: Text(
                              _isAuthenticating
                                  ? l10n.authenticating
                                  : l10n.startBrowserLogin,
                            ),
                          ),
                          if (_statusMessage != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              _statusMessage!,
                              style: TextStyle(
                                fontSize: 12,
                                color: _isAuthError
                                    ? Colors.red
                                    : (_browserOpened
                                        ? Colors.green
                                        : Colors.orange.shade300),
                              ),
                            ),
                          ],
                          if (_authUrl != null) ...[
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: _browserOpened
                                    ? Colors.green.withValues(alpha: 0.08)
                                    : Colors.orange.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: _browserOpened
                                      ? Colors.green.withValues(alpha: 0.3)
                                      : Colors.orange.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        _browserOpened
                                            ? Icons.check_circle_outline
                                            : Icons.link_rounded,
                                        size: 18,
                                        color: _browserOpened
                                            ? Colors.green
                                            : Colors.orange,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          _browserOpened
                                              ? l10n.browserLaunchedOrCopy
                                              : l10n.copyLinkToCompleteLogin,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color: _browserOpened
                                                ? Colors.green
                                                : Colors.orange,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  SelectableText(
                                    _authUrl!,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontFamily: 'monospace',
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                                    maxLines: 2,
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: FilledButton.icon(
                                          onPressed: () {
                                            Clipboard.setData(
                                                ClipboardData(text: _authUrl!));
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  l10n.copyLinkAndPasteHint,
                                                ),
                                                duration: const Duration(seconds: 3),
                                              ),
                                            );
                                          },
                                          icon:
                                              const Icon(Icons.copy, size: 16),
                                          label: Text(l10n.copyShareLink,
                                              style: const TextStyle(fontSize: 12)),
                                          style: FilledButton.styleFrom(
                                            visualDensity:
                                                VisualDensity.compact,
                                            backgroundColor:
                                                AppTheme.primaryColor,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      OutlinedButton.icon(
                                        onPressed: () {
                                          ref
                                              .read(oauthServiceProvider)
                                              .openBrowser(
                                                  Uri.parse(_authUrl!));
                                        },
                                        icon: const Icon(Icons.open_in_browser,
                                            size: 16),
                                        label: Text(l10n.reopenAuth,
                                            style: const TextStyle(fontSize: 12)),
                                        style: OutlinedButton.styleFrom(
                                          visualDensity: VisualDensity.compact,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _tokenController,
                            maxLines: 2,
                            decoration: InputDecoration(
                              labelText: l10n.tokenJsonLabel,
                              hintText: '{"access_token": "..."}',
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ] else if (_selectedProvider == 'webdav' ||
                            _selectedProvider == 'sftp' ||
                            _selectedProvider == 's3') ...[
                          TextFormField(
                            controller: _hostController,
                            decoration: InputDecoration(
                              labelText: _selectedProvider == 'webdav'
                                  ? l10n.webdavUrlLabel
                                  : (_selectedProvider == 's3'
                                      ? l10n.s3EndpointLabel
                                      : l10n.sftpHostLabel),
                              border: const OutlineInputBorder(),
                              prefixIcon: const Icon(Icons.dns_outlined),
                            ),
                            validator: (v) =>
                                (v == null || v.trim().isEmpty)
                                    ? l10n.requiredFieldError
                                    : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _userController,
                            decoration: InputDecoration(
                              labelText: _selectedProvider == 's3'
                                  ? l10n.s3AccessKeyId
                                  : l10n.usernameLabel,
                              border: const OutlineInputBorder(),
                              prefixIcon: const Icon(Icons.person_outline),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _passController,
                            decoration: InputDecoration(
                              labelText: _selectedProvider == 's3'
                                  ? l10n.s3SecretAccessKey
                                  : l10n.passwordLabel,
                              border: const OutlineInputBorder(),
                              prefixIcon: const Icon(Icons.lock_outline),
                            ),
                            obscureText: true,
                          ),
                        ] else if (_selectedProvider == 'local') ...[
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.info_outline, color: Colors.blue),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      l10n.localProviderInfo,
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ] else if (_selectedProvider == 'crypt') ...[
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF00BFA5).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: const Color(0xFF00BFA5).withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.shield_outlined, color: Color(0xFF00BFA5), size: 22),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        l10n.e2eEncryptionTitle,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        l10n.e2eEncryptionDesc,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Consumer(
                            builder: (context, ref, _) {
                              final remotes = ref.watch(cloudAccountsProvider).remotes;
                              final availableRemotes = remotes.where((r) => r.type != 'crypt').toList();

                              if (availableRemotes.isEmpty) {
                                return Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.amber.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.warning_amber_rounded, color: Colors.amber),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          l10n.noTargetCloudForVault,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }

                              if (_cryptTargetRemote == null ||
                                  !availableRemotes.any((r) => r.name == _cryptTargetRemote)) {
                                _cryptTargetRemote = availableRemotes.first.name;
                              }

                              return DropdownButtonFormField<String>(
                                initialValue: _cryptTargetRemote,
                                isExpanded: true,
                                decoration: InputDecoration(
                                  labelText: l10n.vaultTargetCloudLabel,
                                  helperText: l10n.vaultTargetCloudHelper,
                                  border: const OutlineInputBorder(),
                                  prefixIcon: const Icon(Icons.cloud_outlined),
                                ),
                                items: availableRemotes.map((r) {
                                  return DropdownMenuItem<String>(
                                    value: r.name,
                                    child: Row(
                                      children: [
                                        Icon(
                                          AppTheme.getProviderIcon(r.type),
                                          size: 18,
                                          color: AppTheme.getProviderColor(r.type),
                                        ),
                                        const SizedBox(width: 8),
                                        Text('${r.name} (${r.type})'),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  setState(() {
                                    _cryptTargetRemote = val;
                                  });
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _cryptTargetPathController,
                            decoration: InputDecoration(
                              labelText: l10n.vaultTargetPathLabel,
                              hintText: l10n.vaultTargetPathHint,
                              helperText: l10n.vaultTargetPathHelper,
                              border: const OutlineInputBorder(),
                              prefixIcon: const Icon(Icons.folder_outlined),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _cryptPasswordController,
                            obscureText: _obscureCryptPassword,
                            decoration: InputDecoration(
                              labelText: l10n.vaultMasterPasswordLabel,
                              helperText: l10n.vaultMasterPasswordHelper,
                              border: const OutlineInputBorder(),
                              prefixIcon: const Icon(Icons.lock_rounded),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureCryptPassword ? Icons.visibility_off : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureCryptPassword = !_obscureCryptPassword;
                                  });
                                },
                              ),
                            ),
                            validator: (v) {
                              if (_selectedProvider == 'crypt' && (v == null || v.isEmpty)) {
                                return l10n.vaultEnterPasswordError;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _cryptConfirmPasswordController,
                            obscureText: _obscureCryptConfirmPassword,
                            decoration: InputDecoration(
                              labelText: l10n.vaultConfirmPasswordRequired,
                              border: const OutlineInputBorder(),
                              prefixIcon: const Icon(Icons.lock_outline_rounded),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureCryptConfirmPassword ? Icons.visibility_off : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureCryptConfirmPassword = !_obscureCryptConfirmPassword;
                                  });
                                },
                              ),
                            ),
                            validator: (v) {
                              if (_selectedProvider == 'crypt') {
                                if (v == null || v.isEmpty) {
                                  return l10n.vaultConfirmPasswordError;
                                }
                                if (v != _cryptPasswordController.text) {
                                  return l10n.vaultPasswordsDoNotMatch;
                                }
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _cryptSaltController,
                            obscureText: _obscureCryptSalt,
                            decoration: InputDecoration(
                              labelText: l10n.vaultSaltOptionalLabel,
                              helperText: l10n.vaultSaltHelper,
                              border: const OutlineInputBorder(),
                              prefixIcon: const Icon(Icons.key_outlined),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureCryptSalt ? Icons.visibility_off : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureCryptSalt = !_obscureCryptSalt;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            initialValue: _filenameEncryption,
                            isExpanded: true,
                            decoration: InputDecoration(
                              labelText: l10n.fileNameEncryption,
                              border: const OutlineInputBorder(),
                              prefixIcon: const Icon(Icons.drive_file_rename_outline),
                            ),
                            items: [
                              DropdownMenuItem(
                                value: 'standard',
                                child: Text(l10n.encryptStandard),
                              ),
                              DropdownMenuItem(
                                value: 'obfuscate',
                                child: Text(l10n.encryptObscure),
                              ),
                              DropdownMenuItem(
                                value: 'off',
                                child: Text(l10n.encryptOff),
                              ),
                            ],
                            onChanged: (v) {
                              if (v != null) {
                                setState(() {
                                  _filenameEncryption = v;
                                });
                              }
                            },
                          ),
                          const SizedBox(height: 12),
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(l10n.encryptFolderNames),
                            subtitle: Text(l10n.encryptFolderNamesDesc),
                            value: _directoryNameEncryption,
                            onChanged: _filenameEncryption == 'off'
                                ? null
                                : (v) {
                                    setState(() {
                                      _directoryNameEncryption = v;
                                    });
                                  },
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(l10n.cancel),
                    ),
                    const SizedBox(width: 12),
                    FilledButton(
                      onPressed: _isSaving ? null : _saveRemote,
                      child: _isSaving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(l10n.connectCloud),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
