import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'notification_provider.dart';
import 'pages/home_page.dart';
import 'pages/settings_page.dart';
import 'pages/about_page.dart';
import 'pages/dua_page.dart';
import 'pages/tasbeeh_page.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().initialize();
  runApp(const DailyNamazReminderApp());
}

class DailyNamazReminderApp extends StatelessWidget {
  const DailyNamazReminderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Daily Namaz Reminder',
            debugShowCheckedModeBanner: false,
            theme: themeProvider.isDarkMode
                ? ThemeProvider.darkTheme
                : ThemeProvider.lightTheme,
            home: const MainNavigation(),
          );
        },
      ),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const DuaPage(),
    const TasbeehPage(),
    const SettingsPage(),
    const AboutPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        height: 60,
        margin: const EdgeInsets.only(bottom: 10),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onItemTapped,
          backgroundColor: Colors.black.withValues(alpha: 0.8),
          indicatorColor: Colors.orange.withValues(alpha: 0.3),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: [
            NavigationDestination(
              icon: Icon(
                Icons.home_outlined,
                color: isDark ? Colors.white70 : Colors.white,
              ),
              selectedIcon: const Icon(Icons.home, color: Colors.orange),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.menu_book_outlined,
                color: isDark ? Colors.white70 : Colors.white,
              ),
              selectedIcon: const Icon(Icons.menu_book, color: Colors.orange),
              label: 'Dua',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.touch_app_outlined,
                color: isDark ? Colors.white70 : Colors.white,
              ),
              selectedIcon: const Icon(Icons.touch_app, color: Colors.orange),
              label: 'Tasbeeh',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.settings_outlined,
                color: isDark ? Colors.white70 : Colors.white,
              ),
              selectedIcon: const Icon(Icons.settings, color: Colors.orange),
              label: 'Settings',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.info_outlined,
                color: isDark ? Colors.white70 : Colors.white,
              ),
              selectedIcon: const Icon(Icons.info, color: Colors.orange),
              label: 'About',
            ),
          ],
        ),
      ),
    );
  }
}
