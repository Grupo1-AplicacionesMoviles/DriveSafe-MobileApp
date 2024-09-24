import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:drivesafe_mobile_application/services/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';

class VehicleService {
  Future<http.Response> createVehicle({
    required String brand,
    required String model,
    required int maximumSpeed,
    required int consumption,
    required String dimensions,
    required int weight,
    required String carClass,
    required String transmission,
    required String timeType,
    required int rentalCost,
    required String pickUpPlace,
    required String urlImage,
    required String rentStatus,
    required int ownerId,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var url = Uri.parse("${Config.baseUrl}/api/Vehicle");
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        'Brand': brand,
        'Model': model,
        'MaximumSpeed': maximumSpeed,
        'Consumption': consumption,
        'Dimensions': dimensions,
        'Weight': weight,
        'CarClass': carClass,
        'Transmission': transmission,
        'TimeType': timeType,
        'RentalCost': rentalCost,
        'PickUpPlace': pickUpPlace,
        'UrlImage': urlImage,
        'RentStatus': 'Available',
        'OwnerId': ownerId,
      }),
    );
    return response;
  }

  Future<http.Response> postImage(File imageFile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var url = Uri.parse("${Config.baseUrl}/api/File/UploadImage");

    var request = http.MultipartRequest('POST', url)
      ..headers['Authorization'] = 'Bearer $token'
      ..files.add(await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
        contentType: MediaType('image', 'jpeg'),
      ));

    var response = await request.send();
    return http.Response.fromStream(response);
  }

  Future<http.Response> getVehicles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var url = Uri.parse("${Config.baseUrl}/api/Vehicle");
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