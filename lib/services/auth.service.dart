import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:drivesafe_mobile_application/services/config.dart';

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
    return response;
  }
}