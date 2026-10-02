// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'UnifyCloud';

  @override
  String get home => 'ホーム';

  @override
  String get explorer => 'ファイル';

  @override
  String get sync => '同期';

  @override
  String get settings => '設定';

  @override
  String get cancel => 'キャンセル';

  @override
  String get confirm => '確認';

  @override
  String get delete => '削除';

  @override
  String get save => '保存';

  @override
  String get close => '閉じる';

  @override
  String get edit => '編集';

  @override
  String get create => '作成';

  @override
  String get retry => '再試行';

  @override
  String get copy => 'コピー';

  @override
  String get move => '移動';

  @override
  String get rename => '名前変更';

  @override
  String get download => 'ダウンロード';

  @override
  String get upload => 'アップロード';

  @override
  String get share => '共有';

  @override
  String get details => '詳細';

  @override
  String get search => '検索';

  @override
  String get change => '変更';

  @override
  String get reset => 'リセット';

  @override
  String get done => '完了';

  @override
  String get loading => '読み込み中...';

  @override
  String get success => '操作が完了しました';

  @override
  String get error => 'エラー';

  @override
  String get settingsTitle => '設定';

  @override
  String get resetDefaultsTooltip => 'デフォルト設定に戻す';

  @override
  String get resetDialogTitle => '設定のリセット';

  @override
  String get resetDialogContent => 'すべての設定（テーマ、言語、フォルダー、表示）を出荷時デフォルトにリセットしますか？';

  @override
  String get resetSuccessSnackbar => '設定をデフォルトに戻しました';

  @override
  String get appearanceAndTheme => '外観とテーマ';

  @override
  String get chooseVisualThemeSubtitle => 'UnifyCloudのUIテーマを選択：';

  @override
  String get themeSystem => 'システム';

  @override
  String get themeLight => 'ライト';

  @override
  String get themeDark => 'ダーク';

  @override
  String get language => '言語';

  @override
  String get languageSubtitle => 'インターフェース言語を選択';

  @override
  String get langEnglish => 'English';

  @override
  String get langItalian => 'Italiano';

  @override
  String get langSystem => 'システムのデフォルト';

  @override
  String get filesAndExploration => 'ファイルと探索';

  @override
  String get showHiddenFiles => '隠しファイルを表示';

  @override
  String get showHiddenFilesSubtitle => 'ドット (.) で始まるファイルやフォルダーを表示する';

  @override
  String get confirmBeforeDelete => '削除前に確認';

  @override
  String get confirmBeforeDeleteSubtitle => 'ファイルを完全に削除する前に確認メッセージを表示する';

  @override
  String get defaultDownloadFolder => 'デフォルトのダウンロードフォルダー';

  @override
  String get defaultDownloadFolderSystem => 'システムのデフォルトダウンロード先';

  @override
  String get restoreDefaultPath => 'デフォルトパスに戻す';

  @override
  String get customDownloadFolderDialogPrompt =>
      'システムピッカーでフォルダーを選択するか、パスを直接入力してください：';

  @override
  String get folderPath => 'フォルダーのパス';

  @override
  String get folderPathHint => '例: /home/user/Downloads';

  @override
  String get browseWithSystemPicker => 'システムピッカーで参照';

  @override
  String errorOpenPicker(String error) {
    return 'ピッカーを開けませんでした: $error';
  }

  @override
  String get restoreDefault => 'デフォルトに戻す';

  @override
  String get maxConcurrentTransfers => '同時転送数';

  @override
  String get maxConcurrentTransfersSubtitle => '同時に実行するファイル転送の最大数';

  @override
  String get dualPaneMode => '2画面コマンダーモード';

  @override
  String get dualPaneModeSubtitle => 'タブレットや大型画面で2画面を並べて表示する';

  @override
  String get communityAndSupport => 'コミュニティとサポート';

  @override
  String get openSourceDescription =>
      'UnifyCloudはトラッカーやプロプライエタリな仲介者を一切介さず、クラウドデータを一元化する自由なオープンソースソフトウェアです。';

  @override
  String get supportDeveloper => '開発者を支援';

  @override
  String get supportDeveloperSubtitle => 'コーヒーをおごって個人開発をサポートする';

  @override
  String get viewSourceOnGitLab => 'GitLabでコードを見る';

  @override
  String get viewSourceOnGitLabSubtitle => '公式リポジトリ、バグ報告、開発への貢献';

  @override
  String errorOpenBrowser(String url) {
    return 'ブラウザを開けませんでした。URL: $url';
  }

  @override
  String get supportDialogTitle => 'UnifyCloudを支援';

  @override
  String get supportDialogDescription1 =>
      'UnifyCloudはクラウドファイルを完全にコントロールできるように作られた無料のオープンソースプロジェクトです。';

  @override
  String get supportDialogDescription2 =>
      'アプリが役に立ちましたら、継続的な開発や新機能追加のためにご支援をお願いいたします！';

  @override
  String get supportKofiTitle => 'Ko-fiでコーヒーをおごる';

  @override
  String get supportLiberapayTitle => 'Liberapayで寄付する';

  @override
  String get supportPaypalTitle => 'PayPalで寄付する';

  @override
  String get securityAndEncryption => 'セキュリティと暗号化';

  @override
  String get securityArchitectureDescription =>
      'UnifyCloudはゼロ平文アーキテクチャを採用しています。すべてのOAuthトークンと認証情報はシステムのKeychain/Keystoreで保護され、Goエンジンのメモリにのみ展開されます。';

  @override
  String get appLock => 'アプリロック (PIN / 生体認証)';

  @override
  String get appLockSubtitle => 'アクセス時にPINコードまたは指紋を要求する';

  @override
  String get appLockActiveSubtitle => '起動時および一定時間の非アクティブ後に有効';

  @override
  String get appLockEnabledSnackbar => 'アプリロックを有効にしました';

  @override
  String get appLockDisabledSnackbar => 'アプリロックを無効にしました';

  @override
  String get changePin => 'PINコードの変更';

  @override
  String get changePinSubtitle => '新しい6桁のセキュリティPINを設定';

  @override
  String get pinChangedSnackbar => 'セキュリティPINを更新しました';

  @override
  String get biometricAuth => '生体認証';

  @override
  String get biometricAuthSubtitle => '利用可能な場合、指紋または顔認証を使用する';

  @override
  String get biometricNotAvailable => 'このデバイスでは利用できないか設定されていません';

  @override
  String get autoLock => '自動ロック';

  @override
  String get autoLockSubtitle => 'バックグラウンドでの待機時間';

  @override
  String get lockImmediately => '即時';

  @override
  String get lockAfter1Minute => '1分後';

  @override
  String get lockAfter5Minutes => '5分後';

  @override
  String get lockAfter15Minutes => '15分後';

  @override
  String get lockAfter30Minutes => '30分後';

  @override
  String get syncCloudAccounts => 'クラウド口座の同期';

  @override
  String get syncCloudAccountsSubtitle => 'セキュアストレージから設定を再読み込み';

  @override
  String get syncCloudAccountsSuccess => 'クラウド口座を再読み込みしました';

  @override
  String get clearAllCredentials => '全認証情報の消去';

  @override
  String get clearAllCredentialsSubtitle => '暗号化された設定を消去し、すべての接続を解除します';

  @override
  String get clearCredentialsDialogTitle => '警告: 認証情報のリセット';

  @override
  String get clearCredentialsDialogContent =>
      '保存されているすべての認証情報を削除してもよろしいですか？再度アカウントを接続する必要があります。';

  @override
  String get clearCredentialsSuccess => '認証情報を削除しました';

  @override
  String get aboutUnifyCloud => 'UnifyCloudについて';

  @override
  String get appVersion => 'アプリバージョン: 1.0.0';

  @override
  String get developerInfo => '開発者: LeoRise (@leorise25)';

  @override
  String get engineInfo => 'エンジン: Rclone Core CGO (Go v1.22+ / C FFI)';

  @override
  String get frameworkInfo => 'フレームワーク: Flutter (Material 3 Responsive)';

  @override
  String get licenseInfo => 'ライセンス: GNU General Public License v3.0 (GPL-3.0)';

  @override
  String get copyrightInfo => '著作権: © 2026 Leonardo Bani';

  @override
  String get storageOverview => 'ストレージ概要';

  @override
  String get connectedClouds => '接続済みクラウド';

  @override
  String get noCloudsConfigured => 'クラウド口座が設定されていません';

  @override
  String get noCloudsDescription => '最初のクラウドストレージを接続して、ファイルの管理と同期を開始しましょう。';

  @override
  String get addCloud => 'クラウド追加';

  @override
  String get used => '使用済み';

  @override
  String get free => '空き';

  @override
  String get total => '合計';

  @override
  String get manageAccounts => 'アカウント管理';

  @override
  String get viewFiles => 'ファイルを表示';

  @override
  String get createVaultHere => 'ここに暗号化保管庫を作成...';

  @override
  String get disconnectAccount => 'アカウントの切断';

  @override
  String get disconnectConfirmTitle => 'アカウントを切断しますか？';

  @override
  String get disconnectConfirmContent => 'このアカウントを切断しますか？クラウド上のファイルは保持されます。';

  @override
  String get allFiles => 'すべてのファイル';

  @override
  String get emptyFolder => 'このフォルダーは空です';

  @override
  String get emptyFolderSubtitle => 'ファイルをアップロードするか、サブフォルダーを作成してください。';

  @override
  String get uploadFile => 'ファイルをアップロード';

  @override
  String get uploadFolder => 'フォルダー全体をアップロード';

  @override
  String get newFolder => '新しいフォルダー';

  @override
  String get newFolderPrompt => 'フォルダー名を入力してください:';

  @override
  String get folderNameHint => 'フォルダー名';

  @override
  String get selectAll => 'すべて選択';

  @override
  String get clearSelection => '選択解除';

  @override
  String get deleteSelected => '選択項目を削除';

  @override
  String get deleteSelectedPrompt => '選択した項目を削除してもよろしいですか？';

  @override
  String get deleteItemPrompt => 'この項目を削除してもよろしいですか？';

  @override
  String get shareLink => '共有リンク';

  @override
  String get createShareLink => '共有リンクを作成';

  @override
  String get copyShareLink => 'リンクをコピー';

  @override
  String get copiedToClipboard => 'クリップボードにコピーしました';

  @override
  String get transfers => '転送';

  @override
  String get activeTransfers => '実行中の転送';

  @override
  String get completed => '完了';

  @override
  String get failed => '失敗';

  @override
  String get queued => '待機中';

  @override
  String get cancelTransfer => '転送をキャンセル';

  @override
  String get clearCompleted => '完了分をクリア';

  @override
  String get syncRulesTitle => 'バックアップ＆同期ルール';

  @override
  String get newRule => '新規ルール';

  @override
  String get noSyncRules => '同期ルールがありません';

  @override
  String get noSyncRulesSubtitle => '自動ルールを作成して、端末のフォルダーをクラウドと同期させましょう。';

  @override
  String get ruleName => 'ルール名';

  @override
  String get sourcePath => '元のフォルダー';

  @override
  String get destinationCloud => '転送先クラウド';

  @override
  String get destinationPath => 'リモートパス';

  @override
  String get direction => '方向';

  @override
  String get frequency => '頻度';

  @override
  String get runNow => '今すぐ実行';

  @override
  String get syncInProgress => '同期中...';

  @override
  String get syncSuccess => '同期が完了しました';

  @override
  String get syncFailed => '同期に失敗しました';

  @override
  String get addCloudDialogTitle => '新しいクラウドを接続';

  @override
  String get selectProvider => 'クラウドプロバイダーを選択';

  @override
  String get accountNameLabel => 'アカウント名 / エイリアス';

  @override
  String get connectButton => 'アカウントを接続';

  @override
  String get vaultTitle => 'エンドツーエンド暗号化 (Crypt)';

  @override
  String get vaultPassword => '保管庫パスワード';

  @override
  String get vaultConfirmPassword => 'パスワード再入力';

  @override
  String get vaultSalt => 'ソルト / 第2パスワード (任意)';

  @override
  String get encryptFileNames => 'ファイル名を暗号化';

  @override
  String get encryptDirNames => 'フォルダー名を暗号化';

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
  String get selectLanguage => '言語を選択';

  @override
  String get searchLanguageHint => '言語または国を検索...';

  @override
  String get currentLanguage => '現在の言語';

  @override
  String systemDefaultWithLocale(String locale) {
    return 'システム標準 ($locale)';
  }

  @override
  String get refreshCloudsTooltip => 'クラウド設定を更新';

  @override
  String get storageOverviewAggregated => 'ストレージ全体概要';

  @override
  String get ramEncryptionActive => 'メモリ暗号化が有効';

  @override
  String connectedAccountsCount(int count) {
    return '接続中のクラウド口座: $count';
  }

  @override
  String get noCloudsConfiguredHint =>
      'クラウド口座がありません。下の「+ 新しいクラウドを接続」をタップしてください。';

  @override
  String percentUsed(String percent) {
    return '$percent% 使用中';
  }

  @override
  String availableSpace(String space) {
    return '空き $space';
  }

  @override
  String get calculatingQuota => 'ストレージ容量を計算中または容量無制限...';

  @override
  String get syncAndBackup => '同期とバックアップ';

  @override
  String get noRulesConfigured => '同期ルールがありません';

  @override
  String activeRulesCount(int active, int total) {
    return '$active/$total 件のアクティブなルール';
  }

  @override
  String get manage => '管理';

  @override
  String connectedCloudsCount(int count) {
    return '接続中のクラウド ($count)';
  }

  @override
  String get connectNewCloud => '新しいクラウドを接続';

  @override
  String get noCloudProvidersConnected => 'クラウドが接続されていません';

  @override
  String get connectCloudDescription =>
      'Google Drive、Dropbox、OneDrive、SFTP、WebDAVに接続して同期を始めましょう。';

  @override
  String get addFirstCloud => '最初のクラウドを追加';

  @override
  String vaultOnRemote(String remote) {
    return '$remote 上の保管庫';
  }

  @override
  String get disconnectCloudTitle => 'クラウドの切断';

  @override
  String disconnectCloudPrompt(String name) {
    return '「$name」を切断しますか？認証情報は安全に消去されます。';
  }

  @override
  String get disconnect => '切断';

  @override
  String freeSpace(String space) {
    return '空き容量 $space';
  }

  @override
  String get storage => 'ストレージ';

  @override
  String get available => '利用可能';

  @override
  String get exploreFiles => 'ファイルを見る';

  @override
  String get paneLeft => '左側';

  @override
  String get paneRight => '右側';

  @override
  String get folderName => 'フォルダー名';

  @override
  String errorCreatingFolder(String error) {
    return 'フォルダーの作成に失敗しました: $error';
  }

  @override
  String get moveAction => '移動';

  @override
  String get copyAction => 'コピー';

  @override
  String transferBatchStarted(String action, int count, String remote) {
    return '$count項目の[$remote]への$actionを開始しました...';
  }

  @override
  String errorTransferring(String error) {
    return '転送エラー: $error';
  }

  @override
  String itemCopiedToClipboard(String name) {
    return '「$name」をクリップボードにコピーしました';
  }

  @override
  String itemsCopiedToClipboard(int count) {
    return '$count項目をクリップボードにコピーしました';
  }

  @override
  String itemCutToClipboard(String name) {
    return '「$name」を切り取りました（移動可能）';
  }

  @override
  String itemsCutToClipboard(int count) {
    return '$count項目を切り取りました（移動可能）';
  }

  @override
  String get noFilesSelectedForDownload => 'ダウンロードするファイルが選択されていません。';

  @override
  String downloadingItems(int count) {
    return '$count項目をダウンロード中...';
  }

  @override
  String itemsDownloadedSuccess(int count, String path) {
    return '$count項目を「$path」にダウンロードしました';
  }

  @override
  String errorStartingDownload(String error) {
    return 'ダウンロードの開始に失敗しました: $error';
  }

  @override
  String deleteItemsConfirmTitle(int count) {
    return '選択した$count項目を削除しますか？';
  }

  @override
  String deleteItemsConfirmPrompt(int count) {
    return '選択した$count項目をクラウドから完全に削除してもよろしいですか？';
  }

  @override
  String itemsDeletedSuccess(int count) {
    return '$count項目を削除しました';
  }

  @override
  String errorDeleting(String error) {
    return '削除エラー: $error';
  }

  @override
  String get uploadCompletedSuccess => 'アップロードが完了しました';

  @override
  String errorUploading(String error) {
    return 'アップロードエラー: $error';
  }

  @override
  String get folderUploadCompletedSuccess => 'フォルダーのアップロードが完了しました';

  @override
  String errorFolderUploading(String error) {
    return 'フォルダーのアップロードエラー: $error';
  }

  @override
  String get filesAlreadyInDirectory => 'ファイルは既にこのフォルダー内にあります。';

  @override
  String dragDropTransferStarted(String action, int count, String remote) {
    return '$count項目の[$remote]への$actionを開始しました...';
  }

  @override
  String errorDragDrop(String error) {
    return 'ドラッグ＆ドロップ転送エラー: $error';
  }

  @override
  String get closeSelection => '選択を終了';

  @override
  String itemsSelectedCount(int count) {
    return '$count項目を選択中';
  }

  @override
  String get deselectAll => '全解除';

  @override
  String copyToRemote(String remote) {
    return '$remoteにコピー';
  }

  @override
  String moveToRemote(String remote) {
    return '$remoteに移動';
  }

  @override
  String get moreActions => 'その他の操作';

  @override
  String get downloadSelected => '選択項目をダウンロード';

  @override
  String get copyToClipboard => 'クリップボードにコピー';

  @override
  String get cutToClipboard => 'クリップボードに切り取り';

  @override
  String get selectCloud => 'クラウドを選択';

  @override
  String get closeSearch => '検索を閉じる';

  @override
  String get uploadFromDevice => '端末からアップロード';

  @override
  String get moreOptions => 'その他のオプション';

  @override
  String get viewGrid => 'グリッド表示';

  @override
  String get viewList => 'リスト表示';

  @override
  String get multiSelection => '複数選択';

  @override
  String get sortNameAsc => '名前順 (昇順)';

  @override
  String get sortNameDesc => '名前順 (降順)';

  @override
  String get sortSizeDesc => 'サイズ順 (大きい順)';

  @override
  String get sortSizeAsc => 'サイズ順 (小さい順)';

  @override
  String get sortDateDesc => '日付順 (新しい順)';

  @override
  String get disableDualPane => 'コマンダーを無効化 (単一画面)';

  @override
  String get enableDualPane => 'コマンダーを有効化 (2画面)';

  @override
  String itemsInClipboard(int count) {
    return 'クリップボードに$count項目';
  }

  @override
  String get pasteHere => 'ここに貼り付け';

  @override
  String get noResults => '見つかりませんでした';

  @override
  String noMatchingResults(String query) {
    return '「$query」に一致するファイルやフォルダーはありません';
  }

  @override
  String get selectACloud => 'クラウドを選択してください';

  @override
  String get selectCloudDescription => '上のメニューからクラウドを選択して、ファイルを探索しましょう。';

  @override
  String optionsForItem(String name) {
    return '$name のオプション';
  }

  @override
  String get select => '選択';

  @override
  String get openWithSystemApp => '既定のアプリで開く';

  @override
  String get downloadToLocal => '端末にダウンロード';

  @override
  String get cut => '切り取り (移動)';

  @override
  String get copyPath => 'パスをコピー';

  @override
  String get info => '情報';

  @override
  String generatingShareLink(String name) {
    return '「$name」の共有リンクを生成中...';
  }

  @override
  String errorPublicLink(String error) {
    return '公開リンクエラー: $error';
  }

  @override
  String get noLinkGenerated => 'プロバイダーからリンクが取得できませんでした。';

  @override
  String errorDownloading(String error) {
    return 'ダウンロードエラー: $error';
  }

  @override
  String get renameFolderTitle => 'フォルダー名の変更';

  @override
  String get renameFileTitle => 'ファイル名の変更';

  @override
  String errorRenaming(String error) {
    return '名前変更エラー: $error';
  }

  @override
  String get pathCopiedToClipboard => 'パスをコピーしました';

  @override
  String itemDetailsPath(String path) {
    return 'パス: $path';
  }

  @override
  String itemDetailsType(String type) {
    return '種類: $type';
  }

  @override
  String itemDetailsSize(String size) {
    return 'サイズ: $size';
  }

  @override
  String itemDetailsModified(String date) {
    return '更新日時: $date';
  }

  @override
  String get folder => 'フォルダー';

  @override
  String get file => 'ファイル';

  @override
  String get selectCloudFirstLeft => '左側画面でクラウドを選択してください。';

  @override
  String get selectCloudFirstRight => '右側画面でクラウドを選択してください。';

  @override
  String get selectDestinationCloudLeft => '左側画面で転送先クラウドを選択してください。';

  @override
  String get selectDestinationCloudRight => '右側画面で転送先クラウドを選択してください。';

  @override
  String get noFilesToTransfer => '転送対象のファイルがありません。';

  @override
  String transferStarted(String action, int count, String src, String dst) {
    return '$count項目の[$src]から[$dst]への$actionを開始しました...';
  }

  @override
  String get swapPanesTooltip => '左右の画面を入れ替え (<->)';

  @override
  String get refreshBothPanesTooltip => '両方の画面を更新';

  @override
  String get copyRight => '右へコピー ->';

  @override
  String get moveRight => '右へ移動 ->';

  @override
  String get copyLeft => '<- 左へコピー';

  @override
  String get moveLeft => '<- 左へ移動';

  @override
  String copyRightWithCount(int count) {
    return '右へコピー ($count) ->';
  }

  @override
  String moveRightWithCount(int count) {
    return '右へ移動 ($count) ->';
  }

  @override
  String copyLeftWithCount(int count) {
    return '<- 左へコピー ($count)';
  }

  @override
  String moveLeftWithCount(int count) {
    return '<- 左へ移動 ($count)';
  }

  @override
  String get deleteRuleTitle => 'ルールの削除';

  @override
  String deleteRulePrompt(String name) {
    return '同期ルール「$name」を削除しますか？端末やクラウド上のファイルは削除されません。';
  }

  @override
  String get syncAll => 'すべて同期';

  @override
  String get newRuleTooltip => '新規ルール';

  @override
  String get backupBannerTitle => '継続バックアップとクラウド同期';

  @override
  String get backupBannerSubtitle => 'ローカルフォルダーとクラウド間の定期同期を設定します。';

  @override
  String get noActiveRules => '有効なルールがありません';

  @override
  String get noActiveRulesSubtitle =>
      '最初のルールを作成して、Google Drive、Dropbox、SFTPなどに写真を自動バックアップしましょう。';

  @override
  String get createNewRule => '新しいルールを作成';

  @override
  String get ruleOptionsTooltip => 'ルールのオプション';

  @override
  String get syncNow => '今すぐ同期';

  @override
  String get statusWaiting => '待機中';

  @override
  String get statusInProgress => '実行中...';

  @override
  String get statusCompleted => '完了';

  @override
  String get statusFailed => 'エラー';

  @override
  String get editRuleTitle => 'バックアップルールの編集';

  @override
  String get newRuleTitle => '新規同期ルール';

  @override
  String get ruleDialogSubtitle => 'ローカルフォルダーとクラウドの自動バックアップを設定します。';

  @override
  String get ruleNameOptional => 'ルール名 (任意)';

  @override
  String get ruleNameHint => '例: DCIM写真バックアップ または 仕事書類';

  @override
  String get sourceLocalFolder => '対象のローカルフォルダー';

  @override
  String get sourceLocalFolderHint =>
      '/storage/emulated/0/DCIM または /home/user/Pictures';

  @override
  String get browseFolders => 'フォルダーを参照';

  @override
  String get selectLocalFolderError => 'ローカルフォルダーを選択または入力してください';

  @override
  String get noCloudsConfiguredSync => 'クラウドが設定されていません。先にホームからクラウドを追加してください。';

  @override
  String get remoteDestinationPath => 'リモートの転送先パス';

  @override
  String get syncMode => '同期モード';

  @override
  String get syncModeCopy => '増分バックアップ';

  @override
  String get syncModeCopyDesc =>
      'クラウド上の既存ファイルを消さずに、新しいファイルと更新されたファイルのみアップロードします。';

  @override
  String get syncModeSync => 'ミラー同期';

  @override
  String get syncModeSyncDesc =>
      '転送先をローカルと完全に一致させます（端末で削除したファイルはクラウドからも削除されます）。';

  @override
  String get syncFrequency => '実行頻度';

  @override
  String get freqManual => '手動 (要求時のみ)';

  @override
  String get freq15Min => '15分ごと';

  @override
  String get freq30Min => '30分ごと';

  @override
  String get freqHourly => '1時間ごと';

  @override
  String get freq6Hours => '6時間ごと';

  @override
  String get freq12Hours => '12時間ごと';

  @override
  String get freqDaily => '毎日 (24時間ごと)';

  @override
  String get activateRuleImmediately => 'ルールを今すぐ有効化する';

  @override
  String get activateRuleImmediatelyDesc => '設定された間隔に従ってバックグラウンドで自動同期されます';

  @override
  String get updateRule => '更新';

  @override
  String get saveRule => 'ルールを保存';

  @override
  String get selectCloudProvider => 'クラウドプロバイダーを選択:';

  @override
  String get cloudAccountName => 'クラウド口座名';

  @override
  String get cloudAccountNameHint => '例: GoogleDrive, WorkDropbox (スペースなし)';

  @override
  String get enterNameError => '名前を入力してください';

  @override
  String get noSpacesOrColons => 'スペースおよび「:」は使用できません';

  @override
  String get oauthMode => 'Client ID モード (OAuth2)';

  @override
  String get oauthOfficial => 'UnifyCloud (公式 / 推奨)';

  @override
  String get oauthRclone => 'Rclone (非推奨 - 共有クォータ)';

  @override
  String get oauthCustom => '個人のClient ID (上級者向け)';

  @override
  String get officialOauthTitle => '公式UnifyCloud認証情報';

  @override
  String get officialOauthDesc => '専用クォータと最高速度で即座に接続できる事前設定済みの認証情報です。';

  @override
  String get rcloneOauthDesc =>
      'Rcloneの共有オープンソースキーです。利用制限やGoogle 403エラーが発生する場合があります。';

  @override
  String get customClientId => 'Client ID';

  @override
  String get customClientSecret => 'Client Secret';

  @override
  String get selectVaultDestination => '保管庫を作成するクラウドを選択';

  @override
  String get vaultPasswordRequired => '暗号化パスワードは必須です';

  @override
  String get vaultPasswordsDoNotMatch => 'パスワードが一致しません';

  @override
  String errorAddingRemote(String error) {
    return 'クラウドの追加に失敗しました: $error';
  }

  @override
  String get fileNameEncryption => 'ファイル名の暗号化';

  @override
  String get encryptStandard => '標準 (ファイル名を完全暗号化 - 推奨)';

  @override
  String get encryptObscure => '簡易難読化 (拡張子を保持)';

  @override
  String get encryptOff => '無効 (平文表示)';

  @override
  String get encryptFolderNames => 'フォルダー名も暗号化する';

  @override
  String get encryptFolderNamesDesc => 'クラウド上のディレクトリ構造を完全に秘匿します';

  @override
  String get connectCloud => 'クラウドに接続';

  @override
  String get reopenAuth => '再開する';

  @override
  String get linkCopiedToClipboard => 'リンクをクリップボードにコピーしました！';

  @override
  String errorOpenBrowserGeneric(String error) {
    return 'ブラウザを開けませんでした: $error';
  }

  @override
  String get shareableLinkTitle => '共有リンク';

  @override
  String shareLinkAccessDescription(String item) {
    return 'このリンクを持つすべてのユーザーが $item にアクセスできます:';
  }

  @override
  String get open => '開く';

  @override
  String activeTransfersCount(int count) {
    return '$count件の実行中転送';
  }

  @override
  String transfersQueueCount(int count) {
    return '転送キュー ($count)';
  }

  @override
  String get noTransfersInProgress => '現在進行中の転送はありません';

  @override
  String get transfersEmptySubtitle => '送受信されたすべてのファイルがここに表示されます';

  @override
  String get cancelled => 'キャンセル済み';

  @override
  String get appLockedTitle => 'アプリがロックされています';

  @override
  String get unlockWithBiometrics => '生体認証でロック解除';

  @override
  String get pinMustBe6Digits => 'PINコードは6桁である必要があります';

  @override
  String get pinIncorrect => 'PINコードが違います。再試行してください。';

  @override
  String get pinsDoNotMatch => 'PINコードが一致しません。再試行してください。';

  @override
  String get pinStepOld => '現在のPINコードを入力してください。';

  @override
  String get pinStepNew => '新しい6桁のセキュリティPINを入力してください。';

  @override
  String get pinStepConfirm => '確認のためもう一度入力してください。';

  @override
  String get pinStepVerify => '操作を承認するためPINコードを入力してください。';

  @override
  String get pinTitleSetup => 'セキュリティPINの設定';

  @override
  String get pinTitleChange => 'セキュリティPINの変更';

  @override
  String get pinTitleVerify => 'セキュリティ認証';

  @override
  String get pinContinue => '次へ';

  @override
  String get errorDetails => 'エラー詳細';

  @override
  String get errorDetailsCopied => 'エラー詳細をクリップボードにコピーしました';

  @override
  String get collapse => '折りたたむ';

  @override
  String get expand => '展開する';

  @override
  String get copyError => 'エラーをコピー';

  @override
  String get errorNetwork => '接続が切断されているか不安定です。インターネット接続を確認してください。';

  @override
  String get errorDiskSpace => '空き容量が不足しているかディスクがいっぱいです。空きを増やしてください。';

  @override
  String get errorAuthExpired => 'セッションまたはトークンの有効期限が切れました。再度接続してください。';

  @override
  String get errorNotFound => 'クラウド上でファイルまたはフォルダーが見つかりません。';

  @override
  String get errorPermissionDenied => 'このクラウド操作を実行する権限がありません。';

  @override
  String get errorGeneric => '操作中にエラーが発生しました。';
}
