import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DoctorRegistrationScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _specialityController = TextEditingController();

  Future<void> _registerDoctor(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Registration Request'),
          content: Text('Your registration request will be reviewed by the admin.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );

    final url = 'http://localhost:3000/api/doctor';
    final response = await http.post(
      Uri.parse(url),
      body: json.encode({
        'first_name': _firstNameController.text,
        'last_name': _lastNameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'role': 'doctor',
        'address': _addressController.text,
        'speciality': _specialityController.text,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    final responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      // Registration successful
      print(responseData['Registration successful']);
    } else {
      // Registration failed
      print(responseData['Registration failed']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,

      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/doctor.jpg"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.9),
              BlendMode.screen,
            ),
          ),
        ),

        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40.0),
            color: Colors.transparent,
          ),
          padding: EdgeInsets.all(60),

          key: _formKey,
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Doctor Registration',
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 30.0,
                  ),
                ),
              ),
              SizedBox(height: 50),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _firstNameController,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person, color: Colors.black),
                          labelText: 'First Name',
                          labelStyle: TextStyle(fontFamily: "Poppins",
                            fontSize: 17,
                            color: Colors.black,)
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter your first name';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _lastNameController,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person, color: Colors.black),
                          labelText: 'Last Name',
                          labelStyle: TextStyle(fontFamily: "Poppins",
                            fontSize: 17,
                            color: Colors.black,)
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter your last name';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child:
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email, color: Colors.black),
                          labelText: 'Email',
                          labelStyle: TextStyle(fontFamily: "Poppins",
                            fontSize: 17,
                            color: Colors.black,)
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.phone, color: Colors.black),
                          labelText: 'Phone',
                          labelStyle: TextStyle(fontFamily: "Poppins",
                            fontSize: 17,
                            color: Colors.black,)
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child:
                    TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.location_on, color: Colors.black),
                          labelText: 'Address',
                          labelStyle: TextStyle(fontFamily: "Poppins",
                            fontSize: 17,
                            color: Colors.black,)
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter your address';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child:
                    TextFormField(
                      controller: _specialityController,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.list_alt, color: Colors.black),
                          labelText: 'Speciality',
                          labelStyle: TextStyle(fontFamily: "Poppins",
                            fontSize: 17,
                            color: Colors.black,)
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter your speciality';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Empty container to push the button to the right
                  Container(),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _registerDoctor(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),

                      ),
                      padding: EdgeInsets.symmetric(vertical: 15),
                      minimumSize: Size(150, 0),
                    ),
                    child: Text(
                      'Register',
                      style: TextStyle(
                        fontFamily: "Poppins",
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),

            ],
          ),

        ),

      ),
    );
  }
}