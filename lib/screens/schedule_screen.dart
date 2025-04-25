import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  DateTime selectedMonth = DateTime(2025, 9);
  List<int> selectedDays = [19, 25]; // Blue highlighted days

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Schedule',
          style: TextStyle(
            fontSize: 19.0,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // My Schedule heading and "See all" button
              _buildScheduleHeader(),
              const SizedBox(height: 16),

              // Bookings list from Firebase
              Expanded(
                child: _buildBookingsList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'My Schedule',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        TextButton(
          onPressed: () {
            // Handle "See all" button press
          },
          child: const Text('See all', style: TextStyle(color: Colors.blue)),
        ),
      ],
    );
  }

  Widget _buildBookingsList() {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(
        child: Text('Please log in to view your bookings.'),
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('bookings').where('userId', isEqualTo: user.uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error loading bookings.'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No bookings found.'));
        }

        final bookings = snapshot.data!.docs;

        return ListView.builder(
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            final booking = bookings[index].data() as Map<String, dynamic>;
            final hotelName = booking['hotelName'] ?? 'Unknown Hotel';

            return FutureBuilder<QueryDocumentSnapshot<Map<String, dynamic>>?>(
              future: FirebaseFirestore.instance
                  .collection('hotels')
                  .where('name', isEqualTo: hotelName)
                  .limit(1)
                  .get()
                  .then((snapshot) => snapshot.docs.isNotEmpty ? snapshot.docs.first : null),
              builder: (context, hotelSnapshot) {
                if (hotelSnapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 80,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                String? imageUrl;
                double? latitude;
                double? longitude;
                if (hotelSnapshot.hasData && hotelSnapshot.data != null) {
                  final hotelData = hotelSnapshot.data!.data() as Map<String, dynamic>?;
                  imageUrl = hotelData?['imagePath'] as String?;
                  latitude = double.tryParse(hotelData?['latitude'].toString() ?? '');
                  longitude = double.tryParse(hotelData?['longitude'].toString() ?? '');
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Hotel image
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                        ),
                        child: imageUrl != null
                            ? Image.network(
                                imageUrl,
                                width: 100,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  // Placeholder for missing image
                                  return Container(
                                    width: 100,
                                    height: 80,
                                    color: Colors.grey.shade300,
                                  );
                                },
                              )
                            : Container(
                                width: 100,
                                height: 80,
                                color: Colors.grey.shade300,
                              ),
                      ),

                      // Booking details
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                booking['hotelName'] ?? 'Unknown Hotel',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today_outlined,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    booking['checkInDate'] != null
                                        ? DateFormat('dd MMM yyyy').format((booking['checkInDate'] as Timestamp).toDate())
                                        : 'Check-in date not available',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                booking['price'] != null ? '${booking['price']}/night' : 'Price not available',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Directions button
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: IconButton(
                          icon: const Icon(Icons.directions),
                          onPressed: latitude != null && longitude != null
                              ? () async {
                                  final url = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude');
                                  if (await canLaunchUrl(url)) {
                                    await launchUrl(url);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Could not open Google Maps')),
                                    );
                                  }
                                }
                              : null, // Disable button if coordinates are missing
                          color: Colors.grey,
                          iconSize: 35,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
