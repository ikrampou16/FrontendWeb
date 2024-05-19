import 'dart:js';

import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final String title;
  final String backgroundImage;
  final ScrollController scrollController;

  HomePage({
    Key? key,
    required this.title,
    required this.backgroundImage,
    required this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 631,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(backgroundImage),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.5),
                BlendMode.multiply,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 5.0, top: 100.0),
                  child: Text(
                    'Your health',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 60.0,
                      color: Color(0xFF80CBC4),
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text(
                  'matters to us',
                  style: TextStyle(
                    fontSize: 50.0,
                    color: Colors.white,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0, top: 10.0),
                child: Text(
                  'Embrace a healthier lifestyle for a happier \n and more fulfilling life',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          color: Colors.black.withOpacity(0.3),
          padding: EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align buttons at the right
            children: [
              Image.asset(
                'assets/mylogo.png',
                width: 70,
                height: 80,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end, // Align buttons at the right
                  children: [
                    TextButton(
                      onPressed: () => _showServices(context),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      child: Text(
                        'Services',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    TextButton(
                      onPressed: () => _showDoctors(context),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      child: Text(
                        'Doctors',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    TextButton(
                      onPressed: () => _scrollToLogin(context),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    TextButton(
                      onPressed: () => _scrollToLogin(context),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

      ],
    );
  }

  void _scrollToLogin(BuildContext context) {
    scrollController.animateTo(
      MediaQuery.of(context).size.height,
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }
  void _showServices(BuildContext context) {
    scrollController.animateTo(
      MediaQuery.of(context).size.height,
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }
  void _showDoctors(BuildContext context) {
    scrollController.animateTo(
      MediaQuery.of(context).size.height,
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }
}
