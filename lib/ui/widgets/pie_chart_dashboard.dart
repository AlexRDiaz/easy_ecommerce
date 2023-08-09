import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:frontend/ui/sellers/dashboard/filter_details.dart';

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
  double totalValue = 0;

  @override
  void initState() {
    super.initState();
    updateVisibleData();
    setState(() {});
  }

  void updateVisibleData() {
    double totalTemp = 0;
    for (var filter in widget.filters) {
      if (filter.numOfFiles != null) {
        totalTemp += int.parse(filter.numOfFiles!.toString());
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
            annotations: <CircularChartAnnotation>[
              CircularChartAnnotation(
                widget: Container(
                  child: Text('Total : ' + _calculateTotal().toString(),
                      style: TextStyle(
                          color: Color.fromRGBO(216, 225, 227, 1),
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                ),
              )
            ],
            series: <CircularSeries>[
              PieSeries<FilterCheckModel, String>(
                dataSource: widget.filters,
                dataLabelMapper: (FilterCheckModel datum, _) {
                  double percentage =
                      (datum.numOfFiles!.toDouble() / _calculateTotal()) * 100;
                  return '${percentage.toStringAsFixed(2)}%';
                },
                xValueMapper: (FilterCheckModel datum, _) => datum.title,
                yValueMapper: (FilterCheckModel datum, _) => datum.numOfFiles,
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

  _calculatePercentage(int numeroReg) {
    double porcentaje = (numeroReg / _calculateTotal()) * 100;
    return porcentaje;
  }

  _calculateTotal() {
    int total = 0;
    for (var filter in widget.filters) {
      total += filter.numOfFiles!.toInt();
    }
    return total;
  }

  Widget _buildLegend() {
    return Wrap(
      children: widget.filters.map((filter) {
        return InkWell(
          onTap: () {
            setState(() {
              filter.numOfFiles = filter.numOfFiles == 0 ? 10 : 0;
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
                  color: _getColor(filter),
                ),
                SizedBox(width: 4),
                Text(filter.title!),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Color _getColor(FilterCheckModel filter) {
    if (filter.numOfFiles == 0) {
      return Colors.grey;
    } else {
      int index = widget.filters.indexOf(filter) % Colors.primaries.length;
      return Colors.primaries[index];
    }
  }
}
