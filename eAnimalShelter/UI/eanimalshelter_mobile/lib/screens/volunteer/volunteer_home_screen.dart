import 'package:flutter/material.dart';

import '../../widgets/mobile_master_screen.dart';
import '../profile/profile_screen.dart';
import 'volunteer_activites_screen.dart';
import 'volunteer_dashboard_screen.dart';
import 'volunteer_my_activities_screen.dart';

class VolunteerHomeScreen extends StatelessWidget {
  const VolunteerHomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MobileMasterScreen(
      pages: [
        VolunteerDashboardPage(),
        VolunteerActivitiesScreen(),
        VolunteerMyActivitiesScreen(),
        ProfileScreen(showAdoptionRequests: false),
      ],
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.volunteer_activism),
          label: "Activities",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment),
          label: "Applied",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: "Profile",
        ),
      ],
    );
  }
}


