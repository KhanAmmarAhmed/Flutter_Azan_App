import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/components.dart';
import '../theme_provider.dart';
import '../notification_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurfaceVariant;

    return Scaffold(
      appBar: HeaderBar(title: 'Settings'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'General',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 12),

            // Theme Selector
            Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return ThemeSelector(
                  isDarkMode: themeProvider.isDarkMode,
                  onChanged: (value) {
                    themeProvider.setDarkMode(value);
                  },
                );
              },
            ),

            // Notification Main Toggle
            Consumer<NotificationProvider>(
              builder: (context, notificationProvider, child) {
                return NotificationToggle(
                  title: 'Enable Notifications',
                  subtitle: 'Enable or disable all prayer reminders',
                  value: notificationProvider.notificationsEnabled,
                  onChanged: (value) {
                    notificationProvider.toggleNotifications(value);
                    if (value) {
                      notificationProvider.scheduleAllNotifications();
                    }
                  },
                  color: Colors.deepOrange,
                );
              },
            ),

            const SizedBox(height: 20),
            Text(
              'Prayer Notifications',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 12),

            // Individual Prayer Toggles
            Consumer<NotificationProvider>(
              builder: (context, notificationProvider, child) {
                final enabled = notificationProvider.notificationsEnabled;
                return Column(
                  children: [
                    NotificationToggle(
                      title: 'Fajr Reminder',
                      subtitle: 'Notify before Fajr prayer',
                      value: notificationProvider.prayerReminders['Fajr'] ?? false,
                      onChanged: enabled 
                          ? (value) => notificationProvider.togglePrayerReminder('Fajr', value)
                          : null,
                      color: Colors.blue,
                    ),
                    NotificationToggle(
                      title: 'Dhuhr Reminder',
                      subtitle: 'Notify before Dhuhr prayer',
                      value: notificationProvider.prayerReminders['Dhuhr'] ?? false,
                      onChanged: enabled 
                          ? (value) => notificationProvider.togglePrayerReminder('Dhuhr', value)
                          : null,
                      color: Colors.orange,
                    ),
                    NotificationToggle(
                      title: 'Asr Reminder',
                      subtitle: 'Notify before Asr prayer',
                      value: notificationProvider.prayerReminders['Asr'] ?? false,
                      onChanged: enabled 
                          ? (value) => notificationProvider.togglePrayerReminder('Asr', value)
                          : null,
                      color: Colors.purple,
                    ),
                    NotificationToggle(
                      title: 'Maghrib Reminder',
                      subtitle: 'Notify before Maghrib prayer',
                      value: notificationProvider.prayerReminders['Maghrib'] ?? false,
                      onChanged: enabled 
                          ? (value) => notificationProvider.togglePrayerReminder('Maghrib', value)
                          : null,
                      color: Colors.red,
                    ),
                    NotificationToggle(
                      title: 'Isha Reminder',
                      subtitle: 'Notify before Isha prayer',
                      value: notificationProvider.prayerReminders['Isha'] ?? false,
                      onChanged: enabled 
                          ? (value) => notificationProvider.togglePrayerReminder('Isha', value)
                          : null,
                      color: Colors.indigo,
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 20),
            Text(
              'Other Settings',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 12),

            // Other Settings Tiles
            SettingsTile(
              icon: Icons.location_on,
              title: 'Location',
              subtitle: 'Karachi, Pakistan',
              color: Colors.green,
              onTap: () {},
            ),

            SettingsTile(
              icon: Icons.language,
              title: 'Calculation Method',
              subtitle: 'Karachi',
              color: Colors.teal,
              onTap: () {},
            ),

            SettingsTile(
              icon: Icons.volume_up,
              title: 'Adhan Sound',
              subtitle: 'Default',
              color: Colors.amber,
              onTap: () {},
            ),

            SettingsTile(
              icon: Icons.info_outline,
              title: 'About',
              subtitle: 'App version and info',
              color: Colors.blueGrey,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
