import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/adoption_request.dart';
import '../models/search_result.dart';
import '../providers/adoption_request_provider.dart';
import '../widgets/master_screen.dart';
import 'adoption_request_details_screen.dart';

class AdoptionRequestListScreen extends StatefulWidget {
  const AdoptionRequestListScreen({super.key});

  @override
  State<AdoptionRequestListScreen> createState() =>
      _AdoptionRequestListScreenState();
}

class _AdoptionRequestListScreenState
    extends State<AdoptionRequestListScreen> {

  late AdoptionRequestProvider _provider;

  SearchResult<AdoptionRequest>? result;

  final TextEditingController
      _searchController =
          TextEditingController();

  int? selectedStatus;

  String? sortBy;

  int currentPage = 1;
  int pageSize = 10;

  bool loading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _provider =
        context.read<
            AdoptionRequestProvider>();

    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      loading = true;
    });

    try {
      var data =
          await _provider.get(
        filter: {
          "page": currentPage,
          "pageSize": pageSize,
          "includeTotalCount": true,

          "fts":
              _searchController.text,

          "status":
              selectedStatus,

          "sortBy": sortBy,
        },
      );

      setState(() {
        result = data;
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(
          content:
              Text(e.toString()),
        ),
      );
    }
  }

  String getStatusText(
      int status) {
    switch (status) {
      case 0:
        return "Pending";

      case 1:
        return "Approved";

      case 2:
        return "Rejected";

      case 3:
        return "Cancelled";

      default:
        return "-";
    }
  }

  Color getStatusColor(
      int status) {
    switch (status) {
      case 0:
        return Colors.orange;

      case 1:
        return Colors.green;

      case 2:
        return Colors.red;

      case 3:
        return Colors.grey;

      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalPages = ((result?.totalCount ?? 0) / pageSize).ceil();
    return MasterScreen(
      title: "Adoption Requests",
      child: loading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : Column(
              children: [

                Card(
                  child: Padding(
                    padding:
                        const EdgeInsets.all(
                            16),
                    child: Wrap(
                      spacing: 15,
                      runSpacing: 15,
                      crossAxisAlignment:
                          WrapCrossAlignment
                              .end,
                      children: [

                        SizedBox(
                          width: 280,
                          child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            labelText: "Search applicant or animal",
                            prefixIcon: Icon(Icons.search),
                          ),
                          onSubmitted: (_) {
                            currentPage = 1;
                            _loadData();
                          },
                        )
                        ),

                        SizedBox(
                          width: 180,
                          child:
                              DropdownButtonFormField<
                                  int?>(
                            value:
                                selectedStatus,
                            decoration:
                                const InputDecoration(
                              labelText:
                                  "Status",
                            ),
                            items: const [
                              DropdownMenuItem<
                                  int?>(
                                value: null,
                                child:
                                    Text("All"),
                              ),
                              DropdownMenuItem<
                                  int?>(
                                value: 0,
                                child: Text(
                                    "Pending"),
                              ),
                              DropdownMenuItem<
                                  int?>(
                                value: 1,
                                child: Text(
                                    "Approved"),
                              ),
                              DropdownMenuItem<
                                  int?>(
                                value: 2,
                                child: Text(
                                    "Rejected"),
                              ),
                              DropdownMenuItem<
                                  int?>(
                                value: 3,
                                child: Text(
                                    "Cancelled"),
                              ),
                            ],
                            onChanged: (value) {
                            setState(() {
                              selectedStatus = value;
                              currentPage = 1;
                            });

                            _loadData();
                          },
                          ),
                        ),

                        SizedBox(
                          width: 220,
                          child:
                              DropdownButtonFormField<
                                  String>(
                            value: sortBy,
                            decoration:
                                const InputDecoration(
                              labelText:
                                  "Sort By",
                            ),
                            items: const [
                              DropdownMenuItem(
                                value:
                                    "date_desc",
                                child: Text(
                                    "Newest First"),
                              ),
                              DropdownMenuItem(
                                value:
                                    "date_asc",
                                child: Text(
                                    "Oldest First"),
                              ),
                              DropdownMenuItem(
                                value:
                                    "name_asc",
                                child: Text(
                                    "Applicant A-Z"),
                              ),
                              DropdownMenuItem(
                                value:
                                    "name_desc",
                                child: Text(
                                    "Applicant Z-A"),
                              ),
                              DropdownMenuItem(
                                value:
                                    "animal_asc",
                                child: Text(
                                    "Animal A-Z"),
                              ),
                              DropdownMenuItem(
                                value:
                                    "animal_desc",
                                child: Text(
                                    "Animal Z-A"),
                              ),
                              DropdownMenuItem(
                                value:
                                    "status_asc",
                                child: Text(
                                    "Status A-Z"),
                              ),
                              DropdownMenuItem(
                                value:
                                    "status_desc",
                                child: Text(
                                    "Status Z-A"),
                              ),
                            ],
                            onChanged: (value) {
                            setState(() {
                              sortBy = value;
                              currentPage = 1;
                            });

                            _loadData();
                          },
                          ),
                        ),

                        ElevatedButton.icon(
                          onPressed: () {
                            currentPage = 1;
                            _loadData();
                          },
                          icon: const Icon(
                            Icons.search,
                          ),
                          label:
                              const Text(
                            "Search",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(
                    height: 20),

                Expanded(
                  child: Card(
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: result == null
                          ? const SizedBox()
                          : DataTable2(
                              columnSpacing: 20,
                              horizontalMargin: 12,
                              minWidth: 900,

                              columns: const [
                                DataColumn2(
                                  label: Text("Applicant"),
                                  size: ColumnSize.S,
                                ),
                                DataColumn2(
                                  label: Text("Animal"),
                                  size: ColumnSize.S,
                                ),
                                DataColumn2(
                                  label: Text("Request Date"),
                                  size: ColumnSize.S,
                                ),
                                DataColumn2(
                                  label: Text("Status"),
                                  size: ColumnSize.S,
                                ),
                                DataColumn2(
                                  label: Text("Action"),
                                  size: ColumnSize.S,
                                ),
                              ],

                              rows: result!.items.map((request) {
                                return DataRow(
                                  cells: [

                                    DataCell(
                                      Text(
                                        request.userName ?? "",
                                      ),
                                    ),

                                    DataCell(
                                      Text(
                                        request.animalName ?? "",
                                      ),
                                    ),

                                    DataCell(
                                      Text(
                                        request.requestDate
                                            .toString()
                                            .split(" ")
                                            .first,
                                      ),
                                    ),

                                    DataCell(
                                      Container(
                                        padding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: getStatusColor(
                                            request.status,
                                          ).withOpacity(0.15),
                                          borderRadius:
                                              BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Text(
                                          getStatusText(
                                            request.status,
                                          ),
                                          style: TextStyle(
                                            color: getStatusColor(
                                              request.status,
                                            ),
                                            fontWeight:
                                                FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),

                                    DataCell(
                                      ElevatedButton(
                                        onPressed: () async {
                                          var refresh =
                                              await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  AdoptionRequestDetailsScreen(
                                                request: request,
                                              ),
                                            ),
                                          );

                                          if (refresh == true) {
                                            _loadData();
                                          }
                                        },
                                        child:
                                            const Text("Details"),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                    ),
                  ),
                ),

                const SizedBox(
                    height: 15),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: currentPage > 1
                          ? () {
                              currentPage--;
                              _loadData();
                            }
                          : null,
                      child: const Text("Previous"),
                    ),

                    const SizedBox(width: 15),

                    Text(
                      "Page $currentPage of $totalPages",
                    ),

                    const SizedBox(width: 15),

                    ElevatedButton(
                      onPressed: currentPage < totalPages
                          ? () {
                              currentPage++;
                              _loadData();
                            }
                          : null,
                      child: const Text("Next"),
                    ),
                  ],
                )
                
              ],
            ),
    );
  }
}