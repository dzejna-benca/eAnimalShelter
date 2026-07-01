import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/adoption_request_provider.dart';
import 'providers/animal_breed_provider.dart';
import 'providers/animal_provider.dart';
import 'providers/animal_species_provider.dart';
import 'providers/announcement_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/donation_provider.dart';
import 'providers/location_provider.dart';
import 'providers/notification_provider.dart';
import 'providers/profile_provider.dart';
import 'providers/volunteer_activity_provider.dart';
import 'providers/volunteer_assignment_provider.dart';
import 'screens/login_screen.dart';

import 'providers/role_provider.dart';
import 'providers/user_provider.dart';
import 'providers/animal_image_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => RoleProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AnimalProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AnimalSpeciesProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AnimalBreedProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AdoptionRequestProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AnimalImageProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => VolunteerActivityProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => VolunteerAssignmentProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => LocationProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => DonationProvider()
          ),
          ChangeNotifierProvider(
          create: (_) =>
              AnnouncementProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => 
              NotificationProvider()),
        ChangeNotifierProvider(
          create: (_) => ProfileProvider(),
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
      title: 'eAnimal Shelter Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
        ),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}