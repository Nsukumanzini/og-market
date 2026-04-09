import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme.dart';
import '../models/buyer_product_model.dart';

/// Verified vendor circle with initials, a green checkmark badge,
/// and an optional label underneath.
class VendorCircleAvatar extends StatelessWidget {
  const VendorCircleAvatar({
    super.key,
    required this.vendor,
    this.size = 56.0,
    this.showLabel = true,
    this.onTap,
  });

  final VendorModel vendor;

  /// Diameter of the circle.
  final double size;

  /// Whether to render the vendor name below the circle.
  final bool showLabel;

  final VoidCallback? onTap;

  // Deterministic accent color from vendor name
  Color get _avatarColor {
    final palette = [
      CoreTheme.primary,
      const Color(0xFF6366F1),
      const Color(0xFFF59E0B),
      const Color(0xFFEC4899),
      const Color(0xFF10B981),
      const Color(0xFF3B82F6),
    ];
    final index = vendor.name.codeUnitAt(0) % palette.length;
    return palette[index];
  }

  String get _initials {
    final parts = vendor.name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final badgeSize = size * 0.30;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap?.call();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size + badgeSize * 0.5,
            height: size + badgeSize * 0.5,
            child: Stack(
              children: [
                // Circle
                Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    color: _avatarColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _avatarColor.withValues(alpha: 0.25),
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      _initials,
                      style: TextStyle(
                        fontSize: size * 0.28,
                        fontWeight: FontWeight.w700,
                        color: _avatarColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),

                // Verified badge
                if (vendor.isVerified)
                  Positioned(
                    right: 0,
                    bottom: badgeSize * 0.25,
                    child: Container(
                      width: badgeSize,
                      height: badgeSize,
                      decoration: BoxDecoration(
                        color: CoreTheme.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: CoreTheme.background,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.check_rounded,
                        size: badgeSize * 0.55,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          if (showLabel) ...[
            const SizedBox(height: 6),
            SizedBox(
              width: size + 12,
              child: Text(
                vendor.name.split(' ').first, // first word only for compact UI
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: CoreTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
