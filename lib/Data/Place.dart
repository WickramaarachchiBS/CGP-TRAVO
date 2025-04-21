import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Places {
  final String name;
  final String imagePath;
  final double latitude;
  final double longitude;
  final String address;

  Places({
    required this.name,
    required this.imagePath,
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  factory Places.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Places(
      name: data['name'] ?? '',
      imagePath: data['imagePath'] ?? '',
      latitude: double.tryParse(data['latitude'].toString()) ?? 0.0,
      longitude: double.tryParse(data['longitude'].toString()) ?? 0.0,
      address: data['address'] ?? '',
    );
  }
}

// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// class District {
//   String name;
//   String image;
//   List<Place> places;
//
//   District({required this.name, required this.image, required this.places});
// }
//
// class Place {
//   String name;
//   String image;
//   LatLng location;
//   String address;
//
//   Place({required this.name, required this.image, required this.location, required this.address});
//}
//
// //  Data
// List<District> districts = [
//   District(
//     name: "Galle",
//     image: "assets/districtProfilePic/galle.jpg",
//     places: [
//       Place(
//         name: "Galle Dutch Fort",
//         image: "assets/places/galleFort.jpg",
//         location: LatLng(6.025097978915929, 80.21943210768978),
//         address: "Galle Fort, Galle.",
//       ),
//       Place(
//         name: "Hikkaduwa Beach",
//         image: "assets/places/gallehikkaduwa.jpeg",
//         location: LatLng(6.1378209319469175, 80.09905822922613),
//         address: "Hikkaduwa, Galle.",
//       ),
//       Place(
//         name: "Maritime Museum",
//         image: "assets/places/gallemuseum.jpg",
//         location: LatLng(6.025097978915929, 80.21943210768978),
//         address: "Galle Fort, Galle.",
//       ),
//     ],
//   ),
//   District(
//     name: "Kandy",
//     image: "assets/districtProfilePic/kandy.jpg",
//     places: [
//       Place(
//         name: "Sri Dalada Maligawa",
//         image: "assets/places/daladamalagawakandy.jpg",
//         location: LatLng(6.025097978915929, 80.21943210768978),
//         address: "Sri Dalada Maligawa, Kandy.",
//       ),
//       Place(
//         name: "Royal Botanic Gardens, Peradeniya",
//         image: "assets/places/gardenkandy.jpg",
//         location: LatLng(6.025097978915929, 80.21943210768978),
//         address: "Royal Botanic Gardens, Peradeniya, Kandy.",
//       ),
//       Place(
//         name: "Kandy City Centre",
//         image: "assets/places/citycenterkandy.jpg",
//         location: LatLng(6.025097978915929, 80.21943210768978),
//         address: "Kandy City Centre, Kandy.",
//       ),
//     ],
//   ),
//   District(
//     name: "Anuradhapura",
//     image: "assets/districtProfilePic/anuradhapura.webp",
//     places: [
//       Place(
//         name: "Jaya Sri Maha Bodhi",
//         image: "assets/places/srimahabodhi.jpg",
//         location: LatLng(6.025097978915929, 80.21943210768978),
//         address: "Anuradhapura.",
//       ),
//       Place(
//         name: "Ruwanweli Maha Seya",
//         image: "assets/places/ruwanwelimahaseya.jpg",
//         location: LatLng(6.025097978915929, 80.21943210768978),
//         address: "Anuradhapura.",
//       ),
//       Place(
//         name: "Isurumuniya Temple",
//         image: "assets/places/isurumuniyatemple.jpg",
//         location: LatLng(6.025097978915929, 80.21943210768978),
//         address: "Anuradhapura.",
//       ),
//     ],
//   ),
//   District(name: "Ampara", image: "assets/districtProfilePic/ampara.jpg", places: []),
//   District(name: "Badulla", image: "assets/districtProfilePic/badulla.jpg", places: []),
//   District(name: "Batticaloa", image: "assets/districtProfilePic/batticaloa.jpg", places: []),
//   District(name: "Colombo", image: "assets/districtProfilePic/colombo.jpg", places: []),
//   District(name: "Gampaha", image: "assets/districtProfilePic/gampaha.jpg", places: []),
//   District(name: "Hambanthota", image: "assets/districtProfilePic/hambanthota.jpg", places: []),
//   District(name: "Jaffna", image: "assets/districtProfilePic/jaffna.jpg", places: []),
//   District(name: "Kaluthara", image: "assets/districtProfilePic/kaluthara.jpg", places: []),
//   District(name: "Kegalle", image: "assets/districtProfilePic/kegalle.jpg", places: []),
//   District(name: "Kilinochchi", image: "assets/districtProfilePic/kilinochchi.jpg", places: []),
//   District(name: "Kurunegala", image: "assets/districtProfilePic/kurunegala.jpg", places: []),
//   District(name: "Mannar", image: "assets/districtProfilePic/mannar.jpg", places: []),
//   District(name: "Matale", image: "assets/districtProfilePic/matale.jpg", places: []),
//   District(name: "Monaragala", image: "assets/districtProfilePic/monaragala.jpg", places: []),
//   District(name: "Mullaithivu", image: "assets/districtProfilePic/mullaitivu.jpeg", places: []),
//   District(name: "Nuwara Eliya", image: "assets/districtProfilePic/nuwaraeliya.jpg", places: []),
//   District(name: "Polonnaruwa", image: "assets/districtProfilePic/pollonnaruwa.webp", places: []),
// ];
