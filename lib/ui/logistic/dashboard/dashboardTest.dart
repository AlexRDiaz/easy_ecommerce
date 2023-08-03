import 'package:flutter/material.dart';
import 'package:frontend/ui/logistic/dashboard/body_content_widget.dart';
import 'package:frontend/ui/logistic/dashboard/right_side_wdiget.dart';
import 'package:frontend/ui/logistic/dashboard/web_vertical_nav_widget.dart';

class DashBoardLogistic extends StatefulWidget {
  @override
  State<DashBoardLogistic> createState() => _DashBoardLogisticState();
}

class _DashBoardLogisticState extends State<DashBoardLogistic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Row(
            children: [
              WebVerticalNavWidget(),
              BodyContentWidget(),
            ],
          ),
          Positioned(
            child: RightSideWidget(),
            bottom: 0.0,
            top: 0.0,
            right: 0.0,
          )
        ],
      ),
    );
  }
}
