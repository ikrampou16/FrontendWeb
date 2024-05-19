import 'package:flutter/material.dart';

class ServiceUtils {
  final String name;
  final String description;
  final IconData icon;
  bool isHovering; // Add a property to track hover state

  ServiceUtils({
    required this.name,
    required this.description,
    required this.icon,
    this.isHovering = false, // Initialize hover state to false
  });
}

List<ServiceUtils> servicesUtils = [
  ServiceUtils(
    name: 'Expert care, trusted doctors',
    description: 'Receive expert care from trusted doctors. Our team is dedicated\n'
        '  to providing personalized care to meet your healthcare needs ',
    icon: Icons.health_and_safety,
  ),
  ServiceUtils(
    name: 'Emergency Ambulance',
    description: 'Immediate 24/7 assistance with emergency ambulance.\nReliable medical transportation in times of urgent need.',
    icon: Icons.local_hospital,
  ),
  ServiceUtils(
    name: 'Available 24/7',
    description: 'Access our services 24/7 ensuring that you can receive\n assistance whenever you need it for your convenience.',
    icon: Icons.phone_callback,
  ),
  ServiceUtils(
    name: 'Care from a distance',
    description: 'Unparalleled convenience, providing quality medical assistance\n and personalized support anytime and anywhere you need it',
    icon: Icons.healing_rounded,
  ),
];

class ServicePage extends StatefulWidget {
  const ServicePage({Key? key}) : super(key: key);

  @override
  _ServicePageState createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('pd.jpg'), // Change 'background_image.jpg' to your image path
                  fit: BoxFit.cover,
                ),
              ),
            ),
               Container(
              color: Colors.black.withOpacity(0.5), // Adjust opacity as needed
            ),
            Center(
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  if (constraints.maxWidth > 800) {
                    // For larger screens, display two columns
                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          child: Text(
                            'Our Medical Services',
                            style: TextStyle(
                              fontSize: 27.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Poppins",
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          child: GridView.builder(
                            shrinkWrap: true,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 3, // Aspect ratio for the boxes
                            ),
                            itemCount: servicesUtils.length,
                            itemBuilder: (context, index) {
                              return _buildServiceBox(servicesUtils[index]);
                            },
                          ),
                        ),
                      ],
                    );
                  } else {
                    // For smaller screens, display one column
                    return Column(
                      children: [
                        Text(
                          'Our Medical Services',
                          style: TextStyle(
                            fontSize: 27.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Poppins",
                            color: Colors.white,
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: servicesUtils.length,
                            itemBuilder: (context, index) {
                              return _buildServiceBox(servicesUtils[index]);
                            },
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceBox(ServiceUtils service) {
    return InkWell(
      onTap: () {},
      onHover: (hovering) {
        setState(() {
          service.isHovering = hovering; // Update hover state
          if (!hovering) {
            // Reset hover state after a delay
            Future.delayed(Duration(milliseconds: 300), () {
              setState(() {
                service.isHovering = false;
              });
            });
          }
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        margin: EdgeInsets.all(30.0),
        padding: EdgeInsets.all(30.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
          border: Border.all(
            color: service.isHovering ? Color(0xFF1A237E) : Colors.transparent,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  service.icon,
                  size: 100.0,
                  color: Color(0xFF1A237E), // Set icon color to a specific color
                ),
                SizedBox(width: 20.0), // Add spacing between icon and text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 60.0), // Adjust vertical margin
                        child: Text(
                          service.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      // Add spacing between name and description
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.0), // Adjust vertical margin
                        child: Text(
                          service.description,
                          style: TextStyle(fontSize: 14.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}

void main() {
  runApp(ServicePage());
}
