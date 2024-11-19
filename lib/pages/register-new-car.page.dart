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
  final TextEditingController _rentPriceController = TextEditingController();
  String? selectedTransmission;
  String? selectedTimeType;
  XFile? image;

  final ImagePicker _picker = ImagePicker();
  final VehicleService _vehicleService = VehicleService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      image = pickedFile;
    });
  }

  Future<void> _showErrorDialog(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _registerCar() async {
    if (_formKey.currentState!.validate()) {
      if (image != null) {
        final response = await _vehicleService.postImage(File(image!.path));
        final responseBody = jsonDecode(response.body);
        final String urlImage = responseBody['fileName'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? token = prefs.getString('token');
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
        int ownerId = int.parse(decodedToken['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/sid']);

        final vehicleResponse = await _vehicleService.createVehicle(
            id: 0,
            brand: _brandController.text,
            model: _modelController.text,
            maximumSpeed: int.parse(_maximumSpeedController.text),
            consumption: int.parse(_consumptionController.text),
            dimensions: _dimensionsController.text,
            weight: int.parse(_weightController.text),
            carClass: _carClassController.text,
            transmission: selectedTransmission!,
            timeType: selectedTimeType!,
            rentalCost: int.parse(_rentPriceController.text),
            pickUpPlace: _pickUpPlaceController.text,
            urlImage: urlImage,
            rentStatus: 'Available',
            ownerId: ownerId
        );

        if (vehicleResponse.statusCode == 400) {
          _showErrorDialog('Ha ocurrido un error durante el registro del vehículo.');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Se ha registrado correctamente el vehículo.'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushNamed(context, '/home-owner');
        }
      } else {
        _showErrorDialog('Seleccione una imagen para continuar.');
      }
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
            onPressed: () {
              Navigator.pushNamed(context, '/profile-page');
            },
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
                leading: const Icon(Icons.auto_fix_off_sharp),
                title: const Text('Maintenances'),
                onTap: () {
                  Navigator.pushNamed(context, '/maintenances-requests');
                }
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      controller: _brandController,
                      decoration: const InputDecoration(labelText: 'Brand'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the brand';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _modelController,
                      decoration: const InputDecoration(labelText: 'Model'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the model';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _maximumSpeedController,
                      decoration: const InputDecoration(labelText: 'Top Speed'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the top speed';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _consumptionController,
                      decoration: const InputDecoration(labelText: 'Consumption'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the consumption';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _dimensionsController,
                      decoration: const InputDecoration(labelText: 'Large/Width/Height'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the dimensions';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _weightController,
                      decoration: const InputDecoration(labelText: 'Weight'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the weight';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _carClassController,
                      decoration: const InputDecoration(labelText: 'Class'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the class';
                        }
                        return null;
                      },
                    ),
                    DropdownButtonFormField<String>(
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
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a transmission';
                        }
                        return null;
                      },
                    ),
                    DropdownButtonFormField<String>(
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
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a time type';
                        }
                        return null;
                      },
                    ),
                    const Text(
                      'Rent Info',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextFormField(
                      controller: _rentPriceController,
                      decoration: const InputDecoration(labelText: 'Rent Price'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the rent price';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _pickUpPlaceController,
                      decoration: const InputDecoration(labelText: 'Direction'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the pick-up place';
                        }
                        return null;
                      },
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
      ),
    );
  }
}
