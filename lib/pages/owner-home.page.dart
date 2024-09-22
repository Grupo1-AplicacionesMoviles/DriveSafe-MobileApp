import 'package:flutter/material.dart';

class HomeOwner extends StatelessWidget {
  const HomeOwner({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text('Home')
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Welcome to the owner home page'),
      ),
    );
  }
}