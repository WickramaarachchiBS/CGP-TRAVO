import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:newone/components/AdminScreenAddHotels.dart';
import 'package:newone/components/adminScreenAddPlaces.dart';
import 'package:newone/components/adminScreenBookings.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Admin Dashboard',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: CircleAvatar(
                child: PopupMenuButton<String>(
                  icon: const Icon(Icons.person),
                  onSelected: (value) {
                    if (value == 'logout') {
                      FirebaseAuth.instance.signOut();
                      Navigator.pushReplacementNamed(context, '/login');
                      print('Logged out');
                    }
                    if (value == 'home') {
                      Navigator.pushReplacementNamed(context, '/home');
                      print('Navigating to Home Page');
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    const PopupMenuItem<String>(
                      value: 'home',
                      child: Text('Home'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'logout',
                      child: Text('Logout'),
                    ),
                  ],
                ),
              ),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Add Place'),
              Tab(text: 'Add Hotel'),
              Tab(text: 'Bookings'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            AddPlaceSection(),
            AddHotelSection(),
            AllBookingSection(),
          ],
        ),
      ),
    );
  }
}
