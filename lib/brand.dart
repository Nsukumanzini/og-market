import 'package:flutter/material.dart';

const emerald = Color(0xFF087F5B);
const charcoal = Color(0xFF202A30);
const canvas = Color(0xFFF6F8F7);
const paleGreen = Color(0xFFE7F4EE);

ThemeData gijimaTheme() {
  final scheme = ColorScheme.fromSeed(seedColor: emerald, primary: emerald, secondary: charcoal, surface: Colors.white);
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: canvas,
    appBarTheme: const AppBarTheme(backgroundColor: canvas, foregroundColor: charcoal, elevation: 0, scrolledUnderElevation: 0),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(fontSize: 28, height: 1.15, fontWeight: FontWeight.w800, color: charcoal),
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: charcoal),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: charcoal),
      bodyMedium: TextStyle(fontSize: 14, color: charcoal, height: 1.4),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFFE0E7E2))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFFE0E7E2))),
    ),
    filledButtonTheme: FilledButtonThemeData(style: FilledButton.styleFrom(
      backgroundColor: emerald,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    )),
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: paleGreen,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    ),
  );
}

class Surface extends StatelessWidget {
  const Surface({super.key, required this.child, this.padding = const EdgeInsets.all(16), this.color = Colors.white});
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    padding: padding,
    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFE5ECE7))),
    child: child,
  );
}

class SectionHeading extends StatelessWidget {
  const SectionHeading(this.title, {super.key, this.action, this.onTap});
  final String title;
  final String? action;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(child: Text(title, style: Theme.of(context).textTheme.titleLarge)),
      if (action != null) TextButton(onPressed: onTap, child: Text(action!)),
    ],
  );
}
