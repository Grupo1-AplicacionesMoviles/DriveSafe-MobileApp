import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:drivesafe_mobile_application/services/vehicle.service.dart';
import 'package:drivesafe_mobile_application/models/VehicleModel.dart';
import 'package:drivesafe_mobile_application/services/config.dart';

class HomeTenant extends StatefulWidget {
  const HomeTenant({super.key});

  @override
  _HomeTenantState createState() => _HomeTenantState();
}

class _HomeTenantState extends State<HomeTenant> {
  final VehicleService _vehicleService = VehicleService();
  List<VehicleModel> vehicles = [];

  @override
  void initState() {
    super.initState();
    _fetchVehicles();
  }

  Future<void> _fetchVehicles() async {
    final response = await _vehicleService.getVehicles();
    if (response.statusCode == 200) {
      final List<dynamic> responseBody = jsonDecode(response.body);
      setState(() {
        vehicles = responseBody.map((json) => VehicleModel.fromJson(json)).toList();
      });
    } else {
      print('Failed to load vehicles');
    }
  }

  String _buildImageUrl(String filename) {
    return '${Config.baseUrl}/api/File/Image/$filename';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Home')),
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
                Navigator.pushNamed(context, '/home-tenant');
              },
              child: Image.asset('assets/images/Drive-Safe-Logo.png'),
            ),
            ListTile(
              leading: const Icon(Icons.directions_car),
              title: const Text('Find a car'),
              onTap: () {
                Navigator.pushNamed(context, '/find-car');
              },
            ),
            ListTile(
              leading: const Icon(Icons.build),
              title: const Text('Maintenance'),
              onTap: () {
                Navigator.pushNamed(context, '/maintenance');
              },
            ),
            ListTile(
              leading: const Icon(Icons.request_page),
              title: const Text('Requests'),
              onTap: () {
                Navigator.pushNamed(context, '/requests');
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: vehicles.length,
        itemBuilder: (context, index) {
          final vehicle = vehicles[index];
          final imageUrl = _buildImageUrl(vehicle.urlImage);
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          vehicle.brand,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          vehicle.model,
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (imageUrl.isNotEmpty)
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}