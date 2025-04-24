import 'package:flutter/material.dart';

class HotelFacilities extends StatelessWidget {
  const HotelFacilities({
    super.key,
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 7.0),
      decoration: BoxDecoration(
        color: Colors.blueGrey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.blueGrey[900],
          ),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blueGrey[900]),
          ),
        ],
      ),
    );
  }
}
