import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/cloud_models.dart';
import '../models/transfer_models.dart';
import 'transfer_provider.dart';

class ClipboardState {
  final CloudItem? _singleItem;
  final List<CloudItem> _multipleItems;
  final String? sourceRemote;
  final bool isCut;

  const ClipboardState({
    CloudItem? item,
    List<CloudItem> items = const [],
    this.sourceRemote,
    this.isCut = false,
  })  : _singleItem = item,
        _multipleItems = items;

  /// Returns all items in clipboard (supporting both single and multi-item modes).
  List<CloudItem> get items {
    if (_multipleItems.isNotEmpty) return _multipleItems;
    if (_singleItem != null) return [_singleItem];
    return const [];
  }

  /// Convenience getter for backward compatibility with single-item usage.
  CloudItem? get item =>
      _singleItem ?? (_multipleItems.isNotEmpty ? _multipleItems.first : null);

  /// True if there are items and a source remote defined.
  bool get hasItem => items.isNotEmpty && sourceRemote != null;

  /// Total number of items stored in clipboard.
  int get count => items.length;

  String get actionLabel => isCut ? 'Sposta' : 'Copia';
}

final clipboardProvider =
    NotifierProvider<ClipboardNotifier, ClipboardState>(ClipboardNotifier.new);

class ClipboardNotifier extends Notifier<ClipboardState> {
  @override
  ClipboardState build() => const ClipboardState();

  /// Copies a single item to the clipboard.
  void copy(CloudItem item, String sourceRemote) {
    state = ClipboardState(
      items: [item],
      sourceRemote: sourceRemote,
      isCut: false,
    );
  }

  /// Cuts a single item to the clipboard for moving.
  void cut(CloudItem item, String sourceRemote) {
    state = ClipboardState(
      items: [item],
      sourceRemote: sourceRemote,
      isCut: true,
    );
  }

  /// Copies multiple items to the clipboard.
  void copyAll(List<CloudItem> items, String sourceRemote) {
    state = ClipboardState(
      items: items,
      sourceRemote: sourceRemote,
      isCut: false,
    );
  }

  /// Cuts multiple items to the clipboard for moving.
  void cutAll(List<CloudItem> items, String sourceRemote) {
    state = ClipboardState(
      items: items,
      sourceRemote: sourceRemote,
      isCut: true,
    );
  }

  /// Clears the clipboard.
  void clear() {
    state = const ClipboardState();
  }

  /// Pastes all clipboard items into [targetRemote]:[targetPath].
  ///
  /// Automatically dispatches cloud-to-cloud transfer jobs for each item.
  Future<List<TransferJob>> pasteTo({
    required String targetRemote,
    required String targetPath,
  }) async {
    if (!state.hasItem) return [];

    final jobs = <TransferJob>[];
    final itemsToPaste = List<CloudItem>.from(state.items);
    final srcRemote = state.sourceRemote!;
    final isMove = state.isCut;

    for (final item in itemsToPaste) {
      final dst = targetPath.isEmpty ? item.name : '$targetPath/${item.name}';
      final job = await ref.read(transferProvider.notifier).startTransfer(
            srcRemote: srcRemote,
            srcPath: item.path,
            dstRemote: targetRemote,
            dstPath: dst,
            isMove: isMove,
          );
      jobs.add(job);
    }

    // If it was a cut operation, clear the clipboard after dispatching
    if (isMove) {
      clear();
    }

    return jobs;
  }
}

