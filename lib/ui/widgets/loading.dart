import 'package:flutter/material.dart';

getLoadingModal(context, barrier) {
  return showDialog(
      barrierDismissible: barrier,
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ),
              )
            ],
          ),
        );
      });
}
