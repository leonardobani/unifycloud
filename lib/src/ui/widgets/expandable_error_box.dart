import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// An interactive, expandable error box that displays an error snippet when collapsed
/// and expands on click to show the full, selectable, and scrollable error message
/// with a quick copy-to-clipboard action.
class ExpandableErrorBox extends StatefulWidget {
  final String error;
  final Color? accentColor;
  final bool initiallyExpanded;
  final double maxWidth;

  const ExpandableErrorBox({
    super.key,
    required this.error,
    this.accentColor,
    this.initiallyExpanded = false,
    this.maxWidth = 480,
  });

  @override
  State<ExpandableErrorBox> createState() => _ExpandableErrorBoxState();
}

class _ExpandableErrorBoxState extends State<ExpandableErrorBox> {
  late bool _isExpanded;
  bool _copied = false;
  Timer? _copyTimer;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  void dispose() {
    _copyTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: widget.error));
    if (mounted) {
      _copyTimer?.cancel();
      setState(() => _copied = true);
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Dettagli errore copiati negli appunti'),
          duration: Duration(seconds: 2),
        ),
      );
      _copyTimer = Timer(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() => _copied = false);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent = widget.accentColor ?? Colors.red;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: widget.maxWidth),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: accent.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header bar
                  Row(
                    children: [
                      Icon(
                        Icons.bug_report_outlined,
                        size: 16,
                        color: accent.withValues(alpha: 0.9),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Dettagli Errore',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: accent.withValues(alpha: 0.9),
                        ),
                      ),
                      const Spacer(),
                      Flexible(
                        child: Text(
                          _isExpanded ? 'Comprimi' : 'Espandi',
                          style: TextStyle(
                            fontSize: 11,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        _isExpanded ? Icons.expand_less : Icons.expand_more,
                        size: 18,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Content
                  if (!_isExpanded) ...[
                    Text(
                      widget.error,
                      style: TextStyle(
                        fontSize: 11,
                        fontFamily: 'monospace',
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ] else ...[
                    Container(
                      constraints: const BoxConstraints(maxHeight: 220),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.black.withValues(alpha: 0.3)
                            : Theme.of(context).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Scrollbar(
                        controller: _scrollController,
                        thumbVisibility: true,
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: SelectableText(
                            widget.error,
                            style: TextStyle(
                              fontSize: 11,
                              fontFamily: 'monospace',
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.grey.shade200
                                  : Theme.of(context).colorScheme.onSurface,
                              height: 1.35,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          onPressed: _copyToClipboard,
                          icon: Icon(
                            _copied ? Icons.check : Icons.copy_rounded,
                            size: 14,
                            color: _copied ? Colors.green : accent,
                          ),
                          label: Text(
                            _copied ? 'Copiato!' : 'Copia errore',
                            style: TextStyle(
                              fontSize: 11,
                              color: _copied ? Colors.green : accent,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            visualDensity: VisualDensity.compact,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
