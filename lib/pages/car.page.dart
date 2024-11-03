import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/config.dart';
import '../services/rent.service.dart';

class CarPage extends StatelessWidget {
  final Map<String, dynamic> vehicle;


  const CarPage({Key? key, required this.vehicle}) : super(key: key);



  String _buildImageUrl(String filename) {
    return '${Config.baseUrl}/api/File/Image/$filename';
  }

  Future<void> _sendRental({required int ownerId, required int vehicleId, required String pickUpPlace}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    int tenantId = int.parse(decodedToken['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/sid']);

    print('Tenant ID: $tenantId');
    print('Owner ID: $ownerId');
    print('Vehicle ID: $vehicleId');

    final RentService _rentService = RentService();


    final rentResponse = await _rentService.postRent(
      status: 'Pending',
      startDate: DateTime.now().toIso8601String().split('T').first,
      endDate: DateTime.now().add(const Duration(days: 7)).toIso8601String().split('T').first,
      vehicleId: vehicleId,
      ownerId: ownerId,
      tenantId: tenantId,
      pickUpPlace: pickUpPlace,
    );

    print(rentResponse.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${vehicle['brand']}  ${vehicle['model']}'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              // Acción para perfil de usuario
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${vehicle['model']} / ${vehicle['brand']}',
                  style: const TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const Text(
                    'Available',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Center(
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: vehicle['imageUrl'] != null
                    ? Image.network(
                _buildImageUrl(vehicle['imageUrl']),
                  fit: BoxFit.cover,
                )
                    : const Icon(Icons.image, size: 50),
              ),
            ),
            const SizedBox(height: 24.0),
            const Text(
              'Car benefits',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text('Top Speed: ${vehicle['maximumSpeed']} km/h'),
            Text('Consume: ${vehicle['consumption']} L/100 km'),
            const SizedBox(height: 24.0),
            const Text(
              'Dimensions',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text('Large/Widht/Height: ${vehicle['dimensions']} mm'),
            Text('Weight: ${vehicle['weight']} kg'),
            const SizedBox(height: 24.0),
            const Text(
              'Owner',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                    vehicle['ownerImageUrl'] ?? 'https://via.placeholder.com/150'),
              ),
              title: const Text('Full Name'),
              subtitle: const Text('Calification'),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _sendRental(
                    ownerId: vehicle['ownerId'],
                    vehicleId: vehicle['id'],
                    pickUpPlace: vehicle['pickUpPlace'],
                  );
                },
                child: const Text('Apply for rental'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
