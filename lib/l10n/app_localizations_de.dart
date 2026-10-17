// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'UnifyCloud';

  @override
  String get home => 'Startseite';

  @override
  String get explorer => 'Explorer';

  @override
  String get sync => 'Synchronisation';

  @override
  String get settings => 'Einstellungen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get confirm => 'Bestätigen';

  @override
  String get delete => 'Löschen';

  @override
  String get save => 'Speichern';

  @override
  String get close => 'Schließen';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get create => 'Erstellen';

  @override
  String get retry => 'Wiederholen';

  @override
  String get copy => 'Kopieren';

  @override
  String get move => 'Verschieben';

  @override
  String get rename => 'Umbenennen';

  @override
  String get download => 'Herunterladen';

  @override
  String get upload => 'Hochladen';

  @override
  String get share => 'Teilen';

  @override
  String get details => 'Details';

  @override
  String get search => 'Suchen';

  @override
  String get change => 'Ändern';

  @override
  String get reset => 'Zurücksetzen';

  @override
  String get done => 'Fertig';

  @override
  String get loading => 'Wird geladen...';

  @override
  String get success => 'Vorgang abgeschlossen';

  @override
  String get error => 'Fehler';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get resetDefaultsTooltip => 'Standardeinstellungen wiederherstellen';

  @override
  String get resetDialogTitle => 'Einstellungen zurücksetzen';

  @override
  String get resetDialogContent =>
      'Möchten Sie alle Einstellungen (Design, Sprache, Ordner, Ansicht) auf die Werkseinstellungen zurücksetzen?';

  @override
  String get resetSuccessSnackbar =>
      'Einstellungen auf Standardwerte zurückgesetzt';

  @override
  String get appearanceAndTheme => 'Erscheinungsbild & Design';

  @override
  String get chooseVisualThemeSubtitle =>
      'Wählen Sie das visuelle Thema für UnifyCloud:';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get themeStyle => 'Interface Style';

  @override
  String get themeStyleSubtitle =>
      'Select desktop design style or automatic environment detection:';

  @override
  String get themeStyleAuto => 'Auto (Detect)';

  @override
  String get themeStyleStandard => 'Standard';

  @override
  String get themeStyleCosmic => 'COSMIC (Default)';

  @override
  String get themeStyleCosmicActive =>
      'COSMIC style is active across all devices (Teal in light mode, Pop Orange in dark mode)';

  @override
  String get themeStyleCosmicDetected =>
      'COSMIC desktop environment detected: COSMIC style is active (Teal in light mode, Pop Orange in dark mode)';

  @override
  String get language => 'Sprache';

  @override
  String get languageSubtitle => 'Sprache der Benutzeroberfläche wählen';

  @override
  String get langEnglish => 'English';

  @override
  String get langItalian => 'Italiano';

  @override
  String get langSystem => 'Systemstandard';

  @override
  String get filesAndExploration => 'Dateien & Erkundung';

  @override
  String get showHiddenFiles => 'Versteckte Dateien anzeigen';

  @override
  String get showHiddenFilesSubtitle =>
      'Dateien und Ordner anzeigen, die mit einem Punkt beginnen';

  @override
  String get confirmBeforeDelete => 'Vor dem Löschen bestätigen';

  @override
  String get confirmBeforeDeleteSubtitle =>
      'Vor dem endgültigen Löschen von Dateien nachfragen';

  @override
  String get defaultDownloadFolder => 'Standard-Downloadordner';

  @override
  String get defaultDownloadFolderSystem =>
      'Standardmäßiges Download-Verzeichnis des Systems';

  @override
  String get restoreDefaultPath => 'Standardpfad wiederherstellen';

  @override
  String get customDownloadFolderDialogPrompt =>
      'Wählen Sie einen Ordner über das Systemmenü oder geben Sie den Pfad manuell ein:';

  @override
  String get folderPath => 'Ordnerpfad';

  @override
  String get folderPathHint => 'z.B. /home/benutzer/Downloads';

  @override
  String get browseWithSystemPicker => 'Mit Systemauswahl durchsuchen';

  @override
  String errorOpenPicker(String error) {
    return 'Systemauswahl konnte nicht geöffnet werden: $error';
  }

  @override
  String get restoreDefault => 'Standard wiederherstellen';

  @override
  String get maxConcurrentTransfers => 'Gleichzeitige Übertragungen';

  @override
  String get maxConcurrentTransfersSubtitle =>
      'Maximale Anzahl gleichzeitiger Dateiübertragungen';

  @override
  String get dualPaneMode => 'Commander-Modus (Zwei Spalten)';

  @override
  String get dualPaneModeSubtitle =>
      'Zwei Spalten nebeneinander auf breiten Bildschirmen und Tablets anzeigen';

  @override
  String get communityAndSupport => 'Community & Support';

  @override
  String get openSourceDescription =>
      'UnifyCloud ist kostenlose Open-Source-Software, die Ihre Cloud-Daten ohne Tracker oder proprietäre Mittelsmänner vereinheitlicht.';

  @override
  String get supportDeveloper => 'Entwickler unterstützen';

  @override
  String get supportDeveloperSubtitle =>
      'Kaufen Sie einen Kaffee, um die unabhängige Entwicklung zu unterstützen';

  @override
  String get viewSourceOnGitLab => 'Code auf GitLab ansehen';

  @override
  String get viewSourceOnGitLabSubtitle =>
      'Offizielles Repository, Fehlerberichte und Beiträge';

  @override
  String errorOpenBrowser(String url) {
    return 'Browser konnte nicht geöffnet werden. Repository: $url';
  }

  @override
  String get supportDialogTitle => 'UnifyCloud unterstützen';

  @override
  String get supportDialogDescription1 =>
      'UnifyCloud ist ein kostenloses Open-Source-Projekt, das Ihnen die volle Kontrolle über Ihre Cloud-Dateien gibt.';

  @override
  String get supportDialogDescription2 =>
      'Wenn Ihnen diese App gefällt, laden Sie uns auf einen Kaffee ein oder spenden Sie, um die kontinuierliche Entwicklung zu unterstützen!';

  @override
  String get supportKofiTitle => 'Einen Kaffee auf Ko-fi spendieren';

  @override
  String get supportLiberapayTitle => 'Auf Liberapay spenden';

  @override
  String get supportPaypalTitle => 'Über PayPal spenden';

  @override
  String get securityAndEncryption => 'Sicherheit & Verschlüsselung';

  @override
  String get securityArchitectureDescription =>
      'UnifyCloud setzt auf eine Zero-Plaintext-Architektur. Alle OAuth-Token und Anmeldedaten werden sicher im System-Schlüsselbund gespeichert und ausschließlich in den Arbeitsspeicher der Go-Engine geladen.';

  @override
  String get appLock => 'App-Sperre (PIN / Biometrie)';

  @override
  String get appLockSubtitle =>
      'PIN oder Fingerabdruck für den Zugriff anfordern';

  @override
  String get appLockActiveSubtitle => 'Aktiv beim Start und nach Inaktivität';

  @override
  String get appLockEnabledSnackbar => 'App-Sperre erfolgreich aktiviert';

  @override
  String get appLockDisabledSnackbar => 'App-Sperre deaktiviert';

  @override
  String get changePin => 'PIN ändern';

  @override
  String get changePinSubtitle => 'Neuen 6-stelligen Sicherheits-PIN festlegen';

  @override
  String get pinChangedSnackbar => 'Sicherheits-PIN erfolgreich aktualisiert';

  @override
  String get biometricAuth => 'Biometrische Authentifizierung';

  @override
  String get biometricAuthSubtitle =>
      'Fingerabdruck oder biometrischen Sensor verwenden, falls verfügbar';

  @override
  String get biometricNotAvailable =>
      'Auf diesem Gerät nicht verfügbar oder nicht eingerichtet';

  @override
  String get autoLock => 'Automatische Sperre';

  @override
  String get autoLockSubtitle => 'Hintergrund-Inaktivitätszeit vor dem Sperren';

  @override
  String get lockImmediately => 'Sofort';

  @override
  String get lockAfter1Minute => 'Nach 1 Minute';

  @override
  String get lockAfter5Minutes => 'Nach 5 Minuten';

  @override
  String get lockAfter15Minutes => 'Nach 15 Minuten';

  @override
  String get lockAfter30Minutes => 'Nach 30 Minuten';

  @override
  String get syncCloudAccounts => 'Cloud-Konten synchronisieren';

  @override
  String get syncCloudAccountsSubtitle =>
      'Konfigurationen aus dem sicheren Speicher neu laden';

  @override
  String get syncCloudAccountsSuccess => 'Cloud-Konten erfolgreich neu geladen';

  @override
  String get clearAllCredentials => 'Alle Zugangsdaten löschen';

  @override
  String get clearAllCredentialsSubtitle =>
      'Entfernt die verschlüsselte Konfiguration und trennt alle Cloud-Verbindungen';

  @override
  String get clearCredentialsDialogTitle =>
      'Warnung: Zugangsdaten zurücksetzen';

  @override
  String get clearCredentialsDialogContent =>
      'Sind Sie sicher, dass Sie alle gespeicherten Zugangsdaten löschen möchten? Sie müssen Ihre Konten erneut verbinden.';

  @override
  String get clearCredentialsSuccess => 'Zugangsdaten erfolgreich gelöscht';

  @override
  String get aboutUnifyCloud => 'Über UnifyCloud';

  @override
  String get appVersion => 'App-Version: 1.0.0';

  @override
  String get developerInfo => 'Entwickler: LeoRise (@leorise25)';

  @override
  String get engineInfo => 'Engine: Rclone Core CGO (Go v1.22+ / C FFI)';

  @override
  String get frameworkInfo => 'Framework: Flutter (Material 3 Responsive)';

  @override
  String get licenseInfo => 'Lizenz: GNU General Public License v3.0 (GPL-3.0)';

  @override
  String get copyrightInfo => 'Copyright: © 2026 Leonardo Bani';

  @override
  String get storageOverview => 'Speicherübersicht';

  @override
  String get connectedClouds => 'Verbundene Clouds';

  @override
  String get noCloudsConfigured => 'Keine Cloud-Konten konfiguriert';

  @override
  String get noCloudsDescription =>
      'Verbinden Sie Ihr erstes Cloud-Konto, um Dateien zu verwalten und zu synchronisieren.';

  @override
  String get addCloud => 'Cloud hinzufügen';

  @override
  String get used => 'belegt';

  @override
  String get free => 'frei';

  @override
  String get total => 'gesamt';

  @override
  String get manageAccounts => 'Konten verwalten';

  @override
  String get viewFiles => 'Dateien anzeigen';

  @override
  String get createVaultHere => 'Verschlüsselten Tresor hier erstellen...';

  @override
  String get disconnectAccount => 'Konto trennen';

  @override
  String get disconnectConfirmTitle => 'Konto trennen?';

  @override
  String get disconnectConfirmContent =>
      'Möchten Sie dieses Konto wirklich trennen? Entfernte Dateien bleiben unberührt.';

  @override
  String get allFiles => 'Alle Dateien';

  @override
  String get emptyFolder => 'Dieser Ordner ist leer';

  @override
  String get emptyFolderSubtitle =>
      'Laden Sie Dateien hoch oder erstellen Sie einen Unterordner.';

  @override
  String get uploadFile => 'Datei hochladen';

  @override
  String get uploadFolder => 'Ganzen Ordner hochladen';

  @override
  String get newFolder => 'Neuer Ordner';

  @override
  String get newFolderPrompt => 'Namen für den neuen Ordner eingeben:';

  @override
  String get folderNameHint => 'Ordnername';

  @override
  String get selectAll => 'Alle auswählen';

  @override
  String get clearSelection => 'Auswahl aufheben';

  @override
  String get deleteSelected => 'Ausgewählte löschen';

  @override
  String get deleteSelectedPrompt =>
      'Möchten Sie die ausgewählten Elemente wirklich löschen?';

  @override
  String get deleteItemPrompt => 'Möchten Sie dieses Element wirklich löschen?';

  @override
  String get shareLink => 'Freigabelink';

  @override
  String get createShareLink => 'Freigabelink erstellen';

  @override
  String get copyShareLink => 'Link kopieren';

  @override
  String get copiedToClipboard => 'In die Zwischenablage kopiert';

  @override
  String get transfers => 'Übertragungen';

  @override
  String get activeTransfers => 'Aktive Übertragungen';

  @override
  String get completed => 'Abgeschlossen';

  @override
  String get failed => 'Fehlgeschlagen';

  @override
  String get queued => 'In Warteschlange';

  @override
  String get cancelTransfer => 'Übertragung abbrechen';

  @override
  String get clearCompleted => 'Abgeschlossene leeren';

  @override
  String get syncRulesTitle => 'Backup- & Sync-Regeln';

  @override
  String get newRule => 'Neue Regel';

  @override
  String get noSyncRules => 'Keine Synchronisationsregeln eingerichtet';

  @override
  String get noSyncRulesSubtitle =>
      'Erstellen Sie eine automatische Regel, um lokale Ordner mit der Cloud zu synchronisieren.';

  @override
  String get ruleName => 'Regelname';

  @override
  String get sourcePath => 'Quellordner';

  @override
  String get destinationCloud => 'Ziel-Cloud';

  @override
  String get destinationPath => 'Zielpfad';

  @override
  String get direction => 'Richtung';

  @override
  String get frequency => 'Häufigkeit';

  @override
  String get runNow => 'Jetzt ausführen';

  @override
  String get syncInProgress => 'Synchronisation läuft...';

  @override
  String get syncSuccess => 'Synchronisation abgeschlossen';

  @override
  String get syncFailed => 'Synchronisation fehlgeschlagen';

  @override
  String get addCloudDialogTitle => 'Neue Cloud verbinden';

  @override
  String get selectProvider => 'Cloud-Anbieter auswählen';

  @override
  String get accountNameLabel => 'Kontoname / Alias';

  @override
  String get connectButton => 'Konto verbinden';

  @override
  String get vaultTitle => 'E2E-Verschlüsselung (Crypt)';

  @override
  String get vaultPassword => 'Tresor-Passwort';

  @override
  String get vaultConfirmPassword => 'Passwort bestätigen';

  @override
  String get vaultSalt => 'Salt / Sekundäres Passwort (Optional)';

  @override
  String get encryptFileNames => 'Dateinamen verschlüsseln';

  @override
  String get encryptDirNames => 'Ordnernamen verschlüsseln';

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
  String get selectLanguage => 'Sprache auswählen';

  @override
  String get searchLanguageHint => 'Sprache oder Land suchen...';

  @override
  String get currentLanguage => 'Aktuelle Sprache';

  @override
  String systemDefaultWithLocale(String locale) {
    return 'Systemstandard ($locale)';
  }

  @override
  String get refreshCloudsTooltip => 'Konfigurierte Clouds aktualisieren';

  @override
  String get storageOverviewAggregated => 'Aggregierte Speicherübersicht';

  @override
  String get ramEncryptionActive => 'RAM-Verschlüsselung aktiv';

  @override
  String connectedAccountsCount(int count) {
    return 'Verbundene Cloud-Konten: $count';
  }

  @override
  String get noCloudsConfiguredHint =>
      'Keine Cloud-Konten konfiguriert. Tippen Sie unten auf „+ Neue Cloud verbinden“.';

  @override
  String percentUsed(String percent) {
    return '$percent% belegt';
  }

  @override
  String availableSpace(String space) {
    return '$space verfügbar';
  }

  @override
  String get calculatingQuota =>
      'Speicherquoten werden berechnet oder unbegrenzter Speicher...';

  @override
  String get syncAndBackup => 'Synchronisation & Backup';

  @override
  String get noRulesConfigured => 'Keine Regeln eingerichtet';

  @override
  String activeRulesCount(int active, int total) {
    return '$active/$total aktive Regeln';
  }

  @override
  String get manage => 'Verwalten';

  @override
  String connectedCloudsCount(int count) {
    return 'Verbundene Clouds ($count)';
  }

  @override
  String get connectNewCloud => 'Neue Cloud verbinden';

  @override
  String get noCloudProvidersConnected => 'Keine Cloud-Anbieter verbunden';

  @override
  String get connectCloudDescription =>
      'Verbinden Sie Google Drive, Dropbox, OneDrive, SFTP oder WebDAV, um Ihre Dateien zu synchronisieren.';

  @override
  String get addFirstCloud => 'Erste Cloud hinzufügen';

  @override
  String vaultOnRemote(String remote) {
    return 'TRESOR AUF $remote';
  }

  @override
  String get disconnectCloudTitle => 'Cloud trennen';

  @override
  String disconnectCloudPrompt(String name) {
    return 'Möchten Sie „$name“ trennen? Die Anmeldedaten werden aus dem sicheren Speicher entfernt.';
  }

  @override
  String get disconnect => 'Trennen';

  @override
  String freeSpace(String space) {
    return '$space frei';
  }

  @override
  String get storage => 'Speicher';

  @override
  String get available => 'Verfügbar';

  @override
  String get exploreFiles => 'Dateien erkunden';

  @override
  String get paneLeft => 'Links';

  @override
  String get paneRight => 'Rechts';

  @override
  String get folderName => 'Ordnername';

  @override
  String errorCreatingFolder(String error) {
    return 'Fehler beim Erstellen des Ordners: $error';
  }

  @override
  String get moveAction => 'Verschieben';

  @override
  String get copyAction => 'Kopieren';

  @override
  String transferBatchStarted(String action, int count, String remote) {
    return '$action von $count Elementen nach [$remote] gestartet...';
  }

  @override
  String errorTransferring(String error) {
    return 'Fehler bei der Übertragung: $error';
  }

  @override
  String itemCopiedToClipboard(String name) {
    return '„$name“ in die Zwischenablage kopiert';
  }

  @override
  String itemsCopiedToClipboard(int count) {
    return '$count Elemente in die Zwischenablage kopiert';
  }

  @override
  String itemCutToClipboard(String name) {
    return '„$name“ ausgeschnitten (bereit zum Verschieben)';
  }

  @override
  String itemsCutToClipboard(int count) {
    return '$count Elemente ausgeschnitten (bereit zum Verschieben)';
  }

  @override
  String get noFilesSelectedForDownload =>
      'Keine Dateien zum Herunterladen ausgewählt.';

  @override
  String downloadingItems(int count) {
    return '$count Elemente werden heruntergeladen...';
  }

  @override
  String itemsDownloadedSuccess(int count, String path) {
    return '$count Elemente erfolgreich nach „$path“ heruntergeladen';
  }

  @override
  String errorStartingDownload(String error) {
    return 'Fehler beim Starten des Downloads: $error';
  }

  @override
  String deleteItemsConfirmTitle(int count) {
    return '$count ausgewählte Elemente löschen?';
  }

  @override
  String deleteItemsConfirmPrompt(int count) {
    return 'Möchten Sie $count ausgewählte Elemente wirklich endgültig aus der Cloud löschen?';
  }

  @override
  String itemsDeletedSuccess(int count) {
    return '$count Elemente gelöscht';
  }

  @override
  String errorDeleting(String error) {
    return 'Fehler beim Löschen: $error';
  }

  @override
  String get uploadCompletedSuccess => 'Upload erfolgreich abgeschlossen';

  @override
  String errorUploading(String error) {
    return 'Fehler beim Hochladen: $error';
  }

  @override
  String get folderUploadCompletedSuccess =>
      'Ordner-Upload erfolgreich abgeschlossen';

  @override
  String errorFolderUploading(String error) {
    return 'Fehler beim Hochladen des Ordners: $error';
  }

  @override
  String get filesAlreadyInDirectory =>
      'Die Dateien befinden sich bereits in diesem Ordner.';

  @override
  String dragDropTransferStarted(String action, int count, String remote) {
    return '$action von $count Elementen nach [$remote] gestartet...';
  }

  @override
  String errorDragDrop(String error) {
    return 'Fehler bei Drag-and-Drop-Übertragung: $error';
  }

  @override
  String get closeSelection => 'Auswahl schließen';

  @override
  String itemsSelectedCount(int count) {
    return '$count ausgewählt';
  }

  @override
  String get deselectAll => 'Alle abwählen';

  @override
  String copyToRemote(String remote) {
    return 'Nach $remote kopieren';
  }

  @override
  String moveToRemote(String remote) {
    return 'Nach $remote verschieben';
  }

  @override
  String get moreActions => 'Weitere Aktionen';

  @override
  String get downloadSelected => 'Ausgewählte herunterladen';

  @override
  String get copyToClipboard => 'In Zwischenablage kopieren';

  @override
  String get cutToClipboard => 'In Zwischenablage ausschneiden';

  @override
  String get selectCloud => 'Cloud auswählen';

  @override
  String get closeSearch => 'Suche schließen';

  @override
  String get uploadFromDevice => 'Vom Gerät hochladen';

  @override
  String get moreOptions => 'Mehr Optionen';

  @override
  String get viewGrid => 'Rasteransicht';

  @override
  String get viewList => 'Listenansicht';

  @override
  String get multiSelection => 'Mehrfachauswahl';

  @override
  String get sortNameAsc => 'Name (A-Z)';

  @override
  String get sortNameDesc => 'Name (Z-A)';

  @override
  String get sortSizeDesc => 'Größe (Groß -> Klein)';

  @override
  String get sortSizeAsc => 'Größe (Klein -> Groß)';

  @override
  String get sortDateDesc => 'Datum (Neueste zuerst)';

  @override
  String get disableDualPane => 'Commander deaktivieren (Ein Spalte)';

  @override
  String get enableDualPane => 'Commander aktivieren (Zwei Spalten)';

  @override
  String itemsInClipboard(int count) {
    return '$count Elemente in der Zwischenablage';
  }

  @override
  String get pasteHere => 'Hier einfügen';

  @override
  String get noResults => 'Keine Ergebnisse';

  @override
  String noMatchingResults(String query) {
    return 'Keine Dateien oder Ordner entsprechen „$query“';
  }

  @override
  String get selectACloud => 'Wählen Sie eine Cloud';

  @override
  String get selectCloudDescription =>
      'Wählen Sie oben einen Cloud-Anbieter, um Ihre Remote-Dateien anzuzeigen.';

  @override
  String optionsForItem(String name) {
    return 'Optionen für $name';
  }

  @override
  String get select => 'Auswählen';

  @override
  String get openWithSystemApp => 'Mit System-App öffnen';

  @override
  String get downloadToLocal => 'Lokal herunterladen';

  @override
  String get cut => 'Ausschneiden (Verschieben)';

  @override
  String get copyPath => 'Pfad kopieren';

  @override
  String get info => 'Informationen';

  @override
  String generatingShareLink(String name) {
    return 'Freigabelink für „$name“ wird generiert...';
  }

  @override
  String errorPublicLink(String error) {
    return 'Fehler bei öffentlichem Link: $error';
  }

  @override
  String get noLinkGenerated => 'Kein Link vom Anbieter erhalten.';

  @override
  String errorDownloading(String error) {
    return 'Fehler beim Herunterladen: $error';
  }

  @override
  String get renameFolderTitle => 'Ordner umbenennen';

  @override
  String get renameFileTitle => 'Datei umbenennen';

  @override
  String errorRenaming(String error) {
    return 'Fehler beim Umbenennen: $error';
  }

  @override
  String get pathCopiedToClipboard => 'Pfad in die Zwischenablage kopiert';

  @override
  String itemDetailsPath(String path) {
    return 'Pfad: $path';
  }

  @override
  String itemDetailsType(String type) {
    return 'Typ: $type';
  }

  @override
  String itemDetailsSize(String size) {
    return 'Größe: $size';
  }

  @override
  String itemDetailsModified(String date) {
    return 'Änderungsdatum: $date';
  }

  @override
  String get folder => 'Ordner';

  @override
  String get file => 'Datei';

  @override
  String get selectCloudFirstLeft =>
      'Wählen Sie zuerst eine Cloud im linken Bereich.';

  @override
  String get selectCloudFirstRight =>
      'Wählen Sie zuerst eine Cloud im rechten Bereich.';

  @override
  String get selectDestinationCloudLeft =>
      'Wählen Sie zuerst eine Ziel-Cloud im linken Bereich.';

  @override
  String get selectDestinationCloudRight =>
      'Wählen Sie zuerst eine Ziel-Cloud im rechten Bereich.';

  @override
  String get noFilesToTransfer =>
      'Keine Dateien zum Übertragen vorhanden oder ausgewählt.';

  @override
  String transferStarted(String action, int count, String src, String dst) {
    return '$action von $count Elementen von [$src] nach [$dst] gestartet...';
  }

  @override
  String get swapPanesTooltip => 'Bereiche tauschen (<->)';

  @override
  String get refreshBothPanesTooltip => 'Beide Bereiche aktualisieren';

  @override
  String get copyRight => 'Nach rechts kopieren ->';

  @override
  String get moveRight => 'Nach rechts verschieben ->';

  @override
  String get copyLeft => '<- Nach links kopieren';

  @override
  String get moveLeft => '<- Nach links verschieben';

  @override
  String copyRightWithCount(int count) {
    return 'Nach rechts kopieren ($count) ->';
  }

  @override
  String moveRightWithCount(int count) {
    return 'Nach rechts verschieben ($count) ->';
  }

  @override
  String copyLeftWithCount(int count) {
    return '<- Nach links kopieren ($count)';
  }

  @override
  String moveLeftWithCount(int count) {
    return '<- Nach links verschieben ($count)';
  }

  @override
  String get deleteRuleTitle => 'Regel löschen';

  @override
  String deleteRulePrompt(String name) {
    return 'Möchten Sie die Synchronisationsregel „$name“ wirklich löschen? Dateien bleiben erhalten.';
  }

  @override
  String get syncAll => 'Alle synchronisieren';

  @override
  String get newRuleTooltip => 'Neue Regel';

  @override
  String get backupBannerTitle => 'Kontinuierliches Backup & Cloud-Sync';

  @override
  String get backupBannerSubtitle =>
      'Richten Sie geplante Synchronisationen zwischen lokalen Ordnern und der Cloud ein.';

  @override
  String get noActiveRules => 'Keine aktiven Regeln';

  @override
  String get noActiveRulesSubtitle =>
      'Erstellen Sie Ihre erste Regel für automatische Backups zu Google Drive, Dropbox, SFTP oder anderen Clouds.';

  @override
  String get createNewRule => 'Neue Regel erstellen';

  @override
  String get ruleOptionsTooltip => 'Regeloptionen';

  @override
  String get syncNow => 'Jetzt synchronisieren';

  @override
  String get statusWaiting => 'Ausstehend';

  @override
  String get statusInProgress => 'Wird ausgeführt...';

  @override
  String get statusCompleted => 'Abgeschlossen';

  @override
  String get statusFailed => 'Fehler';

  @override
  String get editRuleTitle => 'Backup-Regel bearbeiten';

  @override
  String get newRuleTitle => 'Neue Synchronisationsregel';

  @override
  String get ruleDialogSubtitle =>
      'Automatisches Backup zwischen lokalem Ordner und Cloud konfigurieren.';

  @override
  String get ruleNameOptional => 'Regelname (optional)';

  @override
  String get ruleNameHint => 'z.B. Fotos DCIM Backup oder Arbeitsdokumente';

  @override
  String get sourceLocalFolder => 'Lokaler Quellordner';

  @override
  String get sourceLocalFolderHint =>
      '/storage/emulated/0/DCIM oder /home/benutzer/Bilder';

  @override
  String get browseFolders => 'Ordner durchsuchen';

  @override
  String get selectLocalFolderError =>
      'Bitte wählen oder geben Sie einen lokalen Ordner ein';

  @override
  String get noCloudsConfiguredSync =>
      'Keine Cloud konfiguriert. Bitte richten Sie zuerst auf der Startseite ein Cloud-Konto ein.';

  @override
  String get remoteDestinationPath => 'Entfernter Zielpfad';

  @override
  String get syncMode => 'Synchronisationsmodus';

  @override
  String get syncModeCopy => 'Inkrementelles Backup';

  @override
  String get syncModeCopyDesc =>
      'Lädt neue und geänderte Dateien hoch und behält vorhandene Cloud-Dateien bei.';

  @override
  String get syncModeSync => 'Spiegelsynchronisation';

  @override
  String get syncModeSyncDesc =>
      'Gleicht die Ziel-Cloud exakt an (lokal gelöschte Dateien werden in der Cloud entfernt).';

  @override
  String get syncFrequency => 'Ausführungshäufigkeit';

  @override
  String get freqManual => 'Manuell (nur auf Anfrage)';

  @override
  String get freq15Min => 'Alle 15 Minuten';

  @override
  String get freq30Min => 'Alle 30 Minuten';

  @override
  String get freqHourly => 'Jede Stunde';

  @override
  String get freq6Hours => 'Alle 6 Stunden';

  @override
  String get freq12Hours => 'Alle 12 Stunden';

  @override
  String get freqDaily => 'Täglich (24 Stunden)';

  @override
  String get activateRuleImmediately => 'Regel sofort aktivieren';

  @override
  String get activateRuleImmediatelyDesc =>
      'Die Synchronisation wird im Hintergrund nach dem festgelegten Intervall ausgeführt';

  @override
  String get updateRule => 'Aktualisieren';

  @override
  String get saveRule => 'Regel speichern';

  @override
  String get selectCloudProvider => 'Cloud-Anbieter wählen:';

  @override
  String get cloudAccountName => 'Cloud-Kontoname';

  @override
  String get cloudAccountNameHint =>
      'z.B. GoogleDrive, ArbeitDropbox (ohne Leerzeichen)';

  @override
  String get enterNameError => 'Bitte geben Sie einen Namen ein';

  @override
  String get noSpacesOrColons => 'Leerzeichen und „:“ sind nicht erlaubt';

  @override
  String get oauthMode => 'Client-ID-Modus (OAuth2)';

  @override
  String get oauthOfficial => 'UnifyCloud (Offiziell / Empfohlen)';

  @override
  String get oauthRclone => 'Rclone (Nicht empfohlen - Geteiltes Kontingent)';

  @override
  String get oauthCustom => 'Eigene Client-ID (Erweitert)';

  @override
  String get officialOauthTitle => 'Offizielle UnifyCloud-Zugangsdaten';

  @override
  String get officialOauthDesc =>
      'Vorkonfigurierte Anmeldedaten für sofortige Verbindung mit dediziertem Kontingent und maximaler Geschwindigkeit.';

  @override
  String get rcloneOauthDesc =>
      'Öffentliche Rclone-Schlüssel. Können Kontingentbegrenzungen oder temporäre Google 403-Fehler verursachen.';

  @override
  String get customClientId => 'Client-ID';

  @override
  String get customClientSecret => 'Client-Secret';

  @override
  String get selectVaultDestination => 'Ziel-Cloud für den Tresor auswählen';

  @override
  String get vaultPasswordRequired => 'Das Tresor-Passwort ist erforderlich';

  @override
  String get vaultPasswordsDoNotMatch => 'Die Passwörter stimmen nicht überein';

  @override
  String errorAddingRemote(String error) {
    return 'Fehler beim Hinzufügen der Cloud: $error';
  }

  @override
  String get fileNameEncryption => 'Dateinamen-Verschlüsselung';

  @override
  String get encryptStandard =>
      'Standard (Dateinamen vollständig verschlüsselt - Empfohlen)';

  @override
  String get encryptObscure =>
      'Einfache Verschleierung (Dateiendungen bleiben erhalten)';

  @override
  String get encryptOff => 'Deaktiviert (Klartext-Namen)';

  @override
  String get encryptFolderNames => 'Auch Ordnernamen verschlüsseln';

  @override
  String get encryptFolderNamesDesc =>
      'Verbirgt die Ordnerstruktur in der Cloud vollständig';

  @override
  String get connectCloud => 'Cloud verbinden';

  @override
  String get reopenAuth => 'Erneut öffnen';

  @override
  String get linkCopiedToClipboard => 'Link in Zwischenablage kopiert!';

  @override
  String errorOpenBrowserGeneric(String error) {
    return 'Browser konnte nicht geöffnet werden: $error';
  }

  @override
  String get shareableLinkTitle => 'Freigabelink';

  @override
  String shareLinkAccessDescription(String item) {
    return 'Jeder mit diesem Link hat Zugriff auf $item:';
  }

  @override
  String get open => 'Öffnen';

  @override
  String activeTransfersCount(int count) {
    return '$count aktive Übertragungen';
  }

  @override
  String transfersQueueCount(int count) {
    return 'Übertragungswarteschlange ($count)';
  }

  @override
  String get noTransfersInProgress => 'Keine Übertragungen aktiv';

  @override
  String get transfersEmptySubtitle =>
      'Alle heruntergeladenen oder hochgeladenen Dateien erscheinen hier';

  @override
  String get cancelled => 'Abgebrochen';

  @override
  String get appLockedTitle => 'Anwendung gesperrt';

  @override
  String get unlockWithBiometrics => 'Mit Biometrie entsperren';

  @override
  String get pinMustBe6Digits => 'Der PIN muss genau 6 Ziffern enthalten';

  @override
  String get pinIncorrect => 'Falscher PIN. Bitte erneut versuchen.';

  @override
  String get pinsDoNotMatch =>
      'Die PINs stimmen nicht überein. Bitte erneut versuchen.';

  @override
  String get pinStepOld =>
      'Geben Sie Ihren aktuellen PIN ein, um fortzufahren.';

  @override
  String get pinStepNew =>
      'Geben Sie Ihren neuen 6-stelligen Sicherheits-PIN ein.';

  @override
  String get pinStepConfirm =>
      'Geben Sie den neuen PIN zur Bestätigung erneut ein.';

  @override
  String get pinStepVerify =>
      'Geben Sie Ihren PIN ein, um den Vorgang zu bestätigen.';

  @override
  String get pinTitleSetup => 'Sicherheits-PIN einrichten';

  @override
  String get pinTitleChange => 'Sicherheits-PIN ändern';

  @override
  String get pinTitleVerify => 'Sicherheitsüberprüfung';

  @override
  String get pinContinue => 'Weiter';

  @override
  String get errorDetails => 'Fehlerdetails';

  @override
  String get errorDetailsCopied => 'Fehlerdetails in Zwischenablage kopiert';

  @override
  String get collapse => 'Einklappen';

  @override
  String get expand => 'Ausklappen';

  @override
  String get copyError => 'Fehler kopieren';

  @override
  String get errorNetwork =>
      'Keine oder instabile Verbindung. Überprüfen Sie Ihre Internetverbindung und versuchen Sie es erneut.';

  @override
  String get errorDiskSpace =>
      'Nicht genügend Speicherplatz oder Festplatte voll. Speicher freigeben, um fortzufahren.';

  @override
  String get errorAuthExpired =>
      'Sitzung oder Token abgelaufen/widerrufen. Bitte verbinden Sie Ihr Konto erneut.';

  @override
  String get errorNotFound =>
      'Element oder Ordner beim Cloud-Anbieter nicht gefunden.';

  @override
  String get errorPermissionDenied =>
      'Zugriff für diesen Cloud-Vorgang verweigert.';

  @override
  String get errorGeneric => 'Während des Vorgangs ist ein Fehler aufgetreten.';

  @override
  String get desktopAndSystem => 'Desktop & System';

  @override
  String get desktopAndSystemSubtitle =>
      'Startup behavior, background execution, and system tray';

  @override
  String get autostartOnBoot => 'Start on system boot';

  @override
  String get autostartOnBootSubtitle =>
      'Automatically launch UnifyCloud in the background on login';

  @override
  String get minimizeToTray => 'Minimize to system tray';

  @override
  String get minimizeToTraySubtitle =>
      'Keep UnifyCloud running in the background when the window is closed';

  @override
  String get trayStatusIdle => 'Idle (No active transfers)';

  @override
  String trayStatusActive(int count, String speed) {
    return '$count active transfers ($speed)';
  }

  @override
  String get trayShowWindow => 'Show UnifyCloud';

  @override
  String get trayHideWindow => 'Hide to system tray';

  @override
  String get trayQuit => 'Quit UnifyCloud';

  @override
  String get trayTooltip => 'UnifyCloud - Cloud Storage Manager';
}
