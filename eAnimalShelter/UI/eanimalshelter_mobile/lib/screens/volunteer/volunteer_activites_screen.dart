import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/volunteer_activity.dart';
import '../../providers/volunteer_activity_provider.dart';
import 'volunteer_activity_details_screen.dart';

class VolunteerActivitiesScreen extends StatefulWidget {
  const VolunteerActivitiesScreen({super.key});

  @override
  State<VolunteerActivitiesScreen> createState() =>
      _VolunteerActivitiesScreenState();
}

class _VolunteerActivitiesScreenState
    extends State<VolunteerActivitiesScreen> {
  bool _loading = true;

  List<VolunteerActivity> _activities = [];
  String _search = "";
  String _sortBy = "date";
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  Future<void> _loadActivities() async {
    setState(() => _loading = true);

    try {
      final provider =
          context.read<VolunteerActivityProvider>();

      final result = await provider.get(
        filter: {
          "status": 0,
          "title": _search.isEmpty ? null : _search,
          "startDateTimeFrom":
              _selectedDate?.toIso8601String(),
          "sortBy": _sortBy,
        },
      );

      if (!mounted) return;

      setState(() {
        _activities = result.items!;
      });
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
Widget build(BuildContext context) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: TextField(
          decoration: InputDecoration(
            hintText: "Search activities",
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: (value) {
            _search = value;
            _loadActivities();
          },
        ),
      ),

      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.filter_alt_outlined),
                label: Text(
                  _selectedDate == null
                      ? "Any date"
                      : DateFormat(
                          "dd.MM.yyyy",
                        ).format(_selectedDate!),
                ),
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate:
                        _selectedDate ?? DateTime.now(),
                    firstDate: DateTime(2024),
                    lastDate: DateTime(2100),
                  );

                  if (picked != null) {
                    _selectedDate = picked;
                    _loadActivities();
                  }
                },
              ),
            ),

            if (_selectedDate != null)
              IconButton(
                tooltip: "Clear date",
                icon: const Icon(Icons.close),
                onPressed: () {
                  _selectedDate = null;
                  _loadActivities();
                },
              ),

            PopupMenuButton<String>(
              tooltip: "Sort",
              onSelected: (value) {
                _sortBy = value;
                _loadActivities();
              },
              itemBuilder: (_) => const [
                PopupMenuItem(
                  value: "date",
                  child: Text("Sort by Date"),
                ),
                PopupMenuItem(
                  value: "title",
                  child: Text("Sort by Title"),
                ),
                PopupMenuItem(
                  value: "location",
                  child: Text("Sort by Location"),
                ),
              ],
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 11,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.shade400,
                  ),
                  borderRadius:
                      BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.sort),
                    SizedBox(width: 6),
                    Text("Sort"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      const SizedBox(height: 12),

      Expanded(
        child: _loading
            ? const Center(
                child:
                    CircularProgressIndicator(),
              )
            : _activities.isEmpty
                ? const Center(
                    child: Text(
                      "No volunteer activities available.",
                    ),
                  )
                : ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    itemCount: _activities.length,
                    itemBuilder: (context, index) {
                      final activity =
                          _activities[index];

                      return Card(
                        elevation: 3,
                        margin:
                            const EdgeInsets.only(
                          bottom: 16,
                        ),
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            16,
                          ),
                        ),
                        child: InkWell(
                          borderRadius:
                              BorderRadius.circular(
                            16,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    VolunteerActivityDetailsScreen(
                                  activity:
                                      activity,
                                ),
                              ),
                            ).then((_) {
                              _loadActivities();
                            });
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.all(
                                    16),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [
                                Text(
                                  activity.title,
                                  style:
                                      const TextStyle(
                                    fontSize: 20,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),

                                const SizedBox(
                                    height: 14),

                                Row(
                                  children: [
                                    const Icon(
                                      Icons
                                          .location_on_outlined,
                                      size: 18,
                                    ),
                                    const SizedBox(
                                        width: 8),
                                    Expanded(
                                      child: Text(
                                        activity.locationName ??
                                            "",
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(
                                    height: 8),

                                Row(
                                  children: [
                                    const Icon(
                                      Icons
                                          .calendar_today_outlined,
                                      size: 18,
                                    ),
                                    const SizedBox(
                                        width: 8),
                                    Text(
                                      DateFormat(
                                              "dd.MM.yyyy")
                                          .format(
                                        activity
                                            .startDateTime,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(
                                    height: 8),

                                Row(
                                  children: [
                                    const Icon(
                                      Icons
                                          .access_time,
                                      size: 18,
                                    ),
                                    const SizedBox(
                                        width: 8),
                                    Text(
                                      "${DateFormat("HH:mm").format(activity.startDateTime)} - "
                                      "${DateFormat("HH:mm").format(activity.endDateTime)}",
                                    ),
                                  ],
                                ),

                                const SizedBox(
                                    height: 8),

                                Row(
                                  children: [
                                    const Icon(
                                      Icons
                                          .people_outline,
                                      size: 18,
                                    ),
                                    const SizedBox(
                                        width: 8),
                                    Text(
                                      "${activity.currentVolunteers}/${activity.maxVolunteers} volunteers",
                                    ),
                                  ],
                                ),

                                const SizedBox(
                                    height: 18),

                                Align(
                                  alignment:
                                      Alignment
                                          .centerRight,
                                  child:
                                      FilledButton.icon(
                                    icon:
                                        const Icon(
                                      Icons
                                          .arrow_forward,
                                    ),
                                    label:
                                        const Text(
                                      "Details",
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) =>
                                                  VolunteerActivityDetailsScreen(
                                            activity:
                                                activity,
                                          ),
                                        ),
                                      ).then((_) {
                                        _loadActivities();
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
      ),
    ],
  );
}
    }