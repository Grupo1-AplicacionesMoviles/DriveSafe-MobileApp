import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:drivesafe_mobile_application/services/rent.service.dart';
import 'package:drivesafe_mobile_application/services/vehicle.service.dart';
import 'package:drivesafe_mobile_application/models/RentModel.dart';
import 'package:drivesafe_mobile_application/models/VehicleModel.dart';

import '../services/config.dart';

class RequestsPage extends StatefulWidget {
  const RequestsPage({super.key});

  @override
  _RequestsPageState createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  final RentService _rentService = RentService();
  final VehicleService _vehicleService = VehicleService();
  List<RentModel> rents = [];
  Map<int, VehicleModel> vehicles = {};

  @override
  void initState() {
    super.initState();
    _fetchRents();
  }

  Future<void> _fetchRents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    int tenantId = int.parse(decodedToken['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/sid']);

    final rentResponse = await _rentService.getByTenantId(id: tenantId);
    if (rentResponse.statusCode == 200) {
      final List<dynamic> rentList = jsonDecode(rentResponse.body);
      setState(() {
        rents = rentList.map((json) => RentModel.fromJson(json)).toList();
      });
      for (var rent in rents) {
        final vehicleResponse = await _vehicleService.getVehicleById(id: rent.vehicleId);
        if (vehicleResponse.statusCode == 200) {
          final vehicleJson = jsonDecode(vehicleResponse.body);
          setState(() {
            vehicles[rent.vehicleId] = VehicleModel.fromJson(vehicleJson);
          });
        }
      }
    } else {
      // Handle error
      print('Failed to load rents');
    }
  }

  Future<void> _updateRentStatus(int rentId, String status) async {
    final rent = rents.firstWhere((rent) => rent.id == rentId);
    await _rentService.updateRent(
      id: rent.id,
      status: status,
      startDate: rent.startDate,
      endDate: rent.endDate,
      vehicleId: rent.vehicleId,
      ownerId: rent.ownerId,
      tenantId: rent.tenantId,
      pickUpPlace: rent.pickUpPlace,
    );

    setState(() {
      final updatedRent = rent.copyWith(status: status);
      final index = rents.indexWhere((r) => r.id == rentId);
      rents[index] = updatedRent;
    });
  }

  void _showPaymentDialog(int rentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Payment Method'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: const Text('Efectivo'),
                onTap: () {
                  Navigator.of(context).pop();
                  _updateRentStatus(rentId, 'Paid');
                },
              ),
              ListTile(
                title: const Text('Yape'),
                onTap: () {
                  Navigator.of(context).pop();
                  _updateRentStatus(rentId, 'Paid');
                },
              ),
              ListTile(
                title: const Text('Plin'),
                onTap: () {
                  Navigator.of(context).pop();
                  _updateRentStatus(rentId, 'Paid');
                },
              ),
            ],
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
        title: const Center(child: Text('Requests')),
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
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: rents.length,
        itemBuilder: (context, index) {
          final rent = rents[index];
          final vehicle = vehicles[rent.vehicleId];
          if (vehicle == null) {
            return const SizedBox.shrink();
          }
          final imageUrl = _buildImageUrl(vehicle.urlImage);
          return Card(
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
                  const SizedBox(height: 8.0),
                  Text(
                    'Pick Up Place: ${rent.pickUpPlace}',
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  if (rent.status == 'Pending')
                    const Text(
                      'Pending',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.orange,
                      ),
                    )
                  else if (rent.status == 'Accepted')
                    ElevatedButton(
                      onPressed: () {
                        _showPaymentDialog(rent.id);
                      },
                      child: const Text('Pay'),
                    )
                  else if (rent.status == 'Refused')
                      const Text(
                        'Refused',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.red,
                        ),
                      )
                    else if (rent.status == 'Paid')
                        const Text(
                          'Paid',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.green,
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