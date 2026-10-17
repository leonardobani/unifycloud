import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unifycloud/src/models/transfer_models.dart';
import 'package:unifycloud/src/providers/transfer_provider.dart';
import 'package:unifycloud/src/services/background_service.dart';
import 'package:unifycloud/src/services/desktop_autostart_service.dart';
import 'package:unifycloud/src/services/rclone_service.dart';
import 'package:unifycloud/src/services/tray_service.dart';

class FakeBackgroundService extends AppBackgroundService {
  int progressNotificationCount = 0;
  int idleNotificationCount = 0;
  int lastActiveCount = 0;
  double lastSpeed = 0.0;
  int lastPercentage = 0;

  @override
  bool get isSupported => true;

  @override
  Future<void> notifyTransferProgress({
    required int activeCount,
    required double totalSpeed,
    required int averagePercentage,
    required String formattedSpeed,
  }) async {
    progressNotificationCount++;
    lastActiveCount = activeCount;
    lastSpeed = totalSpeed;
    lastPercentage = averagePercentage;
  }

  @override
  Future<void> notifyTransfersIdle() async {
    idleNotificationCount++;
  }
}

class FakeRcloneService extends RcloneService {
  List<TransferJob> mockTransfers = [];

  FakeRcloneService() : super();

  @override
  Future<List<TransferJob>> getAllTransfers() async {
    return mockTransfers;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DesktopAutostartService Tests', () {
    late Directory tempDir;
    late DesktopAutostartService autostartService;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('unifycloud_autostart_test_');
      autostartService = DesktopAutostartService(
        customAutostartDirPath: tempDir.path,
        customExecutablePath: '/usr/bin/unifycloud',
      );
    });

    tearDown(() {
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    });

    test('isAutostartEnabled returns false initially when desktop file does not exist', () async {
      final enabled = await autostartService.isAutostartEnabled();
      expect(enabled, isFalse);
    });

    test('setAutostartEnabled(true) creates .desktop file with correct XDG autostart metadata', () async {
      final success = await autostartService.setAutostartEnabled(true);
      expect(success, isTrue);

      final file = autostartService.desktopEntryFile;
      expect(file.existsSync(), isTrue);

      final content = file.readAsStringSync();
      expect(content, contains('[Desktop Entry]'));
      expect(content, contains('Name=UnifyCloud'));
      expect(content, contains('Exec="/usr/bin/unifycloud" --background'));
      expect(content, contains('Icon=io.gitlab.leorise25.unifycloud'));
      expect(content, contains('X-GNOME-Autostart-enabled=true'));

      final isEnabled = await autostartService.isAutostartEnabled();
      expect(isEnabled, isTrue);
    });

    test('setAutostartEnabled(false) deletes .desktop file cleanly', () async {
      await autostartService.setAutostartEnabled(true);
      expect(autostartService.desktopEntryFile.existsSync(), isTrue);

      final success = await autostartService.setAutostartEnabled(false);
      expect(success, isTrue);
      expect(autostartService.desktopEntryFile.existsSync(), isFalse);

      final isEnabled = await autostartService.isAutostartEnabled();
      expect(isEnabled, isFalse);
    });
  });

  group('TrayService Tests', () {
    test('TrayService default values and state tracking', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final tray = container.read(trayServiceProvider);
      expect(tray.activeTransfers, equals(0));
      expect(tray.formattedSpeed, isEmpty);
    });

    test('updateTransferStatus updates activeTransfers and formattedSpeed', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final tray = container.read(trayServiceProvider);
      await tray.updateTransferStatus(
        activeTransfers: 3,
        formattedSpeed: '12.5 MB/s',
      );

      expect(tray.activeTransfers, equals(3));
      expect(tray.formattedSpeed, equals('12.5 MB/s'));

      await tray.updateTransferStatus(activeTransfers: 0);
      expect(tray.activeTransfers, equals(0));
    });
  });

  group('Background Transfer & Tray Coordination Tests', () {
    test('TransferNotifier notifies AppBackgroundService and TrayService on active transfers and idle', () async {
      final fakeBg = FakeBackgroundService();
      final fakeRclone = FakeRcloneService();

      fakeRclone.mockTransfers = [
        const TransferJob(
          id: 'job-1',
          srcRemote: 'gdrive',
          srcPath: 'file1.mp4',
          dstRemote: '',
          dstPath: '/local/file1.mp4',
          status: TransferStatus.running,
          bytes: 5000000,
          totalBytes: 10000000,
          percentage: 50,
          speed: 1048576, // 1 MB/s
        ),
      ];

      final container = ProviderContainer(
        overrides: [
          appBackgroundServiceProvider.overrideWithValue(fakeBg),
          rcloneServiceProvider.overrideWithValue(fakeRclone),
        ],
      );
      addTearDown(container.dispose);

      final transferNotifier = container.read(transferProvider.notifier);
      await transferNotifier.loadTransfers();

      // Verify that background service received progress update
      expect(fakeBg.progressNotificationCount, greaterThanOrEqualTo(1));
      expect(fakeBg.lastActiveCount, equals(1));
      expect(fakeBg.lastPercentage, equals(50));

      // Verify that tray service received progress update
      final tray = container.read(trayServiceProvider);
      expect(tray.activeTransfers, equals(1));

      // Now clear active transfers and verify idle notification
      fakeRclone.mockTransfers = [
        const TransferJob(
          id: 'job-1',
          srcRemote: 'gdrive',
          srcPath: 'file1.mp4',
          dstRemote: '',
          dstPath: '/local/file1.mp4',
          status: TransferStatus.completed,
          bytes: 10000000,
          totalBytes: 10000000,
          percentage: 100,
          speed: 0,
        ),
      ];

      await transferNotifier.loadTransfers();
      expect(fakeBg.idleNotificationCount, greaterThanOrEqualTo(1));
      expect(tray.activeTransfers, equals(0));
    });
  });
}
