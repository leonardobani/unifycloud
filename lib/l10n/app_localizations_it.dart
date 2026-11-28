// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'UnifyCloud';

  @override
  String get home => 'Home';

  @override
  String get explorer => 'Esplora';

  @override
  String get sync => 'Sincronizzazione';

  @override
  String get settings => 'Impostazioni';

  @override
  String get cancel => 'Annulla';

  @override
  String get confirm => 'Conferma';

  @override
  String get delete => 'Elimina';

  @override
  String get save => 'Salva';

  @override
  String get close => 'Chiudi';

  @override
  String get edit => 'Modifica';

  @override
  String get create => 'Crea';

  @override
  String get retry => 'Riprova';

  @override
  String get copy => 'Copia';

  @override
  String get move => 'Sposta';

  @override
  String get rename => 'Rinomina';

  @override
  String get download => 'Scarica';

  @override
  String get upload => 'Carica';

  @override
  String get share => 'Condividi';

  @override
  String get details => 'Dettagli';

  @override
  String get search => 'Cerca';

  @override
  String get change => 'Cambia';

  @override
  String get reset => 'Ripristina';

  @override
  String get done => 'Fine';

  @override
  String get loading => 'Caricamento...';

  @override
  String get success => 'Operazione completata';

  @override
  String get error => 'Errore';

  @override
  String get settingsTitle => 'Impostazioni';

  @override
  String get resetDefaultsTooltip => 'Ripristina Impostazioni Predefinite';

  @override
  String get resetDialogTitle => 'Ripristina Impostazioni';

  @override
  String get resetDialogContent =>
      'Vuoi ripristinare tutte le preferenze (tema, lingua, cartelle, visualizzazione) ai valori di fabbrica?';

  @override
  String get resetSuccessSnackbar =>
      'Impostazioni ripristinate ai valori predefiniti';

  @override
  String get appearanceAndTheme => 'Aspetto & Tema';

  @override
  String get chooseVisualThemeSubtitle =>
      'Scegli il tema visivo per l\'interfaccia di UnifyCloud:';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Chiaro';

  @override
  String get themeDark => 'Scuro';

  @override
  String get language => 'Lingua';

  @override
  String get languageSubtitle => 'Seleziona la lingua dell\'interfaccia';

  @override
  String get langEnglish => 'English';

  @override
  String get langItalian => 'Italiano';

  @override
  String get langSystem => 'Predefinito di sistema';

  @override
  String get filesAndExploration => 'File & Esplorazione';

  @override
  String get showHiddenFiles => 'Mostra elementi nascosti';

  @override
  String get showHiddenFilesSubtitle =>
      'Visualizza file e cartelle che iniziano con un punto';

  @override
  String get confirmBeforeDelete => 'Conferma prima di eliminare';

  @override
  String get confirmBeforeDeleteSubtitle =>
      'Chiedi una conferma di sicurezza prima di cancellare file';

  @override
  String get defaultDownloadFolder => 'Cartella Download Predefinita';

  @override
  String get defaultDownloadFolderSystem =>
      'Cartella Download predefinita del sistema';

  @override
  String get restoreDefaultPath => 'Ripristina percorso di sistema';

  @override
  String get customDownloadFolderDialogPrompt =>
      'Seleziona una cartella tramite il selettore del sistema oppure inserisci manualmente il percorso desiderato:';

  @override
  String get folderPath => 'Percorso cartella';

  @override
  String get folderPathHint => 'es. /home/utente/Scaricati';

  @override
  String get browseWithSystemPicker => 'Sfoglia con selettore di sistema';

  @override
  String errorOpenPicker(String error) {
    return 'Impossibile aprire il selettore di sistema: $error';
  }

  @override
  String get restoreDefault => 'Ripristina predefinito';

  @override
  String get maxConcurrentTransfers => 'Trasferimenti Contemporanei';

  @override
  String get maxConcurrentTransfersSubtitle =>
      'Numero massimo di file trasferiti contemporaneamente';

  @override
  String get dualPaneMode => 'Modalità Due Pannelli (Commander)';

  @override
  String get dualPaneModeSubtitle =>
      'Mostra due pannelli affiancati su schermi larghi e tablet';

  @override
  String get communityAndSupport => 'Community & Sviluppo';

  @override
  String get openSourceDescription =>
      'UnifyCloud è un software libero e indipendente creato per unificare i tuoi dati cloud senza tracker o intermediari proprietari.';

  @override
  String get supportDeveloper => 'Sostieni lo Sviluppatore';

  @override
  String get supportDeveloperSubtitle =>
      'Offri un caffè per supportare lo sviluppo indipendente';

  @override
  String get viewSourceOnGitLab => 'Vedi Codice su GitLab';

  @override
  String get viewSourceOnGitLabSubtitle =>
      'Repository ufficiale, segnalazione bug e contributi';

  @override
  String errorOpenBrowser(String url) {
    return 'Impossibile aprire il browser. Repository: $url';
  }

  @override
  String get supportDialogTitle => 'Sostieni UnifyCloud';

  @override
  String get supportDialogDescription1 =>
      'UnifyCloud è un progetto gratuito e open-source nato per darti il pieno controllo sui tuoi file nei vari cloud.';

  @override
  String get supportDialogDescription2 =>
      'Se trovi utile l\'applicazione nel tuo lavoro o nella tua vita quotidiana, puoi offrire un caffè o fare una donazione per sostenere lo sviluppo continuo, l\'integrazione di nuovi provider e la manutenzione!';

  @override
  String get supportKofiTitle => 'Offri un caffè su Ko-fi';

  @override
  String get supportLiberapayTitle => 'Dona su Liberapay';

  @override
  String get supportPaypalTitle => 'Donazione via PayPal';

  @override
  String get securityAndEncryption => 'Sicurezza & Cifratura';

  @override
  String get securityArchitectureDescription =>
      'UnifyCloud adotta un\'architettura Zero-Plaintext. Tutti i token OAuth e le credenziali di accesso sono protetti nel Keychain/Keystore di sistema e iniettati esclusivamente nella memoria RAM del motore Go.';

  @override
  String get appLock => 'Blocco Applicazione (PIN / Biometria)';

  @override
  String get appLockSubtitle => 'Richiedi PIN o Impronta Digitale per accedere';

  @override
  String get appLockActiveSubtitle => 'Attivo all\'avvio e dopo inattività';

  @override
  String get appLockEnabledSnackbar =>
      'Blocco applicazione attivato con successo';

  @override
  String get appLockDisabledSnackbar => 'Blocco applicazione disattivato';

  @override
  String get changePin => 'Cambia Codice PIN';

  @override
  String get changePinSubtitle => 'Modifica il codice numerico a 6 cifre';

  @override
  String get pinChangedSnackbar => 'Codice PIN modificato con successo';

  @override
  String get biometricAuth => 'Autenticazione Biometrica';

  @override
  String get biometricAuthSubtitle => 'Usa Impronta Digitale o Face Unlock';

  @override
  String get biometricNotAvailable =>
      'Non disponibile o non configurata su questo dispositivo';

  @override
  String get autoLock => 'Blocco Automatico';

  @override
  String get autoLockSubtitle =>
      'Tempo di inattività in background prima di bloccare';

  @override
  String get lockImmediately => 'Immediatamente';

  @override
  String get lockAfter1Minute => 'Dopo 1 minuto';

  @override
  String get lockAfter5Minutes => 'Dopo 5 minuti';

  @override
  String get lockAfter15Minutes => 'Dopo 15 minuti';

  @override
  String get lockAfter30Minutes => 'Dopo 30 minuti';

  @override
  String get syncCloudAccounts => 'Sincronizza Account Cloud';

  @override
  String get syncCloudAccountsSubtitle =>
      'Ricarica le configurazioni dalla memoria protetta';

  @override
  String get syncCloudAccountsSuccess =>
      'Account cloud ricaricati con successo';

  @override
  String get clearAllCredentials => 'Cancella Tutte le Credenziali';

  @override
  String get clearAllCredentialsSubtitle =>
      'Rimuove la configurazione cifrata e disconnette tutti i cloud';

  @override
  String get clearCredentialsDialogTitle => 'Attenzione: Reset Credenziali';

  @override
  String get clearCredentialsDialogContent =>
      'Sei sicuro di voler eliminare tutte le credenziali salvate? Dovrai riconnettere i tuoi account cloud.';

  @override
  String get clearCredentialsSuccess => 'Credenziali eliminate con successo';

  @override
  String get aboutUnifyCloud => 'Informazioni su UnifyCloud';

  @override
  String get appVersion => 'Versione App: 1.0.1';

  @override
  String get developerInfo => 'Sviluppatore: Leonardo Bani (@leonardobani)';

  @override
  String get engineInfo => 'Motore: Rclone Core CGO (Go v1.22+ / C FFI)';

  @override
  String get frameworkInfo => 'Framework: Flutter (Material 3 Responsive)';

  @override
  String get licenseInfo =>
      'Licenza: GNU General Public License v3.0 (GPL-3.0)';

  @override
  String get copyrightInfo => 'Copyright: © 2026 Leonardo Bani';

  @override
  String get storageOverview => 'Panoramica Spazio';

  @override
  String get connectedClouds => 'Cloud Connessi';

  @override
  String get noCloudsConfigured => 'Nessun account cloud configurato';

  @override
  String get noCloudsDescription =>
      'Aggiungi il tuo primo cloud storage per iniziare a gestire e sincronizzare i tuoi file.';

  @override
  String get addCloud => 'Aggiungi Cloud';

  @override
  String get used => 'usati';

  @override
  String get free => 'liberi';

  @override
  String get total => 'totali';

  @override
  String get manageAccounts => 'Gestisci Account';

  @override
  String get viewFiles => 'Visualizza File';

  @override
  String get createVaultHere => 'Crea Vault Cifrato qui...';

  @override
  String get disconnectAccount => 'Disconnetti account';

  @override
  String get disconnectConfirmTitle => 'Disconnettere account?';

  @override
  String get disconnectConfirmContent =>
      'Vuoi rimuovere questo account? I file remoti non verranno eliminati.';

  @override
  String get allFiles => 'Tutti i File';

  @override
  String get emptyFolder => 'Questa cartella è vuota';

  @override
  String get emptyFolderSubtitle =>
      'Carica file o crea una cartella per iniziare.';

  @override
  String get uploadFile => 'Carica file';

  @override
  String get uploadFolder => 'Carica intera cartella';

  @override
  String get newFolder => 'Nuova Cartella';

  @override
  String get newFolderPrompt => 'Inserisci il nome della nuova cartella:';

  @override
  String get folderNameHint => 'Nome cartella';

  @override
  String get selectAll => 'Seleziona tutti';

  @override
  String get clearSelection => 'Deseleziona';

  @override
  String get deleteSelected => 'Elimina selezionati';

  @override
  String get deleteSelectedPrompt =>
      'Vuoi davvero eliminare gli elementi selezionati?';

  @override
  String get deleteItemPrompt => 'Vuoi davvero eliminare questo elemento?';

  @override
  String get shareLink => 'Condividi Link';

  @override
  String get createShareLink => 'Crea link condivisibile';

  @override
  String get copyShareLink => 'Copia Link';

  @override
  String get copiedToClipboard => 'Copiato negli appunti';

  @override
  String get transfers => 'Trasferimenti';

  @override
  String get activeTransfers => 'Trasferimenti Attivi';

  @override
  String get completed => 'Completato';

  @override
  String get failed => 'Fallito';

  @override
  String get queued => 'In coda';

  @override
  String get cancelTransfer => 'Annulla trasferimento';

  @override
  String get clearCompleted => 'Pulisci completati';

  @override
  String get syncRulesTitle => 'Regole di Backup & Sync';

  @override
  String get newRule => 'Nuova Regola';

  @override
  String get noSyncRules => 'Nessuna regola di sincronizzazione configurata';

  @override
  String get noSyncRulesSubtitle =>
      'Crea una regola automatica per sincronizzare cartelle locali con il tuo cloud.';

  @override
  String get ruleName => 'Nome Regola';

  @override
  String get sourcePath => 'Cartella Origine';

  @override
  String get destinationCloud => 'Cloud di Destinazione';

  @override
  String get destinationPath => 'Percorso Remoto';

  @override
  String get direction => 'Direzione';

  @override
  String get frequency => 'Frequenza';

  @override
  String get runNow => 'Avvia Ora';

  @override
  String get syncInProgress => 'Sincronizzazione in corso...';

  @override
  String get syncSuccess => 'Sincronizzazione completata';

  @override
  String get syncFailed => 'Sincronizzazione fallita';

  @override
  String get addCloudDialogTitle => 'Collega Nuovo Cloud';

  @override
  String get selectProvider => 'Seleziona Provider Cloud';

  @override
  String get accountNameLabel => 'Nome Account / Alias';

  @override
  String get connectButton => 'Collega Account';

  @override
  String get vaultTitle => 'Crittografia E2E (Crypt)';

  @override
  String get vaultPassword => 'Password Vault';

  @override
  String get vaultConfirmPassword => 'Conferma Password';

  @override
  String get vaultSalt => 'Salt / Password Secondaria (Opzionale)';

  @override
  String get encryptFileNames => 'Cifra nomi dei file';

  @override
  String get encryptDirNames => 'Cifra nomi delle cartelle';

  @override
  String get langSpanish => 'Español';

  @override
  String get langFrench => 'Français';

  @override
  String get langArabic => 'العربية';

  @override
  String get langPolish => 'Polski';

  @override
  String get selectLanguage => 'Seleziona Lingua';

  @override
  String get searchLanguageHint => 'Cerca lingua o paese...';

  @override
  String get currentLanguage => 'Lingua Attuale';

  @override
  String systemDefaultWithLocale(String locale) {
    return 'Predefinito di Sistema ($locale)';
  }

  @override
  String get refreshCloudsTooltip => 'Aggiorna cloud configurati';

  @override
  String get storageOverviewAggregated => 'Panoramica Storage Aggregato';

  @override
  String get ramEncryptionActive => 'Cifratura RAM Attiva';

  @override
  String connectedAccountsCount(int count) {
    return 'Account Cloud Collegati: $count';
  }

  @override
  String get noCloudsConfiguredHint =>
      'Nessun account cloud configurato. Tocca \"+ Collega Nuovo Cloud\" in basso.';

  @override
  String percentUsed(String percent) {
    return '$percent% occupato';
  }

  @override
  String availableSpace(String space) {
    return '$space disponibili';
  }

  @override
  String get calculatingQuota =>
      'Calcolo quote storage in corso o spazio illimitato...';

  @override
  String get syncAndBackup => 'Sincronizzazione & Backup';

  @override
  String get noRulesConfigured => 'Nessuna regola configurata';

  @override
  String activeRulesCount(int active, int total) {
    return '$active/$total regole attive';
  }

  @override
  String get manage => 'Gestisci';

  @override
  String connectedCloudsCount(int count) {
    return 'Cloud Collegati ($count)';
  }

  @override
  String get connectNewCloud => 'Collega Nuovo Cloud';

  @override
  String get noCloudProvidersConnected => 'Nessun Provider Cloud Collegato';

  @override
  String get connectCloudDescription =>
      'Collega Google Drive, Dropbox, OneDrive, SFTP o WebDAV per iniziare a sincronizzare ed esplorare i tuoi file.';

  @override
  String get addFirstCloud => 'Aggiungi Primo Cloud';

  @override
  String vaultOnRemote(String remote) {
    return 'VAULT SU $remote';
  }

  @override
  String get disconnectCloudTitle => 'Disconnetti Cloud';

  @override
  String disconnectCloudPrompt(String name) {
    return 'Vuoi rimuovere \"$name\"? Le credenziali verranno eliminate dallo storage cifrato.';
  }

  @override
  String get disconnect => 'Disconnetti';

  @override
  String freeSpace(String space) {
    return '$space liberi';
  }

  @override
  String get storage => 'Storage';

  @override
  String get available => 'Disponibile';

  @override
  String get exploreFiles => 'Esplora File';

  @override
  String get paneLeft => 'Sinistra';

  @override
  String get paneRight => 'Destra';

  @override
  String get folderName => 'Nome cartella';

  @override
  String errorCreatingFolder(String error) {
    return 'Errore creazione cartella: $error';
  }

  @override
  String get moveAction => 'Spostamento';

  @override
  String get copyAction => 'Copia';

  @override
  String transferBatchStarted(String action, int count, String remote) {
    return '$action di $count elementi verso [$remote] avviato...';
  }

  @override
  String errorTransferring(String error) {
    return 'Errore durante il trasferimento: $error';
  }

  @override
  String itemCopiedToClipboard(String name) {
    return '\"$name\" copiato negli appunti';
  }

  @override
  String itemsCopiedToClipboard(int count) {
    return '$count elementi copiati negli appunti';
  }

  @override
  String itemCutToClipboard(String name) {
    return '\"$name\" tagliato (pronto per lo spostamento)';
  }

  @override
  String itemsCutToClipboard(int count) {
    return '$count elementi tagliati (pronti per lo spostamento)';
  }

  @override
  String get noFilesSelectedForDownload =>
      'Nessun file selezionato per il download.';

  @override
  String downloadingItems(int count) {
    return 'Download di $count elementi in corso...';
  }

  @override
  String itemsDownloadedSuccess(int count, String path) {
    return '$count elementi scaricati in \"$path\"';
  }

  @override
  String errorStartingDownload(String error) {
    return 'Errore durante l\'avvio del download: $error';
  }

  @override
  String deleteItemsConfirmTitle(int count) {
    return 'Elimina $count elementi selezionati?';
  }

  @override
  String deleteItemsConfirmPrompt(int count) {
    return 'Vuoi davvero eliminare definitivamente $count elementi selezionati dal cloud?';
  }

  @override
  String itemsDeletedSuccess(int count) {
    return '$count elementi eliminati';
  }

  @override
  String errorDeleting(String error) {
    return 'Errore durante l\'eliminazione: $error';
  }

  @override
  String get uploadCompletedSuccess => 'Caricamento completato con successo';

  @override
  String errorUploading(String error) {
    return 'Errore durante il caricamento: $error';
  }

  @override
  String get folderUploadCompletedSuccess =>
      'Caricamento cartella completato con successo';

  @override
  String errorFolderUploading(String error) {
    return 'Errore durante il caricamento della cartella: $error';
  }

  @override
  String get filesAlreadyInDirectory =>
      'I file si trovano già in questa cartella.';

  @override
  String dragDropTransferStarted(String action, int count, String remote) {
    return '$action di $count elementi verso [$remote] avviato...';
  }

  @override
  String errorDragDrop(String error) {
    return 'Errore durante il trasferimento drag-and-drop: $error';
  }

  @override
  String get closeSelection => 'Chiudi selezione';

  @override
  String itemsSelectedCount(int count) {
    return '$count selezionati';
  }

  @override
  String get deselectAll => 'Deseleziona tutti';

  @override
  String copyToRemote(String remote) {
    return 'Copia in $remote';
  }

  @override
  String moveToRemote(String remote) {
    return 'Sposta in $remote';
  }

  @override
  String get moreActions => 'Altre azioni';

  @override
  String get downloadSelected => 'Scarica selezionati';

  @override
  String get copyToClipboard => 'Copia negli appunti';

  @override
  String get cutToClipboard => 'Taglia negli appunti';

  @override
  String get selectCloud => 'Seleziona Cloud';

  @override
  String get closeSearch => 'Chiudi ricerca';

  @override
  String get uploadFromDevice => 'Carica dal dispositivo';

  @override
  String get moreOptions => 'Altre opzioni';

  @override
  String get viewGrid => 'Vista griglia';

  @override
  String get viewList => 'Vista elenco';

  @override
  String get multiSelection => 'Selezione multipla';

  @override
  String get sortNameAsc => 'Nome (A-Z)';

  @override
  String get sortNameDesc => 'Nome (Z-A)';

  @override
  String get sortSizeDesc => 'Dimensione (Grande -> Piccolo)';

  @override
  String get sortSizeAsc => 'Dimensione (Piccolo -> Grande)';

  @override
  String get sortDateDesc => 'Data (Recente prima)';

  @override
  String get disableDualPane => 'Disattiva Commander (Singolo Pannello)';

  @override
  String get enableDualPane => 'Attiva Commander (Due Pannelli)';

  @override
  String itemsInClipboard(int count) {
    return '$count elementi negli appunti';
  }

  @override
  String get pasteHere => 'Incolla qui';

  @override
  String get noResults => 'Nessun risultato';

  @override
  String noMatchingResults(String query) {
    return 'Nessun file o cartella corrisponde a \"$query\"';
  }

  @override
  String get selectACloud => 'Seleziona un Cloud';

  @override
  String get selectCloudDescription =>
      'Seleziona un provider cloud dal menu in alto per visualizzare ed esplorare i tuoi file remoti.';

  @override
  String optionsForItem(String name) {
    return 'Opzioni per $name';
  }

  @override
  String get select => 'Seleziona';

  @override
  String get openWithSystemApp => 'Apri con app di sistema';

  @override
  String get downloadToLocal => 'Scarica in locale';

  @override
  String get cut => 'Taglia (Sposta)';

  @override
  String get copyPath => 'Copia percorso';

  @override
  String get info => 'Informazioni';

  @override
  String generatingShareLink(String name) {
    return 'Generazione del link per \"$name\"...';
  }

  @override
  String errorPublicLink(String error) {
    return 'Errore link pubblico: $error';
  }

  @override
  String get noLinkGenerated => 'Nessun link generato dal provider.';

  @override
  String errorDownloading(String error) {
    return 'Errore durante il download: $error';
  }

  @override
  String get renameFolderTitle => 'Rinomina cartella';

  @override
  String get renameFileTitle => 'Rinomina file';

  @override
  String errorRenaming(String error) {
    return 'Errore ridenominazione: $error';
  }

  @override
  String get pathCopiedToClipboard => 'Percorso copiato negli appunti';

  @override
  String itemDetailsPath(String path) {
    return 'Percorso: $path';
  }

  @override
  String itemDetailsType(String type) {
    return 'Tipo: $type';
  }

  @override
  String itemDetailsSize(String size) {
    return 'Dimensione: $size';
  }

  @override
  String itemDetailsModified(String date) {
    return 'Data modifica: $date';
  }

  @override
  String get folder => 'Cartella';

  @override
  String get file => 'File';

  @override
  String get selectCloudFirstLeft =>
      'Seleziona prima un cloud nel pannello sinistro.';

  @override
  String get selectCloudFirstRight =>
      'Seleziona prima un cloud nel pannello destro.';

  @override
  String get selectDestinationCloudLeft =>
      'Seleziona prima un cloud di destinazione nel pannello sinistro.';

  @override
  String get selectDestinationCloudRight =>
      'Seleziona prima un cloud di destinazione nel pannello destro.';

  @override
  String get noFilesToTransfer =>
      'Nessun file presente o selezionato da trasferire.';

  @override
  String transferStarted(String action, int count, String src, String dst) {
    return '$action di $count elementi da [$src] a [$dst] avviato...';
  }

  @override
  String get swapPanesTooltip => 'Scambia pannelli (<->)';

  @override
  String get refreshBothPanesTooltip => 'Aggiorna entrambi i pannelli';

  @override
  String get copyRight => 'Copia a destra ->';

  @override
  String get moveRight => 'Sposta a destra ->';

  @override
  String get copyLeft => '<- Copia a sinistra';

  @override
  String get moveLeft => '<- Sposta a sinistra';

  @override
  String copyRightWithCount(int count) {
    return 'Copia a destra ($count) ->';
  }

  @override
  String moveRightWithCount(int count) {
    return 'Sposta a destra ($count) ->';
  }

  @override
  String copyLeftWithCount(int count) {
    return '<- Copia a sinistra ($count)';
  }

  @override
  String moveLeftWithCount(int count) {
    return '<- Sposta a sinistra ($count)';
  }

  @override
  String get deleteRuleTitle => 'Elimina Regola';

  @override
  String deleteRulePrompt(String name) {
    return 'Vuoi davvero eliminare la regola di sincronizzazione \"$name\"? I file presenti sia sul dispositivo che sul cloud non verranno cancellati.';
  }

  @override
  String get syncAll => 'Sincronizza Tutte';

  @override
  String get newRuleTooltip => 'Nuova regola';

  @override
  String get backupBannerTitle => 'Backup Continuo & Sincronizzazione Cloud';

  @override
  String get backupBannerSubtitle =>
      'Configura sincronizzazioni pianificate tra cartelle locali e remoti cloud.';

  @override
  String get noActiveRules => 'Nessuna Regola Attiva';

  @override
  String get noActiveRulesSubtitle =>
      'Crea la tua prima regola per eseguire backup automatici dal telefono verso Google Drive, Dropbox, SFTP o qualsiasi altro cloud.';

  @override
  String get createNewRule => 'Crea Nuova Regola';

  @override
  String get ruleOptionsTooltip => 'Opzioni regola';

  @override
  String get syncNow => 'Sincronizza ora';

  @override
  String get statusWaiting => 'In attesa';

  @override
  String get statusInProgress => 'In corso...';

  @override
  String get statusCompleted => 'Completato';

  @override
  String get statusFailed => 'Errore';

  @override
  String get editRuleTitle => 'Modifica Regola di Backup';

  @override
  String get newRuleTitle => 'Nuova Regola di Sincronizzazione';

  @override
  String get ruleDialogSubtitle =>
      'Configura backup automatico tra una cartella locale e il cloud.';

  @override
  String get ruleNameOptional => 'Nome Regola (opzionale)';

  @override
  String get ruleNameHint => 'Es. Backup Foto DCIM o Documenti Lavoro';

  @override
  String get sourceLocalFolder => 'Cartella Locale Sorgente';

  @override
  String get sourceLocalFolderHint =>
      '/storage/emulated/0/DCIM o /home/utente/Pictures';

  @override
  String get browseFolders => 'Sfoglia cartelle';

  @override
  String get selectLocalFolderError =>
      'Inserisci o seleziona una cartella locale';

  @override
  String get noCloudsConfiguredSync =>
      'Nessun cloud configurato. Configura un account cloud dalla Home prima di continuare.';

  @override
  String get remoteDestinationPath => 'Percorso Remoto di Destinazione';

  @override
  String get syncMode => 'Modalità di Sincronizzazione';

  @override
  String get syncModeCopy => 'Backup Incrementale';

  @override
  String get syncModeCopyDesc =>
      'Carica file nuovi e modificati preservando sempre i file già presenti sul cloud.';

  @override
  String get syncModeSync => 'Sincronizzazione Mirror';

  @override
  String get syncModeSyncDesc =>
      'Rende la destinazione remota identica alla cartella locale (i file eliminati localmente vengono rimossi dal cloud).';

  @override
  String get syncFrequency => 'Frequenza di Esecuzione';

  @override
  String get freqManual => 'Manuale (solo su richiesta)';

  @override
  String get freq15Min => 'Ogni 15 minuti';

  @override
  String get freq30Min => 'Ogni 30 minuti';

  @override
  String get freqHourly => 'Ogni ora';

  @override
  String get freq6Hours => 'Ogni 6 ore';

  @override
  String get freq12Hours => 'Ogni 12 ore';

  @override
  String get freqDaily => 'Ogni giorno (24 ore)';

  @override
  String get activateRuleImmediately => 'Attiva regola immediatamente';

  @override
  String get activateRuleImmediatelyDesc =>
      'La sincronizzazione avverrà in background secondo l\'intervallo specificato';

  @override
  String get updateRule => 'Aggiorna';

  @override
  String get saveRule => 'Salva Regola';

  @override
  String get selectCloudProvider => 'Seleziona Provider Cloud:';

  @override
  String get cloudAccountName => 'Nome Account / Alias';

  @override
  String get cloudAccountNameHint =>
      'Es. GoogleDrive, LavoroDropbox (senza spazi)';

  @override
  String get enterNameError => 'Inserisci un nome';

  @override
  String get noSpacesOrColons => 'Non sono ammessi spazi o \":\"';

  @override
  String get oauthMode => 'Modalità Client ID (OAuth2)';

  @override
  String get oauthOfficial => 'UnifyCloud (Ufficiale / Consigliato)';

  @override
  String get oauthRclone => 'Rclone (Sconsigliato - Quota condivisa)';

  @override
  String get oauthCustom => 'Client ID Personale (Avanzato)';

  @override
  String get officialOauthTitle => 'Credenziali Ufficiali UnifyCloud';

  @override
  String get officialOauthDesc =>
      'Credenziali preconfigurate per collegarti immediatamente con quota dedicata e massima velocità.';

  @override
  String get rcloneOauthDesc =>
      'Chiavi open-source condivise di Rclone. Potrebbero incorrere in limiti di quota o errori temporanei 403 Google.';

  @override
  String get customClientId => 'Client ID';

  @override
  String get customClientSecret => 'Client Secret';

  @override
  String get selectVaultDestination =>
      'Seleziona il Cloud di destinazione per il Vault';

  @override
  String get vaultPasswordRequired => 'La password di cifratura è obbligatoria';

  @override
  String get vaultPasswordsDoNotMatch => 'Le password inserite non coincidono';

  @override
  String errorAddingRemote(String error) {
    return 'Errore durante l\'aggiunta del remote: $error';
  }

  @override
  String get fileNameEncryption => 'Cifratura dei Nomi di File';

  @override
  String get encryptStandard =>
      'Standard (Nomi file completamente cifrati - Consigliato)';

  @override
  String get encryptObscure => 'Offuscamento semplice (Conserva le estensioni)';

  @override
  String get encryptOff => 'Disattivata (Nomi visibili in chiaro)';

  @override
  String get encryptFolderNames => 'Cifra anche i nomi delle cartelle';

  @override
  String get encryptFolderNamesDesc =>
      'Nasconde completamente la struttura delle directory sul cloud';

  @override
  String get connectCloud => 'Connetti Cloud';

  @override
  String get reopenAuth => 'Riapri';

  @override
  String get linkCopiedToClipboard => 'Link copiato negli appunti!';

  @override
  String errorOpenBrowserGeneric(String error) {
    return 'Impossibile aprire il browser: $error';
  }

  @override
  String get shareableLinkTitle => 'Link Condivisibile';

  @override
  String shareLinkAccessDescription(String item) {
    return 'Chiunque abbia questo link potrà accedere a $item:';
  }

  @override
  String get open => 'Apri';

  @override
  String activeTransfersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count trasferimenti attivi',
      one: '1 trasferimento attivo',
    );
    return '$_temp0';
  }

  @override
  String transfersQueueCount(int count) {
    return 'Coda Trasferimenti ($count)';
  }

  @override
  String get noTransfersInProgress => 'Nessun trasferimento in corso';

  @override
  String get transfersEmptySubtitle =>
      'Tutti i file scaricati o caricati appariranno qui';

  @override
  String get cancelled => 'Annullato';

  @override
  String get appLockedTitle => 'Applicazione bloccata';

  @override
  String get unlockWithBiometrics => 'Sblocca con Biometria';

  @override
  String get pinMustBe6Digits => 'Il PIN deve avere esattamente 6 cifre';

  @override
  String get pinIncorrect => 'Codice PIN errato. Riprova.';

  @override
  String get pinsDoNotMatch => 'I codici PIN non corrispondono. Riprova.';

  @override
  String get pinStepOld =>
      'Inserisci il tuo codice PIN attuale per continuare.';

  @override
  String get pinStepNew => 'Inserisci il nuovo codice PIN a 6 cifre.';

  @override
  String get pinStepConfirm =>
      'Digita nuovamente il nuovo PIN per confermarlo.';

  @override
  String get pinStepVerify =>
      'Inserisci il tuo codice PIN per confermare l\'operazione.';

  @override
  String get pinTitleSetup => 'Imposta PIN di Sicurezza';

  @override
  String get pinTitleChange => 'Modifica PIN di Sicurezza';

  @override
  String get pinTitleVerify => 'Verifica di Sicurezza';

  @override
  String get pinContinue => 'Continua';

  @override
  String get errorDetails => 'Dettagli Errore';

  @override
  String get errorDetailsCopied => 'Dettagli errore copiati negli appunti';

  @override
  String get collapse => 'Comprimi';

  @override
  String get expand => 'Espandi';

  @override
  String get copyError => 'Copia errore';

  @override
  String get errorNetwork =>
      'Connessione assente o instabile. Verifica la rete internet e riprova.';

  @override
  String get errorDiskSpace =>
      'Spazio di archiviazione insufficiente o disco pieno. Libera memoria per continuare.';

  @override
  String get errorAuthExpired =>
      'Sessione o token scaduto/revocato. Riconnetti il tuo account.';

  @override
  String get errorNotFound =>
      'Elemento o cartella non trovata sul provider cloud.';

  @override
  String get errorPermissionDenied =>
      'Permesso negato per eseguire questa operazione sul cloud.';

  @override
  String get errorGeneric => 'Si è verificato un errore durante l\'operazione.';

  @override
  String get desktopAndSystem => 'Desktop & Sistema';

  @override
  String get desktopAndSystemSubtitle =>
      'Avvio automatico, esecuzione in background e vassoio di sistema';

  @override
  String get autostartOnBoot => 'Avvia all\'avvio del sistema';

  @override
  String get autostartOnBootSubtitle =>
      'Avvia automaticamente UnifyCloud in background all\'accesso';

  @override
  String get minimizeToTray => 'Riduci nel vassoio di sistema';

  @override
  String get minimizeToTraySubtitle =>
      'Mantieni UnifyCloud attivo in background alla chiusura della finestra';

  @override
  String get trayStatusIdle => 'Inattivo (Nessun trasferimento)';

  @override
  String trayStatusActive(int count, String speed) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count trasferimenti attivi ($speed)',
      one: '1 trasferimento attivo ($speed)',
    );
    return '$_temp0';
  }

  @override
  String get trayShowWindow => 'Mostra UnifyCloud';

  @override
  String get trayHideWindow => 'Riduci nel vassoio';

  @override
  String get trayQuit => 'Esci da UnifyCloud';

  @override
  String get trayTooltip => 'UnifyCloud - Gestore Cloud';

  @override
  String trayStatusLine(String status) {
    return 'Stato: $status';
  }

  @override
  String get bgNotificationInitialTitle => 'UnifyCloud Trasferimenti';

  @override
  String get bgNotificationInitialContent =>
      'Gestione trasferimenti in background...';

  @override
  String bgNotificationProgressContent(String speed, int percentage) {
    return '$speed • $percentage% completato';
  }

  @override
  String get bgNotificationIdleContent =>
      'Tutti i trasferimenti sono stati completati.';

  @override
  String get pinTitleConfirm => 'Conferma Codice PIN';

  @override
  String get pinTitleEnterCurrent => 'Inserisci PIN Attuale';

  @override
  String get pinTitleNew => 'Nuovo Codice PIN';

  @override
  String get pinTitleConfirmNew => 'Conferma Nuovo PIN';

  @override
  String get pinStepSetupNew =>
      'Crea un codice numerico a 6 cifre per proteggere l\'app.';

  @override
  String get pinStepSetupConfirm =>
      'Digita nuovamente il codice PIN per confermarlo.';

  @override
  String pinTooManyAttempts(int seconds) {
    return 'Troppi tentativi falliti. Riprova tra ${seconds}s.';
  }

  @override
  String pinVerificationError(String error) {
    return 'Errore durante la verifica: $error';
  }

  @override
  String get biometricAuthReason => 'Autenticati per accedere a UnifyCloud';

  @override
  String syncRulesCount(int count) {
    return 'Regole di Sincronizzazione ($count)';
  }

  @override
  String get noSyncRulesEmptyDesc =>
      'Configura una regola per eseguire il backup automatico a intervalli regolari o su richiesta con il pulsante \"Sincronizza ora\".';

  @override
  String get neverSynced => 'Mai sincronizzato';

  @override
  String get lastSyncNow => 'Ultima sinc: adesso';

  @override
  String lastSyncMinutesAgo(int minutes) {
    return 'Ultima sinc: $minutes minuti fa';
  }

  @override
  String lastSyncHoursAgo(int hours) {
    return 'Ultima sinc: $hours ore fa';
  }

  @override
  String lastSyncDate(String date) {
    return 'Ultima sinc: $date';
  }

  @override
  String localFolderNotFound(String path) {
    return 'Cartella locale non trovata: $path';
  }

  @override
  String get selectDestinationCloudError =>
      'Seleziona un cloud di destinazione';

  @override
  String get remoteDestinationPathHint => 'Backup/Foto o /';

  @override
  String get enterDestinationPathError =>
      'Inserisci un percorso di destinazione';

  @override
  String get activateRuleManualOnlyDesc =>
      'Se disattivata, la regola potrà essere avviata solo manualmente.';

  @override
  String get presetPhotosDcim => 'Foto (DCIM)';

  @override
  String get presetPictures => 'Immagini';

  @override
  String get presetDocuments => 'Documenti';

  @override
  String get presetDownloads => 'Download';

  @override
  String defaultBackupRuleName(String name) {
    return 'Backup $name';
  }

  @override
  String defaultSyncRuleName(String name) {
    return 'Sincronizzazione $name';
  }

  @override
  String get folderFallbackName => 'Cartella';

  @override
  String get providerLocalName => 'Disco Locale';

  @override
  String get providerCryptName => 'Crittografia E2E (Crypt)';

  @override
  String get providerSubtitleDrive => 'Archiviazione cloud OAuth2';

  @override
  String get providerSubtitleDropbox => 'Sincronizzazione e condivisione file';

  @override
  String get providerSubtitleOneDrive => 'Archiviazione personale e aziendale';

  @override
  String get providerSubtitleWebdav => 'Cloud self-hosted o aziendale';

  @override
  String get providerSubtitleSftp => 'Server remoto sicuro';

  @override
  String get providerSubtitleS3 => 'Bucket object storage';

  @override
  String get providerSubtitleLocal => 'Cartella locale di sistema';

  @override
  String get providerSubtitleCrypt =>
      'Crittografa file e nomi con AES-256 su qualsiasi cloud';

  @override
  String get noUnifyCloudClientId =>
      'Nessun Client ID UnifyCloud disponibile per questo provider. Usa Rclone o un Client ID personale.';

  @override
  String get noRcloneClientId =>
      'Nessun Client ID di Rclone disponibile per questo provider. Usa un Client ID personale.';

  @override
  String get enterClientIdForOauth =>
      'Inserisci il Client ID per avviare il login OAuth2';

  @override
  String get oauthStartingLocalServer =>
      'Avvio del server locale per l\'accesso...';

  @override
  String get oauthBrowserOpened =>
      'Browser aperto. In attesa di autorizzazione...';

  @override
  String get oauthBrowserNotSupported =>
      'Apertura automatica non supportata. Apri o copia il link sottostante nel tuo browser:';

  @override
  String get oauthCompletedSuccess => 'Autenticazione completata con successo!';

  @override
  String oauthErrorPrefix(String error) {
    return 'Errore OAuth: $error';
  }

  @override
  String get officialOauthActionDesc =>
      'Accesso rapido verificato con credenziali dedicate per UnifyCloud. Clicca su \"Avvia Accesso nel Browser\" per autenticarti senza configurazioni manuali.';

  @override
  String get rcloneOauthTitle => 'Client ID Pubblico di Rclone (Sconsigliato)';

  @override
  String get rcloneOauthWarningDesc =>
      'Usa le chiavi pubbliche storiche condivise con tutti gli utenti di Rclone. Potrebbero verificarsi rallentamenti o blocchi aziendali dovuti alle quote condivise.';

  @override
  String get customOauthGuideInfo =>
      'Crea i tuoi ID in autonomia: consulta docs/oauth_setup_guide.md per la guida passo-passo.';

  @override
  String get customGoogleClientIdLabel => 'Client ID Personale Google';

  @override
  String get customOauthClientIdLabel => 'Client ID Personale (OAuth2)';

  @override
  String get customGoogleClientIdHint => 'Es. xxxxx.apps.googleusercontent.com';

  @override
  String get enterYourClientIdError => 'Inserisci il tuo Client ID';

  @override
  String get customClientSecretOptional => 'Client Secret (Opzionale)';

  @override
  String get authenticating => 'Autenticazione in corso...';

  @override
  String get startBrowserLogin => 'Avvia Accesso nel Browser (OAuth2)';

  @override
  String get browserLaunchedOrCopy =>
      'Browser avviato (oppure copia il link qui sotto)';

  @override
  String get copyLinkToCompleteLogin =>
      'Copia il link per completare l\'accesso nel tuo browser';

  @override
  String get copyLinkAndPasteHint =>
      'Link copiato negli appunti! Incollalo nel tuo browser.';

  @override
  String get tokenJsonLabel => 'Token JSON (generato o incollato)';

  @override
  String get webdavUrlLabel => 'URL WebDAV / Nextcloud';

  @override
  String get s3EndpointLabel => 'Endpoint S3';

  @override
  String get sftpHostLabel => 'Host / Server SFTP';

  @override
  String get requiredFieldError => 'Campo obbligatorio';

  @override
  String get s3AccessKeyId => 'Access Key ID';

  @override
  String get usernameLabel => 'Username';

  @override
  String get s3SecretAccessKey => 'Secret Access Key';

  @override
  String get passwordLabel => 'Password';

  @override
  String get localProviderInfo =>
      'Il provider locale consente di sfogliare ed effettuare copie verso/dal filesystem del dispositivo.';

  @override
  String get e2eEncryptionTitle =>
      'Crittografia End-to-End Client-Side (AES-256)';

  @override
  String get e2eEncryptionDesc =>
      'I file e i loro nomi vengono crittografati sul tuo dispositivo prima di essere inviati al cloud di destinazione. Nemmeno il provider del cloud potrà leggerli.';

  @override
  String get noTargetCloudForVault =>
      'Nessun cloud di destinazione disponibile. Collega prima un altro cloud (es. Google Drive, OneDrive, o Disco Locale) su cui creare il Vault cifrato.';

  @override
  String get vaultTargetCloudLabel => 'Cloud di destinazione *';

  @override
  String get vaultTargetCloudHelper =>
      'Il cloud dove verranno archiviati i file cifrati';

  @override
  String get vaultTargetPathLabel => 'Percorso o Cartella di destinazione';

  @override
  String get vaultTargetPathHint => 'es. vault o secret_data';

  @override
  String get vaultTargetPathHelper =>
      'Cartella sul cloud remoto in cui salvare i file cifrati (opzionale)';

  @override
  String get vaultMasterPasswordLabel =>
      'Password di Cifratura (Password Principale) *';

  @override
  String get vaultMasterPasswordHelper =>
      'Conservala con cura: senza password non sarà possibile recuperare i file';

  @override
  String get vaultEnterPasswordError => 'Inserisci la password di cifratura';

  @override
  String get vaultConfirmPasswordRequired => 'Conferma Password *';

  @override
  String get vaultConfirmPasswordError => 'Conferma la password';

  @override
  String get vaultSaltOptionalLabel => 'Salt / Password Secondaria (Opzionale)';

  @override
  String get vaultSaltHelper =>
      'Aggiunge ulteriore sicurezza contro attacchi brute-force';

  @override
  String oauthPortOccupied(int port) {
    return 'La porta $port è già occupata da un altro processo. Chiudi eventuali sessioni Rclone o browser aperte e riprova.';
  }

  @override
  String get oauthHtmlSuccessTitle => 'UnifyCloud - Autenticato';

  @override
  String get oauthHtmlSuccessHeading => 'Autenticazione riuscita!';

  @override
  String get oauthHtmlSuccessBody =>
      'Puoi chiudere questa scheda e tornare all\'applicazione UnifyCloud.';

  @override
  String get oauthHtmlErrorTitle => 'UnifyCloud - Errore';

  @override
  String get oauthHtmlErrorHeading => 'Errore di autenticazione';

  @override
  String get oauthInvalidState => 'Parametro state OAuth non valido.';

  @override
  String get oauthInvalidCode => 'Codice di autorizzazione non valido.';

  @override
  String get folderDownloadUnsupported =>
      'Il download diretto delle cartelle non è supportato. Seleziona singoli file.';

  @override
  String downloadingSingleItem(String name) {
    return 'Download avviato per \"$name\"...';
  }

  @override
  String downloadingMultipleItems(int count) {
    return 'Avvio download per $count file...';
  }

  @override
  String filesAddedToDownloadQueue(int count) {
    return '$count file aggiunti alla coda di download.';
  }

  @override
  String filesAddedToDownloadQueueWithSkipped(int count, int dirs) {
    return '$count file aggiunti alla coda di download ($dirs cartelle escluse).';
  }

  @override
  String get deleteSingleFolderTitle => 'Elimina cartella?';

  @override
  String get deleteSingleFileTitle => 'Elimina file?';

  @override
  String deleteSingleItemPrompt(String name) {
    return 'Sei sicuro di voler eliminare definitivamente \"$name\"?';
  }

  @override
  String get itemDeletedSuccess => 'Elemento eliminato';

  @override
  String get sortDateAsc => 'Data (Meno recente prima)';

  @override
  String get sortByTooltip => 'Ordina per';

  @override
  String filesAddedToUploadQueue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count file aggiunti alla coda di caricamento',
      one: '1 file aggiunto alla coda di caricamento',
    );
    return '$_temp0';
  }

  @override
  String folderAddedToUploadQueue(int count) {
    return 'Cartella aggiunta al caricamento ($count file in coda)';
  }

  @override
  String dragDropInProgress(String action, int count, String src, String dst) {
    return '$action di $count elementi da [$src] a [$dst] in corso...';
  }

  @override
  String get copySelected => 'Copia selezionati';

  @override
  String get cutSelected => 'Taglia selezionati';

  @override
  String get searchFilesHint => 'Cerca file o cartelle...';

  @override
  String get e2eActiveTooltip =>
      'Crittografia End-to-End attiva (AES-256)\nFile e cartelle cifrati client-side';

  @override
  String get disableDualPaneTooltip => 'Disattiva doppio pannello';

  @override
  String get enableDualPaneTooltip => 'Attiva doppio pannello (Commander)';

  @override
  String dropToCopyTo(String remote) {
    return 'Rilascia per copiare in [$remote]';
  }

  @override
  String get destinationFallback => 'destinazione';

  @override
  String clipboardBannerSingle(String action, String name, String remote) {
    return '$action: \"$name\" da [$remote]';
  }

  @override
  String clipboardBannerMultiple(String action, int count, String remote) {
    return '$action: $count elementi da [$remote]';
  }

  @override
  String transferStartedSingle(String name) {
    return 'Trasferimento avviato per \"$name\"';
  }

  @override
  String transfersStartedCount(int count) {
    return '$count trasferimenti avviati';
  }

  @override
  String get noCloudSelectedTitle => 'Nessun Cloud Selezionato';

  @override
  String get noCloudSelectedSubtitle => 'Seleziona un cloud dal menu in alto.';

  @override
  String loadingFilesFromRemote(String remote) {
    return 'Caricamento file da $remote...';
  }

  @override
  String loadingFolder(String folder) {
    return 'Caricamento $folder...';
  }

  @override
  String get readingDirectory => 'Lettura directory in corso...';

  @override
  String downloadStartedSavedTo(String path) {
    return 'Download avviato: salvataggio in $path';
  }

  @override
  String get noCloudSelected => 'Nessun cloud selezionato.';

  @override
  String get noLinkReturnedByProvider => 'Nessun link restituito dal provider.';

  @override
  String get publicLinksNotSupported =>
      'Questo provider cloud non supporta la creazione di link pubblici.';

  @override
  String errorCreatingShareLink(String error) {
    return 'Errore durante la creazione del link: $error';
  }

  @override
  String get newNameLabel => 'Nuovo nome';

  @override
  String itemDetailsSizeWithBytes(String size, int bytes) {
    return 'Dimensione: $size ($bytes bytes)';
  }

  @override
  String get shareLinkAccessFile =>
      'Chiunque abbia questo link potrà accedere a questo file:';

  @override
  String get shareLinkAccessFolder =>
      'Chiunque abbia questo link potrà accedere a questa cartella:';

  @override
  String get invalidUrlOrBrowser =>
      'URL non valido o impossibile aprire il browser.';

  @override
  String noAppToOpenFile(String name) {
    return 'Nessuna applicazione installata per aprire \"$name\".';
  }

  @override
  String get permissionDeniedOpenFile =>
      'Permesso negato per aprire il file con l\'app di sistema.';

  @override
  String get noDefaultAppFound =>
      'Nessuna applicazione predefinita trovata per aprire questo file.';

  @override
  String unableToOpenFile(String error) {
    return 'Impossibile aprire il file: $error';
  }

  @override
  String downloadingForExternalOpen(String name) {
    return 'Download di \"$name\" per apertura esterna...';
  }

  @override
  String errorOpeningFile(String error) {
    return 'Errore durante l\'apertura del file: $error';
  }

  @override
  String get selectFilesToUpload => 'Seleziona i file da caricare nel Cloud';

  @override
  String get selectFolderToUpload =>
      'Seleziona la cartella da caricare nel Cloud';

  @override
  String get copyRightCompact => 'Copia ->';

  @override
  String copyRightCountCompact(int count) {
    return 'Copia ($count) ->';
  }

  @override
  String get moveRightCompact => 'Sposta ->';

  @override
  String moveRightCountCompact(int count) {
    return 'Sposta ($count) ->';
  }

  @override
  String get copyLeftCompact => '<- Copia';

  @override
  String copyLeftCountCompact(int count) {
    return '<- Copia ($count)';
  }

  @override
  String get moveLeftCompact => '<- Sposta';

  @override
  String moveLeftCountCompact(int count) {
    return '<- Sposta ($count)';
  }

  @override
  String get clear => 'Pulisci';

  @override
  String get noRecentTransfers => 'Nessun trasferimento recente';

  @override
  String get recentTransfersSubtitle =>
      'I download, gli upload e le copie cloud appariranno qui.';

  @override
  String completedWithProgress(String progress) {
    return 'Completato • $progress';
  }

  @override
  String transferFailedError(String error) {
    return 'Errore: $error';
  }

  @override
  String get transferFailedFallback => 'Trasferimento fallito';

  @override
  String get cancelledByUser => 'Annullato dall\'utente';

  @override
  String get localLocation => 'Locale';

  @override
  String get moveToBadge => 'Sposta in';

  @override
  String get copyToBadge => 'Copia in';

  @override
  String get copiedExclamation => 'Copiato!';

  @override
  String get running => 'In corso';

  @override
  String get uploadChooseTypePrompt => 'Scegli cosa vuoi caricare:';

  @override
  String get longPressActionTitle => 'Azione pressione prolungata';

  @override
  String get longPressActionSelect => 'Seleziona';

  @override
  String get longPressActionSelectDesc =>
      'Tenendo premuto un elemento si attiva o modifica la selezione multipla.';

  @override
  String get longPressActionMove => 'Sposta (Trascina)';

  @override
  String get longPressActionMoveDesc =>
      'Tenendo premuto un elemento puoi trascinarlo in una cartella o nell\'altro pannello per spostarlo.';

  @override
  String get longPressActionMenu => 'Menu azioni';

  @override
  String get longPressActionMenuDesc =>
      'Tenendo premuto un elemento si apre il menu delle azioni (apri, scarica, rinomina, elimina).';

  @override
  String get longPressActionCut => 'Taglia';

  @override
  String get longPressActionCutDesc =>
      'Tenendo premuto un elemento lo si taglia negli appunti per spostarlo incollandolo altrove.';

  @override
  String get pinnedFavorites => 'Preferiti';

  @override
  String get noPinnedFavoritesHint =>
      'Fissa file o cartelle da Explorer per averli qui.';

  @override
  String get pinToHome => 'Fissa sulla Home';

  @override
  String get unpinFromHome => 'Rimuovi dalla Home';

  @override
  String pinnedToHomeFeedback(String name) {
    return '\"$name\" fissato sulla Home';
  }

  @override
  String unpinnedFromHomeFeedback(String name) {
    return '\"$name\" rimosso dalla Home';
  }

  @override
  String get openContainingFolder => 'Apri cartella in Explorer';

  @override
  String remoteNotConnected(String remote) {
    return 'Il cloud \"$remote\" non è più collegato';
  }

  @override
  String get androidStoragePermissionTitle =>
      'Accesso a tutti i file richiesto';

  @override
  String get androidStoragePermissionDesc =>
      'Android nasconde i file locali finché non concedi l\'\"Accesso a tutti i file\" a UnifyCloud. Le cartelle sono visibili, ma i file non vengono mostrati.';

  @override
  String get grantPermission => 'Consenti';
}
