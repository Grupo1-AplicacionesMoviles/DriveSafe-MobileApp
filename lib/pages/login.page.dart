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

      print('role: '+ role);
      if (role == "owner")
        Navigator.pushNamed(context, '/home-owner');
      else
      Navigator.pushNamed(context, '/home-tenant');
    } else {
      print('Login failed: ${responseLogin.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DriveSafe'),
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
                children: <Widget>[
                  TextField(
                    controller: _gmailController,
                    decoration: const InputDecoration(
                      labelText: 'Gmail',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  SizedBox (
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Login')
                    ),
                  ),
                  const SizedBox(height: 10),
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
                              decoration: TextDecoration.underline
                          ),
                          overflow: TextOverflow.ellipsis
                      ),
                    ),
                  ),
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
                              decoration: TextDecoration.underline
                          ),
                          overflow: TextOverflow.ellipsis
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