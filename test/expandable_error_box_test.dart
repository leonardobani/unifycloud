import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unifycloud/src/ui/widgets/expandable_error_box.dart';

void main() {
  group('ExpandableErrorBox Widget Tests', () {
    const sampleError =
        'Exception: ListDirectory failed: failed to access remote "GoogleDrive:": '
        'drive: failed when making oauth client: failed to create oauth client: '
        'invalid character \'a\' looking for beginning of object key string\n'
        'at rclone/backend/drive.go:123\n'
        'at rclone/fs/config.go:456';

    Widget createTestApp({bool initiallyExpanded = false}) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: ExpandableErrorBox(
              error: sampleError,
              initiallyExpanded: initiallyExpanded,
            ),
          ),
        ),
      );
    }

    testWidgets('Renders collapsed by default with truncated text and expand hint',
        (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      expect(find.text('Error Details'), findsOneWidget);
      expect(find.text('Expand'), findsOneWidget);
      expect(find.byIcon(Icons.expand_more), findsOneWidget);
      expect(find.text('Copy error'), findsNothing);
      expect(find.byType(SelectableText), findsNothing);
    });

    testWidgets('Tapping expands the box to show full selectable text and copy button',
        (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // Tap on the error box to expand
      await tester.tap(find.text('Error Details'));
      await tester.pumpAndSettle();

      expect(find.text('Collapse'), findsOneWidget);
      expect(find.byIcon(Icons.expand_less), findsOneWidget);
      expect(find.text('Copy error'), findsOneWidget);
      expect(find.byType(SelectableText), findsOneWidget);

      // Verify full error text is inside the SelectableText widget
      final selectableWidget =
          tester.widget<SelectableText>(find.byType(SelectableText));
      expect(selectableWidget.data, equals(sampleError));

      // Tap to collapse again
      await tester.tap(find.text('Collapse'));
      await tester.pumpAndSettle();

      expect(find.text('Expand'), findsOneWidget);
      expect(find.byIcon(Icons.expand_more), findsOneWidget);
      expect(find.text('Copy error'), findsNothing);
    });

    testWidgets('Copy error copies full error to system Clipboard',
        (tester) async {
      // Mock clipboard
      final List<MethodCall> clipboardCalls = [];
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (MethodCall methodCall) async {
          clipboardCalls.add(methodCall);
          if (methodCall.method == 'Clipboard.setData') {
            return null;
          }
          return null;
        },
      );

      await tester.pumpWidget(createTestApp(initiallyExpanded: true));
      await tester.pumpAndSettle();

      expect(find.text('Copy error'), findsOneWidget);

      // Tap copy button
      await tester.tap(find.text('Copy error'));
      await tester.pumpAndSettle();

      // Verify clipboard call was made with full error
      final copyCall = clipboardCalls.firstWhere(
        (c) => c.method == 'Clipboard.setData',
      );
      expect(
        (copyCall.arguments as Map)['text'],
        equals(sampleError),
      );

      // Verify button feedback changed to "Copied!"
      expect(find.text('Copied!'), findsOneWidget);

      // Advance timer by 3 seconds to reset button and close timers cleanly
      await tester.pump(const Duration(seconds: 3));
      expect(find.text('Copy error'), findsOneWidget);
    });

    testWidgets('Scrollbar renders with attached ScrollController and scrolls smoothly',
        (tester) async {
      await tester.pumpWidget(createTestApp(initiallyExpanded: true));
      await tester.pumpAndSettle();

      final scrollbarFinder = find.byType(Scrollbar);
      expect(scrollbarFinder, findsOneWidget);
      final scrollbar = tester.widget<Scrollbar>(scrollbarFinder);
      expect(scrollbar.controller, isNotNull);

      // Perform a drag/scroll gesture to ensure no assertion errors occur
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -50));
      await tester.pumpAndSettle();
    });
  });
}
