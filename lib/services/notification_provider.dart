// lib/services/notification_provider.dart
// Notification state management

import 'package:flutter/material.dart';
import '../models/models.dart';
import '../data/dummy_data.dart';

class NotificationProvider extends ChangeNotifier {
  List<NotificationModel> _notifications = List.from(DummyData.notifications);

  List<NotificationModel> get notifications => _notifications;

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  List<NotificationModel> get unreadNotifications =>
      _notifications.where((n) => !n.isRead).toList();

  // Mark a single notification as read
  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      notifyListeners();
    }
  }

  // Mark all as read
  void markAllAsRead() {
    _notifications = _notifications
        .map((n) => n.copyWith(isRead: true))
        .toList();
    notifyListeners();
  }
}
