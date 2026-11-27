import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/cloud_models.dart';
import '../models/favorite_item.dart';
import '../services/file_opener_service.dart';
import 'settings_provider.dart';

/// Provider exposing the list of [FavoriteItem]s pinned to the Home screen.
final favoritesProvider =
    NotifierProvider<FavoritesNotifier, List<FavoriteItem>>(
  FavoritesNotifier.new,
);

/// Riverpod Notifier managing pinned favorites and persistence.
class FavoritesNotifier extends Notifier<List<FavoriteItem>> {
  FavoritesNotifier([this._initialFavorites]);

  static const String favoritesStorageKey = 'unifycloud_favorites_v1';
  final List<FavoriteItem>? _initialFavorites;
  bool _hasLocalChanges = false;

  FlutterSecureStorage get _storage => ref.read(settingsStorageProvider);

  @override
  List<FavoriteItem> build() {
    _hasLocalChanges = false;
    if (_initialFavorites != null) {
      return _initialFavorites;
    }
    scheduleMicrotask(_loadFromStorage);
    return const [];
  }

  Future<void> _loadFromStorage() async {
    try {
      final rawJson = await _storage.read(key: favoritesStorageKey);
      if (!_hasLocalChanges && rawJson != null && rawJson.trim().isNotEmpty) {
        final decoded = jsonDecode(rawJson) as List<dynamic>;
        state = decoded
            .map((item) => FavoriteItem.fromJson(item as Map<String, dynamic>))
            .where((item) => item.remote.isNotEmpty && item.name.isNotEmpty)
            .toList();
      }
    } catch (_) {
      // Keep current state on storage/parse error
    }
  }

  Future<void> _persist(List<FavoriteItem> newFavorites) async {
    _hasLocalChanges = true;
    state = newFavorites;
    try {
      final jsonString =
          jsonEncode(newFavorites.map((item) => item.toJson()).toList());
      await _storage.write(key: favoritesStorageKey, value: jsonString);
    } catch (_) {}
  }

  /// Resolves the canonical path for [itemPath] inside [currentPath].
  static String canonicalPath(String itemPath, [String? currentPath]) {
    return resolveRemoteItemPath(itemPath, currentPath);
  }

  /// Returns whether the given remote + canonical path is currently pinned.
  bool isPinned(String remote, String path, {String? currentPath}) {
    final resolved = canonicalPath(path, currentPath);
    return state.any((fav) => fav.remote == remote && fav.path == resolved);
  }

  /// Pins or unpins [item] on [remote]. Returns `true` if now pinned, `false` if unpinned.
  Future<bool> toggleFavorite({
    required String remote,
    required CloudItem item,
    String? currentPath,
  }) async {
    final cleanRemote = remote.trim();
    if (cleanRemote.isEmpty) return false;

    final resolvedPath = canonicalPath(item.path, currentPath);
    final existingIndex = state.indexWhere(
      (fav) => fav.remote == cleanRemote && fav.path == resolvedPath,
    );

    if (existingIndex >= 0) {
      final updated = List<FavoriteItem>.from(state)..removeAt(existingIndex);
      await _persist(updated);
      return false;
    }

    final favorite = FavoriteItem(
      remote: cleanRemote,
      path: resolvedPath,
      name: item.name,
      isDir: item.isDir,
      size: item.size,
      mimeType: item.mimeType,
      pinnedAt: DateTime.now(),
    );
    await _persist([...state, favorite]);
    return true;
  }

  /// Removes a pinned item matching [remote] and [path].
  Future<void> removeFavorite(String remote, String path) async {
    final updated = state
        .where((fav) => !(fav.remote == remote && fav.path == path))
        .toList();
    if (updated.length != state.length) {
      await _persist(updated);
    }
  }

  /// Removes all pinned items belonging to a disconnected [remote].
  Future<void> removeByRemote(String remote) async {
    final updated = state.where((fav) => fav.remote != remote).toList();
    if (updated.length != state.length) {
      await _persist(updated);
    }
  }
}
