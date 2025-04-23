import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              print('Admin signing out: ${user?.email}');
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome, Admin ${user?.email ?? 'Admin'}!',
              style: const TextStyle(fontSize: 20),
            ),
            const Text('Manage CGP TRAVO features here'),
            ElevatedButton(
              onPressed: () {
                // Example: Navigate to manage hotels
                Navigator.pushNamed(context, '/allHotels');
              },
              child: const Text('Manage Hotels'),
            ),
            ElevatedButton(
              onPressed: () {
                // Example: Navigate to manage users
                print('Manage users clicked');
              },
              child: const Text('Manage Users'),
            ),
          ],
        ),
      ),
    );
  }
}
