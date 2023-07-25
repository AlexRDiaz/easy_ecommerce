import 'package:flutter/material.dart';
import 'package:frontend/ui/sellers/dashboard/MyFiles.dart';
import 'package:frontend/ui/sellers/dashboard/my_fields.dart';
import 'package:frontend/ui/sellers/dashboard/storage_info_card.dart';

import 'chart.dart';

class FilterDetails extends StatefulWidget {
  final List<FilterCheckModel> filters;
  final Function() function;
  const FilterDetails({Key? key, required this.filters, required this.function})
      : super(key: key);

  @override
  State<FilterDetails> createState() => _FilterDetailsState();
}

class _FilterDetailsState extends State<FilterDetails> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Calculo de valores',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: MyFiles(),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class FilterCheckModel {
  final String? svgSrc, title, filter;
  int? numOfFiles;
  final double? percentage;
  final Color? color;
  late final bool? check;

  FilterCheckModel(
      {this.svgSrc,
      this.title,
      this.filter,
      this.numOfFiles,
      this.percentage,
      this.color,
      this.check});
}
