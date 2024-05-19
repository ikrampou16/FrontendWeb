import 'package:flutter/material.dart';

class ServicesPage extends StatelessWidget {
  final String title;
  final Color color;
  final String backgroundImage;
  final ScrollController? scrollController;

  ServicesPage({
    Key? key,
    required this.title,
    required this.color,
    required this.backgroundImage,
    this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(backgroundImage),
                fit: BoxFit.fill, // Fill the available space
                colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.6),
                  BlendMode.screen,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Our Medical Services',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  Text(
                    'We are dedicated to serve you\nbest medical services',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                    ),
                  ),
                  SizedBox(height: 40),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ColoredContainer(
                          color: Color(0xFFE0F2F1),
                          icon: Icons.health_and_safety,
                          text: 'Expert care,\n trusted doctors.',
                          iconColor: Color(0xFF1A237E),
                        ),
                        SizedBox(width: 20),
                        ColoredContainer(
                          color: Colors.white,
                          icon: Icons.local_hospital,
                          text: 'Emergency\n Ambulance',
                          iconColor: Color(0xFF1A237E),
                        ),
                        SizedBox(width: 20),
                        ColoredContainer(
                          color: Colors.white,
                          icon: Icons.phone_callback,
                          text: 'Available 24/7 for \nyour convenience.',
                          iconColor: Color(0xFF1A237E),
                        ),
                        SizedBox(width: 20),
                        ColoredContainer(
                          color: Color(0xFFE0F2F1),
                          icon: Icons.healing_rounded,
                          text: 'Care from a distance,\nalways by your side.',
                          iconColor: Color(0xFF1A237E),
                        ),
                      ],
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
}

class ColoredContainer extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String text;
  final Color iconColor;

  ColoredContainer({
    required this.color,
    required this.icon,
    required this.text,
    this.iconColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
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
      height: 250,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: 120,
            left: 0,
            right: 0,
        child: Icon(
            icon,
            size: 60,
            color: iconColor,
        ),
          ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
