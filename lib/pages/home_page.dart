import 'package:flutter/material.dart';
import '../components/components.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Dummy data for namaz times
  static final List<Map<String, dynamic>> namazTimes = [
    {'name': 'Fajr', 'time': '05:15 AM', 'color': Colors.blue},
    {'name': 'Dhuhr', 'time': '12:30 PM', 'color': Colors.orange},
    {'name': 'Asr', 'time': '03:45 PM', 'color': Colors.purple},
    {'name': 'Maghrib', 'time': '06:20 PM', 'color': Colors.red},
    {'name': 'Isha', 'time': '08:00 PM', 'color': Colors.indigo},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderBar(title: 'Daily Namaz Reminder'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Location Widget
            const LocationWidget(),
            const SizedBox(height: 20),

            // Current Prayer Widget
            CurrentPrayerWidget(currentPrayer: 'Dhuhr', prayerIndex: 1),
            const SizedBox(height: 20),

            // Countdown Timer
            CountdownTimer(nextPrayer: 'Asr', timeRemaining: '2h 15m'),
            const SizedBox(height: 30),

            // Namaz Times Section
            Text(
              'Today\'s Namaz Times',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 15),

            // Namaz Time Cards
            ...namazTimes.map(
              (namaz) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: NamazTimeCard(
                  name: namaz['name'],
                  time: namaz['time'],
                  color: namaz['color'],
                  icon: _getPrayerIcon(namaz['name']),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static IconData _getPrayerIcon(String name) {
    switch (name) {
      case 'Fajr':
        return Icons.wb_twilight;
      case 'Dhuhr':
        return Icons.wb_sunny;
      case 'Asr':
        return Icons.wb_twilight;
      case 'Maghrib':
        return Icons.nights_stay;
      case 'Isha':
        return Icons.dark_mode;
      default:
        return Icons.access_time;
    }
  }
}
