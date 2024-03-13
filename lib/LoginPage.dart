import 'package:flutter/material.dart';
import 'DoctorDashboard.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  final String title;
  final Color color;
  final String backgroundImage;
  final ScrollController? scrollController;

  LoginPage({
    Key? key,
    required this.title,
    required this.color,
    required this.backgroundImage,
    this.scrollController,
  }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(widget.backgroundImage),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.5),
            BlendMode.multiply,
          ),
        ),
      ),
      child: Center(
        child: Container(
          height: 370,
          width: 400.0,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Log in to your account',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 40),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email, color: Colors.blueAccent),
                  labelText: 'Username or Email',
                  labelStyle: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.black,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Color(0xFF199A8E),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock, color: Colors.blueAccent),
                  labelText: 'Password',
                  labelStyle: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.black,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: () {
                  // Show recovery password dialog
                  _showRecoveryPasswordDialog();
                },
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Recovery Password',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // Check login credentials and navigate to DoctorDashboard if successful
                  _checkLoginCredentials();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15),
                  minimumSize: Size(200, 0),
                ),
                child: Text(
                  'Log in',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Dummy login check for illustration purposes
  void _checkLoginCredentials() async {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    // Check if email or password is empty
    if (email.isEmpty || password.isEmpty) {
      // Display an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all fields.'),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    try {
      print('Login button pressed');
      print('Sending login request...');
      print('Email: $email');

      final response = await http.post(
        Uri.parse('http://localhost:3000/api/doctor/loginDoctor'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final token = responseData['token'];

        // Decode the JWT to get doctorId
        final decodedToken = jsonDecode(utf8.decode(base64.decode(base64.normalize(token.split('.')[1]))));
        print('Decoded Token: $decodedToken');
        final doctorId = decodedToken['id'];
        print('Decoded Doctor ID: $doctorId');

        // Delay the navigation to allow for the decoding process
        Future.delayed(Duration.zero, () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => DoctorDashboard(),
            ),
          );
        });
      } else {
        // Login failed
        // Display an error message
        print('Login failed: ${response.statusCode} - ${response.body}');
      }
    } catch (error, stackTrace) {
      print('Error during login: $error');
      // Print the stack trace for more information
      print('Stack trace: $stackTrace');
    }
  }
  void _showRecoveryPasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController emailController = TextEditingController();

        return AlertDialog(

          title: Text('Recovery Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Enter your email',
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  _recoverPassword(emailController.text.trim());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Recover Password',
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
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'Close',
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _recoverPassword(String email) async {
    try {
      // Check if the email exists in the database
      final checkResponse = await http.post(
        Uri.parse('http://localhost:3000/api/doctor/checkEmailExistence'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
        }),
      );

      if (checkResponse.statusCode != 200 || !jsonDecode(checkResponse.body)['exists']) {
        // Email not found in the database
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('The provided email is not registered.',selectionColor: Colors.white,),
            duration: Duration(seconds: 3),

          ),
        );
        return;
      }

      // Proceed with password recovery since the email exists in the database
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/doctor/recoverpsswrd'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
        }),
      );


      print('Recover Password Response status code: ${response.statusCode}');
      print('Recover Password Response body: ${response.body}');

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Password recovery email sent successfully.'),
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        // Password recovery failed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Password recovery failed: ${response.statusCode} - ${response.body}'),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.white,
          ),
        );
      }
    } catch (error, stackTrace) {
      print('Error during password recovery: $error');
      // Print the stack trace for more information
      print('Stack trace: $stackTrace');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred during password recovery.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
}}
