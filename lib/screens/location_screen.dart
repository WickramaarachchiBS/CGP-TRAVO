import 'package:flutter/material.dart';
import 'package:newone/screens/map_screen.dart';
import 'package:newone/services/locationServices.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationScreen extends StatefulWidget {
  final String place;
  final String imagePath;
  final String latitude;
  final String longitude;
  final String desc;

  const LocationScreen({
    super.key,
    required this.place,
    required this.imagePath,
    required this.latitude,
    required this.longitude,
    required this.desc,
  });

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  String district = 'Loading...';
  final GoogleServices googleServices = GoogleServices();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getDistrictFromLatLng(); // Call the function to get the district each time the widget rebuilds
  }

  Future<void> _getDistrictFromLatLng() async {
    try {
      // List<String> coordinates = widget.latLon.split(',');
      // if (coordinates.length != 2) {
      //   throw Exception('Invalid latLon format');
      // }

      // double latitude = double.parse(coordinates[0].trim());
      // double longitude = double.parse(coordinates[1].trim());
      LatLng latLng = LatLng(
        double.parse(widget.latitude),
        double.parse(widget.longitude),
      );

      String? districtResult = await googleServices.getDistrictFromLatLng(latLng);
      setState(() {
        district = districtResult ?? 'District not found';
      });
    } catch (e) {
      setState(() {
        district = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double boxHeight = screenHeight * 0.48;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
              height: boxHeight,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.imagePath),
                  fit: BoxFit.cover,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: Offset(5, 20),
                  ),
                ],
                borderRadius: const BorderRadius.all(Radius.circular(20.0)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Container(
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey[600],
                            ),
                            child: Icon(
                              Icons.arrow_back_ios_rounded,
                              color: Colors.white,
                              size: 20.0,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, right: 10.0),
                        child: IconButton(
                          onPressed: () {},
                          icon: Container(
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey[600],
                            ),
                            child: Icon(
                              Icons.bookmark_add_outlined,
                              color: Colors.white,
                              size: 20.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: boxHeight * 0.55),
                  Container(
                    color: Colors.teal[200],
                    margin: EdgeInsets.only(right: 20.0, left: 20.0),
                    height: boxHeight * 0.25,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      //removed BackdropFilter because render problems wrap this to padding when testing on physical devices
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.place,
                                style: TextStyle(
                                  fontSize: widget.place.length > 20 ? 20.0 : 25.0,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    color: Colors.white,
                                    size: 20.0,
                                  ),
                                  Text(
                                    district,
                                    style: TextStyle(fontSize: 15.0, color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Overview',
                    style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w700, color: Colors.black),
                  ),
                  SizedBox(width: 15.0),
                  Text(
                    'Details',
                    style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w700, color: Colors.grey),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.cloud),
                  SizedBox(width: 10.0),
                  Text('32.0 °C'),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              width: screenWidth * 0.85,
              height: 100.0,
              // color: Colors.lightGreenAccent,
              child: SingleChildScrollView(
                child: Text(
                  widget.desc,
                  style: TextStyle(fontSize: 15.0, color: Colors.black54),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        height: screenHeight * 0.12,
        child: Container(
          margin: EdgeInsets.only(bottom: 20.0, top: 3.0, left: 13.0, right: 13.0),
          child: ElevatedButton(
            onPressed: () {
              // Navigate to the map screen with the latitude and longitude
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MapScreen(
                    latitude: widget.latitude,
                    longitude: widget.longitude,
                    name: widget.place,
                  ),
                ),
              );
              // Navigator.pushNamed(context, '/map');
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 40.0),
              ),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Direction',
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                  ),
                  SizedBox(width: 15.0),
                  Icon(
                    Icons.send_rounded,
                    color: Colors.white,
                    size: 25.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
