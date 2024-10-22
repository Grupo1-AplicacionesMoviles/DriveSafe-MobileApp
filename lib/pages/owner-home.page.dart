import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:drivesafe_mobile_application/services/vehicle.service.dart';

class HomeOwner extends StatefulWidget {
  const HomeOwner({Key? key}) : super(key: key);

  @override
  _HomeOwnerState createState() => _HomeOwnerState();
}

class _HomeOwnerState extends State<HomeOwner> {
  List<Map<String, dynamic>> _rentalRequests = [];
  bool _isLoading = true;
  int? ownerId;

  @override
  void initState() {
    super.initState();
    _getOwnerId(); // Obtener el ownerId del usuario autenticado
  }

  void _getOwnerId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? storedOwnerId = prefs.getInt('ownerId'); // Obtener el ownerId desde SharedPreferences

    if (storedOwnerId != null) {
      setState(() {
        ownerId = storedOwnerId;
        print('Owner ID found: $ownerId'); // Para depuración
        _fetchRentalRequests(); // Buscar solicitudes si se encuentra el ownerId
      });
    } else {
      setState(() {
        _isLoading = false; // Asegurarse de detener el cargador si no se encuentra el ownerId
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Owner ID not found, please login again.')),
      );
    }
  }

  void _fetchRentalRequests() async {
    try {
      setState(() {
        _isLoading = true; // Iniciar cargador
      });

      final requests = await VehicleService().getAllRentalRequests().timeout(const Duration(seconds: 10));
      print('Rental requests fetched: ${requests.length}'); // Imprimir la cantidad de solicitudes obtenidas

      setState(() {
        // Filtrar solo las solicitudes que pertenecen al arrendador actual
        _rentalRequests = requests.where((request) => request['ownerId'] == ownerId).toList();
        _isLoading = false; // Finalizar cargador
        print('Filtered rental requests: ${_rentalRequests.length}'); // Imprimir cuántas solicitudes se filtraron
      });
    } catch (e) {
      setState(() {
        _isLoading = false; // Finalizar cargador también en caso de error
      });

      if (e is TimeoutException) {
        print('Error: Request timed out');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Request timed out. Please try again later.')),
        );
      } else {
        print('Error fetching rental requests: $e'); // Imprimir el error para depuración
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load requests: $e')),
        );
      }
    }
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
              leading: const Icon(Icons.notification_add),
              title: const Text('Notifications'),
              onTap: () {
                Navigator.pushNamed(context, '/notifications');
              },
            ),
            ListTile(
              leading: const Icon(Icons.request_page),
              title: const Text('Requests'),
              onTap: () {
                if (ownerId != null) {
                  _fetchRentalRequests();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fetching rental requests...')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Owner ID not found, unable to fetch requests.')),
                  );
                }
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
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Rental Requests',
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (_rentalRequests.isEmpty)
                      const Center(child: Text('No rental requests available.'))
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _rentalRequests.length,
                        itemBuilder: (context, index) {
                          final request = _rentalRequests[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ListTile(
                              title: Text('Vehicle ID: ${request['vehicleId']}'),
                              subtitle: Text('Tenant ID: ${request['tenantId']}'),
                              trailing: Text(request['status']),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
