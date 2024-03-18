import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';

// Define DataPoint class
class DataPoint {
  final String month;
  final double y;

  DataPoint(this.month, this.y);
}

class DoctorDashboard extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String email;
  final int doctorId;

  DoctorDashboard({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.doctorId,
  });

  @override
  _DoctorDashboardState createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
  List<DataPoint> dataPointsGood = [];
  List<DataPoint> dataPointsNrml = [];
  List<DataPoint> dataPointsDanger = [];
  String doctorName = '';
  String doctorEmail = '';
  List<Map<String, dynamic>> _patientsInfo = [];
  bool _showGraphs = true;

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchDoctorPatients();
  }

  Future<void> fetchData() async {
    print('Fetching data from the server...');

    try {
      await fetchDataForState('good', dataPointsGood);
      await fetchDataForState('nrml', dataPointsNrml);
      await fetchDataForState('danger', dataPointsDanger);
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  Future<void> fetchDataForState(
      String state, List<DataPoint> dataPoints) async {
    try {
      final response =
      await http.get(Uri.parse('http://localhost:3000/api/graph/$state'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print('Received $state data from server: $data');

        setState(() {
          dataPoints.clear();
          dataPoints.addAll(data.map((item) {
            try {
              final monthName =
              item['month'].split(' ')[0]; // Extract month name
              return DataPoint(
                monthName,
                item['patientCount'] is int
                    ? item['patientCount'].toDouble()
                    : double.parse(item['patientCount'].toString()),
              );
            } catch (e) {
              print('Error parsing data: $item');
              return DataPoint('', 0);
            }
          }).toList());
        });

        print('Updated $state dataPoints: $dataPoints');
        dataPoints.forEach((point) {
          print('Month: ${point.month}, Count: ${point.y}');
        });
      } else {
        print(
            'Failed to fetch $state data from the server. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching $state data: $error');
    }
  }

  Future<void> fetchDoctorPatients() async {
    try {
      final response = await http.get(Uri.parse(
          'http://localhost:3000/api/doctors/${widget.doctorId}/patients'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        setState(() {
          _patientsInfo =
          List<Map<String, dynamic>>.from(jsonData['patients']);
        });
      } else {
        print(
            'Failed to fetch doctor patients from the server. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching doctor patients: $error');
    }
  }

  Future<void> _showPatientDetailsDialog(Map<String, dynamic> patient) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: SingleChildScrollView(
            child: Container(
            padding: EdgeInsets.all(10.0),
        width: MediaQuery.of(context).size.width * 0.5,
        decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
        BoxShadow(
        color: Colors.black,
        blurRadius: 10.0,
        offset: Offset(0.0, 10.0),
        ),
        ],
        ),

        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
        Text(
        'Patient  Details',
        style: TextStyle(
        fontFamily: "Poppins",
        color: Colors.blue,
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
        ),
        ),
        SizedBox(height: 10.0),
        Align(
        alignment: Alignment.center,
        child: _buildDetailRow('Phone', patient['phone']),
        ),
        Align(
        alignment: Alignment.center,
        child: _buildDetailRow('Address', patient['address'].toString()),
        ),
              Align(
                alignment: Alignment.center,
                  child: _buildDetailRow('Age', patient['medical_folder']['age'].toString()),
              ),
              Align(
                alignment: Alignment.center,
                child: _buildDetailRow('Weight', patient['medical_folder']['weight'].toString()),
              ),
              Align(
                alignment: Alignment.center,
                child: _buildDetailRow('Height', patient['medical_folder']['height'].toString()),
              ),
              Align(
                alignment: Alignment.center,
                child: _buildDetailRow('Gender', patient['medical_folder']['gender'].toString()),
              ),
              SizedBox(height: 10.0),
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Close',
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 16.0,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ],
        ),
            ),
        ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.0),
      child: Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.arrow_forward_ios, // Example icon, replace with desired icon
              size: 16.0,
            ),
            SizedBox(width: 5.0), // Adjust spacing as needed
            Expanded(
              flex: 1,
              child: Text(
                '$label:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Poppins",
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                value ?? 'N/A', // Display 'N/A' if value is null
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }





  void _showLogoutDialog() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: Text(
            'Are you sure you want to log out of your account?',
            style: TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Color(0xFF90CAF9)),
              ),
            ),
            TextButton(
              onPressed: () {
                // Perform logout operation here
                // For example, you can navigate to the login screen
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                      (route) => false,
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xFF90CAF9)),
              ),
              child: Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Color(0xFFE3F2FD),
            actions: [
              Positioned(
                top: 25,
                right: 500,
                child: IconButton(
                  icon: Icon(Icons.notifications_none_sharp),
                  color: Colors.black,
                  onPressed: () {
                    // Handle notifications action
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.message),
                color: Colors.black,
                onPressed: () {
                  // Handle email action
                },
              ),
              SizedBox(width: 20.0),
              Container(
                padding: EdgeInsets.only(right: 20.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/medecin.jpg'),
                      radius: 20.0,
                    ),
                    SizedBox(width: 20.0),
                    Text(
                      '${widget.firstName} ${widget.lastName}',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  UserAccountsDrawerHeader(
                    accountName: Text(
                      'Dr.${widget.firstName} ${widget.lastName}',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    accountEmail: Text(
                      widget.email,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: AssetImage('assets/medecin.jpg'),
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFFE3F2FD),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.laptop, color: Color(0xFF90CAF9)),
                    title: Text('Dashboard'),
                    onTap: () {
                      setState(() {
                        _showGraphs = true; // Show graphs
                      });
                      Navigator.pop(context); // Close drawer
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.groups_rounded, color: Color(0xFF90CAF9)),
                    title: Text('Patients'),
                    onTap: () {
                      setState(() {
                        _showGraphs = false; // Show patient information table
                      });
                      Navigator.pop(context); // Close drawer
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.map, color: Color(0xFF90CAF9)),
                    title: Text('Map'),
                    onTap: () {
                      // Handle Title 4 tap
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.notifications, color: Color(0xFF90CAF9)),
                    title: Text('Notification'),
                    onTap: () {
                      // Handle Title 5 tap
                    },
                  ),
                ],
              ),
            ),
            Divider(), // Divider to separate the logout button
            ListTile(
              leading: Icon(Icons.logout,  color: Color(0xFF90CAF9)),
              title: Text('Logout'),
              onTap: () {
                _showLogoutDialog();
              },
            ),
          ],
        ),
      ),
      body: _showGraphs ? _buildGraphs() : _buildPatientInfoTable(),
    );
  }

  Widget _buildGraphs() {
    return Container(
      color: Color(0xFFEEF1F5),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: _buildGraph(
                dataPointsGood,
                Colors.green,
                'Good State',
              ),
            ),
            SizedBox(width: 16.0),
            Expanded(
              child: _buildGraph(
                dataPointsNrml,
                Colors.orange,
                'Moderate State',
              ),
            ),
            SizedBox(width: 16.0),
            Expanded(
              child: _buildGraph(
                dataPointsDanger,
                Colors.red,
                'Danger State',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGraph(
      List<DataPoint> dataPoints,
      Color lineColor,
      String title,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.0),
        Container(
          height: 150.0, // Adjust the height as needed
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: true, drawVerticalLine: true),
              titlesData: FlTitlesData(
                leftTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                ),
                bottomTitles: SideTitles(
                  showTitles: true,
                  getTitles: (value) {
                    final index = value.toInt();
                    if (index >= 0 && index < dataPoints.length) {
                      return dataPoints[index].month;
                    }
                    return '';
                  },
                  interval: 1,
                  rotateAngle: 45,
                ),
                rightTitles: SideTitles(showTitles: false),
                topTitles: SideTitles(showTitles: false),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: const Color(0xff37434d), width: 1),
              ),
              minX: 0,
              maxX: dataPoints.length.toDouble() - 1,
              minY: 0,
              maxY: dataPoints.isNotEmpty
                  ? dataPoints
                  .map((e) => e.y)
                  .reduce((max, e) => max > e ? max : e) +
                  1
                  : 1,
              lineBarsData: [
                LineChartBarData(
                  spots: dataPoints.asMap().entries.map((entry) {
                    final index = entry.key.toDouble();
                    final dataPoint = entry.value;
                    return FlSpot(index, dataPoint.y);
                  }).toList(),
                  isCurved: true,
                  colors: [lineColor],
                  dotData: FlDotData(show: true),
                  belowBarData: BarAreaData(
                    show: true,
                    colors: [lineColor.withOpacity(0.3)],
                    gradientColorStops: [0.5, 1.0],
                    gradientFrom: Offset(0, 0),
                    gradientTo: Offset(0, 1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPatientInfoTable() {
    bool _isEven(int index) => index % 2 == 0;

    return Center(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10.0 ,top: 20.0),
            child: Text(
              'Patients List',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            decoration: BoxDecoration(
              color: Color(0xFFEEF1F5),
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingTextStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                dataTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                columnSpacing: 20,
                columns: [
                  DataColumn(label: Text('First Name')),
                  DataColumn(label: Text('Last Name')),
                  DataColumn(label: Text('Email')),
                  DataColumn(label: Text('Diabetes History')),
                  DataColumn(label: Text('DKA History')),
                  DataColumn(label: Text('Diabetes Type')),
                  DataColumn(label: Text('More Details')),
                ],
                rows: _patientsInfo.asMap().entries.map<DataRow>((entry) {
                  final index = entry.key;
                  final patient = entry.value;

                  return DataRow(
                    color: MaterialStateColor.resolveWith((states) =>
                    _isEven(index) ? Colors.white : Color(0xFFEEF1F5)),
                    cells: [
                      DataCell(Text(patient['first_name'] ?? '')),
                      DataCell(Text(patient['last_name'] ?? '')),
                      DataCell(Text(patient['email'] ?? '')),
                      DataCell(Text(patient['medical_folder']['diabetes_history'] ?? '')),
                      DataCell(Text(patient['medical_folder']['dka_history'] ?? '')),
                      DataCell(Text(patient['medical_folder']['diabetes_type'] ?? '')),
                      DataCell(
                        IconButton(
                          icon: Icon(Icons.info),
                          onPressed: () {
                            _showPatientDetailsDialog(patient);
                          },
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
