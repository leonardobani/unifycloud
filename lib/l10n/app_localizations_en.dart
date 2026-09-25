// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'UnifyCloud';

  @override
  String get home => 'Home';

  @override
  String get explorer => 'Explorer';

  @override
  String get sync => 'Sync';

  @override
  String get settings => 'Settings';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get delete => 'Delete';

  @override
  String get save => 'Save';

  @override
  String get close => 'Close';

  @override
  String get edit => 'Edit';

  @override
  String get create => 'Create';

  @override
  String get retry => 'Retry';

  @override
  String get copy => 'Copy';

  @override
  String get move => 'Move';

  @override
  String get rename => 'Rename';

  @override
  String get download => 'Download';

  @override
  String get upload => 'Upload';

  @override
  String get share => 'Share';

  @override
  String get details => 'Details';

  @override
  String get search => 'Search';

  @override
  String get change => 'Change';

  @override
  String get reset => 'Reset';

  @override
  String get done => 'Done';

  @override
  String get loading => 'Loading...';

  @override
  String get success => 'Operation completed';

  @override
  String get error => 'Error';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get resetDefaultsTooltip => 'Restore Default Settings';

  @override
  String get resetDialogTitle => 'Reset Settings';

  @override
  String get resetDialogContent =>
      'Do you want to reset all preferences (theme, language, folders, display) to factory defaults?';

  @override
  String get resetSuccessSnackbar => 'Settings restored to default values';

  @override
  String get appearanceAndTheme => 'Appearance & Theme';

  @override
  String get chooseVisualThemeSubtitle =>
      'Choose visual theme for UnifyCloud interface:';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get language => 'Language';

  @override
  String get languageSubtitle => 'Select application interface language';

  @override
  String get langEnglish => 'English';

  @override
  String get langItalian => 'Italiano';

  @override
  String get langSystem => 'System Default';

  @override
  String get filesAndExploration => 'Files & Exploration';

  @override
  String get showHiddenFiles => 'Show hidden files';

  @override
  String get showHiddenFilesSubtitle =>
      'Display files and folders starting with a dot';

  @override
  String get confirmBeforeDelete => 'Confirm before deleting';

  @override
  String get confirmBeforeDeleteSubtitle =>
      'Ask for confirmation before permanently deleting files';

  @override
  String get defaultDownloadFolder => 'Default Download Folder';

  @override
  String get defaultDownloadFolderSystem => 'System default download directory';

  @override
  String get restoreDefaultPath => 'Restore default path';

  @override
  String get customDownloadFolderDialogPrompt =>
      'Select a folder using the system picker or enter the desired path manually:';

  @override
  String get folderPath => 'Folder path';

  @override
  String get folderPathHint => 'e.g. /home/user/Downloads';

  @override
  String get browseWithSystemPicker => 'Browse with system picker';

  @override
  String errorOpenPicker(String error) {
    return 'Unable to open system picker: $error';
  }

  @override
  String get restoreDefault => 'Restore default';

  @override
  String get maxConcurrentTransfers => 'Concurrent Transfers';

  @override
  String get maxConcurrentTransfersSubtitle =>
      'Maximum number of simultaneous active file transfers';

  @override
  String get dualPaneMode => 'Dual-Pane Commander Mode';

  @override
  String get dualPaneModeSubtitle =>
      'Show two side-by-side panes on wide screens and tablets';

  @override
  String get communityAndSupport => 'Community & Support';

  @override
  String get openSourceDescription =>
      'UnifyCloud is free and open-source software built to unify your cloud data without trackers or proprietary intermediaries.';

  @override
  String get supportDeveloper => 'Support the Developer';

  @override
  String get supportDeveloperSubtitle =>
      'Buy a coffee to support independent development';

  @override
  String get viewSourceOnGitLab => 'View Code on GitLab';

  @override
  String get viewSourceOnGitLabSubtitle =>
      'Official repository, bug reports, and contributions';

  @override
  String errorOpenBrowser(String url) {
    return 'Unable to open browser. Repository: $url';
  }

  @override
  String get supportDialogTitle => 'Support UnifyCloud';

  @override
  String get supportDialogDescription1 =>
      'UnifyCloud is a free and open-source project designed to give you full control over your cloud files.';

  @override
  String get supportDialogDescription2 =>
      'If you find this application helpful, consider buying a coffee or donating to support continuous development and new features!';

  @override
  String get supportKofiTitle => 'Buy a coffee on Ko-fi';

  @override
  String get supportLiberapayTitle => 'Donate on Liberapay';

  @override
  String get supportPaypalTitle => 'Donate via PayPal';

  @override
  String get securityAndEncryption => 'Security & Encryption';

  @override
  String get securityArchitectureDescription =>
      'UnifyCloud employs a Zero-Plaintext architecture. All OAuth tokens and credentials are securely protected in the system Keychain/Keystore and injected exclusively into Go engine RAM memory.';

  @override
  String get appLock => 'App Lock (PIN / Biometrics)';

  @override
  String get appLockSubtitle => 'Require PIN or fingerprint to access';

  @override
  String get appLockActiveSubtitle => 'Active at startup and after inactivity';

  @override
  String get appLockEnabledSnackbar => 'App Lock enabled successfully';

  @override
  String get appLockDisabledSnackbar => 'App Lock disabled';

  @override
  String get changePin => 'Change PIN';

  @override
  String get changePinSubtitle => 'Set a new 6-digit security PIN';

  @override
  String get pinChangedSnackbar => 'Security PIN updated successfully';

  @override
  String get biometricAuth => 'Biometric Authentication';

  @override
  String get biometricAuthSubtitle =>
      'Use fingerprint or biometric sensor if available';

  @override
  String get biometricNotAvailable =>
      'Not available or not configured on this device';

  @override
  String get autoLock => 'Auto Lock';

  @override
  String get autoLockSubtitle => 'Background inactivity timeout before locking';

  @override
  String get lockImmediately => 'Immediately';

  @override
  String get lockAfter1Minute => 'After 1 minute';

  @override
  String get lockAfter5Minutes => 'After 5 minutes';

  @override
  String get lockAfter15Minutes => 'After 15 minutes';

  @override
  String get lockAfter30Minutes => 'After 30 minutes';

  @override
  String get syncCloudAccounts => 'Sync Cloud Accounts';

  @override
  String get syncCloudAccountsSubtitle =>
      'Reload configurations from secure storage';

  @override
  String get syncCloudAccountsSuccess => 'Cloud accounts reloaded successfully';

  @override
  String get clearAllCredentials => 'Clear All Credentials';

  @override
  String get clearAllCredentialsSubtitle =>
      'Removes encrypted configuration and disconnects all clouds';

  @override
  String get clearCredentialsDialogTitle => 'Warning: Reset Credentials';

  @override
  String get clearCredentialsDialogContent =>
      'Are you sure you want to delete all saved credentials? You will need to reconnect your cloud accounts.';

  @override
  String get clearCredentialsSuccess => 'Credentials deleted successfully';

  @override
  String get aboutUnifyCloud => 'About UnifyCloud';

  @override
  String get appVersion => 'App Version: 1.0.0';

  @override
  String get developerInfo => 'Developer: LeoRise (@leorise25)';

  @override
  String get engineInfo => 'Engine: Rclone Core CGO (Go v1.22+ / C FFI)';

  @override
  String get frameworkInfo => 'Framework: Flutter (Material 3 Responsive)';

  @override
  String get licenseInfo =>
      'License: GNU General Public License v3.0 (GPL-3.0)';

  @override
  String get copyrightInfo => 'Copyright: © 2026 Leonardo Bani';

  @override
  String get storageOverview => 'Storage Overview';

  @override
  String get connectedClouds => 'Connected Clouds';

  @override
  String get noCloudsConfigured => 'No cloud accounts configured';

  @override
  String get noCloudsDescription =>
      'Connect your first cloud storage account to start managing and syncing files.';

  @override
  String get addCloud => 'Add Cloud';

  @override
  String get used => 'used';

  @override
  String get free => 'free';

  @override
  String get total => 'total';

  @override
  String get manageAccounts => 'Manage Accounts';

  @override
  String get viewFiles => 'View Files';

  @override
  String get createVaultHere => 'Create Encrypted Vault here...';

  @override
  String get disconnectAccount => 'Disconnect account';

  @override
  String get disconnectConfirmTitle => 'Disconnect account?';

  @override
  String get disconnectConfirmContent =>
      'Are you sure you want to disconnect this account? Remote files will remain intact.';

  @override
  String get allFiles => 'All Files';

  @override
  String get emptyFolder => 'This folder is empty';

  @override
  String get emptyFolderSubtitle =>
      'Upload files or create a subfolder to get started.';

  @override
  String get uploadFile => 'Upload file';

  @override
  String get uploadFolder => 'Upload entire folder';

  @override
  String get newFolder => 'New Folder';

  @override
  String get newFolderPrompt => 'Enter the name for the new folder:';

  @override
  String get folderNameHint => 'Folder name';

  @override
  String get selectAll => 'Select all';

  @override
  String get clearSelection => 'Clear selection';

  @override
  String get deleteSelected => 'Delete selected';

  @override
  String get deleteSelectedPrompt =>
      'Are you sure you want to delete the selected items?';

  @override
  String get deleteItemPrompt => 'Are you sure you want to delete this item?';

  @override
  String get shareLink => 'Share Link';

  @override
  String get createShareLink => 'Create shareable link';

  @override
  String get copyShareLink => 'Copy Link';

  @override
  String get copiedToClipboard => 'Copied to clipboard';

  @override
  String get transfers => 'Transfers';

  @override
  String get activeTransfers => 'Active Transfers';

  @override
  String get completed => 'Completed';

  @override
  String get failed => 'Failed';

  @override
  String get queued => 'Queued';

  @override
  String get cancelTransfer => 'Cancel transfer';

  @override
  String get clearCompleted => 'Clear completed';

  @override
  String get syncRulesTitle => 'Backup & Sync Rules';

  @override
  String get newRule => 'New Rule';

  @override
  String get noSyncRules => 'No synchronization rules configured';

  @override
  String get noSyncRulesSubtitle =>
      'Create an automated rule to sync local folders with your cloud storage.';

  @override
  String get ruleName => 'Rule Name';

  @override
  String get sourcePath => 'Source Folder';

  @override
  String get destinationCloud => 'Destination Cloud';

  @override
  String get destinationPath => 'Remote Path';

  @override
  String get direction => 'Direction';

  @override
  String get frequency => 'Frequency';

  @override
  String get runNow => 'Run Now';

  @override
  String get syncInProgress => 'Synchronization in progress...';

  @override
  String get syncSuccess => 'Synchronization completed';

  @override
  String get syncFailed => 'Synchronization failed';

  @override
  String get addCloudDialogTitle => 'Connect New Cloud';

  @override
  String get selectProvider => 'Select Cloud Provider';

  @override
  String get accountNameLabel => 'Account Name / Alias';

  @override
  String get connectButton => 'Connect Account';

  @override
  String get vaultTitle => 'E2E Encryption (Crypt)';

  @override
  String get vaultPassword => 'Vault Password';

  @override
  String get vaultConfirmPassword => 'Confirm Password';

  @override
  String get vaultSalt => 'Salt / Secondary Password (Optional)';

  @override
  String get encryptFileNames => 'Encrypt file names';

  @override
  String get encryptDirNames => 'Encrypt directory names';
}
