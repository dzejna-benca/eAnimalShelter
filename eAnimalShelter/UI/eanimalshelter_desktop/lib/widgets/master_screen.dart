import 'package:flutter/material.dart';

import '../providers/auth_provider.dart';
import '../screens/adoption_request_list_screen.dart';
import '../screens/animal_list_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/donation_list_screen.dart';
import '../screens/login_screen.dart';
import '../screens/notification_list_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/user_list_screen.dart';
import '../screens/volunteer_activity_list_screen.dart';

class MasterScreen extends StatelessWidget {
  final Widget child;
  final String title;
  final bool showBackButton;

  const MasterScreen({
    super.key,
    required this.child,
    required this.title,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [

          /// SIDEBAR
          SizedBox(
            width: 250,
            child: Material(
              color: const Color(0xfff5f5f5),
              child: Column(
                children: [

                  const SizedBox(height: 30),

                  const Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.pets,
                        color: Colors.teal,
                        size: 40,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "eAnimalShelter",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight:
                              FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  _menuItem(
                    context,
                    Icons.dashboard,
                    "Dashboard",
                    const DashboardScreen(),
                  ),

                  _menuItem(
                    context,
                    Icons.people,
                    "Users",
                    const UserListScreen(),
                  ),

                  _menuItem(
                    context,
                    Icons.pets,
                    "Animals",
                    const AnimalListScreen(),
                  ),

                  _menuItem(
                    context,
                    Icons.favorite,
                    "Adoptions",
                    const AdoptionRequestListScreen(),
                  ),

                  _menuItem(
                    context,
                    Icons.handshake,
                    "Volunteer Activities",
                    const VolunteerActivityListScreen(),
                  ),

                  _menuItem(
                    context,
                    Icons.volunteer_activism,
                    "Donations",
                    const DonationListScreen(),
                  ),

                  _menuItem(
                    context,
                    Icons.notifications,
                    "Notifications",
                    const NotificationListScreen(),
                  ),

                  const Spacer(),

                  const Divider(),

                  ListTile(
                    leading: const Icon(
                      Icons.logout,
                      color: Colors.red,
                    ),
                    title: const Text(
                      "Logout",
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const LoginScreen(),
                        ),
                        (route) => false,
                      );
                    },
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          /// MAIN CONTENT
          Expanded(
            child: Column(
              children: [

                Container(
                  height: 70,
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  decoration:
                      const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.black12,
                      ),
                    ),
                  ),

                  child: Row(
                    children: [

                      if (showBackButton)
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),

                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const Spacer(),

                      PopupMenuButton<String>(
                        tooltip: "",
                        offset:
                            const Offset(0, 45),

                        onSelected: (value) {

                          if (value ==
                              "profile") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const ProfileScreen(),
                              ),
                            );
                          }

                          if (value ==
                              "logout") {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const LoginScreen(),
                              ),
                              (route) => false,
                            );
                          }
                        },

                        itemBuilder: (_) => const [

                          PopupMenuItem(
                            value: "profile",
                            child: Row(
                              children: [

                                Icon(Icons.person),

                                SizedBox(width: 10),

                                Text(
                                  "My Profile",
                                ),
                              ],
                            ),
                          ),

                          PopupMenuDivider(),

                          PopupMenuItem(
                            value: "logout",
                            child: Row(
                              children: [

                                Icon(
                                  Icons.logout,
                                  color: Colors.red,
                                ),

                                SizedBox(width: 10),

                                Text(
                                  "Logout",
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        child: Row(
                          children: [

                            CircleAvatar(
                              backgroundColor:
                                  Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                              child: const Icon(
                                Icons.person,
                              ),
                            ),

                            const SizedBox(
                                width: 10),

                            Text(
                              AuthProvider.fullName,
                              style:
                                  const TextStyle(
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),

                            const SizedBox(
                                width: 4),

                            const Icon(
                              Icons.arrow_drop_down,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: child,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuItem(
    BuildContext context,
    IconData icon,
    String text,
    Widget screen,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => screen,
          ),
        );
      },
    );
  }
}