import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme.dart';

class SellerDashboard extends StatelessWidget {
  const SellerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CoreTheme.background,
      appBar: AppBar(
        title: const Text('Seller Central'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box_outlined),
            onPressed: () => HapticFeedback.lightImpact(),
            tooltip: 'Add listing',
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => HapticFeedback.lightImpact(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(CoreTheme.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Overview Banner ───────────────────────────────────────
              _OverviewBanner(),

              const SizedBox(height: CoreTheme.spacingLg),

              // ── Stats Grid ────────────────────────────────────────────
              Text(
                'Today\'s Performance',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: CoreTheme.spacingMd),
              _StatsGrid(),

              const SizedBox(height: CoreTheme.spacingLg),

              // ── Recent Orders ─────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Orders',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('View all'),
                  ),
                ],
              ),

              const SizedBox(height: CoreTheme.spacingMd),

              ..._recentOrders(context),

              const SizedBox(height: CoreTheme.spacingLg),

              // ── Quick Actions ─────────────────────────────────────────
              Text(
                'Quick Actions',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: CoreTheme.spacingMd),
              _QuickActions(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _recentOrders(BuildContext context) {
    final orders = [
      ('#OG-4821', 'Wireless Earbuds', 'R 349.00', 'Pending'),
      ('#OG-4820', 'Running Shoes', 'R 899.00', 'Shipped'),
      ('#OG-4819', 'Phone Case', 'R 89.00', 'Delivered'),
    ];
    return orders
        .map(
          (o) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _OrderRow(
              id: o.$1,
              item: o.$2,
              amount: o.$3,
              status: o.$4,
            ),
          ),
        )
        .toList();
  }
}

// ── Overview Banner ──────────────────────────────────────────────────────────

class _OverviewBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(CoreTheme.spacingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            CoreTheme.primary,
            const Color(0xFF00943C),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(CoreTheme.radiusXl),
        boxShadow: [
          BoxShadow(
            color: CoreTheme.primary.withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(CoreTheme.radiusSm),
                ),
                child: Text(
                  'Pro Seller',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: CoreTheme.spacingMd),
          Text(
            'Monthly Revenue',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.75),
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'R 12,450.00',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: CoreTheme.spacingSm),
          Row(
            children: [
              const Icon(
                Icons.trending_up_rounded,
                color: Colors.white,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                '+18.4% from last month',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Stats Grid ───────────────────────────────────────────────────────────────

class _StatsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final stats = [
      _StatData('Orders', '24', Icons.receipt_long_outlined,
          const Color(0xFF6366F1)),
      _StatData(
          'Views', '1.2K', Icons.visibility_outlined, const Color(0xFFF59E0B)),
      _StatData('Conversion', '3.8%', Icons.show_chart_rounded,
          CoreTheme.primary),
      _StatData('Rating', '4.9 ★', Icons.star_outline_rounded,
          const Color(0xFFEC4899)),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: CoreTheme.spacingMd,
      crossAxisSpacing: CoreTheme.spacingMd,
      childAspectRatio: 1.5,
      children: stats.map((s) => _StatCard(data: s)).toList(),
    );
  }
}

class _StatData {
  const _StatData(this.label, this.value, this.icon, this.color);
  final String label;
  final String value;
  final IconData icon;
  final Color color;
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.data});
  final _StatData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(CoreTheme.spacingMd),
      decoration: BoxDecoration(
        color: CoreTheme.background,
        borderRadius: BorderRadius.circular(CoreTheme.radiusLg),
        border: Border.all(color: CoreTheme.border, width: 1),
        boxShadow: CoreTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: data.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(CoreTheme.radiusSm),
            ),
            child: Icon(data.icon, color: data.color, size: 16),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.value,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: CoreTheme.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              Text(
                data.label,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Order Row ────────────────────────────────────────────────────────────────

class _OrderRow extends StatelessWidget {
  const _OrderRow({
    required this.id,
    required this.item,
    required this.amount,
    required this.status,
  });

  final String id;
  final String item;
  final String amount;
  final String status;

  Color _statusColor() {
    return switch (status) {
      'Pending' => const Color(0xFFF59E0B),
      'Shipped' => const Color(0xFF6366F1),
      'Delivered' => CoreTheme.primary,
      _ => CoreTheme.textSecondary,
    };
  }

  @override
  Widget build(BuildContext context) {
    final color = _statusColor();
    return Container(
      padding: const EdgeInsets.all(CoreTheme.spacingMd),
      decoration: BoxDecoration(
        color: CoreTheme.background,
        borderRadius: BorderRadius.circular(CoreTheme.radiusLg),
        border: Border.all(color: CoreTheme.border, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  id,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: CoreTheme.textHint,
                        letterSpacing: 0.5,
                      ),
                ),
                const SizedBox(height: 2),
                Text(item, style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: CoreTheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 2),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Quick Actions ────────────────────────────────────────────────────────────

class _QuickActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final actions = [
      (Icons.add_photo_alternate_outlined, 'Add Listing', CoreTheme.primary),
      (Icons.inventory_2_outlined, 'Inventory', const Color(0xFF6366F1)),
      (Icons.bar_chart_rounded, 'Analytics', const Color(0xFFF59E0B)),
      (Icons.support_agent_rounded, 'Support', const Color(0xFFEC4899)),
    ];

    return Row(
      children: actions.asMap().entries.map((entry) {
        final i = entry.key;
        final a = entry.value;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: i < actions.length - 1 ? CoreTheme.spacingSm : 0,
            ),
            child: GestureDetector(
              onTap: () => HapticFeedback.heavyImpact(),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: CoreTheme.spacingMd),
                decoration: BoxDecoration(
                  color: a.$3.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(CoreTheme.radiusMd),
                  border: Border.all(
                    color: a.$3.withValues(alpha: 0.15),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(a.$1, color: a.$3, size: 24),
                    const SizedBox(height: 6),
                    Text(
                      a.$2,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: CoreTheme.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
