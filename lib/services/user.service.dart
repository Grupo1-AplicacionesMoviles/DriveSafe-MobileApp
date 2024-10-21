import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:drivesafe_mobile_application/services/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  Future<http.Response> getByUserId({required int id}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var url = Uri.parse("${Config.baseUrl}/api/User/$id");
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