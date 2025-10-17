// lib/pages/workout_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WorkoutPage extends StatefulWidget {
  const WorkoutPage({super.key});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> _workouts = [
    {'title': 'Full Body HIIT', 'duration': '30 min', 'cal': 320},
    {'title': 'Upper Strength', 'duration': '45 min', 'cal': 420},
    {'title': 'Yoga Flow', 'duration': '25 min', 'cal': 120},
  ];

  late final AnimationController _anim;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 700))..forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  Widget _workoutCard(Map<String, dynamic> w, int idx) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: _anim, curve: Interval(0.1 * idx, 1.0, curve: Curves.easeOut)),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          leading: CircleAvatar(backgroundColor: Colors.green[50], child: const Icon(Icons.fitness_center, color: Colors.green)),
          title: Text(w['title'], style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          subtitle: Text('${w['duration']} • ${w['cal']} kcal', style: GoogleFonts.poppins(color: Colors.grey[700])),
          trailing: ElevatedButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => WorkoutDetailPage(title: w['title']))),
            style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            child: const Text('Start'),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Workout Tracker', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 20)),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.separated(
            itemCount: _workouts.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, idx) => _workoutCard(_workouts[idx], idx),
          ),
        ),
      ]),
    );
  }
}

class WorkoutDetailPage extends StatefulWidget {
  final String title;
  const WorkoutDetailPage({required this.title, super.key});

  @override
  State<WorkoutDetailPage> createState() => _WorkoutDetailPageState();
}

class _WorkoutDetailPageState extends State<WorkoutDetailPage> {
  bool _running = false;
  int _seconds = 0;
  late final Ticker _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Ticker((elapsed) {
      if (_running) {
        setState(() => _seconds = elapsed.inSeconds);
      }
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _running = !_running);
    if (_running) {
      _ticker.start();
    } else {
      _ticker.stop(canceled: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final minutes = (_seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (_seconds % 60).toString().padLeft(2, '0');
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const SizedBox(height: 24),
          Text('$minutes:$secs', style: GoogleFonts.poppins(fontSize: 48, fontWeight: FontWeight.bold)),
          const SizedBox(height: 18),
          Text('Timer', style: GoogleFonts.poppins(color: Colors.grey)),
          const SizedBox(height: 36),
          ElevatedButton.icon(
            onPressed: _toggle,
            icon: Icon(_running ? Icons.pause : Icons.play_arrow),
            label: Text(_running ? 'Pause' : 'Start'),
            style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14)),
          ),
          const SizedBox(height: 18),
          OutlinedButton(
            onPressed: () {
              setState(() {
                _running = false;
                _seconds = 0;
                _ticker.stop(canceled: true);
              });
            },
            child: const Text('Reset'),
          ),
          const Spacer(),
          Text('Good form matters more than speed. Keep hydrated.', style: GoogleFonts.poppins(color: Colors.grey)),
          const SizedBox(height: 18),
        ]),
      ),
    );
  }
}

// Basic ticker class since we avoid external libs
class Ticker {
  final void Function(Duration) _onTick;
  bool _active = false;
  Duration _start = Duration.zero;
  late final Stopwatch _stopwatch;
  late final void Function() _tickLoop;

  Ticker(this._onTick) {
    _stopwatch = Stopwatch();
    _tickLoop = () async {
      while (_active) {
        await Future.delayed(const Duration(seconds: 1));
        _onTick(_stopwatch.elapsed);
      }
    };
  }

  void start() {
    _active = true;
    _stopwatch.start();
    _tickLoop();
  }

  void stop({bool canceled = false}) {
    _active = false;
    _stopwatch.stop();
    if (canceled) _stopwatch.reset();
  }

  void dispose() {
    _active = false;
  }
}
