import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../models/cloud_models.dart';
import '../services/rclone_service.dart';

/// Presentation mode for directory items.
enum FileViewMode { list, grid }

/// Sorting options for directory items.
enum FileSortMode {
  nameAsc,
  nameDesc,
  sizeAsc,
  sizeDesc,
  dateAsc,
  dateDesc,
}

/// A segment in the breadcrumbs navigation trail.
class BreadcrumbItem {
  final String label;
  final String path;
  final bool isRoot;

  const BreadcrumbItem({
    required this.label,
    required this.path,
    this.isRoot = false,
  });
}

/// State of the active file explorer.
class FileExplorerState {
  final String? currentRemote;
  final String currentPath;
  final List<CloudItem> items;
  final bool isLoading;
  final String? error;
  final FileViewMode viewMode;
  final FileSortMode sortMode;
  final String searchQuery;

  const FileExplorerState({
    this.currentRemote,
    this.currentPath = '',
    this.items = const [],
    this.isLoading = false,
    this.error,
    this.viewMode = FileViewMode.list,
    this.sortMode = FileSortMode.nameAsc,
    this.searchQuery = '',
  });

  FileExplorerState copyWith({
    String? currentRemote,
    String? currentPath,
    List<CloudItem>? items,
    bool? isLoading,
    String? error,
    FileViewMode? viewMode,
    FileSortMode? sortMode,
    String? searchQuery,
  }) {
    return FileExplorerState(
      currentRemote: currentRemote ?? this.currentRemote,
      currentPath: currentPath ?? this.currentPath,
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      viewMode: viewMode ?? this.viewMode,
      sortMode: sortMode ?? this.sortMode,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  /// Calculates the breadcrumbs trail from the current remote and path.
  List<BreadcrumbItem> get breadcrumbs {
    final list = <BreadcrumbItem>[
      const BreadcrumbItem(label: 'Home', path: '', isRoot: true),
    ];

    if (currentRemote == null || currentRemote!.isEmpty) {
      return list;
    }

    list.add(BreadcrumbItem(label: currentRemote!, path: ''));

    if (currentPath.isNotEmpty) {
      final segments = currentPath
          .split('/')
          .where((s) => s.trim().isNotEmpty)
          .toList();

      String accumulated = '';
      for (final segment in segments) {
        accumulated = accumulated.isEmpty ? segment : '$accumulated/$segment';
        list.add(BreadcrumbItem(label: segment, path: accumulated));
      }
    }

    return list;
  }

  /// Returns items filtered by search query and sorted with directories first.
  List<CloudItem> get displayItems {
    var result = List<CloudItem>.from(items);

    if (searchQuery.trim().isNotEmpty) {
      final query = searchQuery.toLowerCase().trim();
      result = result
          .where((item) => item.name.toLowerCase().contains(query))
          .toList();
    }

    result.sort((a, b) {
      // Always put directories first
      if (a.isDir && !b.isDir) return -1;
      if (!a.isDir && b.isDir) return 1;

      switch (sortMode) {
        case FileSortMode.nameAsc:
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        case FileSortMode.nameDesc:
          return b.name.toLowerCase().compareTo(a.name.toLowerCase());
        case FileSortMode.sizeAsc:
          return a.size.compareTo(b.size);
        case FileSortMode.sizeDesc:
          return b.size.compareTo(a.size);
        case FileSortMode.dateAsc:
          if (a.modTime == null) return 1;
          if (b.modTime == null) return -1;
          return a.modTime!.compareTo(b.modTime!);
        case FileSortMode.dateDesc:
          if (a.modTime == null) return 1;
          if (b.modTime == null) return -1;
          return b.modTime!.compareTo(a.modTime!);
      }
    });

    return result;
  }
}

/// State notifier for [FileExplorerState] in Riverpod 3.
class FileExplorerNotifier extends Notifier<FileExplorerState> {
  RcloneService get _rcloneService => ref.read(rcloneServiceProvider);

  @override
  FileExplorerState build() {
    return const FileExplorerState();
  }

  /// Sets the active remote and loads its root directory.
  Future<void> openRemote(String remote, {String path = ''}) async {
    state = state.copyWith(
      currentRemote: remote,
      currentPath: path,
      items: const [],
      isLoading: true,
      error: null,
      searchQuery: '',
    );
    await refresh();
  }

  /// Navigates to a specific subfolder within the current remote.
  Future<void> navigateTo(String path) async {
    state = state.copyWith(
      currentPath: path,
      items: const [],
      isLoading: true,
      error: null,
      searchQuery: '',
    );
    await refresh();
  }

  /// Navigates up one directory level.
  Future<void> navigateUp() async {
    if (state.currentPath.isEmpty) return;
    final parent = p.dirname(state.currentPath);
    final nextPath = (parent == '.' || parent == '/') ? '' : parent;
    await navigateTo(nextPath);
  }

  /// Reloads items from the remote.
  Future<void> refresh() async {
    final remote = state.currentRemote;
    if (remote == null) return;

    state = state.copyWith(isLoading: true, error: null);
    try {
      final items = await _rcloneService.listDirectory(
        remote: remote,
        path: state.currentPath,
      );
      state = state.copyWith(isLoading: false, items: items);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void setViewMode(FileViewMode mode) {
    state = state.copyWith(viewMode: mode);
  }

  void setSortMode(FileSortMode mode) {
    state = state.copyWith(sortMode: mode);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  /// Creates a directory in the current remote and path.
  Future<void> createDirectory(String name) async {
    final remote = state.currentRemote;
    if (remote == null) return;

    final targetPath = state.currentPath.isEmpty
        ? name
        : '${state.currentPath}/$name';

    state = state.copyWith(isLoading: true);
    try {
      await _rcloneService.makeDir(remote: remote, dirPath: targetPath);
      await refresh();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  /// Deletes a file or directory.
  Future<void> deleteItem(CloudItem item) async {
    final remote = state.currentRemote;
    if (remote == null) return;

    state = state.copyWith(isLoading: true);
    try {
      await _rcloneService.deleteFile(remote: remote, filePath: item.path);
      await refresh();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  /// Renames an item by moving/copying to the new name and deleting the old.
  Future<void> renameItem(CloudItem item, String newName) async {
    final remote = state.currentRemote;
    if (remote == null) return;

    final dir = p.dirname(item.path);
    final targetPath = (dir == '.' || dir == '/') ? newName : '$dir/$newName';

    state = state.copyWith(isLoading: true);
    try {
      await _rcloneService.copyFile(
        srcRemote: remote,
        srcPath: item.path,
        dstRemote: remote,
        dstPath: targetPath,
      );
      await _rcloneService.deleteFile(remote: remote, filePath: item.path);
      await refresh();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  /// Downloads an item to the local downloads directory.
  Future<File> downloadItem(CloudItem item) async {
    final remote = state.currentRemote;
    if (remote == null) {
      throw StateError('No remote selected');
    }

    final downloadsDir = await getDownloadsDirectory() ??
        await getApplicationDocumentsDirectory();
    await downloadsDir.create(recursive: true);

    final localDestination = p.join(downloadsDir.path, item.name);

    await _rcloneService.copyFile(
      srcRemote: remote,
      srcPath: item.path,
      dstRemote: '',
      dstPath: localDestination,
    );

    return File(localDestination);
  }
}

/// Riverpod provider for [FileExplorerNotifier].
final fileExplorerProvider =
    NotifierProvider<FileExplorerNotifier, FileExplorerState>(
  FileExplorerNotifier.new,
);
