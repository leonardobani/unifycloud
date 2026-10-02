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

  @override
  String get langSpanish => 'Español';

  @override
  String get langFrench => 'Français';

  @override
  String get langGerman => 'Deutsch';

  @override
  String get langPortuguese => 'Português';

  @override
  String get langRussian => 'Русский';

  @override
  String get langChinese => '简体中文';

  @override
  String get langJapanese => '日本語';

  @override
  String get langKorean => '한국어';

  @override
  String get langArabic => 'العربية';

  @override
  String get langHindi => 'हिन्दी';

  @override
  String get langDutch => 'Nederlands';

  @override
  String get langPolish => 'Polski';

  @override
  String get langTurkish => 'Türkçe';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get searchLanguageHint => 'Search language or country...';

  @override
  String get currentLanguage => 'Current Language';

  @override
  String systemDefaultWithLocale(String locale) {
    return 'System Default ($locale)';
  }

  @override
  String get refreshCloudsTooltip => 'Refresh cloud configurations';

  @override
  String get storageOverviewAggregated => 'Aggregated Storage Overview';

  @override
  String get ramEncryptionActive => 'RAM Encryption Active';

  @override
  String connectedAccountsCount(int count) {
    return 'Connected Cloud Accounts: $count';
  }

  @override
  String get noCloudsConfiguredHint =>
      'No cloud accounts configured. Tap \"+ Connect New Cloud\" below.';

  @override
  String percentUsed(String percent) {
    return '$percent% used';
  }

  @override
  String availableSpace(String space) {
    return '$space available';
  }

  @override
  String get calculatingQuota =>
      'Calculating storage quotas or unlimited space...';

  @override
  String get syncAndBackup => 'Sync & Backup';

  @override
  String get noRulesConfigured => 'No rules configured';

  @override
  String activeRulesCount(int active, int total) {
    return '$active/$total active rules';
  }

  @override
  String get manage => 'Manage';

  @override
  String connectedCloudsCount(int count) {
    return 'Connected Clouds ($count)';
  }

  @override
  String get connectNewCloud => 'Connect New Cloud';

  @override
  String get noCloudProvidersConnected => 'No Cloud Providers Connected';

  @override
  String get connectCloudDescription =>
      'Connect Google Drive, Dropbox, OneDrive, SFTP or WebDAV to start syncing and exploring your files.';

  @override
  String get addFirstCloud => 'Add First Cloud';

  @override
  String vaultOnRemote(String remote) {
    return 'VAULT ON $remote';
  }

  @override
  String get disconnectCloudTitle => 'Disconnect Cloud';

  @override
  String disconnectCloudPrompt(String name) {
    return 'Do you want to disconnect \"$name\"? Credentials will be removed from encrypted storage.';
  }

  @override
  String get disconnect => 'Disconnect';

  @override
  String freeSpace(String space) {
    return '$space free';
  }

  @override
  String get storage => 'Storage';

  @override
  String get available => 'Available';

  @override
  String get exploreFiles => 'Explore Files';

  @override
  String get paneLeft => 'Left';

  @override
  String get paneRight => 'Right';

  @override
  String get folderName => 'Folder name';

  @override
  String errorCreatingFolder(String error) {
    return 'Error creating folder: $error';
  }

  @override
  String get moveAction => 'Move';

  @override
  String get copyAction => 'Copy';

  @override
  String transferBatchStarted(String action, int count, String remote) {
    return '$action of $count items to [$remote] started...';
  }

  @override
  String errorTransferring(String error) {
    return 'Error during transfer: $error';
  }

  @override
  String itemCopiedToClipboard(String name) {
    return '\"$name\" copied to clipboard';
  }

  @override
  String itemsCopiedToClipboard(int count) {
    return '$count items copied to clipboard';
  }

  @override
  String itemCutToClipboard(String name) {
    return '\"$name\" cut (ready to move)';
  }

  @override
  String itemsCutToClipboard(int count) {
    return '$count items cut (ready to move)';
  }

  @override
  String get noFilesSelectedForDownload => 'No files selected for download.';

  @override
  String downloadingItems(int count) {
    return 'Downloading $count items...';
  }

  @override
  String itemsDownloadedSuccess(int count, String path) {
    return '$count items downloaded to \"$path\"';
  }

  @override
  String errorStartingDownload(String error) {
    return 'Error starting download: $error';
  }

  @override
  String deleteItemsConfirmTitle(int count) {
    return 'Delete $count selected items?';
  }

  @override
  String deleteItemsConfirmPrompt(int count) {
    return 'Are you sure you want to permanently delete $count selected items from the cloud?';
  }

  @override
  String itemsDeletedSuccess(int count) {
    return '$count items deleted';
  }

  @override
  String errorDeleting(String error) {
    return 'Error during deletion: $error';
  }

  @override
  String get uploadCompletedSuccess => 'Upload completed successfully';

  @override
  String errorUploading(String error) {
    return 'Error during upload: $error';
  }

  @override
  String get folderUploadCompletedSuccess =>
      'Folder upload completed successfully';

  @override
  String errorFolderUploading(String error) {
    return 'Error uploading folder: $error';
  }

  @override
  String get filesAlreadyInDirectory => 'Files are already in this folder.';

  @override
  String dragDropTransferStarted(String action, int count, String remote) {
    return '$action of $count items to [$remote] started...';
  }

  @override
  String errorDragDrop(String error) {
    return 'Error during drag-and-drop transfer: $error';
  }

  @override
  String get closeSelection => 'Close selection';

  @override
  String itemsSelectedCount(int count) {
    return '$count selected';
  }

  @override
  String get deselectAll => 'Deselect all';

  @override
  String copyToRemote(String remote) {
    return 'Copy to $remote';
  }

  @override
  String moveToRemote(String remote) {
    return 'Move to $remote';
  }

  @override
  String get moreActions => 'More actions';

  @override
  String get downloadSelected => 'Download selected';

  @override
  String get copyToClipboard => 'Copy to clipboard';

  @override
  String get cutToClipboard => 'Cut to clipboard';

  @override
  String get selectCloud => 'Select Cloud';

  @override
  String get closeSearch => 'Close search';

  @override
  String get uploadFromDevice => 'Upload from device';

  @override
  String get moreOptions => 'More options';

  @override
  String get viewGrid => 'Grid view';

  @override
  String get viewList => 'List view';

  @override
  String get multiSelection => 'Multiple selection';

  @override
  String get sortNameAsc => 'Name (A-Z)';

  @override
  String get sortNameDesc => 'Name (Z-A)';

  @override
  String get sortSizeDesc => 'Size (Large -> Small)';

  @override
  String get sortSizeAsc => 'Size (Small -> Large)';

  @override
  String get sortDateDesc => 'Date (Newest first)';

  @override
  String get disableDualPane => 'Disable Commander (Single Pane)';

  @override
  String get enableDualPane => 'Enable Commander (Dual Pane)';

  @override
  String itemsInClipboard(int count) {
    return '$count items in clipboard';
  }

  @override
  String get pasteHere => 'Paste here';

  @override
  String get noResults => 'No results';

  @override
  String noMatchingResults(String query) {
    return 'No files or folders match \"$query\"';
  }

  @override
  String get selectACloud => 'Select a Cloud';

  @override
  String get selectCloudDescription =>
      'Select a cloud provider from the menu above to view and explore your remote files.';

  @override
  String optionsForItem(String name) {
    return 'Options for $name';
  }

  @override
  String get select => 'Select';

  @override
  String get openWithSystemApp => 'Open with system app';

  @override
  String get downloadToLocal => 'Download to local';

  @override
  String get cut => 'Cut (Move)';

  @override
  String get copyPath => 'Copy path';

  @override
  String get info => 'Information';

  @override
  String generatingShareLink(String name) {
    return 'Generating share link for \"$name\"...';
  }

  @override
  String errorPublicLink(String error) {
    return 'Public link error: $error';
  }

  @override
  String get noLinkGenerated => 'No link generated by provider.';

  @override
  String errorDownloading(String error) {
    return 'Error downloading: $error';
  }

  @override
  String get renameFolderTitle => 'Rename folder';

  @override
  String get renameFileTitle => 'Rename file';

  @override
  String errorRenaming(String error) {
    return 'Error renaming: $error';
  }

  @override
  String get pathCopiedToClipboard => 'Path copied to clipboard';

  @override
  String itemDetailsPath(String path) {
    return 'Path: $path';
  }

  @override
  String itemDetailsType(String type) {
    return 'Type: $type';
  }

  @override
  String itemDetailsSize(String size) {
    return 'Size: $size';
  }

  @override
  String itemDetailsModified(String date) {
    return 'Modified date: $date';
  }

  @override
  String get folder => 'Folder';

  @override
  String get file => 'File';

  @override
  String get selectCloudFirstLeft => 'Select a cloud in the left pane first.';

  @override
  String get selectCloudFirstRight => 'Select a cloud in the right pane first.';

  @override
  String get selectDestinationCloudLeft =>
      'Select a destination cloud in the left pane first.';

  @override
  String get selectDestinationCloudRight =>
      'Select a destination cloud in the right pane first.';

  @override
  String get noFilesToTransfer => 'No files present or selected to transfer.';

  @override
  String transferStarted(String action, int count, String src, String dst) {
    return '$action of $count items from [$src] to [$dst] started...';
  }

  @override
  String get swapPanesTooltip => 'Swap panes (<->)';

  @override
  String get refreshBothPanesTooltip => 'Refresh both panes';

  @override
  String get copyRight => 'Copy to right ->';

  @override
  String get moveRight => 'Move to right ->';

  @override
  String get copyLeft => '<- Copy to left';

  @override
  String get moveLeft => '<- Move to left';

  @override
  String copyRightWithCount(int count) {
    return 'Copy right ($count) ->';
  }

  @override
  String moveRightWithCount(int count) {
    return 'Move right ($count) ->';
  }

  @override
  String copyLeftWithCount(int count) {
    return '<- Copy left ($count)';
  }

  @override
  String moveLeftWithCount(int count) {
    return '<- Move left ($count)';
  }

  @override
  String get deleteRuleTitle => 'Delete Rule';

  @override
  String deleteRulePrompt(String name) {
    return 'Are you sure you want to delete sync rule \"$name\"? Files on your device and in the cloud will not be deleted.';
  }

  @override
  String get syncAll => 'Sync All';

  @override
  String get newRuleTooltip => 'New rule';

  @override
  String get backupBannerTitle => 'Continuous Backup & Cloud Sync';

  @override
  String get backupBannerSubtitle =>
      'Configure scheduled synchronizations between local folders and cloud remotes.';

  @override
  String get noActiveRules => 'No Active Rules';

  @override
  String get noActiveRulesSubtitle =>
      'Create your first rule to run automatic backups from your phone to Google Drive, Dropbox, SFTP or any other cloud.';

  @override
  String get createNewRule => 'Create New Rule';

  @override
  String get ruleOptionsTooltip => 'Rule options';

  @override
  String get syncNow => 'Sync now';

  @override
  String get statusWaiting => 'Pending';

  @override
  String get statusInProgress => 'In progress...';

  @override
  String get statusCompleted => 'Completed';

  @override
  String get statusFailed => 'Failed';

  @override
  String get editRuleTitle => 'Edit Backup Rule';

  @override
  String get newRuleTitle => 'New Synchronization Rule';

  @override
  String get ruleDialogSubtitle =>
      'Configure automatic backup between a local folder and the cloud.';

  @override
  String get ruleNameOptional => 'Rule Name (optional)';

  @override
  String get ruleNameHint => 'e.g. DCIM Photo Backup or Work Documents';

  @override
  String get sourceLocalFolder => 'Local Source Folder';

  @override
  String get sourceLocalFolderHint =>
      '/storage/emulated/0/DCIM or /home/user/Pictures';

  @override
  String get browseFolders => 'Browse folders';

  @override
  String get selectLocalFolderError => 'Please enter or select a local folder';

  @override
  String get noCloudsConfiguredSync =>
      'No cloud configured. Configure a cloud account from Home before continuing.';

  @override
  String get remoteDestinationPath => 'Remote Destination Path';

  @override
  String get syncMode => 'Sync Mode';

  @override
  String get syncModeCopy => 'Incremental Backup';

  @override
  String get syncModeCopyDesc =>
      'Uploads new and modified files, preserving existing cloud files.';

  @override
  String get syncModeSync => 'Mirror Synchronization';

  @override
  String get syncModeSyncDesc =>
      'Makes the remote destination identical to the local folder (deletions locally are deleted on cloud).';

  @override
  String get syncFrequency => 'Execution Frequency';

  @override
  String get freqManual => 'Manual (on demand only)';

  @override
  String get freq15Min => 'Every 15 minutes';

  @override
  String get freq30Min => 'Every 30 minutes';

  @override
  String get freqHourly => 'Every hour';

  @override
  String get freq6Hours => 'Every 6 hours';

  @override
  String get freq12Hours => 'Every 12 hours';

  @override
  String get freqDaily => 'Every day (24 hours)';

  @override
  String get activateRuleImmediately => 'Activate rule immediately';

  @override
  String get activateRuleImmediatelyDesc =>
      'Sync will run in background according to the specified interval';

  @override
  String get updateRule => 'Update';

  @override
  String get saveRule => 'Save Rule';

  @override
  String get selectCloudProvider => 'Select Cloud Provider:';

  @override
  String get cloudAccountName => 'Cloud Account Name';

  @override
  String get cloudAccountNameHint =>
      'e.g. GoogleDrive, WorkDropbox (no spaces)';

  @override
  String get enterNameError => 'Please enter a name';

  @override
  String get noSpacesOrColons => 'Spaces and \":\" are not allowed';

  @override
  String get oauthMode => 'Client ID Mode (OAuth2)';

  @override
  String get oauthOfficial => 'UnifyCloud (Official / Recommended)';

  @override
  String get oauthRclone => 'Rclone (Not recommended - Shared quota)';

  @override
  String get oauthCustom => 'Personal Client ID (Advanced)';

  @override
  String get officialOauthTitle => 'Official UnifyCloud Credentials';

  @override
  String get officialOauthDesc =>
      'Pre-configured credentials to connect immediately with dedicated quota and maximum speed.';

  @override
  String get rcloneOauthDesc =>
      'Shared open-source Rclone keys. May encounter rate-limits or temporary Google 403 errors.';

  @override
  String get customClientId => 'Client ID';

  @override
  String get customClientSecret => 'Client Secret';

  @override
  String get selectVaultDestination => 'Select destination cloud for Vault';

  @override
  String get vaultPasswordRequired => 'Vault encryption password is required';

  @override
  String get vaultPasswordsDoNotMatch => 'Passwords do not match';

  @override
  String errorAddingRemote(String error) {
    return 'Error adding remote: $error';
  }

  @override
  String get fileNameEncryption => 'File Name Encryption';

  @override
  String get encryptStandard =>
      'Standard (Fully encrypted file names - Recommended)';

  @override
  String get encryptObscure => 'Simple Obfuscation (Preserves extensions)';

  @override
  String get encryptOff => 'Disabled (Visible file names)';

  @override
  String get encryptFolderNames => 'Also encrypt folder names';

  @override
  String get encryptFolderNamesDesc =>
      'Completely conceals directory structure on the cloud';

  @override
  String get connectCloud => 'Connect Cloud';

  @override
  String get reopenAuth => 'Reopen';

  @override
  String get linkCopiedToClipboard => 'Link copied to clipboard!';

  @override
  String errorOpenBrowserGeneric(String error) {
    return 'Unable to open browser: $error';
  }

  @override
  String get shareableLinkTitle => 'Shareable Link';

  @override
  String shareLinkAccessDescription(String item) {
    return 'Anyone with this link will be able to access $item:';
  }

  @override
  String get open => 'Open';

  @override
  String activeTransfersCount(int count) {
    return '$count active transfers';
  }

  @override
  String transfersQueueCount(int count) {
    return 'Transfer Queue ($count)';
  }

  @override
  String get noTransfersInProgress => 'No transfers in progress';

  @override
  String get transfersEmptySubtitle =>
      'All downloaded or uploaded files will appear here';

  @override
  String get cancelled => 'Cancelled';

  @override
  String get appLockedTitle => 'Application Locked';

  @override
  String get unlockWithBiometrics => 'Unlock with Biometrics';

  @override
  String get pinMustBe6Digits => 'PIN must be exactly 6 digits';

  @override
  String get pinIncorrect => 'Incorrect PIN. Try again.';

  @override
  String get pinsDoNotMatch => 'PINs do not match. Try again.';

  @override
  String get pinStepOld => 'Enter your current PIN to continue.';

  @override
  String get pinStepNew => 'Enter your new 6-digit security PIN.';

  @override
  String get pinStepConfirm => 'Re-enter the new PIN to confirm.';

  @override
  String get pinStepVerify => 'Enter your PIN to confirm the operation.';

  @override
  String get pinTitleSetup => 'Setup Security PIN';

  @override
  String get pinTitleChange => 'Change Security PIN';

  @override
  String get pinTitleVerify => 'Security Verification';

  @override
  String get pinContinue => 'Continue';

  @override
  String get errorDetails => 'Error Details';

  @override
  String get errorDetailsCopied => 'Error details copied to clipboard';

  @override
  String get collapse => 'Collapse';

  @override
  String get expand => 'Expand';

  @override
  String get copyError => 'Copy error';

  @override
  String get errorNetwork =>
      'No connection or unstable network. Check your internet connection and try again.';

  @override
  String get errorDiskSpace =>
      'Insufficient storage space or disk full. Free up memory to continue.';

  @override
  String get errorAuthExpired =>
      'Session or token expired/revoked. Reconnect your account.';

  @override
  String get errorNotFound => 'Item or folder not found on cloud provider.';

  @override
  String get errorPermissionDenied =>
      'Permission denied for this operation on cloud.';

  @override
  String get errorGeneric => 'An error occurred during the operation.';
}
