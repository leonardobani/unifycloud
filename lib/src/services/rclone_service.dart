import 'dart:convert';
import 'dart:ffi' as ffi;
import 'dart:io';
import 'dart:isolate';

import 'package:ffi/ffi.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../ffi/rclone_bindings.dart';
import '../models/cloud_models.dart';
import '../models/transfer_models.dart';

/// Riverpod provider for [RcloneService].
final rcloneServiceProvider = Provider<RcloneService>((ref) {
  return RcloneService();
});

/// Service providing typed Dart APIs over the Go Rclone CGO native shared library.
class RcloneService {
  late final ffi.DynamicLibrary _dylib;
  late final RcloneBindings _bindings;
  final bool _isCustomDylib;

  RcloneService([ffi.DynamicLibrary? dylib]) : _isCustomDylib = dylib != null {
    _dylib = dylib ?? _loadLibrary();
    _bindings = RcloneBindings(_dylib);
  }

  static ffi.DynamicLibrary _loadLibrary() {
    if (Platform.isLinux) {
      // 1. Check relative to current working directory (useful during dev & tests)
      final localBackendLib = File(
        '${Directory.current.path}/go_backend/librclone_wrapper.so',
      );
      if (localBackendLib.existsSync()) {
        return ffi.DynamicLibrary.open(localBackendLib.path);
      }

      // 2. Check relative to executable directory (packaged desktop app)
      final exeDir = File(Platform.resolvedExecutable).parent.path;
      final bundledLib = File('$exeDir/lib/librclone_wrapper.so');
      if (bundledLib.existsSync()) {
        return ffi.DynamicLibrary.open(bundledLib.path);
      }

      // 3. Fallback to system dynamic library search path
      return ffi.DynamicLibrary.open('librclone_wrapper.so');
    } else if (Platform.isMacOS) {
      return ffi.DynamicLibrary.open('librclone_wrapper.dylib');
    } else if (Platform.isWindows) {
      // 1. Check relative to current working directory (dev & tests)
      final localBackendLib = File(
        '${Directory.current.path}/go_backend/librclone_wrapper.dll',
      );
      if (localBackendLib.existsSync()) {
        return ffi.DynamicLibrary.open(localBackendLib.path);
      }

      // 2. Check relative to executable directory (packaged desktop app)
      final exeDir = File(Platform.resolvedExecutable).parent.path;
      final bundledLib = File('$exeDir/librclone_wrapper.dll');
      if (bundledLib.existsSync()) {
        return ffi.DynamicLibrary.open(bundledLib.path);
      }

      // 3. Fallback to system dynamic library search path
      return ffi.DynamicLibrary.open('librclone_wrapper.dll');
    } else if (Platform.isAndroid) {
      return ffi.DynamicLibrary.open('librclone_wrapper.so');
    } else if (Platform.isIOS) {
      return ffi.DynamicLibrary.process();
    }
    throw UnsupportedError('Unsupported platform: ${Platform.operatingSystem}');
  }

  /// Helper that converts native C string pointer to Dart string, and deallocates
  /// native memory using `FreeString` to avoid memory leaks.
  String _invokeAndFree(ffi.Pointer<ffi.Char> Function() fn) {
    final ptr = fn();
    if (ptr.address == 0) {
      throw StateError('Null pointer returned from native library');
    }
    try {
      return ptr.cast<Utf8>().toDartString();
    } finally {
      _bindings.FreeString(ptr);
    }
  }

  /// Initializes the Rclone engine.
  ///
  /// If [configPath] is provided, loads from the specified file.
  /// Otherwise, defaults to secure in-memory mode.
  Future<Map<String, dynamic>> init({String? configPath}) async {
    return using((Arena arena) {
      ffi.Pointer<ffi.Char> cPath = ffi.nullptr;
      if (configPath != null && configPath.isNotEmpty) {
        cPath = configPath.toNativeUtf8(allocator: arena).cast<ffi.Char>();
      }

      final raw = _invokeAndFree(() => _bindings.InitRclone(cPath));
      final response = RcloneResponse.fromJson(
        raw,
        (data) => data as Map<String, dynamic>,
      );

      if (!response.success) {
        throw Exception('InitRclone failed: ${response.error}');
      }
      return response.data ?? {};
    });
  }

  /// Injects an encrypted or decrypted INI configuration string directly into Go RAM memory.
  ///
  /// Guarantees that zero plaintext configuration or tokens are ever written to the disk.
  Future<List<String>> loadConfigInMemory(String configContent) async {
    return using((Arena arena) {
      final cContent = configContent
          .toNativeUtf8(allocator: arena)
          .cast<ffi.Char>();
      final raw = _invokeAndFree(
        () => _bindings.LoadConfigInMemory(cContent),
      );
      final response = RcloneResponse.fromJson(raw, (data) {
        final map = data as Map<String, dynamic>;
        final remotes =
            (map['remotes'] as List<dynamic>?)?.cast<String>() ?? [];
        return remotes;
      });

      if (!response.success) {
        throw Exception('LoadConfigInMemory failed: ${response.error}');
      }
      return response.data ?? [];
    });
  }

  /// Exports the current in-memory Rclone configuration into an INI string.
  ///
  /// Can be passed to [SecureConfigService] to be encrypted and persisted in Keychain/Keystore.
  Future<String> exportConfigInMemory() async {
    final raw = _invokeAndFree(() => _bindings.ExportConfigInMemory());
    final response = RcloneResponse.fromJson(
      raw,
      (data) => data as String,
    );

    if (!response.success) {
      throw Exception('ExportConfigInMemory failed: ${response.error}');
    }
    return response.data ?? '';
  }

  /// Adds or updates a remote configuration directly in Go memory.
  Future<void> setRemoteConfig({
    required String remoteName,
    required String remoteType,
    Map<String, String> options = const {},
  }) async {
    return using((Arena arena) {
      final cName = remoteName.toNativeUtf8(allocator: arena).cast<ffi.Char>();
      final cType = remoteType.toNativeUtf8(allocator: arena).cast<ffi.Char>();
      final cOptions = jsonEncode(options)
          .toNativeUtf8(allocator: arena)
          .cast<ffi.Char>();

      final raw = _invokeAndFree(
        () => _bindings.SetRemoteConfig(cName, cType, cOptions),
      );

      final response = RcloneResponse.fromJson(
        raw,
        (data) => data as Map<String, dynamic>,
      );

      if (!response.success) {
        throw Exception('SetRemoteConfig failed: ${response.error}');
      }
    });
  }

  /// Deletes a remote configuration from Go memory.
  Future<void> deleteRemote(String remoteName) async {
    return using((Arena arena) {
      final cName = remoteName.toNativeUtf8(allocator: arena).cast<ffi.Char>();
      final raw = _invokeAndFree(() => _bindings.DeleteRemote(cName));
      final response = RcloneResponse.fromJson(
        raw,
        (data) => data as Map<String, dynamic>,
      );

      if (!response.success) {
        throw Exception('DeleteRemote failed: ${response.error}');
      }
    });
  }

  /// Lists all cloud remotes currently configured in Rclone.
  Future<List<CloudRemote>> listRemotes() async {
    final raw = _invokeAndFree(() => _bindings.ListRemotes());
    final response = RcloneResponse.fromJson(raw, (data) {
      final list = data as List<dynamic>;
      return list
          .map((item) => CloudRemote.fromJson(item as Map<String, dynamic>))
          .toList();
    });

    if (!response.success) {
      throw Exception('ListRemotes failed: ${response.error}');
    }
    return response.data ?? [];
  }

  /// Lists files and folders in [remote] at directory [path].
  ///
  /// For local filesystem, [remote] can be empty and [path] can be a directory path.
  /// Offloads execution to a background [Isolate] so the main Flutter UI thread never freezes.
  Future<List<CloudItem>> listDirectory({
    required String remote,
    String path = '',
  }) async {
    if (_isCustomDylib) {
      return _listDirectoryInternal(remote: remote, path: path);
    }
    return Isolate.run(() {
      final worker = RcloneService();
      return worker._listDirectoryInternal(remote: remote, path: path);
    });
  }

  List<CloudItem> _listDirectoryInternal({
    required String remote,
    String path = '',
  }) {
    return using((Arena arena) {
      final cRemote = remote.toNativeUtf8(allocator: arena).cast<ffi.Char>();
      final cPath = path.toNativeUtf8(allocator: arena).cast<ffi.Char>();

      final raw = _invokeAndFree(
        () => _bindings.ListDirectory(cRemote, cPath),
      );

      final response = RcloneResponse.fromJson(raw, (data) {
        final list = data as List<dynamic>;
        return list
            .map((item) => CloudItem.fromJson(item as Map<String, dynamic>))
            .toList();
      });

      if (!response.success) {
        throw Exception('ListDirectory failed: ${response.error}');
      }
      return response.data ?? [];
    });
  }

  /// Copies a file from source to destination.
  ///
  /// Works across remotes (cloud-to-cloud, cloud-to-local, local-to-cloud).
  Future<void> copyFile({
    required String srcRemote,
    required String srcPath,
    required String dstRemote,
    required String dstPath,
  }) async {
    return using((Arena arena) {
      final cSrcRemote = srcRemote
          .toNativeUtf8(allocator: arena)
          .cast<ffi.Char>();
      final cSrcPath = srcPath.toNativeUtf8(allocator: arena).cast<ffi.Char>();
      final cDstRemote = dstRemote
          .toNativeUtf8(allocator: arena)
          .cast<ffi.Char>();
      final cDstPath = dstPath.toNativeUtf8(allocator: arena).cast<ffi.Char>();

      final raw = _invokeAndFree(
        () => _bindings.CopyFile(cSrcRemote, cSrcPath, cDstRemote, cDstPath),
      );

      final response = RcloneResponse.fromJson(
        raw,
        (data) => data as Map<String, dynamic>,
      );

      if (!response.success) {
        throw Exception('CopyFile failed: ${response.error}');
      }
    });
  }

  /// Deletes a file or directory at [filePath] on [remote].
  Future<void> deleteFile({
    required String remote,
    required String filePath,
  }) async {
    return using((Arena arena) {
      final cRemote = remote.toNativeUtf8(allocator: arena).cast<ffi.Char>();
      final cFilePath = filePath
          .toNativeUtf8(allocator: arena)
          .cast<ffi.Char>();

      final raw = _invokeAndFree(() => _bindings.DeleteFile(cRemote, cFilePath));
      final response = RcloneResponse.fromJson(
        raw,
        (data) => data as Map<String, dynamic>,
      );

      if (!response.success) {
        throw Exception('DeleteFile failed: ${response.error}');
      }
    });
  }

  /// Creates a directory at [dirPath] on [remote].
  Future<void> makeDir({
    required String remote,
    required String dirPath,
  }) async {
    return using((Arena arena) {
      final cRemote = remote.toNativeUtf8(allocator: arena).cast<ffi.Char>();
      final cDirPath = dirPath.toNativeUtf8(allocator: arena).cast<ffi.Char>();

      final raw = _invokeAndFree(() => _bindings.MakeDir(cRemote, cDirPath));
      final response = RcloneResponse.fromJson(
        raw,
        (data) => data as Map<String, dynamic>,
      );

      if (!response.success) {
        throw Exception('MakeDir failed: ${response.error}');
      }
    });
  }

  /// Starts an asynchronous transfer (copy or move) in a background Go goroutine.
  ///
  /// Returns the initial [TransferJob] with status `queued` or `running`.
  Future<TransferJob> startTransfer({
    required String srcRemote,
    required String srcPath,
    required String dstRemote,
    required String dstPath,
    bool isMove = false,
  }) async {
    return using((Arena arena) {
      final cSrcRemote =
          srcRemote.toNativeUtf8(allocator: arena).cast<ffi.Char>();
      final cSrcPath = srcPath.toNativeUtf8(allocator: arena).cast<ffi.Char>();
      final cDstRemote =
          dstRemote.toNativeUtf8(allocator: arena).cast<ffi.Char>();
      final cDstPath = dstPath.toNativeUtf8(allocator: arena).cast<ffi.Char>();

      final raw = _invokeAndFree(
        () => _bindings.StartTransfer(
          cSrcRemote,
          cSrcPath,
          cDstRemote,
          cDstPath,
          isMove ? 1 : 0,
        ),
      );

      final response = RcloneResponse.fromJson(
        raw,
        (data) => TransferJob.fromJson(data as Map<String, dynamic>),
      );

      if (!response.success || response.data == null) {
        throw Exception('StartTransfer failed: ${response.error}');
      }
      return response.data!;
    });
  }

  /// Returns the live progress of a specific transfer job by [jobId].
  Future<TransferJob?> getTransferProgress(String jobId) async {
    return using((Arena arena) {
      final cJobId = jobId.toNativeUtf8(allocator: arena).cast<ffi.Char>();
      final raw = _invokeAndFree(
        () => _bindings.GetTransferProgress(cJobId),
      );

      final response = RcloneResponse.fromJson(
        raw,
        (data) => TransferJob.fromJson(data as Map<String, dynamic>),
      );

      if (!response.success) {
        return null;
      }
      return response.data;
    });
  }

  /// Returns a snapshot of all active, queued, and recent transfers.
  Future<List<TransferJob>> getAllTransfers() async {
    return using((Arena arena) {
      final cEmpty = ''.toNativeUtf8(allocator: arena).cast<ffi.Char>();
      final raw = _invokeAndFree(
        () => _bindings.GetTransferProgress(cEmpty),
      );

      final response = RcloneResponse.fromJson(
        raw,
        (data) {
          final list = data as List<dynamic>? ?? [];
          return list
              .map((e) => TransferJob.fromJson(e as Map<String, dynamic>))
              .toList();
        },
      );

      if (!response.success) {
        throw Exception('GetAllTransfers failed: ${response.error}');
      }
      return response.data ?? [];
    });
  }

  /// Cancels an active or queued transfer job.
  Future<bool> cancelTransfer(String jobId) async {
    return using((Arena arena) {
      final cJobId = jobId.toNativeUtf8(allocator: arena).cast<ffi.Char>();
      final raw = _invokeAndFree(
        () => _bindings.CancelTransfer(cJobId),
      );

      final response = RcloneResponse.fromJson(
        raw,
        (data) => data as Map<String, dynamic>,
      );

      return response.success;
    });
  }

  /// Clears completed, failed, and cancelled transfers from memory.
  Future<void> clearCompletedTransfers() async {
    final raw = _invokeAndFree(() => _bindings.ClearCompletedTransfers());
    final response = RcloneResponse.fromJson(
      raw,
      (data) => data as Map<String, dynamic>,
    );

    if (!response.success) {
      throw Exception('ClearCompletedTransfers failed: ${response.error}');
    }
  }
}
