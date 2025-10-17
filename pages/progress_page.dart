import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Progress Tracker"),
        backgroundColor: const Color(0xFF0A8754),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Weekly Workout Summary",
                style: GoogleFonts.poppins(
                    fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Expanded(
              child: LineChart(LineChartData(
                gridData: const FlGridData(show: true),
                titlesData: FlTitlesData(show: true),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    color: const Color(0xFF07A3B2),
                    barWidth: 4,
                    belowBarData:
                    BarAreaData(show: true, color: Colors.teal.withOpacity(0.2)),
                    spots: const [
                      FlSpot(0, 2.0),
                      FlSpot(1, 3.0),
                      FlSpot(2, 2.5),
                      FlSpot(3, 4.2),
                      FlSpot(4, 3.8),
                      FlSpot(5, 5.0),
                      FlSpot(6, 4.6),
                    ],
                  ),
                ],
              )),
            ),
            const SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 5,
              child: ListTile(
                leading: const Icon(Icons.local_fire_department, color: Colors.orange),
                title: Text("Total Calories Burned",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                trailing: Text("3,250 kcal",
                    style: GoogleFonts.poppins(fontSize: 16)),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 5,
              child: ListTile(
                leading: const Icon(Icons.directions_walk, color: Colors.teal),
                title: Text("Steps This Week",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                trailing: Text("42,100",
                    style: GoogleFonts.poppins(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
