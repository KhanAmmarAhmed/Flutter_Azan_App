import 'package:flutter/foundation.dart';
import '../services/notification_service.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationService _notificationService = NotificationService();
  
  bool _notificationsEnabled = false;
  bool get notificationsEnabled => _notificationsEnabled;

  final Map<String, bool> _prayerReminders = {
    'Fajr': true,
    'Dhuhr': true,
    'Asr': true,
    'Maghrib': true,
    'Isha': true,
  };

  Map<String, bool> get prayerReminders => _prayerReminders;

  NotificationProvider() {
    _notificationService.onWillPrayReminder = _handleWillPrayReminder;
  }

  void _handleWillPrayReminder(String prayerName) {
    remindAfter2Minutes(prayerName);
  }

  void toggleNotifications(bool value) {
    _notificationsEnabled = value;
    if (!value) {
      _notificationService.cancelAllNotifications();
    }
    notifyListeners();
  }

  void togglePrayerReminder(String prayerName, bool value) {
    _prayerReminders[prayerName] = value;
    if (_notificationsEnabled && value) {
      _schedulePrayerNotification(prayerName);
    } else {
      _cancelPrayerNotification(prayerName);
    }
    notifyListeners();
  }

  void _schedulePrayerNotification(String prayerName) {
    final prayerTimes = _getPrayerTimes();
    final index = _prayerNames.indexOf(prayerName);
    if (index == -1) return;
    
    final time = prayerTimes[index];
    _notificationService.schedulePrayerNotification(
      prayerName: prayerName,
      prayerTime: time,
      prayerIndex: index,
    );
  }

  void _cancelPrayerNotification(String prayerName) {
    final index = _prayerNames.indexOf(prayerName);
    if (index != -1) {
      _notificationService.cancelNotification(index);
    }
  }

  Future<void> scheduleAllNotifications() async {
    if (!_notificationsEnabled) return;
    
    await _notificationService.cancelAllNotifications();
    
    final prayerTimes = _getPrayerTimes();
    for (int i = 0; i < _prayerNames.length; i++) {
      if (_prayerReminders[_prayerNames[i]] ?? false) {
        _notificationService.schedulePrayerNotification(
          prayerName: _prayerNames[i],
          prayerTime: prayerTimes[i],
          prayerIndex: i,
        );
      }
    }
  }

  Future<void> remindAfter2Minutes(String prayerName) async {
    final index = _prayerNames.indexOf(prayerName);
    if (index != -1) {
      await Future.delayed(const Duration(minutes: 2));
      if (_notificationsEnabled && (_prayerReminders[prayerName] ?? false)) {
        _notificationService.showImmediateReminder(
          prayerName: prayerName,
          prayerIndex: index + 100,
        );
      }
    }
  }

  void markAsPrayed(String prayerName) {
    _notificationService.markAsPrayed(prayerName);
    notifyListeners();
  }

  void resetPrayerStatus(String prayerName) {
    _notificationService.resetPrayerStatus(prayerName);
    notifyListeners();
  }

  void resetAllStatuses() {
    _notificationService.resetAllPrayerStatuses();
    notifyListeners();
  }

  static const List<String> _prayerNames = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];

  List<DateTime> _getPrayerTimes() {
    final now = DateTime.now();
    return [
      DateTime(now.year, now.month, now.day, 5, 15),
      DateTime(now.year, now.month, now.day, 12, 30),
      DateTime(now.year, now.month, now.day, 15, 45),
      DateTime(now.year, now.month, now.day, 18, 20),
      DateTime(now.year, now.month, now.day, 20, 0),
    ];
  }
}
