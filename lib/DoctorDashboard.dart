import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

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
  final String? doctorImage;

  DoctorDashboard({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.doctorId,
    this.doctorImage,
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
  bool _showProfile = false;
  Map<String, dynamic>? _doctorProfile;
  bool _showNotificationMessage = false;
  bool notificationPressed = false;
  String? _doctorImage;
  int patientsInDangerCount = 0;


  @override
  void initState() {
    super.initState();
    fetchData();
    fetchDoctorPatients();
    fetchDoctorProfile();
    _doctorImage = widget.doctorImage;
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

  //getting the stets of testes backend
  Future<void> fetchDataForState(
      String state, List<DataPoint> dataPoints) async {
    try {
      final response =
      await http.get(Uri.parse('http://localhost:3000/api/graph/$state/${widget.doctorId}'));

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

//My Home Page
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
                    setState(() {
                      _showNotificationMessage = true;
                      _showGraphs = false;
                      _showProfile = false;
                    });
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
                      backgroundImage: _doctorImage != null ? NetworkImage(_doctorImage!) : null, // Set doctor's image as the background image
                      child: _doctorImage == null ? Icon(Icons.person, color: Colors.white) : null, // Show default icon if image is null
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
                      backgroundImage: _doctorImage != null ? NetworkImage(_doctorImage!) : null, // Set doctor's image as the background image
                      // child: _doctorImage == null ? Icon(Icons.person, color: Colors.white) : null, // Show default icon if image is null
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
                        _showGraphs = true;// Show graphs
                        _showProfile = false;
                        _showNotificationMessage = false;
                        notificationPressed = false;
                      });
                      Navigator.pop(context); // Close drawer
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.groups_rounded, color: Color(0xFF90CAF9)),
                    title: Text('Patients'),
                    onTap: () {
                      setState(() {
                        _showGraphs = false;
                        _showProfile = false; // Show patient information table
                        _showNotificationMessage = false;
                        if (notificationPressed) {
                          notificationPressed = false; // Reset the variable
                        }
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
                    leading: Stack(
                      children: [
                        Icon(Icons.notifications, color: Color(0xFF90CAF9)),
                        if (patientsInDangerCount > 0 )
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                patientsInDangerCount.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    title: Text('Notification'),
                    onTap: () {
                      setState(() {
                        _showNotificationMessage = true;
                        _showGraphs = false;
                        _showProfile = false;
                        notificationPressed = true;
                        patientsInDangerCount = 0; // Reset count
                      });
                      Navigator.pop(context);
                    },
                  ),


                  ListTile(
                    leading: Icon(Icons.person, color: Color(0xFF90CAF9)),
                    title: Text('Profile'),
                    onTap: () {
                      setState(() {
                        _showProfile = true;
                        _showNotificationMessage = false;
                        if (notificationPressed) {
                          notificationPressed = false; // Reset the variable
                        }
                      });
                      Navigator.pop(context);
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
      body:


      _showProfile
          ? _buildDoctorProfile()
          : _showNotificationMessage
          ? _buildNotificationMessage()
          : _buildBody(),


    );
  }
  Widget _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: _showGraphs ? _buildGraphs() : _buildPatientInfoTable(),
        ),
      ],
    );
  }
  //how i made the graphs
  Widget _buildGraphs() {
    return Stack(
      children: [
        Positioned(
          top: MediaQuery.of(context).size.height * 0.4, // Adjust this value as needed
          left: MediaQuery.of(context).size.width * 0.5 - 200, // Center horizontally
          child: FutureBuilder<int>(
            future: fetchPatientCount(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); // Display a loading indicator while fetching data
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final patientCount = snapshot.data!;
                return _buildPatientCountWidget(patientCount);
              }
            },
          ),
        ),
        Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8, // Adjust this value as needed
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: _buildGraph(
                          dataPointsGood,
                          Colors.green,
                          'Good State',
                        ),
                      ),
                      SizedBox(width: 14.0),
                      Expanded(
                        child: _buildGraph(
                          dataPointsNrml,
                          Colors.orange,
                          'Moderate State',
                        ),
                      ),
                      SizedBox(width: 11.0),
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
                SizedBox(height: 4),
              ],
            ),
          ),
        ),
      ],
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
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      return Text(value.toString());
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index >= 0 && index < dataPoints.length) {
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          space: 4.0,
                          child: Text(dataPoints[index].month),
                        );
                      }
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        space: 4.0,
                        child: Text(''),
                      );
                    },
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: const Color(0xff37434d), width: 1),
              ),
              minX: 0,
              maxX: dataPoints.length.toDouble() - 1,
              minY: 0,
              maxY: dataPoints.isNotEmpty
                  ? dataPoints.map((e) => e.y).reduce((max, e) => max > e ? max : e) + 1
                  : 1,
              lineBarsData: [
                LineChartBarData(
                  spots: dataPoints.asMap().entries.map((entry) {
                    final index = entry.key.toDouble();
                    final dataPoint = entry.value;
                    return FlSpot(index, dataPoint.y);
                  }).toList(),
                  isCurved: true,
                  color: lineColor,
                  dotData: FlDotData(show: true),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [lineColor.withOpacity(0.3), lineColor.withOpacity(0.0)],
                      stops: [0.5, 1.0],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

////////////////////////////////////////////////////////////count patient/////////////////////////////////////////////////////////////////////////////
  Future<int> fetchPatientCount() async {
    final response = await http.get(Uri.parse('http://localhost:3000/api/doctors/${widget.doctorId}/patients/count'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['count'];
    } else {
      throw Exception('Failed to fetch patient count');
    }
  }
  Widget _buildPatientCountWidget(int count) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.04), // Adjust the left padding as needed
        child: Container(
          width: 300, // Reduced width
          padding: EdgeInsets.all(20), // Reduced padding
          decoration: BoxDecoration(
            color: Color(0xFFE3F2FD),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                offset: Offset(-6, 8), // Adjusted shadow offset
                blurRadius: 12, // Adjusted blur radius
                color: Color(0xFFDADEE8),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // Center the row
                children: [
                  Text(
                    'Total patients',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 20, // Reduced font size
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 30), // Reduced space
                  Image.asset(
                    'chart.jpg', // Replace 'chart.jpg' with your image path
                    width: 50, // Reduced image width
                    height: 50, // Reduced image height
                    // Optionally, you can set fit: BoxFit.cover or BoxFit.fill
                    // to adjust how the image fits into the container.
                  ),
                ],
              ),
              SizedBox(height: 4), // Reduced space
              Text(
                count.toString(),
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 20, // Reduced font size
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 6), // Reduced space
              Container(
                width: double.infinity,
                height: 4, // Reduced height
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5), // Adjusted border radius
                  color: Color(0xFFE9ECEF),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: -10, // Adjusted position
                      top: 0,
                      bottom: 0,
                      child: Container(
                        width: 280, // Adjusted width
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5), // Adjusted border radius
                          gradient: LinearGradient(
                            colors: [Color(0xFF834D9B), Color(0xFFD04ED6)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


/////////////////////////////////////////////////////////////List Of patients////////////////////////////////////////////////////////////////////////
  //showing my patients list backend
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

  Widget _buildPatientInfoTable() {
    bool _isEven(int index) => index % 2 == 0;
    return Center(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 12.0, top: 10.0),
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
              color: Color(0xFFE3F2FD),
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
                columnSpacing: 40, // Increase spacing between columns
                dataRowHeight: 115, // Set a larger fixed height for the rows
                columns: [
                  DataColumn(label: Text('First Name')),
                  DataColumn(label: Text('Last Name')),
                  DataColumn(label: Text('Email')),
                  DataColumn(label: Text('Diabetes History')),
                  DataColumn(label: Text('Diabetes Type')),
                  DataColumn(label: Text('DKA HISTORY')),
                  DataColumn(label: Text('More Details')),
                  DataColumn(label: Text('Update Patients')),
                ],
                rows: _patientsInfo.asMap().entries.map<DataRow>((entry) {
                  final index = entry.key;
                  final patient = entry.value;
                  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
                  return DataRow(
                    color: MaterialStateColor.resolveWith(
                            (states) => _isEven(index) ? Colors.white : Color(0xFFE3F2FD)),
                    cells: [
                      DataCell(
                        Center(child: Text(patient['first_name'] ?? '')),
                      ),
                      DataCell(
                        Center(child: Text(patient['last_name'] ?? '')),
                      ),
                      DataCell(
                        Center(child: Text(patient['email'] ?? '')),
                      ),
                      DataCell(
                        Center(child: Text(patient['medical_folder']['diabetes_history'] ?? '')),
                      ),
                      DataCell(
                        Center(child: Text(patient['medical_folder']['diabetes_type'] ?? '')),
                      ),
                      DataCell(
                        Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Date: ${patient['dka_history'] != null ? dateFormat.format(DateTime.parse(patient['dka_history']['date'])) : ''}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 1),
                              Text(
                                'Acetone QT: ${patient['dka_history'] != null ? patient['dka_history']['acetoneqet'] : ''}',
                              ),
                              SizedBox(height: 1),
                              Text(
                                'Order: ${patient['dka_history'] != null ? patient['dka_history']['order'] : ''}',
                              ),
                              SizedBox(height: 1),
                              IconButton(
                                icon: Icon(Icons.arrow_drop_down_circle),
                                onPressed: () {
                                  _showAllDKA(patient['medical_folder']['id_folder']);
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                      DataCell(
                        Center(
                          child: IconButton(
                            icon: Icon(Icons.info),
                            onPressed: () {
                              _showPatientDetailsDialog(patient);
                            },
                          ),
                        ),
                      ),
                      DataCell(
                        Center(
                          child: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              try {
                                showEditMedicalDialog(context, patient);
                              } catch (e) {
                                print('Error showing edit dialog: $e');
                              }
                            },
                          ),
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


  Future<void> _showAllDKA(int idFolder) async {
    try {
      final response = await http.get(
          Uri.parse('http://localhost:3000/api/medicalfolders/$idFolder/dka'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        List<dynamic> dkaList = jsonData['dka'];

        // Show DKA history in a ListView
        showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.all(20.0),
                    width: MediaQuery.of(context).size.width * 0.5,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          'DKA History',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10.0),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: Scrollbar(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: dkaList.length,
                              itemBuilder: (BuildContext context, int index) {
                                final date = DateTime.parse(dkaList[index]['date']);
                                final formattedDate = '${date.year} - ${date.month} - ${date.day}';
                                return Column(
                                  children: [
                                    ListTile(
                                      title: Text(
                                        'Date: $formattedDate',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(height: 5.0),
                                          Text('Acetone QT: ${dkaList[index]['acetoneqet']}'),
                                          SizedBox(height: 5.0),
                                          Text('Order: ${dkaList[index]['order']}'),
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      color: Colors.grey,
                                      thickness: 0.5,
                                      indent: 16,
                                      endIndent: 16,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        ),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        color: Colors.white,
                        iconSize: 20.0,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      } else {
        print(
            'Failed to fetch DKA history from the server. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching DKA history: $error');
    }
  }




















  //patient list details button backend
  Future<void> _showPatientDetailsDialog(Map<String, dynamic> patient) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
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
                    child: _buildDetailRow('Date of Birth', dateFormat.format(DateTime.parse(patient['medical_folder']['datebirth']))),
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




  //////Update patients
  void showEditMedicalDialog(BuildContext context, Map<String, dynamic> patient) {
    // Add this print statement to log the patient object
    print('Medical folder object received from backend: ${patient['medical_folder']}');

    TextEditingController diabetesTypeController =
    TextEditingController(text: patient['medical_folder']['diabetes_type']);

    // Extract id_folder from the medical_folder object if it exists, otherwise set it to null
    int? medicalFolderId = patient['medical_folder']['id_folder'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white, // Set background color to white
          title: Center(
            child: Text(
              "Edit Patient",
              style: TextStyle(
                fontFamily: "Poppins",
                color: Colors.blue,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ), // Set title in the middle and use Poppins font
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  value: diabetesTypeController.text,
                  items: ['Type 1', 'Type 2'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    diabetesTypeController.text = newValue!;
                  },
                  decoration: InputDecoration(
                    labelText: 'Diabetes Type',
                    focusColor: Colors.blueAccent, // Set focus color to blue
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Color(0xFF90CAF9),
                  fontFamily: "Poppins",
                ),
              ), // Set cancel button text color
            ),
            TextButton(
              onPressed: () async {
                // Prepare the updated medical folder data
                Map<String, dynamic> updatedMedicalFolder = {
                  'diabetes_type': diabetesTypeController.text,
                };

                if (medicalFolderId != null) {
                  // Perform the update request only if medicalFolderId is not null
                  final response = await http.put(
                    Uri.parse('http://localhost:3000/api/medicalfolders/$medicalFolderId'),
                    body: jsonEncode(updatedMedicalFolder),
                    headers: {'Content-Type': 'application/json'},
                  );

                  if (response.statusCode == 200) {
                    print('Medical folder updated successfully for patient ${patient['first_name']}');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Medical folder updated successfully'),
                        backgroundColor: Colors.green, // Set snackbar background color
                      ),
                    ); // Show success message
                    fetchDoctorPatients(); // Refresh the patient list after update
                  } else {
                    print('Failed to update medical folder for patient ${patient['first_name']}: ${response.statusCode}');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to update medical folder'),
                        backgroundColor: Colors.red, // Set snackbar background color
                      ),
                    ); // Show error message
                  }
                } else {
                  print('medicalFolderId is null');
                }

                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                "Update",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Poppins",
                ),
              ), // Set update button text color to white
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xFF90CAF9)), // Set button background color
              ),
            ),
          ],
        );
      },
    );
  }

////////////////////////////////////////////////////////////notification///////////////////////////////////////////////////////////////////////////////
  Future<List<Map<String, dynamic>>> fetchPatientsInDanger(int doctorId) async {
    final response = await http.get(Uri.parse('http://localhost:3000/api/patients/danger/$doctorId'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      patientsInDangerCount = data.length; // Update count
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to fetch patients in danger');
    }
  }
  Widget _buildNotificationMessage() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchPatientsInDanger(widget.doctorId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // Display a loading indicator while fetching data
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final patients = snapshot.data!;

          return Center(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 10.0 ,top: 20.0),
                  child: Text(
                    'Notification',
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
                    color: Color(0xFFE3F2FD),
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
                      columnSpacing: 40, // Increase spacing between columns
                      columns: [
                        DataColumn(label: Text('First Name')),
                        DataColumn(label: Text('Last Name')),
                        DataColumn(label: Text('Email')),
                        DataColumn(label: Text('Date of Test')),
                        DataColumn(label: Text('Acetone Quantity')),
                        DataColumn(label: Text('State')),
                        DataColumn(label: Text('Position')),
                      ],

                      rows: patients.asMap().entries.map<DataRow>((entry) {
                        final index = entry.key;
                        final patient = entry.value;
                        final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

                        return DataRow(
                          color: MaterialStateColor.resolveWith((states) => Colors.white),
                          cells: [
                            DataCell(
                              Center(child: Text(patient['firstName'] ?? '')),
                              // Adjust padding for center alignment
                              onTap: () => _showPatientDetailsDialog(patient),
                            ),
                            DataCell(
                              Center(child: Text(patient['lastName'] ?? '')),
                              // Adjust padding for center alignment
                              onTap: () => _showPatientDetailsDialog(patient),
                            ),
                            DataCell(
                              Center(child: Text(patient['email'] ?? '')),
                              // Adjust padding for center alignment
                              onTap: () => _showPatientDetailsDialog(patient),
                            ),
                            DataCell(
                              Center(child: Text(dateFormat.format(DateTime.parse(patient['dateOfTest'] ?? '')))), // Adjust for date formatting if necessary
                              // Adjust padding for center alignment
                              onTap: () => _showPatientDetailsDialog(patient),
                            ),
                            DataCell(
                              Center(child: Text(patient['acetoneQt'].toString())),
                              // Adjust padding for center alignment
                              onTap: () => _showPatientDetailsDialog(patient),
                            ),
                            DataCell(
                              Center(child: Text('danger')),
                              // Adjust padding for center alignment
                              onTap: () => _showPatientDetailsDialog(patient),
                            ),

                            DataCell(
                              Center(
                                child: IconButton(
                                  icon: Icon(Icons.pageview),
                                  onPressed: () {
                                  },
                                ),
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
      },
    );
  }

/////////////////////////////////////////////////////////////////////Doctor Profile ////////////////////////////////////////////////////////////////

  //the doctor profile backend
  Future<void> fetchDoctorProfile() async {
    final url = 'http://localhost:3000/api/doctor/profile/${widget.doctorId}';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _doctorProfile = data;
        });
      } else {
        print('Failed to fetch doctor profile: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching doctor profile: $error');
    }
  }

  Widget _buildDoctorProfile() {
    if (_doctorProfile == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Center(
        child: Container(
          height: 300,
          margin: EdgeInsets.all(10.0),
          child: Padding(
            padding: EdgeInsets.all(4.0),
            child: Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Doctor Profile',
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildProfileItem('First Name', _doctorProfile!['first_name']),
                            _buildProfileItem('Last Name', _doctorProfile!['last_name']),
                            _buildProfileItem('Email', _doctorProfile!['email']),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildProfileItem('Phone', _doctorProfile!['phone']),
                            _buildProfileItem('Address', _doctorProfile!['address']),
                            _buildProfileItem('Speciality', _doctorProfile!['speciality']),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return _buildUpdateProfileDialog(context);
                            },
                          );
                        },
                        child: Text(
                          'Update',
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF90CAF9)),
                          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                            EdgeInsets.symmetric(vertical: 15.0, horizontal: 40.0),
                          ),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          _showChangePasswordDialog();
                        },
                        child: Text(
                          'Change Password',
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF90CAF9)),
                          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                            EdgeInsets.symmetric(vertical: 15.0, horizontal: 40.0),
                          ),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
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
  //Update the doctor profile
  Widget _buildUpdateProfileDialog(BuildContext context) {
    // Declare TextEditingController for each field
    TextEditingController firstNameController = TextEditingController(text: _doctorProfile!['first_name']);
    TextEditingController lastNameController = TextEditingController(text: _doctorProfile!['last_name']);
    TextEditingController emailController = TextEditingController(text: _doctorProfile!['email']);
    TextEditingController phoneController = TextEditingController(text: _doctorProfile!['phone']);
    TextEditingController addressController = TextEditingController(text: _doctorProfile!['address']);
    TextEditingController specialityController = TextEditingController(text: _doctorProfile!['speciality']);

    // Function to handle profile update
    void updateProfile() async {
      try {
        // Prepare the request body with updated profile information
        Map<String, dynamic> requestBody = {
          'first_name': firstNameController.text,
          'last_name': lastNameController.text,
          'email': emailController.text,
          'phone': phoneController.text,
          'address': addressController.text,
          'speciality': specialityController.text,
        };

        final response = await http.put(
          Uri.parse('http://localhost:3000/api/doctors/profile/${widget.doctorId}'),
          body: jsonEncode(requestBody),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );

        if (response.statusCode == 200) {
          Navigator.of(context).pop(); // Close the dialog
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Doctor profile updated successfully'),
            backgroundColor: Colors.green,
          ));
          setState(() {
            _doctorProfile = {
              ..._doctorProfile!,
              'first_name': firstNameController.text,
              'last_name': lastNameController.text,
              'email': emailController.text,
              'phone': phoneController.text,
              'address': addressController.text,
              'speciality': specialityController.text,
            };
          });
          // Fetch updated data after profile update
          fetchDoctorPatients();
        } else {
          // If the update fails, show an error message
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Failed to update doctor profile'),
            backgroundColor: Colors.red,
          ));
        }
      } catch (error) {
        // Handle any errors that occur during the request
        print('Error updating doctor profile: $error');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('An error occurred while updating doctor profile'),
          backgroundColor: Colors.red,
        ));
      }
    }

    return AlertDialog(
      title: Center(
        child: Text(
          'Update Profile',
          style: TextStyle(
            fontFamily: "Poppins",
            color: Colors.blue,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              controller: firstNameController,
              decoration: InputDecoration(
                labelText: 'First Name',
                labelStyle: TextStyle(
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            TextFormField(
              controller: lastNameController,
              decoration: InputDecoration(
                labelText: 'Last Name',
                labelStyle: TextStyle(
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            TextFormField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: 'Phone',
                labelStyle: TextStyle(
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            TextFormField(
              controller: addressController,
              decoration: InputDecoration(
                labelText: 'Address',
                labelStyle: TextStyle(
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            TextFormField(
              controller: specialityController,
              decoration: InputDecoration(
                labelText: 'Speciality',
                labelStyle: TextStyle(
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the AlertDialog
          },
          child: Text(
            'Cancel',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              color: Color(0xFF90CAF9),
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            updateProfile();
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Color(0xFF90CAF9)),
          ),
          child: Text(
            'Update',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileItem(String label, String value) {
    IconData iconData;
    switch (label) {
      case 'First Name':
        iconData = Icons.person;
        break;
      case 'Last Name':
        iconData = Icons.person;
        break;
      case 'Email':
        iconData = Icons.email;
        break;
      case 'Phone':
        iconData = Icons.phone;
        break;
      case 'Address':
        iconData = Icons.location_on;
        break;
      case 'Speciality':
        iconData = Icons.work;
        break;
      default:
        iconData = Icons.info; // Default icon
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 13.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            iconData,
            color: Colors.black,
          ),
          SizedBox(width: 20.0),
          Text(
            label,
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(width: 30.0), // Add some space between label and value
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

////////change password
  void _changePassword(BuildContext context, String currentPassword, String newPassword) async {
    // Check if the new password meets the minimum length requirement
    if (newPassword.length <= 7) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password must be more than 7 characters long.'),
          backgroundColor: Colors.red,
        ),
      );
      return; // Exit the function early if the password is not valid
    }
    // Show Snackbar message indicating that the password change process has started
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Changing password...'),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.blue,
      ),
    );

    final url = 'http://localhost:3000/api/doctor/updatePassword';
    final body = jsonEncode({'email': widget.email, 'currentPassword': currentPassword, 'newPassword': newPassword});

    try {
      final response = await http.post(Uri.parse(url), body: body, headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status']) {
          // Password updated successfully
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Password changed successfully'),
              duration: Duration(seconds: 1),
              backgroundColor: Colors.green,
            ),
          );

          // Close the dialog
          Navigator.of(context).pop();
        } else {
          // Failed to update password, show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(data['message']), // Display the error message received from the backend
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        // Failed to update password, show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to change password. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      // Handle error, show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred while changing password.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  void _showChangePasswordDialog() {
    TextEditingController currentPasswordController = TextEditingController();
    TextEditingController newPasswordController = TextEditingController();
    TextEditingController confirmNewPasswordController = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white, // Set background color to white
          title: Text(
            'Change Password',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue, // Change text color to blue
              fontFamily: 'Poppins', // Set font family to Poppins
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'New Password'),
              ),
              TextField(
                controller: confirmNewPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Confirm New Password'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Color(0xFF90CAF9),
                  fontFamily: "Poppins",
                ),
              ), // Set cancel button text color
            ),
            ElevatedButton(
              onPressed: () {
                // Validate and change password
                final currentPassword = currentPasswordController.text;
                final newPassword = newPasswordController.text;
                final confirmNewPassword = confirmNewPasswordController.text;

                // Check if any field is empty
                if (newPassword.isEmpty || confirmNewPassword.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please fill in all fields.'),
                      duration: Duration(seconds: 2),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                // Check if new password matches the confirmation
                if (newPassword != confirmNewPassword) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('New password and confirmation do not match.'),
                      duration: Duration(seconds: 2),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                // Call method to change password
                _changePassword(context, currentPassword, newPassword);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xFF90CAF9)), // Set button background color to light blue
              ),
              child: Text('Change Password', style: TextStyle(color: Colors.white)), // Set button text color to white
            ),
          ],
        );
      },
    );
  }
  ///////////////////////////////////////////////////////////////////////////LOGOUT////////////////////////////////////////////////////////////////////
  void _logout() async {
    try {
      // Navigate back to the homepage
      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
    } catch (error) {
      print('Error during logout: $error');
    }
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
                _logout();
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

}
