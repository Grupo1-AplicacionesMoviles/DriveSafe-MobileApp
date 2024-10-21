import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:drivesafe_mobile_application/services/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MaintenanceService {
  Future<http.Response> getMaintenances() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var url = Uri.parse("${Config.baseUrl}/api/Maintenance");
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      }
    );
    return response;
  }

  Future<http.Response> postMaintenance({
    required String typeProblem,
    required String title,
    required String description,
    required int tenantId,
    required int ownerId,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var url = Uri.parse("${Config.baseUrl}/api/Maintenance");
    var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{
          'TypeProblem': typeProblem,
          'Title': title,
          'Description': description,
          'TenantId': tenantId,
          'OwnerId': ownerId
        }),
    );
    return response;
  }
}