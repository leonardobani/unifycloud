// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'UnifyCloud';

  @override
  String get home => '홈';

  @override
  String get explorer => '탐색기';

  @override
  String get sync => '동기화';

  @override
  String get settings => '설정';

  @override
  String get cancel => '취소';

  @override
  String get confirm => '확인';

  @override
  String get delete => '삭제';

  @override
  String get save => '저장';

  @override
  String get close => '닫기';

  @override
  String get edit => '편집';

  @override
  String get create => '생성';

  @override
  String get retry => '다시 시도';

  @override
  String get copy => '복사';

  @override
  String get move => '이동';

  @override
  String get rename => '이름 바꾸기';

  @override
  String get download => '다운로드';

  @override
  String get upload => '업로드';

  @override
  String get share => '공유';

  @override
  String get details => '세부정보';

  @override
  String get search => '검색';

  @override
  String get change => '변경';

  @override
  String get reset => '초기화';

  @override
  String get done => '완료';

  @override
  String get loading => '로드 중...';

  @override
  String get success => '작업 완료';

  @override
  String get error => '오류';

  @override
  String get settingsTitle => '설정';

  @override
  String get resetDefaultsTooltip => '기본 설정으로 복원';

  @override
  String get resetDialogTitle => '설정 초기화';

  @override
  String get resetDialogContent => '모든 기본 설정(테마, 언어, 폴더, 보기)을 공장 초기화하시겠습니까?';

  @override
  String get resetSuccessSnackbar => '설정이 기본값으로 복원되었습니다';

  @override
  String get appearanceAndTheme => '화면 및 테마';

  @override
  String get chooseVisualThemeSubtitle => 'UnifyCloud 인터페이스 테마 선택:';

  @override
  String get themeSystem => '시스템 설정';

  @override
  String get themeLight => '밝은 테마';

  @override
  String get themeDark => '어두운 테마';

  @override
  String get language => '언어';

  @override
  String get languageSubtitle => '앱 인터페이스 언어 선택';

  @override
  String get langEnglish => 'English';

  @override
  String get langItalian => 'Italiano';

  @override
  String get langSystem => '시스템 기본값';

  @override
  String get filesAndExploration => '파일 및 탐색';

  @override
  String get showHiddenFiles => '숨김 파일 표시';

  @override
  String get showHiddenFilesSubtitle => '점(.)으로 시작하는 파일 및 폴더 표시';

  @override
  String get confirmBeforeDelete => '삭제 전 확인';

  @override
  String get confirmBeforeDeleteSubtitle => '파일을 영구 삭제하기 전에 확인 창 표시';

  @override
  String get defaultDownloadFolder => '기본 다운로드 폴더';

  @override
  String get defaultDownloadFolderSystem => '시스템 기본 다운로드 디렉터리';

  @override
  String get restoreDefaultPath => '기본 경로로 복원';

  @override
  String get customDownloadFolderDialogPrompt => '시스템 선택기를 사용하거나 경로를 직접 입력하세요:';

  @override
  String get folderPath => '폴더 경로';

  @override
  String get folderPathHint => '예: /home/user/Downloads';

  @override
  String get browseWithSystemPicker => '시스템 선택기로 찾아보기';

  @override
  String errorOpenPicker(String error) {
    return '시스템 선택기를 열 수 없습니다: $error';
  }

  @override
  String get restoreDefault => '기본값 복원';

  @override
  String get maxConcurrentTransfers => '동시 전송 수';

  @override
  String get maxConcurrentTransfersSubtitle => '동시에 활성화할 최대 파일 전송 수';

  @override
  String get dualPaneMode => '듀얼 패널 커맨더 모드';

  @override
  String get dualPaneModeSubtitle => '태블릿 및 와이드 화면에서 좌우 2분할 패널 표시';

  @override
  String get communityAndSupport => '커뮤니티 및 지원';

  @override
  String get openSourceDescription =>
      'UnifyCloud는 추적기나 독점 중개인 없이 클라우드 데이터를 통합하는 무료 오픈 소스 소프트웨어입니다.';

  @override
  String get supportDeveloper => '개발자 후원';

  @override
  String get supportDeveloperSubtitle => '커피 한 잔 후원으로 독립 개발을 응원해 주세요';

  @override
  String get viewSourceOnGitLab => 'GitLab에서 소스 보기';

  @override
  String get viewSourceOnGitLabSubtitle => '공식 저장소, 버그 신고 및 기여';

  @override
  String errorOpenBrowser(String url) {
    return '브라우저를 열 수 없습니다. 저장소: $url';
  }

  @override
  String get supportDialogTitle => 'UnifyCloud 후원하기';

  @override
  String get supportDialogDescription1 =>
      'UnifyCloud는 클라우드 파일을 온전히 제어할 수 있도록 만든 무료 오픈 소스 프로젝트입니다.';

  @override
  String get supportDialogDescription2 =>
      '앱이 마음에 드셨다면 커피 후원이나 기부로 지속적인 개발을 응원해 주세요!';

  @override
  String get supportKofiTitle => 'Ko-fi에서 커피 후원하기';

  @override
  String get supportLiberapayTitle => 'Liberapay에서 후원하기';

  @override
  String get supportPaypalTitle => 'PayPal로 후원하기';

  @override
  String get securityAndEncryption => '보안 및 암호화';

  @override
  String get securityArchitectureDescription =>
      'UnifyCloud는 제로 플레인텍스트(Zero-Plaintext) 아키텍처를 채택했습니다. 모든 OAuth 토큰과 자격 증명은 시스템 키체인/키스토어에 안전하게 보관되며 Go 엔진 메모리에만 로드됩니다.';

  @override
  String get appLock => '앱 잠금 (PIN / 생체 인식)';

  @override
  String get appLockSubtitle => '접근 시 PIN 번호 또는 지문 인증 요구';

  @override
  String get appLockActiveSubtitle => '시작 시 및 일정 시간 미사용 시 활성화';

  @override
  String get appLockEnabledSnackbar => '앱 잠금이 활성화되었습니다';

  @override
  String get appLockDisabledSnackbar => '앱 잠금이 비활성화되었습니다';

  @override
  String get changePin => 'PIN 변경';

  @override
  String get changePinSubtitle => '새 6자리 보안 PIN 번호 설정';

  @override
  String get pinChangedSnackbar => '보안 PIN 번호가 변경되었습니다';

  @override
  String get biometricAuth => '생체 인증';

  @override
  String get biometricAuthSubtitle => '지문 또는 생체 인식 센서 사용 (지원되는 경우)';

  @override
  String get biometricNotAvailable => '이 기기에서는 지원되지 않거나 구성되지 않았습니다';

  @override
  String get autoLock => '자동 잠금';

  @override
  String get autoLockSubtitle => '백그라운드 비활성 후 잠금 시간';

  @override
  String get lockImmediately => '즉시';

  @override
  String get lockAfter1Minute => '1분 후';

  @override
  String get lockAfter5Minutes => '5분 후';

  @override
  String get lockAfter15Minutes => '15분 후';

  @override
  String get lockAfter30Minutes => '30분 후';

  @override
  String get syncCloudAccounts => '클라우드 계정 동기화';

  @override
  String get syncCloudAccountsSubtitle => '보안 저장소에서 계정 구성 다시 불러오기';

  @override
  String get syncCloudAccountsSuccess => '클라우드 계정을 성공적으로 다시 불러왔습니다';

  @override
  String get clearAllCredentials => '모든 자격 증명 삭제';

  @override
  String get clearAllCredentialsSubtitle => '암호화된 구성을 삭제하고 모든 클라우드 연결을 해제합니다';

  @override
  String get clearCredentialsDialogTitle => '경고: 자격 증명 초기화';

  @override
  String get clearCredentialsDialogContent =>
      '저장된 모든 자격 증명을 삭제하시겠습니까? 클라우드 계정을 다시 연결해야 합니다.';

  @override
  String get clearCredentialsSuccess => '자격 증명이 삭제되었습니다';

  @override
  String get aboutUnifyCloud => 'UnifyCloud 정보';

  @override
  String get appVersion => '앱 버전: 1.0.0';

  @override
  String get developerInfo => '개발자: LeoRise (@leorise25)';

  @override
  String get engineInfo => '엔진: Rclone Core CGO (Go v1.22+ / C FFI)';

  @override
  String get frameworkInfo => '프레임워크: Flutter (Material 3 반응형)';

  @override
  String get licenseInfo => '라이선스: GNU General Public License v3.0 (GPL-3.0)';

  @override
  String get copyrightInfo => '저작권: © 2026 Leonardo Bani';

  @override
  String get storageOverview => '스토리지 개요';

  @override
  String get connectedClouds => '연결된 클라우드';

  @override
  String get noCloudsConfigured => '구성된 클라우드 계정 없음';

  @override
  String get noCloudsDescription =>
      '첫 번째 클라우드 스토리지 계정을 연결하여 파일 관리와 동기화를 시작하세요.';

  @override
  String get addCloud => '클라우드 추가';

  @override
  String get used => '사용됨';

  @override
  String get free => '남음';

  @override
  String get total => '전체';

  @override
  String get manageAccounts => '계정 관리';

  @override
  String get viewFiles => '파일 보기';

  @override
  String get createVaultHere => '여기에 암호화 금고 생성...';

  @override
  String get disconnectAccount => '계정 연결 해제';

  @override
  String get disconnectConfirmTitle => '계정을 연결 해제하시겠습니까?';

  @override
  String get disconnectConfirmContent =>
      '이 계정의 연결을 해제하시겠습니까? 원격 클라우드의 파일은 유지됩니다.';

  @override
  String get allFiles => '모든 파일';

  @override
  String get emptyFolder => '폴더가 비어 있습니다';

  @override
  String get emptyFolderSubtitle => '파일을 업로드하거나 하위 폴더를 만드세요.';

  @override
  String get uploadFile => '파일 업로드';

  @override
  String get uploadFolder => '전체 폴더 업로드';

  @override
  String get newFolder => '새 폴더';

  @override
  String get newFolderPrompt => '새 폴더 이름을 입력하세요:';

  @override
  String get folderNameHint => '폴더 이름';

  @override
  String get selectAll => '전체 선택';

  @override
  String get clearSelection => '선택 해제';

  @override
  String get deleteSelected => '선택 항목 삭제';

  @override
  String get deleteSelectedPrompt => '선택한 항목을 삭제하시겠습니까?';

  @override
  String get deleteItemPrompt => '이 항목을 삭제하시겠습니까?';

  @override
  String get shareLink => '링크 공유';

  @override
  String get createShareLink => '공유 가능한 링크 생성';

  @override
  String get copyShareLink => '링크 복사';

  @override
  String get copiedToClipboard => '클립보드에 복사되었습니다';

  @override
  String get transfers => '전송';

  @override
  String get activeTransfers => '활성 전송';

  @override
  String get completed => '완료됨';

  @override
  String get failed => '실패';

  @override
  String get queued => '대기 중';

  @override
  String get cancelTransfer => '전송 취소';

  @override
  String get clearCompleted => '완료 항목 지우기';

  @override
  String get syncRulesTitle => '백업 및 동기화 규칙';

  @override
  String get newRule => '새 규칙';

  @override
  String get noSyncRules => '구성된 동기화 규칙 없음';

  @override
  String get noSyncRulesSubtitle => '로컬 폴더를 클라우드와 동기화하는 자동화 규칙을 만드세요.';

  @override
  String get ruleName => '규칙 이름';

  @override
  String get sourcePath => '소스 폴더';

  @override
  String get destinationCloud => '대상 클라우드';

  @override
  String get destinationPath => '원격 경로';

  @override
  String get direction => '방향';

  @override
  String get frequency => '주기';

  @override
  String get runNow => '지금 실행';

  @override
  String get syncInProgress => '동기화 진행 중...';

  @override
  String get syncSuccess => '동기화 완료';

  @override
  String get syncFailed => '동기화 실패';

  @override
  String get addCloudDialogTitle => '새 클라우드 연결';

  @override
  String get selectProvider => '클라우드 제공업체 선택';

  @override
  String get accountNameLabel => '계정 이름 / 별칭';

  @override
  String get connectButton => '계정 연결';

  @override
  String get vaultTitle => '엔드투엔드 암호화 (Crypt)';

  @override
  String get vaultPassword => '금고 비밀번호';

  @override
  String get vaultConfirmPassword => '비밀번호 확인';

  @override
  String get vaultSalt => '솔트 / 보조 비밀번호 (선택사항)';

  @override
  String get encryptFileNames => '파일 이름 암호화';

  @override
  String get encryptDirNames => '폴더 이름 암호화';

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
  String get selectLanguage => '언어 선택';

  @override
  String get searchLanguageHint => '언어 또는 국가 검색...';

  @override
  String get currentLanguage => '현재 언어';

  @override
  String systemDefaultWithLocale(String locale) {
    return '시스템 기본값 ($locale)';
  }

  @override
  String get refreshCloudsTooltip => '클라우드 설정 새로고침';

  @override
  String get storageOverviewAggregated => '통합 스토리지 개요';

  @override
  String get ramEncryptionActive => 'RAM 메모리 암호화 활성';

  @override
  String connectedAccountsCount(int count) {
    return '연결된 클라우드 계정: $count개';
  }

  @override
  String get noCloudsConfiguredHint =>
      '연결된 계정이 없습니다. 아래의 \"+ 새 클라우드 연결\"을 누르세요.';

  @override
  String percentUsed(String percent) {
    return '$percent% 사용 중';
  }

  @override
  String availableSpace(String space) {
    return '$space 남음';
  }

  @override
  String get calculatingQuota => '스토리지 용량 계산 중 또는 무제한...';

  @override
  String get syncAndBackup => '동기화 및 백업';

  @override
  String get noRulesConfigured => '구성된 동기화 규칙 없음';

  @override
  String activeRulesCount(int active, int total) {
    return '$active/$total개 규칙 활성';
  }

  @override
  String get manage => '관리';

  @override
  String connectedCloudsCount(int count) {
    return '연결된 클라우드 ($count)';
  }

  @override
  String get connectNewCloud => '새 클라우드 연결';

  @override
  String get noCloudProvidersConnected => '연결된 클라우드 제공업체 없음';

  @override
  String get connectCloudDescription =>
      'Google Drive, Dropbox, OneDrive, SFTP 또는 WebDAV를 연결하여 파일 탐색 및 동기화를 시작하세요.';

  @override
  String get addFirstCloud => '첫 클라우드 추가';

  @override
  String vaultOnRemote(String remote) {
    return '$remote 상의 금고';
  }

  @override
  String get disconnectCloudTitle => '클라우드 연결 해제';

  @override
  String disconnectCloudPrompt(String name) {
    return '\"$name\" 연결을 해제하시겠습니까? 인증 자격 증명이 안전하게 삭제됩니다.';
  }

  @override
  String get disconnect => '연결 해제';

  @override
  String freeSpace(String space) {
    return '$space 남음';
  }

  @override
  String get storage => '저장공간';

  @override
  String get available => '사용 가능';

  @override
  String get exploreFiles => '파일 탐색';

  @override
  String get paneLeft => '왼쪽';

  @override
  String get paneRight => '오른쪽';

  @override
  String get folderName => '폴더 이름';

  @override
  String errorCreatingFolder(String error) {
    return '폴더 생성 오류: $error';
  }

  @override
  String get moveAction => '이동';

  @override
  String get copyAction => '복사';

  @override
  String transferBatchStarted(String action, int count, String remote) {
    return '$count개 항목 [$remote] (으)로 $action 시작...';
  }

  @override
  String errorTransferring(String error) {
    return '전송 중 오류: $error';
  }

  @override
  String itemCopiedToClipboard(String name) {
    return '\"$name\" 클립보드에 복사됨';
  }

  @override
  String itemsCopiedToClipboard(int count) {
    return '$count개 항목이 클립보드에 복사됨';
  }

  @override
  String itemCutToClipboard(String name) {
    return '\"$name\" 잘라내기됨 (이동 준비)';
  }

  @override
  String itemsCutToClipboard(int count) {
    return '$count개 항목 잘라내기됨 (이동 준비)';
  }

  @override
  String get noFilesSelectedForDownload => '다운로드할 파일이 선택되지 않았습니다.';

  @override
  String downloadingItems(int count) {
    return '$count개 항목 다운로드 중...';
  }

  @override
  String itemsDownloadedSuccess(int count, String path) {
    return '$count개 항목을 \"$path\"에 다운로드했습니다';
  }

  @override
  String errorStartingDownload(String error) {
    return '다운로드 시작 오류: $error';
  }

  @override
  String deleteItemsConfirmTitle(int count) {
    return '선택한 $count개 항목을 삭제하시겠습니까?';
  }

  @override
  String deleteItemsConfirmPrompt(int count) {
    return '선택한 $count개 항목을 클라우드에서 영구 삭제하시겠습니까?';
  }

  @override
  String itemsDeletedSuccess(int count) {
    return '$count개 항목이 삭제되었습니다';
  }

  @override
  String errorDeleting(String error) {
    return '삭제 중 오류: $error';
  }

  @override
  String get uploadCompletedSuccess => '업로드가 완료되었습니다';

  @override
  String errorUploading(String error) {
    return '업로드 중 오류: $error';
  }

  @override
  String get folderUploadCompletedSuccess => '폴더 업로드 완료';

  @override
  String errorFolderUploading(String error) {
    return '폴더 업로드 중 오류: $error';
  }

  @override
  String get filesAlreadyInDirectory => '파일이 이미 이 폴더에 있습니다.';

  @override
  String dragDropTransferStarted(String action, int count, String remote) {
    return '$count개 항목 [$remote] (으)로 $action 시작...';
  }

  @override
  String errorDragDrop(String error) {
    return '드래그 앤 드롭 전송 오류: $error';
  }

  @override
  String get closeSelection => '선택 닫기';

  @override
  String itemsSelectedCount(int count) {
    return '$count개 선택됨';
  }

  @override
  String get deselectAll => '전체 선택 해제';

  @override
  String copyToRemote(String remote) {
    return '$remote (으)로 복사';
  }

  @override
  String moveToRemote(String remote) {
    return '$remote (으)로 이동';
  }

  @override
  String get moreActions => '추가 작업';

  @override
  String get downloadSelected => '선택 항목 다운로드';

  @override
  String get copyToClipboard => '클립보드로 복사';

  @override
  String get cutToClipboard => '클립보드로 잘라내기';

  @override
  String get selectCloud => '클라우드 선택';

  @override
  String get closeSearch => '검색 닫기';

  @override
  String get uploadFromDevice => '기기에서 업로드';

  @override
  String get moreOptions => '추가 옵션';

  @override
  String get viewGrid => '격자 보기';

  @override
  String get viewList => '목록 보기';

  @override
  String get multiSelection => '다중 선택';

  @override
  String get sortNameAsc => '이름 (가-하)';

  @override
  String get sortNameDesc => '이름 (하-가)';

  @override
  String get sortSizeDesc => '크기 (큰 순서)';

  @override
  String get sortSizeAsc => '크기 (작은 순서)';

  @override
  String get sortDateDesc => '날짜 (최신순)';

  @override
  String get disableDualPane => '커맨더 끄기 (단일 패널)';

  @override
  String get enableDualPane => '커맨더 켜기 (듀얼 패널)';

  @override
  String itemsInClipboard(int count) {
    return '클립보드에 $count개 항목 있음';
  }

  @override
  String get pasteHere => '여기에 붙여넣기';

  @override
  String get noResults => '결과 없음';

  @override
  String noMatchingResults(String query) {
    return '\"$query\"와 일치하는 파일이나 폴더가 없습니다';
  }

  @override
  String get selectACloud => '클라우드를 선택하세요';

  @override
  String get selectCloudDescription => '상단 메뉴에서 클라우드 서비스를 선택하여 파일을 탐색하세요.';

  @override
  String optionsForItem(String name) {
    return '$name 옵션';
  }

  @override
  String get select => '선택';

  @override
  String get openWithSystemApp => '시스템 기본 앱으로 열기';

  @override
  String get downloadToLocal => '로컬로 다운로드';

  @override
  String get cut => '잘라내기 (이동)';

  @override
  String get copyPath => '경로 복사';

  @override
  String get info => '정보';

  @override
  String generatingShareLink(String name) {
    return '\"$name\" 공유 링크 생성 중...';
  }

  @override
  String errorPublicLink(String error) {
    return '공개 링크 오류: $error';
  }

  @override
  String get noLinkGenerated => '제공업체에서 링크를 반환하지 않았습니다.';

  @override
  String errorDownloading(String error) {
    return '다운로드 중 오류: $error';
  }

  @override
  String get renameFolderTitle => '폴더 이름 바꾸기';

  @override
  String get renameFileTitle => '파일 이름 바꾸기';

  @override
  String errorRenaming(String error) {
    return '이름 바꾸기 오류: $error';
  }

  @override
  String get pathCopiedToClipboard => '경로가 클립보드에 복사되었습니다';

  @override
  String itemDetailsPath(String path) {
    return '경로: $path';
  }

  @override
  String itemDetailsType(String type) {
    return '유형: $type';
  }

  @override
  String itemDetailsSize(String size) {
    return '크기: $size';
  }

  @override
  String itemDetailsModified(String date) {
    return '수정일: $date';
  }

  @override
  String get folder => '폴더';

  @override
  String get file => '파일';

  @override
  String get selectCloudFirstLeft => '먼저 왼쪽 패널에서 클라우드를 선택하세요.';

  @override
  String get selectCloudFirstRight => '먼저 오른쪽 패널에서 클라우드를 선택하세요.';

  @override
  String get selectDestinationCloudLeft => '먼저 왼쪽 패널에서 대상 클라우드를 선택하세요.';

  @override
  String get selectDestinationCloudRight => '먼저 오른쪽 패널에서 대상 클라우드를 선택하세요.';

  @override
  String get noFilesToTransfer => '전송할 파일이 없거나 선택되지 않았습니다.';

  @override
  String transferStarted(String action, int count, String src, String dst) {
    return '$count개 항목 [$src] -> [$dst] $action 시작...';
  }

  @override
  String get swapPanesTooltip => '좌우 패널 맞바꾸기 (<->)';

  @override
  String get refreshBothPanesTooltip => '양쪽 패널 모두 새로고침';

  @override
  String get copyRight => '오른쪽으로 복사 ->';

  @override
  String get moveRight => '오른쪽으로 이동 ->';

  @override
  String get copyLeft => '<- 왼쪽으로 복사';

  @override
  String get moveLeft => '<- 왼쪽으로 이동';

  @override
  String copyRightWithCount(int count) {
    return '오른쪽으로 복사 ($count) ->';
  }

  @override
  String moveRightWithCount(int count) {
    return '오른쪽으로 이동 ($count) ->';
  }

  @override
  String copyLeftWithCount(int count) {
    return '<- 왼쪽으로 복사 ($count)';
  }

  @override
  String moveLeftWithCount(int count) {
    return '<- 왼쪽으로 이동 ($count)';
  }

  @override
  String get deleteRuleTitle => '규칙 삭제';

  @override
  String deleteRulePrompt(String name) {
    return '동기화 규칙 \"$name\"을(를) 삭제하시겠습니까? 기기 및 클라우드의 파일은 보존됩니다.';
  }

  @override
  String get syncAll => '모두 동기화';

  @override
  String get newRuleTooltip => '새 규칙';

  @override
  String get backupBannerTitle => '지속적 백업 및 클라우드 동기화';

  @override
  String get backupBannerSubtitle => '로컬 폴더와 원격 클라우드 간의 예약 동기화를 구성하세요.';

  @override
  String get noActiveRules => '활성 규칙 없음';

  @override
  String get noActiveRulesSubtitle =>
      '스마트폰에서 Google Drive, Dropbox, SFTP 등으로 사진이나 문서를 자동 백업하는 규칙을 만드세요.';

  @override
  String get createNewRule => '새 규칙 생성';

  @override
  String get ruleOptionsTooltip => '규칙 옵션';

  @override
  String get syncNow => '지금 동기화';

  @override
  String get statusWaiting => '대기 중';

  @override
  String get statusInProgress => '진행 중...';

  @override
  String get statusCompleted => '완료됨';

  @override
  String get statusFailed => '오류';

  @override
  String get editRuleTitle => '백업 규칙 편집';

  @override
  String get newRuleTitle => '새 동기화 규칙';

  @override
  String get ruleDialogSubtitle => '로컬 폴더와 클라우드 간의 자동 백업을 구성합니다.';

  @override
  String get ruleNameOptional => '규칙 이름 (선택사항)';

  @override
  String get ruleNameHint => '예: DCIM 사진 백업 또는 업무 문서';

  @override
  String get sourceLocalFolder => '로컬 원본 폴더';

  @override
  String get sourceLocalFolderHint =>
      '/storage/emulated/0/DCIM 또는 /home/user/Pictures';

  @override
  String get browseFolders => '폴더 찾아보기';

  @override
  String get selectLocalFolderError => '로컬 폴더를 입력하거나 선택하세요';

  @override
  String get noCloudsConfiguredSync => '구성된 클라우드가 없습니다. 홈에서 클라우드 계정을 먼저 추가하세요.';

  @override
  String get remoteDestinationPath => '원격 대상 경로';

  @override
  String get syncMode => '동기화 모드';

  @override
  String get syncModeCopy => '증분 백업';

  @override
  String get syncModeCopyDesc => '클라우드의 기존 파일을 지우지 않고 새 파일과 변경된 파일만 업로드합니다.';

  @override
  String get syncModeSync => '미러 동기화';

  @override
  String get syncModeSyncDesc =>
      '원격 대상을 로컬과 완벽히 동일하게 만듭니다(로컬에서 삭제된 파일은 클라우드에서도 삭제됨).';

  @override
  String get syncFrequency => '실행 주기';

  @override
  String get freqManual => '수동 (요청 시에만)';

  @override
  String get freq15Min => '15분마다';

  @override
  String get freq30Min => '30분마다';

  @override
  String get freqHourly => '1시간마다';

  @override
  String get freq6Hours => '6시간마다';

  @override
  String get freq12Hours => '12시간마다';

  @override
  String get freqDaily => '매일 (24시간마다)';

  @override
  String get activateRuleImmediately => '규칙 즉시 활성화';

  @override
  String get activateRuleImmediatelyDesc => '지정된 간격에 따라 백그라운드에서 동기화가 실행됩니다';

  @override
  String get updateRule => '업데이트';

  @override
  String get saveRule => '규칙 저장';

  @override
  String get selectCloudProvider => '클라우드 서비스 선택:';

  @override
  String get cloudAccountName => '클라우드 계정 이름';

  @override
  String get cloudAccountNameHint => '예: GoogleDrive, WorkDropbox (공백 없이)';

  @override
  String get enterNameError => '이름을 입력하세요';

  @override
  String get noSpacesOrColons => '공백이나 콜론(\":\")은 허용되지 않습니다';

  @override
  String get oauthMode => 'Client ID 모드 (OAuth2)';

  @override
  String get oauthOfficial => 'UnifyCloud (공식 / 권장)';

  @override
  String get oauthRclone => 'Rclone (비권장 - 공유 할당량)';

  @override
  String get oauthCustom => '개인 Client ID (고급)';

  @override
  String get officialOauthTitle => '공식 UnifyCloud 자격 증명';

  @override
  String get officialOauthDesc =>
      '전용 할당량과 최고 속도로 즉시 연결할 수 있도록 사전 구성된 자격 증명입니다.';

  @override
  String get rcloneOauthDesc =>
      'Rclone 공개 공유 키입니다. 요청 제한이나 Google 403 오류가 발생할 수 있습니다.';

  @override
  String get customClientId => 'Client ID';

  @override
  String get customClientSecret => 'Client Secret';

  @override
  String get selectVaultDestination => '금고를 생성할 대상 클라우드 선택';

  @override
  String get vaultPasswordRequired => '암호화 비밀번호를 입력해야 합니다';

  @override
  String get vaultPasswordsDoNotMatch => '비밀번호가 일치하지 않습니다';

  @override
  String errorAddingRemote(String error) {
    return '클라우드 추가 실패: $error';
  }

  @override
  String get fileNameEncryption => '파일 이름 암호화 방식';

  @override
  String get encryptStandard => '표준 (파일 이름 전체 암호화 - 권장)';

  @override
  String get encryptObscure => '단순 난독화 (확장자 유지)';

  @override
  String get encryptOff => '비활성화 (일반 텍스트 이름)';

  @override
  String get encryptFolderNames => '폴더 이름도 암호화';

  @override
  String get encryptFolderNamesDesc => '클라우드에서 디렉터리 구조를 완벽하게 숨깁니다';

  @override
  String get connectCloud => '클라우드 연결';

  @override
  String get reopenAuth => '인증 다시 열기';

  @override
  String get linkCopiedToClipboard => '링크가 클립보드에 복사되었습니다!';

  @override
  String errorOpenBrowserGeneric(String error) {
    return '브라우저를 열 수 없습니다: $error';
  }

  @override
  String get shareableLinkTitle => '공유 링크';

  @override
  String shareLinkAccessDescription(String item) {
    return '이 링크를 가진 모든 사용자가 $item에 접근할 수 있습니다:';
  }

  @override
  String get open => '열기';

  @override
  String activeTransfersCount(int count) {
    return '활성 전송 $count개';
  }

  @override
  String transfersQueueCount(int count) {
    return '전송 대기열 ($count)';
  }

  @override
  String get noTransfersInProgress => '진행 중인 전송 없음';

  @override
  String get transfersEmptySubtitle => '다운로드 또는 업로드된 모든 파일이 여기에 표시됩니다';

  @override
  String get cancelled => '취소됨';

  @override
  String get appLockedTitle => '애플리케이션 잠김';

  @override
  String get unlockWithBiometrics => '생체 인식으로 잠금 해제';

  @override
  String get pinMustBe6Digits => 'PIN 번호는 정확히 6자리여야 합니다';

  @override
  String get pinIncorrect => '잘못된 PIN 번호입니다. 다시 시도하세요.';

  @override
  String get pinsDoNotMatch => 'PIN 번호가 일치하지 않습니다. 다시 시도하세요.';

  @override
  String get pinStepOld => '계속하려면 현재 PIN 번호를 입력하세요.';

  @override
  String get pinStepNew => '새 6자리 보안 PIN 번호를 입력하세요.';

  @override
  String get pinStepConfirm => '확인을 위해 새 PIN 번호를 다시 입력하세요.';

  @override
  String get pinStepVerify => '작업 확인을 위해 PIN 번호를 입력하세요.';

  @override
  String get pinTitleSetup => '보안 PIN 설정';

  @override
  String get pinTitleChange => '보안 PIN 변경';

  @override
  String get pinTitleVerify => '보안 확인';

  @override
  String get pinContinue => '계속';

  @override
  String get errorDetails => '오류 세부정보';

  @override
  String get errorDetailsCopied => '오류 세부정보가 클립보드에 복사되었습니다';

  @override
  String get collapse => '접기';

  @override
  String get expand => '펼치기';

  @override
  String get copyError => '오류 복사';

  @override
  String get errorNetwork => '네트워크 연결이 없거나 불안정합니다. 인터넷 연결을 확인하고 다시 시도하세요.';

  @override
  String get errorDiskSpace => '저장 공간이 부족하거나 디스크가 가득 찼습니다. 공간을 확보하세요.';

  @override
  String get errorAuthExpired => '세션 또는 인증 토큰이 만료/취소되었습니다. 계정을 다시 연결하세요.';

  @override
  String get errorNotFound => '클라우드 서비스에서 파일이나 폴더를 찾을 수 없습니다.';

  @override
  String get errorPermissionDenied => '이 클라우드 작업을 수행할 권한이 거부되었습니다.';

  @override
  String get errorGeneric => '작업 중 오류가 발생했습니다.';
}
