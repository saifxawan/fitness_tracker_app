// lib/pages/settings_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart' as app_main;

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notifications = true;
  bool _location = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Text('App', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          child: SwitchListTile(
            value: app_main.FitnessApp.isDark.value,
            onChanged: (v) => app_main.FitnessApp.isDark.value = v,
            title: const Text('Dark Mode'),
            secondary: const Icon(Icons.dark_mode),
          ),
        ),
        const SizedBox(height: 12),
        Text('Preferences', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(children: [
            SwitchListTile(
              value: _notifications,
              onChanged: (v) => setState(() => _notifications = v),
              title: const Text('Notifications'),
              secondary: const Icon(Icons.notifications),
            ),
            SwitchListTile(
              value: _location,
              onChanged: (v) => setState(() => _location = v),
              title: const Text('Location'),
              secondary: const Icon(Icons.location_on),
            ),
          ]),
        ),
        const SizedBox(height: 12),
        ListTile(leading: const Icon(Icons.lock_outline), title: const Text('Privacy & Security'), onTap: () {}),
        ListTile(leading: const Icon(Icons.info_outline), title: const Text('About'), onTap: () {}),
        const SizedBox(height: 60),
        ElevatedButton(
          onPressed: () {
            showDialog(context: context, builder: (ctx) => AlertDialog(title: const Text('Reset App'), content: const Text('This will clear local demo data (no real data is stored). Continue?'), actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
              ElevatedButton(onPressed: () => Navigator.pop(ctx), child: const Text('Reset')),
            ]));
          },
          child: const Text('Reset Demo Data'),
        )
      ]),
    );
  }
}
