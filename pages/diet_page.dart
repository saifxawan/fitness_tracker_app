// lib/pages/diet_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DietPage extends StatefulWidget {
  const DietPage({super.key});

  @override
  State<DietPage> createState() => _DietPageState();
}

class _DietPageState extends State<DietPage> {
  final List<Map<String, dynamic>> _meals = [
    {'meal': 'Oatmeal', 'time': '08:00 AM', 'cal': 320},
    {'meal': 'Chicken Salad', 'time': '01:00 PM', 'cal': 450},
    {'meal': 'Protein Shake', 'time': '04:00 PM', 'cal': 180},
  ];

  int _dailyGoal = 2400;

  void _addMeal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
      builder: (context) {
        final mealCtrl = TextEditingController();
        final calCtrl = TextEditingController();
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(children: [
            Text('Add Meal', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            TextField(controller: mealCtrl, decoration: const InputDecoration(labelText: 'Meal name')),
            const SizedBox(height: 8),
            TextField(controller: calCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Calories')),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                final m = mealCtrl.text.trim();
                final c = int.tryParse(calCtrl.text.trim()) ?? 0;
                if (m.isNotEmpty) {
                  setState(() {
                    _meals.add({'meal': m, 'time': TimeOfDay.now().format(context), 'cal': c});
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            )
          ]),
        );
      },
    );
  }

  int get _totalCalories => _meals.fold<int>(0, (p, e) => p + (e['cal'] as int));

  @override
  Widget build(BuildContext context) {
    final percent = (_totalCalories / _dailyGoal).clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(children: [
        Row(children: [
          Expanded(child: Text('Diet Monitor', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 20))),
          ElevatedButton.icon(onPressed: _addMeal, icon: const Icon(Icons.add), label: const Text('Add')),
        ]),
        const SizedBox(height: 12),
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(children: [
              Column(children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: Stack(alignment: Alignment.center, children: [
                    CircularProgressIndicator(value: percent, strokeWidth: 8),
                    Column(mainAxisSize: MainAxisSize.min, children: [
                      Text('${(percent * 100).round()}%', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                      Text('of goal', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                    ])
                  ]),
                ),
              ]),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Daily calories', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text('$_totalCalories / $_dailyGoal kcal', style: GoogleFonts.poppins(color: Colors.grey)),
                const SizedBox(height: 8),
                LinearProgressIndicator(value: percent, minHeight: 8),
                const SizedBox(height: 8),
                Wrap(spacing: 8, children: [
                  OutlinedButton(onPressed: () {}, child: const Text('Set Goal')),
                  OutlinedButton(onPressed: () {}, child: const Text('Scan Meal')),
                ])
              ])),
            ]),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.separated(
            itemCount: _meals.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, idx) {
              final m = _meals[idx];
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  title: Text(m['meal'], style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                  subtitle: Text(m['time'], style: GoogleFonts.poppins(color: Colors.grey)),
                  trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                    Text('${m['cal']} kcal', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () {
                        // quick edit sheet
                        showModalBottomSheet(
                          context: context,
                          builder: (ctx) {
                            final mealCtrl = TextEditingController(text: m['meal']);
                            final calCtrl = TextEditingController(text: m['cal'].toString());
                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Wrap(children: [
                                Text('Edit Meal', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                                TextField(controller: mealCtrl),
                                TextField(controller: calCtrl, keyboardType: TextInputType.number),
                                ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        m['meal'] = mealCtrl.text;
                                        m['cal'] = int.tryParse(calCtrl.text) ?? m['cal'];
                                      });
                                      Navigator.pop(ctx);
                                    },
                                    child: const Text('Save'))
                              ]),
                            );
                          },
                        );
                      },
                    )
                  ]),
                ),
              );
            },
          ),
        )
      ]),
    );
  }
}
