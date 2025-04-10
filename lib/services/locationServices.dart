import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class GoogleServices {
  // Function to get the current location of the user
  Future<LatLng?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      // Check if location services are enabled
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }

      // Check for location permissions
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return Future.error('Location permissions are permanently denied, we cannot request permissions.');
      }

      // Get the current position
      Position position = await Geolocator.getCurrentPosition();

      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }

  //get address from lat long
  Future<String?> getAddressFromLatLng(LatLng latLng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String address = '${place.subAdministrativeArea}, ${place.country}';
        return address;
      } else {
        return 'No address found';
      }
    } catch (e) {
      print('Error getting address: $e');
      return null;
    }
  }

  //get district from lat long
  Future<String?> getDistrictFromLatLng(LatLng latLng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String address = '${place.subAdministrativeArea} District';
        return address;
      } else {
        return 'No address found';
      }
    } catch (e) {
      print('Error getting address: $e');
      return null;
    }
  }
}
