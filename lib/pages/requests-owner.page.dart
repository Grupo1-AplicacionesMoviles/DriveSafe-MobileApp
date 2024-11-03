import 'package:flutter/material.dart';

class RequestOwner extends StatefulWidget {
  const RequestOwner({super.key});

  @override
  _RequestOwnerState createState() => _RequestOwnerState();
}

class _RequestOwnerState extends State<RequestOwner> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Rent')),
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
            onPressed: () {
              Navigator.pushNamed(context, '/profile-page');
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/home-owner');
              },
              child: Image.asset('assets/images/Drive-Safe-Logo.png'),
            ),
            ListTile(
              leading: const Icon(Icons.directions_car),
              title: const Text('Register new car'),
              onTap: () {
                Navigator.pushNamed(context, '/register-new-car');
              },
            ),
            ListTile(
              leading: const Icon(Icons.build),
              title: const Text('Rents'),
              onTap: () {
                Navigator.pushNamed(context, '/rent');
              },
            ),
            ListTile(
              leading: const Icon(Icons.notification_add),
              title: const Text('Notifications'),
              onTap: () {
                Navigator.pushNamed(context, '/notifications');
              },
            ),
            ListTile(
              leading: const Icon(Icons.request_page),
              title: const Text('Requests'),
              onTap: () {
                Navigator.pushNamed(context, '/request-owner');
              },
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Request ID',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                ),
              ),
              const SizedBox(height: 8.0),
              const Text(
                'Tenant Information',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 16.0),
              Center(
                child: Card(
                  color: Colors.grey[300],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'Name: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text('Tenant Name'),
                        const SizedBox(height: 8.0),
                        const Text(
                          'Lastname: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text('Tenant Lastname'),
                        const SizedBox(height: 8.0),
                        const Text(
                          'Phone: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text('Tenant Phone'),
                        const SizedBox(height: 8.0),
                        const Text(
                          'Mail: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text('Tenant mail'),
                        const SizedBox(height: 8.0),
                        const Text('Lorem ipsum...'),
                        const SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ElevatedButton(
                              onPressed: () {
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black, // Color de fondo negro
                              ),
                              child: const Text('Accept'),
                            ),
                            const SizedBox(width: 16.0),
                            ElevatedButton(
                              onPressed: () {

                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black, // Color de fondo negro
                              ),
                              child: const Text('Decline'),
                            ),
                          ],
                        ),
                      ],

                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}