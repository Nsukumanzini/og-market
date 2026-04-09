import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme.dart';
import 'selection_screen.dart';

class EntryScreen extends StatelessWidget {
  const EntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: CoreTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: CoreTheme.spacingLg,
            vertical: CoreTheme.spacingMd,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),

              // ── Logo ───────────────────────────────────────────────────
              Center(
                child: _OGLogo(size: size.width * 0.45),
              ),

              const SizedBox(height: CoreTheme.spacingXl),

              // ── Headline ───────────────────────────────────────────────
              Text(
                'Welcome to\nOG Market',
                style: Theme.of(context).textTheme.displayLarge,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: CoreTheme.spacingSm),

              Text(
                'South Africa\'s premium marketplace.\nBuy and sell with confidence.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: CoreTheme.textSecondary,
                    ),
                textAlign: TextAlign.center,
              ),

              const Spacer(flex: 3),

              // ── Register CTA ───────────────────────────────────────────
              _EntryButton(
                label: 'Register',
                subtitle: 'Create a new account',
                icon: Icons.person_add_outlined,
                isPrimary: true,
                onTap: () {
                  HapticFeedback.heavyImpact();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SelectionScreen(
                        mode: SelectionMode.register,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: CoreTheme.spacingMd),

              // ── Login CTA ──────────────────────────────────────────────
              _EntryButton(
                label: 'Login',
                subtitle: 'Access your account',
                icon: Icons.login_rounded,
                isPrimary: false,
                onTap: () {
                  HapticFeedback.heavyImpact();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SelectionScreen(
                        mode: SelectionMode.login,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: CoreTheme.spacingXl),

              // ── Legal footnote ─────────────────────────────────────────
              Text(
                'By continuing you agree to our Terms of Service\nand Privacy Policy.',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: CoreTheme.spacingMd),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Logo Widget ─────────────────────────────────────────────────────────────

class _OGLogo extends StatelessWidget {
  const _OGLogo({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: CoreTheme.primaryLight,
        borderRadius: BorderRadius.circular(CoreTheme.radiusXl),
        boxShadow: CoreTheme.cardShadow,
        border: Border.all(
          color: CoreTheme.primary.withValues(alpha: 0.15),
          width: 1.5,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: size * 0.45,
              height: size * 0.45,
              decoration: BoxDecoration(
                color: CoreTheme.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: CoreTheme.primary.withValues(alpha: 0.35),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'OG',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: size * 0.16,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -1,
                  ),
                ),
              ),
            ),
            SizedBox(height: size * 0.06),
            Text(
              'MARKET',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: size * 0.085,
                fontWeight: FontWeight.w700,
                color: CoreTheme.primary,
                letterSpacing: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Entry Button Card ────────────────────────────────────────────────────────

class _EntryButton extends StatefulWidget {
  const _EntryButton({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.isPrimary,
    required this.onTap,
  });

  final String label;
  final String subtitle;
  final IconData icon;
  final bool isPrimary;
  final VoidCallback onTap;

  @override
  State<_EntryButton> createState() => _EntryButtonState();
}

class _EntryButtonState extends State<_EntryButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

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
    _scale = _ctrl;
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onTapDown(_) => _ctrl.reverse();
  void _onTapUp(_) => _ctrl.forward();
  void _onTapCancel() => _ctrl.forward();

  @override
  Widget build(BuildContext context) {
    final bg = widget.isPrimary ? CoreTheme.primary : CoreTheme.background;
    final fg = widget.isPrimary ? Colors.white : CoreTheme.textPrimary;
    final iconBg = widget.isPrimary
        ? Colors.white.withValues(alpha: 0.2)
        : CoreTheme.primaryLight;
    final iconColor = widget.isPrimary ? Colors.white : CoreTheme.primary;
    final border = widget.isPrimary
        ? BorderSide.none
        : BorderSide(color: CoreTheme.border, width: 1.5);

    return ScaleTransition(
      scale: _scale,
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: CoreTheme.spacingLg,
            vertical: CoreTheme.spacingLg,
          ),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(CoreTheme.radiusLg),
            border: Border.fromBorderSide(border),
            boxShadow: widget.isPrimary ? CoreTheme.cardShadow : null,
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(CoreTheme.radiusSm),
                ),
                child: Icon(widget.icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: CoreTheme.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.label,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: fg,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: widget.isPrimary
                                ? Colors.white.withValues(alpha: 0.75)
                                : CoreTheme.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: iconColor.withValues(alpha: 0.7),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
