import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/cloud_accounts_provider.dart';
import '../../services/secure_config_service.dart';

/// Settings and security screen for UnifyCloud.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Impostazioni'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Security Card
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.security, color: Colors.green),
                      SizedBox(width: 12),
                      Text(
                        'Sicurezza & Cifratura',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    'UnifyCloud utilizza un\'architettura Zero-Plaintext. '
                    'Tutti i token e le credenziali di accesso sono protetti '
                    'tramite il Keychain/Keystore di sistema e iniettati esclusivamente '
                    'nella memoria RAM del motore Go.',
                    style: TextStyle(fontSize: 13, height: 1.4),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Cloud Account Actions
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.sync_outlined),
                  title: const Text('Sincronizza Account Cloud'),
                  subtitle: const Text('Ricarica le configurazioni dalla memoria protetta'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ref.read(cloudAccountsProvider.notifier).loadRemotes();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Account cloud ricaricati')),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.delete_forever_outlined, color: Colors.red),
                  title: const Text('Cancella Tutte le Credenziali', style: TextStyle(color: Colors.red)),
                  subtitle: const Text('Rimuove la configurazione cifrata e disconnette tutti i cloud'),
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
                          const SnackBar(content: Text('Credenziali eliminate con successo')),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // About Card
          const Card(
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
                  Text('Motore: Rclone Core CGO (Go v1.22+ / C FFI)'),
                  SizedBox(height: 4),
                  Text('Framework: Flutter (Material 3 Responsive)'),
                  SizedBox(height: 4),
                  Text('Licenza: Open Source (FOSS)'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
