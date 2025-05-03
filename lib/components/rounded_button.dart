import 'package:flutter/material.dart';
import 'package:newone/screens/booking_summary_screen.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
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
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.0, top: 3.0, left: 13.0, right: 13.0),
      child: ElevatedButton(
        onPressed: () {
          if (chkInDate == null || chkOutDate == null) {
            // Show an error message if dates are not selected
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Please select check-in and check-out dates.'),
              ),
            );
            return;
          }
          // Navigate to the map screen with the latitude and longitude
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Summary(
                chkInDate: chkInDate,
                chkOutDate: chkOutDate,
                numOfDays: numOfDays,
                totalPrice: totalPrice,
                hotelName: hotelName,
                price: price,
              ),
            ),
          );
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF176EF0)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
          ),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Book Now',
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
    );
  }
}
