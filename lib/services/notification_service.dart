import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static const String _prayerStatusKey = 'prayer_status';

  Map<String, PrayerStatus> _prayerStatuses = {};

  Function(String)? onWillPrayReminder;

  Future<void> initialize() async {
    tz_data.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );

    await _loadPrayerStatuses();
  }

  Future<void> _loadPrayerStatuses() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_prayerStatusKey);
    if (data != null) {
      final Map<String, dynamic> decoded = jsonDecode(data);
      _prayerStatuses = decoded.map(
        (key, value) => MapEntry(key, PrayerStatus.fromJson(value)),
      );
    }
  }

  Future<void> _savePrayerStatuses() async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> encoded = _prayerStatuses.map(
      (key, value) => MapEntry(key, value.toJson()),
    );
    await prefs.setString(_prayerStatusKey, jsonEncode(encoded));
  }

  void _onNotificationResponse(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null) return;

    final parts = payload.split('|');
    if (parts.isEmpty) return;

    final prayerName = parts[0];
    final action = parts.length > 1 ? parts[1] : '';

    if (action == 'prayed') {
      markAsPrayed(prayerName);
    } else if (action == 'will_pray') {
      incrementReminderCount(prayerName);
      onWillPrayReminder?.call(prayerName);
    }
  }

  void markAsPrayed(String prayerName) {
    _prayerStatuses[prayerName] = PrayerStatus(
      prayed: true,
      reminderCount: 0,
      lastReminded: DateTime.now(),
    );
    _savePrayerStatuses();
  }

  void incrementReminderCount(String prayerName) {
    final current = _prayerStatuses[prayerName];
    final newCount = (current?.reminderCount ?? 0) + 1;

    _prayerStatuses[prayerName] = PrayerStatus(
      prayed: false,
      reminderCount: newCount,
      lastReminded: DateTime.now(),
    );
    _savePrayerStatuses();
  }

  bool shouldRemind(String prayerName) {
    final status = _prayerStatuses[prayerName];
    if (status == null) return true;
    if (status.prayed) return false;
    if (status.reminderCount >= 2) return false;
    return true;
  }

  AndroidNotificationDetails _getPrayerNotificationDetails() {
    return AndroidNotificationDetails(
      'prayer_reminders',
      'Prayer Reminders',
      channelDescription: 'Notifications for prayer times',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      enableVibration: true,
      actions: <AndroidNotificationAction>[
        const AndroidNotificationAction(
          'prayed',
          'Prayed',
          showsUserInterface: true,
        ),
        const AndroidNotificationAction(
          'will_pray',
          'Will Pray',
          showsUserInterface: true,
        ),
      ],
    );
  }

  Future<void> schedulePrayerNotification({
    required String prayerName,
    required DateTime prayerTime,
    required int prayerIndex,
  }) async {
    if (!shouldRemind(prayerName)) return;

    final notificationTime = prayerTime.subtract(const Duration(minutes: 10));

    if (notificationTime.isBefore(DateTime.now())) return;

    final androidDetails = _getPrayerNotificationDetails();

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.zonedSchedule(
      prayerIndex,
      '$prayerName Prayer Time',
      'It\'s time for $prayerName prayer',
      tz.TZDateTime.from(notificationTime, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: '$prayerName|',
    );
  }

  Future<void> showImmediateReminder({
    required String prayerName,
    required int prayerIndex,
  }) async {
    if (!shouldRemind(prayerName)) return;

    final androidDetails = _getPrayerNotificationDetails();

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      prayerIndex,
      '$prayerName Prayer Time',
      'It\'s time for $prayerName prayer',
      details,
      payload: '$prayerName|',
    );
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  void resetPrayerStatus(String prayerName) {
    _prayerStatuses.remove(prayerName);
    _savePrayerStatuses();
  }

  void resetAllPrayerStatuses() {
    _prayerStatuses.clear();
    _savePrayerStatuses();
  }
}

class PrayerStatus {
  final bool prayed;
  final int reminderCount;
  final DateTime? lastReminded;

  PrayerStatus({
    required this.prayed,
    required this.reminderCount,
    this.lastReminded,
  });

  factory PrayerStatus.fromJson(Map<String, dynamic> json) {
    return PrayerStatus(
      prayed: json['prayed'] ?? false,
      reminderCount: json['reminderCount'] ?? 0,
      lastReminded: json['lastReminded'] != null
          ? DateTime.parse(json['lastReminded'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'prayed': prayed,
      'reminderCount': reminderCount,
      'lastReminded': lastReminded?.toIso8601String(),
    };
  }
}
