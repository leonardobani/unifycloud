import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../providers/app_lock_provider.dart';
import 'app_lock_screen.dart';

/// Top-level gate widget that intercepts the app rendering when [AppLockState.isLocked] is true.
///
/// Ensures no route, screen, or deep link can be accessed while UnifyCloud is locked.
class AppLockGate extends ConsumerWidget {

  const AppLockGate({
    super.key,
    required this.child,
  });
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lockState = ref.watch(appLockProvider);

    if (lockState.isLocked) {
      return const AppLockScreen();
    }

    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) =>
          ref.read(appLockProvider.notifier).recordActivity(),
      onPointerSignal: (_) =>
          ref.read(appLockProvider.notifier).recordActivity(),
      child: child,
    );
  }
}
