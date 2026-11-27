import 'cloud_models.dart';

/// Represents a file or folder pinned to the Home screen for quick access.
class FavoriteItem {
  const FavoriteItem({
    required this.remote,
    required this.path,
    required this.name,
    required this.isDir,
    this.size = 0,
    this.mimeType,
    required this.pinnedAt,
  });

  factory FavoriteItem.fromJson(Map<String, dynamic> json) {
    final rawPinnedAt = json['pinned_at'] as String?;
    return FavoriteItem(
      remote: json['remote'] as String? ?? '',
      path: json['path'] as String? ?? '',
      name: json['name'] as String? ?? '',
      isDir: json['is_dir'] as bool? ?? false,
      size: (json['size'] as num?)?.toInt() ?? 0,
      mimeType: json['mime_type'] as String?,
      pinnedAt: (rawPinnedAt != null ? DateTime.tryParse(rawPinnedAt) : null) ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  final String remote;
  final String path;
  final String name;
  final bool isDir;
  final int size;
  final String? mimeType;
  final DateTime pinnedAt;

  /// Canonical unique identifier across remotes and paths.
  String get storageId => '$remote:$path';

  /// Converts this pinned entry into a [CloudItem] for [FileOpenerService].
  CloudItem toCloudItem() {
    return CloudItem(
      name: name,
      path: path,
      isDir: isDir,
      size: size,
      mimeType: mimeType,
    );
  }

  Map<String, dynamic> toJson() => {
        'remote': remote,
        'path': path,
        'name': name,
        'is_dir': isDir,
        'size': size,
        if (mimeType != null) 'mime_type': mimeType,
        'pinned_at': pinnedAt.toIso8601String(),
      };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FavoriteItem &&
        other.remote == remote &&
        other.path == path &&
        other.name == name &&
        other.isDir == isDir &&
        other.size == size &&
        other.mimeType == mimeType;
  }

  @override
  int get hashCode => Object.hash(remote, path, name, isDir, size, mimeType);
}
