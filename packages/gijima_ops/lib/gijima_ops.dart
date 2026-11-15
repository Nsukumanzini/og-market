import 'package:flutter/material.dart';

const brandGreen = Color(0xFF087F5B);
const brandInk = Color(0xFF202A30);

class DemoTask {
  DemoTask(this.title, this.detail, this.states);
  final String title, detail;
  final List<String> states;
  int step = 0;
  String get status => states[step];
  bool get finished => step == states.length - 1;
}

class OpsApp extends StatelessWidget {
  const OpsApp({super.key, required this.role, required this.subtitle, required this.icon, required this.tasks, required this.metricTitle});
  final String role, subtitle, metricTitle;
  final IconData icon;
  final List<DemoTask> tasks;
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Gijima Mfana $role',
    theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: brandGreen, primary: brandGreen), scaffoldBackgroundColor: const Color(0xFFF6F8F7)),
    home: _Dashboard(role: role, subtitle: subtitle, icon: icon, tasks: tasks, metricTitle: metricTitle),
  );
}

class _Dashboard extends StatefulWidget {
  const _Dashboard({required this.role, required this.subtitle, required this.icon, required this.tasks, required this.metricTitle});
  final String role, subtitle, metricTitle;
  final IconData icon;
  final List<DemoTask> tasks;
  @override
  State<_Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<_Dashboard> {
  bool showComplete = false;
  @override
  Widget build(BuildContext context) {
    final completed = widget.tasks.where((t) => t.finished).length;
    final visible = showComplete ? widget.tasks.where((t) => t.finished) : widget.tasks.where((t) => !t.finished);
    return Scaffold(
      appBar: AppBar(title: Text('Gijima Mfana • ${widget.role}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 19)), backgroundColor: const Color(0xFFF6F8F7)),
      body: SafeArea(child: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 900), child: ListView(padding: const EdgeInsets.all(20), children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(color: brandGreen, borderRadius: BorderRadius.circular(24)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(widget.icon, color: Colors.white, size: 34),
            const SizedBox(height: 16),
            Text(widget.role, style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            Text(widget.subtitle, style: const TextStyle(color: Colors.white70, fontSize: 15)),
            const SizedBox(height: 15),
            const Text('ERMELO • DEMO MODE', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1.5)),
          ]),
        ),
        const SizedBox(height: 20),
        Row(children: [
          Expanded(child: _Metric(label: widget.metricTitle, value: '${widget.tasks.length}')),
          const SizedBox(width: 12),
          Expanded(child: _Metric(label: 'Completed', value: '$completed')),
        ]),
        const SizedBox(height: 24),
        Row(children: [
          Expanded(child: Text(showComplete ? 'Completed' : 'Action required', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: brandInk))),
          TextButton(onPressed: () => setState(() => showComplete = !showComplete), child: Text(showComplete ? 'View active' : 'View completed')),
        ]),
        const SizedBox(height: 8),
        if (visible.isEmpty)
          const Card(child: Padding(padding: EdgeInsets.all(24), child: Text('Nothing to display.')))
        else
          for (final task in visible) Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Card(
              color: Colors.white, elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Text(task.title, style: const TextStyle(color: brandInk, fontSize: 17, fontWeight: FontWeight.w800)),
                const SizedBox(height: 6), Text(task.detail),
                const SizedBox(height: 12),
                Text('Status: ${task.status}', style: const TextStyle(color: brandGreen, fontWeight: FontWeight.w700)),
                if (!task.finished) ...[
                  const SizedBox(height: 12),
                  FilledButton(onPressed: () => setState(() => task.step++), child: Text(task.states[task.step + 1])),
                ],
              ])),
            ),
          ),
        const SizedBox(height: 20),
        const Text('This is an independent mock application. Changes are in memory and are not synchronized with any other app.', style: TextStyle(color: Colors.grey, fontSize: 12)),
      ])))),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});
  final String label, value;
  @override
  Widget build(BuildContext context) => Card(
    elevation: 0, color: Colors.white,
    child: Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(value, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: brandGreen)),
      const SizedBox(height: 4), Text(label),
    ])),
  );
}
