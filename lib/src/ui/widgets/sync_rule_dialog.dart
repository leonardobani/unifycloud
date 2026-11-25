import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/sync_rule_model.dart';
import '../../providers/cloud_accounts_provider.dart';
import '../../providers/sync_provider.dart';

/// Dialog allowing users to create or edit an automated or manual sync rule.
class SyncRuleDialog extends ConsumerStatefulWidget {
  final SyncRule? existingRule;

  const SyncRuleDialog({
    super.key,
    this.existingRule,
  });

  @override
  ConsumerState<SyncRuleDialog> createState() => _SyncRuleDialogState();
}

class _SyncRuleDialogState extends ConsumerState<SyncRuleDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _localPathController;
  late final TextEditingController _remotePathController;

  String? _selectedRemote;
  SyncMode _selectedMode = SyncMode.copy;
  SyncFrequency _selectedFrequency = SyncFrequency.hourly;
  bool _isEnabled = true;

  @override
  void initState() {
    super.initState();
    final rule = widget.existingRule;
    _nameController = TextEditingController(text: rule?.name ?? '');
    _localPathController = TextEditingController(text: rule?.localPath ?? '');
    _remotePathController =
        TextEditingController(text: rule?.remotePath ?? 'Backup');

    if (rule != null) {
      _selectedRemote = rule.remote;
      _selectedMode = rule.mode;
      _selectedFrequency = rule.frequency;
      _isEnabled = rule.isEnabled;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _localPathController.dispose();
    _remotePathController.dispose();
    super.dispose();
  }

  Future<void> _pickLocalDirectory() async {
    final selected = await FilePicker.getDirectoryPath();
    if (selected != null && selected.isNotEmpty) {
      setState(() {
        _localPathController.text = selected;
        if (_nameController.text.trim().isEmpty) {
          final dirName = selected.split(Platform.pathSeparator).lastWhere(
                (p) => p.isNotEmpty,
                orElse: () => 'Cartella',
              );
          _nameController.text = 'Backup $dirName';
          _remotePathController.text = 'Backup/$dirName';
        }
      });
    }
  }

  void _applyLocalPreset(String path, String label) {
    setState(() {
      _localPathController.text = path;
      if (_nameController.text.trim().isEmpty) {
        _nameController.text = 'Backup $label';
        _remotePathController.text = 'Backup/$label';
      }
    });
  }

  List<Map<String, String>> _getSystemPresets() {
    final home = Platform.environment['HOME'] ?? '';
    final presets = <Map<String, String>>[];

    if (Platform.isAndroid) {
      presets.add({'label': 'Foto (DCIM)', 'path': '/storage/emulated/0/DCIM'});
      presets.add({
        'label': 'Documenti',
        'path': '/storage/emulated/0/Documents',
      });
      presets.add({'label': 'Download', 'path': '/storage/emulated/0/Download'});
    } else {
      if (home.isNotEmpty) {
        presets.add({'label': 'Immagini', 'path': '$home/Pictures'});
        presets.add({'label': 'Documenti', 'path': '$home/Documents'});
        presets.add({'label': 'Download', 'path': '$home/Downloads'});
      }
    }
    return presets;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim().isEmpty
        ? 'Sincronizzazione ${_localPathController.text.split(Platform.pathSeparator).last}'
        : _nameController.text.trim();

    final rule = SyncRule(
      id: widget.existingRule?.id ??
          'rule_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      localPath: _localPathController.text.trim(),
      remote: _selectedRemote!,
      remotePath: _remotePathController.text.trim(),
      mode: _selectedMode,
      frequency: _selectedFrequency,
      isEnabled: _isEnabled,
      lastSyncTime: widget.existingRule?.lastSyncTime,
      lastStatus: widget.existingRule?.lastStatus ?? SyncStatus.idle,
      lastError: widget.existingRule?.lastError,
      activeJobId: widget.existingRule?.activeJobId,
    );

    if (widget.existingRule != null) {
      await ref.read(syncProvider.notifier).updateRule(rule);
    } else {
      await ref.read(syncProvider.notifier).addRule(rule);
    }

    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cloudState = ref.watch(cloudAccountsProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isEditing = widget.existingRule != null;
    final presets = _getSystemPresets();

    // Select initial remote if null and remotes exist
    if (_selectedRemote == null && cloudState.remotes.isNotEmpty) {
      _selectedRemote = cloudState.remotes.first.name;
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 580, maxHeight: 720),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: theme.colorScheme.primaryContainer,
                      child: Icon(
                        isEditing ? Icons.edit_calendar : Icons.sync_alt,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isEditing
                                ? 'Modifica Regola di Backup'
                                : 'Nuova Regola di Sincronizzazione',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Configura backup automatico tra una cartella locale e il cloud.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isDark ? Colors.grey[400] : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const Divider(height: 24),

                // Scrollable Form Fields
                Expanded(
                  child: ListView(
                    children: [
                      // Nome Regola
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Nome Regola (opzionale)',
                          hintText: 'Es. Backup Foto DCIM o Documenti Lavoro',
                          prefixIcon: Icon(Icons.bookmark_border),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Cartella Locale
                      TextFormField(
                        controller: _localPathController,
                        decoration: InputDecoration(
                          labelText: 'Cartella Locale Sorgente',
                          hintText: '/home/utente/Pictures o /storage/emulated/0/DCIM',
                          prefixIcon: const Icon(Icons.folder),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.folder_open),
                            tooltip: 'Sfoglia cartelle',
                            onPressed: _pickLocalDirectory,
                          ),
                          border: const OutlineInputBorder(),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Inserisci o seleziona una cartella locale';
                          }
                          return null;
                        },
                      ),
                      if (presets.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: presets.map((p) {
                            return ActionChip(
                              avatar: const Icon(Icons.add, size: 14),
                              label: Text(p['label']!, style: const TextStyle(fontSize: 12)),
                              onPressed: () => _applyLocalPreset(p['path']!, p['label']!),
                            );
                          }).toList(),
                        ),
                      ],
                      const SizedBox(height: 16),

                      // Cloud Remote
                      if (cloudState.remotes.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.errorContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.warning_amber,
                                  color: theme.colorScheme.error),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Nessun cloud configurato. Configura un account cloud dalla Home prima di continuare.',
                                  style: TextStyle(
                                    color: theme.colorScheme.onErrorContainer,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        DropdownButtonFormField<String>(
                          initialValue: _selectedRemote,
                          decoration: const InputDecoration(
                            labelText: 'Cloud di Destinazione',
                            prefixIcon: Icon(Icons.cloud_queue),
                            border: OutlineInputBorder(),
                          ),
                          items: cloudState.remotes.map((remote) {
                            return DropdownMenuItem<String>(
                              value: remote.name,
                              child: Row(
                                children: [
                                  Icon(_getProviderIcon(remote.type), size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    remote.name,
                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '(${remote.type})',
                                    style: TextStyle(
                                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() => _selectedRemote = val);
                          },
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Seleziona un cloud di destinazione';
                            }
                            return null;
                          },
                        ),
                      const SizedBox(height: 16),

                      // Percorso Cartella Cloud
                      TextFormField(
                        controller: _remotePathController,
                        decoration: const InputDecoration(
                          labelText: 'Cartella di Destinazione sul Cloud',
                          hintText: 'Backup/Foto o /',
                          prefixIcon: Icon(Icons.cloud_upload_outlined),
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Inserisci un percorso di destinazione';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 18),

                      // Modalità (SegmentedButton)
                      Text(
                        'Modalità Operativa',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      SegmentedButton<SyncMode>(
                        segments: const [
                          ButtonSegment<SyncMode>(
                            value: SyncMode.copy,
                            label: Text('Backup Incrementale'),
                            icon: Icon(Icons.backup_outlined),
                          ),
                          ButtonSegment<SyncMode>(
                            value: SyncMode.sync,
                            label: Text('Sincronizzazione Mirror'),
                            icon: Icon(Icons.sync),
                          ),
                        ],
                        selected: {_selectedMode},
                        onSelectionChanged: (set) {
                          setState(() => _selectedMode = set.first);
                        },
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _selectedMode.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Frequenza
                      DropdownButtonFormField<SyncFrequency>(
                        initialValue: _selectedFrequency,
                        decoration: const InputDecoration(
                          labelText: 'Frequenza Pianificata',
                          prefixIcon: Icon(Icons.schedule),
                          border: OutlineInputBorder(),
                        ),
                        items: SyncFrequency.values.map((freq) {
                          return DropdownMenuItem<SyncFrequency>(
                            value: freq,
                            child: Text(freq.label),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedFrequency = val);
                          }
                        },
                      ),
                      const SizedBox(height: 12),

                      // Switch Abilita
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Attiva regola immediatamente'),
                        subtitle: const Text(
                          'Se disattivata, la regola potrà essere avviata solo manualmente.',
                          style: TextStyle(fontSize: 12),
                        ),
                        value: _isEnabled,
                        onChanged: (v) => setState(() => _isEnabled = v),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Annulla'),
                    ),
                    const SizedBox(width: 8),
                    FilledButton.icon(
                      icon: const Icon(Icons.check),
                      label: Text(isEditing ? 'Aggiorna' : 'Salva Regola'),
                      onPressed: cloudState.remotes.isEmpty ? null : _save,
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

  IconData _getProviderIcon(String type) {
    switch (type.toLowerCase()) {
      case 'drive':
        return Icons.add_to_drive;
      case 'onedrive':
        return Icons.cloud;
      case 'dropbox':
        return Icons.inventory_2;
      case 's3':
        return Icons.storage;
      case 'sftp':
        return Icons.terminal;
      case 'webdav':
        return Icons.dns;
      default:
        return Icons.cloud_queue;
    }
  }
}
