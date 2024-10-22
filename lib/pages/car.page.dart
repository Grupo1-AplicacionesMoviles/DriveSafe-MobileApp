import 'dart:convert';
import 'package:drivesafe_mobile_application/services/vehicle.service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CarPage extends StatelessWidget {
  final Map<String, dynamic> vehicle;

  const CarPage({Key? key, required this.vehicle}) : super(key: key);

  Future<void> _applyForRental(BuildContext context) async {
    String status = "Pending";
    DateTime startDate = DateTime.now();
    DateTime endDate = startDate.add(Duration(days: 7)); //Duración de ejemplo
    int vehicleId = vehicle['id'];
    int ownerId = vehicle['ownerId'];
    int tenantId = 101;
    String pickUpPlace = "Example Place";

    try {
      final response = await VehicleService().createRentalRequest(
          status: status,
          startDate: startDate,
          endDate: endDate,
          vehicleId: vehicleId,
          ownerId: ownerId,
          tenantId: tenantId,
          pickUpPlace: pickUpPlace,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Solicitud exitosa
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Rental request sent successfully')),
        );
      } else {
        // Solicitud fallida
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(
              'Failed to send rental request: ${response.statusCode}')),
        );
      }
    } catch(e) {
      // Error en la solicitud
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${vehicle['brand']} ${vehicle['model']}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Apply for this car rental',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: () {
                _applyForRental(context);
              },
              child: const Text('Apply for rental'),
            ),
          ],
        ),
      ),
    );
  }
}
