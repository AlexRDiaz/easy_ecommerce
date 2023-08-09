import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DynamicStackedColumnChart extends StatefulWidget {
  final List<Map<String, dynamic>> dataList;

  DynamicStackedColumnChart({required this.dataList});

  @override
  State<DynamicStackedColumnChart> createState() =>
      _DynamicStackedColumnChartState();
}

class _DynamicStackedColumnChartState extends State<DynamicStackedColumnChart> {
  double tama = 0.1;

  reduceTam() {
    tama = tama - 0.01;
    return tama;
  }

  @override
  Widget build(BuildContext context) {
    double tam = widget.dataList.length > 6 ? reduceTam() : tama;

    return Column(
      children: [
        Expanded(
          child: SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            series: <ChartSeries>[
              StackedColumnSeries<Map<String, dynamic>, String>(
                width: tam,
                dataSource: widget.dataList,
                xValueMapper: (Map<String, dynamic> data, _) => data['x'],
                yValueMapper: (Map<String, dynamic> data, _) => data['y1'],
                name: 'Y1',
              ),
              StackedColumnSeries<Map<String, dynamic>, String>(
                width: tam,
                dataSource: widget.dataList,
                xValueMapper: (Map<String, dynamic> data, _) => data['x'],
                yValueMapper: (Map<String, dynamic> data, _) => data['y2'],
                name: 'Y2',
              ),
              StackedColumnSeries<Map<String, dynamic>, String>(
                width: tam,
                dataSource: widget.dataList,
                xValueMapper: (Map<String, dynamic> data, _) => data['x'],
                yValueMapper: (Map<String, dynamic> data, _) => data['y3'],
                name: 'Y3',
              ),
              StackedColumnSeries<Map<String, dynamic>, String>(
                width: tam,
                dataSource: widget.dataList,
                xValueMapper: (Map<String, dynamic> data, _) => data['x'],
                yValueMapper: (Map<String, dynamic> data, _) => data['y4'],
                name: 'Y4',
              ),
              StackedColumnSeries<Map<String, dynamic>, String>(
                width: tam,
                dataSource: widget.dataList,
                xValueMapper: (Map<String, dynamic> data, _) => data['x'],
                yValueMapper: (Map<String, dynamic> data, _) => data['y5'],
                name: 'Y5',
              ),
              StackedColumnSeries<Map<String, dynamic>, String>(
                width: tam,
                dataSource: widget.dataList,
                xValueMapper: (Map<String, dynamic> data, _) => data['x'],
                yValueMapper: (Map<String, dynamic> data, _) => data['y6'],
                name: 'Y6',
              ),
              StackedColumnSeries<Map<String, dynamic>, String>(
                width: tam,
                dataSource: widget.dataList,
                xValueMapper: (Map<String, dynamic> data, _) => data['x'],
                yValueMapper: (Map<String, dynamic> data, _) => data['y7'],
                name: 'Y7',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
