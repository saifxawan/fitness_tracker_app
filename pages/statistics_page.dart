// lib/pages/statistics_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  Widget _metricCard(String title, String value, String subtitle, IconData icon) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(children: [
          CircleAvatar(backgroundColor: Colors.blue[50], child: Icon(icon, color: Colors.blue)),
          const SizedBox(width: 12),
          Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(subtitle, style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12)),
              ])),
          Text(value, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18)),
        ]),
      ),
    );
  }

  Widget _simpleBarChart() {
    final values = [30, 56, 42, 70, 80, 65, 90];
    final max = values.reduce((a, b) => a > b ? a : b);
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Weekly Calories Burned', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          SizedBox(
            height: 180,
            child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: values.map((v) {
              final height = (v / max) * 140;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    AnimatedContainer(duration: const Duration(milliseconds: 400), height: height, decoration: BoxDecoration(color: Colors.deepPurple[300], borderRadius: BorderRadius.circular(6))),
                    const SizedBox(height: 8),
                    Text('', style: GoogleFonts.poppins(fontSize: 12)),
                  ]),
                ),
              );
            }).toList()),
          )
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        _metricCard('Average Heart Rate', '72', 'Last 7 days', Icons.favorite),
        const SizedBox(height: 12),
        _metricCard('Avg Calories Burned', '520', 'Daily average', Icons.local_fire_department),
        const SizedBox(height: 12),
        _simpleBarChart(),
        const SizedBox(height: 12),
        Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Insights', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('You are improving step consistency week-over-week.\nFocus: add strength sessions twice a week.', style: GoogleFonts.poppins(color: Colors.grey)),
            ]),
          ),
        ),
        const SizedBox(height: 60)
      ]),
    );
  }
}
