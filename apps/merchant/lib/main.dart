import 'package:flutter/material.dart';
import 'package:gijima_ops/gijima_ops.dart';

void main() => runApp(OpsApp(
  role: 'Merchant',
  subtitle: 'Manage and prepare example marketplace orders.',
  icon: Icons.storefront_rounded,
  metricTitle: 'Demo orders',
  tasks: [
    DemoTask('GM-1001 • Fresh Corner', 'Bread × 2 • Milk × 1 • R60.97', ['New order', 'Accepted', 'Preparing', 'Ready for pickup']),
    DemoTask('GM-1002 • Fresh Corner', 'Eggs × 1 • R39.99', ['New order', 'Accepted', 'Preparing', 'Ready for pickup']),
  ],
));
