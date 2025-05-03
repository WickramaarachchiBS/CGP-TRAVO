import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:newone/components/adminScreenCustomTextField.dart';

class AddHotelSection extends StatelessWidget {
  AddHotelSection({super.key});

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController districtController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();
  final TextEditingController latController = TextEditingController();
  final TextEditingController lonController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        final hotelData = {
          'district': districtController.text.trim().toLowerCase(),
          'name': nameController.text.trim(),
          'imagePath': imageUrlController.text.trim(),
          'latitude': double.tryParse(latController.text) ?? 0.0,
          'longitude': double.tryParse(lonController.text) ?? 0.0,
          'price': double.tryParse(priceController.text) ?? 0.0,
        };

        await firestore.collection('hotels').add(hotelData);

        districtController.clear();
        nameController.clear();
        imageUrlController.clear();
        latController.clear();
        lonController.clear();
        priceController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Hotel added successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add hotel: $e')),
        );
        print('Error adding hotel: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome, Admin...',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xffb9cfec),
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add New Hotel',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  CustomTextField(controller: districtController, labelText: 'District', maxLines: 1),
                  const SizedBox(height: 5),
                  CustomTextField(controller: nameController, labelText: 'Hotel Name', maxLines: 1),
                  const SizedBox(height: 5),
                  CustomTextField(controller: imageUrlController, labelText: 'Image URL', maxLines: 1),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(controller: latController, labelText: 'Latitude', maxLines: 1),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: CustomTextField(controller: lonController, labelText: 'Longitude', maxLines: 1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  CustomTextField(controller: priceController, labelText: 'Price (per night)', maxLines: 1),
                  const SizedBox(height: 5),
                  Center(
                    child: ElevatedButton(
                      onPressed: () => _submitForm(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      ),
                      child: const Text(
                        'Add Hotel',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
