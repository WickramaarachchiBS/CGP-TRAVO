import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AllBookingSection extends StatelessWidget {
  const AllBookingSection({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bookings',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('bookings').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No bookings found.'));
          }

          final bookings = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index].data() as Map<String, dynamic>;
              final bookingId = bookings[index].id;

              // Safely extract booking data with default values
              final hotelName = booking['hotelName']?.toString() ?? 'Unknown';
              final checkInDate = booking['checkInDate'] is Timestamp ? (booking['checkInDate'] as Timestamp).toDate() : null;
              final checkOutDate = booking['checkOutDate'] is Timestamp ? (booking['checkOutDate'] as Timestamp).toDate() : null;
              final numOfDays = booking['numOfDays']?.toString() ?? '0';
              final price = booking['price']?.toString() ?? '0.0';
              final totalPrice = booking['totalPrice']?.toString() ?? '0.0';
              final userId = booking['userId']?.toString() ?? 'Unknown';

// Format dates
              final dateFormat = DateFormat('MMM dd, yyyy');
              final checkInDateStr = checkInDate != null ? dateFormat.format(checkInDate) : 'N/A';
              final checkOutDateStr = checkOutDate != null ? dateFormat.format(checkOutDate) : 'N/A';

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 5),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hotelName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 16),
                          const SizedBox(width: 5),
                          Text(
                            'Check-In: $checkInDateStr',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 16),
                          const SizedBox(width: 5),
                          Text(
                            'Check-Out: $checkOutDateStr',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Days: $numOfDays',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Price per Night: \$${price}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Total Price: \$${totalPrice}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'User ID: $userId',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Booking ID: $bookingId',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
