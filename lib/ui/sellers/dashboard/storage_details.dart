import 'package:flutter/material.dart';
import 'package:frontend/ui/sellers/dashboard/MyFiles.dart';
import 'package:frontend/ui/sellers/dashboard/my_fields.dart';
import 'package:frontend/ui/sellers/dashboard/storage_info_card.dart';

import 'chart.dart';

class StorageDetails extends StatelessWidget {
  const StorageDetails({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF1A2B3C),
      ),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 5),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: Colors.black),
            ),
            height: 700,
            width: 600,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Estados de entrega",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 16.0),
                        StorageInfoCard(
                          svgSrc: "assets/icons/Documents.svg",
                          title: "ENTREGADO",
                          amountOfFiles: "1.3GB",
                          numOfFiles: 1328,
                        ),
                        StorageInfoCard(
                          svgSrc: "assets/icons/media.svg",
                          title: "NO ENTREGADO",
                          amountOfFiles: "15.3GB",
                          numOfFiles: 1328,
                        ),
                        StorageInfoCard(
                          svgSrc: "assets/icons/folder.svg",
                          title: "NOVEDAD",
                          amountOfFiles: "1.3GB",
                          numOfFiles: 1328,
                        ),
                        StorageInfoCard(
                          svgSrc: "assets/icons/unknown.svg",
                          title: "REAGENDADO",
                          amountOfFiles: "1.3GB",
                          numOfFiles: 140,
                        ),
                        StorageInfoCard(
                          svgSrc: "assets/icons/folder.svg",
                          title: "NOVEDAD",
                          amountOfFiles: "1.3GB",
                          numOfFiles: 1328,
                        ),
                        StorageInfoCard(
                          svgSrc: "assets/icons/folder.svg",
                          title: "EN RUTA",
                          amountOfFiles: "1.3GB",
                          numOfFiles: 1328,
                        ),
                        StorageInfoCard(
                          svgSrc: "assets/icons/folder.svg",
                          title: "EN OFICINA",
                          amountOfFiles: "1.3GB",
                          numOfFiles: 1328,
                        ),
                        StorageInfoCard(
                          svgSrc: "assets/icons/folder.svg",
                          title: "PROGRAMADO",
                          amountOfFiles: "1.3GB",
                          numOfFiles: 1328,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Chart(),
                )
              ],
            ),
          ),
          Container(
            height: 700,
            width: 600,
            margin: EdgeInsets.only(left: 5, top: 10, bottom: 10, right: 10),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: Colors.black),
            ),
            child: Container(
              margin: EdgeInsets.all(20),
              child: MyFiles(),
            ),
          ),
        ],
      ),
    );
  }
}
