import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Summary extends StatefulWidget {
  const Summary({
    super.key,
    required this.chkInDate,
    required this.chkOutDate,
    required this.numOfDays,
    required this.totalPrice,
    required this.hotelName,
    required this.price,
  });

  final DateTime? chkInDate;
  final DateTime? chkOutDate;
  final int numOfDays;
  final double totalPrice;
  final String hotelName;
  final String price;

  @override
  State<Summary> createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {
  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Booking Summary',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent.shade100, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    'Your Booking Details',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent.shade700,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.hotel, color: Colors.blueAccent, size: 28),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                widget.hotelName,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(Icons.monetization_on, color: Colors.green, size: 24),
                            const SizedBox(width: 10),
                            Text(
                              'Price: ${widget.price} / night',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(Icons.calendar_today, color: Colors.blueAccent, size: 24),
                            const SizedBox(width: 10),
                            Text(
                              'Check-in: ${widget.chkInDate != null ? dateFormat.format(widget.chkInDate!) : 'N/A'}',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(Icons.calendar_today_outlined, color: Colors.blueAccent, size: 24),
                            const SizedBox(width: 10),
                            Text(
                              'Check-out: ${widget.chkOutDate != null ? dateFormat.format(widget.chkOutDate!) : 'N/A'}',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(Icons.nights_stay, color: Colors.blueAccent, size: 24),
                            const SizedBox(width: 10),
                            Text(
                              'Duration: ${widget.numOfDays} night${widget.numOfDays != 1 ? 's' : ''}',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        const Divider(height: 30, thickness: 1),
                        Row(
                          children: [
                            Icon(Icons.account_balance_wallet, color: Colors.redAccent, size: 24),
                            const SizedBox(width: 10),
                            Text(
                              'Total: \$${widget.totalPrice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Add navigation or confirmation logic here
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Booking Confirmed!')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Confirm Booking',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
