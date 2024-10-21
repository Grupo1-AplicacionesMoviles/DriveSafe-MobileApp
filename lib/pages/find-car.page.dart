import 'dart:convert';

import 'package:drivesafe_mobile_application/services/vehicle.service.dart';
import 'package:flutter/material.dart';

class FindCar extends StatefulWidget {
  const FindCar({super.key});

  @override
  _FindCarState createState() => _FindCarState();
}

class _FindCarState extends State<FindCar> {
  List<Map<String, dynamic>> _filteredVehicles = [];
  bool _showFilters = true;
  bool _isLoading = true; // Para mostrar el estado de carga
  final VehicleService _vehicleService = VehicleService(); // Instancia del servicio

  @override
  void initState() {
    super.initState();
    _fetchVehicles();
  }

  void _fetchVehicles() async {
    try {
      final response = await _vehicleService.getVehicles();
      if (response.statusCode == 200) {
        final List<dynamic> vehiclesJson = jsonDecode(response.body);
        setState(() {
          _filteredVehicles = vehiclesJson.map((vehicle) {
            return {
              'brand': vehicle['Brand'],
              'model': vehicle['Model'],
              'imageUrl': vehicle['UrlImage'],
              'maximumSpeed': vehicle['MaximumSpeed'],
              'consumption': vehicle['Consumption'],
              'dimensions': vehicle['Dimensions'],
              'ownerId': vehicle['OwnerId'],
              'rentalCost': vehicle['RentalCost'],
            };
          }).toList();
          _isLoading = false; // Finaliza el estado de carga
        });
      } else {
        // Manejo de error en caso de respuesta no exitosa
        setState(() {
          _isLoading = false;
        });
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      // Manejo de excepciones
      setState(() {
        _isLoading = false;
      });
      print('Exception: $e');
    }
  }

  void _searchVehicles() {
    setState(() {
      _showFilters = false;
      // Filtrar vehículos por precio o cualquier otro criterio si es necesario
    });
  }

  void _toggleFilters() {
    setState(() {
      _showFilters = !_showFilters;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Find a car'),
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Indicador de carga
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (!_showFilters)
              Align(
                alignment: Alignment.topLeft,
                child: ElevatedButton(
                  onPressed: _toggleFilters,
                  child: const Text('Filters'),
                ),
              ),
            if (_showFilters) ...[
              const Text(
                'Search by:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
              const SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  onPressed: _searchVehicles,
                  child: const Text('Search'),
                ),
              ),
            ],
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredVehicles.length,
                itemBuilder: (context, index) {
                  final vehicle = _filteredVehicles[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            vehicle['model']!,
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          SizedBox(
                            width: 100,
                            height: 100,
                            child: Image.network(
                              vehicle['imageUrl']!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.error);
                              },
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                              'Top Speed: ${vehicle['MaximumSpeed']} km/h'),
                          Text(
                              'Consumption: ${vehicle['consumption']} L/100 km'),
                          Text(
                              'Dimensions: ${vehicle['dimensions']}'),
                          Text('Owner ID: ${vehicle['ownerId']}'),
                          Text('Rental Cost: \$${vehicle['rentalCost']}'),
                          const SizedBox(height: 8.0),
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
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}