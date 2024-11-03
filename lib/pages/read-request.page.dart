import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:drivesafe_mobile_application/services/rent.service.dart';
import 'package:drivesafe_mobile_application/services/user.service.dart';
import 'package:drivesafe_mobile_application/services/vehicle.service.dart';
import 'package:drivesafe_mobile_application/models/RentModel.dart';
import 'package:drivesafe_mobile_application/models/UserModel.dart';
import 'package:drivesafe_mobile_application/models/VehicleModel.dart';

class ReadRequestPage extends StatefulWidget {
  final int rentId;

  const ReadRequestPage({super.key, required this.rentId});

  @override
  _ReadRequestPageState createState() => _ReadRequestPageState();
}

class _ReadRequestPageState extends State<ReadRequestPage> {
  final RentService _rentService = RentService();
  final UserService _userService = UserService();
  final VehicleService _vehicleService = VehicleService();
  RentModel? rent;
  UserModel? tenant;
  VehicleModel? vehicle;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final rentResponse = await _rentService.getRentById(id: widget.rentId);
    if (rentResponse.statusCode == 200) {
      setState(() {
        rent = RentModel.fromJson(jsonDecode(rentResponse.body));
      });

      final tenantResponse = await _userService.getByUserId(id: rent!.tenantId);
      if (tenantResponse.statusCode == 200) {
        setState(() {
          tenant = UserModel.fromJson(jsonDecode(tenantResponse.body));
        });
      }
    }
  }

  Future<void> _updateRentStatus(String status) async {
    final vehicleResponse = await _vehicleService.getVehicleById(id: rent!.vehicleId);
    if (vehicleResponse.statusCode == 200) {
      setState(() {
        vehicle = VehicleModel.fromJson(jsonDecode(vehicleResponse.body));
      });

      final now = DateTime.now();
      String startDate = now.toIso8601String().split('T').first;
      String endDate;

      if (vehicle!.timeType == 'Daily') {
        endDate = now.add(Duration(days: 1)).toIso8601String().split('T').first;
      } else if (vehicle!.timeType == 'Weekly') {
        endDate = now.add(Duration(days: 7)).toIso8601String().split('T').first;
      } else if (vehicle!.timeType == 'Monthly') {
        endDate = now.add(Duration(days: 30)).toIso8601String().split('T').first;
      } else {
        endDate = rent!.endDate;
      }

      await _rentService.updateRent(
        id: rent!.id,
        status: status,
        startDate: startDate,
        endDate: endDate,
        vehicleId: rent!.vehicleId,
        ownerId: rent!.ownerId,
        tenantId: rent!.tenantId,
        pickUpPlace: rent!.pickUpPlace,
      );

      setState(() {
        rent = rent!.copyWith(
          status: status,
          startDate: startDate,
          endDate: endDate,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (rent == null || tenant == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Read Request'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Read Request'),
        ),
        body: Center(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Center(
                            child: Text(
                            'Tenant Information',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Text('Name: ${tenant!.name} ${tenant!.lastName}', style: TextStyle(fontSize: 16.0)),
                          Text('Cellphone: ${tenant!.cellphone}', style: TextStyle(fontSize: 16.0)),
                          Text('Gmail: ${tenant!.gmail}', style: TextStyle(fontSize: 16.0)),
                          const SizedBox(height: 16.0),
                          Center(
                            child: Text(
                              'Rent Information',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Text('Status: ${rent!.status}', style: TextStyle(fontSize: 16.0)),
                          Text('Start Date: ${rent!.startDate}', style: TextStyle(fontSize: 16.0)),
                          Text('End Date: ${rent!.endDate}', style: TextStyle(fontSize: 16.0)),
                          Text('Pick Up Place: ${rent!.pickUpPlace}', style: TextStyle(fontSize: 16.0)),
                          const SizedBox(height: 16.0),
                          rent!.status == 'Pending' ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              ElevatedButton(
                                onPressed: () => _updateRentStatus('Accepted'),
                                child: const Text('Accept'),
                              ),
                              const SizedBox(width: 16.0),
                              ElevatedButton(
                                onPressed: () => _updateRentStatus('Refused'),
                                child: const Text('Decline'),
                              ),
                            ],
                          ) : Text('${rent!.status}'),
                        ],
                      ),
                    ),
                ),
            ),
        ),
    );
  }
}