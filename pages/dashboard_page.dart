// lib/pages/dashboard_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ✅ Make sure this file exists: lib/pages/progress_page.dart
import 'progress_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  double _calProgress = 0.45;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    Future.delayed(const Duration(milliseconds: 100), () => _controller.forward());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ✅ Animated Stat Cards
  Widget _statCard(IconData icon, String label, String value, Color color) {
    return Expanded(
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.1, 1.0, curve: Curves.easeOut),
        ),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: color),
                  ),
                  const Spacer(),
                  Text(value,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold, fontSize: 14)),
                ]),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ✅ Calorie Progress Ring
  Widget _progressRing() {
    return Hero(
      tag: 'progress-hero',
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Row(
            children: [
              SizedBox(
                width: 110,
                height: 110,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: _calProgress,
                      strokeWidth: 10,
                      color: Colors.orangeAccent,
                      backgroundColor: Colors.orange[100],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${(_calProgress * 100).round()}%',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          'of goal',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Calories Today',
                      style:
                      GoogleFonts.poppins(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'You have consumed ${(_calProgress * 2400).round()} kcal of 2400 kcal',
                      style: GoogleFonts.poppins(color: Colors.grey),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _calProgress += 0.07;
                          if (_calProgress > 1.0) _calProgress = 1.0;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Log Meal'),
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

  // ✅ Simple Animated Weekly Activity Chart
  Widget _miniBarChart() {
    final data = [0.2, 0.45, 0.6, 0.35, 0.8, 0.5, 0.65];
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Last 7 Days Activity',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: data.map((d) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        height: 100 * d,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.green[400],
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ]),
      ),
    );
  }

  // ✅ Build Main Dashboard UI
  @override
  Widget build(BuildContext context) {
    const padding = 16.0;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Top stats row 1
          Row(children: [
            Expanded(
              child:
              _statCard(Icons.directions_run, 'Steps', '6,248', Colors.teal),
            ),
            const SizedBox(width: 12),
            Expanded(
              child:
              _statCard(Icons.favorite, 'Heart', '72 bpm', Colors.redAccent),
            ),
          ]),
          const SizedBox(height: 12),

          // 🔹 Top stats row 2
          Row(children: [
            Expanded(
              child: _statCard(Icons.local_fire_department, 'Calories',
                  '1,080 kcal', Colors.orange),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _statCard(Icons.self_improvement, 'Workout', '45 min',
                  Colors.blue),
            ),
          ]),

          const SizedBox(height: 18),
          _progressRing(),
          const SizedBox(height: 18),
          _miniBarChart(),
          const SizedBox(height: 18),

          Text('Quick Actions',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),

          // ✅ Fixed Buttons
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              ElevatedButton.icon(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => Scaffold(
                      appBar: AppBar(title: const Text('Start Workout')),
                      body: const Center(child: Text('Workout run')),
                    ),
                  ),
                ),
                icon: const Icon(Icons.play_arrow),
                label: const Text('Start'),
              ),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.restaurant),
                label: const Text('Log Meal'),
              ),
              OutlinedButton.icon(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ProgressPage()),
                ),
                icon: const Icon(Icons.show_chart),
                label: const Text('View Progress'),
              ),
            ],
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
