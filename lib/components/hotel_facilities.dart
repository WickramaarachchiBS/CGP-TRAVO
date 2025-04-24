import 'package:flutter/material.dart';

class HotelFacilities extends StatelessWidget {
  const HotelFacilities({
    super.key,
    required this.icon,
    required this.text,
    required this.iconColor,
  });

  final IconData icon;
  final String text;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 7.0),
      decoration: BoxDecoration(
        color: Colors.blueGrey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: iconColor,
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
