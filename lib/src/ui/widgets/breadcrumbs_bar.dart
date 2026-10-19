import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/file_explorer_provider.dart';
import '../theme/cosmic_icons.dart';

/// An interactive horizontal breadcrumb bar allowing one-tap navigation to any parent directory.
class BreadcrumbsBar extends ConsumerWidget {
  final NotifierProvider<FileExplorerNotifier, FileExplorerState>? provider;

  const BreadcrumbsBar({
    super.key,
    this.provider,
  });

  NotifierProvider<FileExplorerNotifier, FileExplorerState> get _provider =>
      provider ?? fileExplorerProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(_provider);
    final breadcrumbs = state.breadcrumbs;

    if (breadcrumbs.isEmpty) {
      return const SizedBox.shrink();
    }

    final scrollController = ScrollController();

    // Auto-scroll to the right whenever the path changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });

    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: ListView.separated(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: breadcrumbs.length,
        separatorBuilder: (context, index) => CosmicSvgIcon(
          CosmicIcons.chevronRightSvg,
          size: 18,
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
        itemBuilder: (context, index) {
          final item = breadcrumbs[index];
          final isLast = index == breadcrumbs.length - 1;

          return Center(
            child: InkWell(
              borderRadius: BorderRadius.circular(6),
              onTap: () {
                if (item.isRoot) {
                  context.go('/');
                } else if (!isLast) {
                  ref.read(_provider.notifier).navigateTo(item.path);
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (item.isRoot) ...[
                      CosmicSvgIcon(
                        CosmicIcons.homeSvg,
                        size: 18,
                        color: isLast
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                    ],
                    Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isLast ? FontWeight.w600 : FontWeight.normal,
                        color: isLast
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
