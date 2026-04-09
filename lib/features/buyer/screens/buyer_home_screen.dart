import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme.dart';
import '../models/buyer_product_model.dart';
import '../widgets/bento_card.dart';
import '../widgets/search_bar_premium.dart';
import '../widgets/vendor_circle_avatar.dart';
import 'product_detail_screen.dart';

class BuyerHomeScreen extends StatelessWidget {
  const BuyerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CoreTheme.background,
      appBar: AppBar(
        title: const Text('OG Market'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () => HapticFeedback.lightImpact(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: CoreTheme.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Greeting ─────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: CoreTheme.spacingLg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Good morning 👋',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: CoreTheme.textSecondary,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'What are you\nlooking for?',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: CoreTheme.spacingLg),

              // ── Search bar (read-only, opens a search screen) ─────────
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: CoreTheme.spacingLg,
                ),
                child: SearchBarPremium(
                  readOnly: true,
                  onTap: () {
                    // TODO: push SearchScreen
                  },
                ),
              ),

              const SizedBox(height: CoreTheme.spacingLg),

              // ── Bento Grid ────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: CoreTheme.spacingLg,
                ),
                child: _BentoSection(),
              ),

              const SizedBox(height: CoreTheme.spacingXl),

              // ── Top Vendors ───────────────────────────────────────────
              _SectionHeader(
                title: 'Top Vendors',
                onSeeAll: () {},
              ),
              const SizedBox(height: CoreTheme.spacingMd),
              _VendorRowScroll(),

              const SizedBox(height: CoreTheme.spacingXl),

              // ── Featured ──────────────────────────────────────────────
              _SectionHeader(
                title: 'Featured',
                onSeeAll: () {},
              ),
              const SizedBox(height: CoreTheme.spacingMd),

              ..._featuredItems(context),

              const SizedBox(height: CoreTheme.spacingLg),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _BottomNav(),
    );
  }

  List<Widget> _featuredItems(BuildContext context) {
    final items = [
      ...BuyerMockData.flashDeals,
      ...BuyerMockData.newArrivals,
    ];
    return items
        .map(
          (product) => Padding(
            padding: const EdgeInsets.fromLTRB(
              CoreTheme.spacingLg,
              0,
              CoreTheme.spacingLg,
              CoreTheme.spacingMd,
            ),
            child: _FeaturedProductCard(product: product),
          ),
        )
        .toList();
  }
}

// ── Bento Section ─────────────────────────────────────────────────────────────

class _BentoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cats = BuyerMockData.bentoCategories;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: BentoCard(category: cats[0], height: 148),
            ),
            const SizedBox(width: CoreTheme.spacingSm),
            Expanded(
              flex: 2,
              child: BentoCard(category: cats[1], height: 148),
            ),
          ],
        ),
        const SizedBox(height: CoreTheme.spacingSm),
        Row(
          children: [
            Expanded(child: BentoCard(category: cats[2], height: 100)),
            const SizedBox(width: CoreTheme.spacingSm),
            Expanded(child: BentoCard(category: cats[3], height: 100)),
            const SizedBox(width: CoreTheme.spacingSm),
            Expanded(child: BentoCard(category: cats[4], height: 100)),
          ],
        ),
      ],
    );
  }
}

// ── Vendor Row Scroll ─────────────────────────────────────────────────────────

class _VendorRowScroll extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: CoreTheme.spacingLg),
        itemCount: BuyerMockData.vendors.length,
        separatorBuilder: (context, index) =>
            const SizedBox(width: CoreTheme.spacingLg),
        itemBuilder: (_, i) => VendorCircleAvatar(
          vendor: BuyerMockData.vendors[i],
          size: 52,
        ),
      ),
    );
  }
}

// ── Section Header ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.onSeeAll});
  final String title;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: CoreTheme.spacingLg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineMedium),
          TextButton(onPressed: onSeeAll, child: const Text('See all')),
        ],
      ),
    );
  }
}

// ── Featured Product Card ─────────────────────────────────────────────────────

class _FeaturedProductCard extends StatelessWidget {
  const _FeaturedProductCard({required this.product});
  final BuyerProductModel product;

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
        padding: const EdgeInsets.all(CoreTheme.spacingMd),
        decoration: BoxDecoration(
          color: CoreTheme.background,
          borderRadius: BorderRadius.circular(CoreTheme.radiusLg),
          border: Border.all(color: CoreTheme.border, width: 1),
          boxShadow: CoreTheme.cardShadow,
        ),
        child: Row(
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: CoreTheme.primaryLight,
                borderRadius: BorderRadius.circular(CoreTheme.radiusMd),
              ),
              child: const Icon(
                Icons.image_outlined,
                color: CoreTheme.primary,
                size: 28,
              ),
            ),
            const SizedBox(width: CoreTheme.spacingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.category,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: CoreTheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.title,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.vendorName,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        product.formattedPrice,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: CoreTheme.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                      ),
                      if (product.rating > 0) ...[
                        const Spacer(),
                        const Icon(
                          Icons.star_rounded,
                          size: 13,
                          color: Color(0xFFF59E0B),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          product.rating.toStringAsFixed(1),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => HapticFeedback.heavyImpact(),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: CoreTheme.primaryLight,
                  borderRadius: BorderRadius.circular(CoreTheme.radiusSm),
                ),
                child: const Icon(
                  Icons.add_rounded,
                  color: CoreTheme.primary,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Bottom Nav ───────────────────────────────────────────────────────────────

class _BottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CoreTheme.background,
        border: Border(
          top: BorderSide(color: CoreTheme.border, width: 1),
        ),
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: CoreTheme.primary,
        unselectedItemColor: CoreTheme.textSecondary,
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
