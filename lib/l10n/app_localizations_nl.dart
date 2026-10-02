// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appTitle => 'UnifyCloud';

  @override
  String get home => 'Startpagina';

  @override
  String get explorer => 'Verkenner';

  @override
  String get sync => 'Synchronisatie';

  @override
  String get settings => 'Instellingen';

  @override
  String get cancel => 'Annuleren';

  @override
  String get confirm => 'Bevestigen';

  @override
  String get delete => 'Verwijderen';

  @override
  String get save => 'Opslaan';

  @override
  String get close => 'Sluiten';

  @override
  String get edit => 'Bewerken';

  @override
  String get create => 'Maken';

  @override
  String get retry => 'Opnieuw proberen';

  @override
  String get copy => 'Kopiëren';

  @override
  String get move => 'Verplaatsen';

  @override
  String get rename => 'Hernoemen';

  @override
  String get download => 'Downloaden';

  @override
  String get upload => 'Uploaden';

  @override
  String get share => 'Delen';

  @override
  String get details => 'Details';

  @override
  String get search => 'Zoeken';

  @override
  String get change => 'Wijzigen';

  @override
  String get reset => 'Herstellen';

  @override
  String get done => 'Gereed';

  @override
  String get loading => 'Laden...';

  @override
  String get success => 'Bewerking voltooid';

  @override
  String get error => 'Fout';

  @override
  String get settingsTitle => 'Instellingen';

  @override
  String get resetDefaultsTooltip => 'Standaardinstellingen herstellen';

  @override
  String get resetDialogTitle => 'Instellingen herstellen';

  @override
  String get resetDialogContent =>
      'Weet u zeker dat u alle instellingen wilt herstellen naar de standaardwaarden?';

  @override
  String get resetSuccessSnackbar =>
      'Instellingen hersteld naar standaardwaarden';

  @override
  String get appearanceAndTheme => 'Uiterlijk & Thema';

  @override
  String get chooseVisualThemeSubtitle => 'Kies het visuele thema van de app';

  @override
  String get themeSystem => 'Systeem';

  @override
  String get themeLight => 'Licht';

  @override
  String get themeDark => 'Donker';

  @override
  String get language => 'Taal';

  @override
  String get languageSubtitle => 'Kies de interfacetaal van de app';

  @override
  String get langEnglish => 'English';

  @override
  String get langItalian => 'Italiano';

  @override
  String get langSystem => 'Systeemstandaard';

  @override
  String get filesAndExploration => 'Bestanden & Verkenning';

  @override
  String get showHiddenFiles => 'Verborgen bestanden tonen';

  @override
  String get showHiddenFilesSubtitle =>
      'Toon bestanden en mappen die beginnen met een punt';

  @override
  String get confirmBeforeDelete => 'Bevestigen voor verwijderen';

  @override
  String get confirmBeforeDeleteSubtitle =>
      'Toon dialoogvenster voor het verwijderen van bestanden of mappen';

  @override
  String get defaultDownloadFolder => 'Standaard downloadmap';

  @override
  String get defaultDownloadFolderSystem => 'Systeemdownloads (standaard)';

  @override
  String get restoreDefaultPath => 'Standaardpad herstellen';

  @override
  String get customDownloadFolderDialogPrompt =>
      'Kies een map via de systeemkiezer of voer het pad handmatig in:';

  @override
  String get folderPath => 'Mappad';

  @override
  String get folderPathHint => 'bijv. /home/gebruiker/Downloads';

  @override
  String get browseWithSystemPicker => 'Bladeren met systeemkiezer';

  @override
  String errorOpenPicker(String error) {
    return 'Kan systeemkiezer niet openen: $error';
  }

  @override
  String get restoreDefault => 'Standaard herstellen';

  @override
  String get maxConcurrentTransfers => 'Max gelijktijdige overdrachten';

  @override
  String get maxConcurrentTransfersSubtitle =>
      'Aantal gelijktijdige downloads en uploads';

  @override
  String get dualPaneMode => 'Dubbel paneelmodus (Desktop/Tablet)';

  @override
  String get dualPaneModeSubtitle =>
      'Toon twee verkenners naast elkaar op grote schermen';

  @override
  String get communityAndSupport => 'Community & Ondersteuning';

  @override
  String get openSourceDescription =>
      'UnifyCloud is een gratis en open-source project onder GPL-3.0 licentie.';

  @override
  String get supportDeveloper => 'Ondersteun de ontwikkelaar';

  @override
  String get supportDeveloperSubtitle =>
      'Help de ontwikkeling actief te houden met een donatie';

  @override
  String get viewSourceOnGitLab => 'Broncode bekijken op GitLab';

  @override
  String get viewSourceOnGitLabSubtitle =>
      'Draag bij, meld problemen of bekijk de code';

  @override
  String errorOpenBrowser(String url) {
    return 'Kan browser niet openen. Repository: $url';
  }

  @override
  String get supportDialogTitle => 'Ondersteun UnifyCloud';

  @override
  String get supportDialogDescription1 =>
      'UnifyCloud is een open-source project dat met passie is ontwikkeld om controle te geven over uw cloudgegevens.';

  @override
  String get supportDialogDescription2 =>
      'U kunt een eenmalige donatie doen of de ontwikkeling steunen via:';

  @override
  String get supportKofiTitle => 'Ko-fi (Donatie)';

  @override
  String get supportLiberapayTitle => 'Liberapay (Periodiek)';

  @override
  String get supportPaypalTitle => 'PayPal (Direct)';

  @override
  String get securityAndEncryption => 'Beveiliging & Versleuteling';

  @override
  String get securityArchitectureDescription =>
      'UnifyCloud gebruikt lokale versleuteling. Uw inloggegevens worden veilig bewaard in de platform-sleutelhanger.';

  @override
  String get appLock => 'App-vergrendeling';

  @override
  String get appLockSubtitle => 'Bescherm de app met een pincode';

  @override
  String get appLockActiveSubtitle => 'PIN actief - Tik om te wijzigen';

  @override
  String get appLockEnabledSnackbar =>
      'App-vergrendeling succesvol ingeschakeld';

  @override
  String get appLockDisabledSnackbar => 'App-vergrendeling uitgeschakeld';

  @override
  String get changePin => 'PIN wijzigen';

  @override
  String get changePinSubtitle => 'Stel een nieuwe 4-6-cijferige pincode in';

  @override
  String get pinChangedSnackbar => 'PIN succesvol gewijzigd';

  @override
  String get biometricAuth => 'Biometrische ontgrendeling';

  @override
  String get biometricAuthSubtitle =>
      'Gebruik vingerafdruk of biometrische sensor indien beschikbaar';

  @override
  String get biometricNotAvailable =>
      'Niet beschikbaar of niet geconfigureerd op dit apparaat';

  @override
  String get autoLock => 'Automatische vergrendeling';

  @override
  String get autoLockSubtitle =>
      'Inactiviteitstijd op de achtergrond voor vergrendeling';

  @override
  String get lockImmediately => 'Onmiddellijk';

  @override
  String get lockAfter1Minute => 'Na 1 minuut';

  @override
  String get lockAfter5Minutes => 'Na 5 minuten';

  @override
  String get lockAfter15Minutes => 'Na 15 minuten';

  @override
  String get lockAfter30Minutes => 'Na 30 minuten';

  @override
  String get syncCloudAccounts => 'Cloud-accounts synchroniseren';

  @override
  String get syncCloudAccountsSubtitle =>
      'Herlaad configuraties uit de beveiligde opslag';

  @override
  String get syncCloudAccountsSuccess =>
      'Cloud-accounts succesvol gesynchroniseerd';

  @override
  String get clearAllCredentials => 'Alle inloggegevens wissen';

  @override
  String get clearAllCredentialsSubtitle =>
      'Verwijdert de versleutelde configuratie en koppelt alle clouds los';

  @override
  String get clearCredentialsDialogTitle =>
      'Waarschuwing: Inloggegevens wissen';

  @override
  String get clearCredentialsDialogContent =>
      'Weet u zeker dat u alle opgeslagen accounts wilt verwijderen? U moet opnieuw inloggen.';

  @override
  String get clearCredentialsSuccess => 'Inloggegevens succesvol gewist';

  @override
  String get aboutUnifyCloud => 'Over UnifyCloud';

  @override
  String get appVersion => 'App-versie: 1.0.0';

  @override
  String get developerInfo => 'Ontwikkelaar: LeoRise (@leorise25)';

  @override
  String get engineInfo => 'Engine: Rclone Core CGO (Go v1.22+ / C FFI)';

  @override
  String get frameworkInfo => 'Framework: Flutter (Material 3 Responsive)';

  @override
  String get licenseInfo =>
      'Licentie: GNU General Public License v3.0 (GPL-3.0)';

  @override
  String get copyrightInfo => 'Copyright: © 2026 Leonardo Bani';

  @override
  String get storageOverview => 'Opslagoverzicht';

  @override
  String get connectedClouds => 'Verbonden clouds';

  @override
  String get noCloudsConfigured => 'Geen clouds geconfigureerd';

  @override
  String get noCloudsDescription =>
      'Verbind uw eerste cloud-account om bestanden te beheren en te synchroniseren.';

  @override
  String get addCloud => 'Cloud toevoegen';

  @override
  String get used => 'gebruikt';

  @override
  String get free => 'vrij';

  @override
  String get total => 'totaal';

  @override
  String get manageAccounts => 'Accounts beheren';

  @override
  String get viewFiles => 'Bestanden weergeven';

  @override
  String get createVaultHere => 'Versleutelde kluis hier maken...';

  @override
  String get disconnectAccount => 'Account loskoppelen';

  @override
  String get disconnectConfirmTitle => 'Account loskoppelen?';

  @override
  String get disconnectConfirmContent =>
      'Weet u zeker dat u dit account wilt loskoppelen? Bestanden in de cloud blijven onaangeroerd.';

  @override
  String get allFiles => 'Alle bestanden';

  @override
  String get emptyFolder => 'Lege map';

  @override
  String get emptyFolderSubtitle =>
      'Upload bestanden of maak een map om te beginnen';

  @override
  String get uploadFile => 'Bestand uploaden';

  @override
  String get uploadFolder => 'Map uploaden';

  @override
  String get newFolder => 'Nieuwe map';

  @override
  String get newFolderPrompt => 'Voer de naam in voor de nieuwe map:';

  @override
  String get folderNameHint => 'Mapnaam';

  @override
  String get selectAll => 'Alles selecteren';

  @override
  String get clearSelection => 'Selectie wissen';

  @override
  String get deleteSelected => 'Geselecteerde verwijderen';

  @override
  String get deleteSelectedPrompt =>
      'Weet u zeker dat u de geselecteerde items wilt verwijderen?';

  @override
  String get deleteItemPrompt =>
      'Weet u zeker dat u dit item wilt verwijderen?';

  @override
  String get shareLink => 'Deellink';

  @override
  String get createShareLink => 'Deellink maken';

  @override
  String get copyShareLink => 'Link kopiëren';

  @override
  String get copiedToClipboard => 'Gekopieerd naar het klembord';

  @override
  String get transfers => 'Overdrachten';

  @override
  String get activeTransfers => 'Actieve overdrachten';

  @override
  String get completed => 'Voltooid';

  @override
  String get failed => 'Mislukt';

  @override
  String get queued => 'In de wachtrij';

  @override
  String get cancelTransfer => 'Overdracht annuleren';

  @override
  String get clearCompleted => 'Voltooide wissen';

  @override
  String get syncRulesTitle => 'Synchronisatieregels';

  @override
  String get newRule => 'Nieuwe regel';

  @override
  String get noSyncRules => 'Geen synchronisatieregels geconfigureerd';

  @override
  String get noSyncRulesSubtitle =>
      'Geen regels geconfigureerd. Maak een regel om back-ups te automatiseren.';

  @override
  String get ruleName => 'Regelnaam';

  @override
  String get sourcePath => 'Bronmap';

  @override
  String get destinationCloud => 'Bestemmingscloud';

  @override
  String get destinationPath => 'Bestemmingspad';

  @override
  String get direction => 'Richting';

  @override
  String get frequency => 'Frequentie';

  @override
  String get runNow => 'Nu uitvoeren';

  @override
  String get syncInProgress => 'Synchronisatie bezig...';

  @override
  String get syncSuccess => 'Synchronisatie voltooid';

  @override
  String get syncFailed => 'Synchronisatie mislukt';

  @override
  String get addCloudDialogTitle => 'Nieuwe cloud verbinden';

  @override
  String get selectProvider => 'Kies provider';

  @override
  String get accountNameLabel => 'Accountnaam';

  @override
  String get connectButton => 'Verbinden';

  @override
  String get vaultTitle => 'Versleutelde kluis';

  @override
  String get vaultPassword => 'Kluiswachtwoord';

  @override
  String get vaultConfirmPassword => 'Wachtwoord bevestigen';

  @override
  String get vaultSalt => 'Beveiligingszout (Optioneel)';

  @override
  String get encryptFileNames => 'Bestandsnamen versleutelen';

  @override
  String get encryptDirNames => 'Mapnamen versleutelen';

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
  String get selectLanguage => 'Selecteer taal';

  @override
  String get searchLanguageHint => 'Zoek taal of land...';

  @override
  String get currentLanguage => 'Huidige taal';

  @override
  String systemDefaultWithLocale(String locale) {
    return 'Systeemstandaard ($locale)';
  }

  @override
  String get refreshCloudsTooltip => 'Geconfigureerde clouds vernieuwen';

  @override
  String get storageOverviewAggregated => 'Geaggregeerd opslagoverzicht';

  @override
  String get ramEncryptionActive => 'RAM-versleuteling actief';

  @override
  String connectedAccountsCount(int count) {
    return 'Verbonden cloud-accounts: $count';
  }

  @override
  String get noCloudsConfiguredHint =>
      'Geen cloud-accounts geconfigureerd. Tik hieronder op \"+ Nieuwe cloud verbinden\".';

  @override
  String percentUsed(String percent) {
    return '$percent% gebruikt';
  }

  @override
  String availableSpace(String space) {
    return '$space beschikbaar';
  }

  @override
  String get calculatingQuota => 'Opslagquota berekenen...';

  @override
  String get syncAndBackup => 'Synchronisatie & Back-up';

  @override
  String get noRulesConfigured => 'Geen regels geconfigureerd';

  @override
  String activeRulesCount(int active, int total) {
    return '$active/$total actieve regels';
  }

  @override
  String get manage => 'Beheren';

  @override
  String connectedCloudsCount(int count) {
    return 'Verbonden clouds ($count)';
  }

  @override
  String get connectNewCloud => 'Nieuwe cloud verbinden';

  @override
  String get noCloudProvidersConnected => 'Geen cloudproviders verbonden';

  @override
  String get connectCloudDescription =>
      'Verbind Google Drive, Dropbox, OneDrive, SFTP of WebDAV om bestanden te synchroniseren.';

  @override
  String get addFirstCloud => 'Eerste cloud toevoegen';

  @override
  String vaultOnRemote(String remote) {
    return 'KLUIS OP $remote';
  }

  @override
  String get disconnectCloudTitle => 'Cloud loskoppelen';

  @override
  String disconnectCloudPrompt(String name) {
    return 'Weet u zeker dat u \"$name\" wilt loskoppelen? De inloggegevens worden verwijderd.';
  }

  @override
  String get disconnect => 'Verbinding verbreken';

  @override
  String freeSpace(String space) {
    return '$space vrij';
  }

  @override
  String get storage => 'Opslag';

  @override
  String get available => 'Beschikbaar';

  @override
  String get exploreFiles => 'Bestanden verkennen';

  @override
  String get paneLeft => 'Links';

  @override
  String get paneRight => 'Rechts';

  @override
  String get folderName => 'Mapnaam';

  @override
  String errorCreatingFolder(String error) {
    return 'Fout bij maken van map: $error';
  }

  @override
  String get moveAction => 'Verplaatsen';

  @override
  String get copyAction => 'Kopiëren';

  @override
  String transferBatchStarted(String action, int count, String remote) {
    return '$action van $count items naar [$remote] gestart...';
  }

  @override
  String errorTransferring(String error) {
    return 'Fout tijdens overdracht: $error';
  }

  @override
  String itemCopiedToClipboard(String name) {
    return '\"$name\" gekopieerd naar klembord';
  }

  @override
  String itemsCopiedToClipboard(int count) {
    return '$count items gekopieerd naar klembord';
  }

  @override
  String itemCutToClipboard(String name) {
    return '\"$name\" geknipt (klaar om te verplaatsen)';
  }

  @override
  String itemsCutToClipboard(int count) {
    return '$count items geknipt (klaar om te verplaatsen)';
  }

  @override
  String get noFilesSelectedForDownload =>
      'Geen bestanden geselecteerd voor download';

  @override
  String downloadingItems(int count) {
    return '$count items downloaden...';
  }

  @override
  String itemsDownloadedSuccess(int count, String path) {
    return '$count items gedownload naar \"$path\"';
  }

  @override
  String errorStartingDownload(String error) {
    return 'Fout bij starten van download: $error';
  }

  @override
  String deleteItemsConfirmTitle(int count) {
    return '$count geselecteerde items verwijderen?';
  }

  @override
  String deleteItemsConfirmPrompt(int count) {
    return 'Weet u zeker dat u $count geselecteerde items definitief uit de cloud wilt verwijderen?';
  }

  @override
  String itemsDeletedSuccess(int count) {
    return '$count items verwijderd';
  }

  @override
  String errorDeleting(String error) {
    return 'Fout tijdens verwijderen: $error';
  }

  @override
  String get uploadCompletedSuccess => 'Upload succesvol voltooid';

  @override
  String errorUploading(String error) {
    return 'Fout tijdens uploaden: $error';
  }

  @override
  String get folderUploadCompletedSuccess => 'Map-upload succesvol voltooid';

  @override
  String errorFolderUploading(String error) {
    return 'Fout bij uploaden van map: $error';
  }

  @override
  String get filesAlreadyInDirectory =>
      'Bestanden bevinden zich al in deze map';

  @override
  String dragDropTransferStarted(String action, int count, String remote) {
    return '$action van $count items naar [$remote] gestart...';
  }

  @override
  String errorDragDrop(String error) {
    return 'Fout tijdens slepen en neerzetten: $error';
  }

  @override
  String get closeSelection => 'Selectie sluiten';

  @override
  String itemsSelectedCount(int count) {
    return '$count geselecteerd';
  }

  @override
  String get deselectAll => 'Alles deselecteren';

  @override
  String copyToRemote(String remote) {
    return 'Kopiëren naar $remote';
  }

  @override
  String moveToRemote(String remote) {
    return 'Verplaatsen naar $remote';
  }

  @override
  String get moreActions => 'Meer acties';

  @override
  String get downloadSelected => 'Geselecteerde downloaden';

  @override
  String get copyToClipboard => 'Kopiëren naar klembord';

  @override
  String get cutToClipboard => 'Knippen naar klembord';

  @override
  String get selectCloud => 'Selecteer cloud';

  @override
  String get closeSearch => 'Zoeken sluiten';

  @override
  String get uploadFromDevice => 'Uploaden vanaf apparaat';

  @override
  String get moreOptions => 'Meer opties';

  @override
  String get viewGrid => 'Rasterweergave';

  @override
  String get viewList => 'Lijstweergave';

  @override
  String get multiSelection => 'Meervoudige selectie';

  @override
  String get sortNameAsc => 'Naam (A-Z)';

  @override
  String get sortNameDesc => 'Naam (Z-A)';

  @override
  String get sortSizeDesc => 'Grootte (Groot-Klein)';

  @override
  String get sortSizeAsc => 'Grootte (Klein-Groot)';

  @override
  String get sortDateDesc => 'Recent gewijzigd';

  @override
  String get disableDualPane => 'Dubbel paneel uitschakelen';

  @override
  String get enableDualPane => 'Dubbel paneel inschakelen';

  @override
  String itemsInClipboard(int count) {
    return '$count items op het klembord';
  }

  @override
  String get pasteHere => 'Hier plakken';

  @override
  String get noResults => 'Geen resultaten gevonden';

  @override
  String noMatchingResults(String query) {
    return 'Geen bestanden of mappen gevonden voor \"$query\"';
  }

  @override
  String get selectACloud => 'Selecteer een cloud';

  @override
  String get selectCloudDescription =>
      'Kies een cloud-account uit het menu hierboven om te bladeren.';

  @override
  String optionsForItem(String name) {
    return 'Opties voor $name';
  }

  @override
  String get select => 'Selecteren';

  @override
  String get openWithSystemApp => 'Openen met systeem-app';

  @override
  String get downloadToLocal => 'Downloaden naar lokaal';

  @override
  String get cut => 'Knippen';

  @override
  String get copyPath => 'Pad kopiëren';

  @override
  String get info => 'Informatie';

  @override
  String generatingShareLink(String name) {
    return 'Deellink genereren voor \"$name\"...';
  }

  @override
  String errorPublicLink(String error) {
    return 'Fout bij openbare link: $error';
  }

  @override
  String get noLinkGenerated => 'Geen link gegenereerd door de server';

  @override
  String errorDownloading(String error) {
    return 'Fout bij downloaden: $error';
  }

  @override
  String get renameFolderTitle => 'Map hernoemen';

  @override
  String get renameFileTitle => 'Bestand hernoemen';

  @override
  String errorRenaming(String error) {
    return 'Fout bij hernoemen: $error';
  }

  @override
  String get pathCopiedToClipboard => 'Pad gekopieerd naar klembord';

  @override
  String itemDetailsPath(String path) {
    return 'Pad: $path';
  }

  @override
  String itemDetailsType(String type) {
    return 'Type: $type';
  }

  @override
  String itemDetailsSize(String size) {
    return 'Grootte: $size';
  }

  @override
  String itemDetailsModified(String date) {
    return 'Gewijzigd op: $date';
  }

  @override
  String get folder => 'Map';

  @override
  String get file => 'Bestand';

  @override
  String get selectCloudFirstLeft =>
      'Selecteer eerst een cloud voor het linkerpaneel';

  @override
  String get selectCloudFirstRight =>
      'Selecteer eerst een cloud voor het rechterpaneel';

  @override
  String get selectDestinationCloudLeft =>
      'Selecteer een cloud voor het linkerpaneel als bestemming';

  @override
  String get selectDestinationCloudRight =>
      'Selecteer een cloud voor het rechterpaneel als bestemming';

  @override
  String get noFilesToTransfer =>
      'Geen bestanden geselecteerd om over te dragen';

  @override
  String transferStarted(String action, int count, String src, String dst) {
    return '$action van $count items van [$src] naar [$dst] gestart...';
  }

  @override
  String get swapPanesTooltip => 'Panelen omwisselen';

  @override
  String get refreshBothPanesTooltip => 'Beide panelen vernieuwen';

  @override
  String get copyRight => 'Kopieer rechts ->';

  @override
  String get moveRight => 'Verplaats rechts ->';

  @override
  String get copyLeft => '<- Kopieer links';

  @override
  String get moveLeft => '<- Verplaats links';

  @override
  String copyRightWithCount(int count) {
    return 'Kopieer naar rechts ($count) ->';
  }

  @override
  String moveRightWithCount(int count) {
    return 'Verplaats naar rechts ($count) ->';
  }

  @override
  String copyLeftWithCount(int count) {
    return '<- Kopieer naar links ($count)';
  }

  @override
  String moveLeftWithCount(int count) {
    return '<- Verplaats naar links ($count)';
  }

  @override
  String get deleteRuleTitle => 'Regel verwijderen';

  @override
  String deleteRulePrompt(String name) {
    return 'Weet u zeker dat u de regel \"$name\" wilt verwijderen? Bestanden worden niet verwijderd.';
  }

  @override
  String get syncAll => 'Alles synchroniseren';

  @override
  String get newRuleTooltip => 'Nieuwe regel toevoegen';

  @override
  String get backupBannerTitle => 'Back-up & Synchronisatie';

  @override
  String get backupBannerSubtitle =>
      'Houd uw bestanden automatisch gespiegeld tussen opslaglocaties';

  @override
  String get noActiveRules => 'Geen actieve synchronisatieregels';

  @override
  String get noActiveRulesSubtitle =>
      'Maak een regel aan om automatisch mappen te synchroniseren op schema.';

  @override
  String get createNewRule => 'Nieuwe regel maken';

  @override
  String get ruleOptionsTooltip => 'Regelopties';

  @override
  String get syncNow => 'Nu synchroniseren';

  @override
  String get statusWaiting => 'Wachten';

  @override
  String get statusInProgress => 'Bezig...';

  @override
  String get statusCompleted => 'Voltooid';

  @override
  String get statusFailed => 'Mislukt';

  @override
  String get editRuleTitle => 'Synchronisatieregel bewerken';

  @override
  String get newRuleTitle => 'Nieuwe synchronisatieregel';

  @override
  String get ruleDialogSubtitle =>
      'Definieer bron, bestemming en frequentie van synchronisatie';

  @override
  String get ruleNameOptional => 'Regelnaam (optioneel)';

  @override
  String get ruleNameHint => 'bijv. Automatische documentenback-up';

  @override
  String get sourceLocalFolder => 'Lokale bronmap';

  @override
  String get sourceLocalFolderHint => 'Selecteer een lokale map...';

  @override
  String get browseFolders => 'Bladeren';

  @override
  String get selectLocalFolderError => 'Selecteer een lokale bronmap';

  @override
  String get noCloudsConfiguredSync =>
      'Geen clouds geconfigureerd. Voeg er eerst een toe in Instellingen.';

  @override
  String get remoteDestinationPath => 'Pad op bestemming';

  @override
  String get syncMode => 'Modus';

  @override
  String get syncModeCopy => 'Kopiëren (alleen nieuwe/bijgewerkte toevoegen)';

  @override
  String get syncModeCopyDesc =>
      'Kopieert nieuwe en gewijzigde bestanden naar de bestemming zonder bestanden te verwijderen.';

  @override
  String get syncModeSync => 'Synchronisatie (spiegelen)';

  @override
  String get syncModeSyncDesc =>
      'Maakt bestemming identiek aan bron. Verwijdert bestanden op de bestemming als ze bij de bron zijn verwijderd.';

  @override
  String get syncFrequency => 'Synchronisatiefrequentie';

  @override
  String get freqManual => 'Alleen handmatig';

  @override
  String get freq15Min => 'Elke 15 minuten';

  @override
  String get freq30Min => 'Elke 30 minuten';

  @override
  String get freqHourly => 'Elk uur';

  @override
  String get freq6Hours => 'Elke 6 uur';

  @override
  String get freq12Hours => 'Elke 12 uur';

  @override
  String get freqDaily => 'Dagelijks';

  @override
  String get activateRuleImmediately => 'Regel onmiddellijk activeren';

  @override
  String get activateRuleImmediatelyDesc =>
      'Indien uitgeschakeld wordt de regel niet automatisch uitgevoerd';

  @override
  String get updateRule => 'Regel bijwerken';

  @override
  String get saveRule => 'Regel opslaan';

  @override
  String get selectCloudProvider => 'Selecteer een provider';

  @override
  String get cloudAccountName => 'Accountnaam';

  @override
  String get cloudAccountNameHint => 'bijv. Mijn persoonlijke opslag';

  @override
  String get enterNameError => 'Voer een accountnaam in';

  @override
  String get noSpacesOrColons =>
      'De naam mag geen spaties of dubbele punten bevatten';

  @override
  String get oauthMode => 'OAuth-authenticatiemodus';

  @override
  String get oauthOfficial => 'Officiële app (Aanbevolen)';

  @override
  String get oauthRclone => 'Standaard Rclone';

  @override
  String get oauthCustom => 'Aangepaste Client-ID & Secret';

  @override
  String get officialOauthTitle => 'Officiële UnifyCloud OAuth';

  @override
  String get officialOauthDesc =>
      'Gebruikt officiële API-inloggegevens voor een snelle en veilige configuratie via de browser.';

  @override
  String get rcloneOauthDesc =>
      'Gebruikt standaard openbare Rclone-inloggegevens. Kan onderhevig zijn aan API-snelheidslimieten.';

  @override
  String get customClientId => 'Aangepaste Client-ID';

  @override
  String get customClientSecret => 'Aangepaste Client-Secret';

  @override
  String get selectVaultDestination => 'Kies bestemmingscloud voor kluis';

  @override
  String get vaultPasswordRequired => 'Voer een wachtwoord in voor de kluis';

  @override
  String get vaultPasswordsDoNotMatch => 'Wachtwoorden komen niet overeen';

  @override
  String errorAddingRemote(String error) {
    return 'Fout bij toevoegen van account: $error';
  }

  @override
  String get fileNameEncryption => 'Bestandsnaamversleuteling';

  @override
  String get encryptStandard =>
      'Standaard (Aanbevolen - volledige versleuteling)';

  @override
  String get encryptObscure => 'Obfuscate (Moeilijk leesbaar)';

  @override
  String get encryptOff => 'Uitgeschakeld (Bestandsnamen zichtbaar laten)';

  @override
  String get encryptFolderNames => 'Mapnamen versleutelen';

  @override
  String get encryptFolderNamesDesc =>
      'Verbergt ook de namen van mappen in de kluis';

  @override
  String get connectCloud => 'Cloud verbinden';

  @override
  String get reopenAuth => 'Heropen browserautorisatie';

  @override
  String get linkCopiedToClipboard => 'Link gekopieerd naar klembord';

  @override
  String errorOpenBrowserGeneric(String error) {
    return 'Kan browser niet openen: $error';
  }

  @override
  String get shareableLinkTitle => 'Deelbare link:';

  @override
  String shareLinkAccessDescription(String item) {
    return 'Iedereen met deze link heeft toegang tot $item:';
  }

  @override
  String get open => 'Openen';

  @override
  String activeTransfersCount(int count) {
    return '$count actieve overdrachten';
  }

  @override
  String transfersQueueCount(int count) {
    return 'Overdrachtswachtrij ($count)';
  }

  @override
  String get noTransfersInProgress => 'Geen actieve overdrachten';

  @override
  String get transfersEmptySubtitle =>
      'Bestandsoverdrachten verschijnen hier in realtime.';

  @override
  String get cancelled => 'Geannuleerd';

  @override
  String get appLockedTitle => 'Applicatie vergrendeld';

  @override
  String get unlockWithBiometrics => 'Ontgrendelen met biometrie';

  @override
  String get pinMustBe6Digits => 'De pincode moet minstens 4 cijfers lang zijn';

  @override
  String get pinIncorrect => 'Onjuiste PIN';

  @override
  String get pinsDoNotMatch =>
      'Pincodes komen niet overeen. Probeer het opnieuw.';

  @override
  String get pinStepOld => 'Voer huidige PIN in';

  @override
  String get pinStepNew => 'Voer nieuwe PIN in';

  @override
  String get pinStepConfirm => 'Bevestig nieuwe PIN';

  @override
  String get pinStepVerify => 'Voer uw PIN in';

  @override
  String get pinTitleSetup => 'Stel App-vergrendeling PIN in';

  @override
  String get pinTitleChange => 'PIN wijzigen';

  @override
  String get pinTitleVerify => 'PIN vereist';

  @override
  String get pinContinue => 'Doorgaan';

  @override
  String get errorDetails => 'Foutdetails';

  @override
  String get errorDetailsCopied => 'Foutdetails gekopieerd naar klembord';

  @override
  String get collapse => 'Inklappen';

  @override
  String get expand => 'Details uitvouwen';

  @override
  String get copyError => 'Fout kopiëren';

  @override
  String get errorNetwork => 'Netwerkfout. Controleer uw internetverbinding.';

  @override
  String get errorDiskSpace => 'Onvoldoende schijfruimte op het doelapparaat.';

  @override
  String get errorAuthExpired =>
      'Sessie verlopen of inloggegevens ingetrokken. Meld u opnieuw aan.';

  @override
  String get errorNotFound =>
      'Het aangevraagde bestand of de map is niet gevonden.';

  @override
  String get errorPermissionDenied =>
      'Toegang geweigerd. U heeft niet de nodige rechten.';

  @override
  String get errorGeneric => 'Er is een onverwachte cloudfout opgetreden.';
}
