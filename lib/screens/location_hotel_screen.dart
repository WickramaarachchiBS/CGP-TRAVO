import 'package:flutter/material.dart';
import 'package:newone/components/hotel_facilities.dart';

class LocationScreenHotel extends StatefulWidget {
  const LocationScreenHotel({
    super.key,
    required this.imagePath,
  });

  final String imagePath;

  @override
  State<LocationScreenHotel> createState() => _LocationScreenHotelState();
}

class _LocationScreenHotelState extends State<LocationScreenHotel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Details',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 25.0),
              height: MediaQuery.of(context).size.height * 0.26,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: NetworkImage(widget.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HotelFacilities(icon: Icons.wifi, text: 'Free WIFI'),
                const SizedBox(width: 10),
                HotelFacilities(icon: Icons.pool, text: 'Swimming Pool'),
              ],
            )
          ],
        ),
      ),
    );
  }
}
