import '../models/mobile_dashboard.dart';
import 'base_provider.dart';

class DashboardProvider
    extends BaseProvider<MobileDashboard> {
  DashboardProvider()
      : super("Dashboard");

  @override
  MobileDashboard fromJson(data) =>
      MobileDashboard.fromJson(data);

  Future<MobileDashboard> getMobileDashboard() async {
    return await getSingle("mobile");
  }
}