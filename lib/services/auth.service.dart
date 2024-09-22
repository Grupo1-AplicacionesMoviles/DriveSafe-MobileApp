import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:drivesafe_mobile_application/services/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<http.Response> register({
    required String name,
    required String lastname,
    required String birthDate,
    required int phone,
    required String gmail,
    required String password,
    required String userType,
  }) async {
    var url = Uri.parse("${Config.baseUrl}/api/User/Register");
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'Name': name,
        'LastName': lastname,
        'Birthdate': birthDate,
        'Cellphone': phone,
        'Gmail': gmail,
        'Password': password,
        'Type': userType,
      }),
    );
    return response;
  }

  Future<http.Response> login({
    required String email,
    required String password,
  }) async {
    var url = Uri.parse("${Config.baseUrl}/api/User/Login");
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'Gmail': email,
        'Password': password,
      }),
    );

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = response.body.replaceAll('"', '');
    await prefs.setString('token', token);

    return response;
  }

  Future<http.Response> getRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    var url = Uri.parse("${Config.baseUrl}/api/User/Type");
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