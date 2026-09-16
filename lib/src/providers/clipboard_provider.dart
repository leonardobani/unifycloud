import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/cloud_models.dart';
import '../models/transfer_models.dart';
import 'transfer_provider.dart';

class ClipboardState {
  final CloudItem? item;
  final String? sourceRemote;
  final bool isCut;

  const ClipboardState({
    this.item,
    this.sourceRemote,
    this.isCut = false,
  });

  bool get hasItem => item != null && sourceRemote != null;

  String get actionLabel => isCut ? 'Sposta' : 'Copia';
}

final clipboardProvider =
    NotifierProvider<ClipboardNotifier, ClipboardState>(ClipboardNotifier.new);

class ClipboardNotifier extends Notifier<ClipboardState> {
  @override
  ClipboardState build() => const ClipboardState();

  void copy(CloudItem item, String sourceRemote) {
    state = ClipboardState(
      item: item,
      sourceRemote: sourceRemote,
      isCut: false,
    );
  }

  void cut(CloudItem item, String sourceRemote) {
    state = ClipboardState(
      item: item,
      sourceRemote: sourceRemote,
      isCut: true,
    );
  }

  void clear() {
    state = const ClipboardState();
  }

  /// Pastes the clipboard item to [targetRemote]:[targetPath].
  ///
  /// Automatically uses Rclone's cloud-to-cloud transfer engine.
  Future<TransferJob?> pasteTo({
    required String targetRemote,
    required String targetPath,
  }) async {
    if (!state.hasItem) return null;

    final item = state.item!;
    final srcRemote = state.sourceRemote!;
    final isMove = state.isCut;

    final job = await ref.read(transferProvider.notifier).startTransfer(
          srcRemote: srcRemote,
          srcPath: item.path,
          dstRemote: targetRemote,
          dstPath: targetPath,
          isMove: isMove,
        );

    // If it was a cut operation, clear the clipboard after dispatching
    if (isMove) {
      clear();
    }

    return job;
  }
}

