import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/settings_models.dart';
import '../../providers/cloud_accounts_provider.dart';
import '../../providers/settings_provider.dart';
import '../../services/secure_config_service.dart';
import '../../utils/url_utils.dart';

/// Comprehensive settings, appearance, and developer support screen for UnifyCloud.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const String gitlabRepoUrl = 'https://gitlab.com/leorise25/unifycloud';
  static const String kofiUrl = 'https://ko-fi.com/leorise';
  static const String liberapayUrl = 'https://liberapay.com/LeoRise25/';
  static const String paypalUrl = 'https://paypal.me/leorise';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Impostazioni'),
        actions: [
          IconButton(
            icon: const Icon(Icons.restore_outlined),
            tooltip: 'Ripristina Impostazioni Predefinite',
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Ripristina Impostazioni'),
                  content: const Text(
                    'Vuoi ripristinare tutte le preferenze (tema, cartelle, visualizzazione) ai valori di fabbrica?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: const Text('Annulla'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.of(ctx).pop(true),
                      child: const Text('Ripristina'),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await settingsNotifier.resetToDefaults();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Impostazioni ripristinate ai valori predefiniti'),
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          // Section 1: Aspetto & Tema
          _buildThemeCard(context, settings, settingsNotifier),
          const SizedBox(height: 16),

          // Section 2: File & Esplorazione
          _buildFilesCard(context, settings, settingsNotifier),
          const SizedBox(height: 16),

          // Section 3: Sviluppo & Open Source (GitLab & Donazioni)
          _buildCommunityAndSupportCard(context),
          const SizedBox(height: 16),

          // Section 4: Sicurezza & Storage Cifrato
          _buildSecurityCard(context, ref),
          const SizedBox(height: 16),

          // Section 5: Informazioni sull'Applicazione
          _buildAboutCard(context),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  /// Theme and appearance selection card.
  Widget _buildThemeCard(
    BuildContext context,
    AppSettings settings,
    SettingsNotifier notifier,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.palette_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Aspetto & Tema',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Scegli il tema visivo per l\'interfaccia di UnifyCloud:',
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                return SizedBox(
                  width: double.infinity,
                  child: SegmentedButton<ThemeMode>(
                    segments: const [
                      ButtonSegment<ThemeMode>(
                        value: ThemeMode.system,
                        icon: Icon(Icons.brightness_auto_outlined),
                        label: Text('Sistema'),
                      ),
                      ButtonSegment<ThemeMode>(
                        value: ThemeMode.light,
                        icon: Icon(Icons.light_mode_outlined),
                        label: Text('Chiaro'),
                      ),
                      ButtonSegment<ThemeMode>(
                        value: ThemeMode.dark,
                        icon: Icon(Icons.dark_mode_outlined),
                        label: Text('Scuro'),
                      ),
                    ],
                    selected: {settings.themeMode},
                    onSelectionChanged: (newSelection) {
                      if (newSelection.isNotEmpty) {
                        notifier.setThemeMode(newSelection.first);
                      }
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// File explorer preferences and download directory card.
  Widget _buildFilesCard(
    BuildContext context,
    AppSettings settings,
    SettingsNotifier notifier,
  ) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Icon(
                  Icons.folder_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                const Text(
                  'File & Esplorazione',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SwitchListTile(
            title: const Text('Mostra elementi nascosti'),
            subtitle: const Text('Visualizza file e cartelle con punto iniziale (".")'),
            secondary: const Icon(Icons.visibility_outlined),
            value: settings.showHiddenFiles,
            onChanged: (val) => notifier.setShowHiddenFiles(val),
          ),
          const Divider(height: 1),
          SwitchListTile(
            title: const Text('Conferma prima di eliminare'),
            subtitle: const Text('Richiedi conferma prima di rimuovere file o cartelle'),
            secondary: const Icon(Icons.delete_sweep_outlined),
            value: settings.confirmDelete,
            onChanged: (val) => notifier.setConfirmDelete(val),
          ),
          const Divider(height: 1),
          SwitchListTile(
            title: const Text('Doppio Pannello su Desktop e Tablet'),
            subtitle: const Text('Visualizza due cloud affiancati (Commander View) su schermi larghi'),
            secondary: const Icon(Icons.splitscreen),
            value: settings.dualPaneEnabled,
            onChanged: (val) => notifier.setDualPaneEnabled(val),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.downloading_outlined),
            title: const Text('Cartella Download Predefinita'),
            subtitle: Text(
              settings.customDownloadPath != null &&
                      settings.customDownloadPath!.isNotEmpty
                  ? settings.customDownloadPath!
                  : 'Cartella Download predefinita del sistema',
              style: TextStyle(
                color: settings.customDownloadPath != null
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
            onTap: () => _showCustomDownloadFolderDialog(
              context,
              settings,
              notifier,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (settings.customDownloadPath != null)
                  IconButton(
                    icon: const Icon(Icons.restore, size: 20),
                    tooltip: 'Ripristina percorso di sistema',
                    onPressed: () => notifier.setCustomDownloadPath(null),
                  ),
                FilledButton.tonalIcon(
                  icon: const Icon(Icons.edit_outlined, size: 16),
                  label: const Text('Cambia'),
                  onPressed: () => _showCustomDownloadFolderDialog(
                    context,
                    settings,
                    notifier,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Dialog allowing user to select or manually enter a custom download folder.
  Future<void> _showCustomDownloadFolderDialog(
    BuildContext context,
    AppSettings settings,
    SettingsNotifier notifier,
  ) async {
    final controller =
        TextEditingController(text: settings.customDownloadPath ?? '');
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.folder_outlined),
            SizedBox(width: 10),
            Text('Cartella Download'),
          ],
        ),
        content: SizedBox(
          width: 480,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Seleziona una cartella tramite il selettore del sistema oppure inserisci manualmente il percorso desiderato:',
                style: TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        labelText: 'Percorso cartella',
                        hintText: 'es. /home/utente/Scaricati',
                        border: OutlineInputBorder(),
                        isDense: true,
                        prefixIcon: Icon(Icons.folder_open, size: 20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filledTonal(
                    icon: const Icon(Icons.search),
                    tooltip: 'Sfoglia con selettore di sistema',
                    onPressed: () async {
                      try {
                        final selectedPath =
                            await FilePicker.getDirectoryPath();
                        if (selectedPath != null && selectedPath.isNotEmpty) {
                          controller.text = selectedPath;
                        }
                      } catch (e) {
                        if (ctx.mounted) {
                          ScaffoldMessenger.of(ctx).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Impossibile aprire il selettore di sistema: $e',
                              ),
                            ),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          if (settings.customDownloadPath != null)
            TextButton(
              onPressed: () {
                notifier.setCustomDownloadPath(null);
                Navigator.of(ctx).pop();
              },
              child: const Text('Ripristina predefinito'),
            ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Annulla'),
          ),
          FilledButton(
            onPressed: () {
              final text = controller.text.trim();
              notifier.setCustomDownloadPath(text.isEmpty ? null : text);
              Navigator.of(ctx).pop();
            },
            child: const Text('Salva'),
          ),
        ],
      ),
    );
  }

  /// Developer support and GitLab repository card.
  Widget _buildCommunityAndSupportCard(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
          width: 1.2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.favorite_rounded,
                  color: Colors.pinkAccent,
                  size: 24,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Community & Sviluppo',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.pinkAccent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Open Source',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.pinkAccent,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'UnifyCloud è un software libero e indipendente creato per unificare i tuoi dati cloud senza tracker o intermediari proprietari.',
              style: TextStyle(fontSize: 13, height: 1.4),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 10,
              children: [
                // Pulsante Sostieni lo Sviluppatore
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.pink.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  icon: const Icon(Icons.coffee_rounded, size: 20),
                  label: const Text('Sostieni lo Sviluppatore'),
                  onPressed: () => _showSupportDialog(context),
                ),

                // Pulsante Vedi Codice su GitLab
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  icon: const Icon(Icons.code_rounded, size: 20),
                  label: const Text('Vedi Codice su GitLab'),
                  onPressed: () async {
                    final success = await UrlUtils.openWebUrl(
                      Uri.parse(gitlabRepoUrl),
                    );
                    if (!success && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Impossibile aprire il browser. Repository: $gitlabRepoUrl',
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Interactive dialog with support and donation links.
  void _showSupportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.favorite, color: Colors.pinkAccent),
            SizedBox(width: 10),
            Text('Sostieni UnifyCloud'),
          ],
        ),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'UnifyCloud è un progetto gratuito e open-source nato per darti il pieno controllo sui tuoi file nei vari cloud.',
                style: TextStyle(fontSize: 14, height: 1.4),
              ),
              const SizedBox(height: 12),
              Text(
                'Se trovi utile l\'applicazione nel tuo lavoro o nella tua vita quotidiana, puoi offrire un caffè o fare una donazione per sostenere lo sviluppo continuo, l\'integrazione di nuovi provider e la manutenzione!',
                style: TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  color: Theme.of(ctx).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),
              _buildDonationTile(
                context: ctx,
                icon: Icons.coffee,
                color: Colors.orange,
                title: 'Offri un caffè su Ko-fi',
                subtitle: 'ko-fi.com/leorise',
                url: kofiUrl,
              ),
              const SizedBox(height: 8),
              _buildDonationTile(
                context: ctx,
                icon: Icons.volunteer_activism_outlined,
                color: Colors.amber.shade800,
                title: 'Dona su Liberapay',
                subtitle: 'liberapay.com/LeoRise25',
                url: liberapayUrl,
              ),
              const SizedBox(height: 8),
              _buildDonationTile(
                context: ctx,
                icon: Icons.payment,
                color: Colors.blue,
                title: 'Donazione via PayPal',
                subtitle: 'paypal.me/leorise',
                url: paypalUrl,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Chiudi'),
          ),
        ],
      ),
    );
  }

  Widget _buildDonationTile({
    required BuildContext context,
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required String url,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () async {
        Navigator.of(context).pop();
        await UrlUtils.openWebUrl(Uri.parse(url));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.open_in_new, size: 16, color: color),
          ],
        ),
      ),
    );
  }

  /// Security and encrypted storage management card.
  Widget _buildSecurityCard(BuildContext context, WidgetRef ref) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Icon(Icons.security, color: Colors.green),
                SizedBox(width: 12),
                Text(
                  'Sicurezza & Cifratura',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              'UnifyCloud adotta un\'architettura Zero-Plaintext. '
              'Tutti i token OAuth e le credenziali di accesso sono protetti '
              'nel Keychain/Keystore di sistema e iniettati esclusivamente '
              'nella memoria RAM del motore Go.',
              style: TextStyle(fontSize: 13, height: 1.4),
            ),
          ),
          const Divider(height: 16),
          ListTile(
            leading: const Icon(Icons.sync_outlined),
            title: const Text('Sincronizza Account Cloud'),
            subtitle: const Text('Ricarica le configurazioni dalla memoria protetta'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ref.read(cloudAccountsProvider.notifier).loadRemotes();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Account cloud ricaricati con successo')),
              );
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.delete_forever_outlined, color: Colors.red),
            title: const Text(
              'Cancella Tutte le Credenziali',
              style: TextStyle(color: Colors.red),
            ),
            subtitle: const Text(
              'Rimuove la configurazione cifrata e disconnette tutti i cloud',
            ),
            onTap: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Attenzione: Reset Credenziali'),
                  content: const Text(
                    'Sei sicuro di voler eliminare tutte le credenziali salvate? Dovrai riconnettere i tuoi account cloud.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: const Text('Annulla'),
                    ),
                    FilledButton(
                      style: FilledButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () => Navigator.of(ctx).pop(true),
                      child: const Text('Elimina Tutto'),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await ref.read(secureConfigServiceProvider).clearConfig();
                await ref.read(cloudAccountsProvider.notifier).loadRemotes();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Credenziali eliminate con successo'),
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }

  /// App and technology information card.
  Widget _buildAboutCard(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue),
                SizedBox(width: 12),
                Text(
                  'Informazioni su UnifyCloud',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text('Versione App: 0.1.0 (Beta)'),
            SizedBox(height: 4),
            Text('Sviluppatore: LeoRise (@leorise25)'),
            SizedBox(height: 4),
            Text('Motore: Rclone Core CGO (Go v1.22+ / C FFI)'),
            SizedBox(height: 4),
            Text('Framework: Flutter (Material 3 Responsive)'),
            SizedBox(height: 4),
            Text('Licenza: GNU General Public License v3.0 (GPL-3.0)'),
            SizedBox(height: 4),
            Text('Copyright: © 2026 Leonardo Bani'),
          ],
        ),
      ),
    );
  }
}
