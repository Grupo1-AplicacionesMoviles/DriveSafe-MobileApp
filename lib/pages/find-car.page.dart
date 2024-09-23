import 'package:flutter/material.dart';

class FindCar extends StatefulWidget {
  const FindCar({super.key});

  @override
  _FindCarState createState() => _FindCarState();
}

class _FindCarState extends State<FindCar> {
  double _price = 50;
  String _rentTime = 'daily';
  String _transmission = 'Automatic';
  List<Map<String, String>> _filteredVehicles = [];
  bool _showFilters = true;

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

  void _searchVehicles() {
    setState(() {
      _filteredVehicles = vehicles;
      _showFilters = false;
    });
  }

  void _toggleFilters() {
    setState(() {
      _showFilters = !_showFilters;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Find a car'),
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
                Navigator.pop(context);
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
            if (!_showFilters)
              Align(
                alignment: Alignment.topLeft,
                child: ElevatedButton(
                  onPressed: _toggleFilters,
                  child: const Text('Filters'),
                ),
              ),
            if (_showFilters) ...[
              const Text(
                'Search by:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
              const SizedBox(height: 16.0),
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const TextField(
                        decoration: InputDecoration(
                          labelText: 'Location',
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Text('Price: \$${_price.toInt()}'),
                      Slider(
                        value: _price,
                        min: 0,
                        max: 100,
                        divisions: 100,
                        label: _price.round().toString(),
                        onChanged: (double value) {
                          setState(() {
                            _price = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16.0),
                      const Text('Rent Time:'),
                      Row(
                        children: <Widget>[
                          Radio(
                            value: 'Daily',
                            groupValue: _rentTime,
                            onChanged: (String? value) {
                              setState(() {
                                _rentTime = value!;
                              });
                            },
                          ),
                          const Text(
                              'Daily',
                              style: TextStyle(
                                fontSize: 16.0,
                              )
                          ),
                          const SizedBox(width: 20),
                          Radio(
                            value: 'Weekly',
                            groupValue: _rentTime,
                            onChanged: (String? value) {
                              setState(() {
                                _rentTime = value!;
                              });
                            },
                          ),
                          const Text(
                              'Weekly',
                              style: TextStyle(
                                fontSize: 16.0,
                              )
                          ),
                          const SizedBox(width: 20),
                          Radio(
                            value: 'Monthly',
                            groupValue: _rentTime,
                            onChanged: (String? value) {
                              setState(() {
                                _rentTime = value!;
                              });
                            },
                          ),
                          const Text(
                              'Monthly',
                              style: TextStyle(
                                fontSize: 16.0,
                              )
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      const TextField(
                        decoration: InputDecoration(
                          labelText: 'Model',
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      const Text('Transmission:'),
                      DropdownButton<String>(
                        value: _transmission,
                        onChanged: (String? newValue) {
                          setState(() {
                            _transmission = newValue!;
                          });
                        },
                        items: <String>['Automatic', 'Manual']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16.0),
                      Center(
                        child: ElevatedButton(
                          onPressed: _searchVehicles,
                          child: const Text('Search'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredVehicles.length,
                itemBuilder: (context, index) {
                  final vehicle = _filteredVehicles[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            vehicle['model']!,
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Image.network(
                            vehicle['imageUrl']!,
                            width: 100.0,
                            height: 100.0,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.error);
                            },
                          ),
                          const SizedBox(height: 8.0),
                          const Text('Top Speed: 200 km/h'),
                          const Text('Consume: 10 L/100 km'),
                          const Text('Dimensions: 4.5/1.8/1.4 m'),
                          const Text('Owner: John Doe'),
                          const SizedBox(height: 8.0),
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
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}