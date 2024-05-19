import 'package:flutter/material.dart';

class DoctorsPage extends StatelessWidget {
  final String title;
  final String backgroundImage;
  final ScrollController? scrollController2;

  DoctorsPage({
    Key? key,
    required this.title,
    required this.backgroundImage,
    this.scrollController2,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 593,
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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Meet Our Family',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Well qualified doctors are ready to serve you',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                ),
              ),
              SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
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
          ),
        ],
      ),
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
      margin: EdgeInsets.symmetric(vertical: 10),
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
            left: 10,
            right: 10,
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
