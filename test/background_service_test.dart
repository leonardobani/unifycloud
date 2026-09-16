import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unifycloud/src/providers/transfer_provider.dart';
import 'package:unifycloud/src/services/background_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Fase 7: AppBackgroundService Unit & Integration Tests', () {
    test('AppBackgroundService detects platform support correctly', () {
      final service = AppBackgroundService();
      // On Linux/Desktop test runner, isSupported is false
      if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
        expect(service.isSupported, isFalse);
      } else if (Platform.isAndroid || Platform.isIOS) {
        expect(service.isSupported, isTrue);
      }
    });

    test('initialize() gracefully completes without errors on desktop', () async {
      final service = AppBackgroundService();
      final result = await service.initialize();
      expect(result, isTrue);
    });

    test('notifyTransferProgress() and notifyTransfersIdle() execute safely', () async {
      final service = AppBackgroundService();
      // Should not throw on unsupported or supported platforms
      await service.notifyTransferProgress(
        activeCount: 2,
        totalSpeed: 1048576,
        averagePercentage: 50,
        formattedSpeed: '1.0 MB/s',
      );

      await service.notifyTransfersIdle();
      await service.stop();
    });

    test('Riverpod container properly provides appBackgroundServiceProvider', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final service = container.read(appBackgroundServiceProvider);
      expect(service, isNotNull);
      expect(service, isA<AppBackgroundService>());
    });

    test('TransferState calculates average progress and formatted speed correctly', () {
      const state = TransferState();
      expect(state.activeCount, 0);
      expect(state.formattedTotalSpeed, '0 B/s');
      expect(state.averageProgress, 0.0);
    });
  });
}

