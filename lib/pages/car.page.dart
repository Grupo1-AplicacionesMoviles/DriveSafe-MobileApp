import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CarPage extends StatelessWidget {
  final Map<String, dynamic> vehicle;

  const CarPage({Key? key, required this.vehicle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${vehicle['brand']} ${vehicle['model']}'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              // Acción para perfil de usuario
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            // Opciones del menú lateral
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/home');
              },
              child: Image.asset('assets/images/logo.png'),
            ),
            ListTile(
              leading: const Icon(Icons.directions_car),
              title: const Text('Find a car'),
              onTap: () {
                Navigator.pushNamed(context, '/find-car');
              },
            ),
            ListTile(
              leading: const Icon(Icons.build),
              title: const Text('Maintenance'),
              onTap: () {
                Navigator.pushNamed(context, '/maintenance');
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${vehicle['model']} / ${vehicle['year']}',
                  style: const TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const Text(
                    'Available',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Center(
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: vehicle['imageUrl'] != null
                    ? Image.network(
                  vehicle['imageUrl'],
                  fit: BoxFit.cover,
                )
                    : const Icon(Icons.image, size: 50),
              ),
            ),
            const SizedBox(height: 24.0),
            const Text(
              'Car benefits',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text('Top Speed: ${vehicle['maximumSpeed']} km/h'),
            Text('Consume: ${vehicle['consumption']} L/100 km'),
            const SizedBox(height: 24.0),
            const Text(
              'Dimensions',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text('Large/Widht/Height: ${vehicle['dimensions']} mm'),
            Text('Weight: ${vehicle['weight']} kg'),
            const SizedBox(height: 24.0),
            const Text(
              'Owner',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                    vehicle['ownerImageUrl'] ?? 'https://via.placeholder.com/150'),
              ),
              title: const Text('Full Name'),
              subtitle: const Text('Calification'),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Acción para ver el contrato
                },
                child: const Text('See Contract'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
