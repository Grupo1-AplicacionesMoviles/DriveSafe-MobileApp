import 'package:drivesafe_mobile_application/pages/car.page.dart';
import 'package:drivesafe_mobile_application/pages/login.page.dart';
import 'package:drivesafe_mobile_application/pages/maintenance.page.dart';
import 'package:drivesafe_mobile_application/pages/maintenances-request.page.dart';
import 'package:drivesafe_mobile_application/pages/notifications.page.dart';
import 'package:drivesafe_mobile_application/pages/profile-page.dart';
import 'package:drivesafe_mobile_application/pages/register-new-car.page.dart';
import 'package:drivesafe_mobile_application/pages/register.page.dart';
import 'package:drivesafe_mobile_application/pages/owner-home.page.dart';
import 'package:drivesafe_mobile_application/pages/rent.page.dart';
import 'package:drivesafe_mobile_application/pages/requests-owner.page.dart';
import 'package:drivesafe_mobile_application/pages/requests.page.dart';
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          titleTextStyle: TextStyle(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFFF6F00),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ),
      home: const HomePage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home-tenant': (context) => const HomeTenant(),
        '/home-owner': (context) => const HomeOwner(),
        '/find-car': (context) => const FindCar(),
        '/maintenance': (context) => const MaintenancePage(),
        '/requests': (context) => const RequestsPage(),
        '/register-new-car': (context) => const RegisterNewCar(),
        '/rent': (context) => const RentPage(),
        '/notifications': (context) => const NotificationPage(),
        '/request-owner': (context) => const RequestOwner(),
        '/maintenances-requests': (context) => const MaintenancesRequestPage(),
        '/car-page': (context) => const CarPage(vehicle: {},),
        '/profile-page': (context) => const ProfilePage(),
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