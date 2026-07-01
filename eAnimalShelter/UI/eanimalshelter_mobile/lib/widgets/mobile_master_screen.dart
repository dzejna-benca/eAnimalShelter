import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/notification_provider.dart';
import '../screens/auth/login_screen.dart';
import '../screens/notification_screen.dart';


class MobileMasterScreen extends StatefulWidget {
  final List<Widget> pages;
  final List<BottomNavigationBarItem> items;
 final VoidCallback? onFavoritesSelected;

  const MobileMasterScreen({
    super.key,
    required this.pages,
    required this.items,
    this.onFavoritesSelected,
  });

  @override
  State<MobileMasterScreen> createState() =>
      _MobileMasterScreenState();
}

class _MobileMasterScreenState
    extends State<MobileMasterScreen> {
  int _selectedIndex = 0;
  late NotificationProvider _notificationProvider;
  @override
void initState() {
  super.initState();

  _notificationProvider =
      context.read<NotificationProvider>();

  _notificationProvider.startPolling();
}
  @override
@override
void dispose() {
  _notificationProvider.stopPolling();
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      title: const Text("eAnimalShelter"),
      actions: [

      Consumer<NotificationProvider>(
        builder: (context, provider, child) {

          return Stack(
            children: [

              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const NotificationScreen(),
                    ),
                  );
                },
              ),

              if (provider.unreadCount > 0)
              Positioned(
                right: 6,
                top: 6,
                child: AnimatedSwitcher(
                  duration: const Duration(
                    milliseconds: 300,
                  ),
                  transitionBuilder:
                      (child, animation) =>
                          ScaleTransition(
                    scale: animation,
                    child: child,
                  ),
                  child: Container(
                    key: ValueKey(
                      provider.unreadCount,
                    ),
                    padding:
                        const EdgeInsets.all(5),
                    decoration:
                        const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints:
                        const BoxConstraints(
                      minHeight: 20,
                      minWidth: 20,
                    ),
                    child: Center(
                      child: Text(
                        provider.unreadCount > 99
                            ? "99+"
                            : provider.unreadCount
                                .toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight:
                              FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),

      IconButton(
        icon: const Icon(Icons.logout),
        onPressed: () async {
          await context
              .read<AuthProvider>()
              .logout();

          if (!mounted) return;

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
    ],
    ),
    body: IndexedStack(
      index: _selectedIndex,
      children: widget.pages,
    ),
    bottomNavigationBar: NavigationBar(
      selectedIndex: _selectedIndex,
      onDestinationSelected: (index) {
        setState(() {
          _selectedIndex = index;
        });

        if (index == 2) {
          widget.onFavoritesSelected?.call();
        }
      },
      destinations: widget.items
          .map(
            (item) => NavigationDestination(
              icon: item.icon,
              label: item.label ?? "",
            ),
          )
          .toList(),
    ),
  );
  }
}