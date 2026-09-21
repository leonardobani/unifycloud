import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A draggable widget that adapts its gesture recognition based on the pointer device kind:
/// - Mouse pointers: immediate drag on click-and-drag.
/// - Touch / stylus pointers: delayed drag (long-press) so vertical swiping and flinging
///   scroll the parent [Scrollable] (ListView/GridView) smoothly without interference.
class AdaptiveDraggable<T extends Object> extends Draggable<T> {
  const AdaptiveDraggable({
    super.key,
    required super.child,
    required super.feedback,
    super.data,
    super.axis,
    super.childWhenDragging,
    super.feedbackOffset = Offset.zero,
    super.dragAnchorStrategy = childDragAnchorStrategy,
    super.affinity,
    super.maxSimultaneousDrags,
    super.onDragStarted,
    super.onDragUpdate,
    super.onDraggableCanceled,
    super.onDragEnd,
    super.onDragCompleted,
    this.hapticFeedbackOnStart = true,
    super.ignoringFeedbackSemantics = true,
    super.ignoringFeedbackPointer = true,
    this.touchDelay = const Duration(milliseconds: 350),
    super.allowedButtonsFilter,
    super.hitTestBehavior = HitTestBehavior.deferToChild,
    super.rootOverlay = false,
  });

  /// Whether to trigger haptic feedback when a touch drag starts.
  final bool hapticFeedbackOnStart;

  /// The duration that a touch pointer must remain in place before a drag is recognized.
  /// Defaults to 350ms to allow smooth scrolling while still feeling responsive.
  final Duration touchDelay;

  @override
  MultiDragGestureRecognizer createRecognizer(GestureMultiDragStartCallback onStart) {
    return _AdaptiveMultiDragGestureRecognizer(
      touchDelay: touchDelay,
      hapticFeedbackOnStart: hapticFeedbackOnStart,
      allowedButtonsFilter: allowedButtonsFilter,
    )..onStart = onStart;
  }
}

class _AdaptiveMultiDragGestureRecognizer extends MultiDragGestureRecognizer {
  _AdaptiveMultiDragGestureRecognizer({
    required this.touchDelay,
    required this.hapticFeedbackOnStart,
    super.debugOwner,
    super.allowedButtonsFilter,
  });

  final Duration touchDelay;
  final bool hapticFeedbackOnStart;

  @override
  MultiDragPointerState createNewPointerState(PointerDownEvent event) {
    if (event.kind == PointerDeviceKind.mouse) {
      return _AdaptiveImmediatePointerState(
        event.position,
        event.kind,
        gestureSettings,
      );
    } else {
      return _AdaptiveDelayedPointerState(
        event.position,
        touchDelay,
        event.kind,
        gestureSettings,
        hapticFeedbackOnStart,
      );
    }
  }

  @override
  String get debugDescription => 'adaptive multidrag';
}

class _AdaptiveImmediatePointerState extends MultiDragPointerState {
  _AdaptiveImmediatePointerState(
    super.initialPosition,
    super.kind,
    super.gestureSettings,
  );

  @override
  void checkForResolutionAfterMove() {
    assert(pendingDelta != null);
    if (pendingDelta!.distance > computeHitSlop(kind, gestureSettings)) {
      resolve(GestureDisposition.accepted);
    }
  }

  @override
  void accepted(GestureMultiDragStartCallback starter) {
    starter(initialPosition);
  }
}

class _AdaptiveDelayedPointerState extends MultiDragPointerState {
  _AdaptiveDelayedPointerState(
    super.initialPosition,
    Duration delay,
    super.kind,
    super.gestureSettings,
    this.hapticFeedback,
  ) {
    _timer = Timer(delay, _delayPassed);
  }

  final bool hapticFeedback;
  Timer? _timer;
  GestureMultiDragStartCallback? _starter;

  void _delayPassed() {
    assert(_timer != null);
    assert(pendingDelta != null);
    assert(pendingDelta!.distance <= computeHitSlop(kind, gestureSettings));
    _timer = null;
    if (hapticFeedback) {
      HapticFeedback.selectionClick();
    }
    if (_starter != null) {
      _starter!(initialPosition);
      _starter = null;
    } else {
      resolve(GestureDisposition.accepted);
    }
    assert(_starter == null);
  }

  void _ensureTimerStopped() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void accepted(GestureMultiDragStartCallback starter) {
    assert(_starter == null);
    if (_timer == null) {
      starter(initialPosition);
    } else {
      _starter = starter;
    }
  }

  @override
  void checkForResolutionAfterMove() {
    if (_timer == null) {
      assert(_starter != null);
      return;
    }
    assert(pendingDelta != null);
    if (pendingDelta!.distance > computeHitSlop(kind, gestureSettings)) {
      resolve(GestureDisposition.rejected);
      _ensureTimerStopped();
    }
  }

  @override
  void dispose() {
    _ensureTimerStopped();
    super.dispose();
  }
}
