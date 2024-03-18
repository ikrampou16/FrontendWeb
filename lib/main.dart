import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'LoginPage.dart';
import 'DoctorsPage.dart';
import 'ServicesPage.dart';
import 'DoctorRegistrationScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        controller: _scrollController,
        children: [
          HomePage(
            title: 'Custom Title',
            backgroundImage: 'assets/doctor.jpg',
            scrollController: _scrollController,
          ),
          SizedBox(height: 40),
          ServicesPage(
            title: 'Services Page',
            color: Colors.blue,
            backgroundImage: 'assets/pd.jpg',
          ),
          SizedBox(height: 50),
          DoctorsPage(
            title: 'Signup Page',
            backgroundImage: 'assets/doc.jpeg',
          ),
          SizedBox(height: 50),
          LoginPage(
            title: 'Login Page',
            color: Colors.green,
            backgroundImage: 'assets/pd.jpg',
            scrollController: _scrollController,
          ),
          SizedBox(height: 50),

          DoctorRegistrationScreen(), // Include DoctorRegistrationScreen here
        ],
      ),
    );
  }
}