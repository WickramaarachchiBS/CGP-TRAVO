import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:newone/screens/chatbot_screen.dart';
import 'package:newone/screens/location_screen.dart';
import 'package:newone/services/locationServices.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:newone/Data/Popular.dart';
import 'package:newone/Data/Popular.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _address = 'Fetching address...';
  String? _userName = 'User';

  @override
  void initState() {
    super.initState();
    _fetchUserAddress();
    _fetchLoggedInUser();
  }

  Future<void> _fetchLoggedInUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        String email = user.email ?? 'User';
        _userName = email.split('@').first;
      });
      print(_userName);
    }
  }

  Future<void> _fetchUserAddress() async {
    GoogleServices googleServices = GoogleServices();
    LatLng? currentLocation = await googleServices.getCurrentLocation();

    if (currentLocation != null) {
      String? address = await googleServices.getAddressFromLatLng(currentLocation);
      setState(() {
        _address = address ?? "Unable to fetch address";
      });
    } else {
      setState(() {
        _address = "Unable to fetch location";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top User Section
              //add logged in username and current location
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hi, $_userName",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.grey, size: 16),
                          Text(
                            _address ?? 'Fetching address...',
                            style: const TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                          child: PopupMenuButton<String>(
                        icon: Icon(Icons.person),
                        onSelected: (value) {
                          if (value == 'logout') {
                            FirebaseAuth.instance.signOut();
                            Navigator.pushReplacementNamed(context, '/login');
                            print('Logged out');
                          }
                        },
                        itemBuilder: (BuildContext context) => [
                          const PopupMenuItem<String>(
                            value: 'logout',
                            child: Text('Logout'),
                          ),
                        ],
                      )),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 20),
              // Search Bar
              TextField(
                decoration: InputDecoration(
                  hintText: "Search for places...",
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Categories Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Categories", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("View all", style: TextStyle(color: Colors.blue)),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCategoryItem("Places", Icons.place, "/allPlaces"),
                  _buildCategoryItem("Hotels", Icons.hotel, "/allHotels"),
                  _buildCategoryItem("Bookmarks", Icons.bookmark, "/bookmarks"),
                  _buildCategoryItem("Schedule", Icons.schedule, "/schedule"),
                ],
              ),
              const SizedBox(height: 20),
              // Popular Places Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Popular", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  // Text("View all", style: TextStyle(color: Colors.blue)),
                ],
              ),
              const SizedBox(height: 10),
              // Popular Places List
              Expanded(
                child: SizedBox(
                  height: 200.0,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('popular').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      final popularPlaces = snapshot.data!.docs.map((doc) => Popular.fromFirestore(doc.data() as Map<String, dynamic>)).toList();

                      return SizedBox(
                        child: ListView.builder(
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
                                print("Tapped on ${popular.name}");
                                print(popular.imagePath);
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
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey, width: 0.5),
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
                                            // SizedBox(height: 4),
                                            // Text(
                                            //   "${popular.distance} km",
                                            //   style: TextStyle(color: Colors.grey),
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChatScreen()),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.chat_bubble, color: Colors.white),
      ),
    );
  }

  // Category Item Widget
  Widget _buildCategoryItem(String title, IconData icon, String route) {
    return Column(
      children: [
        TextButton(
          style: TextButton.styleFrom(
            shape: CircleBorder(),
            padding: EdgeInsets.all(5),
          ),
          onPressed: () {
            Navigator.pushNamed(context, route);
          },
          child: CircleAvatar(
            // backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: Colors.blue),
          ),
        ),
        const SizedBox(height: 1),
        Text(title, style: TextStyle(color: Colors.black, fontSize: 13)),
      ],
    );
  }

  // Bottom Navigation Bar
  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: 0,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
        BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: "Favorites"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}
