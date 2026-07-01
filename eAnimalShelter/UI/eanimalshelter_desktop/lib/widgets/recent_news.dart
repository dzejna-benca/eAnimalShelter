import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../dialogs/announcement_add_edit_dialog.dart';
import '../models/announcement.dart';
import '../providers/announcement_provider.dart';
import '../providers/base_provider.dart';
import '../utils/dialog_helper.dart';
import '../utils/message_helper.dart';

class RecentNewsWidget
    extends StatefulWidget {
  const RecentNewsWidget({
    super.key,
  });

  @override
  State<RecentNewsWidget>
      createState() =>
          _RecentNewsWidgetState();
}

class _RecentNewsWidgetState
    extends State<RecentNewsWidget> {

  List<Announcement> news = [];
  bool loading = true;

  AnnouncementProvider get provider =>
    context.read<AnnouncementProvider>();

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      final provider =
          context.read<AnnouncementProvider>();

      final result = await provider.get(
        filter: {
          "page": 1,
          "pageSize": 5,
          "isActive": true,
        },
      );

      if (!mounted) return;

      setState(() {
        news = result.items;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  Future<void> addNews() async {
    final created =
        await showDialog<bool>(
      context: context,
      builder: (_) =>
          const AnnouncementDialog(),
    );

    if (created == true) {
      await load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding:
            const EdgeInsets.all(20),
        child: Column(
          children: [

            Row(
              children: [

                const Text(
                  "Recent News",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const Spacer(),

                ElevatedButton.icon(
                  onPressed: addNews,
                  icon: const Icon(
                    Icons.add,
                  ),
                  label:
                      const Text(
                    "Add News",
                  ),
                ),
              ],
            ),

            const SizedBox(
                height: 15),

           ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: news.length,
            separatorBuilder: (_, __) =>
                const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = news[index];

              final imageUrl =
                  item.imageUrl != null &&
                          item.imageUrl!.isNotEmpty
                      ? "${BaseProvider.baseUrl}${item.imageUrl!.replaceFirst("/", "")}"
                      : null;

              return Container(
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(16),
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey.shade200,
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      // IMAGE
                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(12),
                        child: imageUrl != null
                            ? Image.network(
                                imageUrl,
                                width: 120,
                                height: 90,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (_, __, ___) =>
                                        Container(
                                  width: 120,
                                  height: 90,
                                  color:
                                      Colors.grey.shade200,
                                  child: const Icon(
                                    Icons.image,
                                    size: 40,
                                  ),
                                ),
                              )
                            : Container(
                                width: 120,
                                height: 90,
                                color:
                                    Colors.grey.shade200,
                                child: const Icon(
                                  Icons.article,
                                  size: 40,
                                ),
                              ),
                      ),

                      const SizedBox(width: 15),

                      // CONTENT
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style:
                                  const TextStyle(
                                fontSize: 17,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            const SizedBox(
                              height: 6,
                            ),

                            Text(
                              item.content,
                              maxLines: 3,
                              overflow:
                                  TextOverflow
                                      .ellipsis,
                              style: TextStyle(
                                color:
                                    Colors.grey[700],
                              ),
                            ),

                            const SizedBox(
                              height: 8,
                            ),

                            Text(
                              item.publishedDate !=
                                      null
                                  ? "${item.publishedDate!.day}.${item.publishedDate!.month}.${item.publishedDate!.year}"
                                  : "",
                              style: TextStyle(
                                color:
                                    Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),

                      PopupMenuButton<String>(
                        onSelected:
                            (value) async {
                          if (value ==
                              "edit") {
                            final updated =
                                await showDialog<
                                    bool>(
                              context:
                                  context,
                              builder: (_) =>
                                  AnnouncementDialog(
                                announcement:
                                    item,
                              ),
                            );

                            if (updated ==
                                true) {
                              await load();
                            }
                          }
                         
                          if (value == "delete") {
                          final confirm =
                              await DialogHelper.confirmAction(
                            context,
                            title: "Delete announcement",
                            message:
                                "Are you sure you want to delete this announcement?",
                            confirmText: "Delete",
                            isDestructive: true,
                          );

                          if (!mounted || !confirm) return;

                          await provider.delete(
                            item.announcementId,
                          );

                          if (!mounted) return;

                          await load();

                          if (!mounted) return;

                          MessageHelper.showSuccess(
                            context,
                            "Announcement deleted successfully.",
                          );
                        }
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(
                          value: "edit",
                          child: Text("Edit"),
                        ),
                        PopupMenuItem(
                          value: "delete",
                          child: Text("Delete"),
                        ),
                      ],
                    ),
                    ],
                  ),
                ),
              );
            },
          )
            
          ],
        ),
      ),
    );
  }
}