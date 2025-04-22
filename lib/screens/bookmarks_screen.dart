import 'package:flutter/material.dart';
import 'package:newone/screens/location_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:newone/Data/Bookmarks.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Bookmarks"),
          centerTitle: true,
        ),
        body: Center(
          child: Text("Please log in to view your bookmarks"),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bookmarks"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: [
              // Popular Places Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Bookmarked Locations...",
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Popular Places List
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('bookmarks').where('userId', isEqualTo: user.uid).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    final popularPlaces = snapshot.data!.docs.map((doc) => Bookmarks.fromFirestore(doc.data() as Map<String, dynamic>)).toList();

                    if (popularPlaces.isEmpty) {
                      return Center(child: Text("No bookmarked locations yet"));
                    }

                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: popularPlaces.length,
                      itemBuilder: (context, index) {
                        final popular = popularPlaces[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LocationScreen(
                                  place: popular.name,
                                  imagePath: popular.imagePath,
                                  latitude: popular.latitude.toString(),
                                  longitude: popular.longitude.toString(),
                                  desc: popular.desc,
                                ),
                              ),
                            );
                            print('Tapped on ${popular.name}');
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                                  child: CachedNetworkImage(
                                    imageUrl: popular.imagePath,
                                    height: 120,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) => Container(
                                      height: 120,
                                      color: Colors.grey,
                                      child: Center(child: Text('Image not found')),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        popular.name,
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
