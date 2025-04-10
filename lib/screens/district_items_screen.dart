import 'package:flutter/material.dart';
import 'package:newone/screens/location_screen.dart';
import '../Data/Place.dart';

class Places extends StatelessWidget {
  late District district;

  Places({super.key, required this.district});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${district.name} - Destinations")),
      body: ListView.builder(
        itemCount: district.places.length,
        itemBuilder: (context, index) {
          final place = district.places[index];
          return Card(
            margin: EdgeInsets.all(10),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LocationScreen(
                      place: place.name,
                      imagePath: place.image,
                      latLon: "${place.location.latitude}, ${place.location.longitude}",
                    ),
                  ),
                );
              },
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    child: Image.asset(place.image, width: double.infinity, height: 200, fit: BoxFit.cover),
                  ),
                  ListTile(
                    title: Text(place.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          place.address,
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
