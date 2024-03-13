import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Line Chart Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyChartWidget(),
    );
  }
}

class MyChartWidget extends StatefulWidget {
  @override
  _MyChartWidgetState createState() => _MyChartWidgetState();
}

class _MyChartWidgetState extends State<MyChartWidget> {
  List<double> yValues = [];
  List<String> xLabels = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('http://localhost:3000/api/graph/good'));
    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      setState(() {
        // Handle null values by providing a default value (0.0 in this case)
        yValues = responseData
            .map<double>((item) => (item['avg_acetoneqt'] as num?)?.toDouble() ?? 0.0)
            .toList();
      });
    } else {
      // Handle errors
      print('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Line Chart Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: yValues.isEmpty
            ? Center(
          child: Text('No data available'),
        )
            : LineChart(
          LineChartData(
            gridData: FlGridData(show: false),
            borderData: FlBorderData(show: true),
            lineBarsData: [
              LineChartBarData(
                spots: List.generate(
                  yValues.length,
                      (index) => FlSpot(index.toDouble(), yValues[index]),
                ),
                isCurved: true,
                colors: [Colors.blue],
                dotData: FlDotData(show: false),
                belowBarData: BarAreaData(show: false),
              ),
            ],
            titlesData: FlTitlesData(
              leftTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitles: (value) {
                  return value.toInt().toString();
                },
              ),
              bottomTitles: SideTitles(
                showTitles: true,
                reservedSize: 22,
                getTitles: (value) {
                  return xLabels[value.toInt()];
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}