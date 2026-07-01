import '../models/volunteer_activity.dart';
import '../models/volunteer_activity_details.dart';
import 'base_provider.dart';

class VolunteerActivityProvider
    extends BaseProvider<VolunteerActivity> {
  VolunteerActivityProvider()
      : super("VolunteerActivity");

  @override
  VolunteerActivity fromJson(data) {
      return VolunteerActivity.fromJson(data);
    }
    Future<VolunteerActivityDetails> getDetails(
      int id) async {
    final data =
        await getRaw<Map<String, dynamic>>(
      "$id/details",
    );

    return VolunteerActivityDetails.fromJson(
      data,
    );
  }
}