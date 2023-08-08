import 'package:flutter/material.dart';
import 'package:frontend/ui/sellers/dashboard/filter_details.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class _ChartData {
  _ChartData(this.category, this.value);

  final String category;
  double value;
}

class DynamicPieChart extends StatefulWidget {
  final List<FilterCheckModel> filters;

  const DynamicPieChart({required this.filters});

  @override
  _DynamicPieChartState createState() => _DynamicPieChartState();
}

class _DynamicPieChartState extends State<DynamicPieChart> {
  late List<_ChartData> visibleData;
  late double totalValue;
  List<_ChartData> data = [
    _ChartData('NoData', 10),
  ];
  @override
  void initState() {
    super.initState();
    loadData();
    updateVisibleData();
  }

  loadData() {
    List<_ChartData> dataTemp = [
      _ChartData('NoData', 10)
    ]; // Limpiar la lista antes de agregar los nuevos datos
    for (var filter in widget.filters) {
      if (filter.numOfFiles != null) {
        dataTemp.add(
            _ChartData(filter.title.toString(), filter.percentage!.toDouble()));
      }
    }
    data = dataTemp;
  }

  void updateVisibleData() {
    visibleData = data.where((data) => data.value > 0).toList();

    double totalTemp = 0;

    for (var visible in visibleData) {
      for (var filter in widget.filters) {
        if (filter.title == visible.category) {
          visible.value = filter.numOfFiles!.toDouble();
          totalTemp += int.parse(filter.numOfFiles!.toString());
        }
      }
    }

    totalValue = totalTemp;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SfCircularChart(
            series: <CircularSeries>[
              PieSeries<_ChartData, String>(
                dataSource: visibleData,
                dataLabelMapper: (_ChartData datum, _) {
                  double percentage = (datum.value / totalValue) * 100;
                  return '${percentage.toStringAsFixed(2)}%';
                },
                xValueMapper: (_ChartData datum, _) => datum.category,
                yValueMapper: (_ChartData datum, _) => datum.value,
                dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  labelPosition: ChartDataLabelPosition.outside,
                ),
              ),
            ],
          ),
        ),
        _buildLegend(),
      ],
    );
  }

  Widget _buildLegend() {
    return Wrap(
      children: data.map((data) {
        return InkWell(
          onTap: () {
            setState(() {
              data.value = data.value == 0 ? 10 : 0;
              updateVisibleData();
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 16,
                  height: 16,
                  color: _getColor(data),
                ),
                SizedBox(width: 4),
                Text(data.category),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Color _getColor(_ChartData data) {
    if (data.value == 0) {
      return Colors.grey;
    } else {
      return Colors
          .primaries[visibleData.indexOf(data) % Colors.primaries.length];
    }
  }
}
