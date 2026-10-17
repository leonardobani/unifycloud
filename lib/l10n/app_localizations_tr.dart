// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'UnifyCloud';

  @override
  String get home => 'Ana Sayfa';

  @override
  String get explorer => 'Dosya Gezgini';

  @override
  String get sync => 'Senkronizasyon';

  @override
  String get settings => 'Ayarlar';

  @override
  String get cancel => 'İptal';

  @override
  String get confirm => 'Onayla';

  @override
  String get delete => 'Sil';

  @override
  String get save => 'Kaydet';

  @override
  String get close => 'Kapat';

  @override
  String get edit => 'Düzenle';

  @override
  String get create => 'Oluştur';

  @override
  String get retry => 'Yeniden Dene';

  @override
  String get copy => 'Kopyala';

  @override
  String get move => 'Taşı';

  @override
  String get rename => 'Yeniden Adlandır';

  @override
  String get download => 'İndir';

  @override
  String get upload => 'Yükle';

  @override
  String get share => 'Paylaş';

  @override
  String get details => 'Ayrıntılar';

  @override
  String get search => 'Ara';

  @override
  String get change => 'Değiştir';

  @override
  String get reset => 'Sıfırla';

  @override
  String get done => 'Bitti';

  @override
  String get loading => 'Yükleniyor...';

  @override
  String get success => 'İşlem başarıyla tamamlandı';

  @override
  String get error => 'Hata';

  @override
  String get settingsTitle => 'Ayarlar';

  @override
  String get resetDefaultsTooltip => 'Varsayılan Ayarlara Sıfırla';

  @override
  String get resetDialogTitle => 'Ayarları Sıfırla';

  @override
  String get resetDialogContent =>
      'Tüm ayarları varsayılan değerlerine sıfırlamak istediğinizden emin misiniz?';

  @override
  String get resetSuccessSnackbar => 'Ayarlar varsayılan değerlere sıfırlandı';

  @override
  String get appearanceAndTheme => 'Görünüm ve Tema';

  @override
  String get chooseVisualThemeSubtitle => 'Uygulamanın görsel temasını seçin:';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get themeLight => 'Açık';

  @override
  String get themeDark => 'Koyu';

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
  String get language => 'Dil';

  @override
  String get languageSubtitle => 'Uygulama arayüzü dilini seçin';

  @override
  String get langEnglish => 'English';

  @override
  String get langItalian => 'Italiano';

  @override
  String get langSystem => 'Sistem Varsayılanı';

  @override
  String get filesAndExploration => 'Dosyalar ve Gezinme';

  @override
  String get showHiddenFiles => 'Gizli dosyaları göster';

  @override
  String get showHiddenFilesSubtitle =>
      'Nokta ile başlayan dosya ve klasörleri göster';

  @override
  String get confirmBeforeDelete => 'Silmeden önce onayla';

  @override
  String get confirmBeforeDeleteSubtitle =>
      'Dosya veya klasör silmeden önce onay iste';

  @override
  String get defaultDownloadFolder => 'Varsayılan İndirme Klasörü';

  @override
  String get defaultDownloadFolderSystem =>
      'Sistem İndirilenler klasörü (varsayılan)';

  @override
  String get restoreDefaultPath => 'Varsayılan yolu geri yükle';

  @override
  String get customDownloadFolderDialogPrompt =>
      'Sistem seçiciyi kullanarak bir klasör seçin veya yolu girin:';

  @override
  String get folderPath => 'Klasör Yolu';

  @override
  String get folderPathHint => 'örn. /home/kullanici/İndirilenler';

  @override
  String get browseWithSystemPicker => 'Sistem Seçiciyle Gözat';

  @override
  String errorOpenPicker(String error) {
    return 'Sistem seçici açılamadı: $error';
  }

  @override
  String get restoreDefault => 'Varsayılana Dön';

  @override
  String get maxConcurrentTransfers => 'Eşzamanlı Transfer Sayısı';

  @override
  String get maxConcurrentTransfersSubtitle =>
      'Aynı anda gerçekleşen maksimum indirme ve yükleme sayısı';

  @override
  String get dualPaneMode => 'Çift Panel Modu (Tablet/Masaüstü)';

  @override
  String get dualPaneModeSubtitle =>
      'Geniş ekranlarda yan yana iki gezgin göster';

  @override
  String get communityAndSupport => 'Topluluk ve Destek';

  @override
  String get openSourceDescription =>
      'UnifyCloud, GPL-3.0 lisansı altında ücretsiz ve açık kaynaklı bir yazılımdır.';

  @override
  String get supportDeveloper => 'Geliştiriciye Destek Olun';

  @override
  String get supportDeveloperSubtitle =>
      'Bağımsız geliştirmeyi desteklemek için bir kahve ısmarlayın';

  @override
  String get viewSourceOnGitLab => 'Kodu GitLab\'da Görüntüle';

  @override
  String get viewSourceOnGitLabSubtitle =>
      'Resmi depo, hata bildirimleri ve katkılar';

  @override
  String errorOpenBrowser(String url) {
    return 'Tarayıcı açılamadı. Depo: $url';
  }

  @override
  String get supportDialogTitle => 'UnifyCloud\'u Destekleyin';

  @override
  String get supportDialogDescription1 =>
      'UnifyCloud, bulut verileriniz üzerinde tam kontrol sağlamak için tutkuyla geliştirilmiş açık kaynaklı bir projedir.';

  @override
  String get supportDialogDescription2 =>
      'Geliştirmeyi desteklemek için bağış yapabilirsiniz:';

  @override
  String get supportKofiTitle => 'Ko-fi üzerinden kahve ısmarla';

  @override
  String get supportLiberapayTitle => 'Liberapay (Düzenli bağış)';

  @override
  String get supportPaypalTitle => 'PayPal (Doğrudan)';

  @override
  String get securityAndEncryption => 'Güvenlik ve Şifreleme';

  @override
  String get securityArchitectureDescription =>
      'UnifyCloud yerel istemci tarafı şifreleme kullanır. Kimlik bilgileriniz cihazın güvenli anahtar zincirinde saklanır.';

  @override
  String get appLock => 'Uygulama Kilidi';

  @override
  String get appLockSubtitle => 'Uygulamayı bir PIN koduyla koruyun';

  @override
  String get appLockActiveSubtitle => 'PIN Etkin – Değiştirmek için dokunun';

  @override
  String get appLockEnabledSnackbar =>
      'Uygulama kilidi başarıyla etkinleştirildi';

  @override
  String get appLockDisabledSnackbar => 'Uygulama kilidi devre dışı bırakıldı';

  @override
  String get changePin => 'PIN\'i Değiştir';

  @override
  String get changePinSubtitle =>
      'Yeni bir 4-6 haneli güvenlik PIN\'i ayarlayın';

  @override
  String get pinChangedSnackbar => 'Güvenlik PIN\'i başarıyla güncellendi';

  @override
  String get biometricAuth => 'Biyometrik Kimlik Doğrulama';

  @override
  String get biometricAuthSubtitle => 'Parmak izi veya yüz tanıma kullanın';

  @override
  String get biometricNotAvailable =>
      'Bu cihazda biyometri kullanılamıyor veya ayarlanmamış';

  @override
  String get autoLock => 'Otomatik Kilitleme';

  @override
  String get autoLockSubtitle =>
      'Kilitlenmeden önceki arka plan hareketsizlik süresi';

  @override
  String get lockImmediately => 'Ayrılınca Hemen';

  @override
  String get lockAfter1Minute => '1 dakika sonra';

  @override
  String get lockAfter5Minutes => '5 dakika sonra';

  @override
  String get lockAfter15Minutes => '15 dakika sonra';

  @override
  String get lockAfter30Minutes => '30 dakika sonra';

  @override
  String get syncCloudAccounts => 'Bulut Hesaplarını Eşitle';

  @override
  String get syncCloudAccountsSubtitle =>
      'Yapılandırmaları güvenli depolamadan yeniden yükleyin';

  @override
  String get syncCloudAccountsSuccess => 'Bulut hesapları başarıyla eşitlendi';

  @override
  String get clearAllCredentials => 'Tüm Kimlik Bilgilerini Temizle';

  @override
  String get clearAllCredentialsSubtitle =>
      'Şifreli yapılandırmayı kaldırır ve tüm bulut bağlantılarını keser';

  @override
  String get clearCredentialsDialogTitle => 'Uyarı: Kimlik Bilgilerini Sıfırla';

  @override
  String get clearCredentialsDialogContent =>
      'Kayıtlı tüm hesapları silmek istediğinizden emin misiniz? Tekrar giriş yapmanız gerekecektir.';

  @override
  String get clearCredentialsSuccess => 'Kimlik bilgileri başarıyla temizlendi';

  @override
  String get aboutUnifyCloud => 'UnifyCloud Hakkında';

  @override
  String get appVersion => 'Uygulama Sürümü: 1.0.0';

  @override
  String get developerInfo => 'Geliştirici: LeoRise (@leorise25)';

  @override
  String get engineInfo => 'Motor: Rclone Core CGO (Go v1.22+ / C FFI)';

  @override
  String get frameworkInfo => 'Çerçeve: Flutter (Material 3 Responsive)';

  @override
  String get licenseInfo => 'Lisans: GNU General Public License v3.0 (GPL-3.0)';

  @override
  String get copyrightInfo => 'Telif Hakkı: © 2026 Leonardo Bani';

  @override
  String get storageOverview => 'Depolama Özeti';

  @override
  String get connectedClouds => 'Bağlı Bulutlar';

  @override
  String get noCloudsConfigured => 'Yapılandırılmış bulut yok';

  @override
  String get noCloudsDescription =>
      'Dosyaları yönetmek ve eşitlemek için ilk bulut hesabınızı bağlayın.';

  @override
  String get addCloud => 'Bulut Ekle';

  @override
  String get used => 'kullanılan';

  @override
  String get free => 'boş';

  @override
  String get total => 'toplam';

  @override
  String get manageAccounts => 'Hesapları Yönet';

  @override
  String get viewFiles => 'Dosyaları Görüntüle';

  @override
  String get createVaultHere => 'Burada şifreli kasa oluştur...';

  @override
  String get disconnectAccount => 'Hesabın Bağlantısını Kes';

  @override
  String get disconnectConfirmTitle => 'Bağlantı kesilsin mi?';

  @override
  String get disconnectConfirmContent =>
      'Bu hesabın bağlantısını kesmek istediğinizden emin misiniz? Buluttaki dosyalarınıza dokunulmaz.';

  @override
  String get allFiles => 'Tüm Dosyalar';

  @override
  String get emptyFolder => 'Boş Klasör';

  @override
  String get emptyFolderSubtitle =>
      'Başlamak için dosya yükleyin veya bir klasör oluşturun';

  @override
  String get uploadFile => 'Dosya Yükle';

  @override
  String get uploadFolder => 'Klasör Yükle';

  @override
  String get newFolder => 'Yeni Klasör';

  @override
  String get newFolderPrompt => 'Yeni klasörün adını girin:';

  @override
  String get folderNameHint => 'Klasör Adı';

  @override
  String get selectAll => 'Tümünü Seç';

  @override
  String get clearSelection => 'Seçimi Temizle';

  @override
  String get deleteSelected => 'Seçilenleri Sil';

  @override
  String get deleteSelectedPrompt =>
      'Seçili öğeleri silmek istediğinizden emin misiniz?';

  @override
  String get deleteItemPrompt => 'Bu öğeyi silmek istediğinizden emin misiniz?';

  @override
  String get shareLink => 'Paylaşım Bağlantısı';

  @override
  String get createShareLink => 'Paylaşım Bağlantısı Oluştur';

  @override
  String get copyShareLink => 'Bağlantıyı Kopyala';

  @override
  String get copiedToClipboard => 'Panoya kopyalandı';

  @override
  String get transfers => 'Transferler';

  @override
  String get activeTransfers => 'Etkin Transferler';

  @override
  String get completed => 'Tamamlananlar';

  @override
  String get failed => 'Başarısız';

  @override
  String get queued => 'Kuyrukta';

  @override
  String get cancelTransfer => 'Transferi İptal Et';

  @override
  String get clearCompleted => 'Tamamlananları Temizle';

  @override
  String get syncRulesTitle => 'Senkronizasyon Kuralları';

  @override
  String get newRule => 'Yeni Kural';

  @override
  String get noSyncRules => 'Yapılandırılmış senkronizasyon kuralı yok';

  @override
  String get noSyncRulesSubtitle =>
      'Kural yok. Yedeklemeleri otomatikleştirmek için bir kural oluşturun.';

  @override
  String get ruleName => 'Kural Adı';

  @override
  String get sourcePath => 'Kaynak Klasör';

  @override
  String get destinationCloud => 'Hedef Bulut';

  @override
  String get destinationPath => 'Hedef Yol';

  @override
  String get direction => 'Yön';

  @override
  String get frequency => 'Sıklık';

  @override
  String get runNow => 'Şimdi Çalıştır';

  @override
  String get syncInProgress => 'Senkronizasyon sürüyor...';

  @override
  String get syncSuccess => 'Senkronizasyon tamamlandı';

  @override
  String get syncFailed => 'Senkronizasyon başarısız oldu';

  @override
  String get addCloudDialogTitle => 'Yeni Bulut Bağla';

  @override
  String get selectProvider => 'Sağlayıcı Seçin';

  @override
  String get accountNameLabel => 'Hesap Adı';

  @override
  String get connectButton => 'Bağlan';

  @override
  String get vaultTitle => 'Şifreli Kasa';

  @override
  String get vaultPassword => 'Kasa Şifresi';

  @override
  String get vaultConfirmPassword => 'Şifreyi Onayla';

  @override
  String get vaultSalt => 'Şifreleme Tuzu (İsteğe bağlı)';

  @override
  String get encryptFileNames => 'Dosya adlarını şifrele';

  @override
  String get encryptDirNames => 'Klasör adlarını şifrele';

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
  String get selectLanguage => 'Dil Seçin';

  @override
  String get searchLanguageHint => 'Dil veya ülke ara...';

  @override
  String get currentLanguage => 'Mevcut Dil';

  @override
  String systemDefaultWithLocale(String locale) {
    return 'Sistem Varsayılanı ($locale)';
  }

  @override
  String get refreshCloudsTooltip => 'Yapılandırılmış bulutları yenile';

  @override
  String get storageOverviewAggregated => 'Birleşik Depolama Özeti';

  @override
  String get ramEncryptionActive => 'RAM Şifrelemesi Etkin';

  @override
  String connectedAccountsCount(int count) {
    return 'Bağlı Bulut Hesapları: $count';
  }

  @override
  String get noCloudsConfiguredHint =>
      'Bağlı bulut hesabı yok. Aşağıdaki \"+ Yeni Bulut Bağla\" seçeneğine dokunun.';

  @override
  String percentUsed(String percent) {
    return '%$percent kullanıldı';
  }

  @override
  String availableSpace(String space) {
    return '$space kullanılabilir';
  }

  @override
  String get calculatingQuota => 'Depolama kotaları hesaplanıyor...';

  @override
  String get syncAndBackup => 'Eşitleme ve Yedekleme';

  @override
  String get noRulesConfigured => 'Kural yapılandırılmadı';

  @override
  String activeRulesCount(int active, int total) {
    return '$active/$total etkin kural';
  }

  @override
  String get manage => 'Yönet';

  @override
  String connectedCloudsCount(int count) {
    return 'Bağlı Bulutlar ($count)';
  }

  @override
  String get connectNewCloud => 'Yeni Bulut Bağla';

  @override
  String get noCloudProvidersConnected => 'Bağlı bulut sağlayıcısı yok';

  @override
  String get connectCloudDescription =>
      'Dosyalarınızı eşitlemek için Google Drive, Dropbox, OneDrive, SFTP veya WebDAV bağlayın.';

  @override
  String get addFirstCloud => 'İlk Bulutu Ekle';

  @override
  String vaultOnRemote(String remote) {
    return '$remote ÜZERİNDE KASA';
  }

  @override
  String get disconnectCloudTitle => 'Bulut Bağlantısını Kes';

  @override
  String disconnectCloudPrompt(String name) {
    return '\"$name\" hesabının bağlantısını kesmek istediğinizden emin misiniz? Kimlik bilgileri kaldırılacaktır.';
  }

  @override
  String get disconnect => 'Bağlantıyı Kes';

  @override
  String freeSpace(String space) {
    return '$space boş';
  }

  @override
  String get storage => 'Depolama';

  @override
  String get available => 'Kullanılabilir';

  @override
  String get exploreFiles => 'Dosyaları Keşfet';

  @override
  String get paneLeft => 'Sol';

  @override
  String get paneRight => 'Sağ';

  @override
  String get folderName => 'Klasör Adı';

  @override
  String errorCreatingFolder(String error) {
    return 'Klasör oluşturulurken hata: $error';
  }

  @override
  String get moveAction => 'Taşı';

  @override
  String get copyAction => 'Kopyala';

  @override
  String transferBatchStarted(String action, int count, String remote) {
    return '$count öğenin [$remote] konumuna $action işlemi başladı...';
  }

  @override
  String errorTransferring(String error) {
    return 'Transfer sırasında hata: $error';
  }

  @override
  String itemCopiedToClipboard(String name) {
    return '\"$name\" panoya kopyalandı';
  }

  @override
  String itemsCopiedToClipboard(int count) {
    return '$count öğe panoya kopyalandı';
  }

  @override
  String itemCutToClipboard(String name) {
    return '\"$name\" kesildi (taşınmaya hazır)';
  }

  @override
  String itemsCutToClipboard(int count) {
    return '$count öğe kesildi (taşınmaya hazır)';
  }

  @override
  String get noFilesSelectedForDownload => 'İndirmek için dosya seçilmedi';

  @override
  String downloadingItems(int count) {
    return '$count öğe indiriliyor...';
  }

  @override
  String itemsDownloadedSuccess(int count, String path) {
    return '$count öğe \"$path\" konumuna indirildi';
  }

  @override
  String errorStartingDownload(String error) {
    return 'İndirme başlatılırken hata: $error';
  }

  @override
  String deleteItemsConfirmTitle(int count) {
    return '$count seçili öğe silinsin mi?';
  }

  @override
  String deleteItemsConfirmPrompt(int count) {
    return '$count seçili öğeyi buluttan kalıcı olarak silmek istediğinizden emin misiniz?';
  }

  @override
  String itemsDeletedSuccess(int count) {
    return '$count öğe silindi';
  }

  @override
  String errorDeleting(String error) {
    return 'Silme sırasında hata: $error';
  }

  @override
  String get uploadCompletedSuccess => 'Yükleme başarıyla tamamlandı';

  @override
  String errorUploading(String error) {
    return 'Yükleme sırasında hata: $error';
  }

  @override
  String get folderUploadCompletedSuccess =>
      'Klasör yükleme başarıyla tamamlandı';

  @override
  String errorFolderUploading(String error) {
    return 'Klasör yüklenirken hata: $error';
  }

  @override
  String get filesAlreadyInDirectory => 'Dosyalar zaten bu dizinde bulunuyor';

  @override
  String dragDropTransferStarted(String action, int count, String remote) {
    return '$count öğenin [$remote] konumuna $action işlemi başladı...';
  }

  @override
  String errorDragDrop(String error) {
    return 'Sürükle-bırak transfer hatası: $error';
  }

  @override
  String get closeSelection => 'Seçimi Kapat';

  @override
  String itemsSelectedCount(int count) {
    return '$count seçildi';
  }

  @override
  String get deselectAll => 'Tüm seçimi kaldır';

  @override
  String copyToRemote(String remote) {
    return '$remote konumuna kopyala';
  }

  @override
  String moveToRemote(String remote) {
    return '$remote konumuna taşı';
  }

  @override
  String get moreActions => 'Diğer Eylemler';

  @override
  String get downloadSelected => 'Seçilenleri İndir';

  @override
  String get copyToClipboard => 'Panoya Kopyala';

  @override
  String get cutToClipboard => 'Panoya Kes';

  @override
  String get selectCloud => 'Bulut Seçin';

  @override
  String get closeSearch => 'Aramayı Kapat';

  @override
  String get uploadFromDevice => 'Cihazdan Yükle';

  @override
  String get moreOptions => 'Daha Fazla Seçenek';

  @override
  String get viewGrid => 'Izgara Görünümü';

  @override
  String get viewList => 'Liste Görünümü';

  @override
  String get multiSelection => 'Çoklu Seçim';

  @override
  String get sortNameAsc => 'İsim (A-Z)';

  @override
  String get sortNameDesc => 'İsim (Z-A)';

  @override
  String get sortSizeDesc => 'Boyut (Büyük-Küçük)';

  @override
  String get sortSizeAsc => 'Boyut (Küçük-Büyük)';

  @override
  String get sortDateDesc => 'Son Değiştirilme';

  @override
  String get disableDualPane => 'Çift Paneli Devre Dışı Bırak';

  @override
  String get enableDualPane => 'Çift Paneli Etkinleştir';

  @override
  String itemsInClipboard(int count) {
    return 'Panoda $count öğe var';
  }

  @override
  String get pasteHere => 'Buraya Yapıştır';

  @override
  String get noResults => 'Sonuç bulunamadı';

  @override
  String noMatchingResults(String query) {
    return '\"$query\" ile eşleşen dosya veya klasör bulunamadı';
  }

  @override
  String get selectACloud => 'Bir Bulut Seçin';

  @override
  String get selectCloudDescription =>
      'Göz atmaya başlamak için yukarıdaki menüden bir bulut hesabı seçin.';

  @override
  String optionsForItem(String name) {
    return '$name için seçenekler';
  }

  @override
  String get select => 'Seç';

  @override
  String get openWithSystemApp => 'Sistem uygulamasıyla aç';

  @override
  String get downloadToLocal => 'Cihaza İndir';

  @override
  String get cut => 'Kes';

  @override
  String get copyPath => 'Yolu Kopyala';

  @override
  String get info => 'Bilgi';

  @override
  String generatingShareLink(String name) {
    return '\"$name\" için paylaşım bağlantısı oluşturuluyor...';
  }

  @override
  String errorPublicLink(String error) {
    return 'Genel bağlantı hatası: $error';
  }

  @override
  String get noLinkGenerated => 'Sunucu tarafından bağlantı oluşturulamadı';

  @override
  String errorDownloading(String error) {
    return 'İndirme hatası: $error';
  }

  @override
  String get renameFolderTitle => 'Klasörü Yeniden Adlandır';

  @override
  String get renameFileTitle => 'Dosyayı Yeniden Adlandır';

  @override
  String errorRenaming(String error) {
    return 'Yeniden adlandırma hatası: $error';
  }

  @override
  String get pathCopiedToClipboard => 'Yol panoya kopyalandı';

  @override
  String itemDetailsPath(String path) {
    return 'Yol: $path';
  }

  @override
  String itemDetailsType(String type) {
    return 'Tür: $type';
  }

  @override
  String itemDetailsSize(String size) {
    return 'Boyut: $size';
  }

  @override
  String itemDetailsModified(String date) {
    return 'Değiştirilme tarihi: $date';
  }

  @override
  String get folder => 'Klasör';

  @override
  String get file => 'Dosya';

  @override
  String get selectCloudFirstLeft => 'Önce sol panel için bir bulut seçin';

  @override
  String get selectCloudFirstRight => 'Önce sağ panel için bir bulut seçin';

  @override
  String get selectDestinationCloudLeft =>
      'Hedef olarak sol panelde bir bulut seçin';

  @override
  String get selectDestinationCloudRight =>
      'Hedef olarak sağ panelde bir bulut seçin';

  @override
  String get noFilesToTransfer => 'Aktarılacak dosya seçilmedi';

  @override
  String transferStarted(String action, int count, String src, String dst) {
    return '$count öğenin [$src] kaynağından [$dst] hedefine $action işlemi başladı...';
  }

  @override
  String get swapPanesTooltip => 'Panellerin yerini değiştir';

  @override
  String get refreshBothPanesTooltip => 'Her iki paneli yenile';

  @override
  String get copyRight => 'Sağa Kopyala ->';

  @override
  String get moveRight => 'Sağa Taşı ->';

  @override
  String get copyLeft => '<- Sola Kopyala';

  @override
  String get moveLeft => '<- Sola Taşı';

  @override
  String copyRightWithCount(int count) {
    return 'Sağa Kopyala ($count) ->';
  }

  @override
  String moveRightWithCount(int count) {
    return 'Sağa Taşı ($count) ->';
  }

  @override
  String copyLeftWithCount(int count) {
    return '<- Sola Kopyala ($count)';
  }

  @override
  String moveLeftWithCount(int count) {
    return '<- Sola Taşı ($count)';
  }

  @override
  String get deleteRuleTitle => 'Kuralı Sil';

  @override
  String deleteRulePrompt(String name) {
    return '\"$name\" senkronizasyon kuralını silmek istediğinizden emin misiniz? Dosyalar silinmeyecektir.';
  }

  @override
  String get syncAll => 'Tümünü Eşitle';

  @override
  String get newRuleTooltip => 'Yeni Kural Ekle';

  @override
  String get backupBannerTitle => 'Yedekleme ve Senkronizasyon';

  @override
  String get backupBannerSubtitle =>
      'Dosyalarınızı depolama konumları arasında otomatik olarak yansıtın';

  @override
  String get noActiveRules => 'Etkin senkronizasyon kuralı yok';

  @override
  String get noActiveRulesSubtitle =>
      'Klasörleri bir takvime göre otomatik eşitlemek için bir kural oluşturun.';

  @override
  String get createNewRule => 'Yeni Kural Oluştur';

  @override
  String get ruleOptionsTooltip => 'Kural Seçenekleri';

  @override
  String get syncNow => 'Şimdi Eşitle';

  @override
  String get statusWaiting => 'Bekliyor';

  @override
  String get statusInProgress => 'Sürüyor...';

  @override
  String get statusCompleted => 'Tamamlandı';

  @override
  String get statusFailed => 'Başarısız';

  @override
  String get editRuleTitle => 'Senkronizasyon Kuralını Düzenle';

  @override
  String get newRuleTitle => 'Yeni Senkronizasyon Kuralı';

  @override
  String get ruleDialogSubtitle =>
      'Senkronizasyonun kaynağını, hedefini ve sıklığını tanımlayın';

  @override
  String get ruleNameOptional => 'Kural Adı (İsteğe bağlı)';

  @override
  String get ruleNameHint => 'örn. Belgelerin Otomatik Yedeklemesi';

  @override
  String get sourceLocalFolder => 'Yerel Kaynak Klasör';

  @override
  String get sourceLocalFolderHint => 'Bir yerel klasör seçin...';

  @override
  String get browseFolders => 'Gözat';

  @override
  String get selectLocalFolderError => 'Lütfen yerel bir kaynak klasör seçin';

  @override
  String get noCloudsConfiguredSync =>
      'Yapılandırılmış bulut yok. Önce Ayarlar\'dan bir bulut ekleyin.';

  @override
  String get remoteDestinationPath => 'Hedef Bulut Yolu';

  @override
  String get syncMode => 'Mod';

  @override
  String get syncModeCopy => 'Kopyalama (Yalnızca yeni/güncellenenleri ekle)';

  @override
  String get syncModeCopyDesc =>
      'Yeni ve güncellenen dosyaları hedefe kopyalar, hedefteki hiçbir dosyayı silmez.';

  @override
  String get syncModeSync => 'Eşitleme (Ayna)';

  @override
  String get syncModeSyncDesc =>
      'Hedefi kaynakla tamamen aynı yapar. Kaynakta silinen dosyalar hedefte de silinir.';

  @override
  String get syncFrequency => 'Eşitleme Sıklığı';

  @override
  String get freqManual => 'Yalnızca Manuel';

  @override
  String get freq15Min => 'Her 15 dakikada bir';

  @override
  String get freq30Min => 'Her 30 dakikada bir';

  @override
  String get freqHourly => 'Her saat';

  @override
  String get freq6Hours => 'Her 6 saatte bir';

  @override
  String get freq12Hours => 'Her 12 saatte bir';

  @override
  String get freqDaily => 'Günlük';

  @override
  String get activateRuleImmediately => 'Kuralı hemen etkinleştir';

  @override
  String get activateRuleImmediatelyDesc =>
      'Devre dışı bırakıldığında kural otomatik olarak çalışmaz';

  @override
  String get updateRule => 'Kuralı Güncelle';

  @override
  String get saveRule => 'Kuralı Kaydet';

  @override
  String get selectCloudProvider => 'Bir sağlayıcı seçin';

  @override
  String get cloudAccountName => 'Hesap Adı';

  @override
  String get cloudAccountNameHint => 'örn. Kişisel Depolamam';

  @override
  String get enterNameError => 'Lütfen bir hesap adı girin';

  @override
  String get noSpacesOrColons => 'Ad boşluk veya iki nokta üst üste içeremez';

  @override
  String get oauthMode => 'OAuth Kimlik Doğrulama Modu';

  @override
  String get oauthOfficial => 'Resmi Uygulama (Önerilen)';

  @override
  String get oauthRclone => 'Varsayılan Rclone';

  @override
  String get oauthCustom => 'Özel Client ID ve Secret';

  @override
  String get officialOauthTitle => 'Resmi UnifyCloud OAuth';

  @override
  String get officialOauthDesc =>
      'Tarayıcı aracılığıyla hızlı ve güvenli kurulum için resmi API kimlik bilgilerini kullanır.';

  @override
  String get rcloneOauthDesc =>
      'Varsayılan genel Rclone kimlik bilgilerini kullanır. API hız sınırlarına tabi olabilir.';

  @override
  String get customClientId => 'Özel İstemci Kimliği (Client ID)';

  @override
  String get customClientSecret =>
      'Özel İstemci Gizli Anahtarı (Client Secret)';

  @override
  String get selectVaultDestination => 'Kasa için hedef bulut seçin';

  @override
  String get vaultPasswordRequired => 'Lütfen kasa için bir şifre girin';

  @override
  String get vaultPasswordsDoNotMatch => 'Şifreler eşleşmiyor';

  @override
  String errorAddingRemote(String error) {
    return 'Hesap eklenirken hata: $error';
  }

  @override
  String get fileNameEncryption => 'Dosya Adı Şifreleme';

  @override
  String get encryptStandard => 'Standart (Önerilen – tam şifreleme)';

  @override
  String get encryptObscure => 'Gizleme (Obfuscate)';

  @override
  String get encryptOff => 'Kapalı (Dosya adlarını görünür bırak)';

  @override
  String get encryptFolderNames => 'Klasör adlarını şifrele';

  @override
  String get encryptFolderNamesDesc =>
      'Kasa içindeki klasör adlarını da gizler';

  @override
  String get connectCloud => 'Bulutu Bağla';

  @override
  String get reopenAuth => 'Tarayıcı Yetkilendirmesini Tekrar Aç';

  @override
  String get linkCopiedToClipboard => 'Bağlantı panoya kopyalandı';

  @override
  String errorOpenBrowserGeneric(String error) {
    return 'Tarayıcı açılamadı: $error';
  }

  @override
  String get shareableLinkTitle => 'Paylaşılabilir Bağlantı:';

  @override
  String shareLinkAccessDescription(String item) {
    return 'Bu bağlantıya sahip olan herkes $item öğesine erişebilir:';
  }

  @override
  String get open => 'Aç';

  @override
  String activeTransfersCount(int count) {
    return '$count etkin transfer';
  }

  @override
  String transfersQueueCount(int count) {
    return 'Transfer Kuyruğu ($count)';
  }

  @override
  String get noTransfersInProgress => 'Etkin transfer yok';

  @override
  String get transfersEmptySubtitle =>
      'Dosya transferleri burada gerçek zamanlı olarak görüntülenecektir.';

  @override
  String get cancelled => 'İptal Edildi';

  @override
  String get appLockedTitle => 'Uygulama Kilitlendi';

  @override
  String get unlockWithBiometrics => 'Biyometri ile Kilidi Aç';

  @override
  String get pinMustBe6Digits => 'PIN kodu en az 4 haneli olmalıdır';

  @override
  String get pinIncorrect => 'Geçersiz PIN';

  @override
  String get pinsDoNotMatch => 'PIN kodları eşleşmiyor. Lütfen tekrar deneyin.';

  @override
  String get pinStepOld => 'Mevcut PIN\'i girin';

  @override
  String get pinStepNew => 'Yeni PIN\'i girin';

  @override
  String get pinStepConfirm => 'Yeni PIN\'i onaylayın';

  @override
  String get pinStepVerify => 'PIN kodunuzu girin';

  @override
  String get pinTitleSetup => 'Uygulama Kilidi PIN\'i Ayarla';

  @override
  String get pinTitleChange => 'PIN\'i Değiştir';

  @override
  String get pinTitleVerify => 'PIN Gerekli';

  @override
  String get pinContinue => 'Devam Et';

  @override
  String get errorDetails => 'Hata Ayrıntıları';

  @override
  String get errorDetailsCopied => 'Hata ayrıntıları panoya kopyalandı';

  @override
  String get collapse => 'Daralt';

  @override
  String get expand => 'Ayrıntıları Genişlet';

  @override
  String get copyError => 'Hatayı Kopyala';

  @override
  String get errorNetwork =>
      'Ağ hatası. Lütfen internet bağlantınızı kontrol edin.';

  @override
  String get errorDiskSpace => 'Hedef cihazda yetersiz disk alanı.';

  @override
  String get errorAuthExpired =>
      'Oturum süresi doldu veya kimlik bilgileri iptal edildi. Lütfen tekrar giriş yapın.';

  @override
  String get errorNotFound => 'İstenen dosya veya klasör bulunamadı.';

  @override
  String get errorPermissionDenied =>
      'Erişim reddedildi. Gerekli izinlere sahip değilsiniz.';

  @override
  String get errorGeneric => 'Beklenmeyen bir bulut hatası oluştu.';

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
