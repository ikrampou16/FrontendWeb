import 'package:flutter/material.dart';

class DoctorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('doc.jpeg'), // Change 'background_image.jpg' to your image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Red Curtain Overlay
          Container(
            color: Colors.black.withOpacity(0.5), // Adjust opacity as needed
          ),
          Padding(
            padding: const EdgeInsets.all(35.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Our Team',
                  style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold,color:Colors.white),
                  textAlign: TextAlign.center,

                ),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    'Meet our professional team of trusted doctors who are dedicated to providing exceptional medical care to our patients.\nWith their expertise in various specialties, our doctors ensure that you receive the best possible treatment for your health needs.',
                    style: TextStyle(fontSize: 18, fontFamily: 'Poppins', fontStyle: FontStyle.italic,color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 40),
                LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          SizedBox(width: 20),
                          DoctorBox(
                            name: 'Dr.Sekhara Rania',
                            description: 'Specializes in Cardiology',
                            imageUrl: 'assets/doctor02.jpg',
                          ),
                          SizedBox(width: 20),
                          DoctorBox(
                            name: 'Dr.Bouleam Ikram',
                            description: 'Specializes in Pediatrics',
                            imageUrl: 'assets/doctor3.png',
                          ),
                          SizedBox(width: 20),
                          DoctorBox(
                            name: 'Dr.Johnson Jhon',
                            description: 'Specializes in Neurology',
                            imageUrl: 'assets/doctor01.jpg',
                          ),
                          SizedBox(width: 20),
                          DoctorBox(
                            name: 'Dr.Brown Daved',
                            description: 'Specializes in Dermatology',
                            imageUrl: 'assets/medecin.jpg',
                          ),
                          SizedBox(width: 20),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DoctorBox extends StatefulWidget {
  final String name;
  final String description;
  final String imageUrl;

  const DoctorBox({
    Key? key,
    required this.name,
    required this.description,
    required this.imageUrl,
  }) : super(key: key);

  @override
  _DoctorBoxState createState() => _DoctorBoxState();
}

class _DoctorBoxState extends State <DoctorBox> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        transform: _isHovered ? Matrix4.translationValues(20, 0, 0) : Matrix4.translationValues(0, 0, 0),
        child: _buildDoctorBox(),
      ),
    );
  }

  Widget _buildDoctorBox() {
    return Container(
      height: 250,
      width: 270,
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(horizontal: 12), // Adjusted margin to have equal spacing
      decoration: BoxDecoration(
        color: Color(0xFF90CAF9),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black, // Changed shadow color to black
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: ClipOval(
              child: Image.asset(
                widget.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            widget.name,
            style: TextStyle(color: Colors.black, fontSize: 24, fontFamily: 'Poppins'),
          ),
          SizedBox(height: 10),
          Text(
            widget.description,
            style: TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Poppins'),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(DoctorPage());
}
