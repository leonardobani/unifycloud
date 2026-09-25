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
  String get appVersion => 'Versione App: 1.0.0';

  @override
  String get developerInfo => 'Sviluppatore: LeoRise (@leorise25)';

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
}
