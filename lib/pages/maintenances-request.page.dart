import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:drivesafe_mobile_application/services/maintenance.service.dart';
import 'package:drivesafe_mobile_application/models/MaintenanceModel.dart';

class MaintenancesRequestPage extends StatefulWidget {
  const MaintenancesRequestPage({super.key});

  @override
  _MaintenancesRequestPageState createState() => _MaintenancesRequestPageState();
}

class _MaintenancesRequestPageState extends State<MaintenancesRequestPage> {
  final MaintenanceService _maintenanceService = MaintenanceService();
  List<MaintenanceModel> maintenances = [];

  @override
  void initState() {
    super.initState();
    _fetchMaintenances();
  }

  Future<void> _fetchMaintenances() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    int ownerId = int.parse(decodedToken['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/sid']);

    final maintenanceResponse = await _maintenanceService.getMaintenances();
    if (maintenanceResponse.statusCode == 200) {
      final List<dynamic> maintenanceList = jsonDecode(maintenanceResponse.body);
      setState(() {
        maintenances = maintenanceList
            .map((json) => MaintenanceModel.fromJson(json))
            .where((maintenance) => maintenance.ownerId == ownerId)
            .toList();
      });
    } else {
      print('Failed to load maintenances');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Maintenance Requests')),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: maintenances.length,
        itemBuilder: (context, index) {
          final maintenance = maintenances[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    maintenance.typeProblem,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    maintenance.title,
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    maintenance.description,
                    style: const TextStyle(
                      fontSize: 14.0,
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