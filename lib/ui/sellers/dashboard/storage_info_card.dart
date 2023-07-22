import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StorageInfoCard extends StatelessWidget {
  const StorageInfoCard({
    Key? key,
    required this.title,
    required this.svgSrc,
    required this.amountOfFiles,
    required this.numOfFiles,
  }) : super(key: key);

  final String title, svgSrc, amountOfFiles;
  final int numOfFiles;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      padding: EdgeInsets.all(10.0),
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
            child: SvgPicture.asset(svgSrc),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "$numOfFiles Files",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
          Checkbox(
            value: false,
            onChanged: (value) {},
          )
        ],
      ),
    );
  }
}
