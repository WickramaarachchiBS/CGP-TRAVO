import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:newone/Data/Hotel.dart';
import 'package:newone/screens/location_hotel_screen.dart';

class HotelsPage extends StatefulWidget {
  const HotelsPage({super.key});

  @override
  State<HotelsPage> createState() => _HotelsPageState();
}

class _HotelsPageState extends State<HotelsPage> {
  String? selectedDistrict;
  List<String> districts = ['All'];

  @override
  void initState() {
    super.initState();
    _loadDistricts();
    _requestLocationPermission();
  }

  // Request location permission for distance calculation
  Future<void> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission is required to calculate distances')),
        );
      }
    }
  }

  // Fetch unique districts from Firestore
  Future<void> _loadDistricts() async {
    final snapshot = await FirebaseFirestore.instance.collection('hotels').get();
    final uniqueDistricts = snapshot.docs.map((doc) => doc['district'] as String).toSet().toList();
    setState(() {
      districts.addAll(uniqueDistricts..sort()); // Sort for better UX
    });
  }

  // Calculate distance between user's location and hotel
  Future<double> _calculateDistance(double latitude, double longitude) async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return Geolocator.distanceBetween(
            position.latitude,
            position.longitude,
            latitude,
            longitude,
          ) /
          1000; // Convert meters to kilometers
    } catch (e) {
      return 0.0; // Fallback distance
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hotels'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 50,
                width: 180,
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 5.0),
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: DropdownButton<String>(
                  value: selectedDistrict,
                  hint: const Text('All'),
                  isExpanded: true,
                  style: const TextStyle(color: Colors.black),
                  items: districts.map((district) {
                    return DropdownMenuItem<String>(
                      value: district,
                      child: Text(district),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedDistrict = newValue;
                    });
                  },
                ),
              ),
            ],
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('hotels').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading hotels'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No hotels found'));
                }

                // Filter hotels based on selected district
                final hotelDocs = snapshot.data!.docs.where((doc) {
                  final hotel = doc.data() as Map<String, dynamic>;
                  return selectedDistrict == null || selectedDistrict == 'All' || hotel['district'] == selectedDistrict;
                }).toList();

                return GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: hotelDocs.length,
                  itemBuilder: (context, index) {
                    final hotelData = hotelDocs[index].data() as Map<String, dynamic>;
                    // Parse latitude and longitude safely
                    final latitude = hotelData['latitude'];
                    final longitude = hotelData['longitude'];
                    final double lat = latitude is String ? double.tryParse(latitude) ?? 0.0 : (latitude as num?)?.toDouble() ?? 0.0;
                    final double lon = longitude is String ? double.tryParse(longitude) ?? 0.0 : (longitude as num?)?.toDouble() ?? 0.0;

                    // Parse price safely
                    final price = hotelData['price'];
                    // final double parsedPrice = price is String ? double.tryParse(price) ?? 0.0 : (price as num?)?.toDouble() ?? 0.0;

                    final hotel = Hotel(
                      name: hotelData['name'] ?? 'Unknown',
                      imagePath: hotelData['imagePath'] ?? '',
                      distance: 0.0, // Will be calculated dynamically
                      district: hotelData['district'] ?? '',
                      location: LatLng(lat, lon),
                      price: price,
                    );

                    return FutureBuilder<double>(
                      future: _calculateDistance(
                        hotel.location.latitude,
                        hotel.location.longitude,
                      ),
                      builder: (context, distanceSnapshot) {
                        final distance = distanceSnapshot.data ?? 0.0;
                        return _buildPopularCard(
                          hotel.name,
                          hotel.imagePath,
                          distance,
                          hotel.price,
                          hotel.location.latitude,
                          hotel.location.longitude,
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularCard(String title, String imagePath, double distance, String price, double latitude, double longitude) {
    return Container(
      margin: const EdgeInsets.only(right: 0),
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
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LocationScreenHotel(
                imagePath: imagePath,
                hotelName: title,
                price: price,
                latitude: latitude,
                longitude: longitude,
              ),
            ),
          );
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                child: imagePath.isNotEmpty
                    ? Image.network(
                        imagePath,
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 120),
                      )
                    : const Icon(Icons.broken_image, size: 120),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${distance.toStringAsFixed(1)}km",
                      style: const TextStyle(color: Colors.grey),
                    ),
                    Text(
                      'LKR. ${price} /night',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
