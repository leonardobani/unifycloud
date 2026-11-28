import 'dart:ffi' as ffi;

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:unifycloud/src/models/cloud_models.dart';
import 'package:unifycloud/src/providers/file_explorer_provider.dart';
import 'package:unifycloud/src/services/rclone_service.dart';
import 'package:unifycloud/src/services/secure_config_service.dart';
import 'package:unifycloud/src/services/storage_permission_service.dart';
import 'package:unifycloud/src/ui/widgets/file_explorer_pane_view.dart';

class _FakeRcloneService extends RcloneService {
  _FakeRcloneService() : super(ffi.DynamicLibrary.process());

  int listCalls = 0;
  bool hasStorageGrant = false;

  @override
  Future<String> exportConfigInMemory() async => '';

  @override
  Future<List<String>> loadConfigInMemory(String configContent) async => [];

  @override
  Future<List<CloudRemote>> listRemotes() async => const [
        CloudRemote(name: 'LocalDisk', type: 'local'),
        CloudRemote(name: 'MyDrive', type: 'drive'),
      ];

  @override
  Future<StorageQuota?> getRemoteAbout(String remote) async => null;

  @override
  Future<List<CloudItem>> listDirectory({
    required String remote,
    String path = '',
  }) async {
    listCalls++;
    return [
      const CloudItem(
        name: 'DCIM',
        path: 'DCIM',
        isDir: true,
        size: 0,
      ),
      if (remote != 'LocalDisk' || hasStorageGrant)
        const CloudItem(
          name: 'photo.jpg',
          path: 'photo.jpg',
          isDir: false,
          size: 2048,
        ),
    ];
  }
}

class _FakeSecureConfigService extends SecureConfigService {
  @override
  Future<String?> loadEncryptedConfig() async => null;

  @override
  Future<void> saveEncryptedConfig(String configContent) async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('StoragePermissionService Tests', () {
    const channel = MethodChannel('dev.leonardobani.unifycloud/storage_permission');

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });

    test('returns true without calling channel on non-Android platforms', () async {
      var called = false;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
        called = true;
        return false;
      });

      final service = StoragePermissionService(
        channel: channel,
        isAndroidOverride: () => false,
      );

      expect(await service.hasAllFilesAccess(), isTrue);
      expect(await service.requestAllFilesAccess(), isTrue);
      expect(called, isFalse);
    });

    test('queries and requests permission via MethodChannel on Android', () async {
      var granted = false;
      final methods = <String>[];

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
        methods.add(call.method);
        if (call.method == 'hasAllFilesAccess') return granted;
        if (call.method == 'requestAllFilesAccess') {
          granted = true;
          return true;
        }
        return null;
      });

      final service = StoragePermissionService(
        channel: channel,
        isAndroidOverride: () => true,
      );

      expect(await service.hasAllFilesAccess(), isFalse);
      expect(await service.requestAllFilesAccess(), isTrue);
      expect(await service.hasAllFilesAccess(), isTrue);
      expect(
        methods,
        equals(['hasAllFilesAccess', 'requestAllFilesAccess', 'hasAllFilesAccess']),
      );
    });
  });

  group('FileExplorerPaneView Android Storage Permission Banner Tests', () {
    const channel = MethodChannel('dev.leonardobani.unifycloud/storage_permission');

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });

    testWidgets('shows storage banner for local remote when missing permission and refreshes once granted',
        (tester) async {
      var granted = false;
      final fakeRclone = _FakeRcloneService();

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
        if (call.method == 'hasAllFilesAccess') return granted;
        if (call.method == 'requestAllFilesAccess') {
          granted = true;
          fakeRclone.hasStorageGrant = true;
          return true;
        }
        return null;
      });

      final service = StoragePermissionService(
        channel: channel,
        isAndroidOverride: () => true,
      );

      final container = ProviderContainer(
        overrides: [
          rcloneServiceProvider.overrideWithValue(fakeRclone),
          secureConfigServiceProvider.overrideWithValue(_FakeSecureConfigService()),
          storagePermissionServiceProvider.overrideWithValue(service),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(
              body: FileExplorerPaneView(
                provider: fileExplorerProvider,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Initially opened LocalDisk without permission: folder visible, file hidden, banner shown
      expect(find.text('DCIM'), findsOneWidget);
      expect(find.text('photo.jpg'), findsNothing);
      expect(find.text('All files access required'), findsOneWidget);
      expect(find.text('Grant Access'), findsOneWidget);

      // Tap Grant Access -> permission granted -> directory automatically refreshes and shows file
      await tester.tap(find.text('Grant Access'));
      await tester.pumpAndSettle();

      expect(find.text('All files access required'), findsNothing);
      expect(find.text('DCIM'), findsOneWidget);
      expect(find.text('photo.jpg'), findsOneWidget);
    });

    testWidgets('does not show storage banner for cloud remotes even when local permission is missing',
        (tester) async {
      final fakeRclone = _FakeRcloneService();

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async => false);

      final service = StoragePermissionService(
        channel: channel,
        isAndroidOverride: () => true,
      );

      final container = ProviderContainer(
        overrides: [
          rcloneServiceProvider.overrideWithValue(fakeRclone),
          secureConfigServiceProvider.overrideWithValue(_FakeSecureConfigService()),
          storagePermissionServiceProvider.overrideWithValue(service),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(
              body: FileExplorerPaneView(
                provider: fileExplorerProvider,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Switch to MyDrive (cloud remote)
      await container.read(fileExplorerProvider.notifier).openRemote('MyDrive');
      await tester.pumpAndSettle();

      expect(find.text('All files access required'), findsNothing);
      expect(find.text('photo.jpg'), findsOneWidget);
    });
  });
}
