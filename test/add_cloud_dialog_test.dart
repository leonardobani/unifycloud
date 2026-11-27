import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
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
        OAuthService.getRcloneClientSecret('dropbox'),
        equals('1n9m04y2zx7bf26'),
      );
      expect(
        OAuthService.getRcloneClientId('onedrive'),
        equals('b15665d9-eda6-4092-8539-0eec376afd59'),
      );
      expect(
        OAuthService.getRcloneClientSecret('onedrive'),
        equals('qtyfaBBYA403=unZUP40~_#'),
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

    test('OneDrive OAuth configuration has correct port, redirect_uri and scopes', () {
      final config = OAuthService.supportedProviders['onedrive'];
      expect(config, isNotNull);
      expect(config!.defaultRedirectUri, equals('http://localhost:53682/'));
      expect(config.defaultClientId, equals('b15665d9-eda6-4092-8539-0eec376afd59'));
      expect(config.scopes, containsAll([
        'Files.Read',
        'Files.ReadWrite',
        'Files.Read.All',
        'Files.ReadWrite.All',
        'Sites.Read.All',
        'offline_access',
      ]));

      final service = OAuthService();
      final authUri = service.buildAuthUrl(
        config: config,
        clientId: config.defaultClientId,
        redirectUri: config.defaultRedirectUri,
      );

      expect(authUri.queryParameters['redirect_uri'], equals('http://localhost:53682/'));
      expect(authUri.queryParameters['client_id'], equals('b15665d9-eda6-4092-8539-0eec376afd59'));
      expect(authUri.queryParameters.containsKey('access_type'), isFalse);
      expect(authUri.queryParameters['scope'], contains('offline_access'));
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

    testWidgets('Renders Google Drive with UnifyCloud Official option by default',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(createDialogApp());
      await tester.pumpAndSettle();

      // Verify Google Drive is selected and dropdown is present with UnifyCloud default
      expect(find.text('Google Drive'), findsWidgets);
      expect(find.text('Client ID Mode (OAuth2)'), findsOneWidget);
      expect(
        find.text('UnifyCloud (Official / Recommended)'),
        findsOneWidget,
      );

      // Verify official UnifyCloud badge is shown and custom fields are hidden
      expect(
        find.text('Official UnifyCloud Credentials'),
        findsOneWidget,
      );
      expect(
        find.text(
          'Fast verified login with dedicated credentials for UnifyCloud. Click "Start Browser Login" to authenticate without manual setup.',
        ),
        findsOneWidget,
      );
      expect(find.text('Personal Google Client ID'), findsNothing);
    });

    testWidgets(
        'Switching dropdown between UnifyCloud, Rclone, and Personal Client ID works correctly',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(createDialogApp());
      await tester.pumpAndSettle();

      // 1. Switch to Rclone mode
      await tester.tap(find.text('UnifyCloud (Official / Recommended)'));
      await tester.pumpAndSettle();

      final rcloneOption =
          find.text('Rclone (Not recommended - Shared quota)').last;
      await tester.tap(rcloneOption);
      await tester.pumpAndSettle();

      // Verify Rclone warning banner is visible
      expect(
        find.text('Rclone Public Client ID (Not Recommended)'),
        findsOneWidget,
      );
      expect(find.text('Personal Google Client ID'), findsNothing);

      // 2. Switch to Custom / Personal Client ID mode
      await tester.tap(find.text('Rclone (Not recommended - Shared quota)').first);
      await tester.pumpAndSettle();

      final customOption =
          find.text('Personal Client ID (Advanced)').last;
      await tester.tap(customOption);
      await tester.pumpAndSettle();

      // Verify custom inputs and guide notification are visible
      expect(
        find.text(
          'Create your own IDs independently: see docs/oauth_setup_guide.md for a step-by-step guide.',
        ),
        findsOneWidget,
      );
      expect(find.text('Personal Google Client ID'), findsOneWidget);
      expect(find.text('Client Secret (Optional)'), findsOneWidget);

      // 3. Switch back to UnifyCloud
      await tester.tap(find.text('Personal Client ID (Advanced)').first);
      await tester.pumpAndSettle();

      final unifyCloudOption =
          find.text('UnifyCloud (Official / Recommended)').last;
      await tester.tap(unifyCloudOption);
      await tester.pumpAndSettle();

      expect(
        find.text('Official UnifyCloud Credentials'),
        findsOneWidget,
      );
      expect(find.text('Personal Google Client ID'), findsNothing);
    });

    testWidgets('Selecting Microsoft OneDrive shows UnifyCloud credentials badge',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(createDialogApp());
      await tester.pumpAndSettle();

      // Tap on Microsoft OneDrive ChoiceChip
      await tester.tap(find.text('Microsoft OneDrive'));
      await tester.pumpAndSettle();

      // Verify OneDrive is selected and UnifyCloud official mode is default
      expect(find.text('UnifyCloud (Official / Recommended)'), findsOneWidget);
      expect(
        find.text('Official UnifyCloud Credentials'),
        findsOneWidget,
      );
    });
  });
}
