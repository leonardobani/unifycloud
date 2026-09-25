import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_it.dart';

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
    Locale('en'),
    Locale('it'),
  ];

  /// Application title
  ///
  /// In en, this message translates to:
  /// **'UnifyCloud'**
  String get appTitle;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @explorer.
  ///
  /// In en, this message translates to:
  /// **'Explorer'**
  String get explorer;

  /// No description provided for @sync.
  ///
  /// In en, this message translates to:
  /// **'Sync'**
  String get sync;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @move.
  ///
  /// In en, this message translates to:
  /// **'Move'**
  String get move;

  /// No description provided for @rename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get rename;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @upload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get upload;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Operation completed'**
  String get success;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @resetDefaultsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Restore Default Settings'**
  String get resetDefaultsTooltip;

  /// No description provided for @resetDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Settings'**
  String get resetDialogTitle;

  /// No description provided for @resetDialogContent.
  ///
  /// In en, this message translates to:
  /// **'Do you want to reset all preferences (theme, language, folders, display) to factory defaults?'**
  String get resetDialogContent;

  /// No description provided for @resetSuccessSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Settings restored to default values'**
  String get resetSuccessSnackbar;

  /// No description provided for @appearanceAndTheme.
  ///
  /// In en, this message translates to:
  /// **'Appearance & Theme'**
  String get appearanceAndTheme;

  /// No description provided for @chooseVisualThemeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose visual theme for UnifyCloud interface:'**
  String get chooseVisualThemeSubtitle;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select application interface language'**
  String get languageSubtitle;

  /// No description provided for @langEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get langEnglish;

  /// No description provided for @langItalian.
  ///
  /// In en, this message translates to:
  /// **'Italiano'**
  String get langItalian;

  /// No description provided for @langSystem.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get langSystem;

  /// No description provided for @filesAndExploration.
  ///
  /// In en, this message translates to:
  /// **'Files & Exploration'**
  String get filesAndExploration;

  /// No description provided for @showHiddenFiles.
  ///
  /// In en, this message translates to:
  /// **'Show hidden files'**
  String get showHiddenFiles;

  /// No description provided for @showHiddenFilesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Display files and folders starting with a dot'**
  String get showHiddenFilesSubtitle;

  /// No description provided for @confirmBeforeDelete.
  ///
  /// In en, this message translates to:
  /// **'Confirm before deleting'**
  String get confirmBeforeDelete;

  /// No description provided for @confirmBeforeDeleteSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ask for confirmation before permanently deleting files'**
  String get confirmBeforeDeleteSubtitle;

  /// No description provided for @defaultDownloadFolder.
  ///
  /// In en, this message translates to:
  /// **'Default Download Folder'**
  String get defaultDownloadFolder;

  /// No description provided for @defaultDownloadFolderSystem.
  ///
  /// In en, this message translates to:
  /// **'System default download directory'**
  String get defaultDownloadFolderSystem;

  /// No description provided for @restoreDefaultPath.
  ///
  /// In en, this message translates to:
  /// **'Restore default path'**
  String get restoreDefaultPath;

  /// No description provided for @customDownloadFolderDialogPrompt.
  ///
  /// In en, this message translates to:
  /// **'Select a folder using the system picker or enter the desired path manually:'**
  String get customDownloadFolderDialogPrompt;

  /// No description provided for @folderPath.
  ///
  /// In en, this message translates to:
  /// **'Folder path'**
  String get folderPath;

  /// No description provided for @folderPathHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. /home/user/Downloads'**
  String get folderPathHint;

  /// No description provided for @browseWithSystemPicker.
  ///
  /// In en, this message translates to:
  /// **'Browse with system picker'**
  String get browseWithSystemPicker;

  /// Error snackbar when opening file picker fails
  ///
  /// In en, this message translates to:
  /// **'Unable to open system picker: {error}'**
  String errorOpenPicker(String error);

  /// No description provided for @restoreDefault.
  ///
  /// In en, this message translates to:
  /// **'Restore default'**
  String get restoreDefault;

  /// No description provided for @maxConcurrentTransfers.
  ///
  /// In en, this message translates to:
  /// **'Concurrent Transfers'**
  String get maxConcurrentTransfers;

  /// No description provided for @maxConcurrentTransfersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Maximum number of simultaneous active file transfers'**
  String get maxConcurrentTransfersSubtitle;

  /// No description provided for @dualPaneMode.
  ///
  /// In en, this message translates to:
  /// **'Dual-Pane Commander Mode'**
  String get dualPaneMode;

  /// No description provided for @dualPaneModeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Show two side-by-side panes on wide screens and tablets'**
  String get dualPaneModeSubtitle;

  /// No description provided for @communityAndSupport.
  ///
  /// In en, this message translates to:
  /// **'Community & Support'**
  String get communityAndSupport;

  /// No description provided for @openSourceDescription.
  ///
  /// In en, this message translates to:
  /// **'UnifyCloud is free and open-source software built to unify your cloud data without trackers or proprietary intermediaries.'**
  String get openSourceDescription;

  /// No description provided for @supportDeveloper.
  ///
  /// In en, this message translates to:
  /// **'Support the Developer'**
  String get supportDeveloper;

  /// No description provided for @supportDeveloperSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Buy a coffee to support independent development'**
  String get supportDeveloperSubtitle;

  /// No description provided for @viewSourceOnGitLab.
  ///
  /// In en, this message translates to:
  /// **'View Code on GitLab'**
  String get viewSourceOnGitLab;

  /// No description provided for @viewSourceOnGitLabSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Official repository, bug reports, and contributions'**
  String get viewSourceOnGitLabSubtitle;

  /// Error snackbar when opening browser fails
  ///
  /// In en, this message translates to:
  /// **'Unable to open browser. Repository: {url}'**
  String errorOpenBrowser(String url);

  /// No description provided for @supportDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Support UnifyCloud'**
  String get supportDialogTitle;

  /// No description provided for @supportDialogDescription1.
  ///
  /// In en, this message translates to:
  /// **'UnifyCloud is a free and open-source project designed to give you full control over your cloud files.'**
  String get supportDialogDescription1;

  /// No description provided for @supportDialogDescription2.
  ///
  /// In en, this message translates to:
  /// **'If you find this application helpful, consider buying a coffee or donating to support continuous development and new features!'**
  String get supportDialogDescription2;

  /// No description provided for @supportKofiTitle.
  ///
  /// In en, this message translates to:
  /// **'Buy a coffee on Ko-fi'**
  String get supportKofiTitle;

  /// No description provided for @supportLiberapayTitle.
  ///
  /// In en, this message translates to:
  /// **'Donate on Liberapay'**
  String get supportLiberapayTitle;

  /// No description provided for @supportPaypalTitle.
  ///
  /// In en, this message translates to:
  /// **'Donate via PayPal'**
  String get supportPaypalTitle;

  /// No description provided for @securityAndEncryption.
  ///
  /// In en, this message translates to:
  /// **'Security & Encryption'**
  String get securityAndEncryption;

  /// No description provided for @securityArchitectureDescription.
  ///
  /// In en, this message translates to:
  /// **'UnifyCloud employs a Zero-Plaintext architecture. All OAuth tokens and credentials are securely protected in the system Keychain/Keystore and injected exclusively into Go engine RAM memory.'**
  String get securityArchitectureDescription;

  /// No description provided for @appLock.
  ///
  /// In en, this message translates to:
  /// **'App Lock (PIN / Biometrics)'**
  String get appLock;

  /// No description provided for @appLockSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Require PIN or fingerprint to access'**
  String get appLockSubtitle;

  /// No description provided for @appLockActiveSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Active at startup and after inactivity'**
  String get appLockActiveSubtitle;

  /// No description provided for @appLockEnabledSnackbar.
  ///
  /// In en, this message translates to:
  /// **'App Lock enabled successfully'**
  String get appLockEnabledSnackbar;

  /// No description provided for @appLockDisabledSnackbar.
  ///
  /// In en, this message translates to:
  /// **'App Lock disabled'**
  String get appLockDisabledSnackbar;

  /// No description provided for @changePin.
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get changePin;

  /// No description provided for @changePinSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set a new 6-digit security PIN'**
  String get changePinSubtitle;

  /// No description provided for @pinChangedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Security PIN updated successfully'**
  String get pinChangedSnackbar;

  /// No description provided for @biometricAuth.
  ///
  /// In en, this message translates to:
  /// **'Biometric Authentication'**
  String get biometricAuth;

  /// No description provided for @biometricAuthSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use fingerprint or biometric sensor if available'**
  String get biometricAuthSubtitle;

  /// No description provided for @biometricNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Not available or not configured on this device'**
  String get biometricNotAvailable;

  /// No description provided for @autoLock.
  ///
  /// In en, this message translates to:
  /// **'Auto Lock'**
  String get autoLock;

  /// No description provided for @autoLockSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Background inactivity timeout before locking'**
  String get autoLockSubtitle;

  /// No description provided for @lockImmediately.
  ///
  /// In en, this message translates to:
  /// **'Immediately'**
  String get lockImmediately;

  /// No description provided for @lockAfter1Minute.
  ///
  /// In en, this message translates to:
  /// **'After 1 minute'**
  String get lockAfter1Minute;

  /// No description provided for @lockAfter5Minutes.
  ///
  /// In en, this message translates to:
  /// **'After 5 minutes'**
  String get lockAfter5Minutes;

  /// No description provided for @lockAfter15Minutes.
  ///
  /// In en, this message translates to:
  /// **'After 15 minutes'**
  String get lockAfter15Minutes;

  /// No description provided for @lockAfter30Minutes.
  ///
  /// In en, this message translates to:
  /// **'After 30 minutes'**
  String get lockAfter30Minutes;

  /// No description provided for @syncCloudAccounts.
  ///
  /// In en, this message translates to:
  /// **'Sync Cloud Accounts'**
  String get syncCloudAccounts;

  /// No description provided for @syncCloudAccountsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Reload configurations from secure storage'**
  String get syncCloudAccountsSubtitle;

  /// No description provided for @syncCloudAccountsSuccess.
  ///
  /// In en, this message translates to:
  /// **'Cloud accounts reloaded successfully'**
  String get syncCloudAccountsSuccess;

  /// No description provided for @clearAllCredentials.
  ///
  /// In en, this message translates to:
  /// **'Clear All Credentials'**
  String get clearAllCredentials;

  /// No description provided for @clearAllCredentialsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Removes encrypted configuration and disconnects all clouds'**
  String get clearAllCredentialsSubtitle;

  /// No description provided for @clearCredentialsDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Warning: Reset Credentials'**
  String get clearCredentialsDialogTitle;

  /// No description provided for @clearCredentialsDialogContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete all saved credentials? You will need to reconnect your cloud accounts.'**
  String get clearCredentialsDialogContent;

  /// No description provided for @clearCredentialsSuccess.
  ///
  /// In en, this message translates to:
  /// **'Credentials deleted successfully'**
  String get clearCredentialsSuccess;

  /// No description provided for @aboutUnifyCloud.
  ///
  /// In en, this message translates to:
  /// **'About UnifyCloud'**
  String get aboutUnifyCloud;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version: 1.0.0'**
  String get appVersion;

  /// No description provided for @developerInfo.
  ///
  /// In en, this message translates to:
  /// **'Developer: LeoRise (@leorise25)'**
  String get developerInfo;

  /// No description provided for @engineInfo.
  ///
  /// In en, this message translates to:
  /// **'Engine: Rclone Core CGO (Go v1.22+ / C FFI)'**
  String get engineInfo;

  /// No description provided for @frameworkInfo.
  ///
  /// In en, this message translates to:
  /// **'Framework: Flutter (Material 3 Responsive)'**
  String get frameworkInfo;

  /// No description provided for @licenseInfo.
  ///
  /// In en, this message translates to:
  /// **'License: GNU General Public License v3.0 (GPL-3.0)'**
  String get licenseInfo;

  /// No description provided for @copyrightInfo.
  ///
  /// In en, this message translates to:
  /// **'Copyright: © 2026 Leonardo Bani'**
  String get copyrightInfo;

  /// No description provided for @storageOverview.
  ///
  /// In en, this message translates to:
  /// **'Storage Overview'**
  String get storageOverview;

  /// No description provided for @connectedClouds.
  ///
  /// In en, this message translates to:
  /// **'Connected Clouds'**
  String get connectedClouds;

  /// No description provided for @noCloudsConfigured.
  ///
  /// In en, this message translates to:
  /// **'No cloud accounts configured'**
  String get noCloudsConfigured;

  /// No description provided for @noCloudsDescription.
  ///
  /// In en, this message translates to:
  /// **'Connect your first cloud storage account to start managing and syncing files.'**
  String get noCloudsDescription;

  /// No description provided for @addCloud.
  ///
  /// In en, this message translates to:
  /// **'Add Cloud'**
  String get addCloud;

  /// No description provided for @used.
  ///
  /// In en, this message translates to:
  /// **'used'**
  String get used;

  /// No description provided for @free.
  ///
  /// In en, this message translates to:
  /// **'free'**
  String get free;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'total'**
  String get total;

  /// No description provided for @manageAccounts.
  ///
  /// In en, this message translates to:
  /// **'Manage Accounts'**
  String get manageAccounts;

  /// No description provided for @viewFiles.
  ///
  /// In en, this message translates to:
  /// **'View Files'**
  String get viewFiles;

  /// No description provided for @createVaultHere.
  ///
  /// In en, this message translates to:
  /// **'Create Encrypted Vault here...'**
  String get createVaultHere;

  /// No description provided for @disconnectAccount.
  ///
  /// In en, this message translates to:
  /// **'Disconnect account'**
  String get disconnectAccount;

  /// No description provided for @disconnectConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Disconnect account?'**
  String get disconnectConfirmTitle;

  /// No description provided for @disconnectConfirmContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to disconnect this account? Remote files will remain intact.'**
  String get disconnectConfirmContent;

  /// No description provided for @allFiles.
  ///
  /// In en, this message translates to:
  /// **'All Files'**
  String get allFiles;

  /// No description provided for @emptyFolder.
  ///
  /// In en, this message translates to:
  /// **'This folder is empty'**
  String get emptyFolder;

  /// No description provided for @emptyFolderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Upload files or create a subfolder to get started.'**
  String get emptyFolderSubtitle;

  /// No description provided for @uploadFile.
  ///
  /// In en, this message translates to:
  /// **'Upload file'**
  String get uploadFile;

  /// No description provided for @uploadFolder.
  ///
  /// In en, this message translates to:
  /// **'Upload entire folder'**
  String get uploadFolder;

  /// No description provided for @newFolder.
  ///
  /// In en, this message translates to:
  /// **'New Folder'**
  String get newFolder;

  /// No description provided for @newFolderPrompt.
  ///
  /// In en, this message translates to:
  /// **'Enter the name for the new folder:'**
  String get newFolderPrompt;

  /// No description provided for @folderNameHint.
  ///
  /// In en, this message translates to:
  /// **'Folder name'**
  String get folderNameHint;

  /// No description provided for @selectAll.
  ///
  /// In en, this message translates to:
  /// **'Select all'**
  String get selectAll;

  /// No description provided for @clearSelection.
  ///
  /// In en, this message translates to:
  /// **'Clear selection'**
  String get clearSelection;

  /// No description provided for @deleteSelected.
  ///
  /// In en, this message translates to:
  /// **'Delete selected'**
  String get deleteSelected;

  /// No description provided for @deleteSelectedPrompt.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the selected items?'**
  String get deleteSelectedPrompt;

  /// No description provided for @deleteItemPrompt.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this item?'**
  String get deleteItemPrompt;

  /// No description provided for @shareLink.
  ///
  /// In en, this message translates to:
  /// **'Share Link'**
  String get shareLink;

  /// No description provided for @createShareLink.
  ///
  /// In en, this message translates to:
  /// **'Create shareable link'**
  String get createShareLink;

  /// No description provided for @copyShareLink.
  ///
  /// In en, this message translates to:
  /// **'Copy Link'**
  String get copyShareLink;

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copiedToClipboard;

  /// No description provided for @transfers.
  ///
  /// In en, this message translates to:
  /// **'Transfers'**
  String get transfers;

  /// No description provided for @activeTransfers.
  ///
  /// In en, this message translates to:
  /// **'Active Transfers'**
  String get activeTransfers;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @failed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get failed;

  /// No description provided for @queued.
  ///
  /// In en, this message translates to:
  /// **'Queued'**
  String get queued;

  /// No description provided for @cancelTransfer.
  ///
  /// In en, this message translates to:
  /// **'Cancel transfer'**
  String get cancelTransfer;

  /// No description provided for @clearCompleted.
  ///
  /// In en, this message translates to:
  /// **'Clear completed'**
  String get clearCompleted;

  /// No description provided for @syncRulesTitle.
  ///
  /// In en, this message translates to:
  /// **'Backup & Sync Rules'**
  String get syncRulesTitle;

  /// No description provided for @newRule.
  ///
  /// In en, this message translates to:
  /// **'New Rule'**
  String get newRule;

  /// No description provided for @noSyncRules.
  ///
  /// In en, this message translates to:
  /// **'No synchronization rules configured'**
  String get noSyncRules;

  /// No description provided for @noSyncRulesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create an automated rule to sync local folders with your cloud storage.'**
  String get noSyncRulesSubtitle;

  /// No description provided for @ruleName.
  ///
  /// In en, this message translates to:
  /// **'Rule Name'**
  String get ruleName;

  /// No description provided for @sourcePath.
  ///
  /// In en, this message translates to:
  /// **'Source Folder'**
  String get sourcePath;

  /// No description provided for @destinationCloud.
  ///
  /// In en, this message translates to:
  /// **'Destination Cloud'**
  String get destinationCloud;

  /// No description provided for @destinationPath.
  ///
  /// In en, this message translates to:
  /// **'Remote Path'**
  String get destinationPath;

  /// No description provided for @direction.
  ///
  /// In en, this message translates to:
  /// **'Direction'**
  String get direction;

  /// No description provided for @frequency.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get frequency;

  /// No description provided for @runNow.
  ///
  /// In en, this message translates to:
  /// **'Run Now'**
  String get runNow;

  /// No description provided for @syncInProgress.
  ///
  /// In en, this message translates to:
  /// **'Synchronization in progress...'**
  String get syncInProgress;

  /// No description provided for @syncSuccess.
  ///
  /// In en, this message translates to:
  /// **'Synchronization completed'**
  String get syncSuccess;

  /// No description provided for @syncFailed.
  ///
  /// In en, this message translates to:
  /// **'Synchronization failed'**
  String get syncFailed;

  /// No description provided for @addCloudDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Connect New Cloud'**
  String get addCloudDialogTitle;

  /// No description provided for @selectProvider.
  ///
  /// In en, this message translates to:
  /// **'Select Cloud Provider'**
  String get selectProvider;

  /// No description provided for @accountNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Account Name / Alias'**
  String get accountNameLabel;

  /// No description provided for @connectButton.
  ///
  /// In en, this message translates to:
  /// **'Connect Account'**
  String get connectButton;

  /// No description provided for @vaultTitle.
  ///
  /// In en, this message translates to:
  /// **'E2E Encryption (Crypt)'**
  String get vaultTitle;

  /// No description provided for @vaultPassword.
  ///
  /// In en, this message translates to:
  /// **'Vault Password'**
  String get vaultPassword;

  /// No description provided for @vaultConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get vaultConfirmPassword;

  /// No description provided for @vaultSalt.
  ///
  /// In en, this message translates to:
  /// **'Salt / Secondary Password (Optional)'**
  String get vaultSalt;

  /// No description provided for @encryptFileNames.
  ///
  /// In en, this message translates to:
  /// **'Encrypt file names'**
  String get encryptFileNames;

  /// No description provided for @encryptDirNames.
  ///
  /// In en, this message translates to:
  /// **'Encrypt directory names'**
  String get encryptDirNames;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
