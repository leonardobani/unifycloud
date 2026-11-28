import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../l10n/l10n_extension.dart';
import '../../models/sync_rule_model.dart';
import '../../providers/cloud_accounts_provider.dart';
import '../../providers/sync_provider.dart';
import '../../services/storage_permission_service.dart';
import '../theme/app_theme.dart';

/// Dialog allowing users to create or edit an automated or manual sync rule.
class SyncRuleDialog extends ConsumerStatefulWidget {

  const SyncRuleDialog({
    super.key,
    this.existingRule,
  });
  final SyncRule? existingRule;

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

  Future<void> _pickLocalDirectory(AppLocalizations l10n) async {
    // Directory() and rclone require a filesystem path rather than an Android SAF content:// URI.
    // ignore: deprecated_member_use
    final selected = await FilePicker.getDirectoryPath();
    if (selected != null && selected.isNotEmpty) {
      setState(() {
        _localPathController.text = selected;
        if (_nameController.text.trim().isEmpty) {
          final dirName = selected.split(Platform.pathSeparator).lastWhere(
                (p) => p.isNotEmpty,
                orElse: () => l10n.folderFallbackName,
              );
          _nameController.text = l10n.defaultBackupRuleName(dirName);
          _remotePathController.text = 'Backup/$dirName';
        }
      });
    }
  }

  void _applyLocalPreset(String path, String label, AppLocalizations l10n) {
    setState(() {
      _localPathController.text = path;
      if (_nameController.text.trim().isEmpty) {
        _nameController.text = l10n.defaultBackupRuleName(label);
        _remotePathController.text = 'Backup/$label';
      }
    });
  }

  List<Map<String, String>> _getSystemPresets(AppLocalizations l10n) {
    final home = Platform.environment['HOME'] ?? '';
    final presets = <Map<String, String>>[];

    if (Platform.isAndroid) {
      presets.add({'label': l10n.presetPhotosDcim, 'path': '/storage/emulated/0/DCIM'});
      presets.add({
        'label': l10n.presetDocuments,
        'path': '/storage/emulated/0/Documents',
      });
      presets.add({'label': l10n.presetDownloads, 'path': '/storage/emulated/0/Download'});
    } else {
      if (home.isNotEmpty) {
        presets.add({'label': l10n.presetPictures, 'path': '$home/Pictures'});
        presets.add({'label': l10n.presetDocuments, 'path': '$home/Documents'});
        presets.add({'label': l10n.presetDownloads, 'path': '$home/Downloads'});
      }
    }
    return presets;
  }

  Future<void> _save(AppLocalizations l10n) async {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim().isEmpty
        ? l10n.defaultSyncRuleName(
            _localPathController.text.split(Platform.pathSeparator).last,
          )
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
    final l10n = context.l10n;
    final cloudState = ref.watch(cloudAccountsProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isEditing = widget.existingRule != null;
    final presets = _getSystemPresets(l10n);
    final hasStorageAccess = ref.watch(storageAccessProvider);

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
                                ? l10n.editRuleTitle
                                : l10n.newRuleTitle,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            l10n.ruleDialogSubtitle,
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
                      if (!hasStorageAccess) ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.amber.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.amber.withValues(alpha: 0.4),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.folder_off_outlined, color: Colors.amber),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l10n.androidStoragePermissionTitle,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      l10n.androidStoragePermissionDesc,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              FilledButton(
                                onPressed: () => ref
                                    .read(storageAccessProvider.notifier)
                                    .requestAccess(),
                                child: Text(l10n.grantPermission),
                              ),
                            ],
                          ),
                        ),
                      ],
                      // Rule Name
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: l10n.ruleNameOptional,
                          hintText: l10n.ruleNameHint,
                          prefixIcon: const Icon(Icons.bookmark_border),
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Local Folder
                      TextFormField(
                        controller: _localPathController,
                        decoration: InputDecoration(
                          labelText: l10n.sourceLocalFolder,
                          hintText: l10n.sourceLocalFolderHint,
                          prefixIcon: const Icon(Icons.folder),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.folder_open),
                            tooltip: l10n.browseFolders,
                            onPressed: () => _pickLocalDirectory(l10n),
                          ),
                          border: const OutlineInputBorder(),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return l10n.selectLocalFolderError;
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
                              onPressed: () =>
                                  _applyLocalPreset(p['path']!, p['label']!, l10n),
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
                                  l10n.noCloudsConfiguredSync,
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
                          decoration: InputDecoration(
                            labelText: l10n.destinationCloud,
                            prefixIcon: const Icon(Icons.cloud_queue),
                            border: const OutlineInputBorder(),
                          ),
                          items: cloudState.remotes.map((remote) {
                            return DropdownMenuItem<String>(
                              value: remote.name,
                              child: Row(
                                children: [
                                  Icon(
                                    AppTheme.getProviderIcon(remote.type),
                                    size: 20,
                                    color: AppTheme.getProviderColor(remote.type),
                                  ),
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
                              return l10n.selectDestinationCloudError;
                            }
                            return null;
                          },
                        ),
                      const SizedBox(height: 16),

                      // Cloud Destination Folder Path
                      TextFormField(
                        controller: _remotePathController,
                        decoration: InputDecoration(
                          labelText: l10n.remoteDestinationPath,
                          hintText: l10n.remoteDestinationPathHint,
                          prefixIcon: const Icon(Icons.cloud_upload_outlined),
                          border: const OutlineInputBorder(),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return l10n.enterDestinationPathError;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 18),

                      // Mode (SegmentedButton)
                      Text(
                        l10n.syncMode,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      SegmentedButton<SyncMode>(
                        segments: [
                          ButtonSegment<SyncMode>(
                            value: SyncMode.copy,
                            label: Text(l10n.syncModeCopy),
                            icon: const Icon(Icons.backup_outlined),
                          ),
                          ButtonSegment<SyncMode>(
                            value: SyncMode.sync,
                            label: Text(l10n.syncModeSync),
                            icon: const Icon(Icons.sync),
                          ),
                        ],
                        selected: {_selectedMode},
                        onSelectionChanged: (set) {
                          setState(() => _selectedMode = set.first);
                        },
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _selectedMode.localizedDescription(l10n),
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Frequency
                      DropdownButtonFormField<SyncFrequency>(
                        initialValue: _selectedFrequency,
                        decoration: InputDecoration(
                          labelText: l10n.syncFrequency,
                          prefixIcon: const Icon(Icons.schedule),
                          border: const OutlineInputBorder(),
                        ),
                        items: SyncFrequency.values.map((freq) {
                          return DropdownMenuItem<SyncFrequency>(
                            value: freq,
                            child: Text(freq.localizedLabel(l10n)),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedFrequency = val);
                          }
                        },
                      ),
                      const SizedBox(height: 12),

                      // Enable Switch
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(l10n.activateRuleImmediately),
                        subtitle: Text(
                          l10n.activateRuleManualOnlyDesc,
                          style: const TextStyle(fontSize: 12),
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
                      child: Text(l10n.cancel),
                    ),
                    const SizedBox(width: 8),
                    FilledButton.icon(
                      icon: const Icon(Icons.check),
                      label: Text(isEditing ? l10n.updateRule : l10n.saveRule),
                      onPressed:
                          cloudState.remotes.isEmpty ? null : () => _save(l10n),
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
