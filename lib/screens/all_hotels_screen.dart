import 'package:flutter/material.dart';
import 'package:newone/Data/Hotel.dart';

class HotelsPage extends StatefulWidget {
  const HotelsPage({super.key});

  @override
  State<HotelsPage> createState() => _HotelsPageState();
}

class _HotelsPageState extends State<HotelsPage> {
  String? selectedDistrict;

  @override
  Widget build(BuildContext context) {
    List<Hotel> filteredHotels = selectedDistrict == null || selectedDistrict == 'All'
        ? Hotel.hotels
        : Hotel.hotels.where((hotel) => hotel.district == selectedDistrict).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hotels'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 50,
                width: 180,
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 5.0),
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: DropdownButton<String>(
                  value: selectedDistrict,
                  hint: const Text('All'),
                  isExpanded: true,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  items: Hotel.districts.map((district) {
                    return DropdownMenuItem<String>(
                      value: district,
                      child: Text(district),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedDistrict = newValue;
                    });
                  },
                ),
              ),
            ],
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/locationhotel');
              },
              child: GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: filteredHotels.length,
                itemBuilder: (context, index) {
                  final hotel = filteredHotels[index];
                  return _buildPopularCard(
                    hotel.name,
                    hotel.imagePath,
                    hotel.distance,
                    hotel.price,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String title, IconData icon, bool isSelected) {
    return Column(
      children: [
        TextButton(
          style: TextButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(5),
            backgroundColor: isSelected ? Colors.blue.withOpacity(0.2) : null,
          ),
          onPressed: () {
            setState(() {
              selectedDistrict = title;
            });
          },
          child: CircleAvatar(
            backgroundColor: isSelected ? Colors.blue.withOpacity(0.1) : null,
            child: Icon(
              icon,
              color: isSelected ? Colors.blue : Colors.grey,
            ),
          ),
        ),
        const SizedBox(height: 1),
        Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.blue : Colors.black,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildPopularCard(String title, String imagePath, double distance, double price) {
    return Container(
      margin: const EdgeInsets.only(right: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.asset(imagePath, height: 120, width: double.infinity, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text("${distance}km", style: const TextStyle(color: Colors.grey)),
                Text('LKR ${price.toInt()} per night', style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
