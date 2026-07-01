import '../models/notification.dart';
import 'base_provider.dart';

class NotificationProvider
    extends BaseProvider<NotificationModel> {
  NotificationProvider()
      : super("Notification");

  @override
  NotificationModel fromJson(data) {
    return NotificationModel.fromJson(data);
  }
}