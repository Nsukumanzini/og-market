import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme.dart';

/// Premium search bar with a frosted-glass aesthetic.
/// Pass [onChanged] for live search, [onSubmitted] for confirmed queries,
/// and [onTap] to intercept the tap (e.g. push a dedicated search screen).
class SearchBarPremium extends StatefulWidget {
  const SearchBarPremium({
    super.key,
    this.hint = 'Search products, vendors…',
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.readOnly = false,
    this.autofocus = false,
  });

  final String hint;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final bool readOnly;
  final bool autofocus;

  @override
  State<SearchBarPremium> createState() => _SearchBarPremiumState();
}

class _SearchBarPremiumState extends State<SearchBarPremium> {
  final TextEditingController _ctrl = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _ctrl.addListener(() {
      final next = _ctrl.text.isNotEmpty;
      if (next != _hasText) setState(() => _hasText = next);
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _clear() {
    HapticFeedback.lightImpact();
    _ctrl.clear();
    widget.onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.readOnly
          ? () {
              HapticFeedback.lightImpact();
              widget.onTap?.call();
            }
          : null,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          // Glassmorphism: white with subtle blur-tinted border
          color: CoreTheme.surface,
          borderRadius: BorderRadius.circular(CoreTheme.radiusLg),
          border: Border.all(
            color: CoreTheme.border,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: CoreTheme.primary.withValues(alpha: 0.05),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: CoreTheme.spacingMd),
            Icon(
              Icons.search_rounded,
              color: _hasText ? CoreTheme.primary : CoreTheme.textHint,
              size: 20,
            ),
            const SizedBox(width: CoreTheme.spacingSm),
            Expanded(
              child: TextField(
                controller: _ctrl,
                readOnly: widget.readOnly,
                autofocus: widget.autofocus,
                onChanged: widget.onChanged,
                onSubmitted: widget.onSubmitted,
                onTap: widget.readOnly
                    ? null
                    : () => widget.onTap?.call(),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: CoreTheme.textPrimary,
                    ),
                decoration: InputDecoration(
                  hintText: widget.hint,
                  hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: CoreTheme.textHint,
                      ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                cursorColor: CoreTheme.primary,
                textInputAction: TextInputAction.search,
              ),
            ),
            if (_hasText) ...[
              GestureDetector(
                onTap: _clear,
                child: Container(
                  width: 28,
                  height: 28,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: CoreTheme.border,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    size: 14,
                    color: CoreTheme.textSecondary,
                  ),
                ),
              ),
            ] else ...[
              // Filter chip
              GestureDetector(
                onTap: () => HapticFeedback.lightImpact(),
                child: Container(
                  width: 36,
                  height: 36,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: CoreTheme.primaryLight,
                    borderRadius: BorderRadius.circular(CoreTheme.radiusSm),
                  ),
                  child: const Icon(
                    Icons.tune_rounded,
                    size: 16,
                    color: CoreTheme.primary,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
