import 'package:google_maps_flutter/google_maps_flutter.dart';

class District {
  String name;
  String image;

  District({required this.name, required this.image});
}

//  Data
List<District> districts = [
  District(name: "Galle", image: "assets/districtProfilePic/galle.jpg"),
  District(name: "Kandy", image: "assets/districtProfilePic/kandy.jpg"),
  District(name: "Anuradhapura", image: "assets/districtProfilePic/anuradhapura.webp"),
  District(name: "Ampara", image: "assets/districtProfilePic/ampara.jpg"),
  District(name: "Badulla", image: "assets/districtProfilePic/badulla.jpg"),
  District(name: "Batticaloa", image: "assets/districtProfilePic/batticaloa.jpg"),
  District(name: "Colombo", image: "assets/districtProfilePic/colombo.jpg"),
  District(name: "Gampaha", image: "assets/districtProfilePic/gampaha.jpg"),
  District(name: "Hambanthota", image: "assets/districtProfilePic/hambanthota.jpg"),
  District(name: "Jaffna", image: "assets/districtProfilePic/jaffna.jpg"),
  District(name: "Kaluthara", image: "assets/districtProfilePic/kaluthara.jpg"),
  District(name: "Kegalle", image: "assets/districtProfilePic/kegalle.jpg"),
  District(name: "Kilinochchi", image: "assets/districtProfilePic/kilinochchi.jpg"),
  District(name: "Kurunegala", image: "assets/districtProfilePic/kurunegala.jpg"),
  District(name: "Mannar", image: "assets/districtProfilePic/mannar.jpg"),
  District(name: "Matale", image: "assets/districtProfilePic/matale.jpg"),
  District(name: "Monaragala", image: "assets/districtProfilePic/monaragala.jpg"),
  District(name: "Mullaithivu", image: "assets/districtProfilePic/mullaitivu.jpeg"),
  District(name: "Nuwara Eliya", image: "assets/districtProfilePic/nuwaraeliya.jpg"),
  District(name: "Polonnaruwa", image: "assets/districtProfilePic/pollonnaruwa.webp"),
];
