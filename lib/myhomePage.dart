import 'package:flutter/material.dart';
import 'servicePage.dart';
import 'doctorPage.dart';
import 'LoginPage.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedButton = 'Home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF80D8FF),
                  Colors.blue[900]!,
                ],
              ),
            ),
          ),

          Positioned(
            left: 40,
            top: 10,
            // Center vertically
            child: Image.asset(
              'A.png',
              width: 400, // Set width
              height: 600, // Set height
              fit: BoxFit.cover, // Ensure the image covers the entire area
            ),
          ),

          Positioned(
            left: MediaQuery.of(context).size.width / 3,
            top: 40,
            bottom: 40,
            width: MediaQuery.of(context).size.width * 2 / 3,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("doctor.jpg"), // Specify your image path here
                  fit: BoxFit.cover, // Adjust the fit as needed
                  colorFilter: ColorFilter.mode(
                    Colors.black12.withOpacity(0.5), // Adjust the opacity as needed
                    BlendMode.srcOver,
                  ),
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  bottomLeft: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  // Positioned Container with Red Shadow
                  Positioned(
                    left: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF80D8FF),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Text(
                        'Your health matters to us',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 45.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 90),
                  Positioned(
                    left: 50,
                    child: Text(
                      'Embrace a healthier lifestyle for a happier and more fulfilling life, and embark on the journey towards vitality and well-being. Take the first step towards better health today, paving the way for a future brimming with energy, joy, and longevity.',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 23, // Adjusted font size
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  SizedBox(height: 60),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'About Us',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20, // Adjust button text size
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all<Color>(Color(0xFF80D8FF)),
                      padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(vertical: 16, horizontal: 30)),
                      // Adjust button padding
                      // Adjust button padding
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  //
  // Widget buildTextButton(String text, {double? fontSize}) {
  //   return Padding(
  //     padding: MediaQuery.of(context).size.width >= 800
  //         ? EdgeInsets.only(top: 20.0) // Add padding from top for bigger screens
  //         : EdgeInsets.all(8.0),
  //     child: TextButton(
  //       onPressed: () {
  //         setState(() {
  //           _selectedButton = text;
  //         });
  //         if (text == 'Services') {
  //           Navigator.push(context, MaterialPageRoute(builder: (context) => ServicePage()),);
  //         }else if(text =='Doctors'){
  //           Navigator.push(context, MaterialPageRoute(builder: (context)=> DoctorPage()),);
  //         } else if(text == 'Login'){
  //           Navigator.push(context,
  //               MaterialPageRoute(builder: (context)=> LoginPage(title: 'Login Page', color: Colors.green, backgroundImage: 'assets/pd.jpg',)));
  //         }
  //       },
  //       child: Text(
  //         text,
  //         style: TextStyle(
  //           fontSize: fontSize,
  //           color: _selectedButton == text ? Colors.white : Colors.black,
  //         ),
  //       ),
  //       style: ButtonStyle(
  //         backgroundColor: _selectedButton == text
  //             ? MaterialStateProperty.all<Color>(Color(0xFF80D8FF))
  //             : null,
  //       ),
  //     ),
  //   );
  // }

  Widget buildDrawerListTile(String text) {
    return ListTile(
      title: Text(
        text,
        style: TextStyle(
          fontSize: 24, // Adjust the font size
          color: _selectedButton == text ? Colors.white : Colors.black,
        ),
      ),
      tileColor: _selectedButton == text ? Color(0xFF80D8FF) : null,
      onTap: () {
        setState(() {
          _selectedButton = text;
        });
        Navigator.pop(context);
        // You can perform other actions here
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MyHomePage(),
  ));
}
