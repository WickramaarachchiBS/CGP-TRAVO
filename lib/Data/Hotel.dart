import 'package:google_maps_flutter/google_maps_flutter.dart';

class Hotel {
  final String name;
  final String imagePath;
  final double distance;
  final String district;
  final LatLng location;
  final String price;

  Hotel({
    required this.name,
    required this.imagePath,
    required this.distance,
    required this.district,
    required this.location,
    required this.price,
  });

  // Optional: Factory to parse Firestore data
  factory Hotel.fromMap(Map<String, dynamic> data, {double distance = 0.0}) {
    final latitude = data['latitude'];
    final longitude = data['longitude'];
    final double lat = latitude is String ? double.tryParse(latitude) ?? 0.0 : (latitude as num?)?.toDouble() ?? 0.0;
    final double lon = longitude is String ? double.tryParse(longitude) ?? 0.0 : (longitude as num?)?.toDouble() ?? 0.0;
    final price = data['price'];
    // final double parsedPrice = price is String ? double.tryParse(price) ?? 0.0 : (price as num?)?.toDouble() ?? 0.0;

    return Hotel(
      name: data['name'] ?? 'Unknown',
      imagePath: data['imagePath'] ?? '',
      distance: distance,
      district: data['district'] ?? '',
      location: LatLng(lat, lon),
      price: price,
    );
  }
}

//   static final List<Hotel> hotels = [
//     //Galle
//     Hotel(
//       name: 'Radisson Blu Resort, Galle',
//       imagePath: 'assets/hotels/raddisonblu.jpg',
//       distance: 2.5,
//       district: 'Galle',
//       location: LatLng(6.0271, 80.2212),
//       price: 20000,
//     ),
//     Hotel(
//       name: 'The Fortress Resort and Spa Galle',
//       imagePath: 'assets/hotels/thefortress.jpg',
//       distance: 3.8,
//       district: 'Galle',
//       location: LatLng(6.0271, 80.2212),
//       price: 15000,
//     ),
//     Hotel(
//       name: 'Thaproban Pavilion Resort & Spa',
//       imagePath: 'assets/hotels/thaprobane.jpg',
//       distance: 1.2,
//       district: 'Galle',
//       location: LatLng(6.0271, 80.2212),
//       price: 12000,
//     ),
//     //Kandy
//     Hotel(
//       name: 'Radisson Hotel Kandy',
//       imagePath: 'assets/hotels/RadissonHotelKandy.jpg',
//       distance: 4.0,
//       district: 'Kandy',
//       location: LatLng(7.2906, 80.6337),
//       price: 18000,
//     ),
//     Hotel(
//       name: 'Kings Ridge',
//       imagePath: 'assets/hotels/KingsRidge.png',
//       distance: 2.0,
//       district: 'Kandy',
//       location: LatLng(7.2906, 80.6337),
//       price: 10000,
//     ),
//     Hotel(
//       name: 'Mount Blue Kandy',
//       imagePath: 'assets/hotels/MountBlueKandy.jpg',
//       distance: 3.5,
//       district: 'Kandy',
//       location: LatLng(7.2906, 80.6337),
//       price: 8000,
//     ),
//     //Anuradhapura
//     Hotel(
//       name: 'Heritance Kandalama',
//       imagePath: 'assets/hotels/heritageKandalama.jpg',
//       distance: 5.0,
//       district: 'Anuradhapura',
//       location: LatLng(8.3469, 80.3713),
//       price: 25000,
//     ),
//     Hotel(
//       name: 'Palm Garden Village',
//       imagePath: 'assets/hotels/palmGarden.jpg',
//       distance: 2.5,
//       district: 'Anuradhapura',
//       location: LatLng(8.3469, 80.3713),
//       price: 12000,
//     ),
//     Hotel(
//       name: 'THE IVY LAKE',
//       imagePath: 'assets/hotels/ivyLake.jpg',
//       distance: 3.0,
//       district: 'Anuradhapura',
//       location: LatLng(8.3469, 80.3713),
//       price: 10000,
//     ),
//   ];
//
//   // Static list of districts
//   static final List<String> districts = [
//     'All',
//     'Galle',
//     'Kandy',
//     'Anuradhapura',
//     'Ampara',
//     'Badulla',
//     'Batticaloa',
//     'Colombo',
//     'Gampaha',
//   ];
// }
