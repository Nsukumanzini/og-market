import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme.dart';
import '../models/buyer_product_model.dart';
import '../widgets/vendor_circle_avatar.dart';

/// Full item/service detail page.
class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.product});

  final BuyerProductModel product;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool _saved = false;
  int _quantity = 1;

  VendorModel get _vendor => BuyerMockData.vendors.firstWhere(
        (v) => v.name == widget.product.vendorName,
        orElse: () => VendorModel(
          id: 'unknown',
          name: widget.product.vendorName,
          tagline: '',
          isVerified: widget.product.vendorIsVerified,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: CoreTheme.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: CoreTheme.background,
              shape: BoxShape.circle,
              boxShadow: CoreTheme.cardShadow,
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: CoreTheme.primary,
              size: 18,
            ),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              HapticFeedback.heavyImpact();
              setState(() => _saved = !_saved);
            },
            child: Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: CoreTheme.background,
                shape: BoxShape.circle,
                boxShadow: CoreTheme.cardShadow,
              ),
              child: Icon(
                _saved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                color: _saved ? CoreTheme.primary : CoreTheme.textSecondary,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          // ── Hero image area ──────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image placeholder
                  Container(
                    height: 300,
                    width: double.infinity,
                    color: CoreTheme.primary.withValues(alpha: 0.07),
                    child: Stack(
                      children: [
                        Center(
                          child: Icon(
                            Icons.image_outlined,
                            size: 72,
                            color: CoreTheme.primary.withValues(alpha: 0.25),
                          ),
                        ),
                        if (product.badge != null)
                          Positioned(
                            top: MediaQuery.of(context).padding.top + 56,
                            left: CoreTheme.spacingMd,
                            child: _BadgeLabel(badge: product.badge!),
                          ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(CoreTheme.spacingLg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category
                        Text(
                          product.category.toUpperCase(),
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: CoreTheme.primary,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.2,
                                  ),
                        ),

                        const SizedBox(height: 6),

                        // Title
                        Text(
                          product.title,
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),

                        const SizedBox(height: CoreTheme.spacingMd),

                        // Price + Rating row
                        Row(
                          children: [
                            Text(
                              product.formattedPrice,
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium
                                  ?.copyWith(
                                    color: CoreTheme.primary,
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                            const Spacer(),
                            if (product.rating > 0) _RatingBadge(product: product),
                          ],
                        ),

                        const SizedBox(height: CoreTheme.spacingLg),
                        const Divider(),
                        const SizedBox(height: CoreTheme.spacingMd),

                        // Vendor row
                        _VendorRow(vendor: _vendor),

                        const SizedBox(height: CoreTheme.spacingLg),
                        const Divider(),
                        const SizedBox(height: CoreTheme.spacingMd),

                        // Description
                        Text(
                          'About this item',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: CoreTheme.spacingSm),
                        Text(
                          product.description.isEmpty
                              ? 'No description provided.'
                              : product.description,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: CoreTheme.textSecondary,
                                height: 1.7,
                              ),
                        ),

                        const SizedBox(height: CoreTheme.spacingLg),

                        // Tags
                        if (product.tags.isNotEmpty) ...[
                          Wrap(
                            spacing: CoreTheme.spacingSm,
                            runSpacing: CoreTheme.spacingXs,
                            children: product.tags
                                .map(
                                  (t) => Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: CoreTheme.surface,
                                      borderRadius: BorderRadius.circular(
                                        CoreTheme.radiusSm,
                                      ),
                                      border: Border.all(
                                        color: CoreTheme.border,
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      '#$t',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: CoreTheme.textSecondary,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                          const SizedBox(height: CoreTheme.spacingXxl),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Bottom action bar ────────────────────────────────────────
          _BottomActionBar(
            product: product,
            quantity: _quantity,
            onDecrement: () {
              if (_quantity > 1) {
                HapticFeedback.lightImpact();
                setState(() => _quantity--);
              }
            },
            onIncrement: () {
              HapticFeedback.lightImpact();
              setState(() => _quantity++);
            },
            onAddToCart: () {
              HapticFeedback.heavyImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${product.title} added to cart'),
                  backgroundColor: CoreTheme.primary,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(CoreTheme.radiusSm),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ── Vendor Row ────────────────────────────────────────────────────────────────

class _VendorRow extends StatelessWidget {
  const _VendorRow({required this.vendor});
  final VendorModel vendor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        VendorCircleAvatar(vendor: vendor, size: 48, showLabel: false),
        const SizedBox(width: CoreTheme.spacingMd),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    vendor.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  if (vendor.isVerified) ...[
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.verified_rounded,
                      size: 16,
                      color: CoreTheme.primary,
                    ),
                  ],
                ],
              ),
              if (vendor.tagline.isNotEmpty)
                Text(
                  vendor.tagline,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
            ],
          ),
        ),
        TextButton(
          onPressed: () => HapticFeedback.lightImpact(),
          child: const Text('View Store'),
        ),
      ],
    );
  }
}

// ── Rating Badge ──────────────────────────────────────────────────────────────

class _RatingBadge extends StatelessWidget {
  const _RatingBadge({required this.product});
  final BuyerProductModel product;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(CoreTheme.radiusSm),
        border: Border.all(
          color: const Color(0xFFF59E0B).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, size: 16, color: Color(0xFFF59E0B)),
          const SizedBox(width: 4),
          Text(
            product.rating.toStringAsFixed(1),
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: const Color(0xFF92400E),
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(width: 4),
          Text(
            '(${product.reviewCount})',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF92400E),
                ),
          ),
        ],
      ),
    );
  }
}

// ── Badge label ───────────────────────────────────────────────────────────────

class _BadgeLabel extends StatelessWidget {
  const _BadgeLabel({required this.badge});
  final ProductBadge badge;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (badge) {
      ProductBadge.flashDeal => ('⚡ Flash Deal', const Color(0xFFEF4444)),
      ProductBadge.newArrival => ('✦ New Arrival', const Color(0xFF6366F1)),
      ProductBadge.bestSeller => ('★ Best Seller', CoreTheme.primary),
      ProductBadge.localFave => ('♥ Local Fave', const Color(0xFFF59E0B)),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(CoreTheme.radiusSm),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}

// ── Bottom Action Bar ─────────────────────────────────────────────────────────

class _BottomActionBar extends StatelessWidget {
  const _BottomActionBar({
    required this.product,
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
    required this.onAddToCart,
  });

  final BuyerProductModel product;
  final int quantity;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final VoidCallback onAddToCart;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        CoreTheme.spacingLg,
        CoreTheme.spacingMd,
        CoreTheme.spacingLg,
        CoreTheme.spacingMd + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: CoreTheme.background,
        border: Border(top: BorderSide(color: CoreTheme.border, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Quantity stepper
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: CoreTheme.border, width: 1.5),
              borderRadius: BorderRadius.circular(CoreTheme.radiusSm),
            ),
            child: Row(
              children: [
                _StepBtn(icon: Icons.remove_rounded, onTap: onDecrement),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: CoreTheme.spacingMd),
                  child: Text(
                    '$quantity',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                _StepBtn(icon: Icons.add_rounded, onTap: onIncrement),
              ],
            ),
          ),

          const SizedBox(width: CoreTheme.spacingMd),

          // Add to cart
          Expanded(
            child: ElevatedButton(
              onPressed: onAddToCart,
              child: Text(
                'Add to Cart · R ${(product.price * quantity).toStringAsFixed(2)}',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepBtn extends StatelessWidget {
  const _StepBtn({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Icon(icon, size: 18, color: CoreTheme.textPrimary),
      ),
    );
  }
}
