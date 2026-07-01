import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/dashboard.dart';
import '../models/donation_report.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/master_screen.dart';
import '../widgets/recent_news.dart';
import '../widgets/stat_card.dart';
import '../providers/donation_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState
    extends State<DashboardScreen> {
  Dashboard? dashboard;
  bool loading = true;
  DonationReport? donationReport;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      dashboard =
          await DashboardProvider().getStats();
      donationReport =
          await DonationProvider().getReport();
    } catch (e) {
      debugPrint(e.toString());
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: "Dashboard",
      child: loading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : dashboard == null
              ? const Center(
                  child: Text(
                    "Failed to load dashboard data",
                  ),
                )
              : SingleChildScrollView(
                child: Column(
                  children: [
                    // STATISTIKE
                    Row(
                      children: [
                        Expanded(
                          child: StatCard(
                            title:
                                "Total Animals",
                            value: dashboard!
                                .totalAnimals
                                .toString(),
                            icon: Icons.pets,
                          ),
                        ),

                        const SizedBox(
                          width: 20,
                        ),

                        Expanded(
                          child: StatCard(
                            title:
                                "Approved Adoptions",
                            value: dashboard!
                                .approvedAdoptions
                                .toString(),
                            icon:
                                Icons.favorite,
                          ),
                        ),

                        const SizedBox(
                          width: 20,
                        ),

                        Expanded(
                          child: StatCard(
                            title:
                                "Volunteers",
                            value: dashboard!
                                .totalVolunteers
                                .toString(),
                            icon: Icons.people,
                          ),
                        ),

                        const SizedBox(
                          width: 20,
                        ),

                        Expanded(
                          child: StatCard(
                            title:
                                "Donations",
                            value: dashboard!
                                .totalDonations
                                .toStringAsFixed(
                                    2),
                            icon: Icons
                                .attach_money,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 30,
                    ),

                    // GRAFOVI
                    SizedBox(
                      height: 350,
                      child: Row(
                        children: [
                          // BAR CHART
                          Expanded(
                            flex: 3,
                            child: Card(
                              elevation: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Donations By Month",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),

                                    const SizedBox(height: 20),

                                    Expanded(
                                      child: donationReport == null
                                          ? const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            )
                                          : BarChart(
                                              BarChartData(
                                                borderData:
                                                    FlBorderData(
                                                  show: false,
                                                ),

                                                gridData:
                                                    FlGridData(
                                                  show: true,
                                                ),

                                                titlesData:
                                                    FlTitlesData(
                                                  rightTitles:
                                                      const AxisTitles(
                                                    sideTitles:
                                                        SideTitles(
                                                      showTitles:
                                                          false,
                                                    ),
                                                  ),
                                                  topTitles:
                                                      const AxisTitles(
                                                    sideTitles:
                                                        SideTitles(
                                                      showTitles:
                                                          false,
                                                    ),
                                                  ),
                                                  bottomTitles:
                                                      AxisTitles(
                                                    sideTitles:
                                                        SideTitles(
                                                      showTitles:
                                                          true,
                                                      getTitlesWidget:
                                                          (value,
                                                              meta) {
                                                        final months =
                                                            donationReport!
                                                                .donationsByMonth
                                                                .keys
                                                                .toList();

                                                        if (value
                                                                .toInt() <
                                                            months
                                                                .length) {
                                                          return Text(
                                                            months[value
                                                                .toInt()],
                                                          );
                                                        }

                                                        return const Text(
                                                            '');
                                                      },
                                                    ),
                                                  ),
                                                ),

                                                barGroups:
                                                    donationReport!
                                                        .donationsByMonth
                                                        .entries
                                                        .toList()
                                                        .asMap()
                                                        .entries
                                                        .map(
                                                          (e) =>
                                                              BarChartGroupData(
                                                            x: e.key,
                                                            barRods: [
                                                              BarChartRodData(
                                                                toY: (e
                                                                        .value
                                                                        .value
                                                                        as num)
                                                                    .toDouble(),
                                                                width:
                                                                    25,
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                        .toList(),
                                              ),
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 20),

                          // PIE CHART
                          Expanded(
                            flex: 2,
                            child: Card(
                              elevation: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Most Adopted Species",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),

                                    const SizedBox(height: 20),

                                    Expanded(
                                      child: dashboard!
                                              .adoptedAnimalsBySpecies
                                              .isEmpty
                                          ? const Center(
                                              child: Text("No data"),
                                            )
                                          : Builder(
                                              builder: (context) {
                                                final colors = [
                                                  Colors.blue,
                                                  Colors.orange,
                                                  Colors.green,
                                                  Colors.red,
                                                  Colors.purple,
                                                  Colors.teal,
                                                  Colors.amber,
                                                  Colors.pink,
                                                ];

                                                return Column(
                                                  children: [
                                                    Expanded(
                                                      child: PieChart(
                                                        PieChartData(
                                                          centerSpaceRadius: 45,
                                                          sections: dashboard!
                                                              .adoptedAnimalsBySpecies
                                                              .entries
                                                              .toList()
                                                              .asMap()
                                                              .entries
                                                              .map(
                                                                (entry) {
                                                                  final e =
                                                                      entry.value;

                                                                  return PieChartSectionData(
                                                                    value: (e.value
                                                                            as num)
                                                                        .toDouble(),
                                                                    title: '',
                                                                    radius: 60,
                                                                    color: colors[
                                                                        entry.key %
                                                                            colors
                                                                                .length],
                                                                  );
                                                                },
                                                              )
                                                              .toList(),
                                                        ),
                                                      ),
                                                    ),

                                                    const SizedBox(
                                                        height: 16),

                                                    Wrap(
                                                      spacing: 12,
                                                      runSpacing: 8,
                                                      alignment:
                                                          WrapAlignment
                                                              .center,
                                                      children:
                                                          dashboard!
                                                              .adoptedAnimalsBySpecies
                                                              .entries
                                                              .toList()
                                                              .asMap()
                                                              .entries
                                                              .map(
                                                                (entry) {
                                                                  final e =
                                                                      entry
                                                                          .value;

                                                                  return Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      Container(
                                                                        width:
                                                                            12,
                                                                        height:
                                                                            12,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              colors[entry.key %
                                                                                  colors.length],
                                                                          borderRadius:
                                                                              BorderRadius.circular(
                                                                                  2),
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                          width:
                                                                              6),
                                                                      Text(
                                                                        "${e.key} (${e.value})",
                                                                        style:
                                                                            const TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              )
                                                              .toList(),
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    const RecentNewsWidget(),
                                 ],
),
),
);
  }
    }