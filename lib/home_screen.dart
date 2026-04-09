import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'mock_data.dart';
import 'theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Home Screen
// ─────────────────────────────────────────────────────────────────────────────

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final AnimationController _entryController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();

    _entryController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOutCubic,
    ));

    _scrollController.addListener(() {
      final scrolled = _scrollController.offset > 60;
      if (scrolled != _isScrolled) {
        setState(() => _isScrolled = scrolled);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _entryController.forward();
    });
  }

  @override
  void dispose() {
    _entryController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OGTheme.background,
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: _AppBarDelegate(isScrolled: _isScrolled),
          ),
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      _SectionHeader(light: 'Browse', bold: 'Categories'),
                      const SizedBox(height: 14),
                      const _BentoGrid(),
                      const SizedBox(height: 28),
                      _SectionHeader(light: 'Verified', bold: 'Vendors'),
                      const SizedBox(height: 14),
                      const _VendorsRow(),
                      const SizedBox(height: 28),
                      _SectionHeader(light: 'Fresh', bold: 'Finds'),
                      const SizedBox(height: 14),
                      const _FreshFindsMasonry(),
                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sliver App Bar Delegate
// ─────────────────────────────────────────────────────────────────────────────

class _AppBarDelegate extends SliverPersistentHeaderDelegate {
  final bool isScrolled;
  const _AppBarDelegate({required this.isScrolled});

  @override
  double get minExtent => 100;

  @override
  double get maxExtent => 148;

  @override
  bool shouldRebuild(_AppBarDelegate old) => old.isScrolled != isScrolled;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final progress = (shrinkOffset / maxExtent).clamp(0.0, 1.0);
    final topPadding = MediaQuery.of(context).padding.top;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: isScrolled ? 24 : 0,
          sigmaY: isScrolled ? 24 : 0,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: isScrolled
                ? Colors.black.withValues(alpha: 0.72)
                : Colors.transparent,
            border: isScrolled
                ? Border(
                    bottom: BorderSide(
                      color: OGTheme.border,
                      width: 0.5,
                    ),
                  )
                : null,
          ),
          padding: EdgeInsets.fromLTRB(16, topPadding + 10, 16, 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: progress < 0.45 ? 1.0 : 0.0,
                          child: Text(
                            'Good morning 👋',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: OGTheme.textSecondary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          'OG Market',
                          style: GoogleFonts.inter(
                            fontSize: progress > 0.5 ? 20 : 26,
                            fontWeight: FontWeight.w800,
                            color: OGTheme.textPrimary,
                            letterSpacing: -1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Profile avatar button
                  GestureDetector(
                    onTap: () => HapticFeedback.lightImpact(),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: OGTheme.surfaceElevated,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: OGTheme.border,
                          width: 0.5,
                        ),
                      ),
                      child: const Center(
                        child: Text('🧑🏾', style: TextStyle(fontSize: 21)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Search bar
              GestureDetector(
                onTap: () => HapticFeedback.lightImpact(),
                child: Container(
                  height: 42,
                  decoration: BoxDecoration(
                    color: OGTheme.surfaceElevated,
                    borderRadius: BorderRadius.circular(OGTheme.radiusSm),
                    border: Border.all(color: OGTheme.border, width: 0.5),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 14),
                      Icon(
                        LucideIcons.search,
                        size: 15,
                        color: OGTheme.textSecondary,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Search local services...',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: OGTheme.textSecondary,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Section Header
// ─────────────────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String light;
  final String bold;
  const _SectionHeader({required this.light, required this.bold});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$light ',
          style: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.w300,
            color: OGTheme.textSecondary,
            letterSpacing: -0.4,
          ),
        ),
        Text(
          bold,
          style: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: OGTheme.textPrimary,
            letterSpacing: -0.4,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bento Grid
// ─────────────────────────────────────────────────────────────────────────────

class _BentoGrid extends StatelessWidget {
  const _BentoGrid();

  static const _rowHeight = 215.0;
  static const _gap = 10.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Row 1: large 2/3 card + two stacked 1/3 cards
        SizedBox(
          height: _rowHeight,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 62,
                child: _BentoCard(
                  label: 'Food & Groceries',
                  subtitle: '240+ vendors',
                  icon: '🛒',
                  isPrimary: true,
                  onTap: () => HapticFeedback.lightImpact(),
                ),
              ),
              const SizedBox(width: _gap),
              Expanded(
                flex: 38,
                child: Column(
                  children: [
                    Expanded(
                      child: _BentoCard(
                        label: 'Services',
                        subtitle: '80+ pros',
                        icon: '🔧',
                        isPrimary: false,
                        onTap: () => HapticFeedback.lightImpact(),
                      ),
                    ),
                    const SizedBox(height: _gap),
                    Expanded(
                      child: _BentoCard(
                        label: 'Electronics',
                        subtitle: '120+ items',
                        icon: '💻',
                        isPrimary: false,
                        onTap: () => HapticFeedback.lightImpact(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: _gap),
        // Row 2: wide full-width card
        SizedBox(
          height: 92,
          child: _BentoCard(
            label: 'Featured: Local Artists',
            subtitle: 'Handcrafted originals — this week only',
            icon: '🎨',
            isPrimary: false,
            isWide: true,
            onTap: () => HapticFeedback.lightImpact(),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bento Card
// ─────────────────────────────────────────────────────────────────────────────

class _BentoCard extends StatefulWidget {
  final String label;
  final String subtitle;
  final String icon;
  final bool isPrimary;
  final bool isWide;
  final VoidCallback onTap;

  const _BentoCard({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.isPrimary,
    this.isWide = false,
    required this.onTap,
  });

  @override
  State<_BentoCard> createState() => _BentoCardState();
}

class _BentoCardState extends State<_BentoCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressCtrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _pressCtrl = AnimationController(
      duration: const Duration(milliseconds: 120),
      vsync: this,
    );
    _scale = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _pressCtrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _pressCtrl.forward(),
      onTapUp: (_) {
        _pressCtrl.reverse();
        widget.onTap();
      },
      onTapCancel: () => _pressCtrl.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: widget.isPrimary
                ? OGTheme.primary.withValues(alpha: 0.10)
                : OGTheme.surface,
            borderRadius: BorderRadius.circular(OGTheme.radiusLg),
            border: Border.all(
              color: widget.isPrimary
                  ? OGTheme.primary.withValues(alpha: 0.28)
                  : OGTheme.border,
              width: 0.5,
            ),
            gradient: widget.isPrimary
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      OGTheme.primary.withValues(alpha: 0.18),
                      OGTheme.primary.withValues(alpha: 0.04),
                    ],
                  )
                : null,
          ),
          padding: const EdgeInsets.all(14),
          child: widget.isWide
              ? _WideContent(
                  icon: widget.icon,
                  label: widget.label,
                  subtitle: widget.subtitle,
                )
              : _StackedContent(
                  icon: widget.icon,
                  label: widget.label,
                  subtitle: widget.subtitle,
                  isPrimary: widget.isPrimary,
                ),
        ),
      ),
    );
  }
}

class _WideContent extends StatelessWidget {
  final String icon, label, subtitle;
  const _WideContent({
    required this.icon,
    required this.label,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 36)),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: OGTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: OGTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Icon(
          LucideIcons.chevronRight,
          size: 18,
          color: OGTheme.textSecondary,
        ),
      ],
    );
  }
}

class _StackedContent extends StatelessWidget {
  final String icon, label, subtitle;
  final bool isPrimary;
  const _StackedContent({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(icon, style: TextStyle(fontSize: isPrimary ? 42 : 26)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: isPrimary ? 16 : 12,
                fontWeight: FontWeight.w700,
                color: OGTheme.textPrimary,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 4),
            if (isPrimary)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                decoration: BoxDecoration(
                  color: OGTheme.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              )
            else
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: OGTheme.textSecondary,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Verified Vendors Row
// ─────────────────────────────────────────────────────────────────────────────

class _VendorsRow extends StatelessWidget {
  const _VendorsRow();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 88,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: kVerifiedVendors.length,
        separatorBuilder: (_, _) => const SizedBox(width: 18),
        itemBuilder: (context, index) {
          final vendor = kVerifiedVendors[index];
          return GestureDetector(
            onTap: () => HapticFeedback.lightImpact(),
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: OGTheme.surfaceElevated,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: OGTheme.border,
                          width: 0.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          vendor['emoji'] as String,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                    // Verified checkmark badge
                    Positioned(
                      right: -1,
                      bottom: -1,
                      child: Container(
                        width: 19,
                        height: 19,
                        decoration: BoxDecoration(
                          color: OGTheme.primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: OGTheme.background,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          size: 11,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                Text(
                  vendor['name'] as String,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: OGTheme.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Fresh Finds Masonry Grid
// ─────────────────────────────────────────────────────────────────────────────

class _FreshFindsMasonry extends StatelessWidget {
  const _FreshFindsMasonry();

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      itemCount: kFreshFinds.length,
      itemBuilder: (context, index) {
        return _FreshFindCard(item: kFreshFinds[index]);
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Fresh Find Card
// ─────────────────────────────────────────────────────────────────────────────

class _FreshFindCard extends StatefulWidget {
  final Map<String, dynamic> item;
  const _FreshFindCard({required this.item});

  @override
  State<_FreshFindCard> createState() => _FreshFindCardState();
}

class _FreshFindCardState extends State<_FreshFindCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressCtrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _pressCtrl = AnimationController(
      duration: const Duration(milliseconds: 120),
      vsync: this,
    );
    _scale = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _pressCtrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final isTall = item['tall'] as bool;

    return GestureDetector(
      onTapDown: (_) => _pressCtrl.forward(),
      onTapUp: (_) {
        _pressCtrl.reverse();
        HapticFeedback.lightImpact();
      },
      onTapCancel: () => _pressCtrl.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          decoration: BoxDecoration(
            color: Color(item['tileColor'] as int),
            borderRadius: BorderRadius.circular(OGTheme.radiusMd),
            border: Border.all(color: OGTheme.border, width: 0.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Emoji image placeholder
              Container(
                height: isTall ? 140 : 105,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.04),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(OGTheme.radiusMd - 1),
                    topRight: Radius.circular(OGTheme.radiusMd - 1),
                  ),
                ),
                child: Center(
                  child: Text(
                    item['emoji'] as String,
                    style: TextStyle(fontSize: isTall ? 52 : 42),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['name'] as String,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: OGTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item['vendor'] as String,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: OGTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item['price'] as String,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: OGTheme.primary,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              LucideIcons.mapPin,
                              size: 11,
                              color: OGTheme.textSecondary,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              item['distance'] as String,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: OGTheme.textSecondary,
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
      ),
    );
  }
}
