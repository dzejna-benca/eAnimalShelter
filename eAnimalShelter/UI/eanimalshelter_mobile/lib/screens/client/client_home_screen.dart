import 'package:eanimalshelter_mobile/models/animal_recommendation.dart';
import 'package:eanimalshelter_mobile/screens/animals/favorite_screen.dart';
import 'package:eanimalshelter_mobile/screens/donations/donate_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/announcement.dart';
import '../../providers/animal_recommendation_provider.dart';
import '../../providers/announcement_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/announcement_card.dart';
import '../../widgets/mobile_master_screen.dart';
import '../../widgets/recommendation_card.dart';
import '../animals/animals_screen.dart';
import '../profile/profile_screen.dart';

final GlobalKey<FavoritesScreenState> favoritesKey =
    GlobalKey<FavoritesScreenState>();

class ClientHomeScreen extends StatelessWidget {
  const ClientHomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MobileMasterScreen(
      onFavoritesSelected: () {
        favoritesKey.currentState?.refresh();
      },
      pages: [
        const ClientDashboardPage(),
        const AnimalsScreen(),
        FavoritesScreen(key: favoritesKey),
        const DonateScreen(),
        const ProfileScreen(),
      ],
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.pets),
          label: "Animals",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: "Favorites",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.volunteer_activism),
          label: "Donate",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: "Profile",
        ),
      ],
    );
  }
}

class ClientDashboardPage extends StatefulWidget {
  const ClientDashboardPage({
    super.key,
  });

  @override
  State<ClientDashboardPage> createState() =>
      _ClientDashboardPageState();
}

class _ClientDashboardPageState
    extends State<ClientDashboardPage> {
  List<AnimalRecommendation> _recommendations = [];

  bool _loading = true;
  List<Announcement> _news = [];


  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {

  try {

    final recommendationProvider =
        context.read<RecommendationProvider>();

    final announcementProvider =
        context.read<AnnouncementProvider>();

    final recommendations =
        await recommendationProvider
            .getRecommendations();

    final news =
        await announcementProvider
            .getLatest();

    if (!mounted) return;

    setState(() {
      _recommendations = recommendations;
      _news = news;
    });

  } finally {

    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }
}

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("eAnimalShelter"),
      ),
      body: _loading
    ? const Center(
        child: CircularProgressIndicator(),
      )
    : ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
          "Welcome back, ${authProvider.firstName}!",
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          "Here are the latest updates and personalized recommendations for you.",
          style: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 16,
          ),
        ),

        const SizedBox(height: 30),
          const Text(
            "Latest News",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          if (_news.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "No announcements available.",
                ),
              ),
            )
          else
            ..._news.map(
              (e) => AnnouncementCard(
                announcement: e,
              ),
            ),

          const SizedBox(height: 28),

          const Text(
            "Recommended for You",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          if (_recommendations.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "Browse animals to receive personalized recommendations.",
                ),
              ),
            )
          else
            SizedBox(
              height: 300,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _recommendations.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(width: 12),
                itemBuilder: (_, index) =>
                    RecommendationCard(
                  recommendation:
                      _recommendations[index],
                ),
              ),
            ),
        ],
      ),
    );
  }
}