import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:drivesafe_mobile_application/services/vehicle.service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class RegisterNewCar extends StatefulWidget {
  const RegisterNewCar({super.key});

  @override
  _RegisterNewCarState createState() => _RegisterNewCarState();
}

class _RegisterNewCarState extends State<RegisterNewCar> {
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _maximumSpeedController = TextEditingController();
  final TextEditingController _consumptionController = TextEditingController();
  final TextEditingController _dimensionsController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _carClassController = TextEditingController();
  final TextEditingController _pickUpPlaceController = TextEditingController();
  String? selectedTransmission;
  String? selectedTimeType;
  double rentPrice = 0;
  XFile? image;

  final ImagePicker _picker = ImagePicker();
  final VehicleService _vehicleService = VehicleService();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      image = pickedFile;
    });
  }

  Future<void> _registerCar() async {
    if (image != null) {
      final response = await _vehicleService.postImage(File(image!.path));
      final responseBody = jsonDecode(response.body);
      final String urlImage = responseBody['fileName'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
      int ownerId = int.parse(decodedToken['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/sid']);

      print('urlImage: $urlImage');
      print('ownerId: $ownerId');

      final vehicleResponse = await _vehicleService.createVehicle(
        brand: _brandController.text,
        model: _modelController.text,
        maximumSpeed: int.parse(_maximumSpeedController.text),
        consumption: int.parse(_consumptionController.text),
        dimensions: _dimensionsController.text,
        weight: int.parse(_weightController.text),
        carClass: _carClassController.text,
        transmission: selectedTransmission!,
        timeType: selectedTimeType!,
        rentalCost: rentPrice.round(),
        pickUpPlace: _pickUpPlaceController.text,
        urlImage: urlImage,
        rentStatus: 'Available',
        ownerId: ownerId,
      );

      print('Vehicle creation response: ${vehicleResponse.statusCode}');
      print('Vehicle creation response body: ${vehicleResponse.body}');

      // Show SnackBar based on response status code
      if (vehicleResponse.statusCode == 400) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ha ocurrido un error durante el registro del vehículo.'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Se ha registrado correctamente el vehículo.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      print('Seleccione una imagen para continuar.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Register new car')),
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
              onTap: () {},
              child: const UserAccountsDrawerHeader(
                accountName: Text("User Name"),
                accountEmail: Text("user@example.com"),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text("U"),
                ),
              ),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Profile'),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Settings'),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {},
            ),
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
                  TextField(
                    controller: _brandController,
                    decoration: const InputDecoration(labelText: 'Brand'),
                  ),
                  TextField(
                    controller: _modelController,
                    decoration: const InputDecoration(labelText: 'Model'),
                  ),
                  const Text(
                    'Benefits',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: _maximumSpeedController,
                    decoration: const InputDecoration(labelText: 'Top Speed'),
                  ),
                  TextField(
                    controller: _consumptionController,
                    decoration: const InputDecoration(labelText: 'Consumption'),
                  ),
                  const Text(
                    'Dimensions',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: _dimensionsController,
                    decoration: const InputDecoration(labelText: 'Large/Width/Height'),
                  ),
                  const Text(
                    'Additionals',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: _weightController,
                    decoration: const InputDecoration(labelText: 'Weight'),
                  ),
                  TextField(
                    controller: _carClassController,
                    decoration: const InputDecoration(labelText: 'Class'),
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
                  DropdownButton<String>(
                    value: selectedTimeType,
                    hint: const Text('Select Time Type'),
                    items: <String>['Daily', 'Weekly', 'Monthly']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedTimeType = newValue;
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
                  TextField(
                    controller: _pickUpPlaceController,
                    decoration: const InputDecoration(labelText: 'Direction'),
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
                      onPressed: _registerCar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                      ),
                      child: const Text('Register'),
                    ),
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