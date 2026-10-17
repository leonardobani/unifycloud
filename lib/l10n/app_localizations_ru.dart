// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'UnifyCloud';

  @override
  String get home => 'Главная';

  @override
  String get explorer => 'Проводник';

  @override
  String get sync => 'Синхронизация';

  @override
  String get settings => 'Настройки';

  @override
  String get cancel => 'Отмена';

  @override
  String get confirm => 'Подтвердить';

  @override
  String get delete => 'Удалить';

  @override
  String get save => 'Сохранить';

  @override
  String get close => 'Закрыть';

  @override
  String get edit => 'Изменить';

  @override
  String get create => 'Создать';

  @override
  String get retry => 'Повторить';

  @override
  String get copy => 'Копировать';

  @override
  String get move => 'Переместить';

  @override
  String get rename => 'Переименовать';

  @override
  String get download => 'Скачать';

  @override
  String get upload => 'Загрузить';

  @override
  String get share => 'Поделиться';

  @override
  String get details => 'Сведения';

  @override
  String get search => 'Поиск';

  @override
  String get change => 'Изменить';

  @override
  String get reset => 'Сбросить';

  @override
  String get done => 'Готово';

  @override
  String get loading => 'Загрузка...';

  @override
  String get success => 'Операция завершена';

  @override
  String get error => 'Ошибка';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get resetDefaultsTooltip => 'Восстановить настройки по умолчанию';

  @override
  String get resetDialogTitle => 'Сброс настроек';

  @override
  String get resetDialogContent =>
      'Сбросить все параметры (тему, язык, папки, отображение) до заводских значений?';

  @override
  String get resetSuccessSnackbar =>
      'Настройки сброшены до значений по умолчанию';

  @override
  String get appearanceAndTheme => 'Внешний вид и тема';

  @override
  String get chooseVisualThemeSubtitle =>
      'Выберите тему оформления интерфейса UnifyCloud:';

  @override
  String get themeSystem => 'Системная';

  @override
  String get themeLight => 'Светлая';

  @override
  String get themeDark => 'Темная';

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
  String get language => 'Язык';

  @override
  String get languageSubtitle => 'Выберите язык интерфейса приложения';

  @override
  String get langEnglish => 'English';

  @override
  String get langItalian => 'Italiano';

  @override
  String get langSystem => 'Системный по умолчанию';

  @override
  String get filesAndExploration => 'Файлы и проводник';

  @override
  String get showHiddenFiles => 'Показывать скрытые файлы';

  @override
  String get showHiddenFilesSubtitle =>
      'Отображать файлы и папки, начинающиеся с точки';

  @override
  String get confirmBeforeDelete => 'Подтверждать удаление';

  @override
  String get confirmBeforeDeleteSubtitle =>
      'Запрашивать подтверждение перед окончательным удалением файлов';

  @override
  String get defaultDownloadFolder => 'Папка загрузки по умолчанию';

  @override
  String get defaultDownloadFolderSystem => 'Системная папка загрузок';

  @override
  String get restoreDefaultPath => 'Восстановить путь по умолчанию';

  @override
  String get customDownloadFolderDialogPrompt =>
      'Выберите папку с помощью системного проводника или укажите путь вручную:';

  @override
  String get folderPath => 'Путь к папке';

  @override
  String get folderPathHint => 'напр. /home/user/Downloads';

  @override
  String get browseWithSystemPicker => 'Обзор в проводнике';

  @override
  String errorOpenPicker(String error) {
    return 'Не удалось открыть системный проводник: $error';
  }

  @override
  String get restoreDefault => 'По умолчанию';

  @override
  String get maxConcurrentTransfers => 'Одновременные передачи';

  @override
  String get maxConcurrentTransfersSubtitle =>
      'Максимальное число параллельных передач файлов';

  @override
  String get dualPaneMode => 'Режим Commander (Две панели)';

  @override
  String get dualPaneModeSubtitle =>
      'Отображать две панели рядом на широких экранах и планшетах';

  @override
  String get communityAndSupport => 'Сообщество и поддержка';

  @override
  String get openSourceDescription =>
      'UnifyCloud — свободное ПО с открытым исходным кодом, созданное для объединения облачных хранилищ без трекеров.';

  @override
  String get supportDeveloper => 'Поддержать разработчика';

  @override
  String get supportDeveloperSubtitle =>
      'Купите кофе, чтобы поддержать независимую разработку';

  @override
  String get viewSourceOnGitLab => 'Код на GitLab';

  @override
  String get viewSourceOnGitLabSubtitle =>
      'Официальный репозиторий, отчеты об ошибках и вклад в проект';

  @override
  String errorOpenBrowser(String url) {
    return 'Не удалось открыть браузер. Репозиторий: $url';
  }

  @override
  String get supportDialogTitle => 'Поддержать UnifyCloud';

  @override
  String get supportDialogDescription1 =>
      'UnifyCloud — бесплатный проект с открытым кодом, предоставляющий полный контроль над облачными файлами.';

  @override
  String get supportDialogDescription2 =>
      'Если приложение оказалось полезным, угостите нас кофе или сделайте пожертвование для развития проекта!';

  @override
  String get supportKofiTitle => 'Купить кофе на Ko-fi';

  @override
  String get supportLiberapayTitle => 'Пожертвовать на Liberapay';

  @override
  String get supportPaypalTitle => 'Пожертвовать через PayPal';

  @override
  String get securityAndEncryption => 'Безопасность и шифрование';

  @override
  String get securityArchitectureDescription =>
      'UnifyCloud использует архитектуру Zero-Plaintext. Все токены OAuth и учетные данные защищены в системном Keychain/Keystore и загружаются только в оперативную память движка Go.';

  @override
  String get appLock => 'Блокировка приложения (PIN / Биометрия)';

  @override
  String get appLockSubtitle =>
      'Требовать PIN-код или отпечаток пальца для входа';

  @override
  String get appLockActiveSubtitle => 'Активна при запуске и после бездействия';

  @override
  String get appLockEnabledSnackbar => 'Блокировка приложения успешно включена';

  @override
  String get appLockDisabledSnackbar => 'Блокировка приложения отключена';

  @override
  String get changePin => 'Сменить PIN-код';

  @override
  String get changePinSubtitle => 'Установить новый 6-значный PIN-код';

  @override
  String get pinChangedSnackbar => 'PIN-код безопасности успешно обновлен';

  @override
  String get biometricAuth => 'Биометрическая аутентификация';

  @override
  String get biometricAuthSubtitle =>
      'Использовать сканер отпечатка пальца или лица, если доступно';

  @override
  String get biometricNotAvailable =>
      'Недоступно или не настроено на устройстве';

  @override
  String get autoLock => 'Автоблокировка';

  @override
  String get autoLockSubtitle =>
      'Таймаут неактивности в фоновом режиме до блокировки';

  @override
  String get lockImmediately => 'Сразу';

  @override
  String get lockAfter1Minute => 'Через 1 минуту';

  @override
  String get lockAfter5Minutes => 'Через 5 минут';

  @override
  String get lockAfter15Minutes => 'Через 15 минут';

  @override
  String get lockAfter30Minutes => 'Через 30 минут';

  @override
  String get syncCloudAccounts => 'Синхронизировать облачные аккаунты';

  @override
  String get syncCloudAccountsSubtitle =>
      'Перезагрузить конфигурации из защищенного хранилища';

  @override
  String get syncCloudAccountsSuccess =>
      'Облачные аккаунты успешно перезагружены';

  @override
  String get clearAllCredentials => 'Очистить все учетные данные';

  @override
  String get clearAllCredentialsSubtitle =>
      'Удаляет зашифрованную конфигурацию и отключает все облака';

  @override
  String get clearCredentialsDialogTitle => 'Внимание: сброс учетных данных';

  @override
  String get clearCredentialsDialogContent =>
      'Вы уверены, что хотите удалить все сохраненные учетные данные? Потребуется повторно подключить аккаунты.';

  @override
  String get clearCredentialsSuccess => 'Учетные данные успешно удалены';

  @override
  String get aboutUnifyCloud => 'О программе UnifyCloud';

  @override
  String get appVersion => 'Версия приложения: 1.0.0';

  @override
  String get developerInfo => 'Разработчик: LeoRise (@leorise25)';

  @override
  String get engineInfo => 'Движок: Rclone Core CGO (Go v1.22+ / C FFI)';

  @override
  String get frameworkInfo => 'Фреймворк: Flutter (Material 3 Responsive)';

  @override
  String get licenseInfo =>
      'Лицензия: GNU General Public License v3.0 (GPL-3.0)';

  @override
  String get copyrightInfo => 'Авторские права: © 2026 Leonardo Bani';

  @override
  String get storageOverview => 'Обзор хранилища';

  @override
  String get connectedClouds => 'Подключенные облака';

  @override
  String get noCloudsConfigured => 'Облачные аккаунты не настроены';

  @override
  String get noCloudsDescription =>
      'Подключите свое первое облачное хранилище для управления и синхронизации файлов.';

  @override
  String get addCloud => 'Добавить облако';

  @override
  String get used => 'занято';

  @override
  String get free => 'свободно';

  @override
  String get total => 'всего';

  @override
  String get manageAccounts => 'Управление аккаунтами';

  @override
  String get viewFiles => 'Просмотр файлов';

  @override
  String get createVaultHere => 'Создать зашифрованное хранилище...';

  @override
  String get disconnectAccount => 'Отключить аккаунт';

  @override
  String get disconnectConfirmTitle => 'Отключить аккаунт?';

  @override
  String get disconnectConfirmContent =>
      'Вы уверены, что хотите отключить этот аккаунт? Файлы в облаке останутся нетронутыми.';

  @override
  String get allFiles => 'Все файлы';

  @override
  String get emptyFolder => 'Эта папка пуста';

  @override
  String get emptyFolderSubtitle => 'Загрузите файлы или создайте подпапку.';

  @override
  String get uploadFile => 'Загрузить файл';

  @override
  String get uploadFolder => 'Загрузить всю папку';

  @override
  String get newFolder => 'Новая папка';

  @override
  String get newFolderPrompt => 'Введите имя новой папки:';

  @override
  String get folderNameHint => 'Имя папки';

  @override
  String get selectAll => 'Выбрать все';

  @override
  String get clearSelection => 'Снять выбор';

  @override
  String get deleteSelected => 'Удалить выбранные';

  @override
  String get deleteSelectedPrompt =>
      'Вы действительно хотите удалить выбранные элементы?';

  @override
  String get deleteItemPrompt =>
      'Вы действительно хотите удалить этот элемент?';

  @override
  String get shareLink => 'Ссылка для общего доступа';

  @override
  String get createShareLink => 'Создать общую ссылку';

  @override
  String get copyShareLink => 'Копировать ссылку';

  @override
  String get copiedToClipboard => 'Скопировано в буфер обмена';

  @override
  String get transfers => 'Передачи';

  @override
  String get activeTransfers => 'Активные передачи';

  @override
  String get completed => 'Завершено';

  @override
  String get failed => 'Ошибка';

  @override
  String get queued => 'В очереди';

  @override
  String get cancelTransfer => 'Отменить передачу';

  @override
  String get clearCompleted => 'Очистить завершенные';

  @override
  String get syncRulesTitle => 'Правила бэкапа и синхронизации';

  @override
  String get newRule => 'Новое правило';

  @override
  String get noSyncRules => 'Правила синхронизации не настроены';

  @override
  String get noSyncRulesSubtitle =>
      'Создайте автоматическое правило для синхронизации локальных папок с облаком.';

  @override
  String get ruleName => 'Имя правила';

  @override
  String get sourcePath => 'Исходная папка';

  @override
  String get destinationCloud => 'Целевое облако';

  @override
  String get destinationPath => 'Удаленный путь';

  @override
  String get direction => 'Направление';

  @override
  String get frequency => 'Частота';

  @override
  String get runNow => 'Запустить сейчас';

  @override
  String get syncInProgress => 'Синхронизация...';

  @override
  String get syncSuccess => 'Синхронизация завершена';

  @override
  String get syncFailed => 'Синхронизация не удалась';

  @override
  String get addCloudDialogTitle => 'Подключить новое облако';

  @override
  String get selectProvider => 'Выбрать провайдера облака';

  @override
  String get accountNameLabel => 'Имя аккаунта / Псевдоним';

  @override
  String get connectButton => 'Подключить аккаунт';

  @override
  String get vaultTitle => 'Сквозное шифрование (Crypt)';

  @override
  String get vaultPassword => 'Пароль хранилища';

  @override
  String get vaultConfirmPassword => 'Подтверждение пароля';

  @override
  String get vaultSalt => 'Salt / Дополнительный пароль (Опционально)';

  @override
  String get encryptFileNames => 'Шифровать имена файлов';

  @override
  String get encryptDirNames => 'Шифровать имена папок';

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
  String get selectLanguage => 'Выбор языка';

  @override
  String get searchLanguageHint => 'Поиск языка или страны...';

  @override
  String get currentLanguage => 'Текущий язык';

  @override
  String systemDefaultWithLocale(String locale) {
    return 'Системный по умолчанию ($locale)';
  }

  @override
  String get refreshCloudsTooltip => 'Обновить список облаков';

  @override
  String get storageOverviewAggregated => 'Сводный обзор хранилища';

  @override
  String get ramEncryptionActive => 'Шифрование RAM активно';

  @override
  String connectedAccountsCount(int count) {
    return 'Подключено облачных аккаунтов: $count';
  }

  @override
  String get noCloudsConfiguredHint =>
      'Облачные аккаунты не настроены. Нажмите «+ Подключить новое облако» ниже.';

  @override
  String percentUsed(String percent) {
    return '$percent% занято';
  }

  @override
  String availableSpace(String space) {
    return '$space доступно';
  }

  @override
  String get calculatingQuota =>
      'Расчет квоты хранилища или неограниченное место...';

  @override
  String get syncAndBackup => 'Синхронизация и бэкап';

  @override
  String get noRulesConfigured => 'Правила не настроены';

  @override
  String activeRulesCount(int active, int total) {
    return '$active/$total активных правил';
  }

  @override
  String get manage => 'Управление';

  @override
  String connectedCloudsCount(int count) {
    return 'Подключенные облака ($count)';
  }

  @override
  String get connectNewCloud => 'Подключить новое облако';

  @override
  String get noCloudProvidersConnected =>
      'Нет подключенных облачных провайдеров';

  @override
  String get connectCloudDescription =>
      'Подключите Google Drive, Dropbox, OneDrive, SFTP или WebDAV для синхронизации и навигации по файлам.';

  @override
  String get addFirstCloud => 'Добавить первое облако';

  @override
  String vaultOnRemote(String remote) {
    return 'ХРАНИЛИЩЕ НА $remote';
  }

  @override
  String get disconnectCloudTitle => 'Отключить облако';

  @override
  String disconnectCloudPrompt(String name) {
    return 'Отключить «$name»? Учетные данные будут удалены из защищенного хранилища.';
  }

  @override
  String get disconnect => 'Отключить';

  @override
  String freeSpace(String space) {
    return '$space свободно';
  }

  @override
  String get storage => 'Хранилище';

  @override
  String get available => 'Доступно';

  @override
  String get exploreFiles => 'Обзор файлов';

  @override
  String get paneLeft => 'Левая панель';

  @override
  String get paneRight => 'Правая панель';

  @override
  String get folderName => 'Имя папки';

  @override
  String errorCreatingFolder(String error) {
    return 'Ошибка создания папки: $error';
  }

  @override
  String get moveAction => 'Перемещение';

  @override
  String get copyAction => 'Копирование';

  @override
  String transferBatchStarted(String action, int count, String remote) {
    return '$action $count элементов в [$remote] начато...';
  }

  @override
  String errorTransferring(String error) {
    return 'Ошибка во время передачи: $error';
  }

  @override
  String itemCopiedToClipboard(String name) {
    return '«$name» скопировано в буфер обмена';
  }

  @override
  String itemsCopiedToClipboard(int count) {
    return '$count элементов скопировано в буфер обмена';
  }

  @override
  String itemCutToClipboard(String name) {
    return '«$name» вырезано (готово к перемещению)';
  }

  @override
  String itemsCutToClipboard(int count) {
    return '$count элементов вырезано (готово к перемещению)';
  }

  @override
  String get noFilesSelectedForDownload => 'Файлы для скачивания не выбраны.';

  @override
  String downloadingItems(int count) {
    return 'Скачивание $count элементов...';
  }

  @override
  String itemsDownloadedSuccess(int count, String path) {
    return '$count элементов успешно скачано в «$path»';
  }

  @override
  String errorStartingDownload(String error) {
    return 'Ошибка запуска скачивания: $error';
  }

  @override
  String deleteItemsConfirmTitle(int count) {
    return 'Удалить $count выбранных элементов?';
  }

  @override
  String deleteItemsConfirmPrompt(int count) {
    return 'Окончательно удалить $count выбранных элементов из облака?';
  }

  @override
  String itemsDeletedSuccess(int count) {
    return '$count элементов удалено';
  }

  @override
  String errorDeleting(String error) {
    return 'Ошибка удаления: $error';
  }

  @override
  String get uploadCompletedSuccess => 'Загрузка успешно завершена';

  @override
  String errorUploading(String error) {
    return 'Ошибка загрузки: $error';
  }

  @override
  String get folderUploadCompletedSuccess => 'Папка успешно загружена';

  @override
  String errorFolderUploading(String error) {
    return 'Ошибка загрузки папки: $error';
  }

  @override
  String get filesAlreadyInDirectory => 'Файлы уже находятся в этой папке.';

  @override
  String dragDropTransferStarted(String action, int count, String remote) {
    return '$action $count элементов в [$remote] начато...';
  }

  @override
  String errorDragDrop(String error) {
    return 'Ошибка передачи drag-and-drop: $error';
  }

  @override
  String get closeSelection => 'Закрыть выбор';

  @override
  String itemsSelectedCount(int count) {
    return '$count выбрано';
  }

  @override
  String get deselectAll => 'Снять выбор со всех';

  @override
  String copyToRemote(String remote) {
    return 'Копировать в $remote';
  }

  @override
  String moveToRemote(String remote) {
    return 'Переместить в $remote';
  }

  @override
  String get moreActions => 'Другие действия';

  @override
  String get downloadSelected => 'Скачать выбранные';

  @override
  String get copyToClipboard => 'Копировать в буфер';

  @override
  String get cutToClipboard => 'Вырезать в буфер';

  @override
  String get selectCloud => 'Выбрать облако';

  @override
  String get closeSearch => 'Закрыть поиск';

  @override
  String get uploadFromDevice => 'Загрузить с устройства';

  @override
  String get moreOptions => 'Еще параметры';

  @override
  String get viewGrid => 'Сетка';

  @override
  String get viewList => 'Список';

  @override
  String get multiSelection => 'Множественный выбор';

  @override
  String get sortNameAsc => 'Имя (А-Я)';

  @override
  String get sortNameDesc => 'Имя (Я-А)';

  @override
  String get sortSizeDesc => 'Размер (По убыванию)';

  @override
  String get sortSizeAsc => 'Размер (По возрастанию)';

  @override
  String get sortDateDesc => 'Дата (Сначала новые)';

  @override
  String get disableDualPane => 'Отключить Commander (Одна панель)';

  @override
  String get enableDualPane => 'Включить Commander (Две панели)';

  @override
  String itemsInClipboard(int count) {
    return '$count элементов в буфере обмена';
  }

  @override
  String get pasteHere => 'Вставить сюда';

  @override
  String get noResults => 'Нет результатов';

  @override
  String noMatchingResults(String query) {
    return 'Нет файлов или папок, соответствующих «$query»';
  }

  @override
  String get selectACloud => 'Выберите облако';

  @override
  String get selectCloudDescription =>
      'Выберите облачного провайдера в меню выше для навигации по файлам.';

  @override
  String optionsForItem(String name) {
    return 'Параметры для $name';
  }

  @override
  String get select => 'Выбрать';

  @override
  String get openWithSystemApp => 'Открыть системным приложением';

  @override
  String get downloadToLocal => 'Скачать на устройство';

  @override
  String get cut => 'Вырезать (Переместить)';

  @override
  String get copyPath => 'Копировать путь';

  @override
  String get info => 'Информация';

  @override
  String generatingShareLink(String name) {
    return 'Создание ссылки для «$name»...';
  }

  @override
  String errorPublicLink(String error) {
    return 'Ошибка публичной ссылки: $error';
  }

  @override
  String get noLinkGenerated => 'Провайдер не вернул ссылку.';

  @override
  String errorDownloading(String error) {
    return 'Ошибка скачивания: $error';
  }

  @override
  String get renameFolderTitle => 'Переименовать папку';

  @override
  String get renameFileTitle => 'Переименовать файл';

  @override
  String errorRenaming(String error) {
    return 'Ошибка переименования: $error';
  }

  @override
  String get pathCopiedToClipboard => 'Путь скопирован в буфер обмена';

  @override
  String itemDetailsPath(String path) {
    return 'Путь: $path';
  }

  @override
  String itemDetailsType(String type) {
    return 'Тип: $type';
  }

  @override
  String itemDetailsSize(String size) {
    return 'Размер: $size';
  }

  @override
  String itemDetailsModified(String date) {
    return 'Дата изменения: $date';
  }

  @override
  String get folder => 'Папка';

  @override
  String get file => 'Файл';

  @override
  String get selectCloudFirstLeft => 'Сначала выберите облако на левой панели.';

  @override
  String get selectCloudFirstRight =>
      'Сначала выберите облако на правой панели.';

  @override
  String get selectDestinationCloudLeft =>
      'Сначала выберите целевое облако на левой панели.';

  @override
  String get selectDestinationCloudRight =>
      'Сначала выберите целевое облако на правой панели.';

  @override
  String get noFilesToTransfer => 'Нет файлов для передачи.';

  @override
  String transferStarted(String action, int count, String src, String dst) {
    return '$action $count элементов из [$src] в [$dst] начато...';
  }

  @override
  String get swapPanesTooltip => 'Поменять панели местами (<->)';

  @override
  String get refreshBothPanesTooltip => 'Обновить обе панели';

  @override
  String get copyRight => 'Копировать вправо ->';

  @override
  String get moveRight => 'Переместить вправо ->';

  @override
  String get copyLeft => '<- Копировать влево';

  @override
  String get moveLeft => '<- Переместить влево';

  @override
  String copyRightWithCount(int count) {
    return 'Копировать вправо ($count) ->';
  }

  @override
  String moveRightWithCount(int count) {
    return 'Переместить вправо ($count) ->';
  }

  @override
  String copyLeftWithCount(int count) {
    return '<- Копировать влево ($count)';
  }

  @override
  String moveLeftWithCount(int count) {
    return '<- Переместить влево ($count)';
  }

  @override
  String get deleteRuleTitle => 'Удалить правило';

  @override
  String deleteRulePrompt(String name) {
    return 'Удалить правило синхронизации «$name»? Файлы на устройстве и в облаке сохранятся.';
  }

  @override
  String get syncAll => 'Синхронизировать все';

  @override
  String get newRuleTooltip => 'Новое правило';

  @override
  String get backupBannerTitle => 'Постоянный бэкап и облачная синхронизация';

  @override
  String get backupBannerSubtitle =>
      'Настройте синхронизацию по расписанию между локальными и облачными папками.';

  @override
  String get noActiveRules => 'Нет активных правил';

  @override
  String get noActiveRulesSubtitle =>
      'Создайте первое правило для автоматического бэкапа с устройства в Google Drive, Dropbox, SFTP или другое облако.';

  @override
  String get createNewRule => 'Создать правило';

  @override
  String get ruleOptionsTooltip => 'Параметры правила';

  @override
  String get syncNow => 'Синхронизировать сейчас';

  @override
  String get statusWaiting => 'В ожидании';

  @override
  String get statusInProgress => 'Выполняется...';

  @override
  String get statusCompleted => 'Завершено';

  @override
  String get statusFailed => 'Ошибка';

  @override
  String get editRuleTitle => 'Редактировать правило бэкапа';

  @override
  String get newRuleTitle => 'Новое правило синхронизации';

  @override
  String get ruleDialogSubtitle =>
      'Настройте автоматический бэкап между локальной папкой и облаком.';

  @override
  String get ruleNameOptional => 'Имя правила (необязательно)';

  @override
  String get ruleNameHint => 'напр. Бэкап фото DCIM или Рабочие документы';

  @override
  String get sourceLocalFolder => 'Исходная локальная папка';

  @override
  String get sourceLocalFolderHint =>
      '/storage/emulated/0/DCIM или /home/user/Pictures';

  @override
  String get browseFolders => 'Обзор папок';

  @override
  String get selectLocalFolderError => 'Введите или выберите локальную папку';

  @override
  String get noCloudsConfiguredSync =>
      'Облака не настроены. Добавьте аккаунт на Главной перед продолжением.';

  @override
  String get remoteDestinationPath => 'Целевой удаленный путь';

  @override
  String get syncMode => 'Режим синхронизации';

  @override
  String get syncModeCopy => 'Инкрементный бэкап';

  @override
  String get syncModeCopyDesc =>
      'Загружает новые и измененные файлы, сохраняя существующие файлы в облаке.';

  @override
  String get syncModeSync => 'Зеркальная синхронизация';

  @override
  String get syncModeSyncDesc =>
      'Делает облачную папку идентичной локальной (удаленные локально файлы удаляются из облака).';

  @override
  String get syncFrequency => 'Частота выполнения';

  @override
  String get freqManual => 'Вручную (только по запросу)';

  @override
  String get freq15Min => 'Каждыми 15 минут';

  @override
  String get freq30Min => 'Каждыми 30 минут';

  @override
  String get freqHourly => 'Каждый час';

  @override
  String get freq6Hours => 'Каждые 6 часов';

  @override
  String get freq12Hours => 'Каждые 12 часов';

  @override
  String get freqDaily => 'Каждый день (24 часа)';

  @override
  String get activateRuleImmediately => 'Активировать правило сразу';

  @override
  String get activateRuleImmediatelyDesc =>
      'Синхронизация будет выполняться в фоне с указанным интервалом';

  @override
  String get updateRule => 'Обновить';

  @override
  String get saveRule => 'Сохранить правило';

  @override
  String get selectCloudProvider => 'Выберите облачного провайдера:';

  @override
  String get cloudAccountName => 'Имя облачного аккаунта';

  @override
  String get cloudAccountNameHint =>
      'напр. GoogleDrive, WorkDropbox (без пробелов)';

  @override
  String get enterNameError => 'Пожалуйста, введите имя';

  @override
  String get noSpacesOrColons => 'Пробелы и знаки «:» запрещены';

  @override
  String get oauthMode => 'Режим Client ID (OAuth2)';

  @override
  String get oauthOfficial => 'UnifyCloud (Официальный / Рекомендуемый)';

  @override
  String get oauthRclone => 'Rclone (Не рекомендуется - общий лимит)';

  @override
  String get oauthCustom => 'Личный Client ID (Расширенный)';

  @override
  String get officialOauthTitle => 'Официальные учетные данные UnifyCloud';

  @override
  String get officialOauthDesc =>
      'Предустановленные ключи для быстрого подключения с выделенной квотой и высокой скоростью.';

  @override
  String get rcloneOauthDesc =>
      'Общие открытые ключи Rclone. Возможны лимиты запросов или ошибки 403 от Google.';

  @override
  String get customClientId => 'Client ID';

  @override
  String get customClientSecret => 'Client Secret';

  @override
  String get selectVaultDestination => 'Выберите облако для создания хранилища';

  @override
  String get vaultPasswordRequired => 'Пароль шифрования обязателен';

  @override
  String get vaultPasswordsDoNotMatch => 'Пароли не совпадают';

  @override
  String errorAddingRemote(String error) {
    return 'Ошибка добавления облака: $error';
  }

  @override
  String get fileNameEncryption => 'Шифрование имен файлов';

  @override
  String get encryptStandard =>
      'Стандартное (Полное шифрование имен - Рекомендуется)';

  @override
  String get encryptObscure => 'Простое сокрытие (С сохранением расширений)';

  @override
  String get encryptOff => 'Отключено (Имена в открытом виде)';

  @override
  String get encryptFolderNames => 'Шифровать также имена папок';

  @override
  String get encryptFolderNamesDesc =>
      'Полностью скрывает структуру каталогов в облаке';

  @override
  String get connectCloud => 'Подключить облако';

  @override
  String get reopenAuth => 'Открыть снова';

  @override
  String get linkCopiedToClipboard => 'Ссылка скопирована в буфер обмена!';

  @override
  String errorOpenBrowserGeneric(String error) {
    return 'Не удалось открыть браузер: $error';
  }

  @override
  String get shareableLinkTitle => 'Ссылка для общего доступа';

  @override
  String shareLinkAccessDescription(String item) {
    return 'Любой пользователь с этой ссылкой получит доступ к $item:';
  }

  @override
  String get open => 'Открыть';

  @override
  String activeTransfersCount(int count) {
    return '$count активных передач';
  }

  @override
  String transfersQueueCount(int count) {
    return 'Очередь передач ($count)';
  }

  @override
  String get noTransfersInProgress => 'Нет активных передач';

  @override
  String get transfersEmptySubtitle =>
      'Здесь будут отображаться все скачиваемые и отправляемые файлы';

  @override
  String get cancelled => 'Отменено';

  @override
  String get appLockedTitle => 'Приложение заблокировано';

  @override
  String get unlockWithBiometrics => 'Разблокировать по биометрии';

  @override
  String get pinMustBe6Digits => 'PIN-код должен состоять ровно из 6 цифр';

  @override
  String get pinIncorrect => 'Неверный PIN-код. Повторите попытку.';

  @override
  String get pinsDoNotMatch => 'PIN-коды не совпадают. Повторите попытку.';

  @override
  String get pinStepOld => 'Введите текущий PIN-код для продолжения.';

  @override
  String get pinStepNew => 'Введите новый 6-значный PIN-код безопасности.';

  @override
  String get pinStepConfirm =>
      'Повторите ввод нового PIN-кода для подтверждения.';

  @override
  String get pinStepVerify => 'Введите PIN-код для подтверждения операции.';

  @override
  String get pinTitleSetup => 'Настройка PIN-кода безопасности';

  @override
  String get pinTitleChange => 'Изменение PIN-кода безопасности';

  @override
  String get pinTitleVerify => 'Проверка безопасности';

  @override
  String get pinContinue => 'Продолжить';

  @override
  String get errorDetails => 'Сведения об ошибке';

  @override
  String get errorDetailsCopied =>
      'Сведения об ошибке скопированы в буфер обмена';

  @override
  String get collapse => 'Свернуть';

  @override
  String get expand => 'Развернуть';

  @override
  String get copyError => 'Копировать ошибку';

  @override
  String get errorNetwork =>
      'Соединение отсутствует или нестабильно. Проверьте подключение к интернету.';

  @override
  String get errorDiskSpace =>
      'Недостаточно места на диске. Освободите память для продолжения.';

  @override
  String get errorAuthExpired =>
      'Сессия или токен истекли/отозваны. Подключите аккаунт заново.';

  @override
  String get errorNotFound => 'Элемент или папка не найдены на облачном диске.';

  @override
  String get errorPermissionDenied =>
      'В доступе отказано для этой операции в облаке.';

  @override
  String get errorGeneric => 'Произошла ошибка во время операции.';

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
