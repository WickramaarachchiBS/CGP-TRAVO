import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;

  static const LatLng initialPosition = LatLng(7.9570, 80.7603);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Destination',
          style: TextStyle(fontSize: 20, color: Colors.white70),
        ),
        backgroundColor: Colors.black,
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: initialPosition,
          zoom: 11.0,
        ),
        markers: {
          Marker(
            markerId: const MarkerId('initialPosition'),
            position: initialPosition,
            infoWindow: const InfoWindow(
              title: 'Initial Position',
              snippet: 'This is the initial position of the map.',
            ),
          ),
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                Navigator.pushNamed(context, '/welcome');
              },
            ),
            IconButton(
              icon: const Icon(Icons.map),
              onPressed: () {
                Navigator.pushNamed(context, '/map');
              },
            ),
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
            ),
          ],
        ),
      ),
    );
  }
}
