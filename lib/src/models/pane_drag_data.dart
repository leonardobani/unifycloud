import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/file_explorer_provider.dart';
import 'cloud_models.dart';

/// Data payload transferred during drag-and-drop operations between explorer panes.
class PaneDragData {
  /// The cloud remote where the dragged items originate.
  final String sourceRemote;

  /// The folder path where the dragged items originate.
  final String sourcePath;

  /// The list of items being dragged.
  final List<CloudItem> items;

  /// Whether this drag operation should move rather than copy files.
  final bool isMove;

  /// The provider instance of the source pane.
  final NotifierProvider<FileExplorerNotifier, FileExplorerState> sourceProvider;

  const PaneDragData({
    required this.sourceRemote,
    required this.sourcePath,
    required this.items,
    required this.sourceProvider,
    this.isMove = false,
  });

  /// Total count of items in this drag payload.
  int get count => items.length;

  /// Primary item name for tooltip / drag feedback.
  String get primaryName => items.isNotEmpty ? items.first.name : '';
}

