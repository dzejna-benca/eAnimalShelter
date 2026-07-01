import 'announcement.dart';

class MobileDashboard {
  final int totalVolunteerHours;
  final int hoursThisMonth;
  final List<MonthlyVolunteerHours> monthlyHours;
  final List<Announcement> recentNews;

  MobileDashboard({
    required this.totalVolunteerHours,
    required this.hoursThisMonth,
    required this.monthlyHours,
    required this.recentNews,
  });

  factory MobileDashboard.fromJson(
    Map<String, dynamic> json,
  ) {
    return MobileDashboard(
      totalVolunteerHours:
          json["totalVolunteerHours"] ?? 0,
      hoursThisMonth:
          json["hoursThisMonth"] ?? 0,
      monthlyHours:
          (json["monthlyHours"] as List?)
                  ?.map(
                    (e) =>
                        MonthlyVolunteerHours.fromJson(e),
                  )
                  .toList() ??
              [],
      recentNews:
          (json["recentNews"] as List?)
                  ?.map(
                    (e) =>
                        Announcement.fromJson(e),
                  )
                  .toList() ??
              [],
    );
  }
}

class MonthlyVolunteerHours {
  final String month;
  final int hours;

  MonthlyVolunteerHours({
    required this.month,
    required this.hours,
  });

  factory MonthlyVolunteerHours.fromJson(
      Map<String, dynamic> json) {
    return MonthlyVolunteerHours(
      month: json["month"],
      hours: json["hours"],
    );
  }
}