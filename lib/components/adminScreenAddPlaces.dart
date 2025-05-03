import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:newone/components/adminScreenCustomTextField.dart';

class AddPlaceSection extends StatelessWidget {
  AddPlaceSection({super.key});

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController districtController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();
  final TextEditingController latController = TextEditingController();
  final TextEditingController lonController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        final placeData = {
          'name': nameController.text.trim(),
          'address': addressController.text.trim(),
          'desc': descriptionController.text.trim(),
          'imagePath': imageUrlController.text.trim(),
          'latitude': double.tryParse(latController.text) ?? 0.0,
          'longitude': double.tryParse(lonController.text) ?? 0.0,
        };

        String district = districtController.text.trim().toLowerCase();
        await firestore.collection('places').doc('districts').collection(district).add(placeData);

        districtController.clear();
        nameController.clear();
        addressController.clear();
        imageUrlController.clear();
        latController.clear();
        lonController.clear();
        descriptionController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Place added successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add place: $e')),
        );
        print('Error adding place: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
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
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              decoration: BoxDecoration(
                color: const Color(0xff9ec2dc),
                border: Border.all(color: Color(0xffdc9e9e)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add New Place',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  CustomTextField(controller: districtController, labelText: 'District', maxLines: 1),
                  const SizedBox(height: 12),
                  CustomTextField(controller: nameController, labelText: 'Place Name', maxLines: 1),
                  const SizedBox(height: 12),
                  CustomTextField(controller: addressController, labelText: 'Address', maxLines: 1),
                  const SizedBox(height: 12),
                  CustomTextField(controller: imageUrlController, labelText: 'Image URL', maxLines: 1),
                  const SizedBox(height: 12),
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
                  const SizedBox(height: 12),
                  CustomTextField(controller: descriptionController, labelText: 'Description', maxLines: 3),
                  const SizedBox(height: 12),
                  Center(
                    child: ElevatedButton(
                      onPressed: () => _submitForm(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      ),
                      child: const Text(
                        'Add Place',
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
