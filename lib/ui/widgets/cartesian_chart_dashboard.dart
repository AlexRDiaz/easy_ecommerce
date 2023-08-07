import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CartesianChartDashboard extends StatefulWidget {
  const CartesianChartDashboard({super.key});

  @override
  State<CartesianChartDashboard> createState() =>
      _CartesianChartDashboardState();
}

class _CartesianChartDashboardState extends State<CartesianChartDashboard> {
  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      ChartData('China', 12, 10, 14, 20),
      ChartData('USA', 14, 11, 18, 23),
      ChartData('UK', 16, 10, 15, 20),
      ChartData('Brazil', 18, 16, 18, 24)
    ];

    return Scaffold(
        body: Center(
            child: Container(
                child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(),
                    series: <ChartSeries>[
          StackedColumnSeries<ChartData, String>(
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y1),
          StackedColumnSeries<ChartData, String>(
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y2),
          StackedColumnSeries<ChartData, String>(
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y3),
          StackedColumnSeries<ChartData, String>(
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y4)
        ]))));
  }
}

class ChartData {
  ChartData(this.x, this.y1, this.y2, this.y3, this.y4);
  final String x;
  final int y1;
  final int y2;
  final int y3;
  final int y4;
}
