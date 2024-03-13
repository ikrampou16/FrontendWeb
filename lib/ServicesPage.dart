import 'package:flutter/material.dart';

class ServicesPage extends StatelessWidget {
  final String title;
  final Color color;
  final String backgroundImage;
  final ScrollController? scrollControllerr;

  ServicesPage({
    Key? key,
    required this.title,
    required this.color,
    required this.backgroundImage,
    this.scrollControllerr,
  }) : super(key: key);

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
          top: 50,
          left: 350,
          child: Text(
            'Our Medical Services',
            style: TextStyle(
              color: Colors.black,
              fontSize: 50,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),Positioned(
          top: 130,
          left: 430,
          child: Text(
            textAlign: TextAlign.center,
            'We are dedicated to serve you\nbest medical services',
            style: TextStyle(
              color: Colors.black,
              fontSize: 25,

            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 250.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ColoredContainer(
                color: Color(0xFFE0F2F1),
                icon: Icons.health_and_safety,
                text: 'Expert care,\n trusted doctors.',
                iconColor: Color(0xFF1A237E), // Customize icon color
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
                icon: Icons.local_hospital,
                text: 'Emergency\n Ambulance',
                iconColor: Color(0xFF1A237E), // Customize icon color
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
                icon: Icons.phone_callback,
                text: 'Available 24/7 for \nyour convenience.',
                iconColor: Color(0xFF1A237E), // Customize icon color
                textStyle: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(width: 50),
              ColoredContainer(
                color: Color(0xFFE0F2F1),
                icon: Icons.healing_rounded,
                text: 'Care from a distance,\nalways by your side.',
                iconColor: Color(0xFF1A237E), // Customize icon color
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
  final IconData icon;
  final String text;
  final Color iconColor;
  final TextStyle textStyle;

  ColoredContainer({
    required this.color,
    required this.icon,
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
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      width: 220,
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
        Positioned(
        top: 40,
          child :Icon(
            icon,
            size: 60,
            color: iconColor,
          ),),
          Positioned(
            bottom: 50, // Adjust the position of the text
            child: Text(
              text,
              style: textStyle,
            ),
          ),
        ],
      ),
    );
  }
}