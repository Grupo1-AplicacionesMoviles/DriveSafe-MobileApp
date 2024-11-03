import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:drivesafe_mobile_application/services/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';

class RentService {
  Future<http.Response> getRents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var url = Uri.parse("${Config.baseUrl}/api/Rent");
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    return response;
  }

  Future<http.Response> postRent({
    required String status,
    required String startDate,
    required String endDate,
    required int vehicleId,
    required int ownerId,
    required int tenantId,
    required String pickUpPlace,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var url = Uri.parse("${Config.baseUrl}/api/Rent");
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        'Status': status,
        'StartDate': startDate,
        'EndDate': endDate,
        'VehicleId': vehicleId,
        'OwnerId': ownerId,
        'TenantId': tenantId,
        'PickUpPlace': pickUpPlace
      }),
    );
    return response;
  }

  Future<http.Response> getRentById({required int id}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var url = Uri.parse("${Config.baseUrl}/api/Rent/$id");
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    return response;
  }

  Future<http.Response> updateRent({
    required int id,
    required String status,
    required String startDate,
    required String endDate,
    required int vehicleId,
    required int ownerId,
    required int tenantId,
    required String pickUpPlace,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var url = Uri.parse("${Config.baseUrl}/api/Rent/$id");
    var response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        'Status': status,
        'StartDate': startDate,
        'EndDate': endDate,
        'VehicleId': vehicleId,
        'OwnerId': ownerId,
        'TenantId': tenantId,
        'PickUpPlace': pickUpPlace
      }),
    );
    return response;
  }

  Future<http.Response> deleteRent({required int id}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var url = Uri.parse("${Config.baseUrl}/api/Rent/$id");
    var response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    return response;
  }

  Future<http.Response> getByTenantId({required int id}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var url = Uri.parse("${Config.baseUrl}/api/Rent/Tenant/$id");
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    return response;
  }
}