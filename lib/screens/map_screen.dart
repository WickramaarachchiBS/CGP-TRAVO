import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  final String latitude;
  final String longitude;

  const MapScreen({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;

  LatLng get latLng {
    final lat = double.tryParse(widget.latitude) ?? 0.0;
    final lon = double.tryParse(widget.longitude) ?? 0.0;
    return LatLng(lat, lon);
  }

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
      body: SafeArea(
        child: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: latLng,
            zoom: 15.0,
          ),
          markers: {
            Marker(
              markerId: const MarkerId('selectedLocation'),
              position: latLng,
              infoWindow: const InfoWindow(
                title: 'Initial Position',
                snippet: 'This is the initial position of the map.',
              ),
            ),
          },
        ),
      ),
    );
  }
}
