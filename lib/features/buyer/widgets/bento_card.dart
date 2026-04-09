import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme.dart';
import '../models/buyer_product_model.dart';
import '../screens/category_detail_screen.dart';

/// Reusable bento grid cell. Tapping navigates to [CategoryDetailScreen].
class BentoCard extends StatefulWidget {
  const BentoCard({
    super.key,
    required this.category,
    required this.height,
    this.flex = 1,
  });

  final BuyerCategoryModel category;
  final double height;
  final int flex;

  @override
  State<BentoCard> createState() => _BentoCardState();
}

class _BentoCardState extends State<BentoCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.96,
      upperBound: 1.0,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Color get _accent => Color(widget.category.accentColor);

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _ctrl,
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  CategoryDetailScreen(category: widget.category),
            ),
          );
        },
        onTapDown: (_) => _ctrl.reverse(),
        onTapUp: (_) => _ctrl.forward(),
        onTapCancel: () => _ctrl.forward(),
        child: Container(
          height: widget.height,
          padding: const EdgeInsets.all(CoreTheme.spacingMd),
          decoration: BoxDecoration(
            color: _accent.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(CoreTheme.radiusLg),
            border: Border.all(
              color: _accent.withValues(alpha: 0.18),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon badge
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: _accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(CoreTheme.radiusSm),
                ),
                child: Icon(
                  _iconFor(widget.category.id),
                  color: _accent,
                  size: 18,
                ),
              ),

              const Spacer(),

              Text(
                widget.category.label,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: CoreTheme.textPrimary,
                      height: 1.2,
                    ),
              ),

              if (widget.category.sublabel != null) ...[
                const SizedBox(height: 2),
                Text(
                  widget.category.sublabel!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: _accent,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  static IconData _iconFor(String id) => switch (id) {
        'flash' => Icons.flash_on_rounded,
        'new' => Icons.new_releases_outlined,
        'electronics' => Icons.devices_rounded,
        'fashion' => Icons.checkroom_rounded,
        'food' => Icons.restaurant_rounded,
        _ => Icons.category_outlined,
      };
}
