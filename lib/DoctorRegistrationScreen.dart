import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:uuid/uuid.dart';

class DoctorRegistrationScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _specialityController = TextEditingController();
  Uint8List? imageBytes;
  Uint8List? pdfBytes;

  String? _validateEmail(String? value) {
    if (value != null && value.isNotEmpty) {
      // Use a regular expression to validate email format
      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
        return 'Please enter a valid email address';
      }
    } else {
      return 'Please enter your email';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value != null && value.isNotEmpty) {
      // Check if the entered value contains only digits
      if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
        return 'Please enter a valid phone number';
      }
    } else {
      return 'Please enter your phone number';
    }
    return null;
  }

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

    // Upload image and PDF to Firebase Storage
    String? imageUrl;
    String? pdfUrl;
    if (imageBytes != null) {
      imageUrl = await _uploadToFirebaseStorage(imageBytes!, 'profile',isPhoto: true);
    }
    if (pdfBytes != null) {
      pdfUrl = await _uploadToFirebaseStorage(pdfBytes!, 'PDF');
    }

    // Proceed with registration
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
        'image_url': imageUrl,
        'pdf_url': pdfUrl,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    final responseData = json.decode(response.body);
    try {
      if (response.statusCode == 200) {
        // Registration successful
        print(responseData['message']);
        // Clear form fields
        _firstNameController.clear();
        _lastNameController.clear();
        _emailController.clear();
        _phoneController.clear();
        _addressController.clear();
        _specialityController.clear();
        // Optionally, reset image and pdf bytes
        imageBytes = null;
        pdfBytes = null;
      } else {
        // Registration failed
        print(responseData['message']);
      }
    } catch (error) {
      // Handle network errors
      print('Error: $error');
    }
  }

  Future<String> _uploadToFirebaseStorage(Uint8List fileBytes, String storagePath,
      {bool isPhoto = false}) async {
    String fileName = Uuid().v1() ;
    Reference? reference;
    if(isPhoto){
       reference = FirebaseStorage.instance.ref().child('$storagePath/$fileName.png');

    }else{
       reference = FirebaseStorage.instance.ref().child('$storagePath/$fileName');
    }
    final UploadTask uploadTask = reference.putData(fileBytes);
    await uploadTask;
    return await reference.getDownloadURL();
  }

  void _openPicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      imageBytes = result.files.single.bytes!;
    }
  }

  void _openFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null) {
      pdfBytes = result.files.single.bytes!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 593,
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
          child: Form(
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
                          labelStyle: TextStyle(fontFamily: "Poppins", fontSize: 17, color: Colors.black),
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
                          labelStyle: TextStyle(fontFamily: "Poppins", fontSize: 17, color: Colors.black),
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
                      child: TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email, color: Colors.black),
                          labelText: 'Email',
                          labelStyle: TextStyle(fontFamily: "Poppins", fontSize: 17, color: Colors.black),
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Please enter your email';
                          }
                          return _validateEmail(value);
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
                          labelStyle: TextStyle(fontFamily: "Poppins", fontSize: 17, color: Colors.black),
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Please enter your phone number';
                          }
                          return _validatePhone(value);
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _addressController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.location_on, color: Colors.black),
                          labelText: 'Address',
                          labelStyle: TextStyle(fontFamily: "Poppins", fontSize: 17, color: Colors.black),
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
                      child: TextFormField(
                        controller: _specialityController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.list_alt, color: Colors.black),
                          labelText: 'Speciality',
                          labelStyle: TextStyle(fontFamily: "Poppins", fontSize: 17, color: Colors.black),
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
                SizedBox(height: 36),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: _openFile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFE3F2FD),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 15),
                        minimumSize: Size(150, 0),
                      ),
                      child: Text(
                        'Add PDF',
                        style: TextStyle(
                          fontFamily: "Poppins",
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Spacer(),
                    ElevatedButton(
                      onPressed: _openPicker,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFE3F2FD),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 15),
                        minimumSize: Size(150, 0),
                      ),
                      child: Text(
                        'Profile Picture',
                        style: TextStyle(
                          fontFamily: "Poppins",
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _registerDoctor(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
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
      ),
    );
  }
}
