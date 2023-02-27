import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:task_tracker/config/colors.dart';

import '../../model/task_model.dart';
import '../../utils/date_time_converter.dart';

class Statistics extends StatefulWidget {
  final List<TaskModel>? tasks;

  const Statistics({super.key, required this.tasks});

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  DateTimeConverter dateTimeConverter = DateTimeConverter();

  List<int> chartData = [];
  List<TaskModel> taskData = [];
  List<Map> barGraphData = [];
  int maxDuration = 0;

  @override
  void initState() {
    widget.tasks!.sort((a, b) => b.duration.compareTo(a.duration));

    for (var i = 0; i < widget.tasks!.length; i++) {
      TaskModel task = widget.tasks![i];
      if (task.duration != 0) {
        Color color = randomColors[i % randomColors.length];
        maxDuration = widget.tasks!.first.duration;
        chartData.add(task.duration);
        barGraphData.add(
          {
            "name": task.name,
            "duration": task.duration,
            "color": color,
          },
        );
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: kscaffoldColor,
      appBar: AppBar(
        backgroundColor: kscaffoldColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: chartData.isEmpty
          ? Center(
              child: const Text('No time data found'),
            )
          : Stack(
              children: [
                ListView(
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: PieChart(
                        PieChartData(
                          borderData: FlBorderData(show: false),
                          sectionsSpace: 0,
                          centerSpaceRadius: 80,
                          startDegreeOffset: 10,
                          sections: showingSections(chartData, taskData),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    for (var i = 0; i < barGraphData.length; i++)
                      barData(
                        barGraphData[i]['name'],
                        barGraphData[i]['duration'],
                        barGraphData[i]['color'],
                      ),
                    const SizedBox(height: 70),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  width: width,
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.01),
                          Colors.black,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  List<PieChartSectionData> showingSections(
      List<int> data, List<TaskModel> taskData) {
    return data.asMap().entries.map((entry) {
      final int index = entry.key;
      final int value = entry.value;
      final parsedValue = dateTimeConverter.formatSeconds(value);
      const double fontSize = 16;
      const double radius = 77;
      return PieChartSectionData(
        color: barGraphData[index]['color'],
        value: value.toDouble(),
        title: parsedValue,
        radius: radius,
        titleStyle: const TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Color(0xffffffff),
        ),
      );
    }).toList();
  }

  Widget barData(String title, int duration, Color color) {
    String time = dateTimeConverter.secondToHoursMin(duration);
    final barWidth = duration / maxDuration;
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                time,
                style: const TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: LinearProgressIndicator(
              minHeight: 8,
              value: barWidth,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
