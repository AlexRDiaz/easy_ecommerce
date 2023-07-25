import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Chart extends StatefulWidget {
  final List sections;
  final int total;
  const Chart({Key? key, required this.sections, required this.total})
      : super(key: key);

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  // List lista = [
  //   {
  //     'color': Color(0xFF2697FF),
  //     'value': 25,
  //     'showTitle': false,
  //     'radius': 25,
  //   },
  //   {
  //     'color': Color.fromARGB(255, 170, 204, 3),
  //     'value': 25,
  //     'showTitle': false,
  //     'radius': 25,
  //   },
  //   {
  //     'color': Color.fromARGB(255, 223, 28, 197),
  //     'value': 25,
  //     'showTitle': false,
  //     'radius': 25,
  //   },
  //   {
  //     'color': Color.fromARGB(255, 4, 130, 8),
  //     'value': 25,
  //     'showTitle': false,
  //     'radius': 25,
  //   }
  // ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 70,
              startDegreeOffset: -90,
              sections: generateChartData(),
            ),
          ),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 16.0),
                Text(
                  "Total",
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: const Color.fromARGB(255, 10, 10, 10),
                        fontWeight: FontWeight.w600,
                        height: 0.5,
                      ),
                ),
                Text("${widget.total} registros")
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> generateChartData() {
    // for (var point in lista) {
    //   total += int.parse(point["value"]);
    // }

    int startDegree = -90;
    List<PieChartSectionData> chartData = [];

    if (widget.total == 0) {
      chartData.add(
        PieChartSectionData(
          color: Colors.amber,
          showTitle: false,
          value: 1.0,
        ),
      );
    } else {
      for (var sec in widget.sections) {
        double percentage = sec['value'] / widget.total;

        PieChartSectionData section = PieChartSectionData(
          color: sec['color'],
          value: sec['value'],
          title: '${(percentage * 100).toStringAsFixed(1)}%',
          radius: 100,
          showTitle: true,
          titleStyle: TextStyle(fontSize: 16, color: Colors.white),
        );
        chartData.add(section);
      }
    }
    return chartData;
  }
}

// List<PieChartSectionData> paiChartSelectionData = [
//   PieChartSectionData(
//     color: Color(0xFF2697FF),
//     value: 25,
//     showTitle: false,
//     radius: 25,
//   ),
//   PieChartSectionData(
//     color: Color(0xFF26E5FF),
//     value: 25,
//     showTitle: false,
//     radius: 22,
//   ),
//   PieChartSectionData(
//     color: Color(0xFFFFCF26),
//     value: 25,
//     showTitle: false,
//     radius: 19,
//   ),
//   PieChartSectionData(
//     color: Color(0xFFEE2727),
//     value: 25,
//     showTitle: false,
//     radius: 16,
//   ),
//   // PieChartSectionData(
//   //   color: Color(0xFF2697FF).withOpacity(0.1),
//   //   value: 25,
//   //   showTitle: false,
//   //   radius: 13,
//   // ),
//];
