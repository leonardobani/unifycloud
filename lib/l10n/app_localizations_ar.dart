// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'UnifyCloud';

  @override
  String get home => 'الرئيسية';

  @override
  String get explorer => 'المستكشف';

  @override
  String get sync => 'المزامنة';

  @override
  String get settings => 'الإعدادات';

  @override
  String get cancel => 'إلغاء';

  @override
  String get confirm => 'تأكيد';

  @override
  String get delete => 'حذف';

  @override
  String get save => 'حفظ';

  @override
  String get close => 'إغلاق';

  @override
  String get edit => 'تعديل';

  @override
  String get create => 'إنشاء';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get copy => 'نسخ';

  @override
  String get move => 'نقل';

  @override
  String get rename => 'إعادة تسمية';

  @override
  String get download => 'تنزيل';

  @override
  String get upload => 'رفع';

  @override
  String get share => 'مشاركة';

  @override
  String get details => 'التفاصيل';

  @override
  String get search => 'بحث';

  @override
  String get change => 'تغيير';

  @override
  String get reset => 'إعادة تعيين';

  @override
  String get done => 'تم';

  @override
  String get loading => 'جار التحميل...';

  @override
  String get success => 'اكتملت العملية';

  @override
  String get error => 'خطأ';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get resetDefaultsTooltip => 'استعادة الإعدادات الافتراضية';

  @override
  String get resetDialogTitle => 'إعادة تعيين الإعدادات';

  @override
  String get resetDialogContent =>
      'هل ترغب في إعادة تعيين كافة التفضيلات (المظهر، اللغة، المجلدات، العرض) إلى الإعدادات الافتراضية؟';

  @override
  String get resetSuccessSnackbar => 'تمت استعادة الإعدادات الافتراضية';

  @override
  String get appearanceAndTheme => 'المظهر والسمة';

  @override
  String get chooseVisualThemeSubtitle => 'اختر سمة الواجهة لتطبيق UnifyCloud:';

  @override
  String get themeSystem => 'النظام';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get language => 'اللغة';

  @override
  String get languageSubtitle => 'تحديد لغة واجهة التطبيق';

  @override
  String get langEnglish => 'English';

  @override
  String get langItalian => 'Italiano';

  @override
  String get langSystem => 'افتراضي النظام';

  @override
  String get filesAndExploration => 'الملفات والاستكشاف';

  @override
  String get showHiddenFiles => 'إظهار الملفات المخفية';

  @override
  String get showHiddenFilesSubtitle => 'عرض الملفات والمجلدات التي تبدأ بنقطة';

  @override
  String get confirmBeforeDelete => 'التأكيد قبل الحذف';

  @override
  String get confirmBeforeDeleteSubtitle =>
      'طلب تأكيد أمان قبل حذف الملفات نهائياً';

  @override
  String get defaultDownloadFolder => 'مجلد التنزيل الافتراضي';

  @override
  String get defaultDownloadFolderSystem => 'دليل التنزيلات الافتراضي للنظام';

  @override
  String get restoreDefaultPath => 'استعادة المسار الافتراضي';

  @override
  String get customDownloadFolderDialogPrompt =>
      'حدد مجلداً باستخدام منتقي النظام أو أدخل المسار يدوياً:';

  @override
  String get folderPath => 'مسار المجلد';

  @override
  String get folderPathHint => 'مثال: /home/user/Downloads';

  @override
  String get browseWithSystemPicker => 'تصفح عبر منتقي النظام';

  @override
  String errorOpenPicker(String error) {
    return 'تعذر فتح منتقي النظام: $error';
  }

  @override
  String get restoreDefault => 'استعادة الافتراضي';

  @override
  String get maxConcurrentTransfers => 'عمليات النقل المتزامنة';

  @override
  String get maxConcurrentTransfersSubtitle =>
      'أقصى عدد لنقل الملفات النشطة في وقت واحد';

  @override
  String get dualPaneMode => 'وضع Commander (لوحتان)';

  @override
  String get dualPaneModeSubtitle =>
      'عرض لوحتين متجاورتين على الشاشات الكبيرة والأجهزة اللوحية';

  @override
  String get communityAndSupport => 'المجتمع والدعم';

  @override
  String get openSourceDescription =>
      'UnifyCloud هو برنامج حر ومفتوح المصدر صُمم لتوحيد بياناتك السحابية دون برامج تتبع أو وسطاء احتكاريين.';

  @override
  String get supportDeveloper => 'دعم المطور';

  @override
  String get supportDeveloperSubtitle => 'اشترِ قهوة لدعم التطوير المستقل';

  @override
  String get viewSourceOnGitLab => 'عرض الكود على GitLab';

  @override
  String get viewSourceOnGitLabSubtitle =>
      'المستودع الرسمي، وتقارير الأخطاء، والمساهمات';

  @override
  String errorOpenBrowser(String url) {
    return 'تعذر فتح المتصفح. المستودع: $url';
  }

  @override
  String get supportDialogTitle => 'دعم UnifyCloud';

  @override
  String get supportDialogDescription1 =>
      'UnifyCloud هو مشروع مجاني ومفتوح المصدر يمنحك التحكم الكامل في ملفاتك السحابية.';

  @override
  String get supportDialogDescription2 =>
      'إذا كان هذا التطبيق مفيداً لك، فكر في دعم التطوير المستمر عبر تقديم تبرع أو شراء قهوة!';

  @override
  String get supportKofiTitle => 'شراء قهوة عبر Ko-fi';

  @override
  String get supportLiberapayTitle => 'التبرع عبر Liberapay';

  @override
  String get supportPaypalTitle => 'التبرع عبر PayPal';

  @override
  String get securityAndEncryption => 'الأمان والتشفير';

  @override
  String get securityArchitectureDescription =>
      'يعتمد UnifyCloud بنية انعدام النص الصريح. جميع رموز OAuth وبيانات الاعتماد محمية في Keychain/Keystore النظام وتُحقن في ذاكرة RAM لمحرك Go فقط.';

  @override
  String get appLock => 'قفل التطبيق (PIN / البصمة)';

  @override
  String get appLockSubtitle => 'طلب رمز PIN أو بصمة الإصبع للدخول';

  @override
  String get appLockActiveSubtitle => 'نشط عند بدء التشغيل وبعد فترة الخمول';

  @override
  String get appLockEnabledSnackbar => 'تم تفعيل قفل التطبيق بنجاح';

  @override
  String get appLockDisabledSnackbar => 'تم تعطيل قفل التطبيق';

  @override
  String get changePin => 'تغيير رمز PIN';

  @override
  String get changePinSubtitle => 'تعيين رمز PIN أمان جديد من 6 أرقام';

  @override
  String get pinChangedSnackbar => 'تم تحديث رمز PIN الأمان بنجاح';

  @override
  String get biometricAuth => 'المصادقة الحيوية';

  @override
  String get biometricAuthSubtitle =>
      'استخدام بصمة الإصبع أو التعرف على الوجه إن توفر';

  @override
  String get biometricNotAvailable => 'غير متوفر أو غير مهيأ على هذا الجهاز';

  @override
  String get autoLock => 'القفل التلقائي';

  @override
  String get autoLockSubtitle => 'مهلة الخمول في الخلفية قبل الإغلاق';

  @override
  String get lockImmediately => 'فوراً';

  @override
  String get lockAfter1Minute => 'بعد دقيقة واحدة';

  @override
  String get lockAfter5Minutes => 'بعد 5 دقائق';

  @override
  String get lockAfter15Minutes => 'بعد 15 دقيقة';

  @override
  String get lockAfter30Minutes => 'بعد 30 دقيقة';

  @override
  String get syncCloudAccounts => 'مزامنة الحسابات السحابية';

  @override
  String get syncCloudAccountsSubtitle =>
      'إعادة تحميل الإعدادات من التخزين الآمن';

  @override
  String get syncCloudAccountsSuccess =>
      'تمت إعادة تحميل الحسابات السحابية بنجاح';

  @override
  String get clearAllCredentials => 'مسح كافة بيانات الاعتماد';

  @override
  String get clearAllCredentialsSubtitle =>
      'إزالة التهيئة المشفرة وفصل جميع السحب المتصلة';

  @override
  String get clearCredentialsDialogTitle =>
      'تحذير: إعادة تعيين بيانات الاعتماد';

  @override
  String get clearCredentialsDialogContent =>
      'هل أنت متأكد من رغبتك في حذف كافة بيانات الاعتماد المحفوظة؟ سيتعين عليك إعادة ربط حساباتك.';

  @override
  String get clearCredentialsSuccess => 'تم حذف بيانات الاعتماد بنجاح';

  @override
  String get aboutUnifyCloud => 'حول UnifyCloud';

  @override
  String get appVersion => 'إصدار التطبيق: 1.0.1';

  @override
  String get developerInfo => 'المطور: Leonardo Bani (@leonardobani)';

  @override
  String get engineInfo => 'المحرك: Rclone Core CGO (Go v1.22+ / C FFI)';

  @override
  String get frameworkInfo => 'إطار العمل: Flutter (Material 3 متجاوب)';

  @override
  String get licenseInfo => 'الترخيص: رخصة جنو العمومية الإصدار 3.0 (GPL-3.0)';

  @override
  String get copyrightInfo => 'حقوق النشر: © 2026 Leonardo Bani';

  @override
  String get storageOverview => 'نظرة عامة على التخزين';

  @override
  String get connectedClouds => 'السحب المتصلة';

  @override
  String get noCloudsConfigured => 'لا توجد حسابات سحابية مهيأة';

  @override
  String get noCloudsDescription =>
      'اربط حساب التخزين السحابي الأول للبدء في إدارة الملفات ومزامنتها.';

  @override
  String get addCloud => 'إضافة سحابة';

  @override
  String get used => 'مستخدم';

  @override
  String get free => 'فارغ';

  @override
  String get total => 'الإجمالي';

  @override
  String get manageAccounts => 'إدارة الحسابات';

  @override
  String get viewFiles => 'عرض الملفات';

  @override
  String get createVaultHere => 'إنشاء خزينة مشفرة هنا...';

  @override
  String get disconnectAccount => 'فصل الحساب';

  @override
  String get disconnectConfirmTitle => 'فصل الحساب؟';

  @override
  String get disconnectConfirmContent =>
      'هل أنت متأكد من فصل هذا الحساب؟ ستبقى الملفات البعيدة كما هي دون حذف.';

  @override
  String get allFiles => 'كافة الملفات';

  @override
  String get emptyFolder => 'هذا المجلد فارغ';

  @override
  String get emptyFolderSubtitle => 'ارفع ملفات أو أنشئ مجلداً فرعياً للبدء.';

  @override
  String get uploadFile => 'رفع ملف';

  @override
  String get uploadFolder => 'رفع مجلد كامل';

  @override
  String get newFolder => 'مجلد جديد';

  @override
  String get newFolderPrompt => 'أدخل اسم المجلد الجديد:';

  @override
  String get folderNameHint => 'اسم المجلد';

  @override
  String get selectAll => 'تحديد الكل';

  @override
  String get clearSelection => 'إلغاء التحديد';

  @override
  String get deleteSelected => 'حذف المحدد';

  @override
  String get deleteSelectedPrompt => 'هل أنت متأكد من حذف العناصر المحددة؟';

  @override
  String get deleteItemPrompt => 'هل أنت متأكد من حذف هذا العنصر؟';

  @override
  String get shareLink => 'مشاركة الرابط';

  @override
  String get createShareLink => 'إنشاء رابط للمشاركة';

  @override
  String get copyShareLink => 'نسخ الرابط';

  @override
  String get copiedToClipboard => 'تم النسخ إلى الحافظة';

  @override
  String get transfers => 'التحويلات';

  @override
  String get activeTransfers => 'التحويلات النشطة';

  @override
  String get completed => 'مكتمل';

  @override
  String get failed => 'فاشل';

  @override
  String get queued => 'في قائمة الانتظار';

  @override
  String get cancelTransfer => 'إلغاء النقل';

  @override
  String get clearCompleted => 'مسح المكتمل';

  @override
  String get syncRulesTitle => 'قواعد النسخ والمزامنة';

  @override
  String get newRule => 'قاعدة جديدة';

  @override
  String get noSyncRules => 'لا توجد قواعد مزامنة مهيأة';

  @override
  String get noSyncRulesSubtitle =>
      'أنشئ قاعدة تلقائية لمزامنة المجلدات المحلية مع السحابة.';

  @override
  String get ruleName => 'اسم القاعدة';

  @override
  String get sourcePath => 'المجلد المصدر';

  @override
  String get destinationCloud => 'سحابة الوجهة';

  @override
  String get destinationPath => 'المسار البعيد';

  @override
  String get direction => 'الاتجاه';

  @override
  String get frequency => 'التكرار';

  @override
  String get runNow => 'تشغيل الآن';

  @override
  String get syncInProgress => 'المزامنة جارية...';

  @override
  String get syncSuccess => 'اكتملت المزامنة';

  @override
  String get syncFailed => 'فشلت المزامنة';

  @override
  String get addCloudDialogTitle => 'ربط سحابة جديدة';

  @override
  String get selectProvider => 'اختيار مزود السحابة';

  @override
  String get accountNameLabel => 'اسم الحساب / الاسم المستعار';

  @override
  String get connectButton => 'ربط الحساب';

  @override
  String get vaultTitle => 'تشفير طرف لطرف (Crypt)';

  @override
  String get vaultPassword => 'كلمة مرور الخزينة';

  @override
  String get vaultConfirmPassword => 'تأكيد كلمة المرور';

  @override
  String get vaultSalt => 'الملح / كلمة مرور ثانوية (اختياري)';

  @override
  String get encryptFileNames => 'تشفير أسماء الملفات';

  @override
  String get encryptDirNames => 'تشفير أسماء المجلدات';

  @override
  String get langSpanish => 'Español';

  @override
  String get langFrench => 'Français';

  @override
  String get langArabic => 'العربية';

  @override
  String get langPolish => 'Polski';

  @override
  String get selectLanguage => 'اختر اللغة';

  @override
  String get searchLanguageHint => 'ابحث عن لغة أو دولة...';

  @override
  String get currentLanguage => 'اللغة الحالية';

  @override
  String systemDefaultWithLocale(String locale) {
    return 'افتراضي النظام ($locale)';
  }

  @override
  String get refreshCloudsTooltip => 'تحديث السحب المهيأة';

  @override
  String get storageOverviewAggregated => 'نظرة عامة مجمعة على التخزين';

  @override
  String get ramEncryptionActive => 'تشفير RAM نشط';

  @override
  String connectedAccountsCount(int count) {
    return 'الحسابات السحابية المتصلة: $count';
  }

  @override
  String get noCloudsConfiguredHint =>
      'لا توجد سحب مهيأة. اضغط على «+ ربط سحابة جديدة» أدناه.';

  @override
  String percentUsed(String percent) {
    return '$percent% مستخدم';
  }

  @override
  String availableSpace(String space) {
    return '$space متاح';
  }

  @override
  String get calculatingQuota =>
      'جارٍ حساب السعة التخزينية أو المساحة غير محدودة...';

  @override
  String get syncAndBackup => 'المزامنة والنسخ الاحتياطي';

  @override
  String get noRulesConfigured => 'لا توجد قواعد مهيأة';

  @override
  String activeRulesCount(int active, int total) {
    return '$active/$total قواعد نشطة';
  }

  @override
  String get manage => 'إدارة';

  @override
  String connectedCloudsCount(int count) {
    return 'السحب المتصلة ($count)';
  }

  @override
  String get connectNewCloud => 'ربط سحابة جديدة';

  @override
  String get noCloudProvidersConnected => 'لا يوجد مزودو سحابة متصلون';

  @override
  String get connectCloudDescription =>
      'اربط Google Drive أو Dropbox أو OneDrive أو SFTP أو WebDAV لمزامنة وتصفح ملفاتك.';

  @override
  String get addFirstCloud => 'إضافة السحابة الأولى';

  @override
  String vaultOnRemote(String remote) {
    return 'خزينة على $remote';
  }

  @override
  String get disconnectCloudTitle => 'فصل السحابة';

  @override
  String disconnectCloudPrompt(String name) {
    return 'هل تريد فصل «$name»؟ سيتم حذف بيانات الاعتماد من التخزين الآمن.';
  }

  @override
  String get disconnect => 'فصل';

  @override
  String freeSpace(String space) {
    return '$space متاح';
  }

  @override
  String get storage => 'التخزين';

  @override
  String get available => 'متاح';

  @override
  String get exploreFiles => 'استكشاف الملفات';

  @override
  String get paneLeft => 'اللوحة اليسرى';

  @override
  String get paneRight => 'اللوحة اليمنى';

  @override
  String get folderName => 'اسم المجلد';

  @override
  String errorCreatingFolder(String error) {
    return 'خطأ أثناء إنشاء المجلد: $error';
  }

  @override
  String get moveAction => 'نقل';

  @override
  String get copyAction => 'نسخ';

  @override
  String transferBatchStarted(String action, int count, String remote) {
    return 'بدأ $action $count عنصر إلى [$remote]...';
  }

  @override
  String errorTransferring(String error) {
    return 'خطأ أثناء النقل: $error';
  }

  @override
  String itemCopiedToClipboard(String name) {
    return 'تم نسخ «$name» إلى الحافظة';
  }

  @override
  String itemsCopiedToClipboard(int count) {
    return 'تم نسخ $count عنصر إلى الحافظة';
  }

  @override
  String itemCutToClipboard(String name) {
    return 'تم قص «$name» (جاهز للنقل)';
  }

  @override
  String itemsCutToClipboard(int count) {
    return 'تم قص $count عنصر (جاهز للنقل)';
  }

  @override
  String get noFilesSelectedForDownload => 'لم يتم تحديد أي ملفات للتنزيل.';

  @override
  String downloadingItems(int count) {
    return 'جارٍ تنزيل $count عنصر...';
  }

  @override
  String itemsDownloadedSuccess(int count, String path) {
    return 'تم تنزيل $count عنصر بنجاح إلى «$path»';
  }

  @override
  String errorStartingDownload(String error) {
    return 'خطأ في بدء التنزيل: $error';
  }

  @override
  String deleteItemsConfirmTitle(int count) {
    return 'حذف $count عنصر محدد؟';
  }

  @override
  String deleteItemsConfirmPrompt(int count) {
    return 'هل أنت متأكد من حذف $count عنصر محدد نهائياً من السحابة؟';
  }

  @override
  String itemsDeletedSuccess(int count) {
    return 'تم حذف $count عنصر';
  }

  @override
  String errorDeleting(String error) {
    return 'خطأ أثناء الحذف: $error';
  }

  @override
  String get uploadCompletedSuccess => 'اكتمل الرفع بنجاح';

  @override
  String errorUploading(String error) {
    return 'خطأ أثناء الرفع: $error';
  }

  @override
  String get folderUploadCompletedSuccess => 'اكتمل رفع المجلد بنجاح';

  @override
  String errorFolderUploading(String error) {
    return 'خطأ أثناء رفع المجلد: $error';
  }

  @override
  String get filesAlreadyInDirectory => 'الملفات موجودة بالفعل في هذا المجلد.';

  @override
  String dragDropTransferStarted(String action, int count, String remote) {
    return 'بدأ $action $count عنصر إلى [$remote]...';
  }

  @override
  String errorDragDrop(String error) {
    return 'خطأ أثناء النقل بالسحب والإفلات: $error';
  }

  @override
  String get closeSelection => 'إغلاق التحديد';

  @override
  String itemsSelectedCount(int count) {
    return 'تم تحديد $count';
  }

  @override
  String get deselectAll => 'إلغاء تحديد الكل';

  @override
  String copyToRemote(String remote) {
    return 'نسخ إلى $remote';
  }

  @override
  String moveToRemote(String remote) {
    return 'نقل إلى $remote';
  }

  @override
  String get moreActions => 'مزيد من الإجراءات';

  @override
  String get downloadSelected => 'تنزيل المحدد';

  @override
  String get copyToClipboard => 'نسخ إلى الحافظة';

  @override
  String get cutToClipboard => 'قص إلى الحافظة';

  @override
  String get selectCloud => 'تحديد السحابة';

  @override
  String get closeSearch => 'إغلاق البحث';

  @override
  String get uploadFromDevice => 'رفع من الجهاز';

  @override
  String get moreOptions => 'خيارات إضافية';

  @override
  String get viewGrid => 'عرض شبكي';

  @override
  String get viewList => 'عرض قائمة';

  @override
  String get multiSelection => 'تحديد متعدد';

  @override
  String get sortNameAsc => 'الاسم (أ-ي)';

  @override
  String get sortNameDesc => 'الاسم (ي-أ)';

  @override
  String get sortSizeDesc => 'الحجم (الأكبر أولاً)';

  @override
  String get sortSizeAsc => 'الحجم (الأصغر أولاً)';

  @override
  String get sortDateDesc => 'التاريخ (الأحدث أولاً)';

  @override
  String get disableDualPane => 'تعطيل Commander (لوحة واحدة)';

  @override
  String get enableDualPane => 'تفعيل Commander (لوحتان)';

  @override
  String itemsInClipboard(int count) {
    return '$count عنصر في الحافظة';
  }

  @override
  String get pasteHere => 'لصق هنا';

  @override
  String get noResults => 'لا توجد نتائج';

  @override
  String noMatchingResults(String query) {
    return 'لا توجد ملفات أو مجلدات تطابق «$query»';
  }

  @override
  String get selectACloud => 'اختر سحابة';

  @override
  String get selectCloudDescription =>
      'اختر مزود سحابي من القائمة أعلاه لتصفح ملفاتك.';

  @override
  String optionsForItem(String name) {
    return 'خيارات «$name»';
  }

  @override
  String get select => 'تحديد';

  @override
  String get openWithSystemApp => 'فتح بتطبيق النظام';

  @override
  String get downloadToLocal => 'تنزيل محلياً';

  @override
  String get cut => 'قص (نقل)';

  @override
  String get copyPath => 'نسخ المسار';

  @override
  String get info => 'معلومات';

  @override
  String generatingShareLink(String name) {
    return 'جارٍ إنشاء رابط لـ «$name»...';
  }

  @override
  String errorPublicLink(String error) {
    return 'خطأ في الرابط العام: $error';
  }

  @override
  String get noLinkGenerated => 'لم يوفر المزود أي رابط.';

  @override
  String errorDownloading(String error) {
    return 'خطأ أثناء التنزيل: $error';
  }

  @override
  String get renameFolderTitle => 'إعادة تسمية المجلد';

  @override
  String get renameFileTitle => 'إعادة تسمية الملف';

  @override
  String errorRenaming(String error) {
    return 'خطأ أثناء إعادة التسمية: $error';
  }

  @override
  String get pathCopiedToClipboard => 'تم نسخ المسار إلى الحافظة';

  @override
  String itemDetailsPath(String path) {
    return 'المسار: $path';
  }

  @override
  String itemDetailsType(String type) {
    return 'النوع: $type';
  }

  @override
  String itemDetailsSize(String size) {
    return 'الحجم: $size';
  }

  @override
  String itemDetailsModified(String date) {
    return 'تاريخ التعديل: $date';
  }

  @override
  String get folder => 'مجلد';

  @override
  String get file => 'ملف';

  @override
  String get selectCloudFirstLeft => 'حدد أولاً سحابة في اللوحة اليسرى.';

  @override
  String get selectCloudFirstRight => 'حدد أولاً سحابة في اللوحة اليمنى.';

  @override
  String get selectDestinationCloudLeft =>
      'حدد أولاً سحابة الوجهة في اللوحة اليسرى.';

  @override
  String get selectDestinationCloudRight =>
      'حدد أولاً سحابة الوجهة في اللوحة اليمنى.';

  @override
  String get noFilesToTransfer => 'لا توجد ملفات لنقلها.';

  @override
  String transferStarted(String action, int count, String src, String dst) {
    return 'بدأ $action $count عنصر من [$src] إلى [$dst]...';
  }

  @override
  String get swapPanesTooltip => 'تبديل اللوحتين (<->)';

  @override
  String get refreshBothPanesTooltip => 'تحديث اللوحتين';

  @override
  String get copyRight => 'نسخ لليمين ->';

  @override
  String get moveRight => 'نقل لليمين ->';

  @override
  String get copyLeft => '<- نسخ لليسار';

  @override
  String get moveLeft => '<- نقل لليسار';

  @override
  String copyRightWithCount(int count) {
    return 'نسخ لليمين ($count) ->';
  }

  @override
  String moveRightWithCount(int count) {
    return 'نقل لليمين ($count) ->';
  }

  @override
  String copyLeftWithCount(int count) {
    return '<- نسخ لليسار ($count)';
  }

  @override
  String moveLeftWithCount(int count) {
    return '<- نقل لليسار ($count)';
  }

  @override
  String get deleteRuleTitle => 'حذف القاعدة';

  @override
  String deleteRulePrompt(String name) {
    return 'هل تريد حذف قاعدة «$name»؟ الملفات المحلية والسحابية لن تحذف.';
  }

  @override
  String get syncAll => 'مزامنة الكل';

  @override
  String get newRuleTooltip => 'قاعدة جديدة';

  @override
  String get backupBannerTitle => 'نسخ احتياطي مستمر ومزامنة سحابية';

  @override
  String get backupBannerSubtitle =>
      'قم بإعداد مزامنة مجدولة بين المجلدات المحلية ومساحات التخزين السحابية.';

  @override
  String get noActiveRules => 'لا توجد قواعد نشطة';

  @override
  String get noActiveRulesSubtitle =>
      'أنشئ قاعدتك الأولى للنسخ الاحتياطي التلقائي من هاتفك إلى Google Drive أو Dropbox أو SFTP.';

  @override
  String get createNewRule => 'إنشاء قاعدة جديدة';

  @override
  String get ruleOptionsTooltip => 'خيارات القاعدة';

  @override
  String get syncNow => 'مزامنة الآن';

  @override
  String get statusWaiting => 'قيد الانتظار';

  @override
  String get statusInProgress => 'جارٍ التشغيل...';

  @override
  String get statusCompleted => 'مكتمل';

  @override
  String get statusFailed => 'خطأ';

  @override
  String get editRuleTitle => 'تعديل قاعدة النسخ الاحتياطي';

  @override
  String get newRuleTitle => 'قاعدة مزامنة جديدة';

  @override
  String get ruleDialogSubtitle =>
      'تهيئة النسخ الاحتياطي التلقائي بين مجلد محلي والسحابة.';

  @override
  String get ruleNameOptional => 'اسم القاعدة (اختياري)';

  @override
  String get ruleNameHint => 'مثال: صور الكاميرا DCIM أو وثائق العمل';

  @override
  String get sourceLocalFolder => 'المجلد المحلي المصدر';

  @override
  String get sourceLocalFolderHint =>
      '/storage/emulated/0/DCIM أو /home/user/Pictures';

  @override
  String get browseFolders => 'تصفح المجلدات';

  @override
  String get selectLocalFolderError => 'يرجى تحديد أو إدخال مجلد محلي';

  @override
  String get noCloudsConfiguredSync =>
      'لم يتم إعداد أي سحابة. أضف حساب سحابة من الرئيسية أولاً.';

  @override
  String get remoteDestinationPath => 'مسار الوجهة البعيدة';

  @override
  String get syncMode => 'وضع المزامنة';

  @override
  String get syncModeCopy => 'نسخ احتياطي تزايدي';

  @override
  String get syncModeCopyDesc =>
      'رفع الملفات الجديدة والمعدلة مع الاحتفاظ بالملفات الموجودة بالسحابة.';

  @override
  String get syncModeSync => 'مزامنة مطابقة (مرآة)';

  @override
  String get syncModeSyncDesc =>
      'جعل الوجهة السحابية مطابقة تماماً للمجلد المحلي (حذف الملفات المحذوفة محلياً من السحابة).';

  @override
  String get syncFrequency => 'تكرار التنفيذ';

  @override
  String get freqManual => 'يدوي (عند الطلب فقط)';

  @override
  String get freq15Min => 'كل 15 دقيقة';

  @override
  String get freq30Min => 'كل 30 دقيقة';

  @override
  String get freqHourly => 'كل ساعة';

  @override
  String get freq6Hours => 'كل 6 ساعات';

  @override
  String get freq12Hours => 'كل 12 ساعة';

  @override
  String get freqDaily => 'يومياً (24 ساعة)';

  @override
  String get activateRuleImmediately => 'تفعيل القاعدة فوراً';

  @override
  String get activateRuleImmediatelyDesc =>
      'ستعمل المزامنة في الخلفية وفق الفترة المحددة';

  @override
  String get updateRule => 'تحديث';

  @override
  String get saveRule => 'حفظ القاعدة';

  @override
  String get selectCloudProvider => 'اختر مزود السحابة:';

  @override
  String get cloudAccountName => 'اسم حساب السحابة';

  @override
  String get cloudAccountNameHint =>
      'مثال: GoogleDrive, WorkDropbox (بدون مسافات)';

  @override
  String get enterNameError => 'يرجى إدخال اسم';

  @override
  String get noSpacesOrColons => 'المسافات والرمز \":\" غير مسموح بها';

  @override
  String get oauthMode => 'وضع Client ID (OAuth2)';

  @override
  String get oauthOfficial => 'UnifyCloud (رسمي / موصى به)';

  @override
  String get oauthRclone => 'Rclone (غير موصى به - سعة مشتركة)';

  @override
  String get oauthCustom => 'معرف عميل شخصي (متقدم)';

  @override
  String get officialOauthTitle => 'بيانات اعتماد UnifyCloud الرسمية';

  @override
  String get officialOauthDesc =>
      'بيانات مهيأة مسبقاً للاتصال المباشر بحصة مخصصة وأعلى سرعة.';

  @override
  String get rcloneOauthDesc =>
      'مفاتيح مفتوحة المصدر مشتركة لـ Rclone. قد تواجه حدوداً أو أخطاء 403 مؤقتة من Google.';

  @override
  String get customClientId => 'Client ID';

  @override
  String get customClientSecret => 'Client Secret';

  @override
  String get selectVaultDestination => 'حدد السحابة المستهدفة للخزينة';

  @override
  String get vaultPasswordRequired => 'كلمة مرور التشفير مطلوبة';

  @override
  String get vaultPasswordsDoNotMatch => 'كلمتا المرور غير متطابقتين';

  @override
  String errorAddingRemote(String error) {
    return 'خطأ أثناء إضافة السحابة: $error';
  }

  @override
  String get fileNameEncryption => 'تشفير أسماء الملفات';

  @override
  String get encryptStandard => 'قياسي (تشفير أسماء الملفات بالكامل - موصى به)';

  @override
  String get encryptObscure => 'تمويه بسيط (الحفاظ على الامتدادات)';

  @override
  String get encryptOff => 'معطل (أسماء واضحة)';

  @override
  String get encryptFolderNames => 'تشفير أسماء المجلدات أيضاً';

  @override
  String get encryptFolderNamesDesc => 'إخفاء بنية المجلدات في السحابة تماماً';

  @override
  String get connectCloud => 'ربط السحابة';

  @override
  String get reopenAuth => 'إعادة فتح';

  @override
  String get linkCopiedToClipboard => 'تم نسخ الرابط إلى الحافظة!';

  @override
  String errorOpenBrowserGeneric(String error) {
    return 'تعذر فتح المتصفح: $error';
  }

  @override
  String get shareableLinkTitle => 'رابط المشاركة';

  @override
  String shareLinkAccessDescription(String item) {
    return 'يمكن لأي شخص لديه هذا الرابط الوصول إلى $item:';
  }

  @override
  String get open => 'فتح';

  @override
  String activeTransfersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count عملية نقل نشطة',
      many: '$count عملية نقل نشطة',
      few: '$count عمليات نقل نشطة',
      two: 'عمليتا نقل نشطتان',
      one: 'عملية نقل واحدة نشطة',
      zero: 'لا توجد عمليات نقل نشطة',
    );
    return '$_temp0';
  }

  @override
  String transfersQueueCount(int count) {
    return 'طابور النقل ($count)';
  }

  @override
  String get noTransfersInProgress => 'لا توجد عمليات نقل جارية';

  @override
  String get transfersEmptySubtitle =>
      'ستظهر جميع الملفات المحملة أو المرفوعة هنا';

  @override
  String get cancelled => 'ملغى';

  @override
  String get appLockedTitle => 'التطبيق مقفل';

  @override
  String get unlockWithBiometrics => 'إلغاء القفل بالبصمة';

  @override
  String get pinMustBe6Digits => 'يجب أن يتكون رمز PIN من 6 أرقام تماماً';

  @override
  String get pinIncorrect => 'رمز PIN غير صحيح. أعد المحاولة.';

  @override
  String get pinsDoNotMatch => 'رمزا PIN غير متطابقين. أعد المحاولة.';

  @override
  String get pinStepOld => 'أدخل رمز PIN الحالي للمتابعة.';

  @override
  String get pinStepNew => 'أدخل رمز PIN الأمان الجديد من 6 أرقام.';

  @override
  String get pinStepConfirm => 'أعد إدخال رمز PIN الجديد للتأكيد.';

  @override
  String get pinStepVerify => 'أدخل رمز PIN لتأكيد العملية.';

  @override
  String get pinTitleSetup => 'إعداد رمز PIN الأمان';

  @override
  String get pinTitleChange => 'تعديل رمز PIN الأمان';

  @override
  String get pinTitleVerify => 'التحقق الأمني';

  @override
  String get pinContinue => 'متابعة';

  @override
  String get errorDetails => 'تفاصيل الخطأ';

  @override
  String get errorDetailsCopied => 'تم نسخ تفاصيل الخطأ إلى الحافظة';

  @override
  String get collapse => 'طي';

  @override
  String get expand => 'توسيع';

  @override
  String get copyError => 'نسخ الخطأ';

  @override
  String get errorNetwork =>
      'الاتصال غير متوفر أو غير مستقر. تحقق من اتصال الإنترنت وحاول مجدداً.';

  @override
  String get errorDiskSpace =>
      'مساحة التخزين غير كافية أو القرص ممتلئ. يرجى توفير مساحة للمتابعة.';

  @override
  String get errorAuthExpired =>
      'انتهت صلاحية الجلسة أو الرمز. يرجى إعادة ربط حسابك.';

  @override
  String get errorNotFound => 'العنصر أو المجلد غير موجود على مزود السحابة.';

  @override
  String get errorPermissionDenied =>
      'تم رفض الإذن لتنفيذ هذا الإجراء على السحابة.';

  @override
  String get errorGeneric => 'حدث خطأ أثناء تنفيذ العملية.';

  @override
  String get desktopAndSystem => 'سطح المكتب والنظام';

  @override
  String get desktopAndSystemSubtitle =>
      'بدء التشغيل التلقائي والتشغيل في الخلفية وصينية النظام';

  @override
  String get autostartOnBoot => 'التشغيل عند بدء النظام';

  @override
  String get autostartOnBootSubtitle =>
      'تشغيل UnifyCloud تلقائياً في الخلفية عند تسجيل الدخول';

  @override
  String get minimizeToTray => 'التصغير إلى صينية النظام';

  @override
  String get minimizeToTraySubtitle =>
      'إبقاء UnifyCloud قيد التشغيل في الخلفية عند إغلاق النافذة';

  @override
  String get trayStatusIdle => 'خامل (لا توجد عمليات نقل نشطة)';

  @override
  String trayStatusActive(int count, String speed) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count عملية نقل نشطة ($speed)',
      many: '$count عملية نقل نشطة ($speed)',
      few: '$count عمليات نقل نشطة ($speed)',
      two: 'عمليتا نقل نشطتان ($speed)',
      one: 'عملية نقل واحدة نشطة ($speed)',
    );
    return '$_temp0';
  }

  @override
  String get trayShowWindow => 'إظهار UnifyCloud';

  @override
  String get trayHideWindow => 'إخفاء إلى صينية النظام';

  @override
  String get trayQuit => 'إنهاء UnifyCloud';

  @override
  String get trayTooltip => 'UnifyCloud - مدير التخزين السحابي';

  @override
  String trayStatusLine(String status) {
    return 'الحالة: $status';
  }

  @override
  String get bgNotificationInitialTitle => 'تحويلات UnifyCloud';

  @override
  String get bgNotificationInitialContent =>
      'جارٍ إدارة عمليات النقل في الخلفية...';

  @override
  String bgNotificationProgressContent(String speed, int percentage) {
    return '$speed • تم إكمال $percentage%';
  }

  @override
  String get bgNotificationIdleContent => 'تم إكمال جميع عمليات النقل.';

  @override
  String get pinTitleConfirm => 'تأكيد رمز PIN';

  @override
  String get pinTitleEnterCurrent => 'أدخل رمز PIN الحالي';

  @override
  String get pinTitleNew => 'رمز PIN جديد';

  @override
  String get pinTitleConfirmNew => 'تأكيد رمز PIN الجديد';

  @override
  String get pinStepSetupNew => 'أنشئ رمزاً رقمياً من 6 أرقام لحماية التطبيق.';

  @override
  String get pinStepSetupConfirm => 'أعد إدخال رمز PIN لتأكيده.';

  @override
  String pinTooManyAttempts(int seconds) {
    return 'محاولات فاشلة كثيرة جداً. حاول مرة أخرى خلال $seconds ث.';
  }

  @override
  String pinVerificationError(String error) {
    return 'خطأ أثناء التحقق: $error';
  }

  @override
  String get biometricAuthReason => 'قم بالمصادقة للوصول إلى UnifyCloud';

  @override
  String syncRulesCount(int count) {
    return 'قواعد المزامنة ($count)';
  }

  @override
  String get noSyncRulesEmptyDesc =>
      'قم بإعداد قاعدة لتشغيل النسخ الاحتياطي التلقائي على فترات منتظمة أو عند الطلب باستخدام زر \"مزامنة الآن\".';

  @override
  String get neverSynced => 'لم تتم المزامنة مطلقاً';

  @override
  String get lastSyncNow => 'آخر مزامنة: الآن';

  @override
  String lastSyncMinutesAgo(int minutes) {
    return 'آخر مزامنة: منذ $minutes دقيقة';
  }

  @override
  String lastSyncHoursAgo(int hours) {
    return 'آخر مزامنة: منذ $hours ساعة';
  }

  @override
  String lastSyncDate(String date) {
    return 'آخر مزامنة: $date';
  }

  @override
  String localFolderNotFound(String path) {
    return 'لم يتم العثور على المجلد المحلي: $path';
  }

  @override
  String get selectDestinationCloudError => 'اختر سحابة وجهة';

  @override
  String get remoteDestinationPathHint => 'Backup/Photos أو /';

  @override
  String get enterDestinationPathError => 'أدخل مسار الوجهة';

  @override
  String get activateRuleManualOnlyDesc =>
      'عند التعطيل، لا يمكن تشغيل القاعدة إلا يدوياً.';

  @override
  String get presetPhotosDcim => 'الصور (DCIM)';

  @override
  String get presetPictures => 'الصور';

  @override
  String get presetDocuments => 'المستندات';

  @override
  String get presetDownloads => 'التنزيلات';

  @override
  String defaultBackupRuleName(String name) {
    return 'نسخ احتياطي $name';
  }

  @override
  String defaultSyncRuleName(String name) {
    return 'مزامنة $name';
  }

  @override
  String get folderFallbackName => 'مجلد';

  @override
  String get providerLocalName => 'قرص محلي';

  @override
  String get providerCryptName => 'تشفير طرف لطرف (Crypt)';

  @override
  String get providerSubtitleDrive => 'تخزين سحابي OAuth2';

  @override
  String get providerSubtitleDropbox => 'مزامنة ومشاركة الملفات';

  @override
  String get providerSubtitleOneDrive => 'تخزين شخصي وللأعمال';

  @override
  String get providerSubtitleWebdav => 'سحابة ذاتية الاستضافة أو للشركات';

  @override
  String get providerSubtitleSftp => 'خادم بعيد آمن';

  @override
  String get providerSubtitleS3 => 'حاوية تخزين كائني';

  @override
  String get providerSubtitleLocal => 'مجلد النظام المحلي';

  @override
  String get providerSubtitleCrypt =>
      'تشفير الملفات والأسماء بـ AES-256 على أي سحابة';

  @override
  String get noUnifyCloudClientId =>
      'لا يتوفر معرّف عميل UnifyCloud لهذا المزود. استخدم Rclone أو معرّف عميل شخصي.';

  @override
  String get noRcloneClientId =>
      'لا يتوفر معرّف عميل Rclone لهذا المزود. استخدم معرّف عميل شخصي.';

  @override
  String get enterClientIdForOauth =>
      'أدخل معرّف العميل لبدء تسجيل الدخول عبر OAuth2';

  @override
  String get oauthStartingLocalServer =>
      'جارٍ تشغيل خادم تسجيل الدخول المحلي...';

  @override
  String get oauthBrowserOpened => 'تم فتح المتصفح. في انتظار التفويض...';

  @override
  String get oauthBrowserNotSupported =>
      'الفتح التلقائي غير مدعوم. افتح الرابط أدناه أو انسخه في متصفحك:';

  @override
  String get oauthCompletedSuccess => 'تمت المصادقة بنجاح!';

  @override
  String oauthErrorPrefix(String error) {
    return 'خطأ OAuth: $error';
  }

  @override
  String get officialOauthActionDesc =>
      'تسجيل دخول سريع وموثق ببيانات اعتماد مخصصة لـ UnifyCloud. انقر على \"بدء تسجيل الدخول في المتصفح\" دون إعداد يدوي.';

  @override
  String get rcloneOauthTitle => 'معرّف عميل Rclone العام (غير موصى به)';

  @override
  String get rcloneOauthWarningDesc =>
      'يستخدم المفاتيح العامة المشتركة بين جميع مستخدمي Rclone. قد يواجه بطئاً أو حدوداً بسبب الحصص المشتركة.';

  @override
  String get customOauthGuideInfo =>
      'أنشئ معرّفاتك بنفسك: راجع docs/oauth_setup_guide.md للحصول على دليل خطوة بخطوة.';

  @override
  String get customGoogleClientIdLabel => 'معرّف عميل Google الشخصي';

  @override
  String get customOauthClientIdLabel => 'معرّف العميل الشخصي (OAuth2)';

  @override
  String get customGoogleClientIdHint =>
      'مثال: xxxxx.apps.googleusercontent.com';

  @override
  String get enterYourClientIdError => 'أدخل معرّف العميل الخاص بك';

  @override
  String get customClientSecretOptional => 'سر العميل (اختياري)';

  @override
  String get authenticating => 'جارٍ المصادقة...';

  @override
  String get startBrowserLogin => 'بدء تسجيل الدخول في المتصفح (OAuth2)';

  @override
  String get browserLaunchedOrCopy => 'تم تشغيل المتصفح (أو انسخ الرابط أدناه)';

  @override
  String get copyLinkToCompleteLogin =>
      'انسخ الرابط لإكمال تسجيل الدخول في متصفحك';

  @override
  String get copyLinkAndPasteHint =>
      'تم نسخ الرابط إلى الحافظة! الصقه في متصفحك.';

  @override
  String get tokenJsonLabel => 'رمز JSON (مُولّد أو ملصق)';

  @override
  String get webdavUrlLabel => 'رابط WebDAV / Nextcloud';

  @override
  String get s3EndpointLabel => 'نقطة نهاية S3';

  @override
  String get sftpHostLabel => 'مضيف / خادم SFTP';

  @override
  String get requiredFieldError => 'حقل مطلوب';

  @override
  String get s3AccessKeyId => 'معرّف مفتاح الوصول';

  @override
  String get usernameLabel => 'اسم المستخدم';

  @override
  String get s3SecretAccessKey => 'مفتاح الوصول السري';

  @override
  String get passwordLabel => 'كلمة المرور';

  @override
  String get localProviderInfo =>
      'يتيح لك المزود المحلي تصفح الملفات ونسخها من وإلى نظام ملفات جهازك.';

  @override
  String get e2eEncryptionTitle => 'تشفير طرف لطرف من جانب العميل (AES-256)';

  @override
  String get e2eEncryptionDesc =>
      'يتم تشفير الملفات وأسمائها على جهازك قبل رفعها إلى السحابة المستهدفة. لا يمكن حتى لمزود السحابة قراءتها.';

  @override
  String get noTargetCloudForVault =>
      'لا تتوفر سحابة وجهة. اربط سحابة أخرى أولاً (مثل Google Drive أو OneDrive أو القرص المحلي) لإنشاء خزينة مشفرة عليها.';

  @override
  String get vaultTargetCloudLabel => 'السحابة المستهدفة *';

  @override
  String get vaultTargetCloudHelper =>
      'السحابة التي سيتم فيها تخزين الملفات المشفرة';

  @override
  String get vaultTargetPathLabel => 'مسار أو مجلد الوجهة';

  @override
  String get vaultTargetPathHint => 'مثال: vault أو secret_data';

  @override
  String get vaultTargetPathHelper =>
      'المجلد على السحابة البعيدة لحفظ الملفات المشفرة (اختياري)';

  @override
  String get vaultMasterPasswordLabel =>
      'كلمة مرور التشفير (كلمة المرور الرئيسية) *';

  @override
  String get vaultMasterPasswordHelper =>
      'احفظها بأمان: بدون كلمة المرور هذه لا يمكن استعادة الملفات';

  @override
  String get vaultEnterPasswordError => 'أدخل كلمة مرور التشفير';

  @override
  String get vaultConfirmPasswordRequired => 'تأكيد كلمة المرور *';

  @override
  String get vaultConfirmPasswordError => 'أكد كلمة المرور';

  @override
  String get vaultSaltOptionalLabel => 'الملح / كلمة مرور ثانوية (اختياري)';

  @override
  String get vaultSaltHelper => 'يضيف حماية إضافية ضد هجمات القوة الغاشمة';

  @override
  String oauthPortOccupied(int port) {
    return 'المنفذ $port قيد الاستخدام بالفعل بواسطة عملية أخرى. أغلق أي جلسات Rclone أو متصفح مفتوحة وحاول مرة أخرى.';
  }

  @override
  String get oauthHtmlSuccessTitle => 'UnifyCloud - تمت المصادقة';

  @override
  String get oauthHtmlSuccessHeading => 'تمت المصادقة بنجاح!';

  @override
  String get oauthHtmlSuccessBody =>
      'يمكنك إغلاق علامة التبويب هذه والعودة إلى تطبيق UnifyCloud.';

  @override
  String get oauthHtmlErrorTitle => 'UnifyCloud - خطأ';

  @override
  String get oauthHtmlErrorHeading => 'خطأ في المصادقة';

  @override
  String get oauthInvalidState => 'معامل حالة OAuth غير صالح.';

  @override
  String get oauthInvalidCode => 'رمز التفويض غير صالح.';

  @override
  String get folderDownloadUnsupported =>
      'التنزيل المباشر للمجلدات غير مدعوم. حدد ملفات فردية.';

  @override
  String downloadingSingleItem(String name) {
    return 'جارٍ بدء تنزيل \"$name\"...';
  }

  @override
  String downloadingMultipleItems(int count) {
    return 'جارٍ بدء تنزيل $count ملفات...';
  }

  @override
  String filesAddedToDownloadQueue(int count) {
    return 'تمت إضافة $count ملفات إلى طابور التنزيل.';
  }

  @override
  String filesAddedToDownloadQueueWithSkipped(int count, int dirs) {
    return 'تمت إضافة $count ملفات إلى طابور التنزيل (تم استبعاد $dirs مجلدات).';
  }

  @override
  String get deleteSingleFolderTitle => 'حذف المجلد؟';

  @override
  String get deleteSingleFileTitle => 'حذف الملف؟';

  @override
  String deleteSingleItemPrompt(String name) {
    return 'هل أنت متأكد من رغبتك في حذف \"$name\" نهائياً؟';
  }

  @override
  String get itemDeletedSuccess => 'تم حذف العنصر';

  @override
  String get sortDateAsc => 'التاريخ (الأقدم أولاً)';

  @override
  String get sortByTooltip => 'ترتيب حسب';

  @override
  String filesAddedToUploadQueue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تمت إضافة $count ملف إلى طابور الرفع',
      many: 'تمت إضافة $count ملفاً إلى طابور الرفع',
      few: 'تمت إضافة $count ملفات إلى طابور الرفع',
      two: 'تمت إضافة ملفين إلى طابور الرفع',
      one: 'تمت إضافة ملف واحد إلى طابور الرفع',
    );
    return '$_temp0';
  }

  @override
  String folderAddedToUploadQueue(int count) {
    return 'تمت إضافة المجلد للرفع ($count ملفات في الطابور)';
  }

  @override
  String dragDropInProgress(String action, int count, String src, String dst) {
    return 'جارٍ $action $count عنصر من [$src] إلى [$dst]...';
  }

  @override
  String get copySelected => 'نسخ المحدد';

  @override
  String get cutSelected => 'قص المحدد';

  @override
  String get searchFilesHint => 'ابحث عن ملفات أو مجلدات...';

  @override
  String get e2eActiveTooltip =>
      'تشفير طرف لطرف نشط (AES-256)\nالملفات والمجلدات مشفرة من جانب العميل';

  @override
  String get disableDualPaneTooltip => 'تعطيل اللوحتين';

  @override
  String get enableDualPaneTooltip => 'تفعيل اللوحتين (Commander)';

  @override
  String dropToCopyTo(String remote) {
    return 'أفلت للنسخ إلى [$remote]';
  }

  @override
  String get destinationFallback => 'الوجهة';

  @override
  String clipboardBannerSingle(String action, String name, String remote) {
    return '$action: \"$name\" من [$remote]';
  }

  @override
  String clipboardBannerMultiple(String action, int count, String remote) {
    return '$action: $count عنصر من [$remote]';
  }

  @override
  String transferStartedSingle(String name) {
    return 'بدأ النقل لـ \"$name\"';
  }

  @override
  String transfersStartedCount(int count) {
    return 'بدأ $count عمليات نقل';
  }

  @override
  String get noCloudSelectedTitle => 'لم يتم تحديد سحابة';

  @override
  String get noCloudSelectedSubtitle => 'اختر سحابة من القائمة أعلاه.';

  @override
  String loadingFilesFromRemote(String remote) {
    return 'جارٍ تحميل الملفات من $remote...';
  }

  @override
  String loadingFolder(String folder) {
    return 'جارٍ تحميل $folder...';
  }

  @override
  String get readingDirectory => 'جارٍ قراءة الدليل...';

  @override
  String downloadStartedSavedTo(String path) {
    return 'بدأ التنزيل: الحفظ في $path';
  }

  @override
  String get noCloudSelected => 'لم يتم تحديد أي سحابة.';

  @override
  String get noLinkReturnedByProvider => 'لم يُرجع المزود أي رابط.';

  @override
  String get publicLinksNotSupported =>
      'مزود السحابة هذا لا يدعم إنشاء روابط عامة.';

  @override
  String errorCreatingShareLink(String error) {
    return 'خطأ أثناء إنشاء الرابط: $error';
  }

  @override
  String get newNameLabel => 'الاسم الجديد';

  @override
  String itemDetailsSizeWithBytes(String size, int bytes) {
    return 'الحجم: $size ($bytes بايت)';
  }

  @override
  String get shareLinkAccessFile =>
      'سيتمكن أي شخص لديه هذا الرابط من الوصول إلى هذا الملف:';

  @override
  String get shareLinkAccessFolder =>
      'سيتمكن أي شخص لديه هذا الرابط من الوصول إلى هذا المجلد:';

  @override
  String get invalidUrlOrBrowser => 'رابط غير صالح أو تعذر فتح المتصفح.';

  @override
  String noAppToOpenFile(String name) {
    return 'لا يوجد تطبيق مثبت لفتح \"$name\".';
  }

  @override
  String get permissionDeniedOpenFile =>
      'تم رفض الإذن لفتح الملف بتطبيق النظام.';

  @override
  String get noDefaultAppFound =>
      'لم يتم العثور على تطبيق افتراضي لفتح هذا الملف.';

  @override
  String unableToOpenFile(String error) {
    return 'تعذر فتح الملف: $error';
  }

  @override
  String downloadingForExternalOpen(String name) {
    return 'جارٍ تنزيل \"$name\" لفتحه خارجياً...';
  }

  @override
  String errorOpeningFile(String error) {
    return 'خطأ أثناء فتح الملف: $error';
  }

  @override
  String get selectFilesToUpload => 'حدد الملفات لرفعها إلى السحابة';

  @override
  String get selectFolderToUpload => 'حدد المجلد لرفعه إلى السحابة';

  @override
  String get copyRightCompact => 'نسخ ->';

  @override
  String copyRightCountCompact(int count) {
    return 'نسخ ($count) ->';
  }

  @override
  String get moveRightCompact => 'نقل ->';

  @override
  String moveRightCountCompact(int count) {
    return 'نقل ($count) ->';
  }

  @override
  String get copyLeftCompact => '<- نسخ';

  @override
  String copyLeftCountCompact(int count) {
    return '<- نسخ ($count)';
  }

  @override
  String get moveLeftCompact => '<- نقل';

  @override
  String moveLeftCountCompact(int count) {
    return '<- نقل ($count)';
  }

  @override
  String get clear => 'مسح';

  @override
  String get noRecentTransfers => 'لا توجد عمليات نقل حديثة';

  @override
  String get recentTransfersSubtitle =>
      'ستظهر التنزيلات والرفوعات والنسخ السحابية هنا.';

  @override
  String completedWithProgress(String progress) {
    return 'مكتمل • $progress';
  }

  @override
  String transferFailedError(String error) {
    return 'خطأ: $error';
  }

  @override
  String get transferFailedFallback => 'فشل النقل';

  @override
  String get cancelledByUser => 'تم الإلغاء بواسطة المستخدم';

  @override
  String get localLocation => 'محلي';

  @override
  String get moveToBadge => 'نقل إلى';

  @override
  String get copyToBadge => 'نسخ إلى';

  @override
  String get copiedExclamation => 'تم النسخ!';

  @override
  String get running => 'جارٍ التنفيذ';
}
