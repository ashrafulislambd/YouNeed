import 'package:flutter/foundation.dart';
import 'notification_model.dart';

/// Singleton service that manages all in-app notifications.
/// Uses ValueNotifier so AppBar badges can listen reactively.
class NotificationService {
  // Singleton instance
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final List<NotificationModel> _notifications = [];

  /// A ValueNotifier that broadcasts the current unread count.
  /// AppBar icons listen to this to show/hide badges without rebuilding.
  final ValueNotifier<int> unreadCountNotifier = ValueNotifier<int>(0);

  /// All notifications, newest first.
  List<NotificationModel> get notifications =>
      List.unmodifiable(_notifications.reversed);

  /// Current unread count.
  int get unreadCount =>
      _notifications.where((n) => !n.isRead).length;

  /// Add a new notification and update listeners.
  void addNotification({
    required String title,
    required String message,
    NotificationType type = NotificationType.general,
  }) {
    final notification = NotificationModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      message: message,
      timestamp: DateTime.now(),
      type: type,
    );
    _notifications.add(notification);
    _updateUnreadCount();
  }

  /// Mark a single notification as read.
  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index].isRead = true;
      _updateUnreadCount();
    }
  }

  /// Mark all notifications as read.
  void markAllAsRead() {
    for (final n in _notifications) {
      n.isRead = true;
    }
    _updateUnreadCount();
  }

  /// Schedule a notification to appear after a delay.
  /// Used for payment deadline reminders.
  void scheduleNotification({
    required String title,
    required String message,
    required Duration delay,
    NotificationType type = NotificationType.general,
  }) {
    Future.delayed(delay, () {
      addNotification(title: title, message: message, type: type);
    });
  }

  void _updateUnreadCount() {
    unreadCountNotifier.value = unreadCount;
  }
}
