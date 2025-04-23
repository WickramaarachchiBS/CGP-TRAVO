import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize Firestore
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Controllers for form fields
    final TextEditingController districtController = TextEditingController();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController addressController = TextEditingController();
    final TextEditingController imageUrlController = TextEditingController();
    final TextEditingController latController = TextEditingController();
    final TextEditingController lonController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    // Form key for validation
    final _formKey = GlobalKey<FormState>();

    Future<void> _submitForm() async {
      if (_formKey.currentState!.validate()) {
        try {
          // Prepare place data
          final placeData = {
            'name': nameController.text.trim(),
            'address': addressController.text.trim(),
            'desc': descriptionController.text.trim(),
            'imagePath': imageUrlController.text.trim(),
            'latitude': double.tryParse(latController.text) ?? 0.0,
            'longitude': double.tryParse(lonController.text) ?? 0.0,
          };

          // Add to Firestore under places/districts/<district_entered>/<place_id>
          String district = districtController.text.trim().toLowerCase();
          await firestore.collection('places').doc('districts').collection(district).add(placeData);

          // Clear form after submission
          districtController.clear();
          nameController.clear();
          addressController.clear();
          imageUrlController.clear();
          latController.clear();
          lonController.clear();
          descriptionController.clear();

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Place added successfully!')),
          );
        } catch (e) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add place: $e')),
          );
          print('Error adding place: $e');
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: CircleAvatar(
              child: PopupMenuButton<String>(
                icon: const Icon(Icons.person),
                onSelected: (value) {
                  if (value == 'logout') {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushReplacementNamed(context, '/login');
                    print('Logged out');
                  }
                  if (value == 'home') {
                    Navigator.pushReplacementNamed(context, '/home');
                    print('Navigating to Home Page');
                  }
                },
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem<String>(
                    value: 'home',
                    child: Text('Home'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'logout',
                    child: Text('Logout'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome, Admin...',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Color(0xffb9cfec),
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
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
                    const SizedBox(height: 16),
                    TextField(controller: districtController, labelText: 'District', maxLines: 1),
                    const SizedBox(height: 12),
                    TextField(controller: nameController, labelText: 'Place Name', maxLines: 1),
                    const SizedBox(height: 12),
                    TextField(controller: addressController, labelText: 'Address', maxLines: 1),
                    const SizedBox(height: 12),
                    TextField(controller: imageUrlController, labelText: 'Image URL', maxLines: 1),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(controller: latController, labelText: 'Latitude', maxLines: 1),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(controller: lonController, labelText: 'Longitude', maxLines: 1),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(controller: descriptionController, labelText: 'Description', maxLines: 3),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 15,
                          ),
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
      ),
    );
  }
}

class TextField extends StatelessWidget {
  const TextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.maxLines,
  });

  final TextEditingController controller;
  final String labelText;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: TextStyle(
        height: 0.8,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      maxLines: maxLines,
      cursorHeight: 20,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a place name';
        }
        return null;
      },
    );
  }
}
