/// Types of notifications in the app
enum NotificationType {
  orderPlaced,
  orderUpdate,
  paymentReminder,
  general,
}

/// Model representing a single notification
class NotificationModel {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final NotificationType type;
  bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    this.type = NotificationType.general,
    this.isRead = false,
  });
}
