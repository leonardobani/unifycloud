// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'UnifyCloud';

  @override
  String get home => 'Accueil';

  @override
  String get explorer => 'Explorateur';

  @override
  String get sync => 'Synchronisation';

  @override
  String get settings => 'Paramètres';

  @override
  String get cancel => 'Annuler';

  @override
  String get confirm => 'Confirmer';

  @override
  String get delete => 'Supprimer';

  @override
  String get save => 'Enregistrer';

  @override
  String get close => 'Fermer';

  @override
  String get edit => 'Modifier';

  @override
  String get create => 'Créer';

  @override
  String get retry => 'Réessayer';

  @override
  String get copy => 'Copier';

  @override
  String get move => 'Déplacer';

  @override
  String get rename => 'Renommer';

  @override
  String get download => 'Télécharger';

  @override
  String get upload => 'Téléverser';

  @override
  String get share => 'Partager';

  @override
  String get details => 'Détails';

  @override
  String get search => 'Rechercher';

  @override
  String get change => 'Changer';

  @override
  String get reset => 'Réinitialiser';

  @override
  String get done => 'Terminé';

  @override
  String get loading => 'Chargement...';

  @override
  String get success => 'Opération terminée';

  @override
  String get error => 'Erreur';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get resetDefaultsTooltip => 'Rétablir les paramètres par défaut';

  @override
  String get resetDialogTitle => 'Réinitialiser les paramètres';

  @override
  String get resetDialogContent =>
      'Voulez-vous réinitialiser toutes les préférences (thème, langue, dossiers, affichage) aux valeurs d\'usine ?';

  @override
  String get resetSuccessSnackbar =>
      'Paramètres restaurés aux valeurs par défaut';

  @override
  String get appearanceAndTheme => 'Apparence et thème';

  @override
  String get chooseVisualThemeSubtitle =>
      'Choisissez le thème visuel pour l\'interface d\'UnifyCloud :';

  @override
  String get themeSystem => 'Système';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get language => 'Langue';

  @override
  String get languageSubtitle => 'Sélectionner la langue de l\'interface';

  @override
  String get langEnglish => 'English';

  @override
  String get langItalian => 'Italiano';

  @override
  String get langSystem => 'Par défaut du système';

  @override
  String get filesAndExploration => 'Fichiers et exploration';

  @override
  String get showHiddenFiles => 'Afficher les fichiers masqués';

  @override
  String get showHiddenFilesSubtitle =>
      'Afficher les fichiers et dossiers commençant par un point';

  @override
  String get confirmBeforeDelete => 'Confirmer avant de supprimer';

  @override
  String get confirmBeforeDeleteSubtitle =>
      'Demander confirmation avant de supprimer définitivement des fichiers';

  @override
  String get defaultDownloadFolder => 'Dossier de téléchargement par défaut';

  @override
  String get defaultDownloadFolderSystem =>
      'Répertoire de téléchargement système par défaut';

  @override
  String get restoreDefaultPath => 'Restaurer le chemin par défaut';

  @override
  String get customDownloadFolderDialogPrompt =>
      'Sélectionnez un dossier à l\'aide du sélecteur système ou saisissez le chemin souhaité :';

  @override
  String get folderPath => 'Chemin du dossier';

  @override
  String get folderPathHint => 'ex. /home/utilisateur/Téléchargements';

  @override
  String get browseWithSystemPicker => 'Parcourir avec le sélecteur système';

  @override
  String errorOpenPicker(String error) {
    return 'Impossible d\'ouvrir le sélecteur système : $error';
  }

  @override
  String get restoreDefault => 'Rétablir par défaut';

  @override
  String get maxConcurrentTransfers => 'Transferts simultanés';

  @override
  String get maxConcurrentTransfersSubtitle =>
      'Nombre maximal de transferts de fichiers simultanés';

  @override
  String get dualPaneMode => 'Mode Commander (Double panneau)';

  @override
  String get dualPaneModeSubtitle =>
      'Afficher deux panneaux côte à côte sur les grands écrans et tablettes';

  @override
  String get communityAndSupport => 'Communauté et assistance';

  @override
  String get openSourceDescription =>
      'UnifyCloud est un logiciel libre et open-source conçu pour unifier vos données cloud sans traceurs ni intermédiaires propriétaires.';

  @override
  String get supportDeveloper => 'Soutenir le développeur';

  @override
  String get supportDeveloperSubtitle =>
      'Offrez un café pour soutenir le développement indépendant';

  @override
  String get viewSourceOnGitLab => 'Voir le code sur GitLab';

  @override
  String get viewSourceOnGitLabSubtitle =>
      'Dépôt officiel, signalement de bugs et contributions';

  @override
  String errorOpenBrowser(String url) {
    return 'Impossible d\'ouvrir le navigateur. Dépôt : $url';
  }

  @override
  String get supportDialogTitle => 'Soutenir UnifyCloud';

  @override
  String get supportDialogDescription1 =>
      'UnifyCloud est un projet gratuit et open source conçu pour vous donner le contrôle total sur vos fichiers cloud.';

  @override
  String get supportDialogDescription2 =>
      'Si vous trouvez cette application utile, offrez un café ou faites un don pour soutenir la maintenance et les nouvelles fonctionnalités !';

  @override
  String get supportKofiTitle => 'Offrir un café sur Ko-fi';

  @override
  String get supportLiberapayTitle => 'Faire un don sur Liberapay';

  @override
  String get supportPaypalTitle => 'Faire un don via PayPal';

  @override
  String get securityAndEncryption => 'Sécurité et chiffrement';

  @override
  String get securityArchitectureDescription =>
      'UnifyCloud utilise une architecture Zéro Texte Clair. Tous les jetons OAuth et identifiants sont protégés dans le Keychain/Keystore système et injectés exclusivement dans la mémoire RAM du moteur Go.';

  @override
  String get appLock => 'Verrouillage de l\'application (PIN / Biométrie)';

  @override
  String get appLockSubtitle =>
      'Exiger un code PIN ou une empreinte pour accéder';

  @override
  String get appLockActiveSubtitle => 'Actif au démarrage et après inactivité';

  @override
  String get appLockEnabledSnackbar =>
      'Verrouillage de l\'application activé avec succès';

  @override
  String get appLockDisabledSnackbar =>
      'Verrouillage de l\'application désactivé';

  @override
  String get changePin => 'Modifier le code PIN';

  @override
  String get changePinSubtitle => 'Définir un nouveau code PIN à 6 chiffres';

  @override
  String get pinChangedSnackbar =>
      'Code PIN de sécurité mis à jour avec succès';

  @override
  String get biometricAuth => 'Authentification biométrique';

  @override
  String get biometricAuthSubtitle =>
      'Utiliser l\'empreinte digitale ou le capteur biométrique si disponible';

  @override
  String get biometricNotAvailable =>
      'Non disponible ou non configuré sur cet appareil';

  @override
  String get autoLock => 'Verrouillage automatique';

  @override
  String get autoLockSubtitle =>
      'Délai d\'inactivité en arrière-plan avant le verrouillage';

  @override
  String get lockImmediately => 'Immédiatement';

  @override
  String get lockAfter1Minute => 'Après 1 minute';

  @override
  String get lockAfter5Minutes => 'Après 5 minutes';

  @override
  String get lockAfter15Minutes => 'Après 15 minutes';

  @override
  String get lockAfter30Minutes => 'Après 30 minutes';

  @override
  String get syncCloudAccounts => 'Synchroniser les comptes cloud';

  @override
  String get syncCloudAccountsSubtitle =>
      'Recharger les configurations depuis le stockage sécurisé';

  @override
  String get syncCloudAccountsSuccess => 'Comptes cloud rechargés avec succès';

  @override
  String get clearAllCredentials => 'Effacer tous les identifiants';

  @override
  String get clearAllCredentialsSubtitle =>
      'Supprime la configuration chiffrée et déconnecte tous les clouds';

  @override
  String get clearCredentialsDialogTitle =>
      'Avertissement : Réinitialisation des identifiants';

  @override
  String get clearCredentialsDialogContent =>
      'Êtes-vous sûr de vouloir supprimer tous les identifiants enregistrés ? Vous devrez reconnecter vos comptes cloud.';

  @override
  String get clearCredentialsSuccess => 'Identifiants supprimés avec succès';

  @override
  String get aboutUnifyCloud => 'À propos d\'UnifyCloud';

  @override
  String get appVersion => 'Version de l\'application : 1.0.0';

  @override
  String get developerInfo => 'Développeur : LeoRise (@leorise25)';

  @override
  String get engineInfo => 'Moteur : Rclone Core CGO (Go v1.22+ / C FFI)';

  @override
  String get frameworkInfo => 'Framework : Flutter (Material 3 Responsive)';

  @override
  String get licenseInfo =>
      'Licence : GNU General Public License v3.0 (GPL-3.0)';

  @override
  String get copyrightInfo => 'Copyright : © 2026 Leonardo Bani';

  @override
  String get storageOverview => 'Aperçu du stockage';

  @override
  String get connectedClouds => 'Clouds connectés';

  @override
  String get noCloudsConfigured => 'Aucun compte cloud configuré';

  @override
  String get noCloudsDescription =>
      'Connectez votre premier compte cloud pour commencer à gérer et synchroniser vos fichiers.';

  @override
  String get addCloud => 'Ajouter un cloud';

  @override
  String get used => 'utilisé';

  @override
  String get free => 'libre';

  @override
  String get total => 'total';

  @override
  String get manageAccounts => 'Gérer les comptes';

  @override
  String get viewFiles => 'Voir les fichiers';

  @override
  String get createVaultHere => 'Créer un coffre chiffré ici...';

  @override
  String get disconnectAccount => 'Déconnecter le compte';

  @override
  String get disconnectConfirmTitle => 'Déconnecter le compte ?';

  @override
  String get disconnectConfirmContent =>
      'Êtes-vous sûr de vouloir déconnecter ce compte ? Les fichiers distants resteront intacts.';

  @override
  String get allFiles => 'Tous les fichiers';

  @override
  String get emptyFolder => 'Ce dossier est vide';

  @override
  String get emptyFolderSubtitle =>
      'Téléversez des fichiers ou créez un sous-dossier pour commencer.';

  @override
  String get uploadFile => 'Téléverser un fichier';

  @override
  String get uploadFolder => 'Téléverser tout un dossier';

  @override
  String get newFolder => 'Nouveau dossier';

  @override
  String get newFolderPrompt => 'Saisissez le nom du nouveau dossier :';

  @override
  String get folderNameHint => 'Nom du dossier';

  @override
  String get selectAll => 'Tout sélectionner';

  @override
  String get clearSelection => 'Désélectionner';

  @override
  String get deleteSelected => 'Supprimer la sélection';

  @override
  String get deleteSelectedPrompt =>
      'Êtes-vous sûr de vouloir supprimer les éléments sélectionnés ?';

  @override
  String get deleteItemPrompt =>
      'Êtes-vous sûr de vouloir supprimer cet élément ?';

  @override
  String get shareLink => 'Partager le lien';

  @override
  String get createShareLink => 'Créer un lien de partage';

  @override
  String get copyShareLink => 'Copier le lien';

  @override
  String get copiedToClipboard => 'Copié dans le presse-papiers';

  @override
  String get transfers => 'Transferts';

  @override
  String get activeTransfers => 'Transferts actifs';

  @override
  String get completed => 'Terminé';

  @override
  String get failed => 'Échoué';

  @override
  String get queued => 'En file d\'attente';

  @override
  String get cancelTransfer => 'Annuler le transfert';

  @override
  String get clearCompleted => 'Effacer les terminés';

  @override
  String get syncRulesTitle => 'Règles de sauvegarde et sync';

  @override
  String get newRule => 'Nouvelle règle';

  @override
  String get noSyncRules => 'Aucune règle de synchronisation configurée';

  @override
  String get noSyncRulesSubtitle =>
      'Créez une règle automatique pour synchroniser des dossiers locaux avec votre cloud.';

  @override
  String get ruleName => 'Nom de la règle';

  @override
  String get sourcePath => 'Dossier source';

  @override
  String get destinationCloud => 'Cloud de destination';

  @override
  String get destinationPath => 'Chemin distant';

  @override
  String get direction => 'Direction';

  @override
  String get frequency => 'Fréquence';

  @override
  String get runNow => 'Exécuter maintenant';

  @override
  String get syncInProgress => 'Synchronisation en cours...';

  @override
  String get syncSuccess => 'Synchronisation terminée';

  @override
  String get syncFailed => 'Échec de la synchronisation';

  @override
  String get addCloudDialogTitle => 'Connecter un nouveau cloud';

  @override
  String get selectProvider => 'Sélectionner le fournisseur cloud';

  @override
  String get accountNameLabel => 'Nom du compte / Alias';

  @override
  String get connectButton => 'Connecter le compte';

  @override
  String get vaultTitle => 'Chiffrement E2E (Crypt)';

  @override
  String get vaultPassword => 'Mot de passe du coffre';

  @override
  String get vaultConfirmPassword => 'Confirmer le mot de passe';

  @override
  String get vaultSalt => 'Salt / Mot de passe secondaire (Facultatif)';

  @override
  String get encryptFileNames => 'Chiffrer les noms de fichiers';

  @override
  String get encryptDirNames => 'Chiffrer les noms de dossiers';

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
  String get selectLanguage => 'Choisir la langue';

  @override
  String get searchLanguageHint => 'Rechercher une langue ou un pays...';

  @override
  String get currentLanguage => 'Langue actuelle';

  @override
  String systemDefaultWithLocale(String locale) {
    return 'Par défaut du système ($locale)';
  }

  @override
  String get refreshCloudsTooltip => 'Actualiser les clouds configurés';

  @override
  String get storageOverviewAggregated => 'Aperçu global du stockage';

  @override
  String get ramEncryptionActive => 'Chiffrement RAM actif';

  @override
  String connectedAccountsCount(int count) {
    return 'Comptes cloud connectés : $count';
  }

  @override
  String get noCloudsConfiguredHint =>
      'Aucun compte cloud configuré. Appuyez sur « + Connecter un nouveau cloud » ci-dessous.';

  @override
  String percentUsed(String percent) {
    return '$percent% utilisé';
  }

  @override
  String availableSpace(String space) {
    return '$space disponibles';
  }

  @override
  String get calculatingQuota =>
      'Calcul du quota de stockage en cours ou espace illimité...';

  @override
  String get syncAndBackup => 'Synchronisation et sauvegarde';

  @override
  String get noRulesConfigured => 'Aucune règle configurée';

  @override
  String activeRulesCount(int active, int total) {
    return '$active/$total règles actives';
  }

  @override
  String get manage => 'Gérer';

  @override
  String connectedCloudsCount(int count) {
    return 'Clouds connectés ($count)';
  }

  @override
  String get connectNewCloud => 'Connecter un nouveau cloud';

  @override
  String get noCloudProvidersConnected => 'Aucun fournisseur cloud connecté';

  @override
  String get connectCloudDescription =>
      'Connectez Google Drive, Dropbox, OneDrive, SFTP ou WebDAV pour synchroniser et explorer vos fichiers.';

  @override
  String get addFirstCloud => 'Ajouter un premier cloud';

  @override
  String vaultOnRemote(String remote) {
    return 'COFFRE SUR $remote';
  }

  @override
  String get disconnectCloudTitle => 'Déconnecter le cloud';

  @override
  String disconnectCloudPrompt(String name) {
    return 'Voulez-vous déconnecter « $name » ? Les identifiants seront supprimés du stockage sécurisé.';
  }

  @override
  String get disconnect => 'Déconnecter';

  @override
  String freeSpace(String space) {
    return '$space libres';
  }

  @override
  String get storage => 'Stockage';

  @override
  String get available => 'Disponible';

  @override
  String get exploreFiles => 'Explorer les fichiers';

  @override
  String get paneLeft => 'Gauche';

  @override
  String get paneRight => 'Droite';

  @override
  String get folderName => 'Nom du dossier';

  @override
  String errorCreatingFolder(String error) {
    return 'Erreur lors de la création du dossier : $error';
  }

  @override
  String get moveAction => 'Déplacement';

  @override
  String get copyAction => 'Copie';

  @override
  String transferBatchStarted(String action, int count, String remote) {
    return '$action de $count éléments vers [$remote] démarré...';
  }

  @override
  String errorTransferring(String error) {
    return 'Erreur lors du transfert : $error';
  }

  @override
  String itemCopiedToClipboard(String name) {
    return '« $name » copié dans le presse-papiers';
  }

  @override
  String itemsCopiedToClipboard(int count) {
    return '$count éléments copiés dans le presse-papiers';
  }

  @override
  String itemCutToClipboard(String name) {
    return '« $name » coupé (prêt à être déplacé)';
  }

  @override
  String itemsCutToClipboard(int count) {
    return '$count éléments coupés (prêts à être déplacés)';
  }

  @override
  String get noFilesSelectedForDownload =>
      'Aucun fichier sélectionné pour le téléchargement.';

  @override
  String downloadingItems(int count) {
    return 'Téléchargement de $count éléments en cours...';
  }

  @override
  String itemsDownloadedSuccess(int count, String path) {
    return '$count éléments téléchargés dans « $path »';
  }

  @override
  String errorStartingDownload(String error) {
    return 'Erreur lors du lancement du téléchargement : $error';
  }

  @override
  String deleteItemsConfirmTitle(int count) {
    return 'Supprimer $count éléments sélectionnés ?';
  }

  @override
  String deleteItemsConfirmPrompt(int count) {
    return 'Êtes-vous sûr de vouloir supprimer définitivement $count éléments sélectionnés du cloud ?';
  }

  @override
  String itemsDeletedSuccess(int count) {
    return '$count éléments supprimés';
  }

  @override
  String errorDeleting(String error) {
    return 'Erreur lors de la suppression : $error';
  }

  @override
  String get uploadCompletedSuccess => 'Téléversement réussi';

  @override
  String errorUploading(String error) {
    return 'Erreur lors du téléversement : $error';
  }

  @override
  String get folderUploadCompletedSuccess => 'Dossier téléversé avec succès';

  @override
  String errorFolderUploading(String error) {
    return 'Erreur lors du téléversement du dossier : $error';
  }

  @override
  String get filesAlreadyInDirectory =>
      'Les fichiers se trouvent déjà dans ce dossier.';

  @override
  String dragDropTransferStarted(String action, int count, String remote) {
    return '$action de $count éléments vers [$remote] démarré...';
  }

  @override
  String errorDragDrop(String error) {
    return 'Erreur lors du glisser-déposer : $error';
  }

  @override
  String get closeSelection => 'Fermer la sélection';

  @override
  String itemsSelectedCount(int count) {
    return '$count sélectionnés';
  }

  @override
  String get deselectAll => 'Tout désélectionner';

  @override
  String copyToRemote(String remote) {
    return 'Copier vers $remote';
  }

  @override
  String moveToRemote(String remote) {
    return 'Déplacer vers $remote';
  }

  @override
  String get moreActions => 'Autres actions';

  @override
  String get downloadSelected => 'Télécharger la sélection';

  @override
  String get copyToClipboard => 'Copier dans le presse-papiers';

  @override
  String get cutToClipboard => 'Couper vers le presse-papiers';

  @override
  String get selectCloud => 'Sélectionner un cloud';

  @override
  String get closeSearch => 'Fermer la recherche';

  @override
  String get uploadFromDevice => 'Téléverser depuis l\'appareil';

  @override
  String get moreOptions => 'Plus d\'options';

  @override
  String get viewGrid => 'Affichage grille';

  @override
  String get viewList => 'Affichage liste';

  @override
  String get multiSelection => 'Sélection multiple';

  @override
  String get sortNameAsc => 'Nom (A-Z)';

  @override
  String get sortNameDesc => 'Nom (Z-A)';

  @override
  String get sortSizeDesc => 'Taille (Grand -> Petit)';

  @override
  String get sortSizeAsc => 'Taille (Petit -> Grand)';

  @override
  String get sortDateDesc => 'Date (Plus récent d\'abord)';

  @override
  String get disableDualPane => 'Désactiver Commander (Panneau unique)';

  @override
  String get enableDualPane => 'Activer Commander (Double panneau)';

  @override
  String itemsInClipboard(int count) {
    return '$count éléments dans le presse-papiers';
  }

  @override
  String get pasteHere => 'Coller ici';

  @override
  String get noResults => 'Aucun résultat';

  @override
  String noMatchingResults(String query) {
    return 'Aucun fichier ou dossier ne correspond à « $query »';
  }

  @override
  String get selectACloud => 'Sélectionnez un cloud';

  @override
  String get selectCloudDescription =>
      'Sélectionnez un fournisseur de cloud dans le menu ci-dessus pour explorer vos fichiers distants.';

  @override
  String optionsForItem(String name) {
    return 'Options pour $name';
  }

  @override
  String get select => 'Sélectionner';

  @override
  String get openWithSystemApp => 'Ouvrir avec l\'application système';

  @override
  String get downloadToLocal => 'Télécharger en local';

  @override
  String get cut => 'Couper (Déplacer)';

  @override
  String get copyPath => 'Copier le chemin';

  @override
  String get info => 'Informations';

  @override
  String generatingShareLink(String name) {
    return 'Génération du lien pour « $name »...';
  }

  @override
  String errorPublicLink(String error) {
    return 'Erreur de lien public : $error';
  }

  @override
  String get noLinkGenerated => 'Aucun lien généré par le fournisseur.';

  @override
  String errorDownloading(String error) {
    return 'Erreur lors du téléchargement : $error';
  }

  @override
  String get renameFolderTitle => 'Renommer le dossier';

  @override
  String get renameFileTitle => 'Renommer le fichier';

  @override
  String errorRenaming(String error) {
    return 'Erreur lors du renommage : $error';
  }

  @override
  String get pathCopiedToClipboard => 'Chemin copié dans le presse-papiers';

  @override
  String itemDetailsPath(String path) {
    return 'Chemin : $path';
  }

  @override
  String itemDetailsType(String type) {
    return 'Type : $type';
  }

  @override
  String itemDetailsSize(String size) {
    return 'Taille : $size';
  }

  @override
  String itemDetailsModified(String date) {
    return 'Date de modification : $date';
  }

  @override
  String get folder => 'Dossier';

  @override
  String get file => 'Fichier';

  @override
  String get selectCloudFirstLeft =>
      'Sélectionnez d\'abord un cloud dans le panneau gauche.';

  @override
  String get selectCloudFirstRight =>
      'Sélectionnez d\'abord un cloud dans le panneau droit.';

  @override
  String get selectDestinationCloudLeft =>
      'Sélectionnez d\'abord un cloud de destination dans le panneau gauche.';

  @override
  String get selectDestinationCloudRight =>
      'Sélectionnez d\'abord un cloud de destination dans le panneau droit.';

  @override
  String get noFilesToTransfer =>
      'Aucun fichier présent ou sélectionné à transférer.';

  @override
  String transferStarted(String action, int count, String src, String dst) {
    return '$action de $count éléments de [$src] vers [$dst] démarré...';
  }

  @override
  String get swapPanesTooltip => 'Intervertir les panneaux (<->)';

  @override
  String get refreshBothPanesTooltip => 'Actualiser les deux panneaux';

  @override
  String get copyRight => 'Copier vers la droite ->';

  @override
  String get moveRight => 'Déplacer vers la droite ->';

  @override
  String get copyLeft => '<- Copier vers la gauche';

  @override
  String get moveLeft => '<- Déplacer vers la gauche';

  @override
  String copyRightWithCount(int count) {
    return 'Copier vers la droite ($count) ->';
  }

  @override
  String moveRightWithCount(int count) {
    return 'Déplacer vers la droite ($count) ->';
  }

  @override
  String copyLeftWithCount(int count) {
    return '<- Copier vers la gauche ($count)';
  }

  @override
  String moveLeftWithCount(int count) {
    return '<- Déplacer vers la gauche ($count)';
  }

  @override
  String get deleteRuleTitle => 'Supprimer la règle';

  @override
  String deleteRulePrompt(String name) {
    return 'Voulez-vous vraiment supprimer la règle « $name » ? Les fichiers locaux et distants seront conservés.';
  }

  @override
  String get syncAll => 'Tout synchroniser';

  @override
  String get newRuleTooltip => 'Nouvelle règle';

  @override
  String get backupBannerTitle =>
      'Sauvegarde continue et synchronisation cloud';

  @override
  String get backupBannerSubtitle =>
      'Configurez des synchronisations planifiées entre dossiers locaux et clouds distants.';

  @override
  String get noActiveRules => 'Aucune règle active';

  @override
  String get noActiveRulesSubtitle =>
      'Créez votre première règle pour sauvegarder automatiquement depuis votre appareil vers Google Drive, Dropbox, SFTP ou tout autre cloud.';

  @override
  String get createNewRule => 'Créer une règle';

  @override
  String get ruleOptionsTooltip => 'Options de la règle';

  @override
  String get syncNow => 'Synchroniser maintenant';

  @override
  String get statusWaiting => 'En attente';

  @override
  String get statusInProgress => 'En cours...';

  @override
  String get statusCompleted => 'Terminé';

  @override
  String get statusFailed => 'Erreur';

  @override
  String get editRuleTitle => 'Modifier la règle de sauvegarde';

  @override
  String get newRuleTitle => 'Nouvelle règle de synchronisation';

  @override
  String get ruleDialogSubtitle =>
      'Configurez la sauvegarde automatique entre un dossier local et le cloud.';

  @override
  String get ruleNameOptional => 'Nom de la règle (facultatif)';

  @override
  String get ruleNameHint => 'ex. Sauvegarde Photos DCIM ou Documents Travail';

  @override
  String get sourceLocalFolder => 'Dossier source local';

  @override
  String get sourceLocalFolderHint =>
      '/storage/emulated/0/DCIM ou /home/utilisateur/Images';

  @override
  String get browseFolders => 'Parcourir les dossiers';

  @override
  String get selectLocalFolderError =>
      'Veuillez saisir ou sélectionner un dossier local';

  @override
  String get noCloudsConfiguredSync =>
      'Aucun cloud configuré. Configurez un compte cloud depuis l\'accueil avant de continuer.';

  @override
  String get remoteDestinationPath => 'Chemin distant de destination';

  @override
  String get syncMode => 'Mode de synchronisation';

  @override
  String get syncModeCopy => 'Sauvegarde incrémentielle';

  @override
  String get syncModeCopyDesc =>
      'Téléverse les fichiers nouveaux et modifiés en conservant toujours les fichiers existants sur le cloud.';

  @override
  String get syncModeSync => 'Synchronisation miroir';

  @override
  String get syncModeSyncDesc =>
      'Rend la destination distante identique au dossier local (les fichiers supprimés localement sont supprimés du cloud).';

  @override
  String get syncFrequency => 'Fréquence d\'exécution';

  @override
  String get freqManual => 'Manuelle (sur demande uniquement)';

  @override
  String get freq15Min => 'Toutes les 15 minutes';

  @override
  String get freq30Min => 'Toutes les 30 minutes';

  @override
  String get freqHourly => 'Toutes les heures';

  @override
  String get freq6Hours => 'Toutes les 6 heures';

  @override
  String get freq12Hours => 'Toutes les 12 heures';

  @override
  String get freqDaily => 'Chaque jour (24 heures)';

  @override
  String get activateRuleImmediately => 'Activer la règle immédiatement';

  @override
  String get activateRuleImmediatelyDesc =>
      'La synchronisation s\'exécutera en arrière-plan selon l\'intervalle spécifié';

  @override
  String get updateRule => 'Mettre à jour';

  @override
  String get saveRule => 'Enregistrer la règle';

  @override
  String get selectCloudProvider => 'Sélectionner le fournisseur de cloud :';

  @override
  String get cloudAccountName => 'Nom du compte cloud';

  @override
  String get cloudAccountNameHint =>
      'ex. GoogleDrive, TravailDropbox (sans espaces)';

  @override
  String get enterNameError => 'Veuillez saisir un nom';

  @override
  String get noSpacesOrColons => 'Les espaces et « : » ne sont pas autorisés';

  @override
  String get oauthMode => 'Mode Client ID (OAuth2)';

  @override
  String get oauthOfficial => 'UnifyCloud (Officiel / Recommandé)';

  @override
  String get oauthRclone => 'Rclone (Déconseillé - Quota partagé)';

  @override
  String get oauthCustom => 'Client ID Personnel (Avancé)';

  @override
  String get officialOauthTitle => 'Identifiants officiels UnifyCloud';

  @override
  String get officialOauthDesc =>
      'Identifiants préconfigurés pour se connecter immédiatement avec quota dédié et vitesse maximale.';

  @override
  String get rcloneOauthDesc =>
      'Clés open source partagées de Rclone. Peuvent faire l\'objet de limites de quota ou d\'erreurs 403 Google.';

  @override
  String get customClientId => 'Client ID';

  @override
  String get customClientSecret => 'Client Secret';

  @override
  String get selectVaultDestination =>
      'Sélectionnez le cloud de destination pour le coffre';

  @override
  String get vaultPasswordRequired =>
      'Le mot de passe de chiffrement est obligatoire';

  @override
  String get vaultPasswordsDoNotMatch =>
      'Les mots de passe ne correspondent pas';

  @override
  String errorAddingRemote(String error) {
    return 'Erreur lors de l\'ajout du cloud : $error';
  }

  @override
  String get fileNameEncryption => 'Chiffrement des noms de fichiers';

  @override
  String get encryptStandard =>
      'Standard (Noms entièrement chiffrés - Recommandé)';

  @override
  String get encryptObscure => 'Obfuscation simple (Conserve les extensions)';

  @override
  String get encryptOff => 'Désactivé (Noms visibles en clair)';

  @override
  String get encryptFolderNames => 'Chiffrer également les noms de dossiers';

  @override
  String get encryptFolderNamesDesc =>
      'Masque complètement la structure des répertoires sur le cloud';

  @override
  String get connectCloud => 'Connecter le cloud';

  @override
  String get reopenAuth => 'Rouvrir';

  @override
  String get linkCopiedToClipboard => 'Lien copié dans le presse-papiers !';

  @override
  String errorOpenBrowserGeneric(String error) {
    return 'Impossible d\'ouvrir le navigateur : $error';
  }

  @override
  String get shareableLinkTitle => 'Lien de partage';

  @override
  String shareLinkAccessDescription(String item) {
    return 'Toute personne disposant de ce lien pourra accéder à $item :';
  }

  @override
  String get open => 'Ouvrir';

  @override
  String activeTransfersCount(int count) {
    return '$count transferts actifs';
  }

  @override
  String transfersQueueCount(int count) {
    return 'File de transfert ($count)';
  }

  @override
  String get noTransfersInProgress => 'Aucun transfert en cours';

  @override
  String get transfersEmptySubtitle =>
      'Tous les fichiers téléchargés ou téléversés apparaîtront ici';

  @override
  String get cancelled => 'Annulé';

  @override
  String get appLockedTitle => 'Application verrouillée';

  @override
  String get unlockWithBiometrics => 'Déverrouiller avec la biométrie';

  @override
  String get pinMustBe6Digits =>
      'Le code PIN doit comporter exactement 6 chiffres';

  @override
  String get pinIncorrect => 'Code PIN incorrect. Réessayez.';

  @override
  String get pinsDoNotMatch => 'Les codes PIN ne correspondent pas. Réessayez.';

  @override
  String get pinStepOld => 'Saisissez votre code PIN actuel pour continuer.';

  @override
  String get pinStepNew => 'Saisissez votre nouveau code PIN à 6 chiffres.';

  @override
  String get pinStepConfirm =>
      'Ressaisissez le nouveau code PIN pour confirmer.';

  @override
  String get pinStepVerify =>
      'Saisissez votre code PIN pour confirmer l\'opération.';

  @override
  String get pinTitleSetup => 'Définir le code PIN de sécurité';

  @override
  String get pinTitleChange => 'Modifier le code PIN de sécurité';

  @override
  String get pinTitleVerify => 'Vérification de sécurité';

  @override
  String get pinContinue => 'Continuer';

  @override
  String get errorDetails => 'Détails de l\'erreur';

  @override
  String get errorDetailsCopied =>
      'Détails de l\'erreur copiés dans le presse-papiers';

  @override
  String get collapse => 'Réduire';

  @override
  String get expand => 'Développer';

  @override
  String get copyError => 'Copier l\'erreur';

  @override
  String get errorNetwork =>
      'Connexion absente ou instable. Vérifiez votre connexion Internet et réessayez.';

  @override
  String get errorDiskSpace =>
      'Espace de stockage insuffisant ou disque plein. Libérez de la mémoire pour continuer.';

  @override
  String get errorAuthExpired =>
      'Session ou jeton expiré/révoqué. Reconnectez votre compte.';

  @override
  String get errorNotFound =>
      'Élément ou dossier introuvable sur le fournisseur de cloud.';

  @override
  String get errorPermissionDenied =>
      'Permission refusée pour cette opération sur le cloud.';

  @override
  String get errorGeneric => 'Une erreur est survenue lors de l\'opération.';
}
