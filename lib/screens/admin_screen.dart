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
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Add New Place',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: districtController,
                      decoration: const InputDecoration(
                        labelText: 'District',
                        border: OutlineInputBorder(),
                        hintText: 'Enter district name',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a district';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Place Name',
                        border: OutlineInputBorder(),
                        hintText: 'Enter place name',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a place name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: addressController,
                      decoration: const InputDecoration(
                        labelText: 'Address',
                        border: OutlineInputBorder(),
                        hintText: 'Enter full address',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: imageUrlController,
                      decoration: const InputDecoration(
                        labelText: 'Image URL',
                        border: OutlineInputBorder(),
                        hintText: 'Enter image URL',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an image URL';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: latController,
                            decoration: const InputDecoration(
                              labelText: 'Latitude',
                              border: OutlineInputBorder(),
                              hintText: 'Enter latitude',
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter latitude';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Please enter a valid number';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: lonController,
                            decoration: const InputDecoration(
                              labelText: 'Longitude',
                              border: OutlineInputBorder(),
                              hintText: 'Enter longitude',
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter longitude';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Please enter a valid number';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                        hintText: 'Enter place description',
                      ),
                      maxLines: 4,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                    ),
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
