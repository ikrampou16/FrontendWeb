import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DoctorsPage extends StatelessWidget {
  final String title;
  final String backgroundImage;

  const DoctorsPage({Key? key, required this.title, required this.backgroundImage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 500,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(backgroundImage),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.6),
                BlendMode.screen,
              ),
            ),
          ),
        ),
        Positioned(
          top: 30,
          left: 400,
          child: Text(
            'Meet Our Family',
            style: TextStyle(
              color: Colors.black,
              fontSize: 50,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Positioned(
          top: 130,
          left: 350,
          child: Text(
            textAlign: TextAlign.center,
            'Well qualified doctors are ready to serve you',
            style: TextStyle(
              color: Colors.black,
              fontSize: 25,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 200.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ColoredContainer(
                color: Colors.white,
                image: AssetImage('assets/medecin.jpg'), // Add your image path
                text: 'Dr. Sarah Louis\n\nCardiologist',
                textStyle: TextStyle(

                  fontFamily: 'Poppins',
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(width: 50),
              ColoredContainer(
                color: Colors.white,
                image: AssetImage('assets/medecin.jpg'), // Add your image path
                text: 'Dr. Emma Wilson\n\nNeurologist',
                textStyle: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(width: 50),
              ColoredContainer(
                color: Colors.white,
                image: AssetImage('assets/medecin.jpg'), // Add your image path
                text: 'Dr. Shane Draw\n\nGynologist',
                textStyle: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ColoredContainer extends StatelessWidget {
  final Color color;
  final ImageProvider image;
  final String text;
  final Color iconColor;
  final TextStyle textStyle;

  ColoredContainer({
    required this.color,
    required this.image,
    required this.text,
    this.iconColor = Colors.black,
    this.textStyle = const TextStyle(
      fontFamily: 'Poppins',
      color: Colors.black,
      fontWeight: FontWeight.bold,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      width: 250,
      height: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 40,
            child: Image(
              image: image,
              width: 100,
              height: 100,

            ),
          ),
          Positioned(
            bottom: 50,
            child: Text(
              text,
              style: textStyle,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
