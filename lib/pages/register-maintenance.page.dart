import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:drivesafe_mobile_application/services/maintenance.service.dart';
import 'package:drivesafe_mobile_application/models/VehicleModel.dart';

class RegisterMaintenancePage extends StatefulWidget {
  final VehicleModel vehicle;

  const RegisterMaintenancePage({super.key, required this.vehicle});

  @override
  _RegisterMaintenancePageState createState() => _RegisterMaintenancePageState();
}

class _RegisterMaintenancePageState extends State<RegisterMaintenancePage> {
  final MaintenanceService _maintenanceService = MaintenanceService();
  final TextEditingController _typeProblemController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Future<void> _sendMaintenance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    int tenantId = int.parse(decodedToken['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/sid']);

    String typeProblem = _typeProblemController.text;
    String title = _titleController.text;
    String description = "Problema con ${widget.vehicle.brand} ${widget.vehicle.model}. ${_descriptionController.text}";

    final response = await _maintenanceService.postMaintenance(
      typeProblem: typeProblem,
      title: title,
      description: description,
      tenantId: tenantId,
      ownerId: widget.vehicle.ownerId,
    );

    if (response.statusCode == 201) {
      Navigator.pushNamed(context, '/find-car');
    } else {
      // Handle error
      print('Failed to send maintenance');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Maintenance'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _typeProblemController,
              decoration: const InputDecoration(labelText: 'Type Problem'),
            ),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendMaintenance,
              child: const Text('Send'),
            ),
          ],
        ),
      ),
    );
  }
}