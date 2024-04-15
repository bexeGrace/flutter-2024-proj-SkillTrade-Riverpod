// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

void main() {
  runApp(const customerProfile());
}

class customerProfile extends StatelessWidget {
  const customerProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(color: Colors.deepPurple),
      ),
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Customers Profile"),
        ),
        body: const Column(
          children: <Widget>[
            CircleAvatar(
              radius: 50.0,
              backgroundImage: AssetImage("assets/profile.jpg"),
            ),
            ListTile(
              title: Center(
                child: Text(
                  "Biniyam Assefa",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              subtitle: Center(
                child: Text("biniyamassefa648@gmail.com",
                    style: TextStyle(fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
