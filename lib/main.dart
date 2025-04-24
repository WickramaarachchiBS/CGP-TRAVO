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
import 'package:newone/services/auth_wrapper.dart';
import 'screens/signup_page.dart';
import 'screens/login_page.dart';
import 'screens/verify_page.dart';
import 'screens/forgotpassword_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
    await FirebaseAuth.instance.authStateChanges().first;
    print('Initial user on start: ${FirebaseAuth.instance.currentUser?.email}');
  } catch (e) {
    print('Firebase initialization failed: $e');
  }
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
        // '/locationHotel': (context) => LocationScreenHotel(),
        '/chatbot': (context) => ChatScreen(),
        '/auth': (context) => AuthWrapper(),
      },
    );
  }
}
