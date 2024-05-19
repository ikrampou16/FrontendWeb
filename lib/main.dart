import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'LoginPage.dart';
import 'DoctorsPage.dart';
import 'ServicesPage.dart';
import 'DoctorRegistrationScreen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: FirebaseOptions( apiKey: "AIzaSyATwromYmxYKkKMsmnUX1LLMYePe_5yo9M",
      authDomain: "dkaproject-2586c.firebaseapp.com",
      projectId: "dkaproject-2586c",
      storageBucket: "dkaproject-2586c.appspot.com",
      messagingSenderId: "867370442571",
      appId: "1:867370442571:web:f151ca0fba2c3bb5cc12ce",
      measurementId: "G-CFW3QN0P2M"));
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
            title: 'Home Page',
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
            title: 'Doctors Page',
            backgroundImage: 'assets/doc.jpeg',
          ),
          SizedBox(height: 50),
          LoginPage(
            title: 'Login Page',
            color: Colors.green,
            backgroundImage: 'assets/pd.jpg',
          ),
          SizedBox(height: 50),
          DoctorRegistrationScreen(),
        ],
      ),
    );
  }
}