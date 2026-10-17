// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'UnifyCloud';

  @override
  String get home => 'होम';

  @override
  String get explorer => 'फ़ाइलें';

  @override
  String get sync => 'सिंक';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get confirm => 'पुष्टि करें';

  @override
  String get delete => 'हटाएं';

  @override
  String get save => 'सहेजें';

  @override
  String get close => 'बंद करें';

  @override
  String get edit => 'संपादित करें';

  @override
  String get create => 'बनाएं';

  @override
  String get retry => 'पुनः प्रयास करें';

  @override
  String get copy => 'कॉपी करें';

  @override
  String get move => 'स्थानांतरित करें';

  @override
  String get rename => 'नाम बदलें';

  @override
  String get download => 'डाउनलोड';

  @override
  String get upload => 'अपलोड';

  @override
  String get share => 'साझा करें';

  @override
  String get details => 'विवरण';

  @override
  String get search => 'खोजें';

  @override
  String get change => 'बदलें';

  @override
  String get reset => 'रीसेट करें';

  @override
  String get done => 'पूर्ण';

  @override
  String get loading => 'लोड हो रहा है...';

  @override
  String get success => 'कार्य पूर्ण हुआ';

  @override
  String get error => 'त्रुटि';

  @override
  String get settingsTitle => 'सेटिंग्स';

  @override
  String get resetDefaultsTooltip => 'डिफ़ॉल्ट सेटिंग्स पुनर्स्थापित करें';

  @override
  String get resetDialogTitle => 'सेटिंग्स रीसेट करें';

  @override
  String get resetDialogContent =>
      'क्या आप सभी प्राथमिकताओं (थीम, भाषा, फ़ोल्डर, प्रदर्शन) को फ़ैक्टरी डिफ़ॉल्ट पर रीसेट करना चाहते हैं?';

  @override
  String get resetSuccessSnackbar =>
      'सेटिंग्स डिफ़ॉल्ट मानों पर पुनर्स्थापित की गईं';

  @override
  String get appearanceAndTheme => 'दिखावट और थीम';

  @override
  String get chooseVisualThemeSubtitle =>
      'UnifyCloud इंटरफ़ेस के लिए थीम चुनें:';

  @override
  String get themeSystem => 'सिस्टम';

  @override
  String get themeLight => 'लाइट';

  @override
  String get themeDark => 'डार्क';

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
  String get language => 'भाषा';

  @override
  String get languageSubtitle => 'ऐप इंटरफ़ेस की भाषा चुनें';

  @override
  String get langEnglish => 'English';

  @override
  String get langItalian => 'Italiano';

  @override
  String get langSystem => 'सिस्टम डिफ़ॉल्ट';

  @override
  String get filesAndExploration => 'फ़ाइलें और अन्वेषण';

  @override
  String get showHiddenFiles => 'छिपी हुई फ़ाइलें दिखाएं';

  @override
  String get showHiddenFilesSubtitle =>
      'डॉट (.) से शुरू होने वाली फ़ाइलें और फ़ोल्डर प्रदर्शित करें';

  @override
  String get confirmBeforeDelete => 'हटाने से पहले पुष्टि करें';

  @override
  String get confirmBeforeDeleteSubtitle =>
      'फ़ाइलों को स्थायी रूप से हटाने से पहले सुरक्षा पुष्टि मांगें';

  @override
  String get defaultDownloadFolder => 'डिफ़ॉल्ट डाउनलोड फ़ोल्डर';

  @override
  String get defaultDownloadFolderSystem =>
      'सिस्टम डिफ़ॉल्ट डाउनलोड निर्देशिका';

  @override
  String get restoreDefaultPath => 'डिफ़ॉल्ट पथ पुनर्स्थापित करें';

  @override
  String get customDownloadFolderDialogPrompt =>
      'सिस्टम पिकर से फ़ोल्डर चुनें या मैन्युअल रूप से पथ दर्ज करें:';

  @override
  String get folderPath => 'फ़ोल्डर पथ';

  @override
  String get folderPathHint => 'उदा. /home/user/Downloads';

  @override
  String get browseWithSystemPicker => 'सिस्टम पिकर से ब्राउज़ करें';

  @override
  String errorOpenPicker(String error) {
    return 'सिस्टम पिकर खोलने में असमर्थ: $error';
  }

  @override
  String get restoreDefault => 'डिफ़ॉल्ट पुनर्स्थापित करें';

  @override
  String get maxConcurrentTransfers => 'समवर्ती स्थानांतरण';

  @override
  String get maxConcurrentTransfersSubtitle =>
      'एक साथ सक्रिय फ़ाइल स्थानांतरणों की अधिकतम संख्या';

  @override
  String get dualPaneMode => 'दोहरा फलक कमांडर मोड';

  @override
  String get dualPaneModeSubtitle =>
      'बड़ी स्क्रीन और टैबलेट पर दो फलक साथ-साथ प्रदर्शित करें';

  @override
  String get communityAndSupport => 'समुदाय और सहायता';

  @override
  String get openSourceDescription =>
      'UnifyCloud एक मुफ़्त और ओपन-सोर्स सॉफ़्टवेयर है जो बिना ट्रैकर्स के आपके क्लाउड डेटा को एकीकृत करता है।';

  @override
  String get supportDeveloper => 'डेवलपर का समर्थन करें';

  @override
  String get supportDeveloperSubtitle =>
      'स्वतंत्र विकास का समर्थन करने के लिए कॉफी खरीदें';

  @override
  String get viewSourceOnGitLab => 'GitLab पर कोड देखें';

  @override
  String get viewSourceOnGitLabSubtitle =>
      'आधिकारिक रिपॉजिटरी, बग रिपोर्ट और योगदान';

  @override
  String errorOpenBrowser(String url) {
    return 'ब्राउज़र खोलने में असमर्थ। रिपॉजिटरी: $url';
  }

  @override
  String get supportDialogTitle => 'UnifyCloud का समर्थन करें';

  @override
  String get supportDialogDescription1 =>
      'UnifyCloud एक निःशुल्क और ओपन-सोर्स प्रोजेक्ट है जो आपको अपनी क्लाउड फ़ाइलों पर पूर्ण नियंत्रण देता है।';

  @override
  String get supportDialogDescription2 =>
      'यदि यह ऐप आपके लिए उपयोगी है, तो निरंतर विकास का समर्थन करने के लिए एक कॉफी या दान दें!';

  @override
  String get supportKofiTitle => 'Ko-fi पर कॉफी खरीदें';

  @override
  String get supportLiberapayTitle => 'Liberapay पर दान करें';

  @override
  String get supportPaypalTitle => 'PayPal के माध्यम से दान करें';

  @override
  String get securityAndEncryption => 'सुरक्षा और एन्क्रिप्शन';

  @override
  String get securityArchitectureDescription =>
      'UnifyCloud शून्य-प्लेनटेक्स्ट आर्किटेक्चर का उपयोग करता है। सभी टोकन और क्रेडेंशियल्स सिस्टम कीचेन में सुरक्षित हैं और केवल Go इंजन मेमोरी में लोड होते हैं।';

  @override
  String get appLock => 'ऐप लॉक (पिन / बायोमेट्रिक्स)';

  @override
  String get appLockSubtitle =>
      'प्रवेश के लिए पिन या फ़िंगरप्रिंट की आवश्यकता रखें';

  @override
  String get appLockActiveSubtitle =>
      'प्रारंभ में और निष्क्रियता के बाद सक्रिय';

  @override
  String get appLockEnabledSnackbar => 'ऐप लॉक सफलतापूर्वक सक्षम किया गया';

  @override
  String get appLockDisabledSnackbar => 'ऐप लॉक अक्षम किया गया';

  @override
  String get changePin => 'पिन बदलें';

  @override
  String get changePinSubtitle => 'नया 6-अंकीय सुरक्षा पिन सेट करें';

  @override
  String get pinChangedSnackbar => 'सुरक्षा पिन सफलतापूर्वक अपडेट किया गया';

  @override
  String get biometricAuth => 'बायोमेट्रिक प्रमाणीकरण';

  @override
  String get biometricAuthSubtitle =>
      'उपलब्ध होने पर फ़िंगरप्रिंट या बायोमेट्रिक सेंसर का उपयोग करें';

  @override
  String get biometricNotAvailable =>
      'इस डिवाइस पर उपलब्ध या कॉन्फ़िगर नहीं है';

  @override
  String get autoLock => 'ऑटो लॉक';

  @override
  String get autoLockSubtitle => 'लॉक करने से पहले बैकग्राउंड निष्क्रियता समय';

  @override
  String get lockImmediately => 'तुरंत';

  @override
  String get lockAfter1Minute => '1 मिनट बाद';

  @override
  String get lockAfter5Minutes => '5 मिनट बाद';

  @override
  String get lockAfter15Minutes => '15 मिनट बाद';

  @override
  String get lockAfter30Minutes => '30 मिनट बाद';

  @override
  String get syncCloudAccounts => 'क्लाउड खाते सिंक करें';

  @override
  String get syncCloudAccountsSubtitle =>
      'सुरक्षित स्टोरेज से कॉन्फ़िगरेशन पुनः लोड करें';

  @override
  String get syncCloudAccountsSuccess =>
      'क्लाउड खाते सफलतापूर्वक पुनः लोड किए गए';

  @override
  String get clearAllCredentials => 'सभी क्रेडेंशियल्स साफ़ करें';

  @override
  String get clearAllCredentialsSubtitle =>
      'एन्क्रिप्टेड कॉन्फ़िगरेशन हटाता है और सभी क्लाउड डिस्कनेक्ट करता है';

  @override
  String get clearCredentialsDialogTitle => 'चेतावनी: क्रेडेंशियल्स रीसेट करें';

  @override
  String get clearCredentialsDialogContent =>
      'क्या आप सभी सहेजे गए क्रेडेंशियल्स हटाना चाहते हैं? आपको अपने क्लाउड खातों को फिर से कनेक्ट करना होगा।';

  @override
  String get clearCredentialsSuccess => 'क्रेडेंशियल्स सफलतापूर्वक हटा दिए गए';

  @override
  String get aboutUnifyCloud => 'UnifyCloud के बारे में';

  @override
  String get appVersion => 'ऐप संस्करण: 1.0.0';

  @override
  String get developerInfo => 'डेवलपर: LeoRise (@leorise25)';

  @override
  String get engineInfo => 'इंजन: Rclone Core CGO (Go v1.22+ / C FFI)';

  @override
  String get frameworkInfo => 'फ़्रेमवर्क: Flutter (Material 3 Responsive)';

  @override
  String get licenseInfo =>
      'लाइसेंस: GNU General Public License v3.0 (GPL-3.0)';

  @override
  String get copyrightInfo => 'कॉपीराइट: © 2026 Leonardo Bani';

  @override
  String get storageOverview => 'स्टोरेज अवलोकन';

  @override
  String get connectedClouds => 'कनेक्टेड क्लाउड';

  @override
  String get noCloudsConfigured => 'कोई क्लाउड खाता कॉन्फ़िगर नहीं है';

  @override
  String get noCloudsDescription =>
      'फ़ाइलों को प्रबंधित और सिंक करना शुरू करने के लिए अपना पहला क्लाउड खाता कनेक्ट करें।';

  @override
  String get addCloud => 'क्लाउड जोड़ें';

  @override
  String get used => 'प्रयुक्त';

  @override
  String get free => 'खाली';

  @override
  String get total => 'कुल';

  @override
  String get manageAccounts => 'खाते प्रबंधित करें';

  @override
  String get viewFiles => 'फ़ाइलें देखें';

  @override
  String get createVaultHere => 'यहाँ एन्क्रिप्टेड वॉल्ट बनाएं...';

  @override
  String get disconnectAccount => 'खाता डिस्कनेक्ट करें';

  @override
  String get disconnectConfirmTitle => 'खाता डिस्कनेक्ट करें?';

  @override
  String get disconnectConfirmContent =>
      'क्या आप वाकई इस खाते को डिस्कनेक्ट करना चाहते हैं? रिमोट फ़ाइलें बरकरार रहेंगी।';

  @override
  String get allFiles => 'सभी फ़ाइलें';

  @override
  String get emptyFolder => 'यह फ़ोल्डर खाली है';

  @override
  String get emptyFolderSubtitle =>
      'शुरू करने के लिए फ़ाइलें अपलोड करें या एक सबफ़ोल्डर बनाएं।';

  @override
  String get uploadFile => 'फ़ाइल अपलोड करें';

  @override
  String get uploadFolder => 'पूरा फ़ोल्डर अपलोड करें';

  @override
  String get newFolder => 'नया फ़ोल्डर';

  @override
  String get newFolderPrompt => 'नए फ़ोल्डर का नाम दर्ज करें:';

  @override
  String get folderNameHint => 'फ़ोल्डर का नाम';

  @override
  String get selectAll => 'सभी चुनें';

  @override
  String get clearSelection => 'चयन साफ़ करें';

  @override
  String get deleteSelected => 'चुने गए हटाएं';

  @override
  String get deleteSelectedPrompt =>
      'क्या आप वाकई चुने गए आइटम हटाना चाहते हैं?';

  @override
  String get deleteItemPrompt => 'क्या आप वाकई इस आइटम को हटाना चाहते हैं?';

  @override
  String get shareLink => 'लिंक साझा करें';

  @override
  String get createShareLink => 'साझा करने योग्य लिंक बनाएं';

  @override
  String get copyShareLink => 'लिंक कॉपी करें';

  @override
  String get copiedToClipboard => 'क्लिपबोर्ड पर कॉपी किया गया';

  @override
  String get transfers => 'स्थानांतरण';

  @override
  String get activeTransfers => 'सक्रिय स्थानांतरण';

  @override
  String get completed => 'पूर्ण';

  @override
  String get failed => 'विफल';

  @override
  String get queued => 'कतार में';

  @override
  String get cancelTransfer => 'स्थानांतरण रद्द करें';

  @override
  String get clearCompleted => 'पूर्ण साफ़ करें';

  @override
  String get syncRulesTitle => 'बैकअप और सिंक नियम';

  @override
  String get newRule => 'नया नियम';

  @override
  String get noSyncRules => 'कोई सिंक नियम कॉन्फ़िगर नहीं है';

  @override
  String get noSyncRulesSubtitle =>
      'स्थानीय फ़ोल्डर को क्लाउड से सिंक करने के लिए एक स्वचालित नियम बनाएं।';

  @override
  String get ruleName => 'नियम का नाम';

  @override
  String get sourcePath => 'स्रोत फ़ोल्डर';

  @override
  String get destinationCloud => 'गंतव्य क्लाउड';

  @override
  String get destinationPath => 'रिमोट पथ';

  @override
  String get direction => 'दिशा';

  @override
  String get frequency => 'आवृत्ति';

  @override
  String get runNow => 'अभी चलाएं';

  @override
  String get syncInProgress => 'सिंक जारी है...';

  @override
  String get syncSuccess => 'सिंक पूर्ण हुआ';

  @override
  String get syncFailed => 'सिंक विफल रहा';

  @override
  String get addCloudDialogTitle => 'नया क्लाउड कनेक्ट करें';

  @override
  String get selectProvider => 'क्लाउड प्रदाता चुनें';

  @override
  String get accountNameLabel => 'खाता नाम / उपनाम';

  @override
  String get connectButton => 'खाता कनेक्ट करें';

  @override
  String get vaultTitle => 'एंड-टू-एंड एन्क्रिप्शन (Crypt)';

  @override
  String get vaultPassword => 'वॉल्ट पासवर्ड';

  @override
  String get vaultConfirmPassword => 'पासवर्ड की पुष्टि करें';

  @override
  String get vaultSalt => 'साल्ट / द्वितीयक पासवर्ड (वैकल्पिक)';

  @override
  String get encryptFileNames => 'फ़ाइल नाम एन्क्रिप्ट करें';

  @override
  String get encryptDirNames => 'फ़ोल्डर नाम एन्क्रिप्ट करें';

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
  String get selectLanguage => 'भाषा चुनें';

  @override
  String get searchLanguageHint => 'भाषा या देश खोजें...';

  @override
  String get currentLanguage => 'वर्तमान भाषा';

  @override
  String systemDefaultWithLocale(String locale) {
    return 'सिस्टम डिफ़ॉल्ट ($locale)';
  }

  @override
  String get refreshCloudsTooltip => 'क्लाउड कॉन्फ़िगरेशन ताज़ा करें';

  @override
  String get storageOverviewAggregated => 'कुल स्टोरेज अवलोकन';

  @override
  String get ramEncryptionActive => 'RAM एन्क्रिप्शन सक्रिय';

  @override
  String connectedAccountsCount(int count) {
    return 'कनेक्टेड क्लाउड खाते: $count';
  }

  @override
  String get noCloudsConfiguredHint =>
      'कोई क्लाउड खाता नहीं है। नीचे \"+ नया क्लाउड कनेक्ट करें\" पर टैप करें।';

  @override
  String percentUsed(String percent) {
    return '$percent% प्रयुक्त';
  }

  @override
  String availableSpace(String space) {
    return '$space उपलब्ध';
  }

  @override
  String get calculatingQuota =>
      'स्टोरेज कोटा की गणना हो रही है या असीमित स्थान...';

  @override
  String get syncAndBackup => 'सिंक और बैकअप';

  @override
  String get noRulesConfigured => 'कोई नियम कॉन्फ़िगर नहीं है';

  @override
  String activeRulesCount(int active, int total) {
    return '$active/$total सक्रिय नियम';
  }

  @override
  String get manage => 'प्रबंधित करें';

  @override
  String connectedCloudsCount(int count) {
    return 'कनेक्टेड क्लाउड ($count)';
  }

  @override
  String get connectNewCloud => 'नया क्लाउड कनेक्ट करें';

  @override
  String get noCloudProvidersConnected => 'कोई क्लाउड प्रदाता कनेक्ट नहीं है';

  @override
  String get connectCloudDescription =>
      'फ़ाइलें सिंक और एक्सप्लोर करने के लिए Google Drive, Dropbox, OneDrive, SFTP या WebDAV कनेक्ट करें।';

  @override
  String get addFirstCloud => 'पहला क्लाउड जोड़ें';

  @override
  String vaultOnRemote(String remote) {
    return '$remote पर वॉल्ट';
  }

  @override
  String get disconnectCloudTitle => 'क्लाउड डिस्कनेक्ट करें';

  @override
  String disconnectCloudPrompt(String name) {
    return 'क्या आप \"$name\" को हटाना चाहते हैं? क्रेडेंशियल सुरक्षित स्टोरेज से हटा दिए जाएंगे।';
  }

  @override
  String get disconnect => 'डिस्कनेक्ट करें';

  @override
  String freeSpace(String space) {
    return '$space उपलब्ध';
  }

  @override
  String get storage => 'स्टोरेज';

  @override
  String get available => 'उपलब्ध';

  @override
  String get exploreFiles => 'फ़ाइलें एक्सप्लोर करें';

  @override
  String get paneLeft => 'बायाँ';

  @override
  String get paneRight => 'दायाँ';

  @override
  String get folderName => 'फ़ोल्डर का नाम';

  @override
  String errorCreatingFolder(String error) {
    return 'फ़ोल्डर निर्माण त्रुटि: $error';
  }

  @override
  String get moveAction => 'स्थानांतरण';

  @override
  String get copyAction => 'कॉपी';

  @override
  String transferBatchStarted(String action, int count, String remote) {
    return '$count आइटम का [$remote] पर $action शुरू हुआ...';
  }

  @override
  String errorTransferring(String error) {
    return 'स्थानांतरण के दौरान त्रुटि: $error';
  }

  @override
  String itemCopiedToClipboard(String name) {
    return '\"$name\" क्लिपबोर्ड पर कॉपी किया गया';
  }

  @override
  String itemsCopiedToClipboard(int count) {
    return '$count आइटम क्लिपबोर्ड पर कॉपी किए गए';
  }

  @override
  String itemCutToClipboard(String name) {
    return '\"$name\" कट किया गया (स्थानांतरण के लिए तैयार)';
  }

  @override
  String itemsCutToClipboard(int count) {
    return '$count आइटम कट किए गए (स्थानांतरण के लिए तैयार)';
  }

  @override
  String get noFilesSelectedForDownload =>
      'डाउनलोड के लिए कोई फ़ाइल नहीं चुनी गई।';

  @override
  String downloadingItems(int count) {
    return '$count आइटम डाउनलोड हो रहे हैं...';
  }

  @override
  String itemsDownloadedSuccess(int count, String path) {
    return '$count आइटम \"$path\" पर डाउनलोड किए गए';
  }

  @override
  String errorStartingDownload(String error) {
    return 'डाउनलोड प्रारंभ त्रुटि: $error';
  }

  @override
  String deleteItemsConfirmTitle(int count) {
    return 'चुने गए $count आइटम हटाएं?';
  }

  @override
  String deleteItemsConfirmPrompt(int count) {
    return 'क्या आप वाकई चुने गए $count आइटम क्लाउड से हमेशा के लिए हटाना चाहते हैं?';
  }

  @override
  String itemsDeletedSuccess(int count) {
    return '$count आइटम हटाए गए';
  }

  @override
  String errorDeleting(String error) {
    return 'हटाने के दौरान त्रुटि: $error';
  }

  @override
  String get uploadCompletedSuccess => 'अपलोड सफलतापूर्वक पूर्ण हुआ';

  @override
  String errorUploading(String error) {
    return 'अपलोड के दौरान त्रुटि: $error';
  }

  @override
  String get folderUploadCompletedSuccess =>
      'फ़ोल्डर अपलोड सफलतापूर्वक पूर्ण हुआ';

  @override
  String errorFolderUploading(String error) {
    return 'फ़ोल्डर अपलोड त्रुटि: $error';
  }

  @override
  String get filesAlreadyInDirectory =>
      'फ़ाइलें पहले से ही इस फ़ोल्डर में मौजूद हैं।';

  @override
  String dragDropTransferStarted(String action, int count, String remote) {
    return '$count आइटम का [$remote] पर $action शुरू हुआ...';
  }

  @override
  String errorDragDrop(String error) {
    return 'ड्रैग-एंड-ड्रॉप स्थानांतरण त्रुटि: $error';
  }

  @override
  String get closeSelection => 'चयन बंद करें';

  @override
  String itemsSelectedCount(int count) {
    return '$count चुने गए';
  }

  @override
  String get deselectAll => 'सभी अचयनित करें';

  @override
  String copyToRemote(String remote) {
    return '$remote पर कॉपी करें';
  }

  @override
  String moveToRemote(String remote) {
    return '$remote पर स्थानांतरित करें';
  }

  @override
  String get moreActions => 'अन्य क्रियाएं';

  @override
  String get downloadSelected => 'चुने गए डाउनलोड करें';

  @override
  String get copyToClipboard => 'क्लिपबोर्ड पर कॉपी करें';

  @override
  String get cutToClipboard => 'क्लिपबोर्ड पर कट करें';

  @override
  String get selectCloud => 'क्लाउड चुनें';

  @override
  String get closeSearch => 'खोज बंद करें';

  @override
  String get uploadFromDevice => 'डिवाइस से अपलोड करें';

  @override
  String get moreOptions => 'अधिक विकल्प';

  @override
  String get viewGrid => 'ग्रिड दृश्य';

  @override
  String get viewList => 'सूची दृश्य';

  @override
  String get multiSelection => 'बहु-चयन';

  @override
  String get sortNameAsc => 'नाम (A-Z)';

  @override
  String get sortNameDesc => 'नाम (Z-A)';

  @override
  String get sortSizeDesc => 'आकार (बड़ा -> छोटा)';

  @override
  String get sortSizeAsc => 'आकार (छोटा -> बड़ा)';

  @override
  String get sortDateDesc => 'दिनांक (नवीनतम पहले)';

  @override
  String get disableDualPane => 'कमांडर अक्षम करें (एकल फलक)';

  @override
  String get enableDualPane => 'कमांडर सक्षम करें (दोहरा फलक)';

  @override
  String itemsInClipboard(int count) {
    return 'क्लिपबोर्ड में $count आइटम';
  }

  @override
  String get pasteHere => 'यहाँ पेस्ट करें';

  @override
  String get noResults => 'कोई परिणाम नहीं';

  @override
  String noMatchingResults(String query) {
    return '\"$query\" से मेल खाने वाली कोई फ़ाइल या फ़ोल्डर नहीं मिला';
  }

  @override
  String get selectACloud => 'एक क्लाउड चुनें';

  @override
  String get selectCloudDescription =>
      'रिमोट फ़ाइलें देखने और एक्सप्लोर करने के लिए ऊपर से क्लाउड चुनें।';

  @override
  String optionsForItem(String name) {
    return '$name के विकल्प';
  }

  @override
  String get select => 'चुनें';

  @override
  String get openWithSystemApp => 'सिस्टम ऐप से खोलें';

  @override
  String get downloadToLocal => 'डिवाइस पर डाउनलोड करें';

  @override
  String get cut => 'कट (स्थानांतरित)';

  @override
  String get copyPath => 'पथ कॉपी करें';

  @override
  String get info => 'जानकारी';

  @override
  String generatingShareLink(String name) {
    return '\"$name\" के लिए लिंक तैयार हो रहा है...';
  }

  @override
  String errorPublicLink(String error) {
    return 'सार्वजनिक लिंक त्रुटि: $error';
  }

  @override
  String get noLinkGenerated => 'प्रदाता द्वारा कोई लिंक वापस नहीं मिला।';

  @override
  String errorDownloading(String error) {
    return 'डाउनलोड के दौरान त्रुटि: $error';
  }

  @override
  String get renameFolderTitle => 'फ़ोल्डर का नाम बदलें';

  @override
  String get renameFileTitle => 'फ़ाइल का नाम बदलें';

  @override
  String errorRenaming(String error) {
    return 'नाम बदलने में त्रुटि: $error';
  }

  @override
  String get pathCopiedToClipboard => 'पथ क्लिपबोर्ड पर कॉपी किया गया';

  @override
  String itemDetailsPath(String path) {
    return 'पथ: $path';
  }

  @override
  String itemDetailsType(String type) {
    return 'प्रकार: $type';
  }

  @override
  String itemDetailsSize(String size) {
    return 'आकार: $size';
  }

  @override
  String itemDetailsModified(String date) {
    return 'संशोधन दिनांक: $date';
  }

  @override
  String get folder => 'फ़ोल्डर';

  @override
  String get file => 'फ़ाइल';

  @override
  String get selectCloudFirstLeft => 'पहले बाएँ फलक में क्लाउड चुनें।';

  @override
  String get selectCloudFirstRight => 'पहले दाएँ फलक में क्लाउड चुनें।';

  @override
  String get selectDestinationCloudLeft =>
      'पहले बाएँ फलक में गंतव्य क्लाउड चुनें।';

  @override
  String get selectDestinationCloudRight =>
      'पहले दाएँ फलक में गंतव्य क्लाउड चुनें।';

  @override
  String get noFilesToTransfer => 'स्थानांतरण के लिए कोई फ़ाइल मौजूद नहीं है।';

  @override
  String transferStarted(String action, int count, String src, String dst) {
    return '$count आइटम का [$src] से [$dst] पर $action शुरू हुआ...';
  }

  @override
  String get swapPanesTooltip => 'फलक आपस में बदलें (<->)';

  @override
  String get refreshBothPanesTooltip => 'दोनों फलक ताज़ा करें';

  @override
  String get copyRight => 'दाएँ कॉपी करें ->';

  @override
  String get moveRight => 'दाएँ स्थानांतरित करें ->';

  @override
  String get copyLeft => '<- बाएँ कॉपी करें';

  @override
  String get moveLeft => '<- बाएँ स्थानांतरित करें';

  @override
  String copyRightWithCount(int count) {
    return 'दाएँ कॉपी करें ($count) ->';
  }

  @override
  String moveRightWithCount(int count) {
    return 'दाएँ स्थानांतरित करें ($count) ->';
  }

  @override
  String copyLeftWithCount(int count) {
    return '<- बाएँ कॉपी करें ($count)';
  }

  @override
  String moveLeftWithCount(int count) {
    return '<- बाएँ स्थानांतरित करें ($count)';
  }

  @override
  String get deleteRuleTitle => 'नियम हटाएं';

  @override
  String deleteRulePrompt(String name) {
    return 'क्या आप सिंक नियम \"$name\" को हटाना चाहते हैं? डिवाइस और क्लाउड पर फ़ाइलें बरकरार रहेंगी।';
  }

  @override
  String get syncAll => 'सभी सिंक करें';

  @override
  String get newRuleTooltip => 'नया नियम';

  @override
  String get backupBannerTitle => 'सतत बैकअप और क्लाउड सिंक';

  @override
  String get backupBannerSubtitle =>
      'स्थानीय फ़ोल्डरों और क्लाउड के बीच अनुसूचित सिंक कॉन्फ़िगर करें।';

  @override
  String get noActiveRules => 'कोई सक्रिय नियम नहीं';

  @override
  String get noActiveRulesSubtitle =>
      'फ़ोन से Google Drive, Dropbox, SFTP आदि पर ऑटो बैकअप के लिए अपना पहला नियम बनाएं।';

  @override
  String get createNewRule => 'नया नियम बनाएं';

  @override
  String get ruleOptionsTooltip => 'नियम विकल्प';

  @override
  String get syncNow => 'अभी सिंक करें';

  @override
  String get statusWaiting => 'प्रतीक्षारत';

  @override
  String get statusInProgress => 'प्रगति पर...';

  @override
  String get statusCompleted => 'पूर्ण';

  @override
  String get statusFailed => 'त्रुटि';

  @override
  String get editRuleTitle => 'बैकअप नियम संपादित करें';

  @override
  String get newRuleTitle => 'नया सिंक नियम';

  @override
  String get ruleDialogSubtitle =>
      'स्थानीय फ़ोल्डर और क्लाउड के बीच ऑटो बैकअप कॉन्फ़िगर करें।';

  @override
  String get ruleNameOptional => 'नियम का नाम (वैकल्पिक)';

  @override
  String get ruleNameHint => 'उदा. DCIM फ़ोटो बैकअप या कार्य दस्तावेज़';

  @override
  String get sourceLocalFolder => 'स्थानीय स्रोत फ़ोल्डर';

  @override
  String get sourceLocalFolderHint =>
      '/storage/emulated/0/DCIM या /home/user/Pictures';

  @override
  String get browseFolders => 'फ़ोल्डर ब्राउज़ करें';

  @override
  String get selectLocalFolderError =>
      'कृपया स्थानीय फ़ोल्डर दर्ज करें या चुनें';

  @override
  String get noCloudsConfiguredSync =>
      'कोई क्लाउड नहीं है। जारी रखने से पहले होम से क्लाउड खाता जोड़ें।';

  @override
  String get remoteDestinationPath => 'रिमोट गंतव्य पथ';

  @override
  String get syncMode => 'सिंक मोड';

  @override
  String get syncModeCopy => 'वृद्धिशील बैकअप';

  @override
  String get syncModeCopyDesc =>
      'क्लाउड फ़ाइलों को हटाए बिना नई और संशोधित फ़ाइलें अपलोड करता है।';

  @override
  String get syncModeSync => 'मिरर सिंक';

  @override
  String get syncModeSyncDesc =>
      'रिमोट को स्थानीय के समान बनाता है (स्थानीय रूप से हटाई गई फ़ाइलें क्लाउड से हट जाती हैं)।';

  @override
  String get syncFrequency => 'निष्पादन आवृत्ति';

  @override
  String get freqManual => 'मैन्युअल (केवल अनुरोध पर)';

  @override
  String get freq15Min => 'हर 15 मिनट';

  @override
  String get freq30Min => 'हर 30 मिनट';

  @override
  String get freqHourly => 'हर घंटे';

  @override
  String get freq6Hours => 'हर 6 घंटे';

  @override
  String get freq12Hours => 'हर 12 घंटे';

  @override
  String get freqDaily => 'प्रतिदिन (24 घंटे)';

  @override
  String get activateRuleImmediately => 'नियम तुरंत सक्रिय करें';

  @override
  String get activateRuleImmediatelyDesc =>
      'सिंक निर्दिष्ट अंतराल के अनुसार बैकग्राउंड में चलेगा';

  @override
  String get updateRule => 'अपडेट करें';

  @override
  String get saveRule => 'नियम सहेजें';

  @override
  String get selectCloudProvider => 'क्लाउड प्रदाता चुनें:';

  @override
  String get cloudAccountName => 'क्लाउड खाता नाम';

  @override
  String get cloudAccountNameHint =>
      'उदा. GoogleDrive, WorkDropbox (बिना स्पेस)';

  @override
  String get enterNameError => 'कृपया एक नाम दर्ज करें';

  @override
  String get noSpacesOrColons => 'स्पेस या \":\" की अनुमति नहीं है';

  @override
  String get oauthMode => 'Client ID मोड (OAuth2)';

  @override
  String get oauthOfficial => 'UnifyCloud (आधिकारिक / अनुशंसित)';

  @override
  String get oauthRclone => 'Rclone (अनुशंसित नहीं - साझा कोटा)';

  @override
  String get oauthCustom => 'व्यक्तिगत Client ID (उन्नत)';

  @override
  String get officialOauthTitle => 'आधिकारिक UnifyCloud क्रेडेंशियल्स';

  @override
  String get officialOauthDesc =>
      'समर्पित कोटा और उच्चतम गति के साथ तुरंत कनेक्ट करने के लिए पूर्व-कॉन्फ़िगर क्रेडेंशियल्स।';

  @override
  String get rcloneOauthDesc =>
      'Rclone ओपन-सोर्स कीज़। कोटा सीमा या Google 403 त्रुटियाँ हो सकती हैं।';

  @override
  String get customClientId => 'Client ID';

  @override
  String get customClientSecret => 'Client Secret';

  @override
  String get selectVaultDestination => 'वॉल्ट के लिए गंतव्य क्लाउड चुनें';

  @override
  String get vaultPasswordRequired => 'एन्क्रिप्शन पासवर्ड आवश्यक है';

  @override
  String get vaultPasswordsDoNotMatch => 'पासवर्ड मेल नहीं खाते';

  @override
  String errorAddingRemote(String error) {
    return 'क्लाउड जोड़ने में त्रुटि: $error';
  }

  @override
  String get fileNameEncryption => 'फ़ाइल नाम एन्क्रिप्शन';

  @override
  String get encryptStandard =>
      'मानक (पूरी तरह से एन्क्रिप्टेड फ़ाइल नाम - अनुशंसित)';

  @override
  String get encryptObscure => 'सरल अस्पष्टता (एक्सटेंशन सुरक्षित रखता है)';

  @override
  String get encryptOff => 'अक्षम (सादा पाठ में नाम)';

  @override
  String get encryptFolderNames => 'फ़ोल्डर नाम भी एन्क्रिप्ट करें';

  @override
  String get encryptFolderNamesDesc =>
      'क्लाउड पर डायरेक्टरी संरचना को पूरी तरह छुपाता है';

  @override
  String get connectCloud => 'क्लाउड कनेक्ट करें';

  @override
  String get reopenAuth => 'पुनः खोलें';

  @override
  String get linkCopiedToClipboard => 'लिंक क्लिपबोर्ड पर कॉपी किया गया!';

  @override
  String errorOpenBrowserGeneric(String error) {
    return 'ब्राउज़र खोलने में असमर्थ: $error';
  }

  @override
  String get shareableLinkTitle => 'साझा करने योग्य लिंक';

  @override
  String shareLinkAccessDescription(String item) {
    return 'इस लिंक वाला कोई भी व्यक्ति $item तक पहुंच सकेगा:';
  }

  @override
  String get open => 'खोलें';

  @override
  String activeTransfersCount(int count) {
    return '$count सक्रिय स्थानांतरण';
  }

  @override
  String transfersQueueCount(int count) {
    return 'स्थानांतरण कतार ($count)';
  }

  @override
  String get noTransfersInProgress => 'कोई स्थानांतरण प्रगति पर नहीं है';

  @override
  String get transfersEmptySubtitle =>
      'सभी डाउनलोड या अपलोड की गई फ़ाइलें यहाँ दिखाई देंगी';

  @override
  String get cancelled => 'रद्द किया गया';

  @override
  String get appLockedTitle => 'एप्लिकेशन लॉक है';

  @override
  String get unlockWithBiometrics => 'बायोमेट्रिक्स से अनलॉक करें';

  @override
  String get pinMustBe6Digits => 'पिन में ठीक 6 अंक होने चाहिए';

  @override
  String get pinIncorrect => 'गलत पिन कोड। पुनः प्रयास करें।';

  @override
  String get pinsDoNotMatch => 'पिन कोड मेल नहीं खाते। पुनः प्रयास करें।';

  @override
  String get pinStepOld => 'जारी रखने के लिए अपना वर्तमान पिन दर्ज करें।';

  @override
  String get pinStepNew => 'अपना नया 6-अंकीय सुरक्षा पिन दर्ज करें।';

  @override
  String get pinStepConfirm => 'पुष्टि के लिए नया पिन पुनः दर्ज करें।';

  @override
  String get pinStepVerify => 'कार्य की पुष्टि के लिए अपना पिन दर्ज करें।';

  @override
  String get pinTitleSetup => 'सुरक्षा पिन सेट करें';

  @override
  String get pinTitleChange => 'सुरक्षा पिन बदलें';

  @override
  String get pinTitleVerify => 'सुरक्षा सत्यापन';

  @override
  String get pinContinue => 'जारी रखें';

  @override
  String get errorDetails => 'त्रुटि विवरण';

  @override
  String get errorDetailsCopied => 'त्रुटि विवरण क्लिपबोर्ड पर कॉपी किया गया';

  @override
  String get collapse => 'समेटें';

  @override
  String get expand => 'विस्तार करें';

  @override
  String get copyError => 'त्रुटि कॉपी करें';

  @override
  String get errorNetwork =>
      'कनेक्शन अनुपलब्ध या अस्थिर है। अपना इंटरनेट जांचें और पुनः प्रयास करें।';

  @override
  String get errorDiskSpace =>
      'अपर्याप्त स्टोरेज या डिस्क भर गई है। जारी रखने के लिए मेमोरी खाली करें।';

  @override
  String get errorAuthExpired =>
      'सत्र या टोकन समाप्त/रद्द हो गया। कृपया अपना खाता पुनः कनेक्ट करें।';

  @override
  String get errorNotFound => 'क्लाउड प्रदाता पर आइटम या फ़ोल्डर नहीं मिला।';

  @override
  String get errorPermissionDenied =>
      'इस क्लाउड ऑपरेशन को करने की अनुमति अस्वीकृत।';

  @override
  String get errorGeneric => 'ऑपरेशन के दौरान एक त्रुटि हुई।';

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
