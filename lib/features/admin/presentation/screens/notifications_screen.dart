import 'package:flutter/material.dart';
import 'package:hrms/core/config/text_config.dart';
import 'package:hrms/core/config/color_cofig.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        title: Text(
          'Notifications',
          style: AppTypography.headline6(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.mark_email_read, color: Colors.white),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 12,
        itemBuilder: (context, index) => _buildNotificationCard(index),
      ),
    );
  }

  Widget _buildNotificationCard(int index) {
    final isUnread = index < 3;
    final notificationTypes = ['leave', 'employee', 'system', 'announcement'];
    final type = notificationTypes[index % 4];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUnread ? Colors.blue.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border:
            isUnread
                ? Border.all(color: Colors.blue.withValues(alpha: 0.2))
                : null,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getNotificationColor(type).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getNotificationIcon(type),
              color: _getNotificationColor(type),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _getNotificationTitle(type, index),
                        style: AppTypography.body1(
                          fontWeight:
                              isUnread ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ),
                    if (isUnread)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  _getNotificationMessage(type),
                  style: AppTypography.body2(color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                Text(
                  _getNotificationTime(index),
                  style: AppTypography.caption(color: Colors.grey[500]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'leave':
        return Icons.event_busy;
      case 'employee':
        return Icons.person_add;
      case 'system':
        return Icons.settings;
      case 'announcement':
        return Icons.campaign;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'leave':
        return Colors.orange;
      case 'employee':
        return Colors.green;
      case 'system':
        return Colors.purple;
      case 'announcement':
        return Colors.blue;
      default:
        return AppColors.primary;
    }
  }

  String _getNotificationTitle(String type, int index) {
    switch (type) {
      case 'leave':
        return 'New Leave Request';
      case 'employee':
        return 'New Employee Added';
      case 'system':
        return 'System Update';
      case 'announcement':
        return 'New Announcement';
      default:
        return 'Notification';
    }
  }

  String _getNotificationMessage(String type) {
    switch (type) {
      case 'leave':
        return 'John Doe has requested sick leave for 3 days';
      case 'employee':
        return 'Jane Smith has been added to the Engineering team';
      case 'system':
        return 'System maintenance scheduled for tonight';
      case 'announcement':
        return 'Important company policy update has been posted';
      default:
        return 'You have a new notification';
    }
  }

  String _getNotificationTime(int index) {
    final times = [
      '2 min ago',
      '1 hour ago',
      '3 hours ago',
      '1 day ago',
      '2 days ago',
    ];
    return times[index % times.length];
  }
}
