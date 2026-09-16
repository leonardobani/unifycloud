import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unifycloud/src/models/cloud_models.dart';
import 'package:unifycloud/src/providers/cloud_accounts_provider.dart';
import 'package:unifycloud/src/ui/screens/home_screen.dart';

class MockCloudAccountsNotifier extends CloudAccountsNotifier {
  final CloudAccountsState initialState;

  MockCloudAccountsNotifier(this.initialState);

  @override
  CloudAccountsState build() => initialState;
}

void main() {
  group('StorageQuota Unit & Formatting Tests', () {
    test('StorageQuota.formatBytes formats units correctly', () {
      expect(StorageQuota.formatBytes(-1), equals('--'));
      expect(StorageQuota.formatBytes(0), equals('0 B'));
      expect(StorageQuota.formatBytes(500), equals('500.0 B'));
      expect(StorageQuota.formatBytes(1024), equals('1.0 KB'));
      expect(StorageQuota.formatBytes(1024 * 1024 * 50), equals('50.0 MB'));
      expect(StorageQuota.formatBytes(1024 * 1024 * 1024 * 15), equals('15.0 GB'));
      expect(StorageQuota.formatBytes(1024 * 1024 * 1024 * 1024 * 2), equals('2.0 TB'));
    });

    test('StorageQuota calculates effective values and percentages', () {
      // Both used and total provided
      const q1 = StorageQuota(
        total: 100 * 1024 * 1024 * 1024,
        used: 25 * 1024 * 1024 * 1024,
        free: 75 * 1024 * 1024 * 1024,
      );
      expect(q1.hasData, isTrue);
      expect(q1.effectiveTotal, equals(100 * 1024 * 1024 * 1024));
      expect(q1.effectiveUsed, equals(25 * 1024 * 1024 * 1024));
      expect(q1.effectiveFree, equals(75 * 1024 * 1024 * 1024));
      expect(q1.usedPercentage, closeTo(0.25, 0.001));

      // Free and total provided, used missing (-1)
      const q2 = StorageQuota(
        total: 100 * 1024 * 1024 * 1024,
        used: -1,
        free: 60 * 1024 * 1024 * 1024,
      );
      expect(q2.hasData, isTrue);
      expect(q2.effectiveUsed, equals(40 * 1024 * 1024 * 1024));
      expect(q2.usedPercentage, closeTo(0.40, 0.001));

      // Empty / unknown quota
      const q3 = StorageQuota();
      expect(q3.hasData, isFalse);
      expect(q3.effectiveTotal, equals(0));
      expect(q3.effectiveUsed, equals(0));
      expect(q3.usedPercentage, equals(0.0));
    });

    test('StorageQuota serializes to and from JSON', () {
      final jsonMap = {'total': 1000, 'used': 300, 'free': 700};
      final quota = StorageQuota.fromJson(jsonMap);
      expect(quota.total, equals(1000));
      expect(quota.used, equals(300));
      expect(quota.free, equals(700));

      final serialized = quota.toJson();
      expect(serialized['total'], equals(1000));
      expect(serialized['used'], equals(300));
      expect(serialized['free'], equals(700));
    });
  });

  group('CloudAccountsState Aggregate Storage Tests', () {
    test('Calculates aggregate storage metrics across multiple remotes', () {
      const state = CloudAccountsState(
        remotes: [
          CloudRemote(
            name: 'GoogleDrive',
            type: 'drive',
            quota: StorageQuota(
              total: 15 * 1024 * 1024 * 1024, // 15 GB
              used: 5 * 1024 * 1024 * 1024, // 5 GB
              free: 10 * 1024 * 1024 * 1024, // 10 GB
            ),
          ),
          CloudRemote(
            name: 'DiscoLocale',
            type: 'local',
            quota: StorageQuota(
              total: 500 * 1024 * 1024 * 1024, // 500 GB
              used: 200 * 1024 * 1024 * 1024, // 200 GB
              free: 300 * 1024 * 1024 * 1024, // 300 GB
            ),
          ),
          CloudRemote(
            name: 'SFTPBackup',
            type: 'sftp', // no quota / unlimited
          ),
        ],
      );

      expect(state.hasStorageData, isTrue);
      expect(state.totalStorageBytes, equals(515 * 1024 * 1024 * 1024));
      expect(state.usedStorageBytes, equals(205 * 1024 * 1024 * 1024));
      expect(state.freeStorageBytes, equals(310 * 1024 * 1024 * 1024));
      expect(
        state.usedStoragePercentage,
        closeTo(205.0 / 515.0, 0.001),
      );
    });
  });

  group('HomeScreen Storage Overview & Drive Progress Bars Widget Tests', () {
    testWidgets('Displays actual numbers and progress bar for aggregate storage', (tester) async {
      const gDriveQuota = StorageQuota(
        total: 100 * 1024 * 1024 * 1024, // 100 GB
        used: 25 * 1024 * 1024 * 1024, // 25 GB
        free: 75 * 1024 * 1024 * 1024, // 75 GB
      );

      const localQuota = StorageQuota(
        total: 400 * 1024 * 1024 * 1024, // 400 GB
        used: 100 * 1024 * 1024 * 1024, // 100 GB
        free: 300 * 1024 * 1024 * 1024, // 300 GB
      );

      final state = const CloudAccountsState(
        isLoading: false,
        remotes: [
          CloudRemote(name: 'GoogleDrive', type: 'drive', quota: gDriveQuota),
          CloudRemote(name: 'DiscoLocale', type: 'local', quota: localQuota),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            cloudAccountsProvider.overrideWith(
              () => MockCloudAccountsNotifier(state),
            ),
          ],
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      // Verify aggregate storage numbers
      // Total = 500 GB, Used = 125 GB, Free = 375 GB
      // 125 / 500 = 25.0%
      expect(find.text('Panoramica Storage Aggregato'), findsOneWidget);
      expect(find.text('125.0 GB / 500.0 GB'), findsOneWidget);
      expect(find.text('25.0% occupato'), findsOneWidget);
      expect(find.text('375.0 GB disponibili'), findsOneWidget);

      // Verify individual drive cards display their respective space bars and numbers
      // GoogleDrive: 25.0 GB / 100.0 GB, 75.0 GB liberi
      expect(find.text('25.0 GB / 100.0 GB'), findsOneWidget);
      expect(find.text('75.0 GB liberi'), findsOneWidget);

      // DiscoLocale: 100.0 GB / 400.0 GB, 300.0 GB liberi
      expect(find.text('100.0 GB / 400.0 GB'), findsOneWidget);
      expect(find.text('300.0 GB liberi'), findsOneWidget);

      // Verify LinearProgressIndicator widgets exist (1 aggregate + 2 for the remotes)
      final progressIndicators = find.byType(LinearProgressIndicator);
      expect(progressIndicators, findsNWidgets(3));
    });
  });
}

