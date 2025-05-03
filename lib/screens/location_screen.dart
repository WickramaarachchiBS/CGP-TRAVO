import 'package:flutter/material.dart';
import 'package:newone/screens/map_screen.dart';
import 'package:newone/services/locationServices.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:newone/Data/Bookmarks.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:newone/services/weatherServices.dart';
import 'dart:ui';

class LocationScreen extends StatefulWidget {
  final String place;
  final String imagePath;
  final String latitude;
  final String longitude;
  final String desc;

  const LocationScreen({
    super.key,
    required this.place,
    required this.imagePath,
    required this.latitude,
    required this.longitude,
    required this.desc,
  });

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  String district = 'Loading...';
  final GoogleServices googleServices = GoogleServices();

  final WeatherService weatherService = WeatherService();
  Map<String, dynamic>? weatherData;

  bool isBookmarked = false;
  String? bookmarkDocId;

  @override
  void initState() {
    super.initState();
    _checkBookmarkStatus(); // Check if the location is bookmarked when the screen loads
    fetchWeather();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getDistrictFromLatLng(); // Call the function to get the district each time the widget rebuilds
  }

  Future<void> _getDistrictFromLatLng() async {
    try {
      LatLng latLng = LatLng(
        double.parse(widget.latitude),
        double.parse(widget.longitude),
      );

      String? districtResult = await googleServices.getDistrictFromLatLng(latLng);
      setState(() {
        district = districtResult ?? 'District not found';
      });
    } catch (e) {
      setState(() {
        district = 'Error: $e';
      });
    }
  }

  //function to fetch weather from API
  Future<void> fetchWeather() async {
    try {
      double lat = double.parse(widget.latitude);
      double lon = double.parse(widget.longitude);
      final data = await weatherService.getWeather(lat, lon);
      setState(() {
        weatherData = data;
      });
    } catch (e) {
      print('Error fetching weather data: $e');
    }
  }

  //Weather icon in description
  Widget buildWeatherIcon() {
    if (weatherData == null || weatherData!['weather'] == null || weatherData!['weather'].isEmpty) {
      return SizedBox.shrink();
    }

    final iconCode = weatherData!['weather'][0]['icon'];
    return Image.network(
      'https://openweathermap.org/img/wn/${iconCode}@2x.png',
      width: 50,
      height: 50,
    );
  }

  // Check if the location is already bookmarked
  Future<void> _checkBookmarkStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final query =
          await FirebaseFirestore.instance.collection('bookmarks').where('userId', isEqualTo: user.uid).where('name', isEqualTo: widget.place).get();

      if (query.docs.isNotEmpty) {
        setState(() {
          isBookmarked = true;
          bookmarkDocId = query.docs.first.id; // Store the document ID
        });
      } else {
        setState(() {
          isBookmarked = false;
          bookmarkDocId = null;
        });
      }
    } catch (e) {
      print('Error checking bookmark status: $e');
    }
  }

  // Toggle bookmark (add or remove)
  Future<void> _toggleBookmark() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please log in to bookmark locations')),
        );
        return;
      }

      if (isBookmarked) {
        // Remove bookmark
        if (bookmarkDocId != null) {
          await FirebaseFirestore.instance.collection('bookmarks').doc(bookmarkDocId).delete();

          setState(() {
            isBookmarked = false;
            bookmarkDocId = null;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Bookmark removed')),
          );
        }
      } else {
        // Add bookmark
        final bookmark = Bookmarks(
          name: widget.place,
          imagePath: widget.imagePath,
          latitude: double.parse(widget.latitude),
          longitude: double.parse(widget.longitude),
          desc: widget.desc,
          userId: user.uid,
        );

        final docRef = await FirebaseFirestore.instance.collection('bookmarks').add(bookmark.toFirestore());

        setState(() {
          isBookmarked = true;
          bookmarkDocId = docRef.id;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location bookmarked successfully')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double boxHeight = screenHeight * 0.48;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
              height: boxHeight,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.imagePath),
                  fit: BoxFit.cover,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: Offset(5, 20),
                  ),
                ],
                borderRadius: const BorderRadius.all(Radius.circular(20.0)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Container(
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey[600],
                            ),
                            child: Icon(
                              Icons.arrow_back_ios_rounded,
                              color: Colors.white,
                              size: 20.0,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, right: 10.0),
                        child: IconButton(
                          onPressed: () {
                            _toggleBookmark();
                          },
                          icon: Container(
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey[600],
                            ),
                            child: Icon(
                              Icons.bookmark_add_outlined,
                              color: Colors.white,
                              size: 20.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: boxHeight * 0.55),
                  Container(
                    margin: EdgeInsets.only(right: 20.0, left: 20.0),
                    height: boxHeight * 0.25,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(color: Colors.white.withOpacity(0.2), width: 2),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10.0,
                                offset: Offset(5, 20),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.place,
                                    style: TextStyle(
                                      fontSize: widget.place.length > 20 ? 20.0 : 25.0,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on_outlined,
                                        color: Colors.white,
                                        size: 20.0,
                                      ),
                                      Text(
                                        district,
                                        style: TextStyle(fontSize: 15.0, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Overview',
                    style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w700, color: Colors.black),
                  ),
                  SizedBox(width: 15.0),
                  Text(
                    'Details',
                    style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w700, color: Colors.grey),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.cloud_outlined),
                  SizedBox(width: 10.0),
                  Text(
                    weatherData != null ? '${weatherData!['main']['temp']}°C' : 'Loading...',
                    style: TextStyle(fontSize: 15.0, color: Colors.black54),
                  ),
                  SizedBox(width: 20.0),
                  Icon(Icons.water_drop_outlined),
                  Text(
                    weatherData != null ? '${weatherData!['main']['humidity']}%' : 'Loading...',
                    style: TextStyle(fontSize: 15.0, color: Colors.black54),
                  ),
                  SizedBox(width: 20.0),
                  buildWeatherIcon(),
                  Text(
                    weatherData != null ? weatherData!['weather'][0]['description'] : 'Loading...',
                    style: TextStyle(fontSize: 15.0, color: Colors.black54),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              width: screenWidth * 0.85,
              height: 100.0,
              // color: Colors.lightGreenAccent,
              child: SingleChildScrollView(
                child: Text(
                  widget.desc,
                  style: TextStyle(fontSize: 15.0, color: Colors.black54),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        height: screenHeight * 0.12,
        child: Container(
          margin: EdgeInsets.only(bottom: 20.0, top: 3.0, left: 13.0, right: 13.0),
          child: ElevatedButton(
            onPressed: () {
              // Navigate to the map screen with the latitude and longitude
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MapScreen(
                    latitude: widget.latitude,
                    longitude: widget.longitude,
                    name: widget.place,
                  ),
                ),
              );
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 40.0),
              ),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Direction',
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                  ),
                  SizedBox(width: 15.0),
                  Icon(
                    Icons.send_rounded,
                    color: Colors.white,
                    size: 25.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
