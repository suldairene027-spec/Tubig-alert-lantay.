// Tubig Alert Lantay - Water Supply Monitoring (Dart / Flutter)
// Barangay Lantay Water Monitoring
// Demo accounts:
//   admin    / admin123   (barangay water officer)
//   resident / lantay123  (resident)
// No extra packages needed. Put this file in lib/main.dart of a Flutter project.

import 'package:flutter/material.dart';

void main() => runApp(const TubigAlertApp());

const Color kBlue = Color(0xFF1565C0);
const Color kRed = Color(0xFFCC1A1A);
const Color kGreen = Color(0xFF1A9933);

// ---------------------------------------------------------------
// DATA MODELS AND SHARED APP DATA
// ---------------------------------------------------------------
class WaterAlert {
  final String title, message, time;
  WaterAlert(this.title, this.message, this.time);
}

class Report {
  final String purok, issue, details, time;
  Report(this.purok, this.issue, this.details, this.time);
}

class AppData {
  static String currentUser = '';
  static bool isAdmin = false;
  static String waterStatus = 'Available';

  static const statuses = [
    'Available',
    'Low Pressure',
    'No Water',
    'Scheduled Interruption',
  ];
  static const puroks = ['Purok 1', 'Purok 2', 'Purok 3', 'Purok 4', 'Purok 5'];
  static const issues = ['No water', 'Low pressure', 'Leaking pipe', 'Dirty water'];

  static const schedule = [
    ['Purok 1', 'Monday & Thursday', '6:00 AM - 9:00 AM'],
    ['Purok 2', 'Tuesday & Friday', '6:00 AM - 9:00 AM'],
    ['Purok 3', 'Wednesday & Saturday', '6:00 AM - 9:00 AM'],
    ['Purok 4', 'Monday & Thursday', '4:00 PM - 7:00 PM'],
    ['Purok 5', 'Tuesday & Friday', '4:00 PM - 7:00 PM'],
  ];

  static final List<WaterAlert> alerts = [
    WaterAlert(
      'Water Interruption',
      'Repair of the main pipeline. Water may be unavailable until 5:00 PM.',
      'Today',
    ),
    WaterAlert(
      'Tank Cleaning',
      'Please store enough water. Tank cleaning is this Saturday.',
      'Yesterday',
    ),
  ];
  static final List<Report> reports = [];

  static Color statusColor(String status) {
    switch (status) {
      case 'Available':
        return const Color(0xFF1AA633);
      case 'Low Pressure':
        return const Color(0xFFF28C00);
      case 'No Water':
        return const Color(0xFFD91A1A);
      default:
        return const Color(0xFF8C33B3);
    }
  }

  static String now() {
    final d = DateTime.now();
    String two(int n) => n.toString().padLeft(2, '0');
    final h = d.hour % 12 == 0 ? 12 : d.hour % 12;
    final ap = d.hour >= 12 ? 'PM' : 'AM';
    return '${two(d.month)}/${two(d.day)}/${d.year} ${two(h)}:${two(d.minute)} $ap';
  }
}

// ---------------------------------------------------------------
// SMALL UI HELPERS (label, colored panel)
// ---------------------------------------------------------------
Widget label(
  String text, {
  double size = 16,
  bool bold = false,
  Color color = Colors.black,
  TextAlign align = TextAlign.left,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Text(
      text,
      textAlign: align,
      style: TextStyle(
        fontSize: size,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        color: color,
      ),
    ),
  );
}

class Panel extends StatelessWidget {
  final List<Widget> children;
  final Color bg;
  final double padding;
  final bool center;

  const Panel({
    super.key,
    required this.children,
    this.bg = const Color(0xFFEAF0FD),
    this.padding = 14,
    this.center = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment:
            center ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

List<Widget> spaced(List<Widget> items) {
  final out = <Widget>[];
  for (var i = 0; i < items.length; i++) {
    if (i > 0) out.add(const SizedBox(height: 10));
    out.add(items[i]);
  }
  return out;
}

// ---------------------------------------------------------------
// APP SETUP
// ---------------------------------------------------------------
class TubigAlertApp extends StatelessWidget {
  const TubigAlertApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tubig Alert Lantay',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: kBlue),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const LoginPage(),
    );
  }
}

// ---------------------------------------------------------------
// LOG-IN FORM
// ---------------------------------------------------------------
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _hidePass = true;
  String _msg = '';

  void _login() {
    const users = {'admin': 'admin123', 'resident': 'lantay123'};
    final u = _userCtrl.text.trim().toLowerCase();
    final p = _passCtrl.text;
    if (users[u] == p) {
      AppData.currentUser = u;
      AppData.isAdmin = (u == 'admin');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } else {
      setState(() => _msg = 'Invalid username or password');
    }
  }

  @override
  void dispose() {
    _userCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              label('Tubig Alert Lantay',
                  size: 30, bold: true, color: kBlue, align: TextAlign.center),
              label('Barangay Lantay Water Monitoring',
                  size: 14, align: TextAlign.center),
              const SizedBox(height: 16),
              TextField(
                controller: _userCtrl,
                decoration: const InputDecoration(
                  hintText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _passCtrl,
                obscureText: _hidePass,
                decoration: const InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.grey.shade400,
                    foregroundColor: Colors.black,
                    shape: const RoundedRectangleBorder(),
                  ),
                  onPressed: () => setState(() => _hidePass = !_hidePass),
                  child: const Text('Show / Hide password'),
                ),
              ),
              label(_msg, size: 14, color: kRed, align: TextAlign.center),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: kBlue,
                    shape: const RoundedRectangleBorder(),
                  ),
                  onPressed: _login,
                  child: const Text('LOG IN',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------
// HOME + BOTTOM NAVIGATION
// ---------------------------------------------------------------
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const _titles = [
    'Water Status',
    'Distribution Schedule',
    'Alerts',
    'Report a Problem',
  ];

  int _tab = 0;
  String _notice = '';
  String _purok = AppData.puroks.first;
  String _issue = AppData.issues.first;
  final _details = TextEditingController();

  @override
  void dispose() {
    _details.dispose();
    super.dispose();
  }

  void _logout() {
    AppData.currentUser = '';
    AppData.isAdmin = false;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [_statusPage(), _schedulePage(), _alertsPage(), _reportPage()];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBlue,
        foregroundColor: Colors.white,
        title: Text(_titles[_tab],
            style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF0D4080),
                foregroundColor: Colors.white,
                shape: const RoundedRectangleBorder(),
              ),
              onPressed: _logout,
              child: const Text('Log out'),
            ),
          ),
        ],
      ),
      body: pages[_tab],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tab,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFFD9E6F7),
        selectedItemColor: kBlue,
        unselectedItemColor: kBlue.withOpacity(0.6),
        onTap: (i) => setState(() => _tab = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.water_drop), label: 'Status'),
          BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Schedule'),
          BottomNavigationBarItem(icon: Icon(Icons.campaign), label: 'Alerts'),
          BottomNavigationBarItem(
              icon: Icon(Icons.report_problem), label: 'Report'),
        ],
      ),
    );
  }

  // ------------------ WATER STATUS DASHBOARD ------------------
  Widget _statusPage() {
    final color = AppData.statusColor(AppData.waterStatus);
    final items = <Widget>[
      label('Welcome, ${AppData.currentUser}!', size: 20, bold: true),
      Panel(
        bg: color.withOpacity(0.18),
        padding: 20,
        center: true,
        children: [
          label('Current Water Supply', size: 14, align: TextAlign.center),
          label(AppData.waterStatus,
              size: 28, bold: true, color: color, align: TextAlign.center),
        ],
      ),
    ];

    if (AppData.isAdmin) {
      items.add(label('Update status (Admin only)', size: 15, bold: true));
      for (final s in AppData.statuses) {
        items.add(SizedBox(
          height: 44,
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppData.statusColor(s),
              shape: const RoundedRectangleBorder(),
            ),
            onPressed: () => setState(() => AppData.waterStatus = s),
            child: Text(s, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ));
      }
    }

    items.add(Panel(children: [
      label('Latest Alert', size: 14, bold: true),
      label(AppData.alerts.isEmpty ? 'No alerts' : AppData.alerts.first.title,
          size: 15),
    ]));

    return ListView(padding: const EdgeInsets.all(12), children: spaced(items));
  }

  // ------------------ DISTRIBUTION SCHEDULE ------------------
  Widget _schedulePage() {
    final items = AppData.schedule
        .map((s) => Panel(children: [
              label(s[0], size: 17, bold: true, color: kBlue),
              label(s[1], size: 15),
              label(s[2], size: 15),
            ]))
        .toList();
    return ListView(padding: const EdgeInsets.all(12), children: spaced(items));
  }

  // ------------------------- ALERTS -------------------------
  Widget _alertsPage() {
    final items = <Widget>[];
    if (AppData.isAdmin) {
      items.add(SizedBox(
        height: 48,
        child: FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: kBlue,
            shape: const RoundedRectangleBorder(),
          ),
          onPressed: _postAlertDialog,
          child: const Text('+ Post Alert',
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ));
    }
    for (final a in AppData.alerts) {
      items.add(Panel(bg: const Color(0xFFFFF0D9), children: [
        label(a.title, size: 17, bold: true),
        label(a.message, size: 15),
        label(a.time, size: 12, color: Colors.grey.shade600),
      ]));
    }
    return ListView(padding: const EdgeInsets.all(12), children: spaced(items));
  }

  void _postAlertDialog() {
    final title = TextEditingController();
    final msg = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Post Alert'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: title,
              decoration: const InputDecoration(hintText: 'Title'),
            ),
            TextField(
              controller: msg,
              maxLines: 3,
              decoration: const InputDecoration(hintText: 'Message'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (title.text.trim().isEmpty) return;
              setState(() => AppData.alerts.insert(
                  0,
                  WaterAlert(
                      title.text.trim(), msg.text.trim(), AppData.now())));
              Navigator.pop(ctx);
            },
            child: const Text('Post'),
          ),
        ],
      ),
    );
  }

  // ---------------------- REPORT A PROBLEM ----------------------
  Widget _reportPage() {
    final items = <Widget>[
      label('Purok', size: 15, bold: true),
      DropdownButton<String>(
        isExpanded: true,
        value: _purok,
        items: AppData.puroks
            .map((p) => DropdownMenuItem(value: p, child: Text(p)))
            .toList(),
        onChanged: (v) => setState(() => _purok = v!),
      ),
      label('Issue', size: 15, bold: true),
      DropdownButton<String>(
        isExpanded: true,
        value: _issue,
        items: AppData.issues
            .map((p) => DropdownMenuItem(value: p, child: Text(p)))
            .toList(),
        onChanged: (v) => setState(() => _issue = v!),
      ),
      TextField(
        controller: _details,
        maxLines: 4,
        decoration: const InputDecoration(
          hintText: 'Details',
          border: OutlineInputBorder(),
        ),
      ),
      SizedBox(
        height: 50,
        child: FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: kBlue,
            shape: const RoundedRectangleBorder(),
          ),
          onPressed: _submitReport,
          child: const Text('SUBMIT REPORT',
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    ];

    if (_notice.isNotEmpty) {
      items.add(label(_notice, size: 15, bold: true, color: kGreen));
    }

    items.add(label('Submitted Reports', size: 16, bold: true));
    for (final r in AppData.reports) {
      items.add(Panel(bg: const Color(0xFFFFE6E6), children: [
        label('${r.purok} - ${r.issue}', size: 16, bold: true),
        if (r.details.isNotEmpty) label(r.details, size: 14),
        label(r.time, size: 12, color: Colors.grey.shade600),
      ]));
    }

    return ListView(padding: const EdgeInsets.all(12), children: spaced(items));
  }

  void _submitReport() {
    setState(() {
      AppData.reports.insert(
        0,
        Report(_purok, _issue, _details.text.trim(), AppData.now()),
      );
      _details.clear();
      _notice = 'Report submitted. Thank you!';
    });
  }
}
