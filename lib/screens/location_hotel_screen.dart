import 'package:flutter/material.dart';
import 'package:newone/components/hotel_facilities.dart';
import 'package:geocoding/geocoding.dart';
import 'package:newone/components/rounded_button.dart';

class LocationScreenHotel extends StatefulWidget {
  const LocationScreenHotel({
    super.key,
    required this.imagePath,
    required this.hotelName,
    required this.price,
    required this.latitude,
    required this.longitude,
  });

  final String imagePath;
  final String hotelName;
  final String price;
  final double latitude;
  final double longitude;

  @override
  State<LocationScreenHotel> createState() => _LocationScreenHotelState();
}

class _LocationScreenHotelState extends State<LocationScreenHotel> {
  String _address = 'Fetching address...';

  @override
  void initState() {
    super.initState();
    _getAddressFromCoordinates();
  }

  // Function to get address from latitude and longitude
  Future<void> _getAddressFromCoordinates() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        widget.latitude,
        widget.longitude,
      );
      Placemark place = placemarks[0]; // Get the first placemark

      // Construct the address string
      String address = '${place.street}, ${place.locality}';

      setState(() {
        _address = address; // Update the address in the state
      });
    } catch (e) {
      setState(() {
        _address = 'Failed to get address'; // Handle errors
      });
      print('Error fetching address: $e');
    }
  }

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
              height: MediaQuery.of(context).size.height * 0.47,
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
                HotelFacilities(icon: Icons.wifi, text: 'Free WIFI', iconColor: Colors.blue),
                const SizedBox(width: 10),
                HotelFacilities(icon: Icons.local_cafe_outlined, text: 'Breakfast', iconColor: Color(0xFF8B4513)),
                const SizedBox(width: 10),
                HotelFacilities(icon: Icons.local_parking, text: 'Parking', iconColor: Color(0xFF808080)),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HotelFacilities(icon: Icons.pool, text: 'Swimming Pool', iconColor: Color(0xFF00BFFF)),
                const SizedBox(width: 10),
                HotelFacilities(icon: Icons.restaurant, text: 'Restaurant', iconColor: Color(0xFF8B0000)),
                const SizedBox(width: 10),
                HotelFacilities(icon: Icons.star_rounded, text: '4.5', iconColor: Color(0xFFF6D421)),
              ],
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.hotelName,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'LKR.  ',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.blueGrey),
                      children: [
                        TextSpan(
                          text: widget.price,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF4B4CDA)),
                        ),
                        TextSpan(
                          text: '/night',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35.0),
              child: Row(
                children: [
                  Icon(Icons.location_on_rounded, color: Colors.redAccent, size: 22),
                  const SizedBox(width: 5),
                  Text(
                    _address,
                    style: TextStyle(fontSize: 15, color: Colors.grey[600], fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Spacer(),
            RoundedButton(),
          ],
        ),
      ),
    );
  }
}
