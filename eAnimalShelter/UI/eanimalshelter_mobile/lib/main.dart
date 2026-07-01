import 'package:eanimalshelter_mobile/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';

import 'providers/adoption_request_provider.dart';
import 'providers/animal_provider.dart';
import 'providers/animal_recommendation_provider.dart';
import 'providers/animal_view_history_provider.dart';
import 'providers/announcement_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/dashboard_provider.dart';
import 'providers/donation_provider.dart';
import 'providers/favorite_provider.dart';
import 'providers/notification_provider.dart';
import 'providers/profile_provider.dart';
import 'providers/volunteer_activity_provider.dart';
import 'providers/volunteer_assignment_provider.dart';
import 'dart:io';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  if (!Platform.isWindows) {
    Stripe.publishableKey =
        dotenv.env["STRIPE_PUBLISHABLE_KEY"]!;

  await Stripe.instance.applySettings();
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AnimalProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AdoptionRequestProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProfileProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => DonationProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => FavoriteProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => NotificationProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AnimalViewHistoryProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => RecommendationProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AnnouncementProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => VolunteerActivityProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => VolunteerAssignmentProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => DashboardProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "eAnimalShelter",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
      ),
      home: const LoginScreen(),
    );
  }
}