import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CarPage extends StatelessWidget {
  final Map<String, dynamic> vehicle;

  const CarPage({Key? key, required this.vehicle}) : super(key: key);

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
            Center(
              child: SizedBox(
                width: 150,
                height: 150,
                child: Image.network(
                  vehicle['imageUrl']!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error);
                  },
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            Text('Top Speed: ${vehicle['maximumSpeed']} km/h'),
            Text('Consumption: ${vehicle['consumption']} L/100 km'),
            Text('Dimensions: ${vehicle['dimensions']}'),
            Text('Owner ID: ${vehicle['ownerId']}'),
            Text('Rental Cost: \$${vehicle['rentalCost']}'),
            const SizedBox(height: 24.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Acción para ver el contrato
                },
                child: const Text('See Contract'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
