import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Iconic symbolic icon set inspired by System76 COSMIC desktop environment (libcosmic).
/// Provides consistent outline, rounded, and symbolic icons across all platforms.
abstract final class CosmicIcons {
  static const String _base = 'assets/icons/cosmic/';

  // Shell & Navigation SVGs
  static const String homeSvg = '${_base}user-home-symbolic.svg';
  static const String explorerSvg = '${_base}folder-symbolic.svg';
  static const String folderSvg = '${_base}folder-symbolic.svg';
  static const String folderOpenSvg = '${_base}folder-open-symbolic.svg';
  static const String folderNewSvg = '${_base}folder-new-symbolic.svg';
  static const String folderZipSvg = '${_base}package-x-generic-symbolic.svg';
  static const String syncSvg = '${_base}emblem-synchronizing-symbolic.svg';
  static const String settingsSvg = '${_base}preferences-system-symbolic.svg';
  static const String cloudSvg = '${_base}folder-remote-symbolic.svg';
  static const String cloudSyncSvg = '${_base}emblem-synchronizing-symbolic.svg';
  static const String desktopSvg = '${_base}user-desktop-symbolic.svg';

  // File Types & Mimetypes SVGs
  static const String documentSvg = '${_base}x-office-document-symbolic.svg';
  static const String imageSvg = '${_base}image-x-generic-symbolic.svg';
  static const String videoSvg = '${_base}video-x-generic-symbolic.svg';
  static const String audioSvg = '${_base}audio-x-generic-symbolic.svg';
  static const String archiveSvg = '${_base}package-x-generic-symbolic.svg';
  static const String codeSvg = '${_base}text-html-symbolic.svg';
  static const String fileSvg = '${_base}text-x-generic-symbolic.svg';
  static const String spreadsheetSvg = '${_base}x-office-spreadsheet-symbolic.svg';
  static const String presentationSvg = '${_base}x-office-presentation-symbolic.svg';

  // Actions & Operations SVGs
  static const String searchSvg = '${_base}system-search-symbolic.svg';
  static const String refreshSvg = '${_base}view-refresh-symbolic.svg';
  static const String addSvg = '${_base}list-add-symbolic.svg';
  static const String removeSvg = '${_base}list-remove-symbolic.svg';
  static const String closeSvg = '${_base}window-close-symbolic.svg';
  static const String checkSvg = '${_base}object-select-symbolic.svg';
  static const String checkboxCheckedSvg = '${_base}checkbox-checked-symbolic.svg';
  static const String editSvg = '${_base}accessories-text-editor-symbolic.svg';
  static const String deleteSvg = '${_base}edit-delete-symbolic.svg';
  static const String trashSvg = '${_base}user-trash-symbolic.svg';
  static const String copySvg = '${_base}edit-copy-symbolic.svg';
  static const String cutSvg = '${_base}edit-cut-symbolic.svg';
  static const String downloadSvg = '${_base}folder-download-symbolic.svg';
  static const String uploadSvg = '${_base}go-up-symbolic.svg';
  static const String moreVertSvg = '${_base}view-more-symbolic.svg';
  static const String moreHorizSvg = '${_base}view-more-horizontal-symbolic.svg';
  static const String chevronRightSvg = '${_base}go-next-symbolic.svg';
  static const String chevronLeftSvg = '${_base}go-previous-symbolic.svg';
  static const String openWithSvg = '${_base}window-pop-out-symbolic.svg';
  static const String sortSvg = '${_base}view-sort-ascending-symbolic.svg';
  static const String sortDescSvg = '${_base}view-sort-descending-symbolic.svg';
  static const String viewListSvg = '${_base}playlist-symbolic.svg';
  static const String viewGridSvg = '${_base}window-stack-symbolic.svg';
  static const String splitScreenSvg = '${_base}window-swap-symbolic.svg';
  static const String shareSvg = '${_base}insert-link-symbolic.svg';
  static const String linkSvg = '${_base}insert-link-symbolic.svg';
  static const String infoSvg = '${_base}dialog-information-symbolic.svg';
  static const String warningSvg = '${_base}dialog-warning-symbolic.svg';
  static const String errorSvg = '${_base}dialog-error-symbolic.svg';

  // Hardware, Security & Cloud SVGs
  static const String terminalSvg = '${_base}utilities-terminal-symbolic.svg';
  static const String lockSvg = '${_base}system-lock-screen-symbolic.svg';
  static const String passwordSvg = '${_base}dialog-password-symbolic.svg';
  static const String shieldSvg = '${_base}security-high-symbolic.svg';
  static const String diskUsageSvg = '${_base}disk-usage-analyzer-symbolic.svg';
  static const String disksSvg = '${_base}disks-symbolic.svg';
  static const String serverSvg = '${_base}network-server-symbolic.svg';
  static const String laptopSvg = '${_base}laptop-symbolic.svg';
  static const String paletteSvg = '${_base}preferences-desktop-wallpaper-symbolic.svg';
  static const String languageSvg = '${_base}preferences-desktop-locale-symbolic.svg';
  static const String weatherCloudsSvg = '${_base}weather-few-clouds-symbolic.svg';
  static const String rocketSvg = '${_base}system-run-symbolic.svg';
  static const String checkCircleSvg = '${_base}emblem-ok-symbolic.svg';
  static const String heartSvg = '${_base}emblem-favorite-symbolic.svg';
  static const String favoriteSvg = '${_base}emblem-favorite-symbolic.svg';
  static const String playSvg = '${_base}media-playback-start-symbolic.svg';
  static const String pauseSvg = '${_base}media-playback-pause-symbolic.svg';
  static const String stopSvg = '${_base}process-stop-symbolic.svg';
  static const String clockSvg = '${_base}accessories-clock-symbolic.svg';
  static const String timeSvg = '${_base}accessories-clock-symbolic.svg';
  static const String lightModeSvg = '${_base}weather-clear-symbolic.svg';
  static const String darkModeSvg = '${_base}weather-clear-night-symbolic.svg';
  static const String powerSvg = '${_base}preferences-power-and-battery-symbolic.svg';
  static const String cardSvg = '${_base}payment-card-symbolic.svg';
  static const String browserSvg = '${_base}web-browser-symbolic.svg';
  static const String clearSvg = '${_base}edit-clear-symbolic.svg';
  static const String pasteSvg = '${_base}edit-paste-symbolic.svg';
  static const String selectAllSvg = '${_base}edit-select-all-symbolic.svg';
  static const String undoSvg = '${_base}edit-undo-symbolic.svg';
  static const String panDownSvg = '${_base}pan-down-symbolic.svg';
  static const String panUpSvg = '${_base}pan-up-symbolic.svg';
  static const String expandMoreSvg = '${_base}pan-down-symbolic.svg';
  static const String expandLessSvg = '${_base}pan-up-symbolic.svg';
  static const String visibilityOffSvg = '${_base}image-red-eye-symbolic.svg';
  static const String visibilitySvg = '${_base}weather-clear-symbolic.svg';
  static const String bugReportSvg = '${_base}dialog-warning-symbolic.svg';
  static const String openMenuSvg = '${_base}open-menu-symbolic.svg';
  static const String unlockSvg = '${_base}changes-allow-symbolic.svg';
  static const String calendarSvg = '${_base}office-calendar-symbolic.svg';
  static const String bookmarkSvg = '${_base}user-bookmarks-symbolic.svg';
  static const String userSvg = '${_base}user-info-symbolic.svg';
  static const String networkTransferSvg = '${_base}network-transmit-receive-symbolic.svg';

  // Navigation & Shell Places
  static const IconData home = Icons.home_outlined;
  static const IconData homeFilled = Icons.home_rounded;
  static const IconData explorer = Icons.folder_outlined;
  static const IconData explorerFilled = Icons.folder_rounded;
  static const IconData sync = Icons.sync_outlined;
  static const IconData syncFilled = Icons.sync_rounded;
  static const IconData settings = Icons.tune_rounded;
  static const IconData settingsFilled = Icons.settings_rounded;
  static const IconData cloudSync = Icons.cloud_sync_outlined;
  static const IconData cloud = Icons.cloud_outlined;
  static const IconData desktop = Icons.desktop_windows_outlined;

  // File Types & Mimetypes (Freedesktop & COSMIC files specs)
  static const IconData folder = Icons.folder_rounded;
  static const IconData folderOpen = Icons.folder_open_rounded;
  static const IconData folderZip = Icons.folder_zip_outlined;
  static const IconData file = Icons.insert_drive_file_outlined;
  static const IconData image = Icons.image_outlined;
  static const IconData video = Icons.movie_outlined;
  static const IconData audio = Icons.audiotrack_outlined;
  static const IconData pdf = Icons.picture_as_pdf_outlined;
  static const IconData document = Icons.article_outlined;
  static const IconData spreadsheet = Icons.table_chart_outlined;
  static const IconData presentation = Icons.slideshow_outlined;
  static const IconData code = Icons.code_outlined;

  // File Actions & Operations
  static const IconData select = Icons.check_circle_outline;
  static const IconData openWith = Icons.open_in_new_rounded;
  static const IconData download = Icons.download_outlined;
  static const IconData downloadFilled = Icons.download_rounded;
  static const IconData upload = Icons.upload_outlined;
  static const IconData uploadFilled = Icons.upload_rounded;
  static const IconData share = Icons.share_outlined;
  static const IconData copy = Icons.copy_rounded;
  static const IconData contentCopy = Icons.content_copy_outlined;
  static const IconData cut = Icons.cut_rounded;
  static const IconData move = Icons.drive_file_move_outlined;
  static const IconData moveToOpposite = Icons.drive_file_move_rtl_outlined;
  static const IconData rename = Icons.edit_outlined;
  static const IconData edit = Icons.edit_outlined;
  static const IconData info = Icons.info_outline;
  static const IconData delete = Icons.delete_outline_rounded;
  static const IconData deleteForever = Icons.delete_forever_rounded;
  static const IconData search = Icons.search_rounded;
  static const IconData refresh = Icons.refresh_rounded;
  static const IconData add = Icons.add_rounded;
  static const IconData addCircle = Icons.add_circle_outline_rounded;
  static const IconData close = Icons.close_rounded;
  static const IconData check = Icons.check_rounded;
  static const IconData checkCircle = Icons.check_circle_outline;
  static const IconData chevronRight = Icons.chevron_right_rounded;
  static const IconData chevronLeft = Icons.chevron_left_rounded;
  static const IconData moreVert = Icons.more_vert_rounded;

  // Security & Hardware
  static const IconData lock = Icons.lock_outline_rounded;
  static const IconData lockOpen = Icons.lock_open_rounded;
  static const IconData shield = Icons.shield_outlined;
  static const IconData fingerprint = Icons.fingerprint_rounded;
  static const IconData terminal = Icons.terminal_outlined;
  static const IconData storage = Icons.storage_outlined;
  static const IconData pieChart = Icons.pie_chart_outline;
  static const IconData networkServer = Icons.dns_outlined;
  static const IconData deviceLaptop = Icons.laptop_outlined;

  // Cloud Providers (Freedesktop & Provider Symbolic mapping)
  static const IconData cloudDrive = Icons.add_to_drive;
  static const IconData cloudDropbox = Icons.inventory_2_outlined;
  static const IconData cloudOneDrive = Icons.cloud_circle_outlined;

  // Appearance & Themes
  static const IconData palette = Icons.palette_outlined;
  static const IconData language = Icons.language_outlined;
  static const IconData brightnessAuto = Icons.brightness_auto_outlined;
  static const IconData lightMode = Icons.light_mode_outlined;
  static const IconData darkMode = Icons.dark_mode_outlined;
  static const IconData rocket = Icons.rocket_launch_outlined;
  static const IconData autoAwesome = Icons.auto_awesome;
  static const IconData viewGrid = Icons.grid_view_rounded;
  static const IconData viewList = Icons.view_list_rounded;
  static const IconData sort = Icons.sort_rounded;

  /// Returns the standard Material [IconData] equivalent for a COSMIC SVG [asset].
  static IconData getMaterialIcon(String asset) {
    return _svgToMaterial[asset] ?? Icons.insert_drive_file_outlined;
  }

  static final Map<String, IconData> _svgToMaterial = {
    homeSvg: Icons.home_outlined,
    explorerSvg: Icons.folder_outlined,
    folderOpenSvg: Icons.folder_open_rounded,
    folderNewSvg: Icons.create_new_folder_outlined,
    folderZipSvg: Icons.folder_zip_outlined,
    syncSvg: Icons.sync_rounded,
    settingsSvg: Icons.tune_rounded,
    cloudSvg: Icons.cloud_outlined,
    desktopSvg: Icons.desktop_windows_outlined,
    documentSvg: Icons.article_outlined,
    imageSvg: Icons.image_outlined,
    videoSvg: Icons.movie_outlined,
    audioSvg: Icons.audiotrack_outlined,
    codeSvg: Icons.code_outlined,
    fileSvg: Icons.insert_drive_file_outlined,
    spreadsheetSvg: Icons.table_chart_outlined,
    presentationSvg: Icons.slideshow_outlined,
    searchSvg: Icons.search_rounded,
    refreshSvg: Icons.refresh_rounded,
    addSvg: Icons.add_rounded,
    removeSvg: Icons.remove_rounded,
    closeSvg: Icons.close_rounded,
    checkSvg: Icons.check_rounded,
    checkboxCheckedSvg: Icons.check_box_rounded,
    editSvg: Icons.edit_outlined,
    deleteSvg: Icons.delete_outline_rounded,
    trashSvg: Icons.delete_outline_rounded,
    copySvg: Icons.copy_rounded,
    cutSvg: Icons.cut_rounded,
    downloadSvg: Icons.download_outlined,
    uploadSvg: Icons.upload_file_outlined,
    moreVertSvg: Icons.more_vert_rounded,
    moreHorizSvg: Icons.more_horiz_rounded,
    chevronRightSvg: Icons.chevron_right_rounded,
    chevronLeftSvg: Icons.chevron_left_rounded,
    openWithSvg: Icons.open_in_new_rounded,
    sortSvg: Icons.sort_rounded,
    sortDescSvg: Icons.sort_rounded,
    viewListSvg: Icons.view_list_rounded,
    viewGridSvg: Icons.grid_view_rounded,
    splitScreenSvg: Icons.splitscreen_rounded,
    shareSvg: Icons.share_outlined,
    infoSvg: Icons.info_outline_rounded,
    warningSvg: Icons.warning_amber_rounded,
    errorSvg: Icons.error_outline_rounded,
    terminalSvg: Icons.terminal_outlined,
    lockSvg: Icons.lock_outline_rounded,
    unlockSvg: Icons.lock_open_rounded,
    passwordSvg: Icons.vpn_key_outlined,
    shieldSvg: Icons.shield_outlined,
    diskUsageSvg: Icons.pie_chart_outline_rounded,
    disksSvg: Icons.storage_outlined,
    serverSvg: Icons.dns_outlined,
    laptopSvg: Icons.laptop_outlined,
    paletteSvg: Icons.palette_outlined,
    languageSvg: Icons.language_outlined,
    weatherCloudsSvg: Icons.cloud_outlined,
    rocketSvg: Icons.rocket_launch_outlined,
    checkCircleSvg: Icons.check_circle_outline_rounded,
    heartSvg: Icons.favorite_rounded,
    playSvg: Icons.play_arrow_rounded,
    pauseSvg: Icons.pause_rounded,
    stopSvg: Icons.stop_rounded,
    clockSvg: Icons.schedule_rounded,
    lightModeSvg: Icons.light_mode_outlined,
    darkModeSvg: Icons.dark_mode_outlined,
    powerSvg: Icons.power_settings_new_rounded,
    cardSvg: Icons.credit_card_rounded,
    browserSvg: Icons.open_in_browser_rounded,
    clearSvg: Icons.clear_all_rounded,
    pasteSvg: Icons.content_paste_rounded,
    selectAllSvg: Icons.select_all_rounded,
    undoSvg: Icons.undo_rounded,
    panDownSvg: Icons.keyboard_arrow_down_rounded,
    panUpSvg: Icons.keyboard_arrow_up_rounded,
    visibilityOffSvg: Icons.visibility_off_rounded,
    openMenuSvg: Icons.menu_rounded,
    calendarSvg: Icons.calendar_today_rounded,
    bookmarkSvg: Icons.bookmark_border_rounded,
    userSvg: Icons.person_outline_rounded,
    networkTransferSvg: Icons.swap_vert_rounded,
  };
}

/// Theme extension that controls whether icons are displayed as official COSMIC SVG icons
/// or classic Material icons across the application according to the selected theme style.
@immutable
class AppIconTheme extends ThemeExtension<AppIconTheme> {
  final bool isCosmic;

  const AppIconTheme({this.isCosmic = true});

  @override
  AppIconTheme copyWith({bool? isCosmic}) {
    return AppIconTheme(isCosmic: isCosmic ?? this.isCosmic);
  }

  @override
  AppIconTheme lerp(ThemeExtension<AppIconTheme>? other, double t) {
    if (other is! AppIconTheme) return this;
    return t < 0.5 ? this : other;
  }
}

/// An adaptive icon widget that renders either an official COSMIC symbolic SVG icon
/// or a standard Material icon, dynamically matching the active theme style.
class CosmicSvgIcon extends StatelessWidget {
  final String asset;
  final double? size;
  final Color? color;
  final String? semanticsLabel;
  final IconData? fallbackMaterialIcon;

  const CosmicSvgIcon(
    this.asset, {
    super.key,
    this.size,
    this.color,
    this.semanticsLabel,
    this.fallbackMaterialIcon,
  });

  @override
  Widget build(BuildContext context) {
    final iconTheme = IconTheme.of(context);
    final effectiveSize = size ?? iconTheme.size ?? 22.0;
    final effectiveColor =
        color ?? iconTheme.color ?? Theme.of(context).colorScheme.onSurface;

    final appIconTheme = Theme.of(context).extension<AppIconTheme>();
    final isCosmic = appIconTheme?.isCosmic ?? false;

    if (!isCosmic) {
      final materialIcon = fallbackMaterialIcon ?? CosmicIcons.getMaterialIcon(asset);
      return Icon(
        materialIcon,
        size: effectiveSize,
        color: effectiveColor,
        semanticLabel: semanticsLabel,
      );
    }

    return SvgPicture.asset(
      asset,
      width: effectiveSize,
      height: effectiveSize,
      colorFilter: ColorFilter.mode(effectiveColor, BlendMode.srcIn),
      semanticsLabel: semanticsLabel,
    );
  }
}
