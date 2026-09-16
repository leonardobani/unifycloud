import 'cloud_error.dart';

enum TransferStatus {
  queued,
  running,
  completed,
  failed,
  cancelled;

  static TransferStatus fromString(String? val) {
    switch (val?.toLowerCase()) {
      case 'running':
        return TransferStatus.running;
      case 'completed':
        return TransferStatus.completed;
      case 'failed':
        return TransferStatus.failed;
      case 'cancelled':
        return TransferStatus.cancelled;
      case 'queued':
      default:
        return TransferStatus.queued;
    }
  }

  String get label {
    switch (this) {
      case TransferStatus.queued:
        return 'In coda';
      case TransferStatus.running:
        return 'In corso';
      case TransferStatus.completed:
        return 'Completato';
      case TransferStatus.failed:
        return 'Fallito';
      case TransferStatus.cancelled:
        return 'Annullato';
    }
  }
}

class TransferJob {
  final String id;
  final String srcRemote;
  final String srcPath;
  final String dstRemote;
  final String dstPath;
  final bool isMove;
  final TransferStatus status;
  final int bytes;
  final int totalBytes;
  final int percentage;
  final double speed;
  final int eta;
  final String? error;
  final DateTime? startTime;
  final DateTime? endTime;

  const TransferJob({
    required this.id,
    required this.srcRemote,
    required this.srcPath,
    required this.dstRemote,
    required this.dstPath,
    this.isMove = false,
    this.status = TransferStatus.queued,
    this.bytes = 0,
    this.totalBytes = 0,
    this.percentage = 0,
    this.speed = 0.0,
    this.eta = 0,
    this.error,
    this.startTime,
    this.endTime,
  });

  factory TransferJob.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic d) {
      if (d is String && d.isNotEmpty) {
        try {
          return DateTime.parse(d);
        } catch (_) {
          return null;
        }
      }
      return null;
    }

    return TransferJob(
      id: json['id'] as String? ?? '',
      srcRemote: json['src_remote'] as String? ?? '',
      srcPath: json['src_path'] as String? ?? '',
      dstRemote: json['dst_remote'] as String? ?? '',
      dstPath: json['dst_path'] as String? ?? '',
      isMove: json['is_move'] as bool? ?? false,
      status: TransferStatus.fromString(json['status'] as String?),
      bytes: (json['bytes'] as num?)?.toInt() ?? 0,
      totalBytes: (json['total_bytes'] as num?)?.toInt() ?? 0,
      percentage: (json['percentage'] as num?)?.toInt() ?? 0,
      speed: (json['speed'] as num?)?.toDouble() ?? 0.0,
      eta: (json['eta'] as num?)?.toInt() ?? 0,
      error: json['error'] as String?,
      startTime: parseDate(json['start_time']),
      endTime: parseDate(json['end_time']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'src_remote': srcRemote,
      'src_path': srcPath,
      'dst_remote': dstRemote,
      'dst_path': dstPath,
      'is_move': isMove,
      'status': status.name,
      'bytes': bytes,
      'total_bytes': totalBytes,
      'percentage': percentage,
      'speed': speed,
      'eta': eta,
      if (error != null) 'error': error,
      if (startTime != null) 'start_time': startTime!.toIso8601String(),
      if (endTime != null) 'end_time': endTime!.toIso8601String(),
    };
  }

  TransferJob copyWith({
    String? id,
    String? srcRemote,
    String? srcPath,
    String? dstRemote,
    String? dstPath,
    bool? isMove,
    TransferStatus? status,
    int? bytes,
    int? totalBytes,
    int? percentage,
    double? speed,
    int? eta,
    String? error,
    DateTime? startTime,
    DateTime? endTime,
  }) {
    return TransferJob(
      id: id ?? this.id,
      srcRemote: srcRemote ?? this.srcRemote,
      srcPath: srcPath ?? this.srcPath,
      dstRemote: dstRemote ?? this.dstRemote,
      dstPath: dstPath ?? this.dstPath,
      isMove: isMove ?? this.isMove,
      status: status ?? this.status,
      bytes: bytes ?? this.bytes,
      totalBytes: totalBytes ?? this.totalBytes,
      percentage: percentage ?? this.percentage,
      speed: speed ?? this.speed,
      eta: eta ?? this.eta,
      error: error ?? this.error,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }

  String get fileName {
    final parts = srcPath.split(RegExp(r'[/\\]'));
    return parts.isNotEmpty ? parts.last : srcPath;
  }

  bool get isActive =>
      status == TransferStatus.queued || status == TransferStatus.running;

  String get formattedSpeed {
    if (speed <= 0) return '0 B/s';
    if (speed < 1024) return '${speed.toStringAsFixed(0)} B/s';
    if (speed < 1024 * 1024) {
      return '${(speed / 1024).toStringAsFixed(1)} KB/s';
    }
    if (speed < 1024 * 1024 * 1024) {
      return '${(speed / (1024 * 1024)).toStringAsFixed(1)} MB/s';
    }
    return '${(speed / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB/s';
  }

  String get formattedProgress {
    String formatSize(int b) {
      if (b < 1024) return '$b B';
      if (b < 1024 * 1024) return '${(b / 1024).toStringAsFixed(1)} KB';
      if (b < 1024 * 1024 * 1024) {
        return '${(b / (1024 * 1024)).toStringAsFixed(1)} MB';
      }
      return '${(b / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
    }

    if (totalBytes > 0) {
      return '${formatSize(bytes)} / ${formatSize(totalBytes)}';
    }
    return formatSize(bytes);
  }

  String get formattedEta {
    if (eta <= 0 || !isActive) return '--';
    if (eta < 60) return '${eta}s';
    final mins = eta ~/ 60;
    final secs = eta % 60;
    if (mins < 60) return '${mins}m ${secs}s';
    final hours = mins ~/ 60;
    final remMins = mins % 60;
    return '${hours}h ${remMins}m';
  }

  /// Classifies the error cause if this transfer failed.
  CloudErrorType? get errorType =>
      error != null ? CloudErrorType.fromError(error) : null;

  /// Whether this failed transfer is eligible for retry (e.g. transient network glitch).
  bool get canRetry =>
      status == TransferStatus.failed &&
      (errorType == CloudErrorType.network || errorType == CloudErrorType.generic);

  /// User-friendly error message in Italian.
  String? get friendlyErrorMessage =>
      error != null ? errorType?.userFriendlyMessage : null;
}

