import 'package:flutter/material.dart';
import 'package:gijima_ops/gijima_ops.dart';

void main() => runApp(OpsApp(
  role: 'Courier',
  subtitle: 'Manage mock delivery tasks around Ermelo.',
  icon: Icons.local_shipping_rounded,
  metricTitle: 'Demo deliveries',
  tasks: [
    DemoTask('DEL-201 • Marketplace delivery', 'Fresh Corner → Ermelo Central • Demo fee R25.00', ['Available', 'Accepted', 'Collected', 'Delivered']),
    DemoTask('DEL-202 • Collection request', 'Example store → Ermelo • Demo fee R30.00', ['Available', 'Accepted', 'Collected', 'Delivered']),
  ],
));
