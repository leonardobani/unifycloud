import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_pl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('pl'),
  ];

  /// Application title
  ///
  /// In en, this message translates to:
  /// **'UnifyCloud'**
  String get appTitle;

  /// Localized message for home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Localized message for explorer.
  ///
  /// In en, this message translates to:
  /// **'Explorer'**
  String get explorer;

  /// Localized message for sync.
  ///
  /// In en, this message translates to:
  /// **'Sync'**
  String get sync;

  /// Localized message for settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Localized message for cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Localized message for confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Localized message for delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Localized message for save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Localized message for close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Localized message for edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Localized message for create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// Localized message for retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Localized message for copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// Localized message for move.
  ///
  /// In en, this message translates to:
  /// **'Move'**
  String get move;

  /// Localized message for rename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get rename;

  /// Localized message for download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// Localized message for upload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get upload;

  /// Localized message for share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// Localized message for details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// Localized message for search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// Localized message for change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// Localized message for reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// Localized message for done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// Localized message for loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Localized message for success.
  ///
  /// In en, this message translates to:
  /// **'Operation completed'**
  String get success;

  /// Localized message for error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Localized message for settings title.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Localized message for reset defaults tooltip.
  ///
  /// In en, this message translates to:
  /// **'Restore Default Settings'**
  String get resetDefaultsTooltip;

  /// Localized message for reset dialog title.
  ///
  /// In en, this message translates to:
  /// **'Reset Settings'**
  String get resetDialogTitle;

  /// Localized message for reset dialog content.
  ///
  /// In en, this message translates to:
  /// **'Do you want to reset all preferences (theme, language, folders, display) to factory defaults?'**
  String get resetDialogContent;

  /// Localized message for reset success snackbar.
  ///
  /// In en, this message translates to:
  /// **'Settings restored to default values'**
  String get resetSuccessSnackbar;

  /// Localized message for appearance and theme.
  ///
  /// In en, this message translates to:
  /// **'Appearance & Theme'**
  String get appearanceAndTheme;

  /// Localized message for choose visual theme subtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose visual theme for UnifyCloud interface:'**
  String get chooseVisualThemeSubtitle;

  /// Localized message for theme system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// Localized message for theme light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// Localized message for theme dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// Localized message for language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Localized message for language subtitle.
  ///
  /// In en, this message translates to:
  /// **'Select application interface language'**
  String get languageSubtitle;

  /// Localized message for lang english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get langEnglish;

  /// Localized message for lang italian.
  ///
  /// In en, this message translates to:
  /// **'Italiano'**
  String get langItalian;

  /// Localized message for lang system.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get langSystem;

  /// Localized message for files and exploration.
  ///
  /// In en, this message translates to:
  /// **'Files & Exploration'**
  String get filesAndExploration;

  /// Localized message for show hidden files.
  ///
  /// In en, this message translates to:
  /// **'Show hidden files'**
  String get showHiddenFiles;

  /// Localized message for show hidden files subtitle.
  ///
  /// In en, this message translates to:
  /// **'Display files and folders starting with a dot'**
  String get showHiddenFilesSubtitle;

  /// Localized message for confirm before delete.
  ///
  /// In en, this message translates to:
  /// **'Confirm before deleting'**
  String get confirmBeforeDelete;

  /// Localized message for confirm before delete subtitle.
  ///
  /// In en, this message translates to:
  /// **'Ask for confirmation before permanently deleting files'**
  String get confirmBeforeDeleteSubtitle;

  /// Localized message for default download folder.
  ///
  /// In en, this message translates to:
  /// **'Default Download Folder'**
  String get defaultDownloadFolder;

  /// Localized message for default download folder system.
  ///
  /// In en, this message translates to:
  /// **'System default download directory'**
  String get defaultDownloadFolderSystem;

  /// Localized message for restore default path.
  ///
  /// In en, this message translates to:
  /// **'Restore default path'**
  String get restoreDefaultPath;

  /// Localized message for custom download folder dialog prompt.
  ///
  /// In en, this message translates to:
  /// **'Select a folder using the system picker or enter the desired path manually:'**
  String get customDownloadFolderDialogPrompt;

  /// Localized message for folder path.
  ///
  /// In en, this message translates to:
  /// **'Folder path'**
  String get folderPath;

  /// Localized message for folder path hint.
  ///
  /// In en, this message translates to:
  /// **'e.g. /home/user/Downloads'**
  String get folderPathHint;

  /// Localized message for browse with system picker.
  ///
  /// In en, this message translates to:
  /// **'Browse with system picker'**
  String get browseWithSystemPicker;

  /// Error snackbar when opening file picker fails
  ///
  /// In en, this message translates to:
  /// **'Unable to open system picker: {error}'**
  String errorOpenPicker(String error);

  /// Localized message for restore default.
  ///
  /// In en, this message translates to:
  /// **'Restore default'**
  String get restoreDefault;

  /// Localized message for max concurrent transfers.
  ///
  /// In en, this message translates to:
  /// **'Concurrent Transfers'**
  String get maxConcurrentTransfers;

  /// Localized message for max concurrent transfers subtitle.
  ///
  /// In en, this message translates to:
  /// **'Maximum number of simultaneous active file transfers'**
  String get maxConcurrentTransfersSubtitle;

  /// Localized message for dual pane mode.
  ///
  /// In en, this message translates to:
  /// **'Dual-Pane Commander Mode'**
  String get dualPaneMode;

  /// Localized message for dual pane mode subtitle.
  ///
  /// In en, this message translates to:
  /// **'Show two side-by-side panes on wide screens and tablets'**
  String get dualPaneModeSubtitle;

  /// Localized message for community and support.
  ///
  /// In en, this message translates to:
  /// **'Community & Support'**
  String get communityAndSupport;

  /// Localized message for open source description.
  ///
  /// In en, this message translates to:
  /// **'UnifyCloud is free and open-source software built to unify your cloud data without trackers or proprietary intermediaries.'**
  String get openSourceDescription;

  /// Localized message for support developer.
  ///
  /// In en, this message translates to:
  /// **'Support the Developer'**
  String get supportDeveloper;

  /// Localized message for support developer subtitle.
  ///
  /// In en, this message translates to:
  /// **'Buy a coffee to support independent development'**
  String get supportDeveloperSubtitle;

  /// Localized message for view source on git lab.
  ///
  /// In en, this message translates to:
  /// **'View Code on GitLab'**
  String get viewSourceOnGitLab;

  /// Localized message for view source on git lab subtitle.
  ///
  /// In en, this message translates to:
  /// **'Official repository, bug reports, and contributions'**
  String get viewSourceOnGitLabSubtitle;

  /// Error snackbar when opening browser fails
  ///
  /// In en, this message translates to:
  /// **'Unable to open browser. Repository: {url}'**
  String errorOpenBrowser(String url);

  /// Localized message for support dialog title.
  ///
  /// In en, this message translates to:
  /// **'Support UnifyCloud'**
  String get supportDialogTitle;

  /// Localized message for support dialog description1.
  ///
  /// In en, this message translates to:
  /// **'UnifyCloud is a free and open-source project designed to give you full control over your cloud files.'**
  String get supportDialogDescription1;

  /// Localized message for support dialog description2.
  ///
  /// In en, this message translates to:
  /// **'If you find this application helpful, consider buying a coffee or donating to support continuous development and new features!'**
  String get supportDialogDescription2;

  /// Localized message for support kofi title.
  ///
  /// In en, this message translates to:
  /// **'Buy a coffee on Ko-fi'**
  String get supportKofiTitle;

  /// Localized message for support liberapay title.
  ///
  /// In en, this message translates to:
  /// **'Donate on Liberapay'**
  String get supportLiberapayTitle;

  /// Localized message for support paypal title.
  ///
  /// In en, this message translates to:
  /// **'Donate via PayPal'**
  String get supportPaypalTitle;

  /// Localized message for security and encryption.
  ///
  /// In en, this message translates to:
  /// **'Security & Encryption'**
  String get securityAndEncryption;

  /// Localized message for security architecture description.
  ///
  /// In en, this message translates to:
  /// **'UnifyCloud employs a Zero-Plaintext architecture. All OAuth tokens and credentials are securely protected in the system Keychain/Keystore and injected exclusively into Go engine RAM memory.'**
  String get securityArchitectureDescription;

  /// Localized message for app lock.
  ///
  /// In en, this message translates to:
  /// **'App Lock (PIN / Biometrics)'**
  String get appLock;

  /// Localized message for app lock subtitle.
  ///
  /// In en, this message translates to:
  /// **'Require PIN or fingerprint to access'**
  String get appLockSubtitle;

  /// Localized message for app lock active subtitle.
  ///
  /// In en, this message translates to:
  /// **'Active at startup and after inactivity'**
  String get appLockActiveSubtitle;

  /// Localized message for app lock enabled snackbar.
  ///
  /// In en, this message translates to:
  /// **'App Lock enabled successfully'**
  String get appLockEnabledSnackbar;

  /// Localized message for app lock disabled snackbar.
  ///
  /// In en, this message translates to:
  /// **'App Lock disabled'**
  String get appLockDisabledSnackbar;

  /// Localized message for change pin.
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get changePin;

  /// Localized message for change pin subtitle.
  ///
  /// In en, this message translates to:
  /// **'Set a new 6-digit security PIN'**
  String get changePinSubtitle;

  /// Localized message for pin changed snackbar.
  ///
  /// In en, this message translates to:
  /// **'Security PIN updated successfully'**
  String get pinChangedSnackbar;

  /// Localized message for biometric auth.
  ///
  /// In en, this message translates to:
  /// **'Biometric Authentication'**
  String get biometricAuth;

  /// Localized message for biometric auth subtitle.
  ///
  /// In en, this message translates to:
  /// **'Use fingerprint or biometric sensor if available'**
  String get biometricAuthSubtitle;

  /// Localized message for biometric not available.
  ///
  /// In en, this message translates to:
  /// **'Not available or not configured on this device'**
  String get biometricNotAvailable;

  /// Localized message for auto lock.
  ///
  /// In en, this message translates to:
  /// **'Auto Lock'**
  String get autoLock;

  /// Localized message for auto lock subtitle.
  ///
  /// In en, this message translates to:
  /// **'Background inactivity timeout before locking'**
  String get autoLockSubtitle;

  /// Localized message for lock immediately.
  ///
  /// In en, this message translates to:
  /// **'Immediately'**
  String get lockImmediately;

  /// Localized message for lock after1 minute.
  ///
  /// In en, this message translates to:
  /// **'After 1 minute'**
  String get lockAfter1Minute;

  /// Localized message for lock after5 minutes.
  ///
  /// In en, this message translates to:
  /// **'After 5 minutes'**
  String get lockAfter5Minutes;

  /// Localized message for lock after15 minutes.
  ///
  /// In en, this message translates to:
  /// **'After 15 minutes'**
  String get lockAfter15Minutes;

  /// Localized message for lock after30 minutes.
  ///
  /// In en, this message translates to:
  /// **'After 30 minutes'**
  String get lockAfter30Minutes;

  /// Localized message for sync cloud accounts.
  ///
  /// In en, this message translates to:
  /// **'Sync Cloud Accounts'**
  String get syncCloudAccounts;

  /// Localized message for sync cloud accounts subtitle.
  ///
  /// In en, this message translates to:
  /// **'Reload configurations from secure storage'**
  String get syncCloudAccountsSubtitle;

  /// Localized message for sync cloud accounts success.
  ///
  /// In en, this message translates to:
  /// **'Cloud accounts reloaded successfully'**
  String get syncCloudAccountsSuccess;

  /// Localized message for clear all credentials.
  ///
  /// In en, this message translates to:
  /// **'Clear All Credentials'**
  String get clearAllCredentials;

  /// Localized message for clear all credentials subtitle.
  ///
  /// In en, this message translates to:
  /// **'Removes encrypted configuration and disconnects all clouds'**
  String get clearAllCredentialsSubtitle;

  /// Localized message for clear credentials dialog title.
  ///
  /// In en, this message translates to:
  /// **'Warning: Reset Credentials'**
  String get clearCredentialsDialogTitle;

  /// Localized message for clear credentials dialog content.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete all saved credentials? You will need to reconnect your cloud accounts.'**
  String get clearCredentialsDialogContent;

  /// Localized message for clear credentials success.
  ///
  /// In en, this message translates to:
  /// **'Credentials deleted successfully'**
  String get clearCredentialsSuccess;

  /// Localized message for about unify cloud.
  ///
  /// In en, this message translates to:
  /// **'About UnifyCloud'**
  String get aboutUnifyCloud;

  /// Localized message for app version.
  ///
  /// In en, this message translates to:
  /// **'App Version: 1.0.1'**
  String get appVersion;

  /// Localized message for developer info.
  ///
  /// In en, this message translates to:
  /// **'Developer: Leonardo Bani (@leonardobani)'**
  String get developerInfo;

  /// Localized message for engine info.
  ///
  /// In en, this message translates to:
  /// **'Engine: Rclone Core CGO (Go v1.22+ / C FFI)'**
  String get engineInfo;

  /// Localized message for framework info.
  ///
  /// In en, this message translates to:
  /// **'Framework: Flutter (Material 3 Responsive)'**
  String get frameworkInfo;

  /// Localized message for license info.
  ///
  /// In en, this message translates to:
  /// **'License: GNU General Public License v3.0 (GPL-3.0)'**
  String get licenseInfo;

  /// Localized message for copyright info.
  ///
  /// In en, this message translates to:
  /// **'Copyright: © 2026 Leonardo Bani'**
  String get copyrightInfo;

  /// Localized message for storage overview.
  ///
  /// In en, this message translates to:
  /// **'Storage Overview'**
  String get storageOverview;

  /// Localized message for connected clouds.
  ///
  /// In en, this message translates to:
  /// **'Connected Clouds'**
  String get connectedClouds;

  /// Localized message for no clouds configured.
  ///
  /// In en, this message translates to:
  /// **'No cloud accounts configured'**
  String get noCloudsConfigured;

  /// Localized message for no clouds description.
  ///
  /// In en, this message translates to:
  /// **'Connect your first cloud storage account to start managing and syncing files.'**
  String get noCloudsDescription;

  /// Localized message for add cloud.
  ///
  /// In en, this message translates to:
  /// **'Add Cloud'**
  String get addCloud;

  /// Localized message for used.
  ///
  /// In en, this message translates to:
  /// **'used'**
  String get used;

  /// Localized message for free.
  ///
  /// In en, this message translates to:
  /// **'free'**
  String get free;

  /// Localized message for total.
  ///
  /// In en, this message translates to:
  /// **'total'**
  String get total;

  /// Localized message for manage accounts.
  ///
  /// In en, this message translates to:
  /// **'Manage Accounts'**
  String get manageAccounts;

  /// Localized message for view files.
  ///
  /// In en, this message translates to:
  /// **'View Files'**
  String get viewFiles;

  /// Localized message for create vault here.
  ///
  /// In en, this message translates to:
  /// **'Create Encrypted Vault here...'**
  String get createVaultHere;

  /// Localized message for disconnect account.
  ///
  /// In en, this message translates to:
  /// **'Disconnect account'**
  String get disconnectAccount;

  /// Localized message for disconnect confirm title.
  ///
  /// In en, this message translates to:
  /// **'Disconnect account?'**
  String get disconnectConfirmTitle;

  /// Localized message for disconnect confirm content.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to disconnect this account? Remote files will remain intact.'**
  String get disconnectConfirmContent;

  /// Localized message for all files.
  ///
  /// In en, this message translates to:
  /// **'All Files'**
  String get allFiles;

  /// Localized message for empty folder.
  ///
  /// In en, this message translates to:
  /// **'This folder is empty'**
  String get emptyFolder;

  /// Localized message for empty folder subtitle.
  ///
  /// In en, this message translates to:
  /// **'Upload files or create a subfolder to get started.'**
  String get emptyFolderSubtitle;

  /// Localized message for upload file.
  ///
  /// In en, this message translates to:
  /// **'Upload file'**
  String get uploadFile;

  /// Localized message for upload folder.
  ///
  /// In en, this message translates to:
  /// **'Upload entire folder'**
  String get uploadFolder;

  /// Localized message for new folder.
  ///
  /// In en, this message translates to:
  /// **'New Folder'**
  String get newFolder;

  /// Localized message for new folder prompt.
  ///
  /// In en, this message translates to:
  /// **'Enter the name for the new folder:'**
  String get newFolderPrompt;

  /// Localized message for folder name hint.
  ///
  /// In en, this message translates to:
  /// **'Folder name'**
  String get folderNameHint;

  /// Localized message for select all.
  ///
  /// In en, this message translates to:
  /// **'Select all'**
  String get selectAll;

  /// Localized message for clear selection.
  ///
  /// In en, this message translates to:
  /// **'Clear selection'**
  String get clearSelection;

  /// Localized message for delete selected.
  ///
  /// In en, this message translates to:
  /// **'Delete selected'**
  String get deleteSelected;

  /// Localized message for delete selected prompt.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the selected items?'**
  String get deleteSelectedPrompt;

  /// Localized message for delete item prompt.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this item?'**
  String get deleteItemPrompt;

  /// Localized message for share link.
  ///
  /// In en, this message translates to:
  /// **'Share Link'**
  String get shareLink;

  /// Localized message for create share link.
  ///
  /// In en, this message translates to:
  /// **'Create shareable link'**
  String get createShareLink;

  /// Localized message for copy share link.
  ///
  /// In en, this message translates to:
  /// **'Copy Link'**
  String get copyShareLink;

  /// Localized message for copied to clipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copiedToClipboard;

  /// Localized message for transfers.
  ///
  /// In en, this message translates to:
  /// **'Transfers'**
  String get transfers;

  /// Localized message for active transfers.
  ///
  /// In en, this message translates to:
  /// **'Active Transfers'**
  String get activeTransfers;

  /// Localized message for completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// Localized message for failed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get failed;

  /// Localized message for queued.
  ///
  /// In en, this message translates to:
  /// **'Queued'**
  String get queued;

  /// Localized message for cancel transfer.
  ///
  /// In en, this message translates to:
  /// **'Cancel transfer'**
  String get cancelTransfer;

  /// Localized message for clear completed.
  ///
  /// In en, this message translates to:
  /// **'Clear completed'**
  String get clearCompleted;

  /// Localized message for sync rules title.
  ///
  /// In en, this message translates to:
  /// **'Backup & Sync Rules'**
  String get syncRulesTitle;

  /// Localized message for new rule.
  ///
  /// In en, this message translates to:
  /// **'New Rule'**
  String get newRule;

  /// Localized message for no sync rules.
  ///
  /// In en, this message translates to:
  /// **'No synchronization rules configured'**
  String get noSyncRules;

  /// Localized message for no sync rules subtitle.
  ///
  /// In en, this message translates to:
  /// **'Create an automated rule to sync local folders with your cloud storage.'**
  String get noSyncRulesSubtitle;

  /// Localized message for rule name.
  ///
  /// In en, this message translates to:
  /// **'Rule Name'**
  String get ruleName;

  /// Localized message for source path.
  ///
  /// In en, this message translates to:
  /// **'Source Folder'**
  String get sourcePath;

  /// Localized message for destination cloud.
  ///
  /// In en, this message translates to:
  /// **'Destination Cloud'**
  String get destinationCloud;

  /// Localized message for destination path.
  ///
  /// In en, this message translates to:
  /// **'Remote Path'**
  String get destinationPath;

  /// Localized message for direction.
  ///
  /// In en, this message translates to:
  /// **'Direction'**
  String get direction;

  /// Localized message for frequency.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get frequency;

  /// Localized message for run now.
  ///
  /// In en, this message translates to:
  /// **'Run Now'**
  String get runNow;

  /// Localized message for sync in progress.
  ///
  /// In en, this message translates to:
  /// **'Synchronization in progress...'**
  String get syncInProgress;

  /// Localized message for sync success.
  ///
  /// In en, this message translates to:
  /// **'Synchronization completed'**
  String get syncSuccess;

  /// Localized message for sync failed.
  ///
  /// In en, this message translates to:
  /// **'Synchronization failed'**
  String get syncFailed;

  /// Localized message for add cloud dialog title.
  ///
  /// In en, this message translates to:
  /// **'Connect New Cloud'**
  String get addCloudDialogTitle;

  /// Localized message for select provider.
  ///
  /// In en, this message translates to:
  /// **'Select Cloud Provider'**
  String get selectProvider;

  /// Localized message for account name label.
  ///
  /// In en, this message translates to:
  /// **'Account Name / Alias'**
  String get accountNameLabel;

  /// Localized message for connect button.
  ///
  /// In en, this message translates to:
  /// **'Connect Account'**
  String get connectButton;

  /// Localized message for vault title.
  ///
  /// In en, this message translates to:
  /// **'E2E Encryption (Crypt)'**
  String get vaultTitle;

  /// Localized message for vault password.
  ///
  /// In en, this message translates to:
  /// **'Vault Password'**
  String get vaultPassword;

  /// Localized message for vault confirm password.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get vaultConfirmPassword;

  /// Localized message for vault salt.
  ///
  /// In en, this message translates to:
  /// **'Salt / Secondary Password (Optional)'**
  String get vaultSalt;

  /// Localized message for encrypt file names.
  ///
  /// In en, this message translates to:
  /// **'Encrypt file names'**
  String get encryptFileNames;

  /// Localized message for encrypt dir names.
  ///
  /// In en, this message translates to:
  /// **'Encrypt directory names'**
  String get encryptDirNames;

  /// Localized message for lang spanish.
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get langSpanish;

  /// Localized message for lang french.
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get langFrench;

  /// Localized message for lang arabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get langArabic;

  /// Localized message for lang polish.
  ///
  /// In en, this message translates to:
  /// **'Polski'**
  String get langPolish;

  /// Localized message for select language.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// Localized message for search language hint.
  ///
  /// In en, this message translates to:
  /// **'Search language or country...'**
  String get searchLanguageHint;

  /// Localized message for current language.
  ///
  /// In en, this message translates to:
  /// **'Current Language'**
  String get currentLanguage;

  /// Localized message for system default with locale.
  ///
  /// In en, this message translates to:
  /// **'System Default ({locale})'**
  String systemDefaultWithLocale(String locale);

  /// Localized message for refresh clouds tooltip.
  ///
  /// In en, this message translates to:
  /// **'Refresh cloud configurations'**
  String get refreshCloudsTooltip;

  /// Localized message for storage overview aggregated.
  ///
  /// In en, this message translates to:
  /// **'Aggregated Storage Overview'**
  String get storageOverviewAggregated;

  /// Localized message for ram encryption active.
  ///
  /// In en, this message translates to:
  /// **'RAM Encryption Active'**
  String get ramEncryptionActive;

  /// Localized message for connected accounts count.
  ///
  /// In en, this message translates to:
  /// **'Connected Cloud Accounts: {count}'**
  String connectedAccountsCount(int count);

  /// Localized message for no clouds configured hint.
  ///
  /// In en, this message translates to:
  /// **'No cloud accounts configured. Tap \"+ Connect New Cloud\" below.'**
  String get noCloudsConfiguredHint;

  /// Localized message for percent used.
  ///
  /// In en, this message translates to:
  /// **'{percent}% used'**
  String percentUsed(String percent);

  /// Localized message for available space.
  ///
  /// In en, this message translates to:
  /// **'{space} available'**
  String availableSpace(String space);

  /// Localized message for calculating quota.
  ///
  /// In en, this message translates to:
  /// **'Calculating storage quotas or unlimited space...'**
  String get calculatingQuota;

  /// Localized message for sync and backup.
  ///
  /// In en, this message translates to:
  /// **'Sync & Backup'**
  String get syncAndBackup;

  /// Localized message for no rules configured.
  ///
  /// In en, this message translates to:
  /// **'No rules configured'**
  String get noRulesConfigured;

  /// Localized message for active rules count.
  ///
  /// In en, this message translates to:
  /// **'{active}/{total} active rules'**
  String activeRulesCount(int active, int total);

  /// Localized message for manage.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get manage;

  /// Localized message for connected clouds count.
  ///
  /// In en, this message translates to:
  /// **'Connected Clouds ({count})'**
  String connectedCloudsCount(int count);

  /// Localized message for connect new cloud.
  ///
  /// In en, this message translates to:
  /// **'Connect New Cloud'**
  String get connectNewCloud;

  /// Localized message for no cloud providers connected.
  ///
  /// In en, this message translates to:
  /// **'No Cloud Providers Connected'**
  String get noCloudProvidersConnected;

  /// Localized message for connect cloud description.
  ///
  /// In en, this message translates to:
  /// **'Connect Google Drive, Dropbox, OneDrive, SFTP or WebDAV to start syncing and exploring your files.'**
  String get connectCloudDescription;

  /// Localized message for add first cloud.
  ///
  /// In en, this message translates to:
  /// **'Add First Cloud'**
  String get addFirstCloud;

  /// Localized message for vault on remote.
  ///
  /// In en, this message translates to:
  /// **'VAULT ON {remote}'**
  String vaultOnRemote(String remote);

  /// Localized message for disconnect cloud title.
  ///
  /// In en, this message translates to:
  /// **'Disconnect Cloud'**
  String get disconnectCloudTitle;

  /// Localized message for disconnect cloud prompt.
  ///
  /// In en, this message translates to:
  /// **'Do you want to disconnect \"{name}\"? Credentials will be removed from encrypted storage.'**
  String disconnectCloudPrompt(String name);

  /// Localized message for disconnect.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get disconnect;

  /// Localized message for free space.
  ///
  /// In en, this message translates to:
  /// **'{space} free'**
  String freeSpace(String space);

  /// Localized message for storage.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get storage;

  /// Localized message for available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// Localized message for explore files.
  ///
  /// In en, this message translates to:
  /// **'Explore Files'**
  String get exploreFiles;

  /// Localized message for pane left.
  ///
  /// In en, this message translates to:
  /// **'Left'**
  String get paneLeft;

  /// Localized message for pane right.
  ///
  /// In en, this message translates to:
  /// **'Right'**
  String get paneRight;

  /// Localized message for folder name.
  ///
  /// In en, this message translates to:
  /// **'Folder name'**
  String get folderName;

  /// Localized message for error creating folder.
  ///
  /// In en, this message translates to:
  /// **'Error creating folder: {error}'**
  String errorCreatingFolder(String error);

  /// Localized message for move action.
  ///
  /// In en, this message translates to:
  /// **'Move'**
  String get moveAction;

  /// Localized message for copy action.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copyAction;

  /// Localized message for transfer batch started.
  ///
  /// In en, this message translates to:
  /// **'{action} of {count} items to [{remote}] started...'**
  String transferBatchStarted(String action, int count, String remote);

  /// Localized message for error transferring.
  ///
  /// In en, this message translates to:
  /// **'Error during transfer: {error}'**
  String errorTransferring(String error);

  /// Localized message for item copied to clipboard.
  ///
  /// In en, this message translates to:
  /// **'\"{name}\" copied to clipboard'**
  String itemCopiedToClipboard(String name);

  /// Localized message for items copied to clipboard.
  ///
  /// In en, this message translates to:
  /// **'{count} items copied to clipboard'**
  String itemsCopiedToClipboard(int count);

  /// Localized message for item cut to clipboard.
  ///
  /// In en, this message translates to:
  /// **'\"{name}\" cut (ready to move)'**
  String itemCutToClipboard(String name);

  /// Localized message for items cut to clipboard.
  ///
  /// In en, this message translates to:
  /// **'{count} items cut (ready to move)'**
  String itemsCutToClipboard(int count);

  /// Localized message for no files selected for download.
  ///
  /// In en, this message translates to:
  /// **'No files selected for download.'**
  String get noFilesSelectedForDownload;

  /// Localized message for downloading items.
  ///
  /// In en, this message translates to:
  /// **'Downloading {count} items...'**
  String downloadingItems(int count);

  /// Localized message for items downloaded success.
  ///
  /// In en, this message translates to:
  /// **'{count} items downloaded to \"{path}\"'**
  String itemsDownloadedSuccess(int count, String path);

  /// Localized message for error starting download.
  ///
  /// In en, this message translates to:
  /// **'Error starting download: {error}'**
  String errorStartingDownload(String error);

  /// Localized message for delete items confirm title.
  ///
  /// In en, this message translates to:
  /// **'Delete {count} selected items?'**
  String deleteItemsConfirmTitle(int count);

  /// Localized message for delete items confirm prompt.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to permanently delete {count} selected items from the cloud?'**
  String deleteItemsConfirmPrompt(int count);

  /// Localized message for items deleted success.
  ///
  /// In en, this message translates to:
  /// **'{count} items deleted'**
  String itemsDeletedSuccess(int count);

  /// Localized message for error deleting.
  ///
  /// In en, this message translates to:
  /// **'Error during deletion: {error}'**
  String errorDeleting(String error);

  /// Localized message for upload completed success.
  ///
  /// In en, this message translates to:
  /// **'Upload completed successfully'**
  String get uploadCompletedSuccess;

  /// Localized message for error uploading.
  ///
  /// In en, this message translates to:
  /// **'Error during upload: {error}'**
  String errorUploading(String error);

  /// Localized message for folder upload completed success.
  ///
  /// In en, this message translates to:
  /// **'Folder upload completed successfully'**
  String get folderUploadCompletedSuccess;

  /// Localized message for error folder uploading.
  ///
  /// In en, this message translates to:
  /// **'Error uploading folder: {error}'**
  String errorFolderUploading(String error);

  /// Localized message for files already in directory.
  ///
  /// In en, this message translates to:
  /// **'Files are already in this folder.'**
  String get filesAlreadyInDirectory;

  /// Localized message for drag drop transfer started.
  ///
  /// In en, this message translates to:
  /// **'{action} of {count} items to [{remote}] started...'**
  String dragDropTransferStarted(String action, int count, String remote);

  /// Localized message for error drag drop.
  ///
  /// In en, this message translates to:
  /// **'Error during drag-and-drop transfer: {error}'**
  String errorDragDrop(String error);

  /// Localized message for close selection.
  ///
  /// In en, this message translates to:
  /// **'Close selection'**
  String get closeSelection;

  /// Localized message for items selected count.
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String itemsSelectedCount(int count);

  /// Localized message for deselect all.
  ///
  /// In en, this message translates to:
  /// **'Deselect all'**
  String get deselectAll;

  /// Localized message for copy to remote.
  ///
  /// In en, this message translates to:
  /// **'Copy to {remote}'**
  String copyToRemote(String remote);

  /// Localized message for move to remote.
  ///
  /// In en, this message translates to:
  /// **'Move to {remote}'**
  String moveToRemote(String remote);

  /// Localized message for more actions.
  ///
  /// In en, this message translates to:
  /// **'More actions'**
  String get moreActions;

  /// Localized message for download selected.
  ///
  /// In en, this message translates to:
  /// **'Download selected'**
  String get downloadSelected;

  /// Localized message for copy to clipboard.
  ///
  /// In en, this message translates to:
  /// **'Copy to clipboard'**
  String get copyToClipboard;

  /// Localized message for cut to clipboard.
  ///
  /// In en, this message translates to:
  /// **'Cut to clipboard'**
  String get cutToClipboard;

  /// Localized message for select cloud.
  ///
  /// In en, this message translates to:
  /// **'Select Cloud'**
  String get selectCloud;

  /// Localized message for close search.
  ///
  /// In en, this message translates to:
  /// **'Close search'**
  String get closeSearch;

  /// Localized message for upload from device.
  ///
  /// In en, this message translates to:
  /// **'Upload from device'**
  String get uploadFromDevice;

  /// Localized message for more options.
  ///
  /// In en, this message translates to:
  /// **'More options'**
  String get moreOptions;

  /// Localized message for view grid.
  ///
  /// In en, this message translates to:
  /// **'Grid view'**
  String get viewGrid;

  /// Localized message for view list.
  ///
  /// In en, this message translates to:
  /// **'List view'**
  String get viewList;

  /// Localized message for multi selection.
  ///
  /// In en, this message translates to:
  /// **'Multiple selection'**
  String get multiSelection;

  /// Localized message for sort name asc.
  ///
  /// In en, this message translates to:
  /// **'Name (A-Z)'**
  String get sortNameAsc;

  /// Localized message for sort name desc.
  ///
  /// In en, this message translates to:
  /// **'Name (Z-A)'**
  String get sortNameDesc;

  /// Localized message for sort size desc.
  ///
  /// In en, this message translates to:
  /// **'Size (Large -> Small)'**
  String get sortSizeDesc;

  /// Localized message for sort size asc.
  ///
  /// In en, this message translates to:
  /// **'Size (Small -> Large)'**
  String get sortSizeAsc;

  /// Localized message for sort date desc.
  ///
  /// In en, this message translates to:
  /// **'Date (Newest first)'**
  String get sortDateDesc;

  /// Localized message for disable dual pane.
  ///
  /// In en, this message translates to:
  /// **'Disable Commander (Single Pane)'**
  String get disableDualPane;

  /// Localized message for enable dual pane.
  ///
  /// In en, this message translates to:
  /// **'Enable Commander (Dual Pane)'**
  String get enableDualPane;

  /// Localized message for items in clipboard.
  ///
  /// In en, this message translates to:
  /// **'{count} items in clipboard'**
  String itemsInClipboard(int count);

  /// Localized message for paste here.
  ///
  /// In en, this message translates to:
  /// **'Paste here'**
  String get pasteHere;

  /// Localized message for no results.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get noResults;

  /// Localized message for no matching results.
  ///
  /// In en, this message translates to:
  /// **'No files or folders match \"{query}\"'**
  String noMatchingResults(String query);

  /// Localized message for select acloud.
  ///
  /// In en, this message translates to:
  /// **'Select a Cloud'**
  String get selectACloud;

  /// Localized message for select cloud description.
  ///
  /// In en, this message translates to:
  /// **'Select a cloud provider from the menu above to view and explore your remote files.'**
  String get selectCloudDescription;

  /// Localized message for options for item.
  ///
  /// In en, this message translates to:
  /// **'Options for {name}'**
  String optionsForItem(String name);

  /// Localized message for select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// Localized message for open with system app.
  ///
  /// In en, this message translates to:
  /// **'Open with system app'**
  String get openWithSystemApp;

  /// Localized message for download to local.
  ///
  /// In en, this message translates to:
  /// **'Download to local'**
  String get downloadToLocal;

  /// Localized message for cut.
  ///
  /// In en, this message translates to:
  /// **'Cut (Move)'**
  String get cut;

  /// Localized message for copy path.
  ///
  /// In en, this message translates to:
  /// **'Copy path'**
  String get copyPath;

  /// Localized message for info.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get info;

  /// Localized message for generating share link.
  ///
  /// In en, this message translates to:
  /// **'Generating share link for \"{name}\"...'**
  String generatingShareLink(String name);

  /// Localized message for error public link.
  ///
  /// In en, this message translates to:
  /// **'Public link error: {error}'**
  String errorPublicLink(String error);

  /// Localized message for no link generated.
  ///
  /// In en, this message translates to:
  /// **'No link generated by provider.'**
  String get noLinkGenerated;

  /// Localized message for error downloading.
  ///
  /// In en, this message translates to:
  /// **'Error downloading: {error}'**
  String errorDownloading(String error);

  /// Localized message for rename folder title.
  ///
  /// In en, this message translates to:
  /// **'Rename folder'**
  String get renameFolderTitle;

  /// Localized message for rename file title.
  ///
  /// In en, this message translates to:
  /// **'Rename file'**
  String get renameFileTitle;

  /// Localized message for error renaming.
  ///
  /// In en, this message translates to:
  /// **'Error renaming: {error}'**
  String errorRenaming(String error);

  /// Localized message for path copied to clipboard.
  ///
  /// In en, this message translates to:
  /// **'Path copied to clipboard'**
  String get pathCopiedToClipboard;

  /// Localized message for item details path.
  ///
  /// In en, this message translates to:
  /// **'Path: {path}'**
  String itemDetailsPath(String path);

  /// Localized message for item details type.
  ///
  /// In en, this message translates to:
  /// **'Type: {type}'**
  String itemDetailsType(String type);

  /// Localized message for item details size.
  ///
  /// In en, this message translates to:
  /// **'Size: {size}'**
  String itemDetailsSize(String size);

  /// Localized message for item details modified.
  ///
  /// In en, this message translates to:
  /// **'Modified date: {date}'**
  String itemDetailsModified(String date);

  /// Localized message for folder.
  ///
  /// In en, this message translates to:
  /// **'Folder'**
  String get folder;

  /// Localized message for file.
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get file;

  /// Localized message for select cloud first left.
  ///
  /// In en, this message translates to:
  /// **'Select a cloud in the left pane first.'**
  String get selectCloudFirstLeft;

  /// Localized message for select cloud first right.
  ///
  /// In en, this message translates to:
  /// **'Select a cloud in the right pane first.'**
  String get selectCloudFirstRight;

  /// Localized message for select destination cloud left.
  ///
  /// In en, this message translates to:
  /// **'Select a destination cloud in the left pane first.'**
  String get selectDestinationCloudLeft;

  /// Localized message for select destination cloud right.
  ///
  /// In en, this message translates to:
  /// **'Select a destination cloud in the right pane first.'**
  String get selectDestinationCloudRight;

  /// Localized message for no files to transfer.
  ///
  /// In en, this message translates to:
  /// **'No files present or selected to transfer.'**
  String get noFilesToTransfer;

  /// Localized message for transfer started.
  ///
  /// In en, this message translates to:
  /// **'{action} of {count} items from [{src}] to [{dst}] started...'**
  String transferStarted(String action, int count, String src, String dst);

  /// Localized message for swap panes tooltip.
  ///
  /// In en, this message translates to:
  /// **'Swap panes (<->)'**
  String get swapPanesTooltip;

  /// Localized message for refresh both panes tooltip.
  ///
  /// In en, this message translates to:
  /// **'Refresh both panes'**
  String get refreshBothPanesTooltip;

  /// Localized message for copy right.
  ///
  /// In en, this message translates to:
  /// **'Copy to right ->'**
  String get copyRight;

  /// Localized message for move right.
  ///
  /// In en, this message translates to:
  /// **'Move to right ->'**
  String get moveRight;

  /// Localized message for copy left.
  ///
  /// In en, this message translates to:
  /// **'<- Copy to left'**
  String get copyLeft;

  /// Localized message for move left.
  ///
  /// In en, this message translates to:
  /// **'<- Move to left'**
  String get moveLeft;

  /// Localized message for copy right with count.
  ///
  /// In en, this message translates to:
  /// **'Copy right ({count}) ->'**
  String copyRightWithCount(int count);

  /// Localized message for move right with count.
  ///
  /// In en, this message translates to:
  /// **'Move right ({count}) ->'**
  String moveRightWithCount(int count);

  /// Localized message for copy left with count.
  ///
  /// In en, this message translates to:
  /// **'<- Copy left ({count})'**
  String copyLeftWithCount(int count);

  /// Localized message for move left with count.
  ///
  /// In en, this message translates to:
  /// **'<- Move left ({count})'**
  String moveLeftWithCount(int count);

  /// Localized message for delete rule title.
  ///
  /// In en, this message translates to:
  /// **'Delete Rule'**
  String get deleteRuleTitle;

  /// Localized message for delete rule prompt.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete sync rule \"{name}\"? Files on your device and in the cloud will not be deleted.'**
  String deleteRulePrompt(String name);

  /// Localized message for sync all.
  ///
  /// In en, this message translates to:
  /// **'Sync All'**
  String get syncAll;

  /// Localized message for new rule tooltip.
  ///
  /// In en, this message translates to:
  /// **'New rule'**
  String get newRuleTooltip;

  /// Localized message for backup banner title.
  ///
  /// In en, this message translates to:
  /// **'Continuous Backup & Cloud Sync'**
  String get backupBannerTitle;

  /// Localized message for backup banner subtitle.
  ///
  /// In en, this message translates to:
  /// **'Configure scheduled synchronizations between local folders and cloud remotes.'**
  String get backupBannerSubtitle;

  /// Localized message for no active rules.
  ///
  /// In en, this message translates to:
  /// **'No Active Rules'**
  String get noActiveRules;

  /// Localized message for no active rules subtitle.
  ///
  /// In en, this message translates to:
  /// **'Create your first rule to run automatic backups from your phone to Google Drive, Dropbox, SFTP or any other cloud.'**
  String get noActiveRulesSubtitle;

  /// Localized message for create new rule.
  ///
  /// In en, this message translates to:
  /// **'Create New Rule'**
  String get createNewRule;

  /// Localized message for rule options tooltip.
  ///
  /// In en, this message translates to:
  /// **'Rule options'**
  String get ruleOptionsTooltip;

  /// Localized message for sync now.
  ///
  /// In en, this message translates to:
  /// **'Sync now'**
  String get syncNow;

  /// Localized message for status waiting.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statusWaiting;

  /// Localized message for status in progress.
  ///
  /// In en, this message translates to:
  /// **'In progress...'**
  String get statusInProgress;

  /// Localized message for status completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statusCompleted;

  /// Localized message for status failed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get statusFailed;

  /// Localized message for edit rule title.
  ///
  /// In en, this message translates to:
  /// **'Edit Backup Rule'**
  String get editRuleTitle;

  /// Localized message for new rule title.
  ///
  /// In en, this message translates to:
  /// **'New Synchronization Rule'**
  String get newRuleTitle;

  /// Localized message for rule dialog subtitle.
  ///
  /// In en, this message translates to:
  /// **'Configure automatic backup between a local folder and the cloud.'**
  String get ruleDialogSubtitle;

  /// Localized message for rule name optional.
  ///
  /// In en, this message translates to:
  /// **'Rule Name (optional)'**
  String get ruleNameOptional;

  /// Localized message for rule name hint.
  ///
  /// In en, this message translates to:
  /// **'e.g. DCIM Photo Backup or Work Documents'**
  String get ruleNameHint;

  /// Localized message for source local folder.
  ///
  /// In en, this message translates to:
  /// **'Local Source Folder'**
  String get sourceLocalFolder;

  /// Localized message for source local folder hint.
  ///
  /// In en, this message translates to:
  /// **'/storage/emulated/0/DCIM or /home/user/Pictures'**
  String get sourceLocalFolderHint;

  /// Localized message for browse folders.
  ///
  /// In en, this message translates to:
  /// **'Browse folders'**
  String get browseFolders;

  /// Localized message for select local folder error.
  ///
  /// In en, this message translates to:
  /// **'Please enter or select a local folder'**
  String get selectLocalFolderError;

  /// Localized message for no clouds configured sync.
  ///
  /// In en, this message translates to:
  /// **'No cloud configured. Configure a cloud account from Home before continuing.'**
  String get noCloudsConfiguredSync;

  /// Localized message for remote destination path.
  ///
  /// In en, this message translates to:
  /// **'Remote Destination Path'**
  String get remoteDestinationPath;

  /// Localized message for sync mode.
  ///
  /// In en, this message translates to:
  /// **'Sync Mode'**
  String get syncMode;

  /// Localized message for sync mode copy.
  ///
  /// In en, this message translates to:
  /// **'Incremental Backup'**
  String get syncModeCopy;

  /// Localized message for sync mode copy desc.
  ///
  /// In en, this message translates to:
  /// **'Uploads new and modified files, preserving existing cloud files.'**
  String get syncModeCopyDesc;

  /// Localized message for sync mode sync.
  ///
  /// In en, this message translates to:
  /// **'Mirror Synchronization'**
  String get syncModeSync;

  /// Localized message for sync mode sync desc.
  ///
  /// In en, this message translates to:
  /// **'Makes the remote destination identical to the local folder (deletions locally are deleted on cloud).'**
  String get syncModeSyncDesc;

  /// Localized message for sync frequency.
  ///
  /// In en, this message translates to:
  /// **'Execution Frequency'**
  String get syncFrequency;

  /// Localized message for freq manual.
  ///
  /// In en, this message translates to:
  /// **'Manual (on demand only)'**
  String get freqManual;

  /// Localized message for freq15 min.
  ///
  /// In en, this message translates to:
  /// **'Every 15 minutes'**
  String get freq15Min;

  /// Localized message for freq30 min.
  ///
  /// In en, this message translates to:
  /// **'Every 30 minutes'**
  String get freq30Min;

  /// Localized message for freq hourly.
  ///
  /// In en, this message translates to:
  /// **'Every hour'**
  String get freqHourly;

  /// Localized message for freq6 hours.
  ///
  /// In en, this message translates to:
  /// **'Every 6 hours'**
  String get freq6Hours;

  /// Localized message for freq12 hours.
  ///
  /// In en, this message translates to:
  /// **'Every 12 hours'**
  String get freq12Hours;

  /// Localized message for freq daily.
  ///
  /// In en, this message translates to:
  /// **'Every day (24 hours)'**
  String get freqDaily;

  /// Localized message for activate rule immediately.
  ///
  /// In en, this message translates to:
  /// **'Activate rule immediately'**
  String get activateRuleImmediately;

  /// Localized message for activate rule immediately desc.
  ///
  /// In en, this message translates to:
  /// **'Sync will run in background according to the specified interval'**
  String get activateRuleImmediatelyDesc;

  /// Localized message for update rule.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get updateRule;

  /// Localized message for save rule.
  ///
  /// In en, this message translates to:
  /// **'Save Rule'**
  String get saveRule;

  /// Localized message for select cloud provider.
  ///
  /// In en, this message translates to:
  /// **'Select Cloud Provider:'**
  String get selectCloudProvider;

  /// Localized message for cloud account name.
  ///
  /// In en, this message translates to:
  /// **'Cloud Account Name'**
  String get cloudAccountName;

  /// Localized message for cloud account name hint.
  ///
  /// In en, this message translates to:
  /// **'e.g. GoogleDrive, WorkDropbox (no spaces)'**
  String get cloudAccountNameHint;

  /// Localized message for enter name error.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get enterNameError;

  /// Localized message for no spaces or colons.
  ///
  /// In en, this message translates to:
  /// **'Spaces and \":\" are not allowed'**
  String get noSpacesOrColons;

  /// Localized message for oauth mode.
  ///
  /// In en, this message translates to:
  /// **'Client ID Mode (OAuth2)'**
  String get oauthMode;

  /// Localized message for oauth official.
  ///
  /// In en, this message translates to:
  /// **'UnifyCloud (Official / Recommended)'**
  String get oauthOfficial;

  /// Localized message for oauth rclone.
  ///
  /// In en, this message translates to:
  /// **'Rclone (Not recommended - Shared quota)'**
  String get oauthRclone;

  /// Localized message for oauth custom.
  ///
  /// In en, this message translates to:
  /// **'Personal Client ID (Advanced)'**
  String get oauthCustom;

  /// Localized message for official oauth title.
  ///
  /// In en, this message translates to:
  /// **'Official UnifyCloud Credentials'**
  String get officialOauthTitle;

  /// Localized message for official oauth desc.
  ///
  /// In en, this message translates to:
  /// **'Pre-configured credentials to connect immediately with dedicated quota and maximum speed.'**
  String get officialOauthDesc;

  /// Localized message for rclone oauth desc.
  ///
  /// In en, this message translates to:
  /// **'Shared open-source Rclone keys. May encounter rate-limits or temporary Google 403 errors.'**
  String get rcloneOauthDesc;

  /// Localized message for custom client id.
  ///
  /// In en, this message translates to:
  /// **'Client ID'**
  String get customClientId;

  /// Localized message for custom client secret.
  ///
  /// In en, this message translates to:
  /// **'Client Secret'**
  String get customClientSecret;

  /// Localized message for select vault destination.
  ///
  /// In en, this message translates to:
  /// **'Select destination cloud for Vault'**
  String get selectVaultDestination;

  /// Localized message for vault password required.
  ///
  /// In en, this message translates to:
  /// **'Vault encryption password is required'**
  String get vaultPasswordRequired;

  /// Localized message for vault passwords do not match.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get vaultPasswordsDoNotMatch;

  /// Localized message for error adding remote.
  ///
  /// In en, this message translates to:
  /// **'Error adding remote: {error}'**
  String errorAddingRemote(String error);

  /// Localized message for file name encryption.
  ///
  /// In en, this message translates to:
  /// **'File Name Encryption'**
  String get fileNameEncryption;

  /// Localized message for encrypt standard.
  ///
  /// In en, this message translates to:
  /// **'Standard (Fully encrypted file names - Recommended)'**
  String get encryptStandard;

  /// Localized message for encrypt obscure.
  ///
  /// In en, this message translates to:
  /// **'Simple Obfuscation (Preserves extensions)'**
  String get encryptObscure;

  /// Localized message for encrypt off.
  ///
  /// In en, this message translates to:
  /// **'Disabled (Visible file names)'**
  String get encryptOff;

  /// Localized message for encrypt folder names.
  ///
  /// In en, this message translates to:
  /// **'Also encrypt folder names'**
  String get encryptFolderNames;

  /// Localized message for encrypt folder names desc.
  ///
  /// In en, this message translates to:
  /// **'Completely conceals directory structure on the cloud'**
  String get encryptFolderNamesDesc;

  /// Localized message for connect cloud.
  ///
  /// In en, this message translates to:
  /// **'Connect Cloud'**
  String get connectCloud;

  /// Localized message for reopen auth.
  ///
  /// In en, this message translates to:
  /// **'Reopen'**
  String get reopenAuth;

  /// Localized message for link copied to clipboard.
  ///
  /// In en, this message translates to:
  /// **'Link copied to clipboard!'**
  String get linkCopiedToClipboard;

  /// Localized message for error open browser generic.
  ///
  /// In en, this message translates to:
  /// **'Unable to open browser: {error}'**
  String errorOpenBrowserGeneric(String error);

  /// Localized message for shareable link title.
  ///
  /// In en, this message translates to:
  /// **'Shareable Link'**
  String get shareableLinkTitle;

  /// Localized message for share link access description.
  ///
  /// In en, this message translates to:
  /// **'Anyone with this link will be able to access {item}:'**
  String shareLinkAccessDescription(String item);

  /// Localized message for open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// Localized message for active transfers count.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 active transfer} other{{count} active transfers}}'**
  String activeTransfersCount(int count);

  /// Localized message for transfers queue count.
  ///
  /// In en, this message translates to:
  /// **'Transfer Queue ({count})'**
  String transfersQueueCount(int count);

  /// Localized message for no transfers in progress.
  ///
  /// In en, this message translates to:
  /// **'No transfers in progress'**
  String get noTransfersInProgress;

  /// Localized message for transfers empty subtitle.
  ///
  /// In en, this message translates to:
  /// **'All downloaded or uploaded files will appear here'**
  String get transfersEmptySubtitle;

  /// Localized message for cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// Localized message for app locked title.
  ///
  /// In en, this message translates to:
  /// **'Application Locked'**
  String get appLockedTitle;

  /// Localized message for unlock with biometrics.
  ///
  /// In en, this message translates to:
  /// **'Unlock with Biometrics'**
  String get unlockWithBiometrics;

  /// Localized message for pin must be6 digits.
  ///
  /// In en, this message translates to:
  /// **'PIN must be exactly 6 digits'**
  String get pinMustBe6Digits;

  /// Localized message for pin incorrect.
  ///
  /// In en, this message translates to:
  /// **'Incorrect PIN. Try again.'**
  String get pinIncorrect;

  /// Localized message for pins do not match.
  ///
  /// In en, this message translates to:
  /// **'PINs do not match. Try again.'**
  String get pinsDoNotMatch;

  /// Localized message for pin step old.
  ///
  /// In en, this message translates to:
  /// **'Enter your current PIN to continue.'**
  String get pinStepOld;

  /// Localized message for pin step new.
  ///
  /// In en, this message translates to:
  /// **'Enter your new 6-digit security PIN.'**
  String get pinStepNew;

  /// Localized message for pin step confirm.
  ///
  /// In en, this message translates to:
  /// **'Re-enter the new PIN to confirm.'**
  String get pinStepConfirm;

  /// Localized message for pin step verify.
  ///
  /// In en, this message translates to:
  /// **'Enter your PIN to confirm the operation.'**
  String get pinStepVerify;

  /// Localized message for pin title setup.
  ///
  /// In en, this message translates to:
  /// **'Setup Security PIN'**
  String get pinTitleSetup;

  /// Localized message for pin title change.
  ///
  /// In en, this message translates to:
  /// **'Change Security PIN'**
  String get pinTitleChange;

  /// Localized message for pin title verify.
  ///
  /// In en, this message translates to:
  /// **'Security Verification'**
  String get pinTitleVerify;

  /// Localized message for pin continue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get pinContinue;

  /// Localized message for error details.
  ///
  /// In en, this message translates to:
  /// **'Error Details'**
  String get errorDetails;

  /// Localized message for error details copied.
  ///
  /// In en, this message translates to:
  /// **'Error details copied to clipboard'**
  String get errorDetailsCopied;

  /// Localized message for collapse.
  ///
  /// In en, this message translates to:
  /// **'Collapse'**
  String get collapse;

  /// Localized message for expand.
  ///
  /// In en, this message translates to:
  /// **'Expand'**
  String get expand;

  /// Localized message for copy error.
  ///
  /// In en, this message translates to:
  /// **'Copy error'**
  String get copyError;

  /// Localized message for error network.
  ///
  /// In en, this message translates to:
  /// **'No connection or unstable network. Check your internet connection and try again.'**
  String get errorNetwork;

  /// Localized message for error disk space.
  ///
  /// In en, this message translates to:
  /// **'Insufficient storage space or disk full. Free up memory to continue.'**
  String get errorDiskSpace;

  /// Localized message for error auth expired.
  ///
  /// In en, this message translates to:
  /// **'Session or token expired/revoked. Reconnect your account.'**
  String get errorAuthExpired;

  /// Localized message for error not found.
  ///
  /// In en, this message translates to:
  /// **'Item or folder not found on cloud provider.'**
  String get errorNotFound;

  /// Localized message for error permission denied.
  ///
  /// In en, this message translates to:
  /// **'Permission denied for this operation on cloud.'**
  String get errorPermissionDenied;

  /// Localized message for error generic.
  ///
  /// In en, this message translates to:
  /// **'An error occurred during the operation.'**
  String get errorGeneric;

  /// Localized message for desktop and system.
  ///
  /// In en, this message translates to:
  /// **'Desktop & System'**
  String get desktopAndSystem;

  /// Localized message for desktop and system subtitle.
  ///
  /// In en, this message translates to:
  /// **'Startup behavior, background execution, and system tray'**
  String get desktopAndSystemSubtitle;

  /// Localized message for autostart on boot.
  ///
  /// In en, this message translates to:
  /// **'Start on system boot'**
  String get autostartOnBoot;

  /// Localized message for autostart on boot subtitle.
  ///
  /// In en, this message translates to:
  /// **'Automatically launch UnifyCloud in the background on login'**
  String get autostartOnBootSubtitle;

  /// Localized message for minimize to tray.
  ///
  /// In en, this message translates to:
  /// **'Minimize to system tray'**
  String get minimizeToTray;

  /// Localized message for minimize to tray subtitle.
  ///
  /// In en, this message translates to:
  /// **'Keep UnifyCloud running in the background when the window is closed'**
  String get minimizeToTraySubtitle;

  /// Localized message for tray status idle.
  ///
  /// In en, this message translates to:
  /// **'Idle (No active transfers)'**
  String get trayStatusIdle;

  /// Localized message for tray status active.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 active transfer ({speed})} other{{count} active transfers ({speed})}}'**
  String trayStatusActive(int count, String speed);

  /// Localized message for tray show window.
  ///
  /// In en, this message translates to:
  /// **'Show UnifyCloud'**
  String get trayShowWindow;

  /// Localized message for tray hide window.
  ///
  /// In en, this message translates to:
  /// **'Hide to system tray'**
  String get trayHideWindow;

  /// Localized message for tray quit.
  ///
  /// In en, this message translates to:
  /// **'Quit UnifyCloud'**
  String get trayQuit;

  /// Localized message for tray tooltip.
  ///
  /// In en, this message translates to:
  /// **'UnifyCloud - Cloud Storage Manager'**
  String get trayTooltip;

  /// Localized message for tray status line.
  ///
  /// In en, this message translates to:
  /// **'Status: {status}'**
  String trayStatusLine(String status);

  /// Localized message for bg notification initial title.
  ///
  /// In en, this message translates to:
  /// **'UnifyCloud Transfers'**
  String get bgNotificationInitialTitle;

  /// Localized message for bg notification initial content.
  ///
  /// In en, this message translates to:
  /// **'Managing transfers in background...'**
  String get bgNotificationInitialContent;

  /// Localized message for bg notification progress content.
  ///
  /// In en, this message translates to:
  /// **'{speed} • {percentage}% completed'**
  String bgNotificationProgressContent(String speed, int percentage);

  /// Localized message for bg notification idle content.
  ///
  /// In en, this message translates to:
  /// **'All transfers have been completed.'**
  String get bgNotificationIdleContent;

  /// Localized message for pin title confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm PIN Code'**
  String get pinTitleConfirm;

  /// Localized message for pin title enter current.
  ///
  /// In en, this message translates to:
  /// **'Enter Current PIN'**
  String get pinTitleEnterCurrent;

  /// Localized message for pin title new.
  ///
  /// In en, this message translates to:
  /// **'New PIN Code'**
  String get pinTitleNew;

  /// Localized message for pin title confirm new.
  ///
  /// In en, this message translates to:
  /// **'Confirm New PIN'**
  String get pinTitleConfirmNew;

  /// Localized message for pin step setup new.
  ///
  /// In en, this message translates to:
  /// **'Create a 6-digit numeric code to protect the app.'**
  String get pinStepSetupNew;

  /// Localized message for pin step setup confirm.
  ///
  /// In en, this message translates to:
  /// **'Re-enter the PIN code to confirm it.'**
  String get pinStepSetupConfirm;

  /// Localized message for pin too many attempts.
  ///
  /// In en, this message translates to:
  /// **'Too many failed attempts. Try again in {seconds}s.'**
  String pinTooManyAttempts(int seconds);

  /// Localized message for pin verification error.
  ///
  /// In en, this message translates to:
  /// **'Verification error: {error}'**
  String pinVerificationError(String error);

  /// Localized message for biometric auth reason.
  ///
  /// In en, this message translates to:
  /// **'Authenticate to access UnifyCloud'**
  String get biometricAuthReason;

  /// Localized message for sync rules count.
  ///
  /// In en, this message translates to:
  /// **'Synchronization Rules ({count})'**
  String syncRulesCount(int count);

  /// Localized message for no sync rules empty desc.
  ///
  /// In en, this message translates to:
  /// **'Configure a rule to run automatic backups at regular intervals or on demand with the \"Sync now\" button.'**
  String get noSyncRulesEmptyDesc;

  /// Localized message for never synced.
  ///
  /// In en, this message translates to:
  /// **'Never synced'**
  String get neverSynced;

  /// Localized message for last sync now.
  ///
  /// In en, this message translates to:
  /// **'Last sync: just now'**
  String get lastSyncNow;

  /// Localized message for last sync minutes ago.
  ///
  /// In en, this message translates to:
  /// **'Last sync: {minutes} min ago'**
  String lastSyncMinutesAgo(int minutes);

  /// Localized message for last sync hours ago.
  ///
  /// In en, this message translates to:
  /// **'Last sync: {hours} hr ago'**
  String lastSyncHoursAgo(int hours);

  /// Localized message for last sync date.
  ///
  /// In en, this message translates to:
  /// **'Last sync: {date}'**
  String lastSyncDate(String date);

  /// Localized message for local folder not found.
  ///
  /// In en, this message translates to:
  /// **'Local folder not found: {path}'**
  String localFolderNotFound(String path);

  /// Localized message for select destination cloud error.
  ///
  /// In en, this message translates to:
  /// **'Select a destination cloud'**
  String get selectDestinationCloudError;

  /// Localized message for remote destination path hint.
  ///
  /// In en, this message translates to:
  /// **'Backup/Photos or /'**
  String get remoteDestinationPathHint;

  /// Localized message for enter destination path error.
  ///
  /// In en, this message translates to:
  /// **'Enter a destination path'**
  String get enterDestinationPathError;

  /// Localized message for activate rule manual only desc.
  ///
  /// In en, this message translates to:
  /// **'When disabled, the rule can only be started manually.'**
  String get activateRuleManualOnlyDesc;

  /// Localized message for preset photos dcim.
  ///
  /// In en, this message translates to:
  /// **'Photos (DCIM)'**
  String get presetPhotosDcim;

  /// Localized message for preset pictures.
  ///
  /// In en, this message translates to:
  /// **'Pictures'**
  String get presetPictures;

  /// Localized message for preset documents.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get presetDocuments;

  /// Localized message for preset downloads.
  ///
  /// In en, this message translates to:
  /// **'Downloads'**
  String get presetDownloads;

  /// Localized message for default backup rule name.
  ///
  /// In en, this message translates to:
  /// **'Backup {name}'**
  String defaultBackupRuleName(String name);

  /// Localized message for default sync rule name.
  ///
  /// In en, this message translates to:
  /// **'Sync {name}'**
  String defaultSyncRuleName(String name);

  /// Localized message for folder fallback name.
  ///
  /// In en, this message translates to:
  /// **'Folder'**
  String get folderFallbackName;

  /// Localized message for provider local name.
  ///
  /// In en, this message translates to:
  /// **'Local Disk'**
  String get providerLocalName;

  /// Localized message for provider crypt name.
  ///
  /// In en, this message translates to:
  /// **'E2E Encryption (Crypt)'**
  String get providerCryptName;

  /// Localized message for provider subtitle drive.
  ///
  /// In en, this message translates to:
  /// **'OAuth2 cloud storage'**
  String get providerSubtitleDrive;

  /// Localized message for provider subtitle dropbox.
  ///
  /// In en, this message translates to:
  /// **'File sync and share'**
  String get providerSubtitleDropbox;

  /// Localized message for provider subtitle one drive.
  ///
  /// In en, this message translates to:
  /// **'Personal and business storage'**
  String get providerSubtitleOneDrive;

  /// Localized message for provider subtitle webdav.
  ///
  /// In en, this message translates to:
  /// **'Self-hosted or corporate cloud'**
  String get providerSubtitleWebdav;

  /// Localized message for provider subtitle sftp.
  ///
  /// In en, this message translates to:
  /// **'Secure remote server'**
  String get providerSubtitleSftp;

  /// Localized message for provider subtitle s3.
  ///
  /// In en, this message translates to:
  /// **'Object storage bucket'**
  String get providerSubtitleS3;

  /// Localized message for provider subtitle local.
  ///
  /// In en, this message translates to:
  /// **'Local system folder'**
  String get providerSubtitleLocal;

  /// Localized message for provider subtitle crypt.
  ///
  /// In en, this message translates to:
  /// **'Encrypt files and names with AES-256 on any cloud'**
  String get providerSubtitleCrypt;

  /// Localized message for no unify cloud client id.
  ///
  /// In en, this message translates to:
  /// **'No UnifyCloud Client ID available for this provider. Use Rclone or a personal Client ID.'**
  String get noUnifyCloudClientId;

  /// Localized message for no rclone client id.
  ///
  /// In en, this message translates to:
  /// **'No Rclone Client ID available for this provider. Use a personal Client ID.'**
  String get noRcloneClientId;

  /// Localized message for enter client id for oauth.
  ///
  /// In en, this message translates to:
  /// **'Enter the Client ID to start OAuth2 login'**
  String get enterClientIdForOauth;

  /// Localized message for oauth starting local server.
  ///
  /// In en, this message translates to:
  /// **'Starting local login server...'**
  String get oauthStartingLocalServer;

  /// Localized message for oauth browser opened.
  ///
  /// In en, this message translates to:
  /// **'Browser opened. Waiting for authorization...'**
  String get oauthBrowserOpened;

  /// Localized message for oauth browser not supported.
  ///
  /// In en, this message translates to:
  /// **'Automatic opening not supported. Open or copy the link below in your browser:'**
  String get oauthBrowserNotSupported;

  /// Localized message for oauth completed success.
  ///
  /// In en, this message translates to:
  /// **'Authentication completed successfully!'**
  String get oauthCompletedSuccess;

  /// Localized message for oauth error prefix.
  ///
  /// In en, this message translates to:
  /// **'OAuth Error: {error}'**
  String oauthErrorPrefix(String error);

  /// Localized message for official oauth action desc.
  ///
  /// In en, this message translates to:
  /// **'Fast verified login with dedicated credentials for UnifyCloud. Click \"Start Browser Login\" to authenticate without manual setup.'**
  String get officialOauthActionDesc;

  /// Localized message for rclone oauth title.
  ///
  /// In en, this message translates to:
  /// **'Rclone Public Client ID (Not Recommended)'**
  String get rcloneOauthTitle;

  /// Localized message for rclone oauth warning desc.
  ///
  /// In en, this message translates to:
  /// **'Uses legacy public keys shared across all Rclone users. May experience slowdowns or rate limits due to shared quotas.'**
  String get rcloneOauthWarningDesc;

  /// Localized message for custom oauth guide info.
  ///
  /// In en, this message translates to:
  /// **'Create your own IDs independently: see docs/oauth_setup_guide.md for a step-by-step guide.'**
  String get customOauthGuideInfo;

  /// Localized message for custom google client id label.
  ///
  /// In en, this message translates to:
  /// **'Personal Google Client ID'**
  String get customGoogleClientIdLabel;

  /// Localized message for custom oauth client id label.
  ///
  /// In en, this message translates to:
  /// **'Personal Client ID (OAuth2)'**
  String get customOauthClientIdLabel;

  /// Localized message for custom google client id hint.
  ///
  /// In en, this message translates to:
  /// **'e.g. xxxxx.apps.googleusercontent.com'**
  String get customGoogleClientIdHint;

  /// Localized message for enter your client id error.
  ///
  /// In en, this message translates to:
  /// **'Enter your Client ID'**
  String get enterYourClientIdError;

  /// Localized message for custom client secret optional.
  ///
  /// In en, this message translates to:
  /// **'Client Secret (Optional)'**
  String get customClientSecretOptional;

  /// Localized message for authenticating.
  ///
  /// In en, this message translates to:
  /// **'Authenticating...'**
  String get authenticating;

  /// Localized message for start browser login.
  ///
  /// In en, this message translates to:
  /// **'Start Browser Login (OAuth2)'**
  String get startBrowserLogin;

  /// Localized message for browser launched or copy.
  ///
  /// In en, this message translates to:
  /// **'Browser launched (or copy the link below)'**
  String get browserLaunchedOrCopy;

  /// Localized message for copy link to complete login.
  ///
  /// In en, this message translates to:
  /// **'Copy the link to complete login in your browser'**
  String get copyLinkToCompleteLogin;

  /// Localized message for copy link and paste hint.
  ///
  /// In en, this message translates to:
  /// **'Link copied to clipboard! Paste it into your browser.'**
  String get copyLinkAndPasteHint;

  /// Localized message for token json label.
  ///
  /// In en, this message translates to:
  /// **'Token JSON (generated or pasted)'**
  String get tokenJsonLabel;

  /// Localized message for webdav url label.
  ///
  /// In en, this message translates to:
  /// **'WebDAV / Nextcloud URL'**
  String get webdavUrlLabel;

  /// Localized message for s3 endpoint label.
  ///
  /// In en, this message translates to:
  /// **'S3 Endpoint'**
  String get s3EndpointLabel;

  /// Localized message for sftp host label.
  ///
  /// In en, this message translates to:
  /// **'SFTP Host / Server'**
  String get sftpHostLabel;

  /// Localized message for required field error.
  ///
  /// In en, this message translates to:
  /// **'Required field'**
  String get requiredFieldError;

  /// Localized message for s3 access key id.
  ///
  /// In en, this message translates to:
  /// **'Access Key ID'**
  String get s3AccessKeyId;

  /// Localized message for username label.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get usernameLabel;

  /// Localized message for s3 secret access key.
  ///
  /// In en, this message translates to:
  /// **'Secret Access Key'**
  String get s3SecretAccessKey;

  /// Localized message for password label.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// Localized message for local provider info.
  ///
  /// In en, this message translates to:
  /// **'The local provider lets you browse and copy files to/from your device\'s filesystem.'**
  String get localProviderInfo;

  /// Localized message for e2e encryption title.
  ///
  /// In en, this message translates to:
  /// **'Client-Side End-to-End Encryption (AES-256)'**
  String get e2eEncryptionTitle;

  /// Localized message for e2e encryption desc.
  ///
  /// In en, this message translates to:
  /// **'Files and their names are encrypted on your device before being uploaded to the destination cloud. Not even the cloud provider can read them.'**
  String get e2eEncryptionDesc;

  /// Localized message for no target cloud for vault.
  ///
  /// In en, this message translates to:
  /// **'No destination cloud available. Connect another cloud first (e.g. Google Drive, OneDrive, or Local Disk) to create an encrypted Vault on it.'**
  String get noTargetCloudForVault;

  /// Localized message for vault target cloud label.
  ///
  /// In en, this message translates to:
  /// **'Destination Cloud *'**
  String get vaultTargetCloudLabel;

  /// Localized message for vault target cloud helper.
  ///
  /// In en, this message translates to:
  /// **'The cloud where encrypted files will be stored'**
  String get vaultTargetCloudHelper;

  /// Localized message for vault target path label.
  ///
  /// In en, this message translates to:
  /// **'Destination Path or Folder'**
  String get vaultTargetPathLabel;

  /// Localized message for vault target path hint.
  ///
  /// In en, this message translates to:
  /// **'e.g. vault or secret_data'**
  String get vaultTargetPathHint;

  /// Localized message for vault target path helper.
  ///
  /// In en, this message translates to:
  /// **'Folder on the remote cloud where encrypted files will be saved (optional)'**
  String get vaultTargetPathHelper;

  /// Localized message for vault master password label.
  ///
  /// In en, this message translates to:
  /// **'Encryption Password (Master Password) *'**
  String get vaultMasterPasswordLabel;

  /// Localized message for vault master password helper.
  ///
  /// In en, this message translates to:
  /// **'Keep it safe: without this password files cannot be recovered'**
  String get vaultMasterPasswordHelper;

  /// Localized message for vault enter password error.
  ///
  /// In en, this message translates to:
  /// **'Enter the encryption password'**
  String get vaultEnterPasswordError;

  /// Localized message for vault confirm password required.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password *'**
  String get vaultConfirmPasswordRequired;

  /// Localized message for vault confirm password error.
  ///
  /// In en, this message translates to:
  /// **'Confirm the password'**
  String get vaultConfirmPasswordError;

  /// Localized message for vault salt optional label.
  ///
  /// In en, this message translates to:
  /// **'Salt / Secondary Password (Optional)'**
  String get vaultSaltOptionalLabel;

  /// Localized message for vault salt helper.
  ///
  /// In en, this message translates to:
  /// **'Adds extra protection against brute-force attacks'**
  String get vaultSaltHelper;

  /// Localized message for oauth port occupied.
  ///
  /// In en, this message translates to:
  /// **'Port {port} is already in use by another process. Close any open Rclone or browser sessions and try again.'**
  String oauthPortOccupied(int port);

  /// Localized message for oauth html success title.
  ///
  /// In en, this message translates to:
  /// **'UnifyCloud - Authenticated'**
  String get oauthHtmlSuccessTitle;

  /// Localized message for oauth html success heading.
  ///
  /// In en, this message translates to:
  /// **'Authentication successful!'**
  String get oauthHtmlSuccessHeading;

  /// Localized message for oauth html success body.
  ///
  /// In en, this message translates to:
  /// **'You can close this tab and return to the UnifyCloud application.'**
  String get oauthHtmlSuccessBody;

  /// Localized message for oauth html error title.
  ///
  /// In en, this message translates to:
  /// **'UnifyCloud - Error'**
  String get oauthHtmlErrorTitle;

  /// Localized message for oauth html error heading.
  ///
  /// In en, this message translates to:
  /// **'Authentication error'**
  String get oauthHtmlErrorHeading;

  /// Localized message for oauth invalid state.
  ///
  /// In en, this message translates to:
  /// **'Invalid OAuth state parameter.'**
  String get oauthInvalidState;

  /// Localized message for oauth invalid code.
  ///
  /// In en, this message translates to:
  /// **'Invalid authorization code.'**
  String get oauthInvalidCode;

  /// Localized message for folder download unsupported.
  ///
  /// In en, this message translates to:
  /// **'Direct folder download is not supported. Select individual files.'**
  String get folderDownloadUnsupported;

  /// Localized message for downloading single item.
  ///
  /// In en, this message translates to:
  /// **'Starting download for \"{name}\"...'**
  String downloadingSingleItem(String name);

  /// Localized message for downloading multiple items.
  ///
  /// In en, this message translates to:
  /// **'Starting download for {count} files...'**
  String downloadingMultipleItems(int count);

  /// Localized message for files added to download queue.
  ///
  /// In en, this message translates to:
  /// **'{count} files added to download queue.'**
  String filesAddedToDownloadQueue(int count);

  /// Localized message for files added to download queue with skipped.
  ///
  /// In en, this message translates to:
  /// **'{count} files added to download queue ({dirs} folders excluded).'**
  String filesAddedToDownloadQueueWithSkipped(int count, int dirs);

  /// Localized message for delete single folder title.
  ///
  /// In en, this message translates to:
  /// **'Delete folder?'**
  String get deleteSingleFolderTitle;

  /// Localized message for delete single file title.
  ///
  /// In en, this message translates to:
  /// **'Delete file?'**
  String get deleteSingleFileTitle;

  /// Localized message for delete single item prompt.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to permanently delete \"{name}\"?'**
  String deleteSingleItemPrompt(String name);

  /// Localized message for item deleted success.
  ///
  /// In en, this message translates to:
  /// **'Item deleted'**
  String get itemDeletedSuccess;

  /// Localized message for sort date asc.
  ///
  /// In en, this message translates to:
  /// **'Date (Oldest first)'**
  String get sortDateAsc;

  /// Localized message for sort by tooltip.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get sortByTooltip;

  /// Localized message for files added to upload queue.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 file added to upload queue} other{{count} files added to upload queue}}'**
  String filesAddedToUploadQueue(int count);

  /// Localized message for folder added to upload queue.
  ///
  /// In en, this message translates to:
  /// **'Folder added to upload ({count} files queued)'**
  String folderAddedToUploadQueue(int count);

  /// Localized message for drag drop in progress.
  ///
  /// In en, this message translates to:
  /// **'{action} of {count} items from [{src}] to [{dst}] in progress...'**
  String dragDropInProgress(String action, int count, String src, String dst);

  /// Localized message for copy selected.
  ///
  /// In en, this message translates to:
  /// **'Copy selected'**
  String get copySelected;

  /// Localized message for cut selected.
  ///
  /// In en, this message translates to:
  /// **'Cut selected'**
  String get cutSelected;

  /// Localized message for search files hint.
  ///
  /// In en, this message translates to:
  /// **'Search files or folders...'**
  String get searchFilesHint;

  /// Localized message for e2e active tooltip.
  ///
  /// In en, this message translates to:
  /// **'End-to-End Encryption active (AES-256)\nFiles and folders encrypted client-side'**
  String get e2eActiveTooltip;

  /// Localized message for disable dual pane tooltip.
  ///
  /// In en, this message translates to:
  /// **'Disable dual pane'**
  String get disableDualPaneTooltip;

  /// Localized message for enable dual pane tooltip.
  ///
  /// In en, this message translates to:
  /// **'Enable dual pane (Commander)'**
  String get enableDualPaneTooltip;

  /// Localized message for drop to copy to.
  ///
  /// In en, this message translates to:
  /// **'Drop to copy to [{remote}]'**
  String dropToCopyTo(String remote);

  /// Localized message for destination fallback.
  ///
  /// In en, this message translates to:
  /// **'destination'**
  String get destinationFallback;

  /// Localized message for clipboard banner single.
  ///
  /// In en, this message translates to:
  /// **'{action}: \"{name}\" from [{remote}]'**
  String clipboardBannerSingle(String action, String name, String remote);

  /// Localized message for clipboard banner multiple.
  ///
  /// In en, this message translates to:
  /// **'{action}: {count} items from [{remote}]'**
  String clipboardBannerMultiple(String action, int count, String remote);

  /// Localized message for transfer started single.
  ///
  /// In en, this message translates to:
  /// **'Transfer started for \"{name}\"'**
  String transferStartedSingle(String name);

  /// Localized message for transfers started count.
  ///
  /// In en, this message translates to:
  /// **'{count} transfers started'**
  String transfersStartedCount(int count);

  /// Localized message for no cloud selected title.
  ///
  /// In en, this message translates to:
  /// **'No Cloud Selected'**
  String get noCloudSelectedTitle;

  /// Localized message for no cloud selected subtitle.
  ///
  /// In en, this message translates to:
  /// **'Select a cloud from the menu above.'**
  String get noCloudSelectedSubtitle;

  /// Localized message for loading files from remote.
  ///
  /// In en, this message translates to:
  /// **'Loading files from {remote}...'**
  String loadingFilesFromRemote(String remote);

  /// Localized message for loading folder.
  ///
  /// In en, this message translates to:
  /// **'Loading {folder}...'**
  String loadingFolder(String folder);

  /// Localized message for reading directory.
  ///
  /// In en, this message translates to:
  /// **'Reading directory...'**
  String get readingDirectory;

  /// Localized message for download started saved to.
  ///
  /// In en, this message translates to:
  /// **'Download started: saving to {path}'**
  String downloadStartedSavedTo(String path);

  /// Localized message for no cloud selected.
  ///
  /// In en, this message translates to:
  /// **'No cloud selected.'**
  String get noCloudSelected;

  /// Localized message for no link returned by provider.
  ///
  /// In en, this message translates to:
  /// **'No link returned by provider.'**
  String get noLinkReturnedByProvider;

  /// Localized message for public links not supported.
  ///
  /// In en, this message translates to:
  /// **'This cloud provider does not support creating public links.'**
  String get publicLinksNotSupported;

  /// Localized message for error creating share link.
  ///
  /// In en, this message translates to:
  /// **'Error creating link: {error}'**
  String errorCreatingShareLink(String error);

  /// Localized message for new name label.
  ///
  /// In en, this message translates to:
  /// **'New name'**
  String get newNameLabel;

  /// Localized message for item details size with bytes.
  ///
  /// In en, this message translates to:
  /// **'Size: {size} ({bytes} bytes)'**
  String itemDetailsSizeWithBytes(String size, int bytes);

  /// Localized message for share link access file.
  ///
  /// In en, this message translates to:
  /// **'Anyone with this link will be able to access this file:'**
  String get shareLinkAccessFile;

  /// Localized message for share link access folder.
  ///
  /// In en, this message translates to:
  /// **'Anyone with this link will be able to access this folder:'**
  String get shareLinkAccessFolder;

  /// Localized message for invalid url or browser.
  ///
  /// In en, this message translates to:
  /// **'Invalid URL or unable to open browser.'**
  String get invalidUrlOrBrowser;

  /// Localized message for no app to open file.
  ///
  /// In en, this message translates to:
  /// **'No application installed to open \"{name}\".'**
  String noAppToOpenFile(String name);

  /// Localized message for permission denied open file.
  ///
  /// In en, this message translates to:
  /// **'Permission denied to open file with system app.'**
  String get permissionDeniedOpenFile;

  /// Localized message for no default app found.
  ///
  /// In en, this message translates to:
  /// **'No default application found to open this file.'**
  String get noDefaultAppFound;

  /// Localized message for unable to open file.
  ///
  /// In en, this message translates to:
  /// **'Unable to open file: {error}'**
  String unableToOpenFile(String error);

  /// Localized message for downloading for external open.
  ///
  /// In en, this message translates to:
  /// **'Downloading \"{name}\" to open externally...'**
  String downloadingForExternalOpen(String name);

  /// Localized message for error opening file.
  ///
  /// In en, this message translates to:
  /// **'Error opening file: {error}'**
  String errorOpeningFile(String error);

  /// Localized message for select files to upload.
  ///
  /// In en, this message translates to:
  /// **'Select files to upload to Cloud'**
  String get selectFilesToUpload;

  /// Localized message for select folder to upload.
  ///
  /// In en, this message translates to:
  /// **'Select folder to upload to Cloud'**
  String get selectFolderToUpload;

  /// Localized message for copy right compact.
  ///
  /// In en, this message translates to:
  /// **'Copy ->'**
  String get copyRightCompact;

  /// Localized message for copy right count compact.
  ///
  /// In en, this message translates to:
  /// **'Copy ({count}) ->'**
  String copyRightCountCompact(int count);

  /// Localized message for move right compact.
  ///
  /// In en, this message translates to:
  /// **'Move ->'**
  String get moveRightCompact;

  /// Localized message for move right count compact.
  ///
  /// In en, this message translates to:
  /// **'Move ({count}) ->'**
  String moveRightCountCompact(int count);

  /// Localized message for copy left compact.
  ///
  /// In en, this message translates to:
  /// **'<- Copy'**
  String get copyLeftCompact;

  /// Localized message for copy left count compact.
  ///
  /// In en, this message translates to:
  /// **'<- Copy ({count})'**
  String copyLeftCountCompact(int count);

  /// Localized message for move left compact.
  ///
  /// In en, this message translates to:
  /// **'<- Move'**
  String get moveLeftCompact;

  /// Localized message for move left count compact.
  ///
  /// In en, this message translates to:
  /// **'<- Move ({count})'**
  String moveLeftCountCompact(int count);

  /// Localized message for clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// Localized message for no recent transfers.
  ///
  /// In en, this message translates to:
  /// **'No recent transfers'**
  String get noRecentTransfers;

  /// Localized message for recent transfers subtitle.
  ///
  /// In en, this message translates to:
  /// **'Downloads, uploads, and cloud copies will appear here.'**
  String get recentTransfersSubtitle;

  /// Localized message for completed with progress.
  ///
  /// In en, this message translates to:
  /// **'Completed • {progress}'**
  String completedWithProgress(String progress);

  /// Localized message for transfer failed error.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String transferFailedError(String error);

  /// Localized message for transfer failed fallback.
  ///
  /// In en, this message translates to:
  /// **'Transfer failed'**
  String get transferFailedFallback;

  /// Localized message for cancelled by user.
  ///
  /// In en, this message translates to:
  /// **'Cancelled by user'**
  String get cancelledByUser;

  /// Localized message for local location.
  ///
  /// In en, this message translates to:
  /// **'Local'**
  String get localLocation;

  /// Localized message for move to badge.
  ///
  /// In en, this message translates to:
  /// **'Move to'**
  String get moveToBadge;

  /// Localized message for copy to badge.
  ///
  /// In en, this message translates to:
  /// **'Copy to'**
  String get copyToBadge;

  /// Localized message for copied exclamation.
  ///
  /// In en, this message translates to:
  /// **'Copied!'**
  String get copiedExclamation;

  /// Localized message for running.
  ///
  /// In en, this message translates to:
  /// **'Running'**
  String get running;

  /// Prompt shown in the upload dialog asking whether to upload a file or folder.
  ///
  /// In en, this message translates to:
  /// **'Choose what you would like to upload:'**
  String get uploadChooseTypePrompt;

  /// Title for configuring what long-pressing an item in Explorer does.
  ///
  /// In en, this message translates to:
  /// **'Long press action'**
  String get longPressActionTitle;

  /// Long press option to toggle item multi-selection.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get longPressActionSelect;

  /// Description for the select long press action.
  ///
  /// In en, this message translates to:
  /// **'Long-pressing an item toggles multi-selection.'**
  String get longPressActionSelectDesc;

  /// Long press option to drag and move an item.
  ///
  /// In en, this message translates to:
  /// **'Move (Drag)'**
  String get longPressActionMove;

  /// Description for the move long press action.
  ///
  /// In en, this message translates to:
  /// **'Long-pressing an item lets you drag it into a folder or opposite pane to move it.'**
  String get longPressActionMoveDesc;

  /// Long press option to open the item context menu.
  ///
  /// In en, this message translates to:
  /// **'Actions menu'**
  String get longPressActionMenu;

  /// Description for the context menu long press action.
  ///
  /// In en, this message translates to:
  /// **'Long-pressing an item opens its actions menu (open, download, rename, delete).'**
  String get longPressActionMenuDesc;

  /// Long press option to cut the item to the clipboard.
  ///
  /// In en, this message translates to:
  /// **'Cut'**
  String get longPressActionCut;

  /// Description for the cut long press action.
  ///
  /// In en, this message translates to:
  /// **'Long-pressing an item cuts it to the clipboard so you can paste-move it elsewhere.'**
  String get longPressActionCutDesc;

  /// Header for the pinned files and folders card on the Home screen.
  ///
  /// In en, this message translates to:
  /// **'Pinned'**
  String get pinnedFavorites;

  /// Minimal hint shown in the pinned card on Home when no items are pinned yet.
  ///
  /// In en, this message translates to:
  /// **'Pin files or folders from Explorer to keep them here.'**
  String get noPinnedFavoritesHint;

  /// Explorer action to pin a file or folder to the Home screen.
  ///
  /// In en, this message translates to:
  /// **'Pin to Home'**
  String get pinToHome;

  /// Action to remove a pinned file or folder from the Home screen.
  ///
  /// In en, this message translates to:
  /// **'Unpin from Home'**
  String get unpinFromHome;

  /// Snackbar feedback after pinning an item to Home.
  ///
  /// In en, this message translates to:
  /// **'Pinned \"{name}\" to Home'**
  String pinnedToHomeFeedback(String name);

  /// Snackbar feedback after removing a pinned item from Home.
  ///
  /// In en, this message translates to:
  /// **'Removed \"{name}\" from Home'**
  String unpinnedFromHomeFeedback(String name);

  /// Action to open a pinned file's parent folder in Explorer.
  ///
  /// In en, this message translates to:
  /// **'Open folder in Explorer'**
  String get openContainingFolder;

  /// Error shown when tapping a pinned item whose remote is no longer configured.
  ///
  /// In en, this message translates to:
  /// **'Cloud \"{remote}\" is no longer connected'**
  String remoteNotConnected(String remote);

  /// Title shown when Android storage permission is needed to list local files.
  ///
  /// In en, this message translates to:
  /// **'All files access required'**
  String get androidStoragePermissionTitle;

  /// Explanation shown when Android storage permission is missing.
  ///
  /// In en, this message translates to:
  /// **'Android hides local files until \"All files access\" is granted for UnifyCloud. Folders remain visible, but files won\'t appear.'**
  String get androidStoragePermissionDesc;

  /// Button label to grant Android all files access.
  ///
  /// In en, this message translates to:
  /// **'Grant Access'**
  String get grantPermission;

  /// Tooltip and menu label to manually refresh the current folder.
  ///
  /// In en, this message translates to:
  /// **'Refresh folder'**
  String get refreshCurrentFolder;

  /// Label for cross-cloud global search mode.
  ///
  /// In en, this message translates to:
  /// **'Global search'**
  String get globalSearch;

  /// Scope toggle label for searching only the current folder.
  ///
  /// In en, this message translates to:
  /// **'Current folder'**
  String get currentFolderScope;

  /// Hint text for the global search input field.
  ///
  /// In en, this message translates to:
  /// **'Search across clouds (e.g. report or *.pdf)...'**
  String get globalSearchHint;

  /// Action tooltip/button to start searching.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchAction;

  /// Button label to cancel an in-progress global search.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stopSearch;

  /// Filter chip label representing all connected cloud remotes.
  ///
  /// In en, this message translates to:
  /// **'All clouds'**
  String get allClouds;

  /// Prefix for file type filter chip.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get fileTypeFilter;

  /// File type preset for all files.
  ///
  /// In en, this message translates to:
  /// **'All types'**
  String get fileTypeAll;

  /// File type preset for documents.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get fileTypeDocuments;

  /// File type preset for images.
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get fileTypeImages;

  /// File type preset for videos.
  ///
  /// In en, this message translates to:
  /// **'Videos'**
  String get fileTypeVideos;

  /// File type preset for audio files.
  ///
  /// In en, this message translates to:
  /// **'Audio'**
  String get fileTypeAudio;

  /// File type preset for archive files.
  ///
  /// In en, this message translates to:
  /// **'Archives'**
  String get fileTypeArchives;

  /// File type preset option for custom file extensions.
  ///
  /// In en, this message translates to:
  /// **'Custom (.ext)'**
  String get fileTypeCustom;

  /// Dialog title for entering custom file extensions.
  ///
  /// In en, this message translates to:
  /// **'Custom extensions'**
  String get customExtensionsTitle;

  /// Hint text for custom file extensions input.
  ///
  /// In en, this message translates to:
  /// **'e.g. .pdf, .docx, .log'**
  String get customExtensionsHint;

  /// Prefix for file size filter chip.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get sizeFilter;

  /// Size filter preset for any file size.
  ///
  /// In en, this message translates to:
  /// **'Any size'**
  String get sizeAny;

  /// Size filter preset under 1 MB.
  ///
  /// In en, this message translates to:
  /// **'< 1 MB'**
  String get sizeUnder1Mb;

  /// Size filter preset from 1 to 100 MB.
  ///
  /// In en, this message translates to:
  /// **'1–100 MB'**
  String get size1To100Mb;

  /// Size filter preset over 100 MB.
  ///
  /// In en, this message translates to:
  /// **'> 100 MB'**
  String get sizeOver100Mb;

  /// Size filter preset over 1 GB.
  ///
  /// In en, this message translates to:
  /// **'> 1 GB'**
  String get sizeOver1Gb;

  /// Prefix for max folder depth filter chip.
  ///
  /// In en, this message translates to:
  /// **'Depth'**
  String get depthFilter;

  /// Depth filter option for unlimited depth.
  ///
  /// In en, this message translates to:
  /// **'Unlimited'**
  String get depthUnlimited;

  /// Depth filter option showing max folder depth.
  ///
  /// In en, this message translates to:
  /// **'Max depth {depth}'**
  String depthLevel(int depth);

  /// Filter chip label to include folders in search results.
  ///
  /// In en, this message translates to:
  /// **'Folders'**
  String get includeFoldersChip;

  /// Live search progress message while scanning a specific remote.
  ///
  /// In en, this message translates to:
  /// **'Scanning {remote} • {files} files, {dirs} folders'**
  String scanningProgress(String remote, int files, int dirs);

  /// Live search progress message while scanning clouds.
  ///
  /// In en, this message translates to:
  /// **'Scanning clouds • {files} files, {dirs} folders'**
  String scanningAllProgress(int files, int dirs);

  /// Summary of completed global search results.
  ///
  /// In en, this message translates to:
  /// **'{count} results ({files} files, {dirs} folders scanned)'**
  String searchResultsSummary(int count, int files, int dirs);

  /// Notice shown when search results reached the maximum cap.
  ///
  /// In en, this message translates to:
  /// **'Showing first {count} results. Refine your query or filters to narrow results.'**
  String searchTruncatedNotice(int count);

  /// Title for non-fatal per-remote search warnings.
  ///
  /// In en, this message translates to:
  /// **'Partial warnings ({count})'**
  String searchWarningsTitle(int count);

  /// Initial prompt shown in Global Search before running a search.
  ///
  /// In en, this message translates to:
  /// **'Enter a name, glob pattern (e.g. *.pdf), or select filters to search across all connected clouds.'**
  String get globalSearchEmptyPrompt;

  /// Empty state shown when global search completes with zero matches.
  ///
  /// In en, this message translates to:
  /// **'No files matched your global search.'**
  String get globalSearchNoResults;

  /// Badge shown when global search was stopped by the user.
  ///
  /// In en, this message translates to:
  /// **'Search stopped'**
  String get searchCancelledLabel;

  /// Action label to open a file or folder.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get openAction;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'en',
    'es',
    'fr',
    'it',
    'pl',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'pl':
      return AppLocalizationsPl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
