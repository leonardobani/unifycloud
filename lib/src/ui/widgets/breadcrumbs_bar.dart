import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/file_explorer_provider.dart';

/// An interactive horizontal breadcrumb bar allowing one-tap navigation to any parent directory.
class BreadcrumbsBar extends ConsumerWidget {
  const BreadcrumbsBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(fileExplorerProvider);
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
        separatorBuilder: (context, index) => Icon(
          Icons.chevron_right,
          size: 18,
          color: Colors.grey.shade500,
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
                  ref.read(fileExplorerProvider.notifier).navigateTo(item.path);
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (item.isRoot) ...[
                      Icon(
                        Icons.home_outlined,
                        size: 18,
                        color: isLast ? Theme.of(context).colorScheme.primary : Colors.grey,
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
                            : Theme.of(context).textTheme.bodyMedium?.color,
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
