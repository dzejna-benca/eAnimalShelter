import '../models/announcement.dart';
import 'base_provider.dart';

class AnnouncementProvider
    extends BaseProvider<Announcement> {

  AnnouncementProvider()
      : super("Announcement");

  @override
  Announcement fromJson(data) =>
      Announcement.fromJson(data);

  Future<List<Announcement>> getLatest() async {

    final result = await get(filter: {
      "isActive": true,
      "page": 1,
      "pageSize": 3,
      "sortBy": "date_desc",
    });

    return result.items;
  }
}