// lib/main.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Page imports - files below assume they live in lib/pages/
import 'pages/dashboard_page.dart';
import 'pages/profile_page.dart';
import 'pages/statistics_page.dart';
import 'pages/workout_page.dart';
import 'pages/diet_page.dart';
import 'pages/progress_page.dart';
import 'pages/settings_page.dart';

void main() {
  runApp(const FitnessApp());
}

class FitnessApp extends StatelessWidget {
  const FitnessApp({super.key});

  static final ValueNotifier<bool> isDark = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDark,
      builder: (context, dark, _) {
        final primary = const Color(0xFF0A8754);
        final secondary = const Color(0xFF07A3B2);

        final lightTheme = ThemeData(
          brightness: Brightness.light,
          primaryColor: primary,
          scaffoldBackgroundColor: const Color(0xFFF7F9F9),
          colorScheme: ColorScheme.fromSeed(seedColor: primary).copyWith(secondary: secondary),
          textTheme: GoogleFonts.poppinsTextTheme(),
          appBarTheme: AppBarTheme(backgroundColor: primary, foregroundColor: Colors.white, elevation: 6),
        );

        final darkTheme = ThemeData(
          brightness: Brightness.dark,
          primaryColor: primary,
          scaffoldBackgroundColor: const Color(0xFF0B0F12),
          colorScheme: ColorScheme.fromSeed(seedColor: primary, brightness: Brightness.dark).copyWith(secondary: secondary),
          textTheme: GoogleFonts.poppinsTextTheme(ThemeData(brightness: Brightness.dark).textTheme),
          appBarTheme: AppBarTheme(backgroundColor: primary, foregroundColor: Colors.white, elevation: 6),
        );

        return MaterialApp(
          title: 'Fitness Tracker',
          debugShowCheckedModeBanner: false,
          theme: dark ? darkTheme : lightTheme,
          home: const MainScreen(),
        );
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late final List<String> _pageTitles;
  late final List<Widget> _pages;
  late final AnimationController _badgeAnimController;
  int _notifCount = 2;

  @override
  void initState() {
    super.initState();
    _pageTitles = ["Home", "Profile", "Statistics"];
    _pages = [const DashboardPage(), const ProfilePage(), const StatisticsPage()];
    _badgeAnimController = AnimationController(vsync: this, duration: const Duration(milliseconds: 350));
    if (_notifCount > 0) _badgeAnimController.forward();
  }

  @override
  void dispose() {
    _badgeAnimController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;
    setState(() => _selectedIndex = index);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("${_pageTitles[index]} opened", style: const TextStyle(fontWeight: FontWeight.w600)),
      backgroundColor: Theme.of(context).primaryColor,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(milliseconds: 900),
    ));
  }

  void _navigateToPage(Widget page) {
    Navigator.of(context).push(PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 320),
      pageBuilder: (_, animation, __) => FadeTransition(opacity: animation, child: page),
    ));
  }

  void _openQuickActions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Wrap(runSpacing: 12, children: [
            Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(8)),
                )),
            ListTile(
              leading: const Icon(Icons.fitness_center),
              title: const Text('Start Workout'),
              subtitle: const Text('Begin a new workout session'),
              onTap: () {
                Navigator.pop(context);
                _navigateToPage(const WorkoutPage());
              },
            ),
            ListTile(
              leading: const Icon(Icons.restaurant),
              title: const Text('Log Meal'),
              subtitle: const Text('Add calories quickly'),
              onTap: () {
                Navigator.pop(context);
                _navigateToPage(const DietPage());
              },
            ),
            ListTile(
              leading: const Icon(Icons.show_chart),
              title: const Text('View Progress'),
              onTap: () {
                Navigator.pop(context);
                _navigateToPage(const ProgressPage());
              },
            ),
          ]),
        );
      },
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, Widget page) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title),
      onTap: () {
        Navigator.of(context).pop();
        Future.delayed(const Duration(milliseconds: 200), () => _navigateToPage(page));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    return LayoutBuilder(builder: (context, constraints) {
      final isWide = constraints.maxWidth > 900;

      return Scaffold(
        appBar: AppBar(
          title: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, anim) => FadeTransition(opacity: anim, child: child),
            child: Text(_pageTitles[_selectedIndex], key: ValueKey(_selectedIndex), style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          actions: [
            IconButton(
              tooltip: 'Notifications',
              onPressed: () {
                setState(() {
                  _notifCount = 0;
                  _badgeAnimController.reverse();
                });
                _navigateToPage(
                  Scaffold(
                    appBar: AppBar(title: const Text('Notifications')),
                    body: const Center(child: Text('No new notifications')),
                  ),
                );

              },
              icon: Stack(clipBehavior: Clip.none, children: [
                const Icon(Icons.notifications_outlined),
                Positioned(
                  right: -6,
                  top: -6,
                  child: ScaleTransition(
                    scale: CurvedAnimation(parent: _badgeAnimController, curve: Curves.elasticOut),
                    child: _notifCount > 0
                        ? Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))]),
                      child: Text('$_notifCount', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    )
                        : const SizedBox.shrink(),
                  ),
                )
              ]),
            ),
            IconButton(
              tooltip: 'Settings',
              onPressed: () => _navigateToPage(const SettingsPage()),
              icon: const Icon(Icons.settings_outlined),
            ),
            PopupMenuButton<int>(
              itemBuilder: (context) => [
                const PopupMenuItem(value: 1, child: Text('Account')),
                const PopupMenuItem(value: 2, child: Text('Logout')),
              ],
              onSelected: (v) {
                if (v == 1) _navigateToPage(const ProfilePage());
                if (v == 2) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Logged out')));
              },
              icon: const CircleAvatar(child: Icon(Icons.person, size: 18)),
            ),
          ],
        ),
        drawer: isWide
            ? null
            : Drawer(
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: primary, borderRadius: const BorderRadius.only(bottomRight: Radius.circular(20))),
                  child: Row(children: [
                    Hero(
                      tag: 'drawer-avatar',
                      child: CircleAvatar(radius: 30, backgroundColor: Colors.white, child: Icon(Icons.fitness_center, color: primary, size: 30)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('Saif Ullah Awan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('Fitness Enthusiast', style: TextStyle(color: Colors.white.withOpacity(0.9))),
                    ])),
                  ]),
                ),
                Expanded(
                  child: ListView(padding: EdgeInsets.zero, children: [
                    _buildDrawerItem(Icons.fitness_center, "Workout Tracker", const WorkoutPage()),
                    _buildDrawerItem(Icons.restaurant_menu, "Diet Monitor", const DietPage()),
                    _buildDrawerItem(Icons.show_chart, "Progress", const ProgressPage()),
                    _buildDrawerItem(Icons.settings, "Settings", const SettingsPage()),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    TextButton.icon(
                      onPressed: () => FitnessApp.isDark.value = !FitnessApp.isDark.value,
                      icon: Icon(Icons.dark_mode, color: primary),
                      label: const Text('Toggle Theme'),
                    ),
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
                  ]),
                )
              ],
            ),
          ),
        ),
        body: Row(children: [
          if (isWide)
            Container(
              width: 260,
              color: Theme.of(context).drawerTheme.backgroundColor,
              child: SafeArea(
                child: Column(children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: primary, borderRadius: const BorderRadius.only(bottomRight: Radius.circular(20))),
                    child: Row(children: [
                      Hero(tag: 'drawer-avatar', child: CircleAvatar(radius: 30, backgroundColor: Colors.white, child: Icon(Icons.fitness_center, color: primary, size: 30))),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text('Saif Ullah Awan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('Fitness Enthusiast', style: TextStyle(color: Colors.white.withOpacity(0.9))),
                      ])),
                    ]),
                  ),
                  const SizedBox(height: 8),
                  ListTile(leading: const Icon(Icons.home_outlined), title: const Text('Home'), onTap: () => setState(() => _selectedIndex = 0)),
                  ListTile(leading: const Icon(Icons.fitness_center), title: const Text('Workout Tracker'), onTap: () => _navigateToPage(const WorkoutPage())),
                  ListTile(leading: const Icon(Icons.restaurant_menu), title: const Text('Diet Monitor'), onTap: () => _navigateToPage(const DietPage())),
                  ListTile(leading: const Icon(Icons.show_chart), title: const Text('Progress'), onTap: () => _navigateToPage(const ProgressPage())),
                  const Spacer(),
                  ListTile(leading: const Icon(Icons.logout), title: const Text('Logout'), onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Logged out')))),
                ]),
              ),
            ),
          Expanded(child: SafeArea(child: AnimatedSwitcher(duration: const Duration(milliseconds: 300), child: _pages[_selectedIndex]))),
        ]),
        floatingActionButton: FloatingActionButton(backgroundColor: primary, onPressed: _openQuickActions, tooltip: 'Quick Actions', child: const Icon(Icons.add)),
        bottomNavigationBar: BottomNavigationBar(currentIndex: _selectedIndex, onTap: _onItemTapped, type: BottomNavigationBarType.fixed, items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined), label: 'Statistics'),
        ]),
      );
    });
  }
}
