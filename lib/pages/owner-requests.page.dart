import 'package:flutter/material.dart';
import 'package:drivesafe_mobile_application/services/vehicle.service.dart';

class OwnerRequestsPage extends StatefulWidget {
  final int ownerId;

  const OwnerRequestsPage({required this.ownerId, Key? key}) : super(key: key);

  @override
  _OwnerRequestsPageState createState() => _OwnerRequestsPageState();
}

class _OwnerRequestsPageState extends State<OwnerRequestsPage> {
  List<Map<String, dynamic>> _rentalRequests = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRentalRequests();
  }

  void _fetchRentalRequests() async {
    try {
      final requests = await VehicleService().getAllRentalRequests();
      setState(() {
        // Filtrar solo las solicitudes que pertenecen al arrendador actual
        _rentalRequests = requests.where((request) => request['ownerId'] == widget.ownerId).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load requests: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rental Requests'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _rentalRequests.isEmpty
          ? const Center(child: Text('No rental requests available.'))
          : ListView.builder(
        itemCount: _rentalRequests.length,
        itemBuilder: (context, index) {
          final request = _rentalRequests[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              title: Text('Vehicle ID: ${request['vehicleId']}'),
              subtitle: Text('Tenant ID: ${request['tenantId']}'),
              trailing: Text(request['status']),
            ),
          );
        },
      ),
    );
  }
}
