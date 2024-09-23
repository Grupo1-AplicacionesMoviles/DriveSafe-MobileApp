import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RegisterNewCar extends StatefulWidget {
  const RegisterNewCar({super.key});

  @override
  _RegisterNewCarState createState() => _RegisterNewCarState();
}

class _RegisterNewCarState extends State<RegisterNewCar> {
  String? selectedBrand;
  String? selectedModel;
  String? selectedTransmission;
  double rentPrice = 0;
  PickedFile? image;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      image = pickedFile as PickedFile?;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Rent')),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/home-owner');
              },
              child: Image.asset('assets/images/Drive-Safe-Logo.png'),
            ),
            ListTile(
              leading: const Icon(Icons.directions_car),
              title: const Text('Register new car'),
              onTap: () {
                Navigator.pushNamed(context, '/register-new-car');
              },
            ),
            ListTile(
              leading: const Icon(Icons.build),
              title: const Text('Rents'),
              onTap: () {
                Navigator.pushNamed(context, '/rent');
              },
            ),
            ListTile(
              leading: const Icon(Icons.notification_add),
              title: const Text('Notifications'),
              onTap: () {
                Navigator.pushNamed(context, '/notifications');
              },
            ),
            ListTile(
              leading: const Icon(Icons.request_page),
              title: const Text('Requests'),
              onTap: () {
                Navigator.pushNamed(context, '/request-owner');
              },
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  DropdownButton<String>(
                    value: selectedBrand,
                    hint: const Text('Select Brand'),
                    items: <String>['Brand 1', 'Brand 2', 'Brand 3']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedBrand = newValue;
                      });
                    },
                  ),
                  DropdownButton<String>(
                    value: selectedModel,
                    hint: const Text('Select Model'),
                    items: <String>['Model 1', 'Model 2', 'Model 3']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedModel = newValue;
                      });
                    },
                  ),
                  const Text(
                    'Benefits',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const TextField(
                    decoration: InputDecoration(labelText: 'Top Speed'),
                  ),
                  const TextField(
                    decoration: InputDecoration(labelText: 'Consumption'),
                  ),
                  const Text(
                    'Dimensions',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const TextField(
                    decoration: InputDecoration(labelText: 'Large/Width/Height'),
                  ),
                  const Text(
                    'Additionals',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const TextField(
                    decoration: InputDecoration(labelText: 'Class'),
                  ),
                  DropdownButton<String>(
                    value: selectedTransmission,
                    hint: const Text('Select Transmission'),
                    items: <String>['Automatic', 'Manual']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedTransmission = newValue;
                      });
                    },
                  ),
                  const Text(
                    'Rent Info',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Slider(
                    value: rentPrice,
                    min: 0,
                    max: 100,
                    divisions: 100,
                    label: '\$${rentPrice.round()}',
                    onChanged: (double value) {
                      setState(() {
                        rentPrice = value;
                      });
                    },
                  ),
                  const Text(
                    'Location',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const TextField(
                    decoration: InputDecoration(labelText: 'Direction'),
                  ),
                  const Text(
                    'Upload a picture',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: const Text('Upload image from gallery'),
                  ),
                  if (image != null) Image.file(File(image!.path)),
                  const SizedBox(height: 16.0),
                  Center(
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/rent');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                        child: const Text('Register')
                    )
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