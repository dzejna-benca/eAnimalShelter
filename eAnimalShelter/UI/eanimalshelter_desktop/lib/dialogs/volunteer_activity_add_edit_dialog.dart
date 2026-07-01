import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/location.dart';
import '../models/volunteer_activity.dart';
import '../models/requests/volunteer_activity_insert_request.dart';
import '../models/requests/volunteer_activity_update_request.dart';
import '../providers/location_provider.dart';
import '../providers/volunteer_activity_provider.dart';
import '../utils/message_helper.dart';
import '../utils/volunteer_activity_validator.dart';
import 'loaction_add_dialog.dart';


class VolunteerActivityAddEditDialog
    extends StatefulWidget {
  final VolunteerActivity? activity;

  const VolunteerActivityAddEditDialog({
    super.key,
    this.activity,
  });

  @override
  State<VolunteerActivityAddEditDialog>
      createState() =>
          _VolunteerActivityAddEditDialogState();
}

class _VolunteerActivityAddEditDialogState
    extends State<VolunteerActivityAddEditDialog> {
  late VolunteerActivityProvider
      _activityProvider;

  late LocationProvider
      _locationProvider;

  final _formKey =
      GlobalKey<FormState>();

  final _titleController =
      TextEditingController();

  final _descriptionController =
      TextEditingController();

  final _maxVolunteersController =
      TextEditingController();

  List<Location> _locations = [];

  int? _selectedLocationId;
  Location? get selectedLocation {
  if (_selectedLocationId == null) return null;

  try {
    return _locations.firstWhere(
      (e) => e.locationId == _selectedLocationId,
    );
  } catch (_) {
    return null;
  }
}

  DateTime? _startDateTime;
  DateTime? _endDateTime;

  bool _loading = true;
  bool _saving = false;

  String? _startDateError;
 String? _endDateError;

  bool get isEdit =>
      widget.activity != null;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback((_) {
      _initialize();
    });
  }

  Future<void> _initialize() async {
    _activityProvider =
        context.read<
          VolunteerActivityProvider
        >();

    _locationProvider =
        context.read<LocationProvider>();

  

    await _loadData();
  }

  Future<void> _loadData() async {
    try {
      var locationsResult =
          await _locationProvider.get(
        filter: {
          "page": 1,
          "pageSize": 1000,
        },
      );

      _locations =
          locationsResult.items;

      if (isEdit) {
        var activity =
            widget.activity!;

        _titleController.text =
            activity.title ?? "";

        _descriptionController.text =
            activity.description ?? "";

        _maxVolunteersController.text =
            activity.maxVolunteers
                    ?.toString() ??
                "";

        _selectedLocationId =
            activity.locationId;

        _startDateTime =
            activity.startDateTime;

        _endDateTime =
            activity.endDateTime;

      }

      setState(() {
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      MessageHelper.showError(
        context,
        e.toString(),
      );

      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _pickStartDate() async {
    var date =
        await showDatePicker(
      context: context,
      initialDate:
          _startDateTime ??
          DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

     if (!mounted || date == null) return;

    var time =
        await showTimePicker(
      context: context,
      initialTime:
          TimeOfDay.fromDateTime(
        _startDateTime ??
            DateTime.now(),
      ),
    );

   if (!mounted || time == null) return;

    setState(() {
      _startDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> _pickEndDate() async {
    var date =
        await showDatePicker(
      context: context,
      initialDate:
          _endDateTime ??
          DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (!mounted || date == null) return;

    var time =
        await showTimePicker(
      context: context,
      initialTime:
          TimeOfDay.fromDateTime(
        _endDateTime ??
            DateTime.now(),
      ),
    );

    if (!mounted || time == null) return;

    setState(() {
      _endDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  String _formatDateTime(
      DateTime? value) {
    if (value == null) {
      return "Select";
    }

    return "${value.day.toString().padLeft(2, '0')}."
        "${value.month.toString().padLeft(2, '0')}."
        "${value.year} "
        "${value.hour.toString().padLeft(2, '0')}:"
        "${value.minute.toString().padLeft(2, '0')}";
  }

  Future<void> _save() async {
    if (!_formKey.currentState!
        .validate()) {
      return;
    }
    setState(() {
      _startDateError = null;
      _endDateError = null;
    });

    if (_startDateTime == null) {
      setState(() {
        _startDateError = "Start date is required.";
      });
      return;
    }

    if (_endDateTime == null) {
      setState(() {
        _endDateError = "End date is required.";
      });
      return;
    }

    if (_startDateTime!.isBefore(DateTime.now())) {
      setState(() {
        _startDateError = "Start date must be in the future.";
      });
      return;
    }

    if (_endDateTime!.isBefore(_startDateTime!)) {
      setState(() {
        _endDateError = "End date must be after start date.";
      });
      return;
    }

    try {
      setState(() {
        _saving = true;
      });

      if (isEdit) {
        await _activityProvider
            .update(
          widget.activity!
              .activityId,
          VolunteerActivityUpdateRequest(
            title:
                _titleController.text,
            description:
                _descriptionController
                    .text,
            locationId:
                _selectedLocationId!,
            startDateTime:
                _startDateTime!,
            endDateTime:
                _endDateTime!,
            maxVolunteers:
                int.parse(
              _maxVolunteersController
                  .text,
            ),
          ).toJson(),
        );
      } else {
        await _activityProvider
            .insert(
          VolunteerActivityInsertRequest(
            title:
                _titleController.text,
            description:
                _descriptionController
                    .text,
            locationId:
                _selectedLocationId!,
            startDateTime:
                _startDateTime!,
            endDateTime:
                _endDateTime!,
            maxVolunteers:
                int.parse(
              _maxVolunteersController
                  .text,
            ),
          ).toJson(),
        );
      }

      if (!mounted) return;

      Navigator.pop(
        context,
        true,
      );
    } catch (e) {
      MessageHelper.showError(
        context,
        e.toString(),
      );
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }
Future<void> _loadLocations() async {
  final result = await _locationProvider.get(
    filter: {
      "page": 1,
      "pageSize": 1000,
    },
  );

  if (!mounted) return;

  setState(() {
    _locations = result.items;
  });
}

  @override
  Widget build(
    BuildContext context,
  ) {
    return AlertDialog(
      title: Text(
        isEdit
            ? "Edit Volunteer Activity"
            : "New Volunteer Activity",
      ),
      content: SizedBox(
        width: 700,
        child: _loading
            ? const SizedBox(
                height: 300,
                child: Center(
                  child:
                      CircularProgressIndicator(),
                ),
              )
            : Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize:
                        MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller:
                            _titleController,
                        decoration:
                            const InputDecoration(
                          labelText:
                              "Title",
                        ),
                        validator: VolunteerActivityValidator.validateTitle, 
                            
                      ),

                      const SizedBox(
                        height: 15,
                      ),

                      TextFormField(
                        controller:
                            _descriptionController,
                        maxLines: 4,
                        decoration:
                            const InputDecoration(
                          labelText:
                              "Description",
                        ),
                        validator: VolunteerActivityValidator.validateDescription,
                          
                      ),

                      const SizedBox(
                        height: 15,
                      ),

                      Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            value: _selectedLocationId,
                            validator: VolunteerActivityValidator.validateLocation,
                            decoration: const InputDecoration(
                              labelText: "Location",
                            ),
                            items: _locations.map((e) {
                              return DropdownMenuItem(
                                value: e.locationId,
                                child: Text(e.name ?? ""),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedLocationId = value;
                              });
                            },
                          ),
                        ),

                        const SizedBox(width: 10),

                        IconButton(
                          tooltip: "Add location",
                          icon: const Icon(Icons.add),
                          onPressed: () async {
                            final refresh = await showDialog<bool>(
                              context: context,
                              builder: (_) => const LocationAddDialog(),
                            );

                            if (refresh == true) {
                              await _loadLocations();
                            }
                          },
                        ),
                      ],
                    ),

                      const SizedBox(
                        height: 15,
                      ),

                      TextFormField(
                        controller:
                            _maxVolunteersController,
                        keyboardType:
                            TextInputType
                                .number,
                        decoration:
                            const InputDecoration(
                          labelText:
                              "Max Volunteers",
                        ),
                        validator: VolunteerActivityValidator.validateMaxVolunteers,
                            
                      ),

                     const SizedBox(
                        height: 15,
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: _pickStartDate,
                                  child: InputDecorator(
                                    decoration: const InputDecoration(
                                      labelText: "Start Date",
                                      border: OutlineInputBorder(),
                                      suffixIcon: Icon(Icons.calendar_month),
                                    ),
                                    child: Text(
                                      _formatDateTime(_startDateTime),
                                    ),
                                  ),
                                ),

                                if (_startDateError != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      _startDateError!,
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: _pickEndDate,
                                  child: InputDecorator(
                                    decoration: const InputDecoration(
                                      labelText: "End Date",
                                      border: OutlineInputBorder(),
                                      suffixIcon: Icon(Icons.calendar_month),
                                    ),
                                    child: Text(
                                      _formatDateTime(_endDateTime),
                                    ),
                                  ),
                                ),

                                if (_endDateError != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      _endDateError!,
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      
                      ],
                                          
                  ),
                ),
              ),
      ),
     actions: [
  TextButton(
    onPressed: _saving
        ? null
        : () => Navigator.pop(context),
    child: const Text("Cancel"),
  ),
  ElevatedButton(
    onPressed: _saving
        ? null
        : _save,
    child: const Text("Save"),
   ),
      ],
    );
  }
}
            

 