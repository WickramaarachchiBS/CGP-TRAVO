import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:newone/screens/admin_screen.dart';
import 'package:newone/screens/all_hotels_screen.dart';
import 'package:newone/screens/bookmarks_screen.dart';
import 'package:newone/screens/chatbot_screen.dart';
import 'package:newone/screens/districts_screen.dart';
import 'package:newone/screens/home_screen.dart';
import 'package:newone/screens/location_hotel_screen.dart';
import 'package:newone/screens/schedule_screen.dart';
import 'package:newone/screens/welcome_screen.dart';
import 'package:newone/services/auth_layout.dart';
import 'screens/signup_page.dart';
import 'screens/login_page.dart';
import 'screens/verify_page.dart';
import 'screens/forgotpassword_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: ' CGP TRAVO',
      home: AuthWrapper(),
      routes: {
        '/welcome': (context) => WelcomeScreen(),
        '/admin': (context) => AdminScreen(),
        '/home': (context) => HomeScreen(),
        '/signup': (context) => SignUpPage(),
        '/login': (context) => LogInPage(),
        '/verify': (context) => VerifyPage(),
        '/forgotPW': (context) => ForgotPWPage(),
        '/allPlaces': (context) => AllPlacesScreen(),
        '/allHotels': (context) => HotelsPage(),
        '/schedule': (context) => SchedulePage(),
        '/bookmarks': (context) => BookmarksScreen(),
        '/locationHotel': (context) => LocationScreenHotel(),
        'chatbot': (context) => ChatScreen(),
      },
    );
  }
}
