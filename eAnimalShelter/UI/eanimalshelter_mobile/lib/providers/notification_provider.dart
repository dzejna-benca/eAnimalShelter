import 'dart:async';

import 'package:flutter/material.dart';

import '../models/notification.dart';
import 'base_provider.dart';

class NotificationProvider
    extends BaseProvider<NotificationModel> {
  NotificationProvider()
      : super("Notification");

  List<NotificationModel> _notifications = [];

  int _unreadCount = 0;

  Timer? _timer;

  List<NotificationModel> get notifications =>
      _notifications;

  int get unreadCount => _unreadCount;

  @override
  NotificationModel fromJson(data) =>
      NotificationModel.fromJson(data);

  Future<void> loadNotifications() async {
    final result = await get(filter: {
      "sortBy": "date_desc",
      "page": 1,
      "pageSize": 100,
    });

    _notifications = result.items;

    notifyListeners();
  }

  Future<void> loadUnreadCount() async {
    _unreadCount =
        await getRaw<int>("unread-count");

    notifyListeners();
  }

  Future<void> refresh() async {
  try {
    await Future.wait([
      loadNotifications(),
      loadUnreadCount(),
    ]);
  } catch (e) {
    debugPrint(e.toString());
  }
}

  Future<void> markAsRead(int id) async {
    await putVoid("$id/read",{});

    await refresh();
  }

  Future<void> markAllAsRead() async {
    await putVoid("read-all",{});

    await refresh();
  }

  void startPolling() {
    _timer?.cancel();

    refresh();

    _timer = Timer.periodic(
    const Duration(seconds: 15),
    (_) async {
      try {
        await refresh();
      } catch (_) {}
    },
  );
  }

  void stopPolling() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    stopPolling();
    super.dispose();
  }
}