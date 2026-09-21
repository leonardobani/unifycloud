import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/cloud_accounts_provider.dart';
import '../../services/oauth_service.dart';
import '../../utils/token_utils.dart';
import '../theme/app_theme.dart';

/// Modal dialog allowing users to configure and connect a new cloud storage provider.
class AddCloudDialog extends ConsumerStatefulWidget {
  const AddCloudDialog({super.key});

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
  ];

  @override
  void initState() {
    super.initState();
    _nameController.text = 'GoogleDrive';
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
    super.dispose();
  }

  void _onProviderChanged(String type) {
    setState(() {
      _selectedProvider = type;
      _discoveredDriveId = null;
      _discoveredDriveType = null;
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
      }
    });
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
                    Icon(
                      AppTheme.getProviderIcon(_selectedProvider),
                      color: AppTheme.getProviderColor(_selectedProvider),
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Collega Nuovo Cloud',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                                  Icon(
                                    AppTheme.getProviderIcon(p['type']!),
                                    size: 16,
                                    color: AppTheme.getProviderColor(p['type']!),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(p['name']!),
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
                            prefixIcon: Icon(Icons.label_outline),
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
                              prefixIcon: Icon(Icons.vpn_key_outlined),
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
                                  const Icon(Icons.info_outline, size: 18, color: Colors.teal),
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
                                prefixIcon: const Icon(Icons.key_outlined),
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
                                prefixIcon: Icon(Icons.lock_outline),
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
                                          icon:
                                              const Icon(Icons.copy, size: 16),
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
                                        icon: const Icon(Icons.open_in_browser,
                                            size: 16),
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
                              prefixIcon: const Icon(Icons.dns_outlined),
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
                              prefixIcon: const Icon(Icons.person_outline),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _passController,
                            decoration: InputDecoration(
                              labelText: _selectedProvider == 's3' ? 'Secret Access Key' : 'Password',
                              border: const OutlineInputBorder(),
                              prefixIcon: const Icon(Icons.lock_outline),
                            ),
                            obscureText: true,
                          ),
                        ] else if (_selectedProvider == 'local') ...[
                          const Card(
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  Icon(Icons.info_outline, color: Colors.blue),
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
