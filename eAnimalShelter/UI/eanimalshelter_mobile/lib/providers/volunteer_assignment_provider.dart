import '../models/volunteer_assignment.dart';
import '../models/volunteer_assignment_insert_request.dart';
import 'base_provider.dart';

class VolunteerAssignmentProvider
    extends BaseProvider<VolunteerAssignment> {
  VolunteerAssignmentProvider()
      : super("VolunteerAssignment");

  @override
  VolunteerAssignment fromJson(data) {
    return VolunteerAssignment.fromJson(data);
  }
Future<VolunteerAssignment> apply(
      VolunteerAssignmentInsertRequest request) async {
    return await insert(request.toJson());
  }

  Future<VolunteerAssignment> cancel(
    int id,
  ) async {
    return await postCustom(
      "$id/cancel",
      {},
    );
  }

}