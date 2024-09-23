import 'package:drivesafe_mobile_application/pages/login.page.dart';
import 'package:drivesafe_mobile_application/pages/maintenance.page.dart';
import 'package:drivesafe_mobile_application/pages/register.page.dart';
import 'package:drivesafe_mobile_application/pages/owner-home.page.dart';
import 'package:drivesafe_mobile_application/pages/tenant-home.page.dart';
import 'package:drivesafe_mobile_application/pages/find-car.page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home-tenant': (context) => const HomeTenant(),
        '/home-owner': (context) => const HomeOwner(),
        '/find-car': (context) => const FindCar(),
        '/maintenance': (context) => const MaintenancePage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/Drive-Safe-Logo.png'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: const Text('Go to Login Page'),
            ),
          ],
        ),
      ),
    );
  }
}