import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../dialogs/donation_report_dialog.dart';
import '../models/donation.dart';
import '../models/search_objects/donation_search_object.dart';
import '../models/search_result.dart';
import '../providers/donation_provider.dart';
import '../widgets/master_screen.dart';
import 'donation_details_screen.dart';

class DonationListScreen extends StatefulWidget {
  const DonationListScreen({super.key});

  @override
  State<DonationListScreen> createState() =>
      _DonationListScreenState();
}

class _DonationListScreenState
    extends State<DonationListScreen> {

  late DonationProvider _provider;

  SearchResult<Donation>? result;

  final TextEditingController
      _searchController =
          TextEditingController();

  final TextEditingController
      _minAmountController =
          TextEditingController();

  final TextEditingController
      _maxAmountController =
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
        context.read<DonationProvider>();

    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      loading = true;
    });

    try {
      var data =
          await _provider.get(
        filter: DonationSearchObject(
          userFullName:
              _searchController.text
                      .trim()
                      .isEmpty
                  ? null
                  : _searchController.text,
          transactionStatus:
              selectedStatus,

          minAmount:
              double.tryParse(
            _minAmountController.text,
          ),

          maxAmount:
              double.tryParse(
            _maxAmountController.text,
          ),

          sortBy: sortBy,

          page: currentPage,
          pageSize: pageSize,
        ).toJson(),
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
        return "Successful";

      case 1:
        return "Failed";

      case 2:
        return "Pending";

      default:
        return "-";
    }
  }

  Color getStatusColor(
      int status) {
    switch (status) {
      case 0:
        return Colors.green;

      case 1:
        return Colors.red;

      case 2:
        return Colors.orange;

      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {

    int totalPages =
        ((result?.totalCount ?? 0) /
                pageSize)
            .ceil();

    return MasterScreen(
      title: "Donation Management",
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
                            controller:
                                _searchController,
                            decoration:
                                const InputDecoration(
                              labelText:
                                  "Search donor",
                              prefixIcon:
                                  Icon(Icons.search),
                            ),
                            onSubmitted: (_) {
                              currentPage = 1;
                              _loadData();
                            },
                          ),
                        ),

                        SizedBox(
                          width: 140,
                          child: TextField(
                            controller:
                                _minAmountController,
                            keyboardType:
                                TextInputType.number,
                            decoration:
                                const InputDecoration(
                              labelText:
                                  "Min Amount",
                            ),
                          ),
                        ),

                        SizedBox(
                          width: 140,
                          child: TextField(
                            controller:
                                _maxAmountController,
                            keyboardType:
                                TextInputType.number,
                            decoration:
                                const InputDecoration(
                              labelText:
                                  "Max Amount",
                            ),
                          ),
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
                                    "Successful"),
                              ),

                              DropdownMenuItem<
                                  int?>(
                                value: 1,
                                child: Text(
                                    "Failed"),
                              ),

                              DropdownMenuItem<
                                  int?>(
                                value: 2,
                                child: Text(
                                    "Pending"),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                selectedStatus =
                                    value;
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
                                    "amount_desc",
                                child: Text(
                                    "Highest Amount"),
                              ),

                              DropdownMenuItem(
                                value:
                                    "amount_asc",
                                child: Text(
                                    "Lowest Amount"),
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

                        ElevatedButton.icon(
                          onPressed: () async {
                            try {
                              var report =
                                  await _provider.getReport();

                              if (!mounted) return;

                              showDialog(
                                context: context,
                                builder: (_) => DonationReportDialog(
                                  report: report,
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                SnackBar(
                                  content: Text(e.toString()),
                                ),
                              );
                            }
                          },
                          icon: const Icon(
                            Icons.assessment,
                          ),
                          label: const Text(
                            "Make Report",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: Card(
                    elevation: 3,
                    child: Padding(
                      padding:
                          const EdgeInsets.all(
                              12),
                      child: result == null
                          ? const SizedBox()
                          : DataTable2(
                              columnSpacing:
                                  20,
                              horizontalMargin:
                                  12,
                              minWidth: 1000,

                              columns: const [

                                DataColumn2(
                                  label:
                                      Text("Donor"),
                                  size:
                                      ColumnSize.L,
                                ),

                                DataColumn2(
                                  label:
                                      Text("Amount"),
                                  size:
                                      ColumnSize.M,
                                ),

                                DataColumn2(
                                  label: Text(
                                      "Payment Method"),
                                  size:
                                      ColumnSize.M,
                                ),

                                DataColumn2(
                                  label:
                                      Text("Status"),
                                  size:
                                      ColumnSize.M,
                                ),

                                DataColumn2(
                                  label:
                                      Text("Date"),
                                  size:
                                      ColumnSize.M,
                                ),

                                DataColumn2(
                                  label:
                                      Text("Action"),
                                  size:
                                      ColumnSize.S,
                                ),
                              ],

                              rows: result!.items
                                  .map(
                                    (
                                      donation,
                                    ) {
                                      return DataRow(
                                        cells: [

                                          DataCell(
                                            Text(
                                              donation.userFullName ??
                                                  "",
                                            ),
                                          ),

                                          DataCell(
                                            Text(
                                              "${donation.amount?.toStringAsFixed(2)} KM",
                                            ),
                                          ),

                                          DataCell(
                                            Text(
                                              donation.paymentMethod ??
                                                  "",
                                            ),
                                          ),

                                          DataCell(
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal:
                                                    10,
                                                vertical:
                                                    4,
                                              ),
                                              decoration:
                                                  BoxDecoration(
                                                color: getStatusColor(
                                                  donation.transactionStatus,
                                                ).withOpacity(
                                                    0.15),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  20,
                                                ),
                                              ),
                                              child:
                                                  Text(
                                                getStatusText(
                                                  donation.transactionStatus,
                                                ),
                                                style:
                                                    TextStyle(
                                                  color:
                                                      getStatusColor(
                                                    donation.transactionStatus,
                                                  ),
                                                  fontWeight:
                                                      FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),

                                          DataCell(
                                            Text(
                                              donation
                                                      .donationDate
                                                      ?.toString()
                                                      .split(
                                                          " ")
                                                      .first ??
                                                  "",
                                            ),
                                          ),

                                          DataCell(
                                            ElevatedButton(
                                              onPressed:
                                                  () async {
                                                await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (_) =>
                                                            DonationDetailsScreen(
                                                      donationId:
                                                          donation.donationId!,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child:
                                                  const Text(
                                                "Details",
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  )
                                  .toList(),
                            ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.end,
                  children: [

                    ElevatedButton(
                      onPressed:
                          currentPage > 1
                              ? () {
                                  currentPage--;

                                  _loadData();
                                }
                              : null,
                      child:
                          const Text(
                        "Previous",
                      ),
                    ),

                    const SizedBox(
                        width: 15),

                    Text(
                      "Page $currentPage of $totalPages",
                    ),

                    const SizedBox(
                        width: 15),

                    ElevatedButton(
                      onPressed:
                          currentPage <
                                  totalPages
                              ? () {
                                  currentPage++;

                                  _loadData();
                                }
                              : null,
                      child:
                          const Text(
                        "Next",
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}