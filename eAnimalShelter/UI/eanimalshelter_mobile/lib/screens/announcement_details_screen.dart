import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/announcement.dart';
import '../utils/app_config.dart';

class AnnouncementDetailsScreen extends StatelessWidget {
  final Announcement announcement;

  const AnnouncementDetailsScreen({
    super.key,
    required this.announcement,
  });

  @override
  Widget build(BuildContext context) {
    String? imageUrl;

    if (announcement.imageUrl != null &&
        announcement.imageUrl!.isNotEmpty) {
      imageUrl =
          "${AppConfig.baseUrl}${announcement.imageUrl}";
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Announcement"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            if (imageUrl != null)
              Image.network(
                imageUrl,
                width: double.infinity,
                height: 260,
                fit: BoxFit.cover,
              ),

            Padding(
              padding:
                  const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    announcement.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    DateFormat(
                      "dd.MM.yyyy HH:mm",
                    ).format(
                      announcement.publishedDate,
                    ),
                    style: TextStyle(
                      color:
                          Colors.grey.shade600,
                    ),
                  ),

                  const SizedBox(height: 24),

                  Text(
                    announcement.content,
                    style: const TextStyle(
                      fontSize: 17,
                      height: 1.6,
                    ),
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