import 'package:flutter/material.dart';
import '../components/components.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderBar(title: 'About'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // About Card
            AboutCard(
              appName: 'Daily Namaz Reminder',
              version: '1.0.0',
              description:
                  'A simple app to help Muslims remember their daily prayers (Namaz) with timely notifications.',
              icon: Icons.mosque,
            ),

            const SizedBox(height: 30),

            // Features Section
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Features',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(height: 15),

            _buildFeatureItem(
              icon: Icons.notifications_active,
              color: Colors.orange,
              title: 'Prayer Reminders',
              description: 'Get timely notifications before each prayer time',
            ),

            _buildFeatureItem(
              icon: Icons.location_on,
              color: Colors.green,
              title: 'Location Based',
              description: 'Accurate prayer times based on your location',
            ),

            _buildFeatureItem(
              icon: Icons.schedule,
              color: Colors.blue,
              title: 'Daily Schedule',
              description: 'View complete prayer times for the entire day',
            ),

            _buildFeatureItem(
              icon: Icons.tune,
              color: Colors.purple,
              title: 'Customizable',
              description: 'Enable or disable individual prayer notifications',
            ),

            const SizedBox(height: 30),

            // Developer Info
            Builder(
              builder: (context) {
                final isDark = Theme.of(context).brightness == Brightness.dark;
                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Developed with ❤️',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Flutter',
                        style: TextStyle(fontSize: 14, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  static Widget _buildFeatureItem({
    required IconData icon,
    required Color color,
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Builder(
                  builder: (context) {
                    final isDark = Theme.of(context).brightness == Brightness.dark;
                    return Text(
                      description,
                      style: TextStyle(fontSize: 13, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
