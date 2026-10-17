import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_zh.dart';

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
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('nl'),
    Locale('pl'),
    Locale('pt'),
    Locale('ru'),
    Locale('tr'),
    Locale('zh'),
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

  /// No description provided for @themeStyle.
  ///
  /// In en, this message translates to:
  /// **'Interface Style'**
  String get themeStyle;

  /// No description provided for @themeStyleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select desktop design style or automatic environment detection:'**
  String get themeStyleSubtitle;

  /// No description provided for @themeStyleAuto.
  ///
  /// In en, this message translates to:
  /// **'Auto (Detect)'**
  String get themeStyleAuto;

  /// No description provided for @themeStyleStandard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get themeStyleStandard;

  /// No description provided for @themeStyleCosmic.
  ///
  /// In en, this message translates to:
  /// **'COSMIC (Default)'**
  String get themeStyleCosmic;

  /// No description provided for @themeStyleCosmicActive.
  ///
  /// In en, this message translates to:
  /// **'COSMIC style is active across all devices (Teal in light mode, Pop Orange in dark mode)'**
  String get themeStyleCosmicActive;

  /// No description provided for @themeStyleCosmicDetected.
  ///
  /// In en, this message translates to:
  /// **'COSMIC desktop environment detected: COSMIC style is active (Teal in light mode, Pop Orange in dark mode)'**
  String get themeStyleCosmicDetected;

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

  /// No description provided for @langSpanish.
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get langSpanish;

  /// No description provided for @langFrench.
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get langFrench;

  /// No description provided for @langGerman.
  ///
  /// In en, this message translates to:
  /// **'Deutsch'**
  String get langGerman;

  /// No description provided for @langPortuguese.
  ///
  /// In en, this message translates to:
  /// **'Português'**
  String get langPortuguese;

  /// No description provided for @langRussian.
  ///
  /// In en, this message translates to:
  /// **'Русский'**
  String get langRussian;

  /// No description provided for @langChinese.
  ///
  /// In en, this message translates to:
  /// **'简体中文'**
  String get langChinese;

  /// No description provided for @langJapanese.
  ///
  /// In en, this message translates to:
  /// **'日本語'**
  String get langJapanese;

  /// No description provided for @langKorean.
  ///
  /// In en, this message translates to:
  /// **'한국어'**
  String get langKorean;

  /// No description provided for @langArabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get langArabic;

  /// No description provided for @langHindi.
  ///
  /// In en, this message translates to:
  /// **'हिन्दी'**
  String get langHindi;

  /// No description provided for @langDutch.
  ///
  /// In en, this message translates to:
  /// **'Nederlands'**
  String get langDutch;

  /// No description provided for @langPolish.
  ///
  /// In en, this message translates to:
  /// **'Polski'**
  String get langPolish;

  /// No description provided for @langTurkish.
  ///
  /// In en, this message translates to:
  /// **'Türkçe'**
  String get langTurkish;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @searchLanguageHint.
  ///
  /// In en, this message translates to:
  /// **'Search language or country...'**
  String get searchLanguageHint;

  /// No description provided for @currentLanguage.
  ///
  /// In en, this message translates to:
  /// **'Current Language'**
  String get currentLanguage;

  /// No description provided for @systemDefaultWithLocale.
  ///
  /// In en, this message translates to:
  /// **'System Default ({locale})'**
  String systemDefaultWithLocale(String locale);

  /// No description provided for @refreshCloudsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Refresh cloud configurations'**
  String get refreshCloudsTooltip;

  /// No description provided for @storageOverviewAggregated.
  ///
  /// In en, this message translates to:
  /// **'Aggregated Storage Overview'**
  String get storageOverviewAggregated;

  /// No description provided for @ramEncryptionActive.
  ///
  /// In en, this message translates to:
  /// **'RAM Encryption Active'**
  String get ramEncryptionActive;

  /// No description provided for @connectedAccountsCount.
  ///
  /// In en, this message translates to:
  /// **'Connected Cloud Accounts: {count}'**
  String connectedAccountsCount(int count);

  /// No description provided for @noCloudsConfiguredHint.
  ///
  /// In en, this message translates to:
  /// **'No cloud accounts configured. Tap \"+ Connect New Cloud\" below.'**
  String get noCloudsConfiguredHint;

  /// No description provided for @percentUsed.
  ///
  /// In en, this message translates to:
  /// **'{percent}% used'**
  String percentUsed(String percent);

  /// No description provided for @availableSpace.
  ///
  /// In en, this message translates to:
  /// **'{space} available'**
  String availableSpace(String space);

  /// No description provided for @calculatingQuota.
  ///
  /// In en, this message translates to:
  /// **'Calculating storage quotas or unlimited space...'**
  String get calculatingQuota;

  /// No description provided for @syncAndBackup.
  ///
  /// In en, this message translates to:
  /// **'Sync & Backup'**
  String get syncAndBackup;

  /// No description provided for @noRulesConfigured.
  ///
  /// In en, this message translates to:
  /// **'No rules configured'**
  String get noRulesConfigured;

  /// No description provided for @activeRulesCount.
  ///
  /// In en, this message translates to:
  /// **'{active}/{total} active rules'**
  String activeRulesCount(int active, int total);

  /// No description provided for @manage.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get manage;

  /// No description provided for @connectedCloudsCount.
  ///
  /// In en, this message translates to:
  /// **'Connected Clouds ({count})'**
  String connectedCloudsCount(int count);

  /// No description provided for @connectNewCloud.
  ///
  /// In en, this message translates to:
  /// **'Connect New Cloud'**
  String get connectNewCloud;

  /// No description provided for @noCloudProvidersConnected.
  ///
  /// In en, this message translates to:
  /// **'No Cloud Providers Connected'**
  String get noCloudProvidersConnected;

  /// No description provided for @connectCloudDescription.
  ///
  /// In en, this message translates to:
  /// **'Connect Google Drive, Dropbox, OneDrive, SFTP or WebDAV to start syncing and exploring your files.'**
  String get connectCloudDescription;

  /// No description provided for @addFirstCloud.
  ///
  /// In en, this message translates to:
  /// **'Add First Cloud'**
  String get addFirstCloud;

  /// No description provided for @vaultOnRemote.
  ///
  /// In en, this message translates to:
  /// **'VAULT ON {remote}'**
  String vaultOnRemote(String remote);

  /// No description provided for @disconnectCloudTitle.
  ///
  /// In en, this message translates to:
  /// **'Disconnect Cloud'**
  String get disconnectCloudTitle;

  /// No description provided for @disconnectCloudPrompt.
  ///
  /// In en, this message translates to:
  /// **'Do you want to disconnect \"{name}\"? Credentials will be removed from encrypted storage.'**
  String disconnectCloudPrompt(String name);

  /// No description provided for @disconnect.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get disconnect;

  /// No description provided for @freeSpace.
  ///
  /// In en, this message translates to:
  /// **'{space} free'**
  String freeSpace(String space);

  /// No description provided for @storage.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get storage;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @exploreFiles.
  ///
  /// In en, this message translates to:
  /// **'Explore Files'**
  String get exploreFiles;

  /// No description provided for @paneLeft.
  ///
  /// In en, this message translates to:
  /// **'Left'**
  String get paneLeft;

  /// No description provided for @paneRight.
  ///
  /// In en, this message translates to:
  /// **'Right'**
  String get paneRight;

  /// No description provided for @folderName.
  ///
  /// In en, this message translates to:
  /// **'Folder name'**
  String get folderName;

  /// No description provided for @errorCreatingFolder.
  ///
  /// In en, this message translates to:
  /// **'Error creating folder: {error}'**
  String errorCreatingFolder(String error);

  /// No description provided for @moveAction.
  ///
  /// In en, this message translates to:
  /// **'Move'**
  String get moveAction;

  /// No description provided for @copyAction.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copyAction;

  /// No description provided for @transferBatchStarted.
  ///
  /// In en, this message translates to:
  /// **'{action} of {count} items to [{remote}] started...'**
  String transferBatchStarted(String action, int count, String remote);

  /// No description provided for @errorTransferring.
  ///
  /// In en, this message translates to:
  /// **'Error during transfer: {error}'**
  String errorTransferring(String error);

  /// No description provided for @itemCopiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'\"{name}\" copied to clipboard'**
  String itemCopiedToClipboard(String name);

  /// No description provided for @itemsCopiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'{count} items copied to clipboard'**
  String itemsCopiedToClipboard(int count);

  /// No description provided for @itemCutToClipboard.
  ///
  /// In en, this message translates to:
  /// **'\"{name}\" cut (ready to move)'**
  String itemCutToClipboard(String name);

  /// No description provided for @itemsCutToClipboard.
  ///
  /// In en, this message translates to:
  /// **'{count} items cut (ready to move)'**
  String itemsCutToClipboard(int count);

  /// No description provided for @noFilesSelectedForDownload.
  ///
  /// In en, this message translates to:
  /// **'No files selected for download.'**
  String get noFilesSelectedForDownload;

  /// No description provided for @downloadingItems.
  ///
  /// In en, this message translates to:
  /// **'Downloading {count} items...'**
  String downloadingItems(int count);

  /// No description provided for @itemsDownloadedSuccess.
  ///
  /// In en, this message translates to:
  /// **'{count} items downloaded to \"{path}\"'**
  String itemsDownloadedSuccess(int count, String path);

  /// No description provided for @errorStartingDownload.
  ///
  /// In en, this message translates to:
  /// **'Error starting download: {error}'**
  String errorStartingDownload(String error);

  /// No description provided for @deleteItemsConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete {count} selected items?'**
  String deleteItemsConfirmTitle(int count);

  /// No description provided for @deleteItemsConfirmPrompt.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to permanently delete {count} selected items from the cloud?'**
  String deleteItemsConfirmPrompt(int count);

  /// No description provided for @itemsDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'{count} items deleted'**
  String itemsDeletedSuccess(int count);

  /// No description provided for @errorDeleting.
  ///
  /// In en, this message translates to:
  /// **'Error during deletion: {error}'**
  String errorDeleting(String error);

  /// No description provided for @uploadCompletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Upload completed successfully'**
  String get uploadCompletedSuccess;

  /// No description provided for @errorUploading.
  ///
  /// In en, this message translates to:
  /// **'Error during upload: {error}'**
  String errorUploading(String error);

  /// No description provided for @folderUploadCompletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Folder upload completed successfully'**
  String get folderUploadCompletedSuccess;

  /// No description provided for @errorFolderUploading.
  ///
  /// In en, this message translates to:
  /// **'Error uploading folder: {error}'**
  String errorFolderUploading(String error);

  /// No description provided for @filesAlreadyInDirectory.
  ///
  /// In en, this message translates to:
  /// **'Files are already in this folder.'**
  String get filesAlreadyInDirectory;

  /// No description provided for @dragDropTransferStarted.
  ///
  /// In en, this message translates to:
  /// **'{action} of {count} items to [{remote}] started...'**
  String dragDropTransferStarted(String action, int count, String remote);

  /// No description provided for @errorDragDrop.
  ///
  /// In en, this message translates to:
  /// **'Error during drag-and-drop transfer: {error}'**
  String errorDragDrop(String error);

  /// No description provided for @closeSelection.
  ///
  /// In en, this message translates to:
  /// **'Close selection'**
  String get closeSelection;

  /// No description provided for @itemsSelectedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String itemsSelectedCount(int count);

  /// No description provided for @deselectAll.
  ///
  /// In en, this message translates to:
  /// **'Deselect all'**
  String get deselectAll;

  /// No description provided for @copyToRemote.
  ///
  /// In en, this message translates to:
  /// **'Copy to {remote}'**
  String copyToRemote(String remote);

  /// No description provided for @moveToRemote.
  ///
  /// In en, this message translates to:
  /// **'Move to {remote}'**
  String moveToRemote(String remote);

  /// No description provided for @moreActions.
  ///
  /// In en, this message translates to:
  /// **'More actions'**
  String get moreActions;

  /// No description provided for @downloadSelected.
  ///
  /// In en, this message translates to:
  /// **'Download selected'**
  String get downloadSelected;

  /// No description provided for @copyToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copy to clipboard'**
  String get copyToClipboard;

  /// No description provided for @cutToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Cut to clipboard'**
  String get cutToClipboard;

  /// No description provided for @selectCloud.
  ///
  /// In en, this message translates to:
  /// **'Select Cloud'**
  String get selectCloud;

  /// No description provided for @closeSearch.
  ///
  /// In en, this message translates to:
  /// **'Close search'**
  String get closeSearch;

  /// No description provided for @uploadFromDevice.
  ///
  /// In en, this message translates to:
  /// **'Upload from device'**
  String get uploadFromDevice;

  /// No description provided for @moreOptions.
  ///
  /// In en, this message translates to:
  /// **'More options'**
  String get moreOptions;

  /// No description provided for @viewGrid.
  ///
  /// In en, this message translates to:
  /// **'Grid view'**
  String get viewGrid;

  /// No description provided for @viewList.
  ///
  /// In en, this message translates to:
  /// **'List view'**
  String get viewList;

  /// No description provided for @multiSelection.
  ///
  /// In en, this message translates to:
  /// **'Multiple selection'**
  String get multiSelection;

  /// No description provided for @sortNameAsc.
  ///
  /// In en, this message translates to:
  /// **'Name (A-Z)'**
  String get sortNameAsc;

  /// No description provided for @sortNameDesc.
  ///
  /// In en, this message translates to:
  /// **'Name (Z-A)'**
  String get sortNameDesc;

  /// No description provided for @sortSizeDesc.
  ///
  /// In en, this message translates to:
  /// **'Size (Large -> Small)'**
  String get sortSizeDesc;

  /// No description provided for @sortSizeAsc.
  ///
  /// In en, this message translates to:
  /// **'Size (Small -> Large)'**
  String get sortSizeAsc;

  /// No description provided for @sortDateDesc.
  ///
  /// In en, this message translates to:
  /// **'Date (Newest first)'**
  String get sortDateDesc;

  /// No description provided for @disableDualPane.
  ///
  /// In en, this message translates to:
  /// **'Disable Commander (Single Pane)'**
  String get disableDualPane;

  /// No description provided for @enableDualPane.
  ///
  /// In en, this message translates to:
  /// **'Enable Commander (Dual Pane)'**
  String get enableDualPane;

  /// No description provided for @itemsInClipboard.
  ///
  /// In en, this message translates to:
  /// **'{count} items in clipboard'**
  String itemsInClipboard(int count);

  /// No description provided for @pasteHere.
  ///
  /// In en, this message translates to:
  /// **'Paste here'**
  String get pasteHere;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get noResults;

  /// No description provided for @noMatchingResults.
  ///
  /// In en, this message translates to:
  /// **'No files or folders match \"{query}\"'**
  String noMatchingResults(String query);

  /// No description provided for @selectACloud.
  ///
  /// In en, this message translates to:
  /// **'Select a Cloud'**
  String get selectACloud;

  /// No description provided for @selectCloudDescription.
  ///
  /// In en, this message translates to:
  /// **'Select a cloud provider from the menu above to view and explore your remote files.'**
  String get selectCloudDescription;

  /// No description provided for @optionsForItem.
  ///
  /// In en, this message translates to:
  /// **'Options for {name}'**
  String optionsForItem(String name);

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @openWithSystemApp.
  ///
  /// In en, this message translates to:
  /// **'Open with system app'**
  String get openWithSystemApp;

  /// No description provided for @downloadToLocal.
  ///
  /// In en, this message translates to:
  /// **'Download to local'**
  String get downloadToLocal;

  /// No description provided for @cut.
  ///
  /// In en, this message translates to:
  /// **'Cut (Move)'**
  String get cut;

  /// No description provided for @copyPath.
  ///
  /// In en, this message translates to:
  /// **'Copy path'**
  String get copyPath;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get info;

  /// No description provided for @generatingShareLink.
  ///
  /// In en, this message translates to:
  /// **'Generating share link for \"{name}\"...'**
  String generatingShareLink(String name);

  /// No description provided for @errorPublicLink.
  ///
  /// In en, this message translates to:
  /// **'Public link error: {error}'**
  String errorPublicLink(String error);

  /// No description provided for @noLinkGenerated.
  ///
  /// In en, this message translates to:
  /// **'No link generated by provider.'**
  String get noLinkGenerated;

  /// No description provided for @errorDownloading.
  ///
  /// In en, this message translates to:
  /// **'Error downloading: {error}'**
  String errorDownloading(String error);

  /// No description provided for @renameFolderTitle.
  ///
  /// In en, this message translates to:
  /// **'Rename folder'**
  String get renameFolderTitle;

  /// No description provided for @renameFileTitle.
  ///
  /// In en, this message translates to:
  /// **'Rename file'**
  String get renameFileTitle;

  /// No description provided for @errorRenaming.
  ///
  /// In en, this message translates to:
  /// **'Error renaming: {error}'**
  String errorRenaming(String error);

  /// No description provided for @pathCopiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Path copied to clipboard'**
  String get pathCopiedToClipboard;

  /// No description provided for @itemDetailsPath.
  ///
  /// In en, this message translates to:
  /// **'Path: {path}'**
  String itemDetailsPath(String path);

  /// No description provided for @itemDetailsType.
  ///
  /// In en, this message translates to:
  /// **'Type: {type}'**
  String itemDetailsType(String type);

  /// No description provided for @itemDetailsSize.
  ///
  /// In en, this message translates to:
  /// **'Size: {size}'**
  String itemDetailsSize(String size);

  /// No description provided for @itemDetailsModified.
  ///
  /// In en, this message translates to:
  /// **'Modified date: {date}'**
  String itemDetailsModified(String date);

  /// No description provided for @folder.
  ///
  /// In en, this message translates to:
  /// **'Folder'**
  String get folder;

  /// No description provided for @file.
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get file;

  /// No description provided for @selectCloudFirstLeft.
  ///
  /// In en, this message translates to:
  /// **'Select a cloud in the left pane first.'**
  String get selectCloudFirstLeft;

  /// No description provided for @selectCloudFirstRight.
  ///
  /// In en, this message translates to:
  /// **'Select a cloud in the right pane first.'**
  String get selectCloudFirstRight;

  /// No description provided for @selectDestinationCloudLeft.
  ///
  /// In en, this message translates to:
  /// **'Select a destination cloud in the left pane first.'**
  String get selectDestinationCloudLeft;

  /// No description provided for @selectDestinationCloudRight.
  ///
  /// In en, this message translates to:
  /// **'Select a destination cloud in the right pane first.'**
  String get selectDestinationCloudRight;

  /// No description provided for @noFilesToTransfer.
  ///
  /// In en, this message translates to:
  /// **'No files present or selected to transfer.'**
  String get noFilesToTransfer;

  /// No description provided for @transferStarted.
  ///
  /// In en, this message translates to:
  /// **'{action} of {count} items from [{src}] to [{dst}] started...'**
  String transferStarted(String action, int count, String src, String dst);

  /// No description provided for @swapPanesTooltip.
  ///
  /// In en, this message translates to:
  /// **'Swap panes (<->)'**
  String get swapPanesTooltip;

  /// No description provided for @refreshBothPanesTooltip.
  ///
  /// In en, this message translates to:
  /// **'Refresh both panes'**
  String get refreshBothPanesTooltip;

  /// No description provided for @copyRight.
  ///
  /// In en, this message translates to:
  /// **'Copy to right ->'**
  String get copyRight;

  /// No description provided for @moveRight.
  ///
  /// In en, this message translates to:
  /// **'Move to right ->'**
  String get moveRight;

  /// No description provided for @copyLeft.
  ///
  /// In en, this message translates to:
  /// **'<- Copy to left'**
  String get copyLeft;

  /// No description provided for @moveLeft.
  ///
  /// In en, this message translates to:
  /// **'<- Move to left'**
  String get moveLeft;

  /// No description provided for @copyRightWithCount.
  ///
  /// In en, this message translates to:
  /// **'Copy right ({count}) ->'**
  String copyRightWithCount(int count);

  /// No description provided for @moveRightWithCount.
  ///
  /// In en, this message translates to:
  /// **'Move right ({count}) ->'**
  String moveRightWithCount(int count);

  /// No description provided for @copyLeftWithCount.
  ///
  /// In en, this message translates to:
  /// **'<- Copy left ({count})'**
  String copyLeftWithCount(int count);

  /// No description provided for @moveLeftWithCount.
  ///
  /// In en, this message translates to:
  /// **'<- Move left ({count})'**
  String moveLeftWithCount(int count);

  /// No description provided for @deleteRuleTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Rule'**
  String get deleteRuleTitle;

  /// No description provided for @deleteRulePrompt.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete sync rule \"{name}\"? Files on your device and in the cloud will not be deleted.'**
  String deleteRulePrompt(String name);

  /// No description provided for @syncAll.
  ///
  /// In en, this message translates to:
  /// **'Sync All'**
  String get syncAll;

  /// No description provided for @newRuleTooltip.
  ///
  /// In en, this message translates to:
  /// **'New rule'**
  String get newRuleTooltip;

  /// No description provided for @backupBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Continuous Backup & Cloud Sync'**
  String get backupBannerTitle;

  /// No description provided for @backupBannerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Configure scheduled synchronizations between local folders and cloud remotes.'**
  String get backupBannerSubtitle;

  /// No description provided for @noActiveRules.
  ///
  /// In en, this message translates to:
  /// **'No Active Rules'**
  String get noActiveRules;

  /// No description provided for @noActiveRulesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create your first rule to run automatic backups from your phone to Google Drive, Dropbox, SFTP or any other cloud.'**
  String get noActiveRulesSubtitle;

  /// No description provided for @createNewRule.
  ///
  /// In en, this message translates to:
  /// **'Create New Rule'**
  String get createNewRule;

  /// No description provided for @ruleOptionsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Rule options'**
  String get ruleOptionsTooltip;

  /// No description provided for @syncNow.
  ///
  /// In en, this message translates to:
  /// **'Sync now'**
  String get syncNow;

  /// No description provided for @statusWaiting.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statusWaiting;

  /// No description provided for @statusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress...'**
  String get statusInProgress;

  /// No description provided for @statusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statusCompleted;

  /// No description provided for @statusFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get statusFailed;

  /// No description provided for @editRuleTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Backup Rule'**
  String get editRuleTitle;

  /// No description provided for @newRuleTitle.
  ///
  /// In en, this message translates to:
  /// **'New Synchronization Rule'**
  String get newRuleTitle;

  /// No description provided for @ruleDialogSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Configure automatic backup between a local folder and the cloud.'**
  String get ruleDialogSubtitle;

  /// No description provided for @ruleNameOptional.
  ///
  /// In en, this message translates to:
  /// **'Rule Name (optional)'**
  String get ruleNameOptional;

  /// No description provided for @ruleNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. DCIM Photo Backup or Work Documents'**
  String get ruleNameHint;

  /// No description provided for @sourceLocalFolder.
  ///
  /// In en, this message translates to:
  /// **'Local Source Folder'**
  String get sourceLocalFolder;

  /// No description provided for @sourceLocalFolderHint.
  ///
  /// In en, this message translates to:
  /// **'/storage/emulated/0/DCIM or /home/user/Pictures'**
  String get sourceLocalFolderHint;

  /// No description provided for @browseFolders.
  ///
  /// In en, this message translates to:
  /// **'Browse folders'**
  String get browseFolders;

  /// No description provided for @selectLocalFolderError.
  ///
  /// In en, this message translates to:
  /// **'Please enter or select a local folder'**
  String get selectLocalFolderError;

  /// No description provided for @noCloudsConfiguredSync.
  ///
  /// In en, this message translates to:
  /// **'No cloud configured. Configure a cloud account from Home before continuing.'**
  String get noCloudsConfiguredSync;

  /// No description provided for @remoteDestinationPath.
  ///
  /// In en, this message translates to:
  /// **'Remote Destination Path'**
  String get remoteDestinationPath;

  /// No description provided for @syncMode.
  ///
  /// In en, this message translates to:
  /// **'Sync Mode'**
  String get syncMode;

  /// No description provided for @syncModeCopy.
  ///
  /// In en, this message translates to:
  /// **'Incremental Backup'**
  String get syncModeCopy;

  /// No description provided for @syncModeCopyDesc.
  ///
  /// In en, this message translates to:
  /// **'Uploads new and modified files, preserving existing cloud files.'**
  String get syncModeCopyDesc;

  /// No description provided for @syncModeSync.
  ///
  /// In en, this message translates to:
  /// **'Mirror Synchronization'**
  String get syncModeSync;

  /// No description provided for @syncModeSyncDesc.
  ///
  /// In en, this message translates to:
  /// **'Makes the remote destination identical to the local folder (deletions locally are deleted on cloud).'**
  String get syncModeSyncDesc;

  /// No description provided for @syncFrequency.
  ///
  /// In en, this message translates to:
  /// **'Execution Frequency'**
  String get syncFrequency;

  /// No description provided for @freqManual.
  ///
  /// In en, this message translates to:
  /// **'Manual (on demand only)'**
  String get freqManual;

  /// No description provided for @freq15Min.
  ///
  /// In en, this message translates to:
  /// **'Every 15 minutes'**
  String get freq15Min;

  /// No description provided for @freq30Min.
  ///
  /// In en, this message translates to:
  /// **'Every 30 minutes'**
  String get freq30Min;

  /// No description provided for @freqHourly.
  ///
  /// In en, this message translates to:
  /// **'Every hour'**
  String get freqHourly;

  /// No description provided for @freq6Hours.
  ///
  /// In en, this message translates to:
  /// **'Every 6 hours'**
  String get freq6Hours;

  /// No description provided for @freq12Hours.
  ///
  /// In en, this message translates to:
  /// **'Every 12 hours'**
  String get freq12Hours;

  /// No description provided for @freqDaily.
  ///
  /// In en, this message translates to:
  /// **'Every day (24 hours)'**
  String get freqDaily;

  /// No description provided for @activateRuleImmediately.
  ///
  /// In en, this message translates to:
  /// **'Activate rule immediately'**
  String get activateRuleImmediately;

  /// No description provided for @activateRuleImmediatelyDesc.
  ///
  /// In en, this message translates to:
  /// **'Sync will run in background according to the specified interval'**
  String get activateRuleImmediatelyDesc;

  /// No description provided for @updateRule.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get updateRule;

  /// No description provided for @saveRule.
  ///
  /// In en, this message translates to:
  /// **'Save Rule'**
  String get saveRule;

  /// No description provided for @selectCloudProvider.
  ///
  /// In en, this message translates to:
  /// **'Select Cloud Provider:'**
  String get selectCloudProvider;

  /// No description provided for @cloudAccountName.
  ///
  /// In en, this message translates to:
  /// **'Cloud Account Name'**
  String get cloudAccountName;

  /// No description provided for @cloudAccountNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. GoogleDrive, WorkDropbox (no spaces)'**
  String get cloudAccountNameHint;

  /// No description provided for @enterNameError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get enterNameError;

  /// No description provided for @noSpacesOrColons.
  ///
  /// In en, this message translates to:
  /// **'Spaces and \":\" are not allowed'**
  String get noSpacesOrColons;

  /// No description provided for @oauthMode.
  ///
  /// In en, this message translates to:
  /// **'Client ID Mode (OAuth2)'**
  String get oauthMode;

  /// No description provided for @oauthOfficial.
  ///
  /// In en, this message translates to:
  /// **'UnifyCloud (Official / Recommended)'**
  String get oauthOfficial;

  /// No description provided for @oauthRclone.
  ///
  /// In en, this message translates to:
  /// **'Rclone (Not recommended - Shared quota)'**
  String get oauthRclone;

  /// No description provided for @oauthCustom.
  ///
  /// In en, this message translates to:
  /// **'Personal Client ID (Advanced)'**
  String get oauthCustom;

  /// No description provided for @officialOauthTitle.
  ///
  /// In en, this message translates to:
  /// **'Official UnifyCloud Credentials'**
  String get officialOauthTitle;

  /// No description provided for @officialOauthDesc.
  ///
  /// In en, this message translates to:
  /// **'Pre-configured credentials to connect immediately with dedicated quota and maximum speed.'**
  String get officialOauthDesc;

  /// No description provided for @rcloneOauthDesc.
  ///
  /// In en, this message translates to:
  /// **'Shared open-source Rclone keys. May encounter rate-limits or temporary Google 403 errors.'**
  String get rcloneOauthDesc;

  /// No description provided for @customClientId.
  ///
  /// In en, this message translates to:
  /// **'Client ID'**
  String get customClientId;

  /// No description provided for @customClientSecret.
  ///
  /// In en, this message translates to:
  /// **'Client Secret'**
  String get customClientSecret;

  /// No description provided for @selectVaultDestination.
  ///
  /// In en, this message translates to:
  /// **'Select destination cloud for Vault'**
  String get selectVaultDestination;

  /// No description provided for @vaultPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Vault encryption password is required'**
  String get vaultPasswordRequired;

  /// No description provided for @vaultPasswordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get vaultPasswordsDoNotMatch;

  /// No description provided for @errorAddingRemote.
  ///
  /// In en, this message translates to:
  /// **'Error adding remote: {error}'**
  String errorAddingRemote(String error);

  /// No description provided for @fileNameEncryption.
  ///
  /// In en, this message translates to:
  /// **'File Name Encryption'**
  String get fileNameEncryption;

  /// No description provided for @encryptStandard.
  ///
  /// In en, this message translates to:
  /// **'Standard (Fully encrypted file names - Recommended)'**
  String get encryptStandard;

  /// No description provided for @encryptObscure.
  ///
  /// In en, this message translates to:
  /// **'Simple Obfuscation (Preserves extensions)'**
  String get encryptObscure;

  /// No description provided for @encryptOff.
  ///
  /// In en, this message translates to:
  /// **'Disabled (Visible file names)'**
  String get encryptOff;

  /// No description provided for @encryptFolderNames.
  ///
  /// In en, this message translates to:
  /// **'Also encrypt folder names'**
  String get encryptFolderNames;

  /// No description provided for @encryptFolderNamesDesc.
  ///
  /// In en, this message translates to:
  /// **'Completely conceals directory structure on the cloud'**
  String get encryptFolderNamesDesc;

  /// No description provided for @connectCloud.
  ///
  /// In en, this message translates to:
  /// **'Connect Cloud'**
  String get connectCloud;

  /// No description provided for @reopenAuth.
  ///
  /// In en, this message translates to:
  /// **'Reopen'**
  String get reopenAuth;

  /// No description provided for @linkCopiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Link copied to clipboard!'**
  String get linkCopiedToClipboard;

  /// No description provided for @errorOpenBrowserGeneric.
  ///
  /// In en, this message translates to:
  /// **'Unable to open browser: {error}'**
  String errorOpenBrowserGeneric(String error);

  /// No description provided for @shareableLinkTitle.
  ///
  /// In en, this message translates to:
  /// **'Shareable Link'**
  String get shareableLinkTitle;

  /// No description provided for @shareLinkAccessDescription.
  ///
  /// In en, this message translates to:
  /// **'Anyone with this link will be able to access {item}:'**
  String shareLinkAccessDescription(String item);

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @activeTransfersCount.
  ///
  /// In en, this message translates to:
  /// **'{count} active transfers'**
  String activeTransfersCount(int count);

  /// No description provided for @transfersQueueCount.
  ///
  /// In en, this message translates to:
  /// **'Transfer Queue ({count})'**
  String transfersQueueCount(int count);

  /// No description provided for @noTransfersInProgress.
  ///
  /// In en, this message translates to:
  /// **'No transfers in progress'**
  String get noTransfersInProgress;

  /// No description provided for @transfersEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'All downloaded or uploaded files will appear here'**
  String get transfersEmptySubtitle;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @appLockedTitle.
  ///
  /// In en, this message translates to:
  /// **'Application Locked'**
  String get appLockedTitle;

  /// No description provided for @unlockWithBiometrics.
  ///
  /// In en, this message translates to:
  /// **'Unlock with Biometrics'**
  String get unlockWithBiometrics;

  /// No description provided for @pinMustBe6Digits.
  ///
  /// In en, this message translates to:
  /// **'PIN must be exactly 6 digits'**
  String get pinMustBe6Digits;

  /// No description provided for @pinIncorrect.
  ///
  /// In en, this message translates to:
  /// **'Incorrect PIN. Try again.'**
  String get pinIncorrect;

  /// No description provided for @pinsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'PINs do not match. Try again.'**
  String get pinsDoNotMatch;

  /// No description provided for @pinStepOld.
  ///
  /// In en, this message translates to:
  /// **'Enter your current PIN to continue.'**
  String get pinStepOld;

  /// No description provided for @pinStepNew.
  ///
  /// In en, this message translates to:
  /// **'Enter your new 6-digit security PIN.'**
  String get pinStepNew;

  /// No description provided for @pinStepConfirm.
  ///
  /// In en, this message translates to:
  /// **'Re-enter the new PIN to confirm.'**
  String get pinStepConfirm;

  /// No description provided for @pinStepVerify.
  ///
  /// In en, this message translates to:
  /// **'Enter your PIN to confirm the operation.'**
  String get pinStepVerify;

  /// No description provided for @pinTitleSetup.
  ///
  /// In en, this message translates to:
  /// **'Setup Security PIN'**
  String get pinTitleSetup;

  /// No description provided for @pinTitleChange.
  ///
  /// In en, this message translates to:
  /// **'Change Security PIN'**
  String get pinTitleChange;

  /// No description provided for @pinTitleVerify.
  ///
  /// In en, this message translates to:
  /// **'Security Verification'**
  String get pinTitleVerify;

  /// No description provided for @pinContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get pinContinue;

  /// No description provided for @errorDetails.
  ///
  /// In en, this message translates to:
  /// **'Error Details'**
  String get errorDetails;

  /// No description provided for @errorDetailsCopied.
  ///
  /// In en, this message translates to:
  /// **'Error details copied to clipboard'**
  String get errorDetailsCopied;

  /// No description provided for @collapse.
  ///
  /// In en, this message translates to:
  /// **'Collapse'**
  String get collapse;

  /// No description provided for @expand.
  ///
  /// In en, this message translates to:
  /// **'Expand'**
  String get expand;

  /// No description provided for @copyError.
  ///
  /// In en, this message translates to:
  /// **'Copy error'**
  String get copyError;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'No connection or unstable network. Check your internet connection and try again.'**
  String get errorNetwork;

  /// No description provided for @errorDiskSpace.
  ///
  /// In en, this message translates to:
  /// **'Insufficient storage space or disk full. Free up memory to continue.'**
  String get errorDiskSpace;

  /// No description provided for @errorAuthExpired.
  ///
  /// In en, this message translates to:
  /// **'Session or token expired/revoked. Reconnect your account.'**
  String get errorAuthExpired;

  /// No description provided for @errorNotFound.
  ///
  /// In en, this message translates to:
  /// **'Item or folder not found on cloud provider.'**
  String get errorNotFound;

  /// No description provided for @errorPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Permission denied for this operation on cloud.'**
  String get errorPermissionDenied;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'An error occurred during the operation.'**
  String get errorGeneric;

  /// No description provided for @desktopAndSystem.
  ///
  /// In en, this message translates to:
  /// **'Desktop & System'**
  String get desktopAndSystem;

  /// No description provided for @desktopAndSystemSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Startup behavior, background execution, and system tray'**
  String get desktopAndSystemSubtitle;

  /// No description provided for @autostartOnBoot.
  ///
  /// In en, this message translates to:
  /// **'Start on system boot'**
  String get autostartOnBoot;

  /// No description provided for @autostartOnBootSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Automatically launch UnifyCloud in the background on login'**
  String get autostartOnBootSubtitle;

  /// No description provided for @minimizeToTray.
  ///
  /// In en, this message translates to:
  /// **'Minimize to system tray'**
  String get minimizeToTray;

  /// No description provided for @minimizeToTraySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Keep UnifyCloud running in the background when the window is closed'**
  String get minimizeToTraySubtitle;

  /// No description provided for @trayStatusIdle.
  ///
  /// In en, this message translates to:
  /// **'Idle (No active transfers)'**
  String get trayStatusIdle;

  /// No description provided for @trayStatusActive.
  ///
  /// In en, this message translates to:
  /// **'{count} active transfers ({speed})'**
  String trayStatusActive(int count, String speed);

  /// No description provided for @trayShowWindow.
  ///
  /// In en, this message translates to:
  /// **'Show UnifyCloud'**
  String get trayShowWindow;

  /// No description provided for @trayHideWindow.
  ///
  /// In en, this message translates to:
  /// **'Hide to system tray'**
  String get trayHideWindow;

  /// No description provided for @trayQuit.
  ///
  /// In en, this message translates to:
  /// **'Quit UnifyCloud'**
  String get trayQuit;

  /// No description provided for @trayTooltip.
  ///
  /// In en, this message translates to:
  /// **'UnifyCloud - Cloud Storage Manager'**
  String get trayTooltip;
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
    'de',
    'en',
    'es',
    'fr',
    'hi',
    'it',
    'ja',
    'ko',
    'nl',
    'pl',
    'pt',
    'ru',
    'tr',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'nl':
      return AppLocalizationsNl();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'tr':
      return AppLocalizationsTr();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
