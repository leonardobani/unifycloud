import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/cloud_models.dart';
import '../models/search_models.dart';
import '../services/rclone_service.dart';
import 'settings_provider.dart';

/// Preset file categories for quick global search filtering.
enum SearchFileTypePreset {
  all,
  documents,
  images,
  videos,
  audio,
  archives,
  custom;

  List<String> get extensions {
    switch (this) {
      case SearchFileTypePreset.all:
      case SearchFileTypePreset.custom:
        return const [];
      case SearchFileTypePreset.documents:
        return const [
          '.pdf',
          '.doc',
          '.docx',
          '.txt',
          '.md',
          '.rtf',
          '.odt',
          '.xls',
          '.xlsx',
          '.csv',
          '.ppt',
          '.pptx',
        ];
      case SearchFileTypePreset.images:
        return const [
          '.jpg',
          '.jpeg',
          '.png',
          '.gif',
          '.webp',
          '.svg',
          '.bmp',
          '.heic',
          '.tiff',
        ];
      case SearchFileTypePreset.videos:
        return const [
          '.mp4',
          '.mkv',
          '.avi',
          '.mov',
          '.webm',
          '.wmv',
          '.flv',
          '.m4v',
        ];
      case SearchFileTypePreset.audio:
        return const [
          '.mp3',
          '.flac',
          '.wav',
          '.aac',
          '.ogg',
          '.m4a',
          '.opus',
        ];
      case SearchFileTypePreset.archives:
        return const [
          '.zip',
          '.rar',
          '.7z',
          '.tar',
          '.gz',
          '.bz2',
          '.xz',
        ];
    }
  }
}

/// Preset file size ranges for global search filtering.
enum SearchSizePreset {
  any,
  under1Mb,
  from1To100Mb,
  over100Mb,
  over1Gb;

  int get minBytes {
    switch (this) {
      case SearchSizePreset.any:
      case SearchSizePreset.under1Mb:
        return -1;
      case SearchSizePreset.from1To100Mb:
        return 1024 * 1024;
      case SearchSizePreset.over100Mb:
        return 100 * 1024 * 1024;
      case SearchSizePreset.over1Gb:
        return 1024 * 1024 * 1024;
    }
  }

  int get maxBytes {
    switch (this) {
      case SearchSizePreset.any:
      case SearchSizePreset.over100Mb:
      case SearchSizePreset.over1Gb:
        return -1;
      case SearchSizePreset.under1Mb:
        return 1024 * 1024;
      case SearchSizePreset.from1To100Mb:
        return 100 * 1024 * 1024;
    }
  }
}

/// State of the global cross-cloud search.
class GlobalSearchState {
  const GlobalSearchState({
    this.query = '',
    this.selectedRemote,
    this.basePath = '',
    this.fileTypePreset = SearchFileTypePreset.all,
    this.customExtensions = const [],
    this.sizePreset = SearchSizePreset.any,
    this.maxDepth = 0,
    this.includeDirs = true,
    this.showHiddenFiles = false,
    this.activeJobId,
    this.status,
    this.isStarting = false,
    this.scannedFiles = 0,
    this.scannedDirs = 0,
    this.currentRemote = '',
    this.truncated = false,
    this.results = const [],
    this.warnings = const [],
    this.error,
    this.pendingGlobalSearchOpen = false,
  });

  final String query;
  final String? selectedRemote; // null = all configured remotes
  final String basePath;
  final SearchFileTypePreset fileTypePreset;
  final List<String> customExtensions;
  final SearchSizePreset sizePreset;
  final int maxDepth; // <= 0 means unlimited
  final bool includeDirs;
  final bool showHiddenFiles;

  final String? activeJobId;
  final SearchStatus? status;
  final bool isStarting;
  final int scannedFiles;
  final int scannedDirs;
  final String currentRemote;
  final bool truncated;
  final List<CloudItem> results;
  final List<String> warnings;
  final String? error;

  /// Set when HomeScreen triggers Global Search so Explorer opens in Global Search mode.
  final bool pendingGlobalSearchOpen;

  bool get isSearching => isStarting || status == SearchStatus.running;

  bool get hasActiveFilters =>
      selectedRemote != null ||
      fileTypePreset != SearchFileTypePreset.all ||
      sizePreset != SearchSizePreset.any ||
      maxDepth > 0 ||
      !includeDirs;

  List<String> get effectiveExtensions {
    if (fileTypePreset == SearchFileTypePreset.custom) {
      return customExtensions;
    }
    return fileTypePreset.extensions;
  }

  List<CloudItem> get visibleResults {
    if (showHiddenFiles) return results;
    return results.where((item) => !item.name.startsWith('.')).toList();
  }

  GlobalSearchState copyWith({
    String? query,
    String? Function()? selectedRemote,
    String? basePath,
    SearchFileTypePreset? fileTypePreset,
    List<String>? customExtensions,
    SearchSizePreset? sizePreset,
    int? maxDepth,
    bool? includeDirs,
    bool? showHiddenFiles,
    String? Function()? activeJobId,
    SearchStatus? Function()? status,
    bool? isStarting,
    int? scannedFiles,
    int? scannedDirs,
    String? currentRemote,
    bool? truncated,
    List<CloudItem>? results,
    List<String>? warnings,
    String? Function()? error,
    bool? pendingGlobalSearchOpen,
  }) {
    return GlobalSearchState(
      query: query ?? this.query,
      selectedRemote:
          selectedRemote != null ? selectedRemote() : this.selectedRemote,
      basePath: basePath ?? this.basePath,
      fileTypePreset: fileTypePreset ?? this.fileTypePreset,
      customExtensions: customExtensions ?? this.customExtensions,
      sizePreset: sizePreset ?? this.sizePreset,
      maxDepth: maxDepth ?? this.maxDepth,
      includeDirs: includeDirs ?? this.includeDirs,
      showHiddenFiles: showHiddenFiles ?? this.showHiddenFiles,
      activeJobId: activeJobId != null ? activeJobId() : this.activeJobId,
      status: status != null ? status() : this.status,
      isStarting: isStarting ?? this.isStarting,
      scannedFiles: scannedFiles ?? this.scannedFiles,
      scannedDirs: scannedDirs ?? this.scannedDirs,
      currentRemote: currentRemote ?? this.currentRemote,
      truncated: truncated ?? this.truncated,
      results: results ?? this.results,
      warnings: warnings ?? this.warnings,
      error: error != null ? error() : this.error,
      pendingGlobalSearchOpen:
          pendingGlobalSearchOpen ?? this.pendingGlobalSearchOpen,
    );
  }
}

/// Riverpod 3 Notifier managing global cross-cloud search lifecycle and ~400ms status polling.
class SearchNotifier extends Notifier<GlobalSearchState> {
  static const Duration pollInterval = Duration(milliseconds: 400);

  Timer? _pollingTimer;
  String? _activeJobId;
  bool _isRunning = false;
  bool _isPollingInFlight = false;
  int _searchGeneration = 0;

  RcloneService get _rclone => ref.read(rcloneServiceProvider);

  @override
  GlobalSearchState build() {
    final rclone = ref.read(rcloneServiceProvider);
    ref.listen<bool>(
      settingsProvider.select((s) => s.showHiddenFiles),
      (previous, next) {
        state = state.copyWith(showHiddenFiles: next);
      },
    );

    ref.onDispose(() {
      _pollingTimer?.cancel();
      _pollingTimer = null;
      final jobId = _activeJobId;
      if (jobId != null) {
        if (_isRunning) {
          unawaited(rclone.cancelSearch(jobId).catchError((_) => false));
        }
        unawaited(rclone.clearSearch(jobId).catchError((_) {}));
      }
      _activeJobId = null;
      _isRunning = false;
    });

    final initialHidden = ref.read(settingsProvider).showHiddenFiles;
    return GlobalSearchState(showHiddenFiles: initialHidden);
  }

  /// Signals the File Explorer to switch directly into Global Search mode.
  void requestOpenGlobalSearch({String? remote}) {
    state = state.copyWith(
      selectedRemote: remote != null ? () => remote : null,
      pendingGlobalSearchOpen: true,
    );
  }

  /// Marks a pending Home-to-Explorer global search navigation request as handled.
  void consumeOpenRequest() {
    if (!state.pendingGlobalSearchOpen) return;
    state = state.copyWith(pendingGlobalSearchOpen: false);
  }

  void setQuery(String query) {
    state = state.copyWith(query: query);
  }

  void setSelectedRemote(String? remote, {String basePath = ''}) {
    state = state.copyWith(
      selectedRemote: () => remote,
      basePath: remote == null ? '' : basePath,
    );
  }

  void setFileTypePreset(
    SearchFileTypePreset preset, {
    List<String>? customExtensions,
  }) {
    state = state.copyWith(
      fileTypePreset: preset,
      customExtensions: customExtensions ?? state.customExtensions,
    );
  }

  void setSizePreset(SearchSizePreset preset) {
    state = state.copyWith(sizePreset: preset);
  }

  void setMaxDepth(int maxDepth) {
    state = state.copyWith(maxDepth: maxDepth);
  }

  void setIncludeDirs(bool includeDirs) {
    state = state.copyWith(includeDirs: includeDirs);
  }

  /// Starts a new cross-cloud search, cancelling and clearing any prior job.
  Future<void> startSearch({String? queryOverride}) async {
    final generation = ++_searchGeneration;
    _pollingTimer?.cancel();
    _pollingTimer = null;

    if (queryOverride != null) {
      state = state.copyWith(query: queryOverride);
    }

    final previousJobId = _activeJobId;
    final previousRunning = _isRunning;
    _activeJobId = null;
    _isRunning = false;

    if (previousJobId != null) {
      if (previousRunning) {
        try {
          await _rclone.cancelSearch(previousJobId);
        } catch (_) {}
      }
      try {
        await _rclone.clearSearch(previousJobId);
      } catch (_) {}
    }

    if (generation != _searchGeneration) return;

    final current = state;
    final trimmedQuery = current.query.trim();
    final extensions = current.effectiveExtensions;
    final hasSizeFilter = current.sizePreset != SearchSizePreset.any;
    final effectiveIncludeDirs =
        current.includeDirs && extensions.isEmpty && !hasSizeFilter;

    if (trimmedQuery.isEmpty &&
        extensions.isEmpty &&
        !hasSizeFilter &&
        current.maxDepth <= 0) {
      state = state.copyWith(
        isStarting: false,
        activeJobId: () => null,
        status: () => null,
        results: const [],
        warnings: const [],
        error: () => null,
      );
      return;
    }

    state = state.copyWith(
      isStarting: true,
      activeJobId: () => null,
      status: () => SearchStatus.running,
      scannedFiles: 0,
      scannedDirs: 0,
      currentRemote: '',
      truncated: false,
      results: const [],
      warnings: const [],
      error: () => null,
    );

    final request = SearchRequest(
      remotes: current.selectedRemote != null ? [current.selectedRemote!] : const [],
      basePath: current.selectedRemote != null ? current.basePath : '',
      query: trimmedQuery,
      extensions: extensions,
      minSize: current.sizePreset.minBytes,
      maxSize: current.sizePreset.maxBytes,
      maxDepth: current.maxDepth,
      includeDirs: effectiveIncludeDirs,
    );

    try {
      final initial = await _rclone.startSearch(request);
      if (generation != _searchGeneration) {
        unawaited(_rclone.cancelSearch(initial.jobId).catchError((_) => false));
        unawaited(_rclone.clearSearch(initial.jobId).catchError((_) {}));
        return;
      }

      _activeJobId = initial.jobId;
      _isRunning = initial.status.isActive;

      state = state.copyWith(
        isStarting: false,
        activeJobId: () => initial.jobId,
        status: () => initial.status,
      );

      // Fetch an immediate snapshot and start periodic polling while running.
      await _pollStatus(generation);
      if (generation == _searchGeneration && _isRunning) {
        _pollingTimer = Timer.periodic(pollInterval, (_) {
          unawaited(_pollStatus(generation));
        });
      }
    } catch (e) {
      if (generation != _searchGeneration) return;
      _isRunning = false;
      state = state.copyWith(
        isStarting: false,
        status: () => SearchStatus.failed,
        error: e.toString,
      );
    }
  }

  Future<void> _pollStatus(int generation) async {
    final jobId = _activeJobId;
    if (jobId == null || _isPollingInFlight || generation != _searchGeneration) {
      return;
    }
    _isPollingInFlight = true;
    try {
      final snapshot = await _rclone.getSearchStatus(jobId);
      if (generation != _searchGeneration) return;

      _isRunning = snapshot.status.isActive;
      state = state.copyWith(
        activeJobId: () => snapshot.jobId,
        status: () => snapshot.status,
        scannedFiles: snapshot.scannedFiles,
        scannedDirs: snapshot.scannedDirs,
        currentRemote: snapshot.currentRemote,
        truncated: snapshot.truncated,
        results: snapshot.results,
        warnings: snapshot.warnings,
        error: () => snapshot.error,
      );

      if (snapshot.status.isTerminal) {
        _pollingTimer?.cancel();
        _pollingTimer = null;
      }
    } catch (e) {
      if (generation != _searchGeneration) return;
      _pollingTimer?.cancel();
      _pollingTimer = null;
      _isRunning = false;
      state = state.copyWith(
        status: () => SearchStatus.failed,
        error: e.toString,
      );
    } finally {
      _isPollingInFlight = false;
    }
  }

  /// Stops an active search job without discarding results found so far.
  Future<void> stopSearch() async {
    _pollingTimer?.cancel();
    _pollingTimer = null;
    final jobId = _activeJobId;
    final generation = _searchGeneration;

    if (jobId == null) {
      _isRunning = false;
      state = state.copyWith(isStarting: false);
      return;
    }

    _isRunning = false;
    try {
      await _rclone.cancelSearch(jobId);
      final snapshot = await _rclone.getSearchStatus(jobId);
      if (generation != _searchGeneration) return;
      state = state.copyWith(
        isStarting: false,
        status: () => snapshot.status,
        scannedFiles: snapshot.scannedFiles,
        scannedDirs: snapshot.scannedDirs,
        currentRemote: '',
        truncated: snapshot.truncated,
        results: snapshot.results,
        warnings: snapshot.warnings,
        error: () => snapshot.error,
      );
    } catch (_) {
      if (generation != _searchGeneration) return;
      state = state.copyWith(
        isStarting: false,
        status: () => SearchStatus.cancelled,
        currentRemote: '',
      );
    }
  }

  /// Cancels any active search, clears the Go job from memory, and resets results.
  Future<void> clearSearch({bool clearQuery = true}) async {
    _searchGeneration++;
    _pollingTimer?.cancel();
    _pollingTimer = null;

    final jobId = _activeJobId;
    final wasRunning = _isRunning;
    _activeJobId = null;
    _isRunning = false;

    state = state.copyWith(
      query: clearQuery ? '' : null,
      isStarting: false,
      activeJobId: () => null,
      status: () => null,
      scannedFiles: 0,
      scannedDirs: 0,
      currentRemote: '',
      truncated: false,
      results: const [],
      warnings: const [],
      error: () => null,
    );

    if (jobId != null) {
      if (wasRunning) {
        try {
          await _rclone.cancelSearch(jobId);
        } catch (_) {}
      }
      try {
        await _rclone.clearSearch(jobId);
      } catch (_) {}
    }
  }

  /// Removes a deleted item from the current in-memory search results list.
  void removeResult(CloudItem item) {
    state = state.copyWith(
      results: state.results
          .where((r) => !(r.remote == item.remote && r.path == item.path))
          .toList(),
    );
  }
}

final searchProvider =
    NotifierProvider<SearchNotifier, GlobalSearchState>(SearchNotifier.new);
