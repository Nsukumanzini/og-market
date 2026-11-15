import 'package:flutter/material.dart';
import 'package:gijima_ops/gijima_ops.dart';

void main() => runApp(OpsApp(
  role: 'Admin',
  subtitle: 'Review mock merchant and courier applications.',
  icon: Icons.dashboard_rounded,
  metricTitle: 'Demo applications',
  tasks: [
    DemoTask('Merchant application • Fresh Corner', 'Example grocery merchant • Verification required', ['Pending review', 'Under review', 'Approved']),
    DemoTask('Courier application • Demo applicant', 'Example delivery partner • Verification required', ['Pending review', 'Under review', 'Approved']),
  ],
));
