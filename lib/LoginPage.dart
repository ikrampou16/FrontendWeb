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
  bool _passwordVisible = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 630,
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
                obscureText: !_passwordVisible,
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
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible; // Toggle password visibility
                      });
                    },
                    icon: Icon(
                      _passwordVisible ? Icons.visibility : Icons.visibility_off,
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
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
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
        final bool passwordChanged = responseData['passwordChanged'] ?? true;
        final photo = responseData['image'];

        setState(() {
          _errorMessage = null; // Clear any previous error message
        });

        if (!passwordChanged) {
          // Show AlertDialog to update password
          _showUpdatePasswordDialog(email, token);
        } else {
          // Navigate to dashboard
          final decodedToken = _parseJwt(token);
          final doctorId = decodedToken['id'];
          final firstName = decodedToken['first_name'];
          final lastName = decodedToken['last_name'];
          final doctorImage = photo  ;
          print(doctorImage);
          _navigateToDashboard(doctorId.toString(), email, firstName, lastName ,doctorImage);
        }
      }

      else {
        // Login failed
        _showErrorSnackBar('Invalid email or password. Please try again.');
      }
    } catch (error, stackTrace) {
      print('Error during login: $error');
      // Print the stack trace for more information
      print('Stack trace: $stackTrace');
    }
  }

  void _showUpdatePasswordDialog(String email, String token) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController newPasswordController = TextEditingController();

        return AlertDialog(
          backgroundColor: Colors.white,
          title: Row(
            children: [
              Icon(Icons.lock, color: Colors.blueAccent),
              SizedBox(width: 10),
              Text('Update Password', style: TextStyle(fontFamily: 'Poppins', color: Colors.black)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Enter New Password',
                  labelStyle: TextStyle(fontFamily: 'Poppins', color: Colors.black),
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
                'Cancel',
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                String newPassword = newPasswordController.text.trim();
                if (newPassword.length >= 7) {
                  // Password meets minimum length requirement, update password
                  _updatePassword(email, newPassword, token);
                  Navigator.of(context).pop(); // Close the dialog
                } else {
                  // Show snackbar for password length requirement
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Password must be at least 7 characters long'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'Update Password',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
  void _updatePassword(String email, String newPassword, String token) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/doctor/updatePassword'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'email': email,
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        // Password updated successfully
        final updatedTokenResponse = await http.post(
          Uri.parse('http://localhost:3000/api/doctor/loginDoctor'), // Log in again to get updated token
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'email': email,
            'password': newPassword, // Use the updated password
          }),
        );

        if (updatedTokenResponse.statusCode == 200) {
          final updatedTokenData = jsonDecode(updatedTokenResponse.body);
          final updatedToken = updatedTokenData['token'];

          // Parse the updated token
          final decodedToken = _parseJwt(updatedToken);
          final doctorId = decodedToken['id'];
          final firstName = decodedToken['first_name'];
          final lastName = decodedToken['last_name'];
          final doctorImage = decodedToken['image'];
          // Navigate to dashboard
          _navigateToDashboard(doctorId.toString(), email, firstName, lastName,doctorImage);
        } else {
          // Login failed after updating password
          _showErrorSnackBar('Failed to log in after updating password. Please try again.');
        }
      } else {
        // Password update failed
        _showErrorSnackBar('Failed to update password. Please try again.');
      }
    } catch (error) {
      print('Error updating password: $error');
      _showErrorSnackBar('An error occurred. Please try again.');
    }
  }


  void _navigateToDashboard(String doctorId, String email, String firstName, String lastName, String? doctorImage) {
    Future.delayed(Duration.zero, () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => DoctorDashboard(
            doctorId: int.parse(doctorId), // Convert doctorId to int
            email: email,
            firstName: firstName,
            lastName: lastName,
            doctorImage: doctorImage,
          ),
        ),
      );
    });
  }


  Map<String, dynamic> _parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw FormatException('Invalid JWT');
    }

    final payload = parts[1];
    final String normalized = base64Url.normalize(payload);
    final String decoded = utf8.decode(base64Url.decode(normalized));

    return json.decode(decoded);
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.green,
      ),
    );
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
                  Navigator.of(context).pop();
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

      if (checkResponse.statusCode == 200 && jsonDecode(checkResponse.body)['exists']) {
        // Proceed with password recovery since the email exists in the database
        final recoveryResponse = await http.post(
          Uri.parse('http://localhost:3000/api/doctor/recoverPassword'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'email': email,
          }),
        );

        print('Recover Password Response status code: ${recoveryResponse.statusCode}');
        print('Recover Password Response body: ${recoveryResponse.body}');

        if (recoveryResponse.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Password recovery email sent successfully.'),
              duration: Duration(seconds: 3),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          // Password recovery failed
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Password recovery failed: ${recoveryResponse.statusCode} - ${recoveryResponse.body}'),
              duration: Duration(seconds: 3),
              backgroundColor: Colors.white,
            ),
          );
        }
      } else {
        // Email not found in the database
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('The provided email is not registered.'),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.orange,
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
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showChangePasswordDialog(String doctorId){
  }}