import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../models/settings_models.dart';
import '../../providers/app_lock_provider.dart';
import '../../providers/cloud_accounts_provider.dart';
import '../../providers/settings_provider.dart';
import '../../services/app_lock_service.dart';
import '../../services/secure_config_service.dart';
import '../../utils/url_utils.dart';
import '../theme/app_theme.dart';
import '../theme/cosmic_icons.dart';
import '../widgets/pin_setup_dialog.dart';

/// Comprehensive settings, appearance, and developer support screen for UnifyCloud.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const String gitlabRepoUrl = 'https://gitlab.com/leorise25/unifycloud';
  static const String kofiUrl = 'https://ko-fi.com/leorise';
  static const String liberapayUrl = 'https://liberapay.com/LeoRise25/';
  static const String paypalUrl = 'https://paypal.me/leorise';

  /// Returns a human-friendly display label for any language code or 'system'.
  static String getLanguageDisplayName(String code, AppLocalizations l10n) {
    switch (code) {
      case 'en':
        return l10n.langEnglish;
      case 'it':
        return l10n.langItalian;
      case 'system':
        return l10n.langSystem;
      case 'de':
        return 'Deutsch';
      case 'es':
        return 'Español';
      case 'fr':
        return 'Français';
      case 'pt':
        return 'Português';
      case 'ru':
        return 'Русский';
      case 'zh':
        return '中文';
      case 'ja':
        return '日本語';
      case 'ko':
        return '한국어';
      case 'ar':
        return 'العربية';
      case 'hi':
        return 'हिन्दी';
      case 'nl':
        return 'Nederlands';
      case 'pl':
        return 'Polski';
      case 'tr':
        return 'Türkçe';
      default:
        return code.toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
        actions: [
          IconButton(
            icon: const CosmicSvgIcon(CosmicIcons.refreshSvg, size: 20),
            tooltip: l10n.resetDefaultsTooltip,
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(l10n.resetDialogTitle),
                  content: Text(l10n.resetDialogContent),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: Text(l10n.cancel),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.of(ctx).pop(true),
                      child: Text(l10n.reset),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await settingsNotifier.resetToDefaults();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.resetSuccessSnackbar),
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

          // Section 1: Aspetto & Tema & Lingua
          _buildThemeCard(context, settings, settingsNotifier, l10n),
          const SizedBox(height: 16),

          // Section 2: File & Esplorazione
          _buildFilesCard(context, settings, settingsNotifier, l10n),
          const SizedBox(height: 16),

          // Section 3: Desktop & Sistema (Avvio automatico & System Tray)
          if (!kIsWeb && (Platform.isLinux || Platform.isWindows || Platform.isMacOS)) ...[
            _buildDesktopCard(context, settings, settingsNotifier, l10n),
            const SizedBox(height: 16),
          ],

          // Section 4: Sviluppo & Open Source (GitLab & Donazioni)
          _buildCommunityAndSupportCard(context, l10n),
          const SizedBox(height: 16),

          // Section 4: Sicurezza & Storage Cifrato
          _buildSecurityCard(context, ref, settings, settingsNotifier, l10n),
          const SizedBox(height: 16),

          // Section 5: Informazioni sull'Applicazione
          _buildAboutCard(context, l10n),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  /// Theme, appearance, and language selection card.
  Widget _buildThemeCard(
    BuildContext context,
    AppSettings settings,
    SettingsNotifier notifier,
    AppLocalizations l10n,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CosmicSvgIcon(
                  CosmicIcons.paletteSvg,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  l10n.appearanceAndTheme,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              l10n.chooseVisualThemeSubtitle,
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
                    segments: [
                      ButtonSegment<ThemeMode>(
                        value: ThemeMode.system,
                        icon: const CosmicSvgIcon(CosmicIcons.weatherCloudsSvg, size: 18),
                        label: Text(l10n.themeSystem),
                      ),
                      ButtonSegment<ThemeMode>(
                        value: ThemeMode.light,
                        icon: const CosmicSvgIcon(CosmicIcons.lightModeSvg, size: 18),
                        label: Text(l10n.themeLight),
                      ),
                      ButtonSegment<ThemeMode>(
                        value: ThemeMode.dark,
                        icon: const CosmicSvgIcon(CosmicIcons.darkModeSvg, size: 18),
                        label: Text(l10n.themeDark),
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
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Divider(height: 1),
            ),
            Row(
              children: [
                CosmicSvgIcon(
                  CosmicIcons.desktopSvg,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  l10n.themeStyle,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              l10n.themeStyleSubtitle,
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: SegmentedButton<AppThemeStyle>(
                segments: [
                  ButtonSegment<AppThemeStyle>(
                    value: AppThemeStyle.cosmic,
                    icon: const CosmicSvgIcon(CosmicIcons.rocketSvg, size: 18),
                    label: Text(l10n.themeStyleCosmic),
                  ),
                  ButtonSegment<AppThemeStyle>(
                    value: AppThemeStyle.standard,
                    icon: const CosmicSvgIcon(CosmicIcons.paletteSvg, size: 18),
                    label: Text(l10n.themeStyleStandard),
                  ),
                  ButtonSegment<AppThemeStyle>(
                    value: AppThemeStyle.auto,
                    icon: const CosmicSvgIcon(CosmicIcons.weatherCloudsSvg, size: 18),
                    label: Text(l10n.themeStyleAuto),
                  ),
                ],
                selected: {settings.themeStyle},
                onSelectionChanged: (newSelection) {
                  if (newSelection.isNotEmpty) {
                    notifier.setThemeStyle(newSelection.first);
                  }
                },
              ),
            ),
            if (settings.themeStyle == AppThemeStyle.cosmic ||
                (settings.themeStyle == AppThemeStyle.auto && AppTheme.isCosmicDesktopEnvironment())) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.25),
                  ),
                ),
                child: Row(
                  children: [
                    CosmicSvgIcon(
                      CosmicIcons.rocketSvg,
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        settings.themeStyle == AppThemeStyle.cosmic
                            ? l10n.themeStyleCosmicActive
                            : l10n.themeStyleCosmicDetected,
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Divider(height: 1),
            ),
            Row(
              children: [
                CosmicSvgIcon(
                  CosmicIcons.languageSvg,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  l10n.language,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              l10n.languageSubtitle,
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                final supported = AppLocalizations.supportedLocales;
                // If 2 or fewer languages (+ system = 3 segments), SegmentedButton fits nicely.
                // For 3+ languages (scaling up to 10-20+ languages), use DropdownButtonFormField to avoid RenderFlex overflow.
                if (supported.length <= 2) {
                  return SizedBox(
                    width: double.infinity,
                    child: SegmentedButton<String>(
                      segments: [
                        ...supported.map(
                          (loc) => ButtonSegment<String>(
                            value: loc.languageCode,
                            icon: const CosmicSvgIcon(
                              CosmicIcons.languageSvg,
                              size: 18,
                            ),
                            label: Text(
                              getLanguageDisplayName(loc.languageCode, l10n),
                            ),
                          ),
                        ),
                        ButtonSegment<String>(
                          value: 'system',
                          icon: const CosmicSvgIcon(CosmicIcons.weatherCloudsSvg, size: 18),
                          label: Text(l10n.langSystem),
                        ),
                      ],
                      selected: {
                        supported.any((l) => l.languageCode == settings.language) ||
                                settings.language == 'system'
                            ? settings.language
                            : 'system',
                      },
                      onSelectionChanged: (newSelection) {
                        if (newSelection.isNotEmpty) {
                          notifier.setLanguage(newSelection.first);
                        }
                      },
                    ),
                  );
                }

                // Scalable Dropdown selector for 10-20+ languages
                final availableOptions = <String>[
                  'system',
                  ...supported.map((l) => l.languageCode),
                ];
                final currentSelected = availableOptions.contains(settings.language)
                    ? settings.language
                    : 'system';

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const CosmicSvgIcon(CosmicIcons.languageSvg, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            key: const ValueKey('settings_language_dropdown'),
                            value: currentSelected,
                            isExpanded: true,
                            items: availableOptions.map((code) {
                              return DropdownMenuItem<String>(
                                value: code,
                                child: Row(
                                  children: [
                                    CosmicSvgIcon(
                                      code == 'system'
                                          ? CosmicIcons.weatherCloudsSvg
                                          : CosmicIcons.languageSvg,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(getLanguageDisplayName(code, l10n)),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (newVal) {
                              if (newVal != null) {
                                notifier.setLanguage(newVal);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
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
    AppLocalizations l10n,
  ) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                CosmicSvgIcon(
                  CosmicIcons.folderOpenSvg,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  l10n.filesAndExploration,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SwitchListTile(
            title: Text(l10n.showHiddenFiles),
            subtitle: Text(l10n.showHiddenFilesSubtitle),
            secondary: const CosmicSvgIcon(CosmicIcons.visibilitySvg, size: 20),
            value: settings.showHiddenFiles,
            onChanged: (val) => notifier.setShowHiddenFiles(val),
          ),
          const Divider(height: 1),
          SwitchListTile(
            title: Text(l10n.confirmBeforeDelete),
            subtitle: Text(l10n.confirmBeforeDeleteSubtitle),
            secondary: const CosmicSvgIcon(CosmicIcons.trashSvg, size: 20),
            value: settings.confirmDelete,
            onChanged: (val) => notifier.setConfirmDelete(val),
          ),
          const Divider(height: 1),
          SwitchListTile(
            title: Text(l10n.dualPaneMode),
            subtitle: Text(l10n.dualPaneModeSubtitle),
            secondary: const CosmicSvgIcon(CosmicIcons.splitScreenSvg, size: 20),
            value: settings.dualPaneEnabled,
            onChanged: (val) => notifier.setDualPaneEnabled(val),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const CosmicSvgIcon(CosmicIcons.downloadSvg, size: 20),
            title: Text(l10n.defaultDownloadFolder),
            subtitle: Text(
              settings.customDownloadPath != null &&
                      settings.customDownloadPath!.isNotEmpty
                  ? settings.customDownloadPath!
                  : l10n.defaultDownloadFolderSystem,
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
              l10n,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (settings.customDownloadPath != null)
                  IconButton(
                    icon: const CosmicSvgIcon(CosmicIcons.refreshSvg, size: 20),
                    tooltip: l10n.restoreDefaultPath,
                    onPressed: () => notifier.setCustomDownloadPath(null),
                  ),
                FilledButton.tonalIcon(
                  icon: const CosmicSvgIcon(CosmicIcons.editSvg, size: 16),
                  label: Text(l10n.change),
                  onPressed: () => _showCustomDownloadFolderDialog(
                    context,
                    settings,
                    notifier,
                    l10n,
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
    AppLocalizations l10n,
  ) async {
    final controller =
        TextEditingController(text: settings.customDownloadPath ?? '');
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const CosmicSvgIcon(CosmicIcons.folderOpenSvg, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                l10n.defaultDownloadFolder,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: 480,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.customDownloadFolderDialogPrompt,
                style: const TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        labelText: l10n.folderPath,
                        hintText: l10n.folderPathHint,
                        border: const OutlineInputBorder(),
                        isDense: true,
                        prefixIcon: const Padding(
                          padding: EdgeInsets.all(12),
                          child: CosmicSvgIcon(CosmicIcons.folderOpenSvg, size: 20),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filledTonal(
                    icon: const CosmicSvgIcon(CosmicIcons.searchSvg, size: 20),
                    tooltip: l10n.browseWithSystemPicker,
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
                                l10n.errorOpenPicker(e.toString()),
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
                Navigator.of(ctx).pop();
                notifier.setCustomDownloadPath(null);
              },
              child: Text(
                l10n.restoreDefault,
              ),
            ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              final text = controller.text.trim();
              notifier.setCustomDownloadPath(text.isEmpty ? null : text);
              Navigator.of(ctx).pop();
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  /// Developer support and GitLab repository card.
  Widget _buildCommunityAndSupportCard(
    BuildContext context,
    AppLocalizations l10n,
  ) {
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
                const CosmicSvgIcon(
                  CosmicIcons.heartSvg,
                  color: Colors.pinkAccent,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  l10n.communityAndSupport,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
            Text(
              l10n.openSourceDescription,
              style: const TextStyle(fontSize: 13, height: 1.4),
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
                  icon: const CosmicSvgIcon(CosmicIcons.heartSvg, size: 20, color: Colors.white),
                  label: Text(l10n.supportDeveloper),
                  onPressed: () => _showSupportDialog(context, l10n),
                ),

                // Pulsante Vedi Codice su GitLab
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  icon: const CosmicSvgIcon(CosmicIcons.codeSvg, size: 20),
                  label: Text(l10n.viewSourceOnGitLab),
                  onPressed: () async {
                    final success = await UrlUtils.openWebUrl(
                      Uri.parse(gitlabRepoUrl),
                    );
                    if (!success && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            l10n.errorOpenBrowser(gitlabRepoUrl),
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
  void _showSupportDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const CosmicSvgIcon(CosmicIcons.heartSvg, color: Colors.pinkAccent, size: 22),
            const SizedBox(width: 10),
            Text(
              l10n.supportDialogTitle,
            ),
          ],
        ),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.supportDialogDescription1,
                style: const TextStyle(fontSize: 14, height: 1.4),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.supportDialogDescription2,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  color: Theme.of(ctx).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),
              _buildDonationTile(
                context: ctx,
                svgAsset: CosmicIcons.heartSvg,
                color: Colors.orange,
                title: l10n.supportKofiTitle,
                subtitle: 'ko-fi.com/leorise',
                url: kofiUrl,
              ),
              const SizedBox(height: 8),
              _buildDonationTile(
                context: ctx,
                svgAsset: CosmicIcons.favoriteSvg,
                color: Colors.amber.shade800,
                title: l10n.supportLiberapayTitle,
                subtitle: 'liberapay.com/LeoRise25',
                url: liberapayUrl,
              ),
              const SizedBox(height: 8),
              _buildDonationTile(
                context: ctx,
                svgAsset: CosmicIcons.cardSvg,
                color: Colors.blue,
                title: l10n.supportPaypalTitle,
                subtitle: 'paypal.me/leorise',
                url: paypalUrl,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  Widget _buildDonationTile({
    required BuildContext context,
    required String svgAsset,
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
            CosmicSvgIcon(svgAsset, color: color, size: 22),
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
            CosmicSvgIcon(CosmicIcons.openWithSvg, size: 16, color: color),
          ],
        ),
      ),
    );
  }

  /// Security and encrypted storage management card.
  Widget _buildSecurityCard(
    BuildContext context,
    WidgetRef ref,
    AppSettings settings,
    SettingsNotifier notifier,
    AppLocalizations l10n,
  ) {
    final lockState = ref.watch(appLockProvider);
    final appLockService = ref.read(appLockServiceProvider);

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                const CosmicSvgIcon(CosmicIcons.shieldSvg, color: Colors.green, size: 22),
                const SizedBox(width: 12),
                Text(
                  l10n.securityAndEncryption,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              l10n.securityArchitectureDescription,
              style: const TextStyle(fontSize: 13, height: 1.4),
            ),
          ),
          const Divider(height: 16),

          // --- App Lock Section ---
          SwitchListTile(
            secondary: const CosmicSvgIcon(CosmicIcons.lockSvg, size: 20),
            title: Text(
              l10n.appLock,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              settings.appLockEnabled
                  ? l10n.appLockActiveSubtitle
                  : l10n.appLockSubtitle,
            ),
            value: settings.appLockEnabled,
            onChanged: (enabled) async {
              if (enabled) {
                // Open PIN setup dialog
                final success = await showDialog<bool>(
                  context: context,
                  barrierDismissible: false,
                  builder: (ctx) => PinSetupDialog(
                    mode: PinDialogMode.setup,
                    onSaveNewPin: (pin) async {
                      await appLockService.savePin(pin);
                      await notifier.setAppLockEnabled(true);
                      await ref.read(appLockProvider.notifier).refreshCapabilities();
                    },
                  ),
                );

                if (success == true && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        l10n.appLockEnabledSnackbar,
                      ),
                    ),
                  );
                }
              } else {
                // Verify old PIN before disabling
                final verified = await showDialog<bool>(
                  context: context,
                  barrierDismissible: false,
                  builder: (ctx) => PinSetupDialog(
                    mode: PinDialogMode.verify,
                    onVerifyOldPin: (pin) => appLockService.verifyPin(pin),
                  ),
                );

                if (verified == true) {
                  await notifier.setAppLockEnabled(false);
                  await appLockService.clearPin();
                  await ref.read(appLockProvider.notifier).refreshCapabilities();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          l10n.appLockDisabledSnackbar,
                        ),
                      ),
                    );
                  }
                }
              }
            },
          ),

          if (settings.appLockEnabled) ...[
            const Divider(height: 1),
            ListTile(
              leading: const CosmicSvgIcon(CosmicIcons.passwordSvg, size: 20),
              title: Text(l10n.changePin),
              subtitle: Text(l10n.changePinSubtitle),
              trailing: const CosmicSvgIcon(CosmicIcons.chevronRightSvg, size: 16),
              onTap: () async {
                final success = await showDialog<bool>(
                  context: context,
                  barrierDismissible: false,
                  builder: (ctx) => PinSetupDialog(
                    mode: PinDialogMode.change,
                    onVerifyOldPin: (pin) => appLockService.verifyPin(pin),
                    onSaveNewPin: (pin) => appLockService.savePin(pin),
                  ),
                );

                if (success == true && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        l10n.pinChangedSnackbar,
                      ),
                    ),
                  );
                }
              },
            ),
            const Divider(height: 1),
            SwitchListTile(
              secondary: const CosmicSvgIcon(CosmicIcons.shieldSvg, size: 20),
              title: Text(l10n.biometricAuth),
              subtitle: Text(
                lockState.canCheckBiometrics
                    ? l10n.biometricAuthSubtitle
                    : l10n.biometricNotAvailable,
              ),
              value: settings.useBiometrics && lockState.canCheckBiometrics,
              onChanged: lockState.canCheckBiometrics
                  ? (val) => notifier.setUseBiometrics(val)
                  : null,
            ),
            const Divider(height: 1),
            ListTile(
              leading: const CosmicSvgIcon(CosmicIcons.clockSvg, size: 20),
              title: Text(l10n.autoLock),
              subtitle: Text(
                l10n.autoLockSubtitle,
              ),
              trailing: DropdownButton<int>(
                value: settings.autoLockTimeoutMinutes,
                underline: const SizedBox.shrink(),
                items: [
                  DropdownMenuItem(
                    value: 0,
                    child: Text(l10n.lockImmediately),
                  ),
                  DropdownMenuItem(
                    value: 1,
                    child: Text(l10n.lockAfter1Minute),
                  ),
                  DropdownMenuItem(
                    value: 5,
                    child: Text(l10n.lockAfter5Minutes),
                  ),
                  DropdownMenuItem(
                    value: 15,
                    child: Text(l10n.lockAfter15Minutes),
                  ),
                  DropdownMenuItem(
                    value: 30,
                    child: Text(l10n.lockAfter30Minutes),
                  ),
                ],
                onChanged: (val) {
                  if (val != null) {
                    notifier.setAutoLockTimeoutMinutes(val);
                  }
                },
              ),
            ),
          ],

          const Divider(height: 16),
          ListTile(
            leading: const CosmicSvgIcon(CosmicIcons.syncSvg, size: 20),
            title: Text(l10n.syncCloudAccounts),
            subtitle: Text(
              l10n.syncCloudAccountsSubtitle,
            ),
            trailing: const CosmicSvgIcon(CosmicIcons.chevronRightSvg, size: 16),
            onTap: () {
              ref.read(cloudAccountsProvider.notifier).loadRemotes();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    l10n.syncCloudAccountsSuccess,
                  ),
                ),
              );
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const CosmicSvgIcon(CosmicIcons.deleteSvg, color: Colors.red, size: 20),
            title: Text(
              l10n.clearAllCredentials,
              style: const TextStyle(color: Colors.red),
            ),
            subtitle: Text(
              l10n.clearAllCredentialsSubtitle,
            ),
            onTap: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(
                    l10n.clearCredentialsDialogTitle,
                  ),
                  content: Text(
                    l10n.clearCredentialsDialogContent,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: Text(l10n.cancel),
                    ),
                    FilledButton(
                      style: FilledButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () => Navigator.of(ctx).pop(true),
                      child: Text(l10n.delete),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await ref.read(secureConfigServiceProvider).clearConfig();
                await ref.read(cloudAccountsProvider.notifier).loadRemotes();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        l10n.clearCredentialsSuccess,
                      ),
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
  Widget _buildAboutCard(BuildContext context, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CosmicSvgIcon(CosmicIcons.infoSvg, color: Colors.blue, size: 20),
                const SizedBox(width: 12),
                Text(
                  l10n.aboutUnifyCloud,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(l10n.appVersion),
            const SizedBox(height: 4),
            Text(l10n.developerInfo),
            const SizedBox(height: 4),
            Text(
              l10n.engineInfo,
            ),
            const SizedBox(height: 4),
            Text(
              l10n.frameworkInfo,
            ),
            const SizedBox(height: 4),
            Text(l10n.licenseInfo),
            const SizedBox(height: 4),
            Text(l10n.copyrightInfo),
          ],
        ),
      ),
    );
  }

  /// Desktop system integration, autostart, and system tray card.
  Widget _buildDesktopCard(
    BuildContext context,
    AppSettings settings,
    SettingsNotifier notifier,
    AppLocalizations l10n,
  ) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                CosmicSvgIcon(
                  CosmicIcons.desktopSvg,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  l10n.desktopAndSystem,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              l10n.desktopAndSystemSubtitle,
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const Divider(height: 16),

          // Autostart on Boot (Linux XDG autostart)
          if (Platform.isLinux) ...[
            SwitchListTile(
              secondary: const CosmicSvgIcon(CosmicIcons.powerSvg, size: 20),
              title: Text(
                l10n.autostartOnBoot,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(l10n.autostartOnBootSubtitle),
              value: settings.autostartOnBoot,
              onChanged: (val) {
                notifier.setAutostartOnBoot(val);
              },
            ),
            const Divider(height: 1),
          ],

          // Minimize to System Tray
          SwitchListTile(
            secondary: const CosmicSvgIcon(CosmicIcons.panDownSvg, size: 20),
            title: Text(
              l10n.minimizeToTray,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(l10n.minimizeToTraySubtitle),
            value: settings.minimizeToTray,
            onChanged: (val) {
              notifier.setMinimizeToTray(val);
            },
          ),
        ],
      ),
    );
  }
}
