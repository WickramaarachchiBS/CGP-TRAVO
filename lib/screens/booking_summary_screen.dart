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
  bool checkBoxState = false;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Summary',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.grey,
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    'Confirm Your Booking...',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
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
                              'Duration: ${widget.numOfDays} Day${widget.numOfDays != 1 ? 's' : ''}',
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
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.info, color: Colors.blueAccent, size: 20),
                      const Text(
                        'Please review your booking details carefully.',
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Checkbox(
                      value: checkBoxState,
                      onChanged: (value) {
                        setState(() {
                          checkBoxState = value!;
                        });
                      },
                      activeColor: Colors.blueAccent,
                    ),
                    Expanded(
                      child: Text('Hereby I declare that I have read and accepted the terms and conditions.'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (!checkBoxState) {
                        print('Checkbox not checked');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please accept the terms and conditions.'),
                          ),
                        );
                        return;
                      }
                      // Proceed with payment or booking confirmation
                      print('Checkbox checked');

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Booking Confirmed!'),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.credit_card, color: Colors.white, size: 28),
                        const SizedBox(width: 10),
                        const Text(
                          'Pay Now',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
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
