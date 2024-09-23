import 'package:flutter/material.dart';

class HomeTenant extends StatelessWidget {
  const HomeTenant({super.key});

  final List<Map<String, String>> vehicles = const [
    {
      'brand': 'Toyota',
      'model': 'Corolla',
      'imageUrl': 'https://www.mitsuiautomotriz.com/sites/default/files/2023-02/CONOCELOS_TOYOTA_Corolla-01_0.jpg',
    },
    {
      'brand': 'Honda',
      'model': 'Civic',
      'imageUrl': 'https://d275w7g9tp258u.cloudfront.net/wp-content/uploads/2022/09/honda_civic.png',
    },
    {
      'brand': 'Ford',
      'model': 'Mustang',
      'imageUrl': 'https://live.dealer-asset.co/images/br1168/product/paintSwatch/vehicle/ford-azul-oscuro.png?s=1024',
    },
    {
      'brand': 'Chevrolet',
      'model': 'Camaro',
      'imageUrl': 'https://d1extt4q0kbmr.cloudfront.net/wp-content/uploads/2019/11/camaro-interior1.png',
    },
    {
      'brand': 'BMW',
      'model': 'M3',
      'imageUrl': 'https://hips.hearstapps.com/hmg-prod/images/2025-bmw-m3-110-66562ddceaf59.jpg?crop=0.752xw:0.501xh;0.105xw,0.331xh&resize=1200:*',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Home')
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/home-tenant');
              },
              child: Image.asset('assets/images/Drive-Safe-Logo.png'),
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
            ListTile(
              leading: const Icon(Icons.request_page),
              title: const Text('Requests'),
              onTap: () {
                Navigator.pushNamed(context, '/requests');
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: vehicles.length,
        itemBuilder: (context, index) {
          final vehicle = vehicles[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          vehicle['brand']!,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          vehicle['model']!,
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Image.network(
                    vehicle['imageUrl']!,
                    width: 100.0,
                    height: 100.0,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}