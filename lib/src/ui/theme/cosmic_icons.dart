import 'package:flutter/material.dart';

/// Iconic symbolic icon set inspired by System76 COSMIC desktop environment (libcosmic).
/// Provides consistent outline, rounded, and symbolic icons across all platforms.
abstract final class CosmicIcons {
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
}
