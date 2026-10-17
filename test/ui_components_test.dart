import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unifycloud/l10n/app_localizations.dart';
import 'package:unifycloud/src/models/cloud_models.dart';
import 'package:unifycloud/src/providers/cloud_accounts_provider.dart';
import 'package:unifycloud/src/providers/file_explorer_provider.dart';
import 'package:unifycloud/src/ui/screens/file_explorer_screen.dart';
import 'package:unifycloud/src/ui/screens/home_screen.dart';
import 'package:unifycloud/src/ui/theme/cosmic_icons.dart';
import 'package:unifycloud/src/ui/widgets/breadcrumbs_bar.dart';
import 'package:unifycloud/src/ui/widgets/file_type_icon.dart';

void main() {
  group('Fase 5: UI Component Tests', () {
    testWidgets('FileTypeIcon displays correct icon and color per extension', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                FileTypeIcon(fileName: 'MyFolder', isDir: true),
                FileTypeIcon(fileName: 'document.pdf', isDir: false),
                FileTypeIcon(fileName: 'photo.png', isDir: false),
                FileTypeIcon(fileName: 'archive.zip', isDir: false),
                FileTypeIcon(fileName: 'code.dart', isDir: false),
              ],
            ),
          ),
        ),
      );

      expect(
        find.byWidgetPredicate(
          (w) => w is CosmicSvgIcon && w.asset == CosmicIcons.explorerSvg,
        ),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate(
          (w) => w is CosmicSvgIcon && w.asset == CosmicIcons.documentSvg,
        ),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate(
          (w) => w is CosmicSvgIcon && w.asset == CosmicIcons.imageSvg,
        ),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate(
          (w) => w is CosmicSvgIcon && w.asset == CosmicIcons.archiveSvg,
        ),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate(
          (w) => w is CosmicSvgIcon && w.asset == CosmicIcons.codeSvg,
        ),
        findsOneWidget,
      );
    });

    testWidgets('BreadcrumbsBar displays hierarchy trail', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            fileExplorerProvider.overrideWith(
              () => FileExplorerNotifierMock(
                const FileExplorerState(
                  currentRemote: 'GoogleDrive',
                  currentPath: 'Projects/2026/Design',
                ),
              ),
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(body: BreadcrumbsBar()),
          ),
        ),
      );

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('GoogleDrive'), findsOneWidget);
      expect(find.text('Projects'), findsOneWidget);
      expect(find.text('2026'), findsOneWidget);
      expect(find.text('Design'), findsOneWidget);
      expect(find.byIcon(Icons.chevron_right), findsNWidgets(4));
    });

    testWidgets('HomeScreen renders storage overview and add cloud button', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            cloudAccountsProvider.overrideWith(
              () => CloudAccountsNotifierMock(
                const CloudAccountsState(
                  isLoading: false,
                  remotes: [
                    CloudRemote(name: 'MyDrive', type: 'drive'),
                    CloudRemote(name: 'WorkDropbox', type: 'dropbox'),
                  ],
                ),
              ),
            ),
          ],
          child: const MaterialApp(
            locale: Locale('it'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: HomeScreen(),
          ),
        ),
      );

      expect(find.text('UnifyCloud'), findsOneWidget);
      expect(find.text('Panoramica Storage Aggregato'), findsOneWidget);
      expect(find.text('Cloud Collegati (2)'), findsOneWidget);
      expect(find.text('MyDrive'), findsOneWidget);
      expect(find.text('WorkDropbox'), findsOneWidget);
      expect(find.text('Collega Nuovo Cloud'), findsOneWidget);
    });

    testWidgets('FileExplorerScreen renders toolbar and item cards', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            cloudAccountsProvider.overrideWith(
              () => CloudAccountsNotifierMock(
                const CloudAccountsState(
                  isLoading: false,
                  remotes: [CloudRemote(name: 'MyDrive', type: 'drive')],
                ),
              ),
            ),
            fileExplorerProvider.overrideWith(
              () => FileExplorerNotifierMock(
                FileExplorerState(
                  currentRemote: 'MyDrive',
                  currentPath: 'Docs',
                  items: [
                    const CloudItem(name: 'Subfolder', path: 'Docs/Subfolder', isDir: true, size: 0),
                    CloudItem(name: 'report.pdf', path: 'Docs/report.pdf', isDir: false, size: 2048, modTime: DateTime(2026, 9, 14)),
                  ],
                ),
              ),
            ),
          ],
          child: const MaterialApp(
            home: FileExplorerScreen(),
          ),
        ),
      );

      expect(find.text('Subfolder'), findsOneWidget);
      expect(find.text('report.pdf'), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.sort), findsOneWidget);
      expect(find.byIcon(Icons.grid_view_outlined), findsOneWidget);

      // Verify 3-dots PopupMenuButton is rendered for items
      final moreButtons = find.byIcon(Icons.more_vert);
      expect(moreButtons, findsNWidgets(2));

      // Tap 3-dots on file item (second one)
      await tester.tap(moreButtons.at(1));
      await tester.pumpAndSettle();

      // Check popup menu options appear
      expect(find.text('Scarica in locale'), findsOneWidget);
      expect(find.text('Copia'), findsOneWidget);
      expect(find.text('Taglia (Sposta)'), findsOneWidget);
      expect(find.text('Rinomina'), findsOneWidget);
      expect(find.text('Copia percorso'), findsOneWidget);
      expect(find.text('Informazioni'), findsOneWidget);
      expect(find.text('Elimina'), findsOneWidget);
    });

    testWidgets('FileExplorerScreen displays informative loading indicator when isLoading is true', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            cloudAccountsProvider.overrideWith(
              () => CloudAccountsNotifierMock(
                const CloudAccountsState(
                  isLoading: false,
                  remotes: [CloudRemote(name: 'GoogleDrive', type: 'drive')],
                ),
              ),
            ),
            fileExplorerProvider.overrideWith(
              () => FileExplorerNotifierMock(
                const FileExplorerState(
                  currentRemote: 'GoogleDrive',
                  currentPath: '',
                  isLoading: true,
                ),
              ),
            ),
          ],
          child: const MaterialApp(
            home: FileExplorerScreen(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Caricamento file da GoogleDrive...'), findsOneWidget);
      expect(find.text('Lettura directory in corso...'), findsOneWidget);
    });
  });
}

class CloudAccountsNotifierMock extends Notifier<CloudAccountsState>
    implements CloudAccountsNotifier {
  final CloudAccountsState _initialState;
  CloudAccountsNotifierMock(this._initialState);

  @override
  CloudAccountsState build() => _initialState;

  @override
  Future<void> loadRemotes() async {}

  @override
  Future<void> addRemote({required String name, required String type, Map<String, String> options = const {}}) async {}

  @override
  Future<void> deleteRemote(String name) async {}
}

class FileExplorerNotifierMock extends Notifier<FileExplorerState>
    implements FileExplorerNotifier {
  final FileExplorerState _initialState;
  FileExplorerNotifierMock(this._initialState);

  @override
  FileExplorerState build() => _initialState;

  @override
  Future<void> openRemote(String remote, {String path = ''}) async {}

  @override
  Future<void> navigateTo(String path) async {}

  @override
  Future<void> navigateUp() async {}

  @override
  Future<void> refresh() async {}

  @override
  void setViewMode(FileViewMode mode) {}

  @override
  void setSortMode(FileSortMode mode) {}

  @override
  void setSearchQuery(String query) {}

  @override
  Future<void> createDirectory(String name) async {}

  @override
  Future<void> deleteItem(CloudItem item) async {}

  @override
  Future<void> renameItem(CloudItem item, String newName) async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
