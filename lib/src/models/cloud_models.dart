import 'dart:convert';

/// Represents storage usage and quota information for a cloud remote or local drive.
class StorageQuota {
  final int total; // in bytes, -1 if unknown
  final int used; // in bytes, -1 if unknown
  final int free; // in bytes, -1 if unknown

  const StorageQuota({
    this.total = -1,
    this.used = -1,
    this.free = -1,
  });

  bool get hasData => total > 0 || used > 0 || free > 0;

  int get effectiveTotal {
    if (total >= 0) return total;
    if (used >= 0 && free >= 0) return used + free;
    return 0;
  }

  int get effectiveUsed {
    if (used >= 0) return used;
    if (total >= 0 && free >= 0 && total >= free) return total - free;
    return 0;
  }

  int get effectiveFree {
    if (free >= 0) return free;
    if (total >= 0 && used >= 0 && total >= used) return total - used;
    return 0;
  }

  double get usedPercentage {
    final t = effectiveTotal;
    if (t <= 0) return 0.0;
    final u = effectiveUsed;
    return (u / t).clamp(0.0, 1.0);
  }

  static String formatBytes(int bytes) {
    if (bytes < 0) return '--';
    if (bytes == 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB', 'PB'];
    var i = 0;
    double d = bytes.toDouble();
    while (d >= 1024 && i < suffixes.length - 1) {
      d /= 1024;
      i++;
    }
    return '${d.toStringAsFixed(1)} ${suffixes[i]}';
  }

  factory StorageQuota.fromJson(Map<String, dynamic> json) {
    return StorageQuota(
      total: (json['total'] as num?)?.toInt() ?? -1,
      used: (json['used'] as num?)?.toInt() ?? -1,
      free: (json['free'] as num?)?.toInt() ?? -1,
    );
  }

  Map<String, dynamic> toJson() => {
    'total': total,
    'used': used,
    'free': free,
  };

  @override
  String toString() => 'StorageQuota(total: $total, used: $used, free: $free)';
}

/// Represents a configured cloud remote provider.
class CloudRemote {
  final String name;
  final String type;
  final String? description;
  final StorageQuota? quota;

  const CloudRemote({
    required this.name,
    required this.type,
    this.description,
    this.quota,
  });

  CloudRemote copyWith({
    String? name,
    String? type,
    String? description,
    StorageQuota? quota,
  }) {
    return CloudRemote(
      name: name ?? this.name,
      type: type ?? this.type,
      description: description ?? this.description,
      quota: quota ?? this.quota,
    );
  }

  factory CloudRemote.fromJson(Map<String, dynamic> json) {
    return CloudRemote(
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? '',
      description: json['description'] as String?,
      quota: json['quota'] != null
          ? StorageQuota.fromJson(json['quota'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'type': type,
    if (description != null) 'description': description,
    if (quota != null) 'quota': quota!.toJson(),
  };

  @override
  String toString() => 'CloudRemote(name: $name, type: $type, quota: $quota)';
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

