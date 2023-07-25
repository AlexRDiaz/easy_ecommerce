import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FilterInfoCard extends StatefulWidget {
  final String title, filter, svgSrc;
  final int numOfFiles;
  final double percentage;
  final Function(dynamic) function;

  const FilterInfoCard(
      {Key? key,
      required this.title,
      required this.filter,
      required this.svgSrc,
      required this.percentage,
      required this.numOfFiles,
      required this.function})
      : super(key: key);

  @override
  State<FilterInfoCard> createState() => _FilterInfoCardState();
}

class _FilterInfoCardState extends State<FilterInfoCard> {
  bool checked = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 6.0),
      padding: EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        border:
            Border.all(width: 2, color: Color(0xFF2697FF).withOpacity(0.15)),
        borderRadius: const BorderRadius.all(
          Radius.circular(16.0),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 15,
            width: 15,
            child: SvgPicture.asset(widget.svgSrc),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "${widget.numOfFiles} Files",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
          Checkbox(
            value: checked,
            onChanged: (value) {
              setState(() {
                checked = value!;
              });
              widget.function({"value": checked, "filter": widget.filter});
            },
          )
        ],
      ),
    );
  }
}
