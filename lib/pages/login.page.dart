import 'dart:convert';
import 'package:drivesafe_mobile_application/services/user.service.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/UserModel.dart';
import '../services/auth.service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService authService = AuthService();
  final UserService userService = UserService();
  final TextEditingController _gmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _showErrorDialog(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login Failed'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _login() async {
    String gmail = _gmailController.text;
    String password = _passwordController.text;

    var responseLogin = await authService.login(
      email: gmail,
      password: password,
    );

    if (responseLogin.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
      int Id = int.parse(decodedToken['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/sid']);

      var responseUser = await userService.getByUserId(id: Id);

      UserModel user = UserModel.fromJson(jsonDecode(responseUser.body));
      String role = user.type;

      if (role == "owner")
        Navigator.pushNamed(context, '/home-owner');
      else
        Navigator.pushNamed(context, '/home-tenant');
    } else {
      _showErrorDialog('The entered data is incorrect.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('DriveSafe', style: TextStyle(color: Colors.white)),
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 8.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: _gmailController,
                    decoration: InputDecoration(
                      labelText: 'Gmail',
                      labelStyle: TextStyle(color: Colors.black),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFFF6F00), width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.black),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFFF6F00), width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      )
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox (
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFF6F00),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text('Login', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: (){
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text(
                          'Forgot password?',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFF6F00),
                              decoration: TextDecoration.underline
                          ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: (){
                        Navigator.pushNamed(context, '/register');
                      },
                      child: const Text(
                          'Create an account',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFF6F00),
                              decoration: TextDecoration.underline
                          ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
