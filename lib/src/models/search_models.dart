import 'cloud_models.dart';

/// Lifecycle status of an asynchronous global search job.
enum SearchStatus {
  running,
  completed,
  failed,
  cancelled;

  static SearchStatus fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'completed':
        return SearchStatus.completed;
      case 'failed':
        return SearchStatus.failed;
      case 'cancelled':
        return SearchStatus.cancelled;
      case 'running':
      default:
        return SearchStatus.running;
    }
  }

  bool get isActive => this == SearchStatus.running;
  bool get isTerminal => !isActive;
}

/// Request payload sent to the Go backend `StartSearch` FFI endpoint.
class SearchRequest {
  const SearchRequest({
    this.remotes = const [],
    this.basePath = '',
    this.query = '',
    this.extensions = const [],
    this.minSize = -1,
    this.maxSize = -1,
    this.modifiedAfter,
    this.modifiedBefore,
    this.maxDepth = 0,
    this.includeDirs = true,
    this.maxResults = 500,
  });

  final List<String> remotes;
  final String basePath;
  final String query;
  final List<String> extensions;
  final int minSize;
  final int maxSize;
  final DateTime? modifiedAfter;
  final DateTime? modifiedBefore;
  final int maxDepth;
  final bool includeDirs;
  final int maxResults;

  Map<String, dynamic> toJson() => {
        'remotes': remotes,
        if (basePath.isNotEmpty) 'base_path': basePath,
        'query': query,
        if (extensions.isNotEmpty) 'extensions': extensions,
        'min_size': minSize,
        'max_size': maxSize,
        if (modifiedAfter != null)
          'modified_after': modifiedAfter!.toUtc().toIso8601String(),
        if (modifiedBefore != null)
          'modified_before': modifiedBefore!.toUtc().toIso8601String(),
        'max_depth': maxDepth,
        'include_dirs': includeDirs,
        'max_results': maxResults,
      };
}

/// Snapshot of a running or finished global search job returned by Go.
class SearchJobSnapshot {
  const SearchJobSnapshot({
    required this.jobId,
    required this.status,
    this.scannedFiles = 0,
    this.scannedDirs = 0,
    this.currentRemote = '',
    this.truncated = false,
    this.results = const [],
    this.warnings = const [],
    this.error,
  });

  factory SearchJobSnapshot.fromJson(Map<String, dynamic> json) {
    final rawResults = json['results'] as List<dynamic>? ?? const [];
    final rawWarnings = json['warnings'] as List<dynamic>? ?? const [];

    return SearchJobSnapshot(
      jobId: json['job_id'] as String? ?? '',
      status: SearchStatus.fromString(json['status'] as String?),
      scannedFiles: (json['scanned_files'] as num?)?.toInt() ?? 0,
      scannedDirs: (json['scanned_dirs'] as num?)?.toInt() ?? 0,
      currentRemote: json['current_remote'] as String? ?? '',
      truncated: json['truncated'] as bool? ?? false,
      results: rawResults
          .whereType<Map<String, dynamic>>()
          .map(CloudItem.fromJson)
          .toList(),
      warnings: rawWarnings.map((e) => e.toString()).toList(),
      error: json['error'] as String?,
    );
  }

  final String jobId;
  final SearchStatus status;
  final int scannedFiles;
  final int scannedDirs;
  final String currentRemote;
  final bool truncated;
  final List<CloudItem> results;
  final List<String> warnings;
  final String? error;

  SearchJobSnapshot copyWith({
    String? jobId,
    SearchStatus? status,
    int? scannedFiles,
    int? scannedDirs,
    String? currentRemote,
    bool? truncated,
    List<CloudItem>? results,
    List<String>? warnings,
    String? error,
  }) {
    return SearchJobSnapshot(
      jobId: jobId ?? this.jobId,
      status: status ?? this.status,
      scannedFiles: scannedFiles ?? this.scannedFiles,
      scannedDirs: scannedDirs ?? this.scannedDirs,
      currentRemote: currentRemote ?? this.currentRemote,
      truncated: truncated ?? this.truncated,
      results: results ?? this.results,
      warnings: warnings ?? this.warnings,
      error: error ?? this.error,
    );
  }
}
