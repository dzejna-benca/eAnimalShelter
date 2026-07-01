import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../utils/app_config.dart';
import '../../models/mobile_dashboard.dart';
import '../../providers/dashboard_provider.dart';
import '../announcement_details_screen.dart';


class VolunteerDashboardPage extends StatefulWidget {
  const VolunteerDashboardPage({
    super.key,
  });

  @override
  State<VolunteerDashboardPage> createState() =>
      _VolunteerDashboardPageState();
}

class _VolunteerDashboardPageState
    extends State<VolunteerDashboardPage> {
  bool _loading = true;

  MobileDashboard? _dashboard;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final provider =
          context.read<DashboardProvider>();

      final result =
          await provider.getMobileDashboard();

      if (!mounted) return;

      setState(() {
        _dashboard = result;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_dashboard == null) {
      return const Center(
        child: Text(
          "Unable to load dashboard.",
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _load,
      child: SafeArea(
        child: SingleChildScrollView(
          physics:
              const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 5),

              const Text(
                "Welcome back 👋",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                "Thank you for helping shelter animals.",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 28),

              Row(
                children: [

                  Expanded(
                    child: _StatCard(
                      title: "Total Hours",
                      value: _dashboard!
                          .totalVolunteerHours
                          .toString(),
                      icon: Icons.schedule,
                      color: Colors.green,
                    ),
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: _StatCard(
                      title: "This Month",
                      value: _dashboard!
                          .hoursThisMonth
                          .toString(),
                      icon: Icons.calendar_month,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 35),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: const [

                  Text(
                    "Volunteer Hours",
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              Container(
                height: 260,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(.12),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    )
                  ],
                ),
                child: LineChart(
                  LineChartData(
                    minY: 0,
                    borderData:
                        FlBorderData(show: false),
                    gridData: FlGridData(
                      drawVerticalLine: false,
                    ),
                    titlesData: FlTitlesData(

                      topTitles:
                          const AxisTitles(),

                      rightTitles:
                          const AxisTitles(),

                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget:
                              (value, meta) {

                            if (value.toInt() >=
                                _dashboard!
                                    .monthlyHours
                                    .length) {
                              return const SizedBox();
                            }

                            return Padding(
                              padding:
                                  const EdgeInsets.only(
                                      top: 8),
                              child: Text(
                                _dashboard!
                                    .monthlyHours[
                                        value.toInt()]
                                    .month,
                                style:
                                    const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 32,
                        ),
                      ),
                    ),

                    lineBarsData: [

                      LineChartBarData(
                        isCurved: true,
                        barWidth: 4,
                        color: Colors.green,
                        dotData:
                            FlDotData(show: true),
                        belowBarData:
                            BarAreaData(
                          show: true,
                          color: Colors.green
                              .withOpacity(.15),
                        ),
                        spots: List.generate(
                          _dashboard!
                              .monthlyHours.length,
                          (index) {

                            final item =
                                _dashboard!
                                        .monthlyHours[
                                    index];

                            return FlSpot(
                              index.toDouble(),
                              item.hours
                                  .toDouble(),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 35),

              const Text(
                "Recent News",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 21,
                ),
              ),

              const SizedBox(height: 15),

              ..._dashboard!.recentNews.map(
                (news) => Padding(
                  padding:
                      const EdgeInsets.only(
                          bottom: 18),
                  child: _NewsCard(
                    news: news,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

 class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [

          CircleAvatar(
            radius: 28,
            backgroundColor:
                color.withOpacity(.12),
            child: Icon(
              icon,
              color: color,
              size: 30,
            ),
          ),

          const SizedBox(height: 15),

          Text(
            value,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _NewsCard extends StatelessWidget {
  final dynamic news;

  const _NewsCard({
    required this.news,
  });

  @override
  Widget build(BuildContext context) {
    String imageUrl = "";

    if (news.imageUrl != null &&
        news.imageUrl.isNotEmpty) {
      imageUrl =
          "${AppConfig.apiUrl}${news.imageUrl}";
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AnnouncementDetailsScreen(
                announcement: news,
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.08),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 190,
                width: double.infinity,
                child: imageUrl.isEmpty
                    ? Container(
                        color: Colors.grey.shade300,
                        child: const Center(
                          child: Icon(
                            Icons.pets,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (_, __, ___) {
                          return Container(
                            color: Colors.grey.shade300,
                            child: const Center(
                              child: Icon(
                                Icons.image_not_supported,
                                size: 60,
                              ),
                            ),
                          );
                        },
                      ),
              ),

              Padding(
                padding:
                    const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      news.title,
                      style:
                          const TextStyle(
                        fontSize: 20,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      news.content,
                      maxLines: 3,
                      overflow:
                          TextOverflow.ellipsis,
                      style: TextStyle(
                        color:
                            Colors.grey.shade700,
                        height: 1.45,
                      ),
                    ),

                    const SizedBox(height: 18),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 15,
                              color:
                                  Colors.grey.shade500,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              DateFormat(
                                "dd.MM.yyyy",
                              ).format(
                                news.publishedDate,
                              ),
                              style: TextStyle(
                                color:
                                    Colors.grey.shade500,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),

                        Row(
                          children: const [
                            Text(
                              "Tap to read",
                              style: TextStyle(
                                color:
                                    Colors.green,
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 6),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                              color: Colors.green,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
