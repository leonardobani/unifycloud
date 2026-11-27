import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unifycloud/src/models/cloud_models.dart';
import 'package:unifycloud/src/models/favorite_item.dart';
import 'package:unifycloud/src/providers/favorites_provider.dart';
import 'package:unifycloud/src/providers/settings_provider.dart';

class _InMemorySecureStorage extends FlutterSecureStorage {
  final Map<String, String> _store = {};

  @override
  Future<String?> read({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    return _store[key];
  }

  @override
  Future<void> write({
    required String key,
    required String? value,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    if (value == null) {
      _store.remove(key);
    } else {
      _store[key] = value;
    }
  }
}

void main() {
  group('FavoriteItem & FavoritesNotifier Tests', () {
    test('FavoriteItem serializes and deserializes cleanly', () {
      final item = FavoriteItem(
        remote: 'MyDrive',
        path: 'Docs/report.pdf',
        name: 'report.pdf',
        isDir: false,
        size: 4096,
        mimeType: 'application/pdf',
        pinnedAt: DateTime.utc(2026, 11, 27, 12),
      );

      final decoded = FavoriteItem.fromJson(item.toJson());
      expect(decoded, equals(item));
      expect(decoded.storageId, equals('MyDrive:Docs/report.pdf'));

      final cloudItem = decoded.toCloudItem();
      expect(cloudItem.name, equals('report.pdf'));
      expect(cloudItem.path, equals('Docs/report.pdf'));
      expect(cloudItem.isDir, isFalse);
      expect(cloudItem.size, equals(4096));
    });

    test('FavoritesNotifier toggles, resolves canonical paths, and persists', () async {
      final storage = _InMemorySecureStorage();
      final container = ProviderContainer(
        overrides: [
          settingsStorageProvider.overrideWithValue(storage),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(favoritesProvider.notifier);
      const file = CloudItem(
        name: 'notes.txt',
        path: 'notes.txt',
        isDir: false,
        size: 120,
      );

      final pinned = await notifier.toggleFavorite(
        remote: 'MyDrive',
        item: file,
        currentPath: 'Work/2026',
      );
      expect(pinned, isTrue);
      expect(container.read(favoritesProvider).length, equals(1));
      expect(
        container.read(favoritesProvider).first.path,
        equals('Work/2026/notes.txt'),
      );
      expect(
        notifier.isPinned('MyDrive', 'notes.txt', currentPath: 'Work/2026'),
        isTrue,
      );
      expect(
        notifier.isPinned('MyDrive', 'Work/2026/notes.txt'),
        isTrue,
      );

      // Re-create container to confirm persistence in storage
      final container2 = ProviderContainer(
        overrides: [
          settingsStorageProvider.overrideWithValue(storage),
        ],
      );
      addTearDown(container2.dispose);
      container2.read(favoritesProvider);
      await Future<void>.delayed(Duration.zero);
      expect(container2.read(favoritesProvider).length, equals(1));
      expect(
        container2.read(favoritesProvider).first.path,
        equals('Work/2026/notes.txt'),
      );

      // Unpin toggles off
      final unpinned = await notifier.toggleFavorite(
        remote: 'MyDrive',
        item: file,
        currentPath: 'Work/2026',
      );
      expect(unpinned, isFalse);
      expect(container.read(favoritesProvider), isEmpty);
    });

    test('removeByRemote removes only items from disconnected remote', () async {
      final storage = _InMemorySecureStorage();
      final initial = [
        FavoriteItem(
          remote: 'DriveA',
          path: 'a.pdf',
          name: 'a.pdf',
          isDir: false,
          pinnedAt: DateTime.utc(2026, 11, 27),
        ),
        FavoriteItem(
          remote: 'DriveB',
          path: 'b.pdf',
          name: 'b.pdf',
          isDir: false,
          pinnedAt: DateTime.utc(2026, 11, 27),
        ),
      ];

      final container = ProviderContainer(
        overrides: [
          settingsStorageProvider.overrideWithValue(storage),
          favoritesProvider.overrideWith(() => FavoritesNotifier(initial)),
        ],
      );
      addTearDown(container.dispose);

      await container.read(favoritesProvider.notifier).removeByRemote('DriveA');
      final remaining = container.read(favoritesProvider);
      expect(remaining.length, equals(1));
      expect(remaining.first.remote, equals('DriveB'));
    });
  });
}
