// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'UnifyCloud';

  @override
  String get home => 'Strona główna';

  @override
  String get explorer => 'Eksplorator';

  @override
  String get sync => 'Synchronizacja';

  @override
  String get settings => 'Ustawienia';

  @override
  String get cancel => 'Anuluj';

  @override
  String get confirm => 'Potwierdź';

  @override
  String get delete => 'Usuń';

  @override
  String get save => 'Zapisz';

  @override
  String get close => 'Zamknij';

  @override
  String get edit => 'Edytuj';

  @override
  String get create => 'Utwórz';

  @override
  String get retry => 'Ponów';

  @override
  String get copy => 'Kopiuj';

  @override
  String get move => 'Przenieś';

  @override
  String get rename => 'Zmień nazwę';

  @override
  String get download => 'Pobierz';

  @override
  String get upload => 'Prześlij';

  @override
  String get share => 'Udostępnij';

  @override
  String get details => 'Szczegóły';

  @override
  String get search => 'Szukaj';

  @override
  String get change => 'Zmień';

  @override
  String get reset => 'Zresetuj';

  @override
  String get done => 'Gotowe';

  @override
  String get loading => 'Ładowanie...';

  @override
  String get success => 'Operacja zakończona sukcesem';

  @override
  String get error => 'Błąd';

  @override
  String get settingsTitle => 'Ustawienia';

  @override
  String get resetDefaultsTooltip => 'Przywróć ustawienia domyślne';

  @override
  String get resetDialogTitle => 'Zresetować ustawienia?';

  @override
  String get resetDialogContent =>
      'Czy na pewno chcesz przywrócić wszystkie ustawienia do wartości domyślnych?';

  @override
  String get resetSuccessSnackbar => 'Przywrócono ustawienia domyślne';

  @override
  String get appearanceAndTheme => 'Wygląd i motyw';

  @override
  String get chooseVisualThemeSubtitle => 'Wybierz motyw wizualny aplikacji:';

  @override
  String get themeSystem => 'Systemowy';

  @override
  String get themeLight => 'Jasny';

  @override
  String get themeDark => 'Ciemny';

  @override
  String get language => 'Język';

  @override
  String get languageSubtitle => 'Wybierz język interfejsu aplikacji';

  @override
  String get langEnglish => 'English';

  @override
  String get langItalian => 'Italiano';

  @override
  String get langSystem => 'Domyślny systemowy';

  @override
  String get filesAndExploration => 'Pliki i przeglądanie';

  @override
  String get showHiddenFiles => 'Pokaż ukryte pliki';

  @override
  String get showHiddenFilesSubtitle =>
      'Wyświetlaj pliki i foldery zaczynające się od kropki';

  @override
  String get confirmBeforeDelete => 'Potwierdź przed usunięciem';

  @override
  String get confirmBeforeDeleteSubtitle =>
      'Wyświetlaj monit przed trwałym usunięciem';

  @override
  String get defaultDownloadFolder => 'Domyślny folder pobierania';

  @override
  String get defaultDownloadFolderSystem =>
      'Katalog Pobrane w systemie (domyślny)';

  @override
  String get restoreDefaultPath => 'Przywróć domyślną ścieżkę';

  @override
  String get customDownloadFolderDialogPrompt =>
      'Wybierz folder za pomocą selektora lub wpisz ścieżkę ręcznie:';

  @override
  String get folderPath => 'Ścieżka folderu';

  @override
  String get folderPathHint => 'np. /home/uzytkownik/Pobrane';

  @override
  String get browseWithSystemPicker => 'Przeglądaj w systemie';

  @override
  String errorOpenPicker(String error) {
    return 'Nie można otworzyć selektora plików: $error';
  }

  @override
  String get restoreDefault => 'Przywróć domyślne';

  @override
  String get maxConcurrentTransfers => 'Jednoczesne transfery';

  @override
  String get maxConcurrentTransfersSubtitle =>
      'Maksymalna liczba jednoczesnych transferów plików';

  @override
  String get dualPaneMode => 'Tryb dwóch paneli (Tablet/Pulpit)';

  @override
  String get dualPaneModeSubtitle =>
      'Pokaż dwa panele obok siebie na dużych ekranach';

  @override
  String get communityAndSupport => 'Społeczność i wsparcie';

  @override
  String get openSourceDescription =>
      'UnifyCloud to darmowe oprogramowanie open source na licencji GPL-3.0.';

  @override
  String get supportDeveloper => 'Wesprzyj twórcę';

  @override
  String get supportDeveloperSubtitle =>
      'Postaw kawę, aby wesprzeć niezależny rozwój';

  @override
  String get viewSourceOnGitLab => 'Zobacz kod na GitLabie';

  @override
  String get viewSourceOnGitLabSubtitle =>
      'Oficjalne repozytorium, zgłoszenia i wkład';

  @override
  String errorOpenBrowser(String url) {
    return 'Nie można otworzyć przeglądarki. Repozytorium: $url';
  }

  @override
  String get supportDialogTitle => 'Wesprzyj UnifyCloud';

  @override
  String get supportDialogDescription1 =>
      'UnifyCloud to projekt open source tworzony z pasją, dający pełną kontrolę nad Twoimi danymi w chmurze.';

  @override
  String get supportDialogDescription2 =>
      'Możesz przekazać darowiznę lub wesprzeć rozwój przez:';

  @override
  String get supportKofiTitle => 'Postaw kawę na Ko-fi';

  @override
  String get supportLiberapayTitle => 'Liberapay (Cyklicznie)';

  @override
  String get supportPaypalTitle => 'PayPal (Bezpośrednio)';

  @override
  String get securityAndEncryption => 'Bezpieczeństwo i szyfrowanie';

  @override
  String get securityArchitectureDescription =>
      'UnifyCloud korzysta z lokalnego szyfrowania. Twoje poświadczenia są bezpiecznie przechowywane w pęku kluczy.';

  @override
  String get appLock => 'Blokada aplikacji';

  @override
  String get appLockSubtitle => 'Zabezpiecz aplikację kodem PIN';

  @override
  String get appLockActiveSubtitle => 'PIN aktywny – dotknij, aby zmienić';

  @override
  String get appLockEnabledSnackbar => 'Pomyślnie włączono blokadę aplikacji';

  @override
  String get appLockDisabledSnackbar => 'Blokada aplikacji wyłączona';

  @override
  String get changePin => 'Zmień PIN';

  @override
  String get changePinSubtitle => 'Ustaw nowy 4-6-cyfrowy kod PIN';

  @override
  String get pinChangedSnackbar => 'Kod PIN został pomyślnie zmieniony';

  @override
  String get biometricAuth => 'Uwierzytelnianie biometryczne';

  @override
  String get biometricAuthSubtitle =>
      'Użyj odcisku palca lub rozpoznawania twarzy';

  @override
  String get biometricNotAvailable =>
      'Biometria niedostępna lub nieskonfigurowana na tym urządzeniu';

  @override
  String get autoLock => 'Automatyczna blokada';

  @override
  String get autoLockSubtitle => 'Czas bezczynności w tle przed zablokowaniem';

  @override
  String get lockImmediately => 'Natychmiast po opuszczeniu';

  @override
  String get lockAfter1Minute => 'Po 1 minucie';

  @override
  String get lockAfter5Minutes => 'Po 5 minutach';

  @override
  String get lockAfter15Minutes => 'Po 15 minutach';

  @override
  String get lockAfter30Minutes => 'Po 30 minutach';

  @override
  String get syncCloudAccounts => 'Synchronizuj konta chmurowe';

  @override
  String get syncCloudAccountsSubtitle =>
      'Odśwież konfiguracje z bezpiecznego magazynu';

  @override
  String get syncCloudAccountsSuccess =>
      'Pomyślnie zsynchronizowano konta chmurowe';

  @override
  String get clearAllCredentials => 'Wyczyść wszystkie poświadczenia';

  @override
  String get clearAllCredentialsSubtitle =>
      'Usuwa zaszyfrowaną konfigurację i odłącza wszystkie chmury';

  @override
  String get clearCredentialsDialogTitle => 'Ostrzeżenie: Reset poświadczeń';

  @override
  String get clearCredentialsDialogContent =>
      'Czy na pewno chcesz usunąć wszystkie zapisane konta? Konieczne będzie ponowne zalogowanie.';

  @override
  String get clearCredentialsSuccess => 'Pomyślnie wyczyszczono poświadczenia';

  @override
  String get aboutUnifyCloud => 'O UnifyCloud';

  @override
  String get appVersion => 'Wersja aplikacji: 1.0.0';

  @override
  String get developerInfo => 'Twórca: LeoRise (@leorise25)';

  @override
  String get engineInfo => 'Silnik: Rclone Core CGO (Go v1.22+ / C FFI)';

  @override
  String get frameworkInfo => 'Framework: Flutter (Material 3 Responsive)';

  @override
  String get licenseInfo =>
      'Licencja: GNU General Public License v3.0 (GPL-3.0)';

  @override
  String get copyrightInfo => 'Prawa autorskie: © 2026 Leonardo Bani';

  @override
  String get storageOverview => 'Przegląd pamięci';

  @override
  String get connectedClouds => 'Połączone chmury';

  @override
  String get noCloudsConfigured => 'Brak skonfigurowanych chmur';

  @override
  String get noCloudsDescription =>
      'Połącz swoje pierwsze konto w chmurze, aby zarządzać plikami i je synchronizować.';

  @override
  String get addCloud => 'Dodaj chmurę';

  @override
  String get used => 'zajęte';

  @override
  String get free => 'wolne';

  @override
  String get total => 'łącznie';

  @override
  String get manageAccounts => 'Zarządzaj kontami';

  @override
  String get viewFiles => 'Pokaż pliki';

  @override
  String get createVaultHere => 'Utwórz zaszyfrowany skarbiec...';

  @override
  String get disconnectAccount => 'Odłącz konto';

  @override
  String get disconnectConfirmTitle => 'Odłączyć konto?';

  @override
  String get disconnectConfirmContent =>
      'Czy na pewno chcesz odłączyć to konto? Zdalne pliki pozostaną nienaruszone.';

  @override
  String get allFiles => 'Wszystkie pliki';

  @override
  String get emptyFolder => 'Pusty folder';

  @override
  String get emptyFolderSubtitle =>
      'Prześlij pliki lub utwórz folder, aby rozpocząć';

  @override
  String get uploadFile => 'Prześlij plik';

  @override
  String get uploadFolder => 'Prześlij folder';

  @override
  String get newFolder => 'Nowy folder';

  @override
  String get newFolderPrompt => 'Wprowadź nazwę nowego folderu:';

  @override
  String get folderNameHint => 'Nazwa folderu';

  @override
  String get selectAll => 'Zaznacz wszystko';

  @override
  String get clearSelection => 'Wyczyść zaznaczenie';

  @override
  String get deleteSelected => 'Usuń zaznaczone';

  @override
  String get deleteSelectedPrompt =>
      'Czy na pewno chcesz usunąć zaznaczone elementy?';

  @override
  String get deleteItemPrompt => 'Czy na pewno chcesz usunąć ten element?';

  @override
  String get shareLink => 'Link udostępniania';

  @override
  String get createShareLink => 'Utwórz link do udostępnienia';

  @override
  String get copyShareLink => 'Kopiuj link';

  @override
  String get copiedToClipboard => 'Skopiowano do schowka';

  @override
  String get transfers => 'Transfery';

  @override
  String get activeTransfers => 'Aktywne transfery';

  @override
  String get completed => 'Ukończone';

  @override
  String get failed => 'Nieudane';

  @override
  String get queued => 'W kolejce';

  @override
  String get cancelTransfer => 'Anuluj transfer';

  @override
  String get clearCompleted => 'Wyczyść ukończone';

  @override
  String get syncRulesTitle => 'Reguły synchronizacji';

  @override
  String get newRule => 'Nowa reguła';

  @override
  String get noSyncRules => 'Brak skonfigurowanych reguł synchronizacji';

  @override
  String get noSyncRulesSubtitle =>
      'Brak reguł. Utwórz regułę, aby zautomatyzować kopie zapasowe.';

  @override
  String get ruleName => 'Nazwa reguły';

  @override
  String get sourcePath => 'Folder źródłowy';

  @override
  String get destinationCloud => 'Chmura docelowa';

  @override
  String get destinationPath => 'Ścieżka docelowa';

  @override
  String get direction => 'Kierunek';

  @override
  String get frequency => 'Częstotliwość';

  @override
  String get runNow => 'Uruchom teraz';

  @override
  String get syncInProgress => 'Synchronizacja w toku...';

  @override
  String get syncSuccess => 'Synchronizacja zakończona';

  @override
  String get syncFailed => 'Synchronizacja nie powiodła się';

  @override
  String get addCloudDialogTitle => 'Połącz nową chmurę';

  @override
  String get selectProvider => 'Wybierz dostawcę';

  @override
  String get accountNameLabel => 'Nazwa konta';

  @override
  String get connectButton => 'Połącz';

  @override
  String get vaultTitle => 'Zaszyfrowany skarbiec';

  @override
  String get vaultPassword => 'Hasło skarbca';

  @override
  String get vaultConfirmPassword => 'Potwierdź hasło';

  @override
  String get vaultSalt => 'Sól kryptograficzna (opcjonalnie)';

  @override
  String get encryptFileNames => 'Szyfruj nazwy plików';

  @override
  String get encryptDirNames => 'Szyfruj nazwy folderów';

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
  String get selectLanguage => 'Wybierz język';

  @override
  String get searchLanguageHint => 'Szukaj języka lub kraju...';

  @override
  String get currentLanguage => 'Bieżący język';

  @override
  String systemDefaultWithLocale(String locale) {
    return 'Domyślny systemowy ($locale)';
  }

  @override
  String get refreshCloudsTooltip => 'Odśwież skonfigurowane chmury';

  @override
  String get storageOverviewAggregated => 'Zbiorczy przegląd pamięci';

  @override
  String get ramEncryptionActive => 'Szyfrowanie RAM aktywne';

  @override
  String connectedAccountsCount(int count) {
    return 'Połączone konta chmurowe: $count';
  }

  @override
  String get noCloudsConfiguredHint =>
      'Brak skonfigurowanych chmur. Dotknij „+ Połącz nową chmurę” poniżej.';

  @override
  String percentUsed(String percent) {
    return '$percent% zajęte';
  }

  @override
  String availableSpace(String space) {
    return '$space dostępne';
  }

  @override
  String get calculatingQuota => 'Obliczanie limitu pamięci...';

  @override
  String get syncAndBackup => 'Synchronizacja i kopia zapasowa';

  @override
  String get noRulesConfigured => 'Brak reguł';

  @override
  String activeRulesCount(int active, int total) {
    return '$active/$total aktywnych reguł';
  }

  @override
  String get manage => 'Zarządzaj';

  @override
  String connectedCloudsCount(int count) {
    return 'Połączone chmury ($count)';
  }

  @override
  String get connectNewCloud => 'Połącz nową chmurę';

  @override
  String get noCloudProvidersConnected => 'Brak połączonych dostawców chmury';

  @override
  String get connectCloudDescription =>
      'Połącz Google Drive, Dropbox, OneDrive, SFTP lub WebDAV, aby synchronizować pliki.';

  @override
  String get addFirstCloud => 'Dodaj pierwszą chmurę';

  @override
  String vaultOnRemote(String remote) {
    return 'SKARBIEC NA $remote';
  }

  @override
  String get disconnectCloudTitle => 'Odłącz chmurę';

  @override
  String disconnectCloudPrompt(String name) {
    return 'Czy na pewno chcesz odłączyć „$name”? Poświadczenia zostaną usunięte.';
  }

  @override
  String get disconnect => 'Odłącz';

  @override
  String freeSpace(String space) {
    return '$space wolne';
  }

  @override
  String get storage => 'Pamięć';

  @override
  String get available => 'Dostępne';

  @override
  String get exploreFiles => 'Przeglądaj pliki';

  @override
  String get paneLeft => 'Lewy';

  @override
  String get paneRight => 'Prawy';

  @override
  String get folderName => 'Nazwa folderu';

  @override
  String errorCreatingFolder(String error) {
    return 'Błąd podczas tworzenia folderu: $error';
  }

  @override
  String get moveAction => 'Przenieś';

  @override
  String get copyAction => 'Kopiuj';

  @override
  String transferBatchStarted(String action, int count, String remote) {
    return 'Rozpoczęto $action $count elementów do [$remote]...';
  }

  @override
  String errorTransferring(String error) {
    return 'Błąd transferu: $error';
  }

  @override
  String itemCopiedToClipboard(String name) {
    return '„$name” skopiowano do schowka';
  }

  @override
  String itemsCopiedToClipboard(int count) {
    return 'Skopiowano $count elementów do schowka';
  }

  @override
  String itemCutToClipboard(String name) {
    return '„$name” wycięto (gotowe do przeniesienia)';
  }

  @override
  String itemsCutToClipboard(int count) {
    return 'Wycięto $count elementów (gotowe do przeniesienia)';
  }

  @override
  String get noFilesSelectedForDownload => 'Nie wybrano plików do pobrania';

  @override
  String downloadingItems(int count) {
    return 'Pobieranie $count elementów...';
  }

  @override
  String itemsDownloadedSuccess(int count, String path) {
    return 'Pobrano $count elementów do „$path”';
  }

  @override
  String errorStartingDownload(String error) {
    return 'Błąd podczas rozpoczynania pobierania: $error';
  }

  @override
  String deleteItemsConfirmTitle(int count) {
    return 'Usunąć $count zaznaczonych elementów?';
  }

  @override
  String deleteItemsConfirmPrompt(int count) {
    return 'Czy na pewno chcesz trwale usunąć $count zaznaczonych elementów z chmury?';
  }

  @override
  String itemsDeletedSuccess(int count) {
    return 'Usunięto $count elementów';
  }

  @override
  String errorDeleting(String error) {
    return 'Błąd podczas usuwania: $error';
  }

  @override
  String get uploadCompletedSuccess => 'Przesyłanie zakończone pomyślnie';

  @override
  String errorUploading(String error) {
    return 'Błąd podczas przesyłania: $error';
  }

  @override
  String get folderUploadCompletedSuccess =>
      'Przesyłanie folderu zakończone pomyślnie';

  @override
  String errorFolderUploading(String error) {
    return 'Błąd podczas przesyłania folderu: $error';
  }

  @override
  String get filesAlreadyInDirectory => 'Pliki znajdują się już w tym katalogu';

  @override
  String dragDropTransferStarted(String action, int count, String remote) {
    return 'Rozpoczęto $action $count elementów do [$remote]...';
  }

  @override
  String errorDragDrop(String error) {
    return 'Błąd transferu przeciągnij i upuść: $error';
  }

  @override
  String get closeSelection => 'Zamknij zaznaczenie';

  @override
  String itemsSelectedCount(int count) {
    return 'Zaznaczono: $count';
  }

  @override
  String get deselectAll => 'Odznacz wszystko';

  @override
  String copyToRemote(String remote) {
    return 'Kopiuj do $remote';
  }

  @override
  String moveToRemote(String remote) {
    return 'Przenieś do $remote';
  }

  @override
  String get moreActions => 'Więcej działań';

  @override
  String get downloadSelected => 'Pobierz zaznaczone';

  @override
  String get copyToClipboard => 'Kopiuj do schowka';

  @override
  String get cutToClipboard => 'Wytnij do schowka';

  @override
  String get selectCloud => 'Wybierz chmurę';

  @override
  String get closeSearch => 'Zamknij wyszukiwanie';

  @override
  String get uploadFromDevice => 'Prześlij z urządzenia';

  @override
  String get moreOptions => 'Więcej opcji';

  @override
  String get viewGrid => 'Widok siatki';

  @override
  String get viewList => 'Widok listy';

  @override
  String get multiSelection => 'Wielokrotny wybór';

  @override
  String get sortNameAsc => 'Nazwa (A-Z)';

  @override
  String get sortNameDesc => 'Nazwa (Z-A)';

  @override
  String get sortSizeDesc => 'Rozmiar (malejąco)';

  @override
  String get sortSizeAsc => 'Rozmiar (rosnąco)';

  @override
  String get sortDateDesc => 'Ostatnio zmodyfikowane';

  @override
  String get disableDualPane => 'Wyłącz dwa panele';

  @override
  String get enableDualPane => 'Włącz dwa panele';

  @override
  String itemsInClipboard(int count) {
    return '$count elementów w schowku';
  }

  @override
  String get pasteHere => 'Wklej tutaj';

  @override
  String get noResults => 'Nie znaleziono wyników';

  @override
  String noMatchingResults(String query) {
    return 'Brak plików pasujących do „$query”';
  }

  @override
  String get selectACloud => 'Wybierz chmurę';

  @override
  String get selectCloudDescription =>
      'Wybierz konto w chmurze z menu powyżej, aby rozpocząć przeglądanie.';

  @override
  String optionsForItem(String name) {
    return 'Opcje dla $name';
  }

  @override
  String get select => 'Wybierz';

  @override
  String get openWithSystemApp => 'Otwórz w aplikacji systemowej';

  @override
  String get downloadToLocal => 'Pobierz na urządzenie';

  @override
  String get cut => 'Wytnij';

  @override
  String get copyPath => 'Kopiuj ścieżkę';

  @override
  String get info => 'Informacje';

  @override
  String generatingShareLink(String name) {
    return 'Generowanie linku do „$name”...';
  }

  @override
  String errorPublicLink(String error) {
    return 'Błąd publicznego linku: $error';
  }

  @override
  String get noLinkGenerated => 'Serwer nie wygenerował linku';

  @override
  String errorDownloading(String error) {
    return 'Błąd pobierania: $error';
  }

  @override
  String get renameFolderTitle => 'Zmień nazwę folderu';

  @override
  String get renameFileTitle => 'Zmień nazwę pliku';

  @override
  String errorRenaming(String error) {
    return 'Błąd zmiany nazwy: $error';
  }

  @override
  String get pathCopiedToClipboard => 'Ścieżka skopiowana do schowka';

  @override
  String itemDetailsPath(String path) {
    return 'Ścieżka: $path';
  }

  @override
  String itemDetailsType(String type) {
    return 'Typ: $type';
  }

  @override
  String itemDetailsSize(String size) {
    return 'Rozmiar: $size';
  }

  @override
  String itemDetailsModified(String date) {
    return 'Zmodyfikowano: $date';
  }

  @override
  String get folder => 'Folder';

  @override
  String get file => 'Plik';

  @override
  String get selectCloudFirstLeft =>
      'Najpierw wybierz chmurę dla lewego panelu';

  @override
  String get selectCloudFirstRight =>
      'Najpierw wybierz chmurę dla prawego panelu';

  @override
  String get selectDestinationCloudLeft =>
      'Wybierz chmurę docelową w lewym panelu';

  @override
  String get selectDestinationCloudRight =>
      'Wybierz chmurę docelową w prawym panelu';

  @override
  String get noFilesToTransfer => 'Brak plików do przesłania';

  @override
  String transferStarted(String action, int count, String src, String dst) {
    return 'Rozpoczęto $action $count elementów z [$src] do [$dst]...';
  }

  @override
  String get swapPanesTooltip => 'Zamień panele miejscami';

  @override
  String get refreshBothPanesTooltip => 'Odśwież oba panele';

  @override
  String get copyRight => 'Kopiuj w prawo ->';

  @override
  String get moveRight => 'Przenieś w prawo ->';

  @override
  String get copyLeft => '<- Kopiuj w lewo';

  @override
  String get moveLeft => '<- Przenieś w lewo';

  @override
  String copyRightWithCount(int count) {
    return 'Kopiuj w prawo ($count) ->';
  }

  @override
  String moveRightWithCount(int count) {
    return 'Przenieś w prawo ($count) ->';
  }

  @override
  String copyLeftWithCount(int count) {
    return '<- Kopiuj w lewo ($count)';
  }

  @override
  String moveLeftWithCount(int count) {
    return '<- Przenieś w lewo ($count)';
  }

  @override
  String get deleteRuleTitle => 'Usuń regułę';

  @override
  String deleteRulePrompt(String name) {
    return 'Czy na pewno chcesz usunąć regułę „$name”? Pliki nie zostaną usunięte.';
  }

  @override
  String get syncAll => 'Synchronizuj wszystko';

  @override
  String get newRuleTooltip => 'Dodaj nową regułę';

  @override
  String get backupBannerTitle => 'Kopia zapasowa i synchronizacja';

  @override
  String get backupBannerSubtitle =>
      'Automatycznie odzwierciedlaj pliki w wybranych lokalizacjach';

  @override
  String get noActiveRules => 'Brak aktywnych reguł synchronizacji';

  @override
  String get noActiveRulesSubtitle =>
      'Utwórz regułę, aby automatycznie synchronizować foldery według harmonogramu.';

  @override
  String get createNewRule => 'Utwórz nową regułę';

  @override
  String get ruleOptionsTooltip => 'Opcje reguły';

  @override
  String get syncNow => 'Synchronizuj teraz';

  @override
  String get statusWaiting => 'Oczekiwanie';

  @override
  String get statusInProgress => 'W toku...';

  @override
  String get statusCompleted => 'Zakończono';

  @override
  String get statusFailed => 'Niepowodzenie';

  @override
  String get editRuleTitle => 'Edytuj regułę synchronizacji';

  @override
  String get newRuleTitle => 'Nowa reguła synchronizacji';

  @override
  String get ruleDialogSubtitle =>
      'Zdefiniuj źródło, cel i częstotliwość synchronizacji';

  @override
  String get ruleNameOptional => 'Nazwa reguły (opcjonalnie)';

  @override
  String get ruleNameHint => 'np. Automatyczna kopia dokumentów';

  @override
  String get sourceLocalFolder => 'Lokalny folder źródłowy';

  @override
  String get sourceLocalFolderHint => 'Wybierz folder lokalny...';

  @override
  String get browseFolders => 'Przeglądaj';

  @override
  String get selectLocalFolderError => 'Wybierz lokalny folder źródłowy';

  @override
  String get noCloudsConfiguredSync =>
      'Brak skonfigurowanych chmur. Dodaj chmurę w Ustawieniach.';

  @override
  String get remoteDestinationPath => 'Ścieżka docelowa w chmurze';

  @override
  String get syncMode => 'Tryb';

  @override
  String get syncModeCopy => 'Kopiowanie (tylko nowe/zaktualizowane)';

  @override
  String get syncModeCopyDesc =>
      'Kopiuje nowe i zaktualizowane pliki do celu bez usuwania żadnych plików docelowych.';

  @override
  String get syncModeSync => 'Synchronizacja (lustro)';

  @override
  String get syncModeSyncDesc =>
      'Ujednolica cel ze źródłem. Usuwa pliki w miejscu docelowym, jeśli zostały usunięte w źródle.';

  @override
  String get syncFrequency => 'Częstotliwość synchronizacji';

  @override
  String get freqManual => 'Tylko ręcznie';

  @override
  String get freq15Min => 'Co 15 minut';

  @override
  String get freq30Min => 'Co 30 minut';

  @override
  String get freqHourly => 'Co godzinę';

  @override
  String get freq6Hours => 'Co 6 godzin';

  @override
  String get freq12Hours => 'Co 12 godzin';

  @override
  String get freqDaily => 'Codziennie';

  @override
  String get activateRuleImmediately => 'Aktywuj regułę natychmiast';

  @override
  String get activateRuleImmediatelyDesc =>
      'Gdy wyłączona, reguła nie będzie uruchamiać się automatycznie';

  @override
  String get updateRule => 'Zaktualizuj regułę';

  @override
  String get saveRule => 'Zapisz regułę';

  @override
  String get selectCloudProvider => 'Wybierz dostawcę';

  @override
  String get cloudAccountName => 'Nazwa konta';

  @override
  String get cloudAccountNameHint => 'np. Mój dysk prywatny';

  @override
  String get enterNameError => 'Wprowadź nazwę konta';

  @override
  String get noSpacesOrColons =>
      'Nazwa nie może zawierać spacji ani dwukropków';

  @override
  String get oauthMode => 'Tryb uwierzytelniania OAuth';

  @override
  String get oauthOfficial => 'Oficjalna aplikacja (Zalecane)';

  @override
  String get oauthRclone => 'Domyślne Rclone';

  @override
  String get oauthCustom => 'Własny Client ID i Secret';

  @override
  String get officialOauthTitle => 'Oficjalne OAuth UnifyCloud';

  @override
  String get officialOauthDesc =>
      'Używa oficjalnych poświadczeń API do szybkiej i bezpiecznej konfiguracji w przeglądarce.';

  @override
  String get rcloneOauthDesc =>
      'Używa domyślnych publicznych poświadczeń Rclone. Może podlegać globalnym limitom API.';

  @override
  String get customClientId => 'Własny identyfikator klienta';

  @override
  String get customClientSecret => 'Własny sekret klienta';

  @override
  String get selectVaultDestination => 'Wybierz docelową chmurę dla skarbca';

  @override
  String get vaultPasswordRequired => 'Wprowadź hasło do skarbca';

  @override
  String get vaultPasswordsDoNotMatch => 'Hasła nie są identyczne';

  @override
  String errorAddingRemote(String error) {
    return 'Błąd podczas dodawania konta: $error';
  }

  @override
  String get fileNameEncryption => 'Szyfrowanie nazw plików';

  @override
  String get encryptStandard => 'Standardowe (Zalecane – pełne szyfrowanie)';

  @override
  String get encryptObscure => 'Zaciemnianie (Obfuscate)';

  @override
  String get encryptOff => 'Wyłączone (pozostaw czytelne nazwy)';

  @override
  String get encryptFolderNames => 'Szyfruj nazwy folderów';

  @override
  String get encryptFolderNamesDesc =>
      'Ukrywa również nazwy folderów wewnątrz skarbca';

  @override
  String get connectCloud => 'Połącz chmurę';

  @override
  String get reopenAuth => 'Otwórz ponownie autoryzację w przeglądarce';

  @override
  String get linkCopiedToClipboard => 'Link skopiowano do schowka';

  @override
  String errorOpenBrowserGeneric(String error) {
    return 'Nie można otworzyć przeglądarki: $error';
  }

  @override
  String get shareableLinkTitle => 'Link do udostępnienia:';

  @override
  String shareLinkAccessDescription(String item) {
    return 'Każdy, kto ma ten link, uzyska dostęp do $item:';
  }

  @override
  String get open => 'Otwórz';

  @override
  String activeTransfersCount(int count) {
    return '$count aktywnych transferów';
  }

  @override
  String transfersQueueCount(int count) {
    return 'Kolejka transferów ($count)';
  }

  @override
  String get noTransfersInProgress => 'Brak aktywnych transferów';

  @override
  String get transfersEmptySubtitle =>
      'Transfery plików będą widoczne tutaj w czasie rzeczywistym.';

  @override
  String get cancelled => 'Anulowano';

  @override
  String get appLockedTitle => 'Aplikacja zablokowana';

  @override
  String get unlockWithBiometrics => 'Odblokuj biometrią';

  @override
  String get pinMustBe6Digits => 'Kod PIN musi mieć co najmniej 4 cyfry';

  @override
  String get pinIncorrect => 'Nieprawidłowy PIN';

  @override
  String get pinsDoNotMatch => 'Kody PIN nie są zgodne. Spróbuj ponownie.';

  @override
  String get pinStepOld => 'Wprowadź bieżący PIN';

  @override
  String get pinStepNew => 'Wprowadź nowy PIN';

  @override
  String get pinStepConfirm => 'Potwierdź nowy PIN';

  @override
  String get pinStepVerify => 'Wprowadź swój PIN';

  @override
  String get pinTitleSetup => 'Ustaw kod PIN aplikacji';

  @override
  String get pinTitleChange => 'Zmień PIN';

  @override
  String get pinTitleVerify => 'Wymagany PIN';

  @override
  String get pinContinue => 'Kontynuuj';

  @override
  String get errorDetails => 'Szczegóły błędu';

  @override
  String get errorDetailsCopied => 'Szczegóły błędu skopiowano do schowka';

  @override
  String get collapse => 'Zwiń';

  @override
  String get expand => 'Rozwiń szczegóły';

  @override
  String get copyError => 'Kopiuj błąd';

  @override
  String get errorNetwork => 'Błąd sieci. Sprawdź połączenie z internetem.';

  @override
  String get errorDiskSpace =>
      'Niewystarczająca ilość miejsca na dysku urządzenia.';

  @override
  String get errorAuthExpired =>
      'Sesja wygasła lub poświadczenia zostały cofnięte. Zaloguj się ponownie.';

  @override
  String get errorNotFound => 'Żądany plik lub folder nie został odnaleziony.';

  @override
  String get errorPermissionDenied =>
      'Odmowa dostępu. Brak wystarczających uprawnień.';

  @override
  String get errorGeneric => 'Wystąpił nieoczekiwany błąd chmury.';
}
