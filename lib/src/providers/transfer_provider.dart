import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../models/transfer_models.dart';
import '../services/background_service.dart';
import '../services/rclone_service.dart';
import '../services/tray_service.dart';
import 'settings_provider.dart';

class TransferState {
  final List<TransferJob> transfers;
  final bool isPolling;

  const TransferState({
    this.transfers = const [],
    this.isPolling = false,
  });

  TransferState copyWith({
    List<TransferJob>? transfers,
    bool? isPolling,
  }) {
    return TransferState(
      transfers: transfers ?? this.transfers,
      isPolling: isPolling ?? this.isPolling,
    );
  }

  List<TransferJob> get activeTransfers =>
      transfers.where((t) => t.isActive).toList();

  List<TransferJob> get completedTransfers =>
      transfers.where((t) => t.status == TransferStatus.completed).toList();

  int get activeCount => activeTransfers.length;

  double get totalSpeed =>
      activeTransfers.fold(0.0, (sum, t) => sum + t.speed);

  String get formattedTotalSpeed {
    if (totalSpeed <= 0) return '0 B/s';
    if (totalSpeed < 1024) return '${totalSpeed.toStringAsFixed(0)} B/s';
    if (totalSpeed < 1024 * 1024) {
      return '${(totalSpeed / 1024).toStringAsFixed(1)} KB/s';
    }
    if (totalSpeed < 1024 * 1024 * 1024) {
      return '${(totalSpeed / (1024 * 1024)).toStringAsFixed(1)} MB/s';
    }
    return '${(totalSpeed / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB/s';
  }

  double get averageProgress {
    final active = activeTransfers;
    if (active.isEmpty) return 0.0;
    final totalPercentage =
        active.fold<int>(0, (sum, t) => sum + t.percentage);
    return totalPercentage / (active.length * 100);
  }
}

final transferProvider =
    NotifierProvider<TransferNotifier, TransferState>(TransferNotifier.new);

class TransferNotifier extends Notifier<TransferState> {
  Timer? _pollingTimer;

  @override
  TransferState build() {
    ref.onDispose(() {
      _pollingTimer?.cancel();
    });
    // Initial fetch of existing transfers
    Future.microtask(() => loadTransfers());
    return const TransferState();
  }

  RcloneService get _rclone => ref.read(rcloneServiceProvider);

  Future<void> loadTransfers() async {
    try {
      final jobs = await _rclone.getAllTransfers();
      state = state.copyWith(transfers: jobs);
      _checkPollingStatus();
    } catch (_) {
      // Ignored or handled in UI
    }
  }

  Future<TransferJob> startTransfer({
    required String srcRemote,
    required String srcPath,
    required String dstRemote,
    required String dstPath,
    bool isMove = false,
  }) async {
    final job = await _rclone.startTransfer(
      srcRemote: srcRemote,
      srcPath: srcPath,
      dstRemote: dstRemote,
      dstPath: dstPath,
      isMove: isMove,
    );

    state = state.copyWith(
      transfers: [job, ...state.transfers.where((t) => t.id != job.id)],
    );

    _startPolling();
    return job;
  }

  Future<void> cancelTransfer(String jobId) async {
    await _rclone.cancelTransfer(jobId);
    await loadTransfers();
  }

  Future<void> clearCompleted() async {
    await _rclone.clearCompletedTransfers();
    await loadTransfers();
  }

  /// Retries a previously failed or stopped transfer job using its original parameters.
  Future<TransferJob?> retryTransfer(String jobId) async {
    final existing = state.transfers.where((t) => t.id == jobId).firstOrNull;
    if (existing == null) return null;

    return startTransfer(
      srcRemote: existing.srcRemote,
      srcPath: existing.srcPath,
      dstRemote: existing.dstRemote,
      dstPath: existing.dstPath,
      isMove: existing.isMove,
    );
  }

  /// Uploads a single local file to [dstRemote]:[dstPath], preserving its filename.
  Future<TransferJob> uploadFile({
    required File file,
    required String dstRemote,
    required String dstPath,
  }) async {
    final fileName = p.basename(file.path);
    final targetDstPath = dstPath.isEmpty ? fileName : '$dstPath/$fileName';
    return startTransfer(
      srcRemote: '',
      srcPath: file.path,
      dstRemote: dstRemote,
      dstPath: targetDstPath,
      isMove: false,
    );
  }

  /// Uploads multiple local files to [dstRemote]:[dstPath], preserving their filenames.
  Future<List<TransferJob>> uploadFiles({
    required List<File> files,
    required String dstRemote,
    required String dstPath,
  }) async {
    final launchedJobs = <TransferJob>[];
    for (final file in files) {
      final job = await uploadFile(
        file: file,
        dstRemote: dstRemote,
        dstPath: dstPath,
      );
      launchedJobs.add(job);
    }
    return launchedJobs;
  }

  /// Opens the native file picker to select one or more local files and upload them to [dstRemote]:[dstPath].
  Future<List<TransferJob>> pickAndUploadFiles({
    required String dstRemote,
    required String dstPath,
  }) async {
    final result = await FilePicker.pickFiles(
      dialogTitle: 'Seleziona i file da caricare nel Cloud',
    );

    if (result.isEmpty) {
      return [];
    }

    final files = <File>[];
    for (final file in result) {
      final localPath = file.path;
      if (localPath != null && localPath.isNotEmpty) {
        files.add(File(localPath));
      }
    }

    return uploadFiles(
      files: files,
      dstRemote: dstRemote,
      dstPath: dstPath,
    );
  }

  /// Uploads all files in a local directory recursively to [dstRemote]:[dstPath],
  /// preserving the directory tree structure under a root folder named after the local folder.
  Future<List<TransferJob>> uploadDirectory({
    required Directory directory,
    required String dstRemote,
    required String dstPath,
  }) async {
    if (!directory.existsSync()) {
      throw FileSystemException('Directory non esistente', directory.path);
    }

    final rootDirName = p.basename(directory.path);
    final cloudRoot = dstPath.isEmpty ? rootDirName : '$dstPath/$rootDirName';

    // Ensure the root remote directory exists (covers empty directories)
    try {
      await _rclone.makeDir(remote: dstRemote, dirPath: cloudRoot);
    } catch (_) {
      // Ignored if cloud backend handles directories implicitly
    }

    final launchedJobs = <TransferJob>[];
    final entities = directory.listSync(recursive: true, followLinks: false);

    for (final entity in entities) {
      if (entity is File) {
        final relativePath = p.relative(entity.path, from: directory.path);
        final normalizedRelPath = p.split(relativePath).join('/');
        final targetDstPath = '$cloudRoot/$normalizedRelPath';

        final job = await startTransfer(
          srcRemote: '',
          srcPath: entity.path,
          dstRemote: dstRemote,
          dstPath: targetDstPath,
          isMove: false,
        );
        launchedJobs.add(job);
      } else if (entity is Directory) {
        final relativePath = p.relative(entity.path, from: directory.path);
        final normalizedRelPath = p.split(relativePath).join('/');
        final subDirDstPath = '$cloudRoot/$normalizedRelPath';
        try {
          await _rclone.makeDir(remote: dstRemote, dirPath: subDirDstPath);
        } catch (_) {}
      }
    }

    return launchedJobs;
  }

  /// Opens the native directory picker to select a local folder and upload it recursively to [dstRemote]:[dstPath].
  Future<List<TransferJob>> pickAndUploadFolder({
    required String dstRemote,
    required String dstPath,
  }) async {
    final selectedDir = await FilePicker.getDirectoryPath(
      dialogTitle: 'Seleziona la cartella da caricare nel Cloud',
    );

    if (selectedDir == null || selectedDir.trim().isEmpty) {
      return [];
    }

    return uploadDirectory(
      directory: Directory(selectedDir.trim()),
      dstRemote: dstRemote,
      dstPath: dstPath,
    );
  }

  /// Downloads a cloud file to the local system downloads or documents directory (or user-defined custom directory).
  Future<TransferJob> downloadFile({
    required String srcRemote,
    required String srcPath,
    String? customTargetDir,
  }) async {
    final customPath =
        customTargetDir ?? ref.read(settingsProvider).customDownloadPath;
    Directory targetDir;
    if (customPath != null && customPath.trim().isNotEmpty) {
      targetDir = Directory(customPath.trim());
    } else {
      Directory? sysDir;
      try {
        sysDir = await getDownloadsDirectory();
      } catch (_) {
        sysDir = null;
      }
      try {
        targetDir = sysDir ?? await getApplicationDocumentsDirectory();
      } catch (_) {
        targetDir = Directory.systemTemp;
      }
    }

    await targetDir.create(recursive: true);

    final rawName = p.basename(srcPath.replaceAll(RegExp(r'/+$'), ''));
    final fileName = rawName.isNotEmpty ? rawName : 'downloaded_file';
    final localDestination = p.join(targetDir.path, fileName);

    return startTransfer(
      srcRemote: srcRemote,
      srcPath: srcPath,
      dstRemote: '',
      dstPath: localDestination,
      isMove: false,
    );
  }

  /// Downloads multiple cloud files to the local downloads or custom directory.
  Future<List<TransferJob>> downloadFiles({
    required String srcRemote,
    required List<String> srcPaths,
    String? customTargetDir,
  }) async {
    final jobs = <TransferJob>[];
    for (final path in srcPaths) {
      final job = await downloadFile(
        srcRemote: srcRemote,
        srcPath: path,
        customTargetDir: customTargetDir,
      );
      jobs.add(job);
    }
    return jobs;
  }

  void _checkPollingStatus() {
    _updateBackgroundMetrics();
    if (state.activeTransfers.isNotEmpty) {
      _startPolling();
    } else {
      _stopPolling();
    }
  }

  void _updateBackgroundMetrics() {
    try {
      if (state.activeTransfers.isNotEmpty) {
        ref.read(appBackgroundServiceProvider).notifyTransferProgress(
          activeCount: state.activeCount,
          totalSpeed: state.totalSpeed,
          averagePercentage: (state.averageProgress * 100).round(),
          formattedSpeed: state.formattedTotalSpeed,
        );
        ref.read(trayServiceProvider).updateTransferStatus(
          activeTransfers: state.activeCount,
          formattedSpeed: state.formattedTotalSpeed,
        );
      } else {
        ref.read(appBackgroundServiceProvider).notifyTransfersIdle();
        ref.read(trayServiceProvider).updateTransferStatus(
          activeTransfers: 0,
        );
      }
    } catch (_) {}
  }

  void _startPolling() {
    _updateBackgroundMetrics();
    if (_pollingTimer != null && _pollingTimer!.isActive) return;

    state = state.copyWith(isPolling: true);
    _pollingTimer = Timer.periodic(
      const Duration(milliseconds: 500),
      (_) async {
        try {
          final jobs = await _rclone.getAllTransfers();
          state = state.copyWith(transfers: jobs);
          _updateBackgroundMetrics();
          if (state.activeTransfers.isEmpty) {
            _stopPolling();
          }
        } catch (_) {
          _stopPolling();
        }
      },
    );
  }

  void _stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
    state = state.copyWith(isPolling: false);
    _updateBackgroundMetrics();
  }
}
