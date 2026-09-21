import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unifycloud/src/ui/widgets/adaptive_draggable.dart';

void main() {
  group('AdaptiveDraggable Tests', () {
    testWidgets('Touch swipe scrolls ListView and does not trigger drag',
        (tester) async {
      final scrollController = ScrollController();
      bool dragStarted = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView.builder(
              controller: scrollController,
              itemCount: 50,
              itemBuilder: (context, index) {
                return AdaptiveDraggable<String>(
                  data: 'item_$index',
                  touchDelay: const Duration(milliseconds: 300),
                  onDragStarted: () {
                    dragStarted = true;
                  },
                  feedback: Material(
                    child: Text('Dragging $index'),
                  ),
                  child: SizedBox(
                    height: 80,
                    child: Text('Item $index'),
                  ),
                );
              },
            ),
          ),
        ),
      );

      expect(scrollController.offset, equals(0.0));

      // Simulate a touch swipe upward (scrolling down)
      await tester.drag(find.text('Item 0'), const Offset(0, -200));
      await tester.pumpAndSettle();

      // Scroll position must have changed
      expect(scrollController.offset, greaterThan(50.0));
      // Drag should NOT have been started
      expect(dragStarted, isFalse);
    });

    testWidgets('Touch hold for touchDelay starts drag', (tester) async {
      bool dragStarted = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: AdaptiveDraggable<String>(
                data: 'test_item',
                touchDelay: const Duration(milliseconds: 300),
                onDragStarted: () {
                  dragStarted = true;
                },
                feedback: const Material(
                  child: Text('Dragging test_item'),
                ),
                child: const Text('Touch Me'),
              ),
            ),
          ),
        ),
      );

      final target = find.text('Touch Me');
      final targetCenter = tester.getCenter(target);

      final gesture = await tester.startGesture(
        targetCenter,
        kind: PointerDeviceKind.touch,
      );

      // Wait for touchDelay
      await tester.pump(const Duration(milliseconds: 350));

      expect(dragStarted, isTrue);

      await gesture.up();
      await tester.pumpAndSettle();
    });

    testWidgets('Mouse click-and-drag starts drag immediately without delay',
        (tester) async {
      bool dragStarted = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: AdaptiveDraggable<String>(
                data: 'test_item',
                touchDelay: const Duration(milliseconds: 500),
                onDragStarted: () {
                  dragStarted = true;
                },
                feedback: const Material(
                  child: Text('Dragging test_item'),
                ),
                child: const Text('Mouse Item'),
              ),
            ),
          ),
        ),
      );

      final target = find.text('Mouse Item');
      final targetCenter = tester.getCenter(target);

      final gesture = await tester.startGesture(
        targetCenter,
        kind: PointerDeviceKind.mouse,
      );

      // Immediately move without any delay
      await gesture.moveBy(const Offset(30, 0));
      await tester.pump();

      // Mouse drag must start immediately
      expect(dragStarted, isTrue);

      await gesture.up();
      await tester.pumpAndSettle();
    });
  });
}
