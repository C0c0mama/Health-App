// lib/screens/notifications/notifications_screen.dart
// Notifications - Appointment reminders, vaccination alerts, announcements

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../models/models.dart';
import '../../services/notification_provider.dart';
import '../../widgets/app_widgets.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _showUnreadOnly = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(
      builder: (context, notifProvider, _) {
        final displayed = _showUnreadOnly
            ? notifProvider.unreadNotifications
            : notifProvider.notifications;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Notifications'),
                if (notifProvider.unreadCount > 0)
                  Text(
                    '${notifProvider.unreadCount} unread',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
              ],
            ),
            backgroundColor: AppColors.white,
            actions: [
              if (notifProvider.unreadCount > 0)
                TextButton(
                  onPressed: notifProvider.markAllAsRead,
                  child: Text(
                    'Mark all read',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
            ],
          ),
          body: Column(
            children: [
              // Filter chips
              _buildFilterBar(notifProvider),

              // Notification list
              Expanded(
                child: displayed.isEmpty
                    ? EmptyStateWidget(
                        icon: Icons.notifications_off_outlined,
                        title: _showUnreadOnly
                            ? 'No unread notifications'
                            : 'No notifications yet',
                        subtitle: _showUnreadOnly
                            ? 'All caught up! 🎉'
                            : 'You will receive health reminders and alerts here.',
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: displayed.length,
                        itemBuilder: (context, index) => _NotificationCard(
                          notification: displayed[index],
                          onTap: () =>
                              notifProvider.markAsRead(displayed[index].id),
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterBar(NotificationProvider provider) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: Row(
        children: [
          _FilterChip(
            label: 'All',
            count: provider.notifications.length,
            selected: !_showUnreadOnly,
            onTap: () => setState(() => _showUnreadOnly = false),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Unread',
            count: provider.unreadCount,
            selected: _showUnreadOnly,
            onTap: () => setState(() => _showUnreadOnly = true),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.background,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTextStyles.labelMedium.copyWith(
                color: selected ? Colors.white : AppColors.textSecondary,
              ),
            ),
            if (count > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: selected
                      ? Colors.white.withValues(alpha: 0.3)
                      : AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  count.toString(),
                  style: TextStyle(
                    color: selected ? Colors.white : AppColors.primary,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Notification Card
// ──────────────────────────────────────────────────────────────────────────────
class _NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const _NotificationCard({required this.notification, required this.onTap});

  IconData get _icon {
    switch (notification.type) {
      case NotificationType.appointment:
        return Icons.calendar_today_rounded;
      case NotificationType.vaccination:
        return Icons.vaccines_rounded;
      case NotificationType.announcement:
        return Icons.campaign_rounded;
      case NotificationType.system:
        return Icons.info_rounded;
    }
  }

  Color get _iconColor {
    switch (notification.type) {
      case NotificationType.appointment:
        return AppColors.primary;
      case NotificationType.vaccination:
        return AppColors.secondary;
      case NotificationType.announcement:
        return const Color(0xFFF59E0B);
      case NotificationType.system:
        return AppColors.textMuted;
    }
  }

  Color get _iconBg {
    switch (notification.type) {
      case NotificationType.appointment:
        return AppColors.primaryLighter;
      case NotificationType.vaccination:
        return AppColors.secondaryLighter;
      case NotificationType.announcement:
        return const Color(0xFFFFFBEB);
      case NotificationType.system:
        return AppColors.background;
    }
  }

  String get _typeLabel {
    switch (notification.type) {
      case NotificationType.appointment:
        return 'Appointment';
      case NotificationType.vaccination:
        return 'Vaccination';
      case NotificationType.announcement:
        return 'Announcement';
      case NotificationType.system:
        return 'System';
    }
  }

  String _formatTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    return DateFormat('MMM d').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: notification.isRead
              ? AppColors.white
              : AppColors.primaryLighter,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: notification.isRead
                ? AppColors.border
                : AppColors.primary.withValues(alpha: 0.25),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: _iconBg, shape: BoxShape.circle),
              child: Icon(_icon, color: _iconColor, size: 20),
            ),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: AppTextStyles.h3.copyWith(fontSize: 14),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (!notification.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(left: 6, top: 2),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.message,
                    style: AppTextStyles.bodySmall,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: _iconBg,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _typeLabel,
                          style: AppTextStyles.caption.copyWith(
                            color: _iconColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.access_time,
                        size: 11,
                        color: AppColors.textMuted,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        _formatTime(notification.timestamp),
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
