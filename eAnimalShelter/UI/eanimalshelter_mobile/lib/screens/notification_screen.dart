import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/notification.dart';
import '../../providers/notification_provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() =>
      _NotificationScreenState();
}

class _NotificationScreenState
    extends State<NotificationScreen> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await context
        .read<NotificationProvider>()
        .refresh();

    if (!mounted) return;

    setState(() {
      _loading = false;
    });
  }

  IconData _icon(NotificationType type) {
    switch (type) {
      case NotificationType.adoption:
        return Icons.pets;

      case NotificationType.donation:
        return Icons.volunteer_activism;

      case NotificationType.volunteer:
        return Icons.groups;

      case NotificationType.announcement:
        return Icons.campaign;

      case NotificationType.system:
        return Icons.notifications;
    }
  }

  Color _color(NotificationType type) {
    switch (type) {
      case NotificationType.adoption:
        return Colors.green;

      case NotificationType.donation:
        return Colors.orange;

      case NotificationType.volunteer:
        return Colors.blue;

      case NotificationType.announcement:
        return Colors.purple;

      case NotificationType.system:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider =
        context.watch<NotificationProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        actions: [
          if (provider.unreadCount > 0)
            TextButton(
              onPressed: () async {
                await provider.markAllAsRead();
              },
              child: const Text(
                "Mark all",
              ),
            ),
        ],
      ),
      body: _loading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : provider.notifications.isEmpty
              ? ListView(
                  children: const [
                    SizedBox(height: 140),
                    Icon(
                      Icons.notifications_none,
                      size: 90,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Text(
                        "No notifications",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                )
              : ListView.separated(
                  padding:
                      const EdgeInsets.all(16),
                  itemCount:
                      provider.notifications.length,
                  separatorBuilder:
                      (_, __) =>
                          const SizedBox(
                    height: 12,
                  ),
                  itemBuilder:
                      (context, index) {
                    final notification =
                        provider.notifications[index];

                    return InkWell(
                      borderRadius:
                          BorderRadius.circular(
                              18),
                      onTap: () async {
                        if (!notification
                            .isRead) {
                          await provider
                              .markAsRead(
                            notification
                                .notificationId,
                          );
                          setState(() {});
                        }
                      },
                      child: AnimatedContainer(
                        duration:
                            const Duration(
                                milliseconds:
                                    250),
                        padding:
                            const EdgeInsets.all(
                                16),
                        decoration:
                            BoxDecoration(
                          color: notification
                                  .isRead
                              ? Colors.white
                              : Colors.blue
                                  .withOpacity(
                                      .06),
                          borderRadius:
                              BorderRadius
                                  .circular(
                                      18),
                          border: Border.all(
                            color: notification
                                    .isRead
                                ? Colors.grey
                                    .shade300
                                : Colors.blue,
                            width: notification
                                    .isRead
                                ? 1
                                : 1.5,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor:
                                  _color(notification
                                          .type)
                                      .withOpacity(
                                          .15),
                              child: Icon(
                                _icon(notification
                                    .type),
                                color: _color(
                                    notification
                                        .type),
                              ),
                            ),

                            const SizedBox(
                                width: 14),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child:
                                            Text(
                                          notification
                                              .title,
                                          style:
                                              TextStyle(
                                            fontWeight: notification
                                                    .isRead
                                                ? FontWeight
                                                    .w500
                                                : FontWeight
                                                    .bold,
                                            fontSize:
                                                16,
                                          ),
                                        ),
                                      ),
                                      if (!notification
                                          .isRead)
                                        Container(
                                          padding:
                                              const EdgeInsets.symmetric(
                                            horizontal:
                                                8,
                                            vertical:
                                                3,
                                          ),
                                          decoration:
                                              BoxDecoration(
                                            color: Colors
                                                .red,
                                            borderRadius:
                                                BorderRadius.circular(
                                                    12),
                                          ),
                                          child:
                                              const Text(
                                            "NEW",
                                            style:
                                                TextStyle(
                                              color: Colors
                                                  .white,
                                              fontSize:
                                                  11,
                                              fontWeight:
                                                  FontWeight.bold,
                                            ),
                                          ),
                                        )
                                    ],
                                  ),

                                  const SizedBox(
                                      height: 8),

                                  Text(
                                    notification
                                        .message,
                                    style:
                                        TextStyle(
                                      color: Colors
                                          .grey
                                          .shade700,
                                      height:
                                          1.4,
                                    ),
                                  ),

                                  const SizedBox(
                                      height: 10),

                                  Row(
                                    children: [
                                      Icon(
                                        Icons
                                            .schedule,
                                        size: 16,
                                        color: Colors
                                            .grey,
                                      ),
                                      const SizedBox(
                                          width:
                                              4),
                                      Text(
                                        DateFormat(
                                          "dd.MM.yyyy HH:mm",
                                        ).format(
                                          notification
                                              .dateSent,
                                        ),
                                        style:
                                            const TextStyle(
                                          color: Colors
                                              .grey,
                                          fontSize:
                                              12,
                                        ),
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
                  },
                ),
    );
  }
}