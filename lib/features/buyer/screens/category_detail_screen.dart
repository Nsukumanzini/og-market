import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme.dart';
import '../models/buyer_product_model.dart';
import '../widgets/search_bar_premium.dart';
import 'product_detail_screen.dart';

/// Filtered product grid for a single category (e.g. "Best Kotas").
class CategoryDetailScreen extends StatefulWidget {
  const CategoryDetailScreen({super.key, required this.category});

  final BuyerCategoryModel category;

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  late List<BuyerProductModel> _filtered;
  String _query = '';

  Color get _accent => Color(widget.category.accentColor);

  @override
  void initState() {
    super.initState();
    _filtered = widget.category.products;
  }

  void _onSearch(String query) {
    setState(() {
      _query = query.toLowerCase();
      _filtered = widget.category.products
          .where((p) =>
              p.title.toLowerCase().contains(_query) ||
              p.vendorName.toLowerCase().contains(_query) ||
              p.tags.any((t) => t.contains(_query)))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CoreTheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.pop(context);
          },
        ),
        title: Text(widget.category.label),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort_rounded),
            onPressed: () => HapticFeedback.lightImpact(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ── Search ──────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(
                CoreTheme.spacingMd,
                CoreTheme.spacingSm,
                CoreTheme.spacingMd,
                CoreTheme.spacingMd,
              ),
              child: SearchBarPremium(
                hint: 'Search in ${widget.category.label}…',
                onChanged: _onSearch,
                autofocus: false,
              ),
            ),

            // ── Count badge ─────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: CoreTheme.spacingMd,
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: _accent.withValues(alpha: 0.1),
                      borderRadius:
                          BorderRadius.circular(CoreTheme.radiusSm),
                    ),
                    child: Text(
                      '${_filtered.length} item${_filtered.length == 1 ? '' : 's'}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: _accent,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: CoreTheme.spacingMd),

            // ── Product Grid ─────────────────────────────────────────────
            Expanded(
              child: _filtered.isEmpty
                  ? _EmptyState(query: _query, color: _accent)
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: CoreTheme.spacingMd,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: CoreTheme.spacingMd,
                        crossAxisSpacing: CoreTheme.spacingMd,
                        childAspectRatio: 0.72,
                      ),
                      itemCount: _filtered.length,
                      itemBuilder: (_, i) => _ProductGridCard(
                        product: _filtered[i],
                        accent: _accent,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Product Grid Card ─────────────────────────────────────────────────────────

class _ProductGridCard extends StatelessWidget {
  const _ProductGridCard({
    required this.product,
    required this.accent,
  });

  final BuyerProductModel product;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: CoreTheme.background,
          borderRadius: BorderRadius.circular(CoreTheme.radiusLg),
          border: Border.all(color: CoreTheme.border, width: 1),
          boxShadow: CoreTheme.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.07),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(CoreTheme.radiusLg),
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Icon(
                        Icons.image_outlined,
                        color: accent.withValues(alpha: 0.35),
                        size: 40,
                      ),
                    ),
                    if (product.badge != null)
                      Positioned(
                        top: 10,
                        left: 10,
                        child: _BadgeChip(badge: product.badge!),
                      ),
                  ],
                ),
              ),
            ),

            // Info
            Padding(
              padding: const EdgeInsets.all(CoreTheme.spacingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: CoreTheme.textPrimary,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.vendorName,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: CoreTheme.textHint,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.formattedPrice,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: CoreTheme.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                      ),
                      // Star rating
                      if (product.rating > 0)
                        Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              size: 12,
                              color: Color(0xFFF59E0B),
                            ),
                            const SizedBox(width: 2),
                            Text(
                              product.rating.toStringAsFixed(1),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: CoreTheme.textSecondary,
                                  ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Badge chip ────────────────────────────────────────────────────────────────

class _BadgeChip extends StatelessWidget {
  const _BadgeChip({required this.badge});
  final ProductBadge badge;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (badge) {
      ProductBadge.flashDeal => ('Flash', const Color(0xFFEF4444)),
      ProductBadge.newArrival => ('New', const Color(0xFF6366F1)),
      ProductBadge.bestSeller => ('Best Seller', CoreTheme.primary),
      ProductBadge.localFave => ('Local Fave', const Color(0xFFF59E0B)),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(CoreTheme.radiusSm),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.query, required this.color});
  final String query;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off_rounded, size: 56, color: color.withValues(alpha: 0.3)),
          const SizedBox(height: CoreTheme.spacingMd),
          Text(
            query.isEmpty ? 'No products yet' : 'No results for "$query"',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: CoreTheme.textSecondary),
          ),
        ],
      ),
    );
  }
}
