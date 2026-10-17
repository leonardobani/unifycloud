// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'UnifyCloud';

  @override
  String get home => '首页';

  @override
  String get explorer => '文件浏览';

  @override
  String get sync => '同步';

  @override
  String get settings => '设置';

  @override
  String get cancel => '取消';

  @override
  String get confirm => '确认';

  @override
  String get delete => '删除';

  @override
  String get save => '保存';

  @override
  String get close => '关闭';

  @override
  String get edit => '编辑';

  @override
  String get create => '创建';

  @override
  String get retry => '重试';

  @override
  String get copy => '复制';

  @override
  String get move => '移动';

  @override
  String get rename => '重命名';

  @override
  String get download => '下载';

  @override
  String get upload => '上传';

  @override
  String get share => '分享';

  @override
  String get details => '详情';

  @override
  String get search => '搜索';

  @override
  String get change => '更改';

  @override
  String get reset => '重置';

  @override
  String get done => '完成';

  @override
  String get loading => '加载中...';

  @override
  String get success => '操作完成';

  @override
  String get error => '错误';

  @override
  String get settingsTitle => '设置';

  @override
  String get resetDefaultsTooltip => '恢复默认设置';

  @override
  String get resetDialogTitle => '重置设置';

  @override
  String get resetDialogContent => '确定要将所有偏好设置（主题、语言、文件夹、显示）恢复为出厂默认值吗？';

  @override
  String get resetSuccessSnackbar => '设置已恢复为默认值';

  @override
  String get appearanceAndTheme => '外观与主题';

  @override
  String get chooseVisualThemeSubtitle => '选择 UnifyCloud 界面的视觉主题：';

  @override
  String get themeSystem => '跟随系统';

  @override
  String get themeLight => '浅色';

  @override
  String get themeDark => '深色';

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
  String get language => '语言';

  @override
  String get languageSubtitle => '选择应用界面语言';

  @override
  String get langEnglish => 'English';

  @override
  String get langItalian => 'Italiano';

  @override
  String get langSystem => '跟随系统';

  @override
  String get filesAndExploration => '文件与浏览';

  @override
  String get showHiddenFiles => '显示隐藏文件';

  @override
  String get showHiddenFilesSubtitle => '显示以点 (.) 开头的文件和文件夹';

  @override
  String get confirmBeforeDelete => '删除前确认';

  @override
  String get confirmBeforeDeleteSubtitle => '在永久删除文件前弹出安全确认提示';

  @override
  String get defaultDownloadFolder => '默认下载文件夹';

  @override
  String get defaultDownloadFolderSystem => '系统默认下载目录';

  @override
  String get restoreDefaultPath => '恢复默认路径';

  @override
  String get customDownloadFolderDialogPrompt => '使用系统选择器选择文件夹或手动输入路径：';

  @override
  String get folderPath => '文件夹路径';

  @override
  String get folderPathHint => '例如 /home/user/Downloads';

  @override
  String get browseWithSystemPicker => '使用系统选择器浏览';

  @override
  String errorOpenPicker(String error) {
    return '无法打开系统选择器：$error';
  }

  @override
  String get restoreDefault => '恢复默认';

  @override
  String get maxConcurrentTransfers => '并发传输数';

  @override
  String get maxConcurrentTransfersSubtitle => '最大同时活动的文件传输数量';

  @override
  String get dualPaneMode => '双栏 Commander 模式';

  @override
  String get dualPaneModeSubtitle => '在宽屏设备和平板电脑上并排显示两个栏目';

  @override
  String get communityAndSupport => '社区与支持';

  @override
  String get openSourceDescription =>
      'UnifyCloud 是一款自由开源软件，旨在整合您的多云数据，绝无追踪器或专有中介。';

  @override
  String get supportDeveloper => '支持开发者';

  @override
  String get supportDeveloperSubtitle => '请开发者喝杯咖啡，支持独立开发';

  @override
  String get viewSourceOnGitLab => '在 GitLab 上查看源码';

  @override
  String get viewSourceOnGitLabSubtitle => '官方仓库、问题反馈与代码贡献';

  @override
  String errorOpenBrowser(String url) {
    return '无法打开浏览器。仓库：$url';
  }

  @override
  String get supportDialogTitle => '支持 UnifyCloud';

  @override
  String get supportDialogDescription1 =>
      'UnifyCloud 是一个免费且开源的项目，让您完全掌控自己的云端文件。';

  @override
  String get supportDialogDescription2 => '如果您觉得该应用对您有帮助，欢迎请喝杯咖啡或赞助，以支持持续开发！';

  @override
  String get supportKofiTitle => '在 Ko-fi 上请喝咖啡';

  @override
  String get supportLiberapayTitle => '在 Liberapay 上赞助';

  @override
  String get supportPaypalTitle => '通过 PayPal 赞助';

  @override
  String get securityAndEncryption => '安全与加密';

  @override
  String get securityArchitectureDescription =>
      'UnifyCloud 采用零明文 (Zero-Plaintext) 架构。所有 OAuth 令牌和凭据均受系统安全密钥库保护，并仅注入 Go 引擎内存中。';

  @override
  String get appLock => '应用锁 (PIN码 / 生物识别)';

  @override
  String get appLockSubtitle => '进入应用需要输入 PIN 码或指纹';

  @override
  String get appLockActiveSubtitle => '启动时以及长时间未操作后生效';

  @override
  String get appLockEnabledSnackbar => '应用锁已成功启用';

  @override
  String get appLockDisabledSnackbar => '应用锁已停用';

  @override
  String get changePin => '更改 PIN 码';

  @override
  String get changePinSubtitle => '设置新的 6 位安全 PIN 码';

  @override
  String get pinChangedSnackbar => '安全 PIN 码已成功更新';

  @override
  String get biometricAuth => '生物识别认证';

  @override
  String get biometricAuthSubtitle => '如果设备支持，可使用指纹或面部解锁';

  @override
  String get biometricNotAvailable => '此设备不可用或未配置生物识别';

  @override
  String get autoLock => '自动锁定';

  @override
  String get autoLockSubtitle => '后台闲置多久后自动上锁';

  @override
  String get lockImmediately => '立即';

  @override
  String get lockAfter1Minute => '1 分钟后';

  @override
  String get lockAfter5Minutes => '5 分钟后';

  @override
  String get lockAfter15Minutes => '15 分钟后';

  @override
  String get lockAfter30Minutes => '30 分钟后';

  @override
  String get syncCloudAccounts => '同步云端账户';

  @override
  String get syncCloudAccountsSubtitle => '从安全存储中重新载入账户配置';

  @override
  String get syncCloudAccountsSuccess => '云端账户已成功重载';

  @override
  String get clearAllCredentials => '清除所有凭据';

  @override
  String get clearAllCredentialsSubtitle => '移除加密配置并断开所有已连接的云端服务';

  @override
  String get clearCredentialsDialogTitle => '警告：重置凭据';

  @override
  String get clearCredentialsDialogContent => '确定要删除所有已保存的凭据吗？您将需要重新连接云盘账户。';

  @override
  String get clearCredentialsSuccess => '凭据已成功清除';

  @override
  String get aboutUnifyCloud => '关于 UnifyCloud';

  @override
  String get appVersion => '应用版本：1.0.0';

  @override
  String get developerInfo => '开发者：LeoRise (@leorise25)';

  @override
  String get engineInfo => '引擎：Rclone Core CGO (Go v1.22+ / C FFI)';

  @override
  String get frameworkInfo => '框架：Flutter (Material 3 响应式)';

  @override
  String get licenseInfo => '许可证：GNU 通用公共许可证 v3.0 (GPL-3.0)';

  @override
  String get copyrightInfo => '版权所有：© 2026 Leonardo Bani';

  @override
  String get storageOverview => '存储总览';

  @override
  String get connectedClouds => '已连接云盘';

  @override
  String get noCloudsConfigured => '未配置任何云端账户';

  @override
  String get noCloudsDescription => '连接您的第一个云端存储账户，开始管理和同步您的文件。';

  @override
  String get addCloud => '添加云盘';

  @override
  String get used => '已用';

  @override
  String get free => '可用';

  @override
  String get total => '总量';

  @override
  String get manageAccounts => '管理账户';

  @override
  String get viewFiles => '查看文件';

  @override
  String get createVaultHere => '在此创建加密保险库...';

  @override
  String get disconnectAccount => '断开账户连接';

  @override
  String get disconnectConfirmTitle => '断开账户？';

  @override
  String get disconnectConfirmContent => '确定要断开此账户吗？云端远程文件不会受到任何影响。';

  @override
  String get allFiles => '全部文件';

  @override
  String get emptyFolder => '此文件夹为空';

  @override
  String get emptyFolderSubtitle => '上传文件或创建子文件夹以开始使用。';

  @override
  String get uploadFile => '上传文件';

  @override
  String get uploadFolder => '上传整个文件夹';

  @override
  String get newFolder => '新建文件夹';

  @override
  String get newFolderPrompt => '请输入新文件夹名称：';

  @override
  String get folderNameHint => '文件夹名称';

  @override
  String get selectAll => '全选';

  @override
  String get clearSelection => '清除选择';

  @override
  String get deleteSelected => '删除所选';

  @override
  String get deleteSelectedPrompt => '确定要删除选中的项目吗？';

  @override
  String get deleteItemPrompt => '确定要删除此项目吗？';

  @override
  String get shareLink => '分享链接';

  @override
  String get createShareLink => '创建共享链接';

  @override
  String get copyShareLink => '复制链接';

  @override
  String get copiedToClipboard => '已复制到剪贴板';

  @override
  String get transfers => '传输';

  @override
  String get activeTransfers => '正在传输';

  @override
  String get completed => '已完成';

  @override
  String get failed => '失败';

  @override
  String get queued => '排队中';

  @override
  String get cancelTransfer => '取消传输';

  @override
  String get clearCompleted => '清除已完成';

  @override
  String get syncRulesTitle => '备份与同步规则';

  @override
  String get newRule => '新建规则';

  @override
  String get noSyncRules => '未配置同步规则';

  @override
  String get noSyncRulesSubtitle => '创建自动规则，将本地文件夹同步至云盘。';

  @override
  String get ruleName => '规则名称';

  @override
  String get sourcePath => '源文件夹';

  @override
  String get destinationCloud => '目标云盘';

  @override
  String get destinationPath => '云端路径';

  @override
  String get direction => '方向';

  @override
  String get frequency => '频率';

  @override
  String get runNow => '立即执行';

  @override
  String get syncInProgress => '正在同步...';

  @override
  String get syncSuccess => '同步完成';

  @override
  String get syncFailed => '同步失败';

  @override
  String get addCloudDialogTitle => '连接新云盘';

  @override
  String get selectProvider => '选择云盘提供商';

  @override
  String get accountNameLabel => '账户名称 / 别名';

  @override
  String get connectButton => '连接账户';

  @override
  String get vaultTitle => '端到端加密 (Crypt)';

  @override
  String get vaultPassword => '保险库密码';

  @override
  String get vaultConfirmPassword => '确认密码';

  @override
  String get vaultSalt => '盐值 / 二级密码 (选填)';

  @override
  String get encryptFileNames => '加密文件名';

  @override
  String get encryptDirNames => '加密文件夹名';

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
  String get selectLanguage => '选择语言';

  @override
  String get searchLanguageHint => '搜索语言或国家...';

  @override
  String get currentLanguage => '当前语言';

  @override
  String systemDefaultWithLocale(String locale) {
    return '系统默认 ($locale)';
  }

  @override
  String get refreshCloudsTooltip => '刷新云端配置';

  @override
  String get storageOverviewAggregated => '汇总存储总览';

  @override
  String get ramEncryptionActive => '内存加密已激活';

  @override
  String connectedAccountsCount(int count) {
    return '已连接云端账户：$count';
  }

  @override
  String get noCloudsConfiguredHint => '未配置云端账户。点击下方的“+ 连接新云盘”。';

  @override
  String percentUsed(String percent) {
    return '已使用 $percent%';
  }

  @override
  String availableSpace(String space) {
    return '剩余 $space';
  }

  @override
  String get calculatingQuota => '正在计算配额或容量无限...';

  @override
  String get syncAndBackup => '同步与备份';

  @override
  String get noRulesConfigured => '未配置任何同步规则';

  @override
  String activeRulesCount(int active, int total) {
    return '$active/$total 条活跃规则';
  }

  @override
  String get manage => '管理';

  @override
  String connectedCloudsCount(int count) {
    return '已连接云盘 ($count)';
  }

  @override
  String get connectNewCloud => '连接新云盘';

  @override
  String get noCloudProvidersConnected => '未连接云盘提供商';

  @override
  String get connectCloudDescription =>
      '连接 Google Drive、Dropbox、OneDrive、SFTP 或 WebDAV，轻松同步与探索文件。';

  @override
  String get addFirstCloud => '添加第一个云盘';

  @override
  String vaultOnRemote(String remote) {
    return '$remote 上的保险库';
  }

  @override
  String get disconnectCloudTitle => '断开云盘连接';

  @override
  String disconnectCloudPrompt(String name) {
    return '确定要断开“$name”吗？其凭据将从加密存储中安全删除。';
  }

  @override
  String get disconnect => '断开连接';

  @override
  String freeSpace(String space) {
    return '剩余 $space';
  }

  @override
  String get storage => '存储';

  @override
  String get available => '可用';

  @override
  String get exploreFiles => '浏览文件';

  @override
  String get paneLeft => '左栏';

  @override
  String get paneRight => '右栏';

  @override
  String get folderName => '文件夹名称';

  @override
  String errorCreatingFolder(String error) {
    return '创建文件夹失败：$error';
  }

  @override
  String get moveAction => '移动';

  @override
  String get copyAction => '复制';

  @override
  String transferBatchStarted(String action, int count, String remote) {
    return '已开始将 $count 项$action到 [$remote]...';
  }

  @override
  String errorTransferring(String error) {
    return '传输过程中出错：$error';
  }

  @override
  String itemCopiedToClipboard(String name) {
    return '“$name”已复制到剪贴板';
  }

  @override
  String itemsCopiedToClipboard(int count) {
    return '已复制 $count 项到剪贴板';
  }

  @override
  String itemCutToClipboard(String name) {
    return '“$name”已剪切（准备移动）';
  }

  @override
  String itemsCutToClipboard(int count) {
    return '已剪切 $count 项（准备移动）';
  }

  @override
  String get noFilesSelectedForDownload => '未选择任何要下载的文件。';

  @override
  String downloadingItems(int count) {
    return '正在下载 $count 个项目...';
  }

  @override
  String itemsDownloadedSuccess(int count, String path) {
    return '已成功下载 $count 项至“$path”';
  }

  @override
  String errorStartingDownload(String error) {
    return '启动下载失败：$error';
  }

  @override
  String deleteItemsConfirmTitle(int count) {
    return '确定删除选中的 $count 项吗？';
  }

  @override
  String deleteItemsConfirmPrompt(int count) {
    return '确定要从云端永久删除这 $count 个选中的项目吗？';
  }

  @override
  String itemsDeletedSuccess(int count) {
    return '已删除 $count 个项目';
  }

  @override
  String errorDeleting(String error) {
    return '删除过程中出错：$error';
  }

  @override
  String get uploadCompletedSuccess => '上传成功完成';

  @override
  String errorUploading(String error) {
    return '上传过程中出错：$error';
  }

  @override
  String get folderUploadCompletedSuccess => '文件夹上传成功';

  @override
  String errorFolderUploading(String error) {
    return '上传文件夹出错：$error';
  }

  @override
  String get filesAlreadyInDirectory => '文件已在此文件夹中。';

  @override
  String dragDropTransferStarted(String action, int count, String remote) {
    return '已启动将 $count 项$action至 [$remote]...';
  }

  @override
  String errorDragDrop(String error) {
    return '拖拽传输过程中出错：$error';
  }

  @override
  String get closeSelection => '退出选择';

  @override
  String itemsSelectedCount(int count) {
    return '已选择 $count 项';
  }

  @override
  String get deselectAll => '取消全选';

  @override
  String copyToRemote(String remote) {
    return '复制到 $remote';
  }

  @override
  String moveToRemote(String remote) {
    return '移动到 $remote';
  }

  @override
  String get moreActions => '更多操作';

  @override
  String get downloadSelected => '下载选中项';

  @override
  String get copyToClipboard => '复制到剪贴板';

  @override
  String get cutToClipboard => '剪切到剪贴板';

  @override
  String get selectCloud => '选择云盘';

  @override
  String get closeSearch => '关闭搜索';

  @override
  String get uploadFromDevice => '从设备上传';

  @override
  String get moreOptions => '更多选项';

  @override
  String get viewGrid => '网格视图';

  @override
  String get viewList => '列表视图';

  @override
  String get multiSelection => '多选模式';

  @override
  String get sortNameAsc => '名称 (A-Z)';

  @override
  String get sortNameDesc => '名称 (Z-A)';

  @override
  String get sortSizeDesc => '大小 (从大到小)';

  @override
  String get sortSizeAsc => '大小 (从小到大)';

  @override
  String get sortDateDesc => '日期 (从新到旧)';

  @override
  String get disableDualPane => '关闭 Commander (单栏模式)';

  @override
  String get enableDualPane => '开启 Commander (双栏模式)';

  @override
  String itemsInClipboard(int count) {
    return '剪贴板中有 $count 项';
  }

  @override
  String get pasteHere => '粘贴到此处';

  @override
  String get noResults => '无搜索结果';

  @override
  String noMatchingResults(String query) {
    return '未找到匹配“$query”的文件或文件夹';
  }

  @override
  String get selectACloud => '请选择云盘';

  @override
  String get selectCloudDescription => '请从顶部菜单选择一个云端服务提供商以浏览文件。';

  @override
  String optionsForItem(String name) {
    return '$name 的选项';
  }

  @override
  String get select => '选择';

  @override
  String get openWithSystemApp => '使用系统应用打开';

  @override
  String get downloadToLocal => '下载到本地';

  @override
  String get cut => '剪切 (移动)';

  @override
  String get copyPath => '复制路径';

  @override
  String get info => '信息';

  @override
  String generatingShareLink(String name) {
    return '正在为“$name”生成分享链接...';
  }

  @override
  String errorPublicLink(String error) {
    return '公开链接生成失败：$error';
  }

  @override
  String get noLinkGenerated => '服务商未返回任何链接。';

  @override
  String errorDownloading(String error) {
    return '下载出错：$error';
  }

  @override
  String get renameFolderTitle => '重命名文件夹';

  @override
  String get renameFileTitle => '重命名文件';

  @override
  String errorRenaming(String error) {
    return '重命名失败：$error';
  }

  @override
  String get pathCopiedToClipboard => '路径已复制到剪贴板';

  @override
  String itemDetailsPath(String path) {
    return '路径：$path';
  }

  @override
  String itemDetailsType(String type) {
    return '类型：$type';
  }

  @override
  String itemDetailsSize(String size) {
    return '大小：$size';
  }

  @override
  String itemDetailsModified(String date) {
    return '修改日期：$date';
  }

  @override
  String get folder => '文件夹';

  @override
  String get file => '文件';

  @override
  String get selectCloudFirstLeft => '请先在左栏选择云盘。';

  @override
  String get selectCloudFirstRight => '请先在右栏选择云盘。';

  @override
  String get selectDestinationCloudLeft => '请先在左栏选择目标云盘。';

  @override
  String get selectDestinationCloudRight => '请先在右栏选择目标云盘。';

  @override
  String get noFilesToTransfer => '当前没有文件可供传输。';

  @override
  String transferStarted(String action, int count, String src, String dst) {
    return '已启动将 $count 项从 [$src] $action到 [$dst]...';
  }

  @override
  String get swapPanesTooltip => '左右对调 (<->)';

  @override
  String get refreshBothPanesTooltip => '刷新两侧面板';

  @override
  String get copyRight => '向右复制 ->';

  @override
  String get moveRight => '向右移动 ->';

  @override
  String get copyLeft => '<- 向左复制';

  @override
  String get moveLeft => '<- 向左移动';

  @override
  String copyRightWithCount(int count) {
    return '向右复制 ($count) ->';
  }

  @override
  String moveRightWithCount(int count) {
    return '向右移动 ($count) ->';
  }

  @override
  String copyLeftWithCount(int count) {
    return '<- 向左复制 ($count)';
  }

  @override
  String moveLeftWithCount(int count) {
    return '<- 向左移动 ($count)';
  }

  @override
  String get deleteRuleTitle => '删除规则';

  @override
  String deleteRulePrompt(String name) {
    return '确定要删除同步规则“$name”吗？本地与云端的文件均不会被删除。';
  }

  @override
  String get syncAll => '全部同步';

  @override
  String get newRuleTooltip => '新建规则';

  @override
  String get backupBannerTitle => '持续备份与多云同步';

  @override
  String get backupBannerSubtitle => '在本地文件夹与云端存储之间配置计划同步任务。';

  @override
  String get noActiveRules => '暂无活跃规则';

  @override
  String get noActiveRulesSubtitle =>
      '创建您的第一条规则，自动将手机中的照片或文件备份到 Google Drive、Dropbox 或 SFTP。';

  @override
  String get createNewRule => '创建新规则';

  @override
  String get ruleOptionsTooltip => '规则选项';

  @override
  String get syncNow => '立即同步';

  @override
  String get statusWaiting => '等待中';

  @override
  String get statusInProgress => '进行中...';

  @override
  String get statusCompleted => '已完成';

  @override
  String get statusFailed => '失败';

  @override
  String get editRuleTitle => '编辑备份规则';

  @override
  String get newRuleTitle => '新建同步规则';

  @override
  String get ruleDialogSubtitle => '配置本地文件夹与云端之间的自动备份。';

  @override
  String get ruleNameOptional => '规则名称 (选填)';

  @override
  String get ruleNameHint => '例如 相机DCIM备份 或 工作文档';

  @override
  String get sourceLocalFolder => '本地源文件夹';

  @override
  String get sourceLocalFolderHint =>
      '/storage/emulated/0/DCIM 或 /home/user/Pictures';

  @override
  String get browseFolders => '浏览文件夹';

  @override
  String get selectLocalFolderError => '请输入或选择本地文件夹';

  @override
  String get noCloudsConfiguredSync => '未配置云端账户。请先在首页添加云盘。';

  @override
  String get remoteDestinationPath => '目标云端路径';

  @override
  String get syncMode => '同步模式';

  @override
  String get syncModeCopy => '增量备份';

  @override
  String get syncModeCopyDesc => '上传新增和修改的文件，始终保留云端既有文件。';

  @override
  String get syncModeSync => '镜像同步';

  @override
  String get syncModeSyncDesc => '使云端目标与本地完全一致（本地删除的文件会从云端移除）。';

  @override
  String get syncFrequency => '执行频率';

  @override
  String get freqManual => '手动 (仅按需)';

  @override
  String get freq15Min => '每 15 分钟';

  @override
  String get freq30Min => '每 30 分钟';

  @override
  String get freqHourly => '每小时';

  @override
  String get freq6Hours => '每 6 小时';

  @override
  String get freq12Hours => '每 12 小时';

  @override
  String get freqDaily => '每天 (24 小时)';

  @override
  String get activateRuleImmediately => '立即启用规则';

  @override
  String get activateRuleImmediatelyDesc => '同步任务将根据指定的时间间隔在后台自动执行';

  @override
  String get updateRule => '更新';

  @override
  String get saveRule => '保存规则';

  @override
  String get selectCloudProvider => '选择云盘提供商：';

  @override
  String get cloudAccountName => '云盘账户名称';

  @override
  String get cloudAccountNameHint => '例如 GoogleDrive, WorkDropbox (无空格)';

  @override
  String get enterNameError => '请输入名称';

  @override
  String get noSpacesOrColons => '不允许包含空格或冒号“:”';

  @override
  String get oauthMode => 'Client ID 模式 (OAuth2)';

  @override
  String get oauthOfficial => 'UnifyCloud (官方 / 推荐)';

  @override
  String get oauthRclone => 'Rclone (不推荐 - 共享配额)';

  @override
  String get oauthCustom => '个人 Client ID (高级)';

  @override
  String get officialOauthTitle => '官方 UnifyCloud 凭据';

  @override
  String get officialOauthDesc => '预配置凭据，即刻连接，享有专属配额与极致传输速度。';

  @override
  String get rcloneOauthDesc => 'Rclone 共享开源密钥。可能会遇到速率限制或 Google 403 错误。';

  @override
  String get customClientId => 'Client ID';

  @override
  String get customClientSecret => 'Client Secret';

  @override
  String get selectVaultDestination => '选择保险库的目标云盘';

  @override
  String get vaultPasswordRequired => '必须填写加密密码';

  @override
  String get vaultPasswordsDoNotMatch => '两次输入的密码不一致';

  @override
  String errorAddingRemote(String error) {
    return '添加云盘失败：$error';
  }

  @override
  String get fileNameEncryption => '文件名加密方式';

  @override
  String get encryptStandard => '标准 (完全加密文件名 - 推荐)';

  @override
  String get encryptObscure => '简单混淆 (保留文件后缀)';

  @override
  String get encryptOff => '关闭 (明文文件名)';

  @override
  String get encryptFolderNames => '同时加密文件夹名称';

  @override
  String get encryptFolderNamesDesc => '在云端彻底隐藏目录结构';

  @override
  String get connectCloud => '连接云盘';

  @override
  String get reopenAuth => '重新打开授权';

  @override
  String get linkCopiedToClipboard => '链接已复制到剪贴板！';

  @override
  String errorOpenBrowserGeneric(String error) {
    return '无法打开浏览器：$error';
  }

  @override
  String get shareableLinkTitle => '共享链接';

  @override
  String shareLinkAccessDescription(String item) {
    return '拥有此链接的任何人均可访问 $item：';
  }

  @override
  String get open => '打开';

  @override
  String activeTransfersCount(int count) {
    return '$count 个活跃传输';
  }

  @override
  String transfersQueueCount(int count) {
    return '传输队列 ($count)';
  }

  @override
  String get noTransfersInProgress => '没有正在进行的传输';

  @override
  String get transfersEmptySubtitle => '所有上传或下载的文件都会显示在此处';

  @override
  String get cancelled => '已取消';

  @override
  String get appLockedTitle => '应用已锁定';

  @override
  String get unlockWithBiometrics => '使用生物识别解锁';

  @override
  String get pinMustBe6Digits => 'PIN 码必须为 6 位数字';

  @override
  String get pinIncorrect => 'PIN 码错误，请重试。';

  @override
  String get pinsDoNotMatch => '两次输入的 PIN 码不匹配，请重试。';

  @override
  String get pinStepOld => '请输入当前的 PIN 码以继续。';

  @override
  String get pinStepNew => '请输入新的 6 位安全 PIN 码。';

  @override
  String get pinStepConfirm => '请再次输入新的 PIN 码以确认。';

  @override
  String get pinStepVerify => '请输入 PIN 码以验证操作。';

  @override
  String get pinTitleSetup => '设置安全 PIN 码';

  @override
  String get pinTitleChange => '修改安全 PIN 码';

  @override
  String get pinTitleVerify => '安全验证';

  @override
  String get pinContinue => '继续';

  @override
  String get errorDetails => '错误详情';

  @override
  String get errorDetailsCopied => '错误详情已复制到剪贴板';

  @override
  String get collapse => '收起';

  @override
  String get expand => '展开';

  @override
  String get copyError => '复制错误';

  @override
  String get errorNetwork => '网络断开或不稳定。请检查您的网络连接并重试。';

  @override
  String get errorDiskSpace => '存储空间不足或磁盘已满。请清理空间后重试。';

  @override
  String get errorAuthExpired => '会话或授权令牌已过期/撤销。请重新连接您的账户。';

  @override
  String get errorNotFound => '云端未找到指定的文件或文件夹。';

  @override
  String get errorPermissionDenied => '无权在云端执行此操作。';

  @override
  String get errorGeneric => '操作过程中发生错误。';

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
