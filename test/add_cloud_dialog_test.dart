import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unifycloud/src/services/oauth_service.dart';
import 'package:unifycloud/src/ui/widgets/add_cloud_dialog.dart';

void main() {
  group('OAuthService Rclone Credentials Tests', () {
    test('getRcloneClientId and getRcloneClientSecret return valid credentials', () {
      expect(
        OAuthService.getRcloneClientId('drive'),
        equals('202264815644.apps.googleusercontent.com'),
      );
      expect(
        OAuthService.getRcloneClientSecret('drive'),
        equals('X4Z3ca8xfWDb1Voo-F9a7ZxJ'),
      );
      expect(
        OAuthService.getRcloneClientId('dropbox'),
        equals('5jcck7diasz0rqy'),
      );
      expect(
        OAuthService.getRcloneClientId('onedrive'),
        equals('b15665d9-eda6-4092-8539-0eec376afd59'),
      );
      expect(
        OAuthService.getRcloneClientId('unknown_provider'),
        isNull,
      );
    });

    test('openBrowser executes safely and returns boolean without unhandled exceptions', () async {
      final service = OAuthService();
      final result = await service.openBrowser(
        Uri.parse('https://accounts.google.com/o/oauth2/auth'),
      );
      expect(result, isA<bool>());
    });
  });

  group('AddCloudDialog Client ID Dropdown Tests', () {
    Widget createDialogApp() {
      return const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: AddCloudDialog(),
          ),
        ),
      );
    }

    testWidgets('Renders Google Drive with Rclone Client ID option by default',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(createDialogApp());
      await tester.pumpAndSettle();

      // Verify Google Drive is selected and dropdown is present
      expect(find.text('Google Drive'), findsWidgets);
      expect(find.text('Modalità Client ID (OAuth2)'), findsOneWidget);
      expect(
        find.text('Client ID di Rclone (Consigliato / Rapido)'),
        findsOneWidget,
      );

      // Verify rclone info container is shown and personal Client ID input is not shown
      expect(
        find.text('Accesso Rapido con Client ID di Rclone'),
        findsOneWidget,
      );
      expect(
        find.text('Non è necessario creare un progetto su Google Cloud Console. Clicca direttamente su "Avvia Accesso nel Browser" per autenticarti.'),
        findsOneWidget,
      );
      expect(find.text('Client ID Personale Google'), findsNothing);
    });

    testWidgets(
        'Switching dropdown to Personal Client ID displays custom input fields',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(createDialogApp());
      await tester.pumpAndSettle();

      // Tap dropdown to open menu
      await tester.tap(find.text('Client ID di Rclone (Consigliato / Rapido)'));
      await tester.pumpAndSettle();

      // Select 'Client ID Personale'
      final customOption = find.text('Client ID Personale').last;
      await tester.tap(customOption);
      await tester.pumpAndSettle();

      // Now custom fields should be visible and rclone banner hidden
      expect(find.text('Client ID Personale Google'), findsOneWidget);
      expect(find.text('Client Secret (Opzionale)'), findsOneWidget);
      expect(find.text('Accesso rapido con Client ID di Rclone'), findsNothing);

      // Switch back to Rclone mode
      await tester.tap(find.text('Client ID Personale').first);
      await tester.pumpAndSettle();

      final rcloneOption =
          find.text('Client ID di Rclone (Consigliato / Rapido)').last;
      await tester.tap(rcloneOption);
      await tester.pumpAndSettle();

      // Rclone banner is visible again, custom fields are gone
      expect(
        find.text('Accesso Rapido con Client ID di Rclone'),
        findsOneWidget,
      );
      expect(find.text('Client ID Personale Google'), findsNothing);
    });
  });
}
