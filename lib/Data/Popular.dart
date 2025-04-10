import 'package:google_maps_flutter/google_maps_flutter.dart';

class Popular {
  final String name;
  final String imagePath;
  final double distance;
  final LatLng location;

  Popular({
    required this.name,
    required this.imagePath,
    required this.distance,
    required this.location,
  });

  static List<Popular> places = [
    Popular(name: "Temple Of Tooth, Kandy", imagePath: "assets/popular/kandy.jpg", distance: 2.5, location: LatLng(7.2906, 80.6328)),
    Popular(name: "Lotus Tower, Colombo", imagePath: "assets/popular/lotus.jpg", distance: 3.7, location: LatLng(6.9271, 79.9585)),
    Popular(name: "Galle Dutch Fort, Galle", imagePath: "assets/popular/galle.jpg", distance: 1.8, location: LatLng(6.0251, 80.2194)),
    Popular(name: "Sigiriya, Matale", imagePath: "assets/popular/sigiriya.jpg", distance: 4.0, location: LatLng(7.9572, 80.7603)),
    Popular(name: "Yala National Park, Hambantota", imagePath: "assets/popular/yala.jpg", distance: 5.2, location: LatLng(6.8628, 81.6040)),
  ];
}
