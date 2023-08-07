// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:frontend/ui/sellers/dashboard/filter_details.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PieChartDashboard extends StatefulWidget {
  final List<FilterCheckModel> filters;
  const PieChartDashboard({super.key, required this.filters});

  @override
  State<PieChartDashboard> createState() => _PieChartDashboardState();
}

class _PieChartDashboardState extends State<PieChartDashboard> {
  static List<ChartData> chartData = [];
  int total = 0;
  @override
  Widget build(BuildContext context) {
    chartData = [];
    for (var filter in widget.filters) {
      chartData.add(ChartData(filter.title!,
          double.parse(filter.numOfFiles!.toString()), filter.color!));
    }
    return Scaffold(
        body: Center(
            child: Container(
                child: SfCircularChart(
                    onDataLabelRender: (DataLabelRenderArgs args) {
                      var data = args.dataPoints[args.pointIndex];
                      print('Valor del item: ${data.toString()}');
                      if (args.dataPoints[args.pointIndex].isVisible) {
                        calculateTotal(args.dataPoints[args.pointIndex].y);
                      }
                    },
                    annotations: <CircularChartAnnotation>[
                      CircularChartAnnotation(
                        widget: Container(
                          child: Text('Total: 100%',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              )),
                        ),
                      )
                    ],
                    legend: Legend(
                        isVisible: true, position: LegendPosition.bottom),
                    onLegendItemRender: (legendRenderArgs) {
                      print(legendRenderArgs.toString());
                    },
                    palette: <Color>[
                      // Colors.amber,
                      // Colors.brown,
                      // Colors.green,
                      // Colors.redAccent,
                      // Colors.blueAccent,
                      // Colors.teal
                    ],
                    series: <CircularSeries<ChartData, String>>[
                      // Render pie chart

                      PieSeries<ChartData, String>(
                          dataSource: chartData,
                          pointColorMapper: (ChartData data, _) => data.color,
                          xValueMapper: (ChartData data, _) => data.x,
                          yValueMapper: (ChartData data, _) => data.y,
                          dataLabelMapper: (ChartData data, _) => '${data.y}%',
                          dataLabelSettings: DataLabelSettings(
                              labelPosition: ChartDataLabelPosition.outside,
                              isVisible: true))
                    ]))));
  }

  calculateTotal(int value) {
    total += value;
  }
}

class ChartData {
  ChartData(this.x, this.y, this.color);
  final String x;
  final double y;
  final Color color;
}
