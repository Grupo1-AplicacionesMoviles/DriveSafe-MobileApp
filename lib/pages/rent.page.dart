import 'dart:convert';
import 'package:drivesafe_mobile_application/pages/read-request.page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:drivesafe_mobile_application/services/vehicle.service.dart';
import 'package:drivesafe_mobile_application/services/rent.service.dart';
import 'package:drivesafe_mobile_application/models/VehicleModel.dart';
import 'package:drivesafe_mobile_application/models/RentModel.dart';

import '../services/config.dart';

class RentPage extends StatefulWidget {
  const RentPage({super.key});

  @override
  _RentPageState createState() => _RentPageState();
}

class _RentPageState extends State<RentPage> {
  final VehicleService _vehicleService = VehicleService();
  final RentService _rentService = RentService();
  List<VehicleModel> vehicles = [];
  List<RentModel> rents = [];

  @override
  void initState() {
    super.initState();
    _fetchVehicles();
  }

  Future<void> _fetchVehicles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    int ownerId = int.parse(decodedToken['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/sid']);

    final vehicleResponse = await _vehicleService.getVehicleByOwnerId(ownerId: ownerId);
    if (vehicleResponse.statusCode == 200) {
      final List<dynamic> vehicleList = jsonDecode(vehicleResponse.body);
      setState(() {
        vehicles = vehicleList.map((json) => VehicleModel.fromJson(json)).toList();
      });
    } else {
      print('Failed to load vehicles');
    }
  }

  Future<void> _showRentsDialog(BuildContext context, int vehicleId) async {
    final rentResponse = await _rentService.getRents();
    if (rentResponse.statusCode == 200) {
      final List<dynamic> rentList = jsonDecode(rentResponse.body);
      setState(() {
        rents = rentList.map((json) => RentModel.fromJson(json)).where((rent) => rent.vehicleId == vehicleId).toList();
      });
    } else {
      print('Failed to load rents');
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Rents for this Vehicle'),
          content: SingleChildScrollView(
            child: Column(
              children: rents.isEmpty
                  ? [const Text('No rents requests')]
                  : rents.map((rent) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReadRequestPage(rentId: rent.id),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Status: ${rent.status}'),
                          Text('Start Date: ${rent.startDate}'),
                          Text('End Date: ${rent.endDate}'),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  String _buildImageUrl(String filename) {
    return '${Config.baseUrl}/api/File/Image/$filename';
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
        child: ListView.builder(
          itemCount: vehicles.length,
          itemBuilder: (context, index) {
            final vehicle = vehicles[index];
            final imageUrl = _buildImageUrl(vehicle.urlImage);
            return GestureDetector(
              onTap: () {
                _showRentsDialog(context, vehicle.id);
              },
              child: Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${vehicle.brand} ${vehicle.model}',
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      if (imageUrl.isNotEmpty)
                        Image.network(
                          imageUrl,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}