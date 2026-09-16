import 'dart:convert';

/// Represents a configured cloud remote provider.
class CloudRemote {
  final String name;
  final String type;
  final String? description;

  const CloudRemote({
    required this.name,
    required this.type,
    this.description,
  });

  factory CloudRemote.fromJson(Map<String, dynamic> json) {
    return CloudRemote(
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? '',
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'type': type,
    if (description != null) 'description': description,
  };

  @override
  String toString() => 'CloudRemote(name: $name, type: $type)';
}

/// Represents an item (file or directory) in a cloud remote or local filesystem.
class CloudItem {
  final String name;
  final String path;
  final bool isDir;
  final int size;
  final DateTime? modTime;
  final String? mimeType;
  final String? id;

  const CloudItem({
    required this.name,
    required this.path,
    required this.isDir,
    required this.size,
    this.modTime,
    this.mimeType,
    this.id,
  });

  factory CloudItem.fromJson(Map<String, dynamic> json) {
    DateTime? parsedModTime;
    final rawModTime = json['mod_time'] as String?;
    if (rawModTime != null && rawModTime.isNotEmpty) {
      parsedModTime = DateTime.tryParse(rawModTime);
    }

    return CloudItem(
      name: json['name'] as String? ?? '',
      path: json['path'] as String? ?? '',
      isDir: json['is_dir'] as bool? ?? false,
      size: (json['size'] as num?)?.toInt() ?? 0,
      modTime: parsedModTime,
      mimeType: json['mime_type'] as String?,
      id: json['id'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'path': path,
    'is_dir': isDir,
    'size': size,
    if (modTime != null) 'mod_time': modTime!.toIso8601String(),
    if (mimeType != null) 'mime_type': mimeType,
    if (id != null) 'id': id,
  };

  @override
  String toString() => 'CloudItem(name: $name, isDir: $isDir, size: $size)';
}

/// Wrapper for standard response from Rclone Go wrapper.
class RcloneResponse<T> {
  final bool success;
  final String? error;
  final T? data;

  const RcloneResponse({
    required this.success,
    this.error,
    this.data,
  });

  factory RcloneResponse.fromJson(
    String jsonString,
    T Function(dynamic json) fromJsonData,
  ) {
    final map = jsonDecode(jsonString) as Map<String, dynamic>;
    final success = map['success'] as bool? ?? false;
    final error = map['error'] as String?;
    final rawData = map['data'];

    return RcloneResponse<T>(
      success: success,
      error: error,
      data: success && rawData != null ? fromJsonData(rawData) : null,
    );
  }
}

