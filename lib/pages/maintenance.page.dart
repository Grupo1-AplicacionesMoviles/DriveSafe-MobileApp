import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:drivesafe_mobile_application/services/rent.service.dart';
import 'package:drivesafe_mobile_application/services/vehicle.service.dart';
import 'package:drivesafe_mobile_application/models/VehicleModel.dart';

class MaintenancePage extends StatefulWidget {
  const MaintenancePage({super.key});

  @override
  _MaintenancePageState createState() => _MaintenancePageState();
}

class _MaintenancePageState extends State<MaintenancePage> {
  final RentService _rentService = RentService();
  final VehicleService _vehicleService = VehicleService();
  List<VehicleModel> vehicles = [];

  @override
  void initState() {
    super.initState();
    _fetchRentsAndVehicles();
  }

  Future<void> _fetchRentsAndVehicles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    int tenantId = int.parse(decodedToken['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/sid']);

    final response = await _rentService.getByTenantId(id: tenantId);
    print("Response Rent: ");
    print(response);

    if (response.statusCode == 200) {
      final List<dynamic> rents = jsonDecode(response.body);
      List<int> vehicleIds = rents.map<int>((rent) => rent['VehicleId'] as int).toList();

      for (int vehicleId in vehicleIds) {
        final vehicleResponse = await _vehicleService.getVehicleById(id: vehicleId);
        if (vehicleResponse.statusCode == 200) {
          final vehicleJson = jsonDecode(vehicleResponse.body);
          setState(() {
            vehicles.add(VehicleModel.fromJson(vehicleJson));
          });
        }
      }
    } else {
      // Handle error
      print('Failed to load rents');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Maintenance'),
        ),
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
          return GestureDetector(
            onTap: () {
              // Handle card tap
            },
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: <Widget>[
                    if (vehicle.urlImage.isNotEmpty)
                      Image.network(
                        vehicle.urlImage,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    const SizedBox(width: 16.0),
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
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}