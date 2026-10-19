import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/cloud_accounts_provider.dart';
import '../../services/oauth_service.dart';
import '../../utils/token_utils.dart';
import '../theme/app_theme.dart';
import '../theme/cosmic_icons.dart';

/// Modal dialog allowing users to configure and connect a new cloud storage provider.
class AddCloudDialog extends ConsumerStatefulWidget {
  final String? initialProvider;
  final String? initialTargetRemote;

  const AddCloudDialog({
    super.key,
    this.initialProvider,
    this.initialTargetRemote,
  });

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
  String? _statusMessage;
  String? _authUrl;
  bool _browserOpened = false;
  bool _isSaving = false;
  String? _discoveredDriveId;
  String? _discoveredDriveType;

  final List<Map<String, String>> _availableProviders = const [
    {'type': 'drive', 'name': 'Google Drive', 'subtitle': 'OAuth2 cloud storage'},
    {'type': 'dropbox', 'name': 'Dropbox', 'subtitle': 'File sync and share'},
    {'type': 'onedrive', 'name': 'Microsoft OneDrive', 'subtitle': 'Personal and business storage'},
    {'type': 'webdav', 'name': 'Nextcloud / WebDAV', 'subtitle': 'Self-hosted or corporate cloud'},
    {'type': 'sftp', 'name': 'SSH / SFTP', 'subtitle': 'Secure remote server'},
    {'type': 's3', 'name': 'Amazon S3 / MinIO', 'subtitle': 'Object storage bucket'},
    {'type': 'local', 'name': 'Disco Locale', 'subtitle': 'Cartella locale di sistema'},
    {'type': 'crypt', 'name': 'Crittografia E2E (Crypt)', 'subtitle': 'Crittografa file e nomi con AES-256 su qualsiasi cloud'},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialProvider != null) {
      _selectedProvider = widget.initialProvider!;
    }
    if (widget.initialTargetRemote != null) {
      _cryptTargetRemote = widget.initialTargetRemote!;
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
        break;
      case 'dropbox':
        _nameController.text = 'Dropbox';
        break;
      case 'onedrive':
        _nameController.text = 'OneDrive';
        break;
      case 'webdav':
        _nameController.text = 'Nextcloud';
        break;
      case 'sftp':
        _nameController.text = 'ServerSFTP';
        break;
      case 's3':
        _nameController.text = 'BucketS3';
        break;
      case 'local':
        _nameController.text = 'DiscoLocale';
        break;
      case 'crypt':
        _nameController.text = 'VaultCifrato';
        break;
    }
  }

  Future<void> _startOAuthFlow() async {
    final String effectiveClientId;
    final String? effectiveClientSecret;

    if (_authMethod == 'unifycloud') {
      final ucId = OAuthService.getUnifyCloudClientId(_selectedProvider);
      final ucSecret = OAuthService.getUnifyCloudClientSecret(_selectedProvider);

      if (ucId == null || ucId.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Nessun Client ID UnifyCloud disponibile per questo provider. Usa Rclone o un Client ID personale.',
            ),
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
          const SnackBar(
            content: Text(
              'Nessun Client ID di Rclone disponibile per questo provider. Usa un Client ID personale.',
            ),
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
          const SnackBar(
            content: Text(
              'Inserisci il Client ID per avviare il login OAuth2',
            ),
          ),
        );
        return;
      }
    }

    setState(() {
      _isAuthenticating = true;
      _authUrl = null;
      _browserOpened = false;
      _statusMessage = 'Avvio del server locale per l\'accesso...';
    });

    try {
      final oauth = ref.read(oauthServiceProvider);
      final tokens = await oauth.authenticate(
        providerType: _selectedProvider,
        clientId: effectiveClientId,
        clientSecret: effectiveClientSecret,
        onAuthUrlReady: (authUrl, opened) {
          if (mounted) {
            setState(() {
              _authUrl = authUrl.toString();
              _browserOpened = opened;
              if (opened) {
                _statusMessage =
                    'Browser aperto. In attesa di autorizzazione...';
              } else {
                _statusMessage =
                    'Apertura automatica non supportata. Apri o copia il link sottostante nel tuo browser:';
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
          _statusMessage = 'Autenticazione completata con successo!';
          _authUrl = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _statusMessage = 'Errore OAuth: $e';
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
        break;
      case 'webdav':
        options['url'] = _hostController.text.trim();
        options['user'] = _userController.text.trim();
        options['pass'] = _passController.text.trim();
        options['vendor'] = 'nextcloud';
        break;
      case 'sftp':
        options['host'] = _hostController.text.trim();
        options['user'] = _userController.text.trim();
        options['pass'] = _passController.text.trim();
        break;
      case 's3':
        options['endpoint'] = _hostController.text.trim();
        options['access_key_id'] = _userController.text.trim();
        options['secret_access_key'] = _passController.text.trim();
        break;
      case 'local':
        options['copy_links'] = 'true';
        break;
      case 'crypt':
        if (_cryptTargetRemote == null || _cryptTargetRemote!.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Seleziona il Cloud di destinazione per il Vault'),
            ),
          );
          return;
        }
        if (_cryptPasswordController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('La password di cifratura è obbligatoria'),
            ),
          );
          return;
        }
        if (_cryptPasswordController.text !=
            _cryptConfirmPasswordController.text) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Le password inserite non coincidono'),
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
        break;
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
          SnackBar(content: Text('Errore durante l\'aggiunta del remote: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    CosmicSvgIcon(
                      AppTheme.getProviderSvg(_selectedProvider),
                      color: AppTheme.getProviderColor(_selectedProvider),
                      size: 28,
                      fallbackMaterialIcon:
                          AppTheme.getProviderIcon(_selectedProvider),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Collega Nuovo Cloud',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const CosmicSvgIcon(
                        CosmicIcons.closeSvg,
                        fallbackMaterialIcon: Icons.close,
                      ),
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
                        const Text(
                          'Seleziona Provider:',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _availableProviders.map((p) {
                            final isSelected = p['type'] == _selectedProvider;
                            return ChoiceChip(
                              label: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CosmicSvgIcon(
                                    AppTheme.getProviderSvg(p['type']!),
                                    size: 16,
                                    color: AppTheme.getProviderColor(p['type']!),
                                    fallbackMaterialIcon:
                                        AppTheme.getProviderIcon(p['type']!),
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
                          decoration: const InputDecoration(
                            labelText: 'Nome identificativo del Cloud',
                            helperText: 'Es. GoogleDrive, LavoroDropbox (senza spazi)',
                            border: OutlineInputBorder(),
                            prefixIcon: Padding(
                              padding: EdgeInsets.all(12),
                              child: CosmicSvgIcon(
                                CosmicIcons.editSvg,
                                size: 20,
                                fallbackMaterialIcon: Icons.label_outline,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Inserisci un nome';
                            }
                            if (value.contains(' ') || value.contains(':')) {
                              return 'Non sono ammessi spazi o ":"';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        if (isOAuth) ...[
                          DropdownButtonFormField<String>(
                            initialValue: _authMethod,
                            isExpanded: true,
                            decoration: const InputDecoration(
                              labelText: 'Modalità Client ID (OAuth2)',
                              border: OutlineInputBorder(),
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(12),
                                child: CosmicSvgIcon(
                                  CosmicIcons.passwordSvg,
                                  size: 20,
                                  fallbackMaterialIcon: Icons.vpn_key_outlined,
                                ),
                              ),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'unifycloud',
                                child: Text('UnifyCloud (Ufficiale / Consigliato)'),
                              ),
                              DropdownMenuItem(
                                value: 'rclone',
                                child: Text('Rclone (Sconsigliato - Quota condivisa)'),
                              ),
                              DropdownMenuItem(
                                value: 'custom',
                                child: Text('Client ID Personale (Avanzato)'),
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
                                  const CosmicSvgIcon(
                                    CosmicIcons.checkCircleSvg,
                                    size: 20,
                                    color: Colors.blue,
                                    fallbackMaterialIcon: Icons.verified_rounded,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Credenziali Ufficiali UnifyCloud',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Accesso rapido verificato con credenziali dedicate per UnifyCloud. Clicca su "Avvia Accesso nel Browser" per autenticarti senza configurazioni manuali.',
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
                                  const CosmicSvgIcon(
                                    CosmicIcons.warningSvg,
                                    size: 20,
                                    color: Colors.amber,
                                    fallbackMaterialIcon: Icons.warning_amber_rounded,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Client ID Pubblico di Rclone (Sconsigliato)',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Usa le chiavi pubbliche storiche condivise con tutti gli utenti di Rclone. Potrebbero verificarsi rallentamenti o blocchi aziendali dovuti alle quote condivise.',
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
                                  const CosmicSvgIcon(
                                    CosmicIcons.infoSvg,
                                    size: 18,
                                    color: Colors.teal,
                                    fallbackMaterialIcon: Icons.info_outline,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Crea i tuoi ID in autonomia: consulta docs/oauth_setup_guide.md per la guida passo-passo.',
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
                                    ? 'Client ID Personale Google'
                                    : 'Client ID Personale (OAuth2)',
                                hintText: _selectedProvider == 'drive'
                                    ? 'Es. xxxxx.apps.googleusercontent.com'
                                    : null,
                                border: const OutlineInputBorder(),
                                prefixIcon: const Padding(
                                  padding: EdgeInsets.all(12),
                                  child: CosmicSvgIcon(
                                    CosmicIcons.passwordSvg,
                                    size: 20,
                                    fallbackMaterialIcon: Icons.key_outlined,
                                  ),
                                ),
                              ),
                              validator: (v) {
                                if (_authMethod == 'custom' &&
                                    (v == null || v.trim().isEmpty)) {
                                  return 'Inserisci il tuo Client ID';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _clientSecretController,
                              decoration: const InputDecoration(
                                labelText: 'Client Secret (Opzionale)',
                                border: OutlineInputBorder(),
                                prefixIcon: Padding(
                                  padding: EdgeInsets.all(12),
                                  child: CosmicSvgIcon(
                                    CosmicIcons.lockSvg,
                                    size: 20,
                                    fallbackMaterialIcon: Icons.lock_outline,
                                  ),
                                ),
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
                                : const CosmicSvgIcon(
                                    CosmicIcons.openWithSvg,
                                    size: 18,
                                    fallbackMaterialIcon: Icons.open_in_browser,
                                  ),
                            label: Text(
                              _isAuthenticating
                                  ? 'Autenticazione in corso...'
                                  : 'Avvia Accesso nel Browser (OAuth2)',
                            ),
                          ),
                          if (_statusMessage != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              _statusMessage!,
                              style: TextStyle(
                                fontSize: 12,
                                color: _statusMessage!.startsWith('Errore')
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
                                      CosmicSvgIcon(
                                        _browserOpened
                                            ? CosmicIcons.checkCircleSvg
                                            : CosmicIcons.linkSvg,
                                        size: 18,
                                        color: _browserOpened
                                            ? Colors.green
                                            : Colors.orange,
                                        fallbackMaterialIcon: _browserOpened
                                            ? Icons.check_circle_outline
                                            : Icons.link_rounded,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          _browserOpened
                                              ? 'Browser avviato (oppure copia il link qui sotto)'
                                              : 'Copia il link per completare l\'accesso nel tuo browser',
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
                                              const SnackBar(
                                                content: Text(
                                                    'Link copiato negli appunti! Incollalo nel tuo browser.'),
                                                duration: Duration(seconds: 3),
                                              ),
                                            );
                                          },
                                          icon: const CosmicSvgIcon(
                                            CosmicIcons.copySvg,
                                            size: 16,
                                            fallbackMaterialIcon: Icons.copy,
                                          ),
                                          label: const Text('Copia Link',
                                              style: TextStyle(fontSize: 12)),
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
                                        icon: const CosmicSvgIcon(
                                          CosmicIcons.openWithSvg,
                                          size: 16,
                                          fallbackMaterialIcon: Icons.open_in_browser,
                                        ),
                                        label: const Text('Riapri',
                                            style: TextStyle(fontSize: 12)),
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
                            decoration: const InputDecoration(
                              labelText: 'Token JSON (generato o incollato)',
                              hintText: '{"access_token": "..."}',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ] else if (_selectedProvider == 'webdav' ||
                            _selectedProvider == 'sftp' ||
                            _selectedProvider == 's3') ...[
                          TextFormField(
                            controller: _hostController,
                            decoration: InputDecoration(
                              labelText: _selectedProvider == 'webdav'
                                  ? 'URL WebDAV / Nextcloud'
                                  : (_selectedProvider == 's3' ? 'Endpoint S3' : 'Host / Server SFTP'),
                              border: const OutlineInputBorder(),
                              prefixIcon: const Padding(
                                padding: EdgeInsets.all(12),
                                child: CosmicSvgIcon(
                                  CosmicIcons.serverSvg,
                                  size: 20,
                                  fallbackMaterialIcon: Icons.dns_outlined,
                                ),
                              ),
                            ),
                            validator: (v) =>
                                (v == null || v.trim().isEmpty) ? 'Campo obbligatorio' : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _userController,
                            decoration: InputDecoration(
                              labelText: _selectedProvider == 's3' ? 'Access Key ID' : 'Username',
                              border: const OutlineInputBorder(),
                              prefixIcon: const Padding(
                                padding: EdgeInsets.all(12),
                                child: CosmicSvgIcon(
                                  CosmicIcons.userSvg,
                                  size: 20,
                                  fallbackMaterialIcon: Icons.person_outline,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _passController,
                            decoration: InputDecoration(
                              labelText: _selectedProvider == 's3' ? 'Secret Access Key' : 'Password',
                              border: const OutlineInputBorder(),
                              prefixIcon: const Padding(
                                padding: EdgeInsets.all(12),
                                child: CosmicSvgIcon(
                                  CosmicIcons.lockSvg,
                                  size: 20,
                                  fallbackMaterialIcon: Icons.lock_outline,
                                ),
                              ),
                            ),
                            obscureText: true,
                          ),
                        ] else if (_selectedProvider == 'local') ...[
                          const Card(
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  CosmicSvgIcon(
                                    CosmicIcons.infoSvg,
                                    color: Colors.blue,
                                    fallbackMaterialIcon: Icons.info_outline,
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'Il provider locale consente di sfogliare ed effettuare copie verso/dal filesystem del dispositivo.',
                                      style: TextStyle(fontSize: 13),
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
                            child: const Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CosmicSvgIcon(
                                  CosmicIcons.shieldSvg,
                                  color: Color(0xFF00BFA5),
                                  size: 22,
                                  fallbackMaterialIcon: Icons.shield_outlined,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Crittografia End-to-End Client-Side (AES-256)',
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'I file e i loro nomi vengono crittografati sul tuo dispositivo prima di essere inviati al cloud di destinazione. Nemmeno il provider del cloud potrà leggerli.',
                                        style: TextStyle(fontSize: 12),
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
                                  child: const Row(
                                    children: [
                                      CosmicSvgIcon(
                                        CosmicIcons.warningSvg,
                                        color: Colors.amber,
                                        fallbackMaterialIcon: Icons.warning_amber_rounded,
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          'Nessun cloud di destinazione disponibile. Collega prima un altro cloud (es. Google Drive, OneDrive, o Disco Locale) su cui creare il Vault cifrato.',
                                          style: TextStyle(fontSize: 12),
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
                                decoration: const InputDecoration(
                                  labelText: 'Cloud di destinazione *',
                                  helperText: 'Il cloud dove verranno archiviati i file cifrati',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.all(12),
                                    child: CosmicSvgIcon(
                                      CosmicIcons.cloudSvg,
                                      size: 20,
                                      fallbackMaterialIcon: Icons.cloud_outlined,
                                    ),
                                  ),
                                ),
                                items: availableRemotes.map((r) {
                                  return DropdownMenuItem<String>(
                                    value: r.name,
                                    child: Row(
                                      children: [
                                        CosmicSvgIcon(
                                          AppTheme.getProviderSvg(r.type),
                                          size: 18,
                                          color: AppTheme.getProviderColor(r.type),
                                          fallbackMaterialIcon:
                                              AppTheme.getProviderIcon(r.type),
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
                            decoration: const InputDecoration(
                              labelText: 'Percorso o Cartella di destinazione',
                              hintText: 'es. vault o secret_data',
                              helperText: 'Cartella sul cloud remoto in cui salvare i file cifrati (opzionale)',
                              border: OutlineInputBorder(),
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(12),
                                child: CosmicSvgIcon(
                                  CosmicIcons.folderSvg,
                                  size: 20,
                                  fallbackMaterialIcon: Icons.folder_outlined,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _cryptPasswordController,
                            obscureText: _obscureCryptPassword,
                            decoration: InputDecoration(
                              labelText: 'Password di Cifratura (Password Principale) *',
                              helperText: 'Conservala con cura: senza password non sarà possibile recuperare i file',
                              border: const OutlineInputBorder(),
                              prefixIcon: const Padding(
                                padding: EdgeInsets.all(12),
                                child: CosmicSvgIcon(
                                  CosmicIcons.lockSvg,
                                  size: 20,
                                  fallbackMaterialIcon: Icons.lock_rounded,
                                ),
                              ),
                              suffixIcon: IconButton(
                                icon: CosmicSvgIcon(
                                  _obscureCryptPassword
                                      ? CosmicIcons.visibilityOffSvg
                                      : CosmicIcons.visibilitySvg,
                                  size: 20,
                                  fallbackMaterialIcon: _obscureCryptPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
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
                                return 'Inserisci la password di cifratura';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _cryptConfirmPasswordController,
                            obscureText: _obscureCryptConfirmPassword,
                            decoration: InputDecoration(
                              labelText: 'Conferma Password *',
                              border: const OutlineInputBorder(),
                              prefixIcon: const Padding(
                                padding: EdgeInsets.all(12),
                                child: CosmicSvgIcon(
                                  CosmicIcons.lockSvg,
                                  size: 20,
                                  fallbackMaterialIcon: Icons.lock_outline_rounded,
                                ),
                              ),
                              suffixIcon: IconButton(
                                icon: CosmicSvgIcon(
                                  _obscureCryptConfirmPassword
                                      ? CosmicIcons.visibilityOffSvg
                                      : CosmicIcons.visibilitySvg,
                                  size: 20,
                                  fallbackMaterialIcon: _obscureCryptConfirmPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
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
                                  return 'Conferma la password';
                                }
                                if (v != _cryptPasswordController.text) {
                                  return 'Le password non coincidono';
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
                              labelText: 'Salt / Password Secondaria (Opzionale)',
                              helperText: 'Aggiunge ulteriore sicurezza contro attacchi brute-force',
                              border: const OutlineInputBorder(),
                              prefixIcon: const Padding(
                                padding: EdgeInsets.all(12),
                                child: CosmicSvgIcon(
                                  CosmicIcons.passwordSvg,
                                  size: 20,
                                  fallbackMaterialIcon: Icons.key_outlined,
                                ),
                              ),
                              suffixIcon: IconButton(
                                icon: CosmicSvgIcon(
                                  _obscureCryptSalt
                                      ? CosmicIcons.visibilityOffSvg
                                      : CosmicIcons.visibilitySvg,
                                  size: 20,
                                  fallbackMaterialIcon: _obscureCryptSalt
                                      ? Icons.visibility_off
                                      : Icons.visibility,
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
                            decoration: const InputDecoration(
                              labelText: 'Cifratura dei Nomi File',
                              border: OutlineInputBorder(),
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(12),
                                child: CosmicSvgIcon(
                                  CosmicIcons.editSvg,
                                  size: 20,
                                  fallbackMaterialIcon: Icons.drive_file_rename_outline,
                                ),
                              ),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'standard',
                                child: Text('Standard (Nomi file completamente cifrati - Consigliato)'),
                              ),
                              DropdownMenuItem(
                                value: 'obfuscate',
                                child: Text('Offuscamento semplice (Conserva le estensioni)'),
                              ),
                              DropdownMenuItem(
                                value: 'off',
                                child: Text('Disattivata (Nomi visibili in chiaro)'),
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
                            title: const Text('Cifra anche i nomi delle cartelle'),
                            subtitle: const Text('Nasconde completamente la struttura delle directory sul cloud'),
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
                      child: const Text('Annulla'),
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
                          : const Text('Connetti Cloud'),
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
