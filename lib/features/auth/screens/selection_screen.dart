import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme.dart';
import '../../buyer/screens/buyer_home_screen.dart';
import '../../seller/screens/seller_dashboard.dart';

enum SelectionMode { login, register }

class SelectionScreen extends StatelessWidget {
  const SelectionScreen({super.key, required this.mode});

  final SelectionMode mode;

  String get _title =>
      mode == SelectionMode.register ? 'Register as...' : 'Login as...';

  String get _subtitle => mode == SelectionMode.register
      ? 'Choose how you want to use OG Market.'
      : 'Select your account type to continue.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CoreTheme.background,
      appBar: AppBar(
        backgroundColor: CoreTheme.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: CoreTheme.primary,
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: CoreTheme.spacingLg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: CoreTheme.spacingMd),

              // ── Header ─────────────────────────────────────────────────
              Text(
                _title,
                style: Theme.of(context).textTheme.displayMedium,
              ),

              const SizedBox(height: CoreTheme.spacingSm),

              Text(
                _subtitle,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: CoreTheme.textSecondary,
                    ),
              ),

              const SizedBox(height: CoreTheme.spacingXxl),

              // ── Buyer Card ─────────────────────────────────────────────
              _SelectionCard(
                title: mode == SelectionMode.register
                    ? 'Register as Buyer'
                    : 'Login as Buyer',
                description: mode == SelectionMode.register
                    ? 'Discover and purchase products from\nverified local sellers.'
                    : 'Access your buyer account and\nbrowse the marketplace.',
                icon: Icons.shopping_bag_outlined,
                accentColor: CoreTheme.primary,
                features: mode == SelectionMode.register
                    ? ['Phone number only', 'Instant access', 'Buyer protection']
                    : ['Secure login', 'Order history', 'Saved items'],
                onTap: () {
                  HapticFeedback.heavyImpact();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const BuyerHomeScreen()),
                    (route) => false,
                  );
                },
              ),

              const SizedBox(height: CoreTheme.spacingMd),

              // ── Seller Card ────────────────────────────────────────────
              _SelectionCard(
                title: mode == SelectionMode.register
                    ? 'Register as Seller'
                    : 'Login as Seller',
                description: mode == SelectionMode.register
                    ? 'List your products and grow\nyour business on OG Market.'
                    : 'Manage your store, orders,\nand sales performance.',
                icon: Icons.storefront_outlined,
                accentColor: const Color(0xFF6366F1), // Indigo for contrast
                features: mode == SelectionMode.register
                    ? ['ID verification required', 'Business profile', 'Analytics']
                    : ['Seller dashboard', 'Real-time orders', 'Revenue stats'],
                onTap: () {
                  HapticFeedback.heavyImpact();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const SellerDashboard()),
                    (route) => false,
                  );
                },
              ),

              const Spacer(),

              // ── Footnote ───────────────────────────────────────────────
              if (mode == SelectionMode.register)
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: CoreTheme.spacingLg),
                  child: Text(
                    'Seller accounts require ID/Business verification\nto protect all buyers on the platform.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: CoreTheme.textHint,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Selection Card ───────────────────────────────────────────────────────────

class _SelectionCard extends StatefulWidget {
  const _SelectionCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.accentColor,
    required this.features,
    required this.onTap,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color accentColor;
  final List<String> features;
  final VoidCallback onTap;

  @override
  State<_SelectionCard> createState() => _SelectionCardState();
}

class _SelectionCardState extends State<_SelectionCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.97,
      upperBound: 1.0,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _ctrl,
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) => _ctrl.reverse(),
        onTapUp: (_) => _ctrl.forward(),
        onTapCancel: () => _ctrl.forward(),
        child: Container(
          padding: const EdgeInsets.all(CoreTheme.spacingLg),
          decoration: BoxDecoration(
            color: CoreTheme.background,
            borderRadius: BorderRadius.circular(CoreTheme.radiusXl),
            border: Border.all(color: CoreTheme.border, width: 1.5),
            boxShadow: CoreTheme.elevatedShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Icon badge
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: widget.accentColor.withValues(alpha: 0.1),
                      borderRadius:
                          BorderRadius.circular(CoreTheme.radiusMd),
                    ),
                    child: Icon(
                      widget.icon,
                      color: widget.accentColor,
                      size: 26,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: widget.accentColor.withValues(alpha: 0.08),
                      borderRadius:
                          BorderRadius.circular(CoreTheme.radiusSm),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Select',
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: widget.accentColor,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.3,
                                  ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 12,
                          color: widget.accentColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: CoreTheme.spacingMd),

              Text(
                widget.title,
                style: Theme.of(context).textTheme.headlineMedium,
              ),

              const SizedBox(height: CoreTheme.spacingXs),

              Text(
                widget.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              const SizedBox(height: CoreTheme.spacingMd),

              // Feature pills
              Wrap(
                spacing: CoreTheme.spacingSm,
                runSpacing: CoreTheme.spacingXs,
                children: widget.features
                    .map(
                      (f) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: CoreTheme.surface,
                          borderRadius:
                              BorderRadius.circular(CoreTheme.radiusSm),
                          border: Border.all(
                            color: CoreTheme.border,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          f,
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
            ],
          ),
        ),
      ),
    );
  }
}
