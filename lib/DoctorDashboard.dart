import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';

class DataPoint {
  final String month;
  final double y;

  DataPoint(this.month, this.y);
}

class DoctorDashboard extends StatefulWidget {
  @override
  _DoctorDashboardState createState() => _DoctorDashboardState();
}


class _DoctorDashboardState extends State<DoctorDashboard> {
  List<DataPoint> dataPointsGood = [];
  List<DataPoint> dataPointsNrml = [];
  List<DataPoint> dataPointsDanger = [];
  String doctorName = '';
  String doctorEmail = '';

  @override
  void initState() {
    super.initState();
    fetchData();
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

  Future<void> fetchDataForState(String state, List<DataPoint> dataPoints) async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/api/graph/$state'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print('Received $state data from server: $data');

        setState(() {
          dataPoints.clear();
          dataPoints.addAll(data.map((item) {
            try {
              final monthName = item['month'].split(' ')[0]; // Extract month name
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
        print('Failed to fetch $state data from the server. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching $state data: $error');
    }
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
                      'John Doe',
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
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('Dr.bouhelais Wahiba' ,style: TextStyle(
                color: Colors.black, // Set your desired text color
              ),),
              accountEmail: Text('wahibabouhlais@example.com',style: TextStyle(
                color: Colors.black, // Set your desired text color
              ),),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/medecin.jpg'),
              ),
              decoration: BoxDecoration(
                color: Color(0xFFE3F2FD), // Set your desired background color
                // You can also use an image as the background:
                // image: DecorationImage(
                //   image: AssetImage('your_image_path.jpg'),
                //   fit: BoxFit.cover,
                // ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.laptop,
                color: Color(0xFF90CAF9), // Set the desired color here
              ),

              title: Text('Dashboard'),
              onTap: () {
                // Handle Title 1 tap
              },
            ),
            ListTile(
              leading: Icon(Icons.message,
                color: Color(0xFF90CAF9),),
              title: Text('Messaging'),
              onTap: () {
                // Handle Title 2 tap
              },
            ),
            ListTile(
              leading: Icon(Icons.groups_rounded,
                color: Color(0xFF90CAF9),),
              title: Text('Patients'),
              onTap: () {
                // Handle Title 3 tap
              },
            ),
            ListTile(
              leading: Icon(Icons.map,
                color: Color(0xFF90CAF9),), // Add this line to set the icon
              title: Text('Map'),
              onTap: () {
                // Handle Title 4 tap
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications,
                color: Color(0xFF90CAF9),), // Add this line to set the icon
              title: Text('Notification'),
              onTap: () {
                // Handle Title 5 tap
              },
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.white, // Set your desired background color
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: _buildGraph(dataPointsGood, Colors.green, 'Good State'),
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: _buildGraph(dataPointsNrml, Colors.orange, 'Moderate State'),
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: _buildGraph(dataPointsDanger, Colors.red, 'Danger State'),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildGraph(List<DataPoint> dataPoints, Color lineColor, String title) {
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
}


void main() {
  runApp(MaterialApp(
    home: DoctorDashboard(),
  ));
}