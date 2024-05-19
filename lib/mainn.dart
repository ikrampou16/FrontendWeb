import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'myhomePage.dart';
import 'servicePage.dart';
import 'doctorPage.dart';
import 'LoginPage.dart';
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
  final PageController _pageController = PageController();

  void scrollToServicePage() {
    _pageController.animateToPage(
      1, // Index of the service page
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  void scrollToLoginPage() {
    _pageController.animateToPage(
      3, // Index of the login page
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }
  void scrollToRegistrationPage() {
    _pageController.animateToPage(
      4, // Index of the registration page
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(90.0),
          child: AppBar(
            backgroundColor: Color(0xFF80D8FF),
            title: Text('KETOSMART', style: TextStyle(color: Colors.white ,fontFamily: "Poppins",fontSize: 28)),
            actions: [
              TextButton(
                onPressed: () {
                  _pageController.animateToPage(
                    0, // Index of the home page
                    duration: Duration(milliseconds: 500),
                    curve: Curves.ease,
                  );
                },
                child: Text('Home', style: TextStyle(color: Colors.black ,fontFamily: "Poppins",fontSize: 22)),
              ),
              TextButton(
                onPressed: scrollToServicePage, // Scroll to service page vertically
                child: Text('Services', style: TextStyle(color: Colors.black ,fontFamily: "Poppins",fontSize: 22)),
              ),
              TextButton(
                onPressed: () {
                  _pageController.animateToPage(
                    2, // Index of the doctor page
                    duration: Duration(milliseconds: 500),
                    curve: Curves.ease,
                  );
                },
                child: Text('Doctors', style: TextStyle(color: Colors.black ,fontFamily: "Poppins",fontSize: 22)),
              ),
              TextButton(
                onPressed: scrollToLoginPage, // Scroll to login page
                child: Text('Login', style: TextStyle(color: Colors.black ,fontFamily: "Poppins",fontSize: 22)),
              ),
              TextButton(
                onPressed: scrollToRegistrationPage, // Scroll to registration page
                child: Text('Registration', style: TextStyle(color: Colors.black ,fontFamily: "Poppins",fontSize: 22)),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                children: [
                  MyHomePage(),
                  ServicePage(),
                  DoctorPage(),
                  LoginPage( // Add LoginPage here
                    title: 'Log In',
                    color: Colors.green,
                    backgroundImage: 'assets/pd.jpg', // Change to your desired background image
                  ),
                  DoctorRegistrationScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
