import 'package:flutter/material.dart';
import 'notification_model.dart';
import 'notification_service.dart';
import '../theme_provider.dart';

/// Screen displaying all notifications with mark-as-read functionality.
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotificationService _service = NotificationService();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final notifications = _service.notifications;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: false,
        elevation: 0,
        actions: [
          if (notifications.any((n) => !n.isRead))
            TextButton.icon(
              onPressed: () {
                _service.markAllAsRead();
                setState(() {});
              },
              icon: const Icon(Icons.done_all, size: 18),
              label: const Text('Mark all read'),
            ),
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              themeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark;
            },
          ),
        ],
      ),
      body: notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_none_rounded,
                    size: 80,
                    color: isDark ? Colors.white24 : Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No notifications yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: isDark ? Colors.white38 : Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Place an order to see notifications here',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.white24 : Colors.grey[400],
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final n = notifications[index];
                return _NotificationCard(
                  notification: n,
                  onTap: () {
                    _service.markAsRead(n.id);
                    setState(() {});
                  },
                );
              },
            ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const _NotificationCard({
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final n = notification;

    // Icon and color based on notification type
    IconData icon;
    Color iconColor;
    switch (n.type) {
      case NotificationType.orderPlaced:
        icon = Icons.check_circle_outline;
        iconColor = Colors.green;
        break;
      case NotificationType.orderUpdate:
        icon = Icons.local_shipping_outlined;
        iconColor = Colors.blue;
        break;
      case NotificationType.paymentReminder:
        icon = Icons.payment;
        iconColor = Colors.redAccent;
        break;
      case NotificationType.general:
        icon = Icons.info_outline;
        iconColor = Colors.orange;
        break;
    }

    // Relative time string
    final timeAgo = _formatTimeAgo(n.timestamp);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 10),
      child: Card(
        elevation: n.isRead ? 1 : 3,
        color: n.isRead
            ? Theme.of(context).cardColor
            : (isDark
                ? const Color(0xFF1A2A3A)
                : const Color(0xFFF0F5FF)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: n.isRead
              ? BorderSide.none
              : BorderSide(
                  color: iconColor.withOpacity(0.3),
                  width: 1,
                ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Type icon
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                const SizedBox(width: 14),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              n.title,
                              style: TextStyle(
                                fontWeight:
                                    n.isRead ? FontWeight.w500 : FontWeight.bold,
                                fontSize: 14,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                          ),
                          if (!n.isRead)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: iconColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        n.message,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? Colors.white60 : Colors.black54,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        timeAgo,
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? Colors.white30 : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTimeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hr ago';
    if (diff.inDays < 7) return '${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago';
    return '${time.day}/${time.month}/${time.year}';
  }
}
