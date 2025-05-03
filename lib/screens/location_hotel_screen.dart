import 'package:flutter/material.dart';
import 'package:newone/components/hotel_facilities.dart';
import 'package:geocoding/geocoding.dart';
import 'package:newone/components/rounded_button.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';

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
  int numOfDays = 1;
  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  int _numberOfDays = 0;
  double totalPrice = 0.0;

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

  // Function to calculate the total price based on the number of days
  void _calculateTotalPrice() {
    if (_checkInDate != null && _checkOutDate != null) {
      int days = _checkOutDate!.difference(_checkInDate!).inDays;
      setState(() {
        totalPrice = days * double.parse(widget.price);
        print(totalPrice);
      });
    }
  }

  // Function to show the date range picker dialog
  void _pickDateRange() {
    PickerDateRange? tempSelectedRange;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Check-In Check-Out Dates'),
          content: SizedBox(
            height: 350,
            width: 350,
            child: SfDateRangePicker(
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                if (args.value is PickerDateRange) {
                  tempSelectedRange = args.value;
                }
              },
              selectionMode: DateRangePickerSelectionMode.range,
              minDate: DateTime.now(),
              initialSelectedRange: _checkInDate != null && _checkOutDate != null ? PickerDateRange(_checkInDate, _checkOutDate) : null,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (tempSelectedRange != null) {
                  setState(() {
                    _checkInDate = tempSelectedRange!.startDate;
                    _checkOutDate = tempSelectedRange!.endDate;

                    if (_checkInDate != null && _checkOutDate != null) {
                      _numberOfDays = _checkOutDate!.difference(_checkInDate!).inDays;
                    } else {
                      _numberOfDays = 0;
                    }
                  });
                }
                Navigator.pop(context);
                print(_checkInDate);
                print(_checkOutDate);
                print(_numberOfDays);
                _calculateTotalPrice();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
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
              height: MediaQuery.of(context).size.height * 0.35,
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
                  Flexible(
                    child: SizedBox(
                      height: 25, // adjust based on font size
                      child: Marquee(
                        text: widget.hotelName,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                        scrollAxis: Axis.horizontal,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        blankSpace: 20.0,
                        velocity: 30.0,
                        pauseAfterRound: Duration(seconds: 2),
                        startPadding: 10.0,
                        accelerationDuration: Duration(seconds: 1),
                        accelerationCurve: Curves.linear,
                        decelerationDuration: Duration(milliseconds: 500),
                        decelerationCurve: Curves.easeOut,
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
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
            const SizedBox(height: 1),
            const Divider(
              color: Colors.grey,
              height: 20,
              thickness: 1,
              indent: 20,
              endIndent: 20,
            ),
            const SizedBox(height: 10),
            // Date range picker button
            TextButton(
              onPressed: _pickDateRange,
              child: Text(
                _checkInDate != null && _checkOutDate != null
                    ? 'Check-In: ${DateFormat('yyyy-MM-dd').format(_checkInDate!)} \nCheck-Out: ${DateFormat('yyyy-MM-dd').format(_checkOutDate!)}'
                    : 'Select Dates',
                style: const TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ),
            // Display number of days
            Text(
              _numberOfDays > 0 ? '$_numberOfDays ${_numberOfDays == 1 ? 'Day' : 'Days'}' : 'Select dates to see duration',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(
              color: Colors.grey,
              height: 20,
              thickness: 1,
              indent: 20,
              endIndent: 20,
            ),
            Spacer(),
            RoundedButton(
              chkInDate: _checkInDate,
              chkOutDate: _checkOutDate,
              numOfDays: _numberOfDays,
              hotelName: widget.hotelName,
              price: widget.price,
              totalPrice: totalPrice,
            ),
          ],
        ),
      ),
    );
  }
}
