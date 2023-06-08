import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:frontend/config/exports.dart';
import 'package:frontend/connections/connections.dart';
import 'package:frontend/helpers/navigators.dart';
import 'package:frontend/ui/logistic/print_guides/model_guide/model_guide.dart';
import 'package:frontend/ui/logistic/printed_guides/controllers/controllers.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:frontend/ui/widgets/loading.dart';
import 'package:frontend/ui/widgets/logistic/scanner_printed.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:screenshot/screenshot.dart';

class PrintedGuides extends StatefulWidget {
  const PrintedGuides({super.key});

  @override
  State<PrintedGuides> createState() => _PrintedGuidesState();
}

class _PrintedGuidesState extends State<PrintedGuides> {
  PrintedGuidesControllers _controllers = PrintedGuidesControllers();
  ScreenshotController screenshotController = ScreenshotController();

  String? _barcode;
  late bool visible;
  List optionsCheckBox = [];
  List data = [];
  bool sort = false;
  List dataTemporal = [];

  int counterChecks = 0;
  void didChangeDependencies() {
    loadData();
    super.didChangeDependencies();
  }

  loadData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getLoadingModal(context, false);
    });
    var response = [];
    setState(() {
      data = [];
    });
    response =
        await Connections().getOrdersForPrintedGuides(_controllers.search.text);

    data = response;
    dataTemporal = response;

    setState(() {
      optionsCheckBox = [];
      counterChecks = 0;
    });
    for (var i = 0; i < data.length; i++) {
      optionsCheckBox.add({
        "check": false,
        "id": "",
        "numPedido": "",
        "date": "",
        "city": "",
        "product": "",
        "extraProduct": "",
        "quantity": "",
        "phone": "",
        "price": "",
        "name": "",
        "transport": "",
        "address": "",
        "obervation": "",
        "qrLink": "",
      });
    }
    Future.delayed(Duration(milliseconds: 500), () {
      Navigator.pop(context);
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                        child: counterChecks != 0
                            ? _buttons()
                            : _modelTextField(
                                text: "Busqueda",
                                controller: _controllers.search)),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Contador: ${data.length}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                        onPressed: () async {
                          await showDialog(
                              context: context,
                              builder: (context) {
                                return ScannerPrinted();
                              });
                          await loadData();
                        },
                        child: Text(
                          "SCANNER",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: DataTable2(
                    headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                    dataTextStyle:TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
                    columnSpacing: 12,
                    horizontalMargin: 12,
                    
                    minWidth: 2500,
                    
                    columns: [
                      DataColumn2(
                        label: Text(''),
                        size: ColumnSize.S,
                      ),
                      DataColumn2(
                        label: Text('Código'),
                        size: ColumnSize.M,
                        onSort: (columnIndex, ascending) {
                          sortFunc("NumeroOrden");
                        },
                      ),
                      DataColumn2(
                        label: Text('Ciudad'),
                        size: ColumnSize.M,
                        onSort: (columnIndex, ascending) {
                          sortFunc("CiudadShipping");
                        },
                      ),
                      DataColumn2(
                        label: Text('Nombre Cliente'),
                        size: ColumnSize.M,
                        onSort: (columnIndex, ascending) {
                          sortFunc("NombreShipping");
                        },
                      ),
                      DataColumn2(
                        label: Text('Dirección'),
                        size: ColumnSize.M,
                        onSort: (columnIndex, ascending) {
                          sortFunc("DireccionShipping");
                        },
                      ),
                      DataColumn2(
                        label: Text('Cantidad'),
                        size: ColumnSize.M,
                        onSort: (columnIndex, ascending) {
                          sortFunc("Cantidad_Total");
                        },
                      ),
                      DataColumn2(
                        label: Text('Producto'),
                        size: ColumnSize.M,
                        onSort: (columnIndex, ascending) {
                          sortFunc("ProductoP");
                        },
                      ),
                      DataColumn2(
                        label: Text('Producto Extra'),
                        size: ColumnSize.M,
                        onSort: (columnIndex, ascending) {
                          sortFunc("ProductoExtra");
                        },
                      ),
                      DataColumn2(
                        label: Text('Precio Total'),
                        size: ColumnSize.M,
                        onSort: (columnIndex, ascending) {
                          sortFunc("PrecioTotal");
                        },
                      ),
                      DataColumn2(
                        label: Text('Estado'),
                        size: ColumnSize.M,
                        onSort: (columnIndex, ascending) {
                          sortFunc("Status");
                        },
                      ),
                      DataColumn2(
                        label: Text('Estado Logistico'),
                        size: ColumnSize.M,
                        onSort: (columnIndex, ascending) {
                          sortFunc("Estado_Logistico");
                        },
                      ),
                      DataColumn2(
                        label: Text('Transportadora'),
                        size: ColumnSize.M,
                        onSort: (columnIndex, ascending) {
                          sortFuncTransporte();
                        },
                      ),
                    ],
                    rows: List<DataRow>.generate(
                        data.length,
                        (index) => DataRow(cells: [
                              DataCell(Checkbox(
                                  value: optionsCheckBox[index]['check'],
                                  onChanged: (value) {
                                    setState(() {
                                      if (value!) {
                                        optionsCheckBox[index]['check'] = value;
                                        optionsCheckBox[index]['id'] =
                                            data[index]['id'].toString();
                                        optionsCheckBox[index]['numPedido'] =
                                            "${data[index]['attributes']['Tienda_Temporal'].toString()}-${data[index]['attributes']['NumeroOrden']}"
                                                .toString();
                                        optionsCheckBox[index]
                                            ['date'] = data[index]['attributes']
                                                    ['pedido_fecha']['data']
                                                ['attributes']['Fecha']
                                            .toString();
                                        optionsCheckBox[index]['city'] =
                                            data[index]['attributes']
                                                    ['CiudadShipping']
                                                .toString();
                                        optionsCheckBox[index]['product'] =
                                            data[index]['attributes']
                                                    ['ProductoP']
                                                .toString();
                                        optionsCheckBox[index]['extraProduct'] =
                                            data[index]['attributes']
                                                    ['ProductoExtra']
                                                .toString();
                                        optionsCheckBox[index]['quantity'] =
                                            data[index]['attributes']
                                                    ['Cantidad_Total']
                                                .toString();
                                        optionsCheckBox[index]['phone'] =
                                            data[index]['attributes']
                                                    ['TelefonoShipping']
                                                .toString();
                                        optionsCheckBox[index]['price'] =
                                            data[index]['attributes']
                                                    ['PrecioTotal']
                                                .toString();
                                        optionsCheckBox[index]['name'] =
                                            data[index]['attributes']
                                                    ['NombreShipping']
                                                .toString();
                                        optionsCheckBox[index]['transport'] =
                                            "${data[index]['attributes']['transportadora']['data'] != null ? data[index]['attributes']['transportadora']['data']['attributes']['Nombre'].toString() : ''}";
                                        optionsCheckBox[index]['address'] =
                                            data[index]['attributes']
                                                    ['DireccionShipping']
                                                .toString();
                                        optionsCheckBox[index]['obervation'] =
                                            data[index]['attributes']
                                                    ['Observacion']
                                                .toString();
                                        optionsCheckBox[index]['qrLink'] =
                                            data[index]['attributes']['users']
                                                                    ['data'][0]
                                                                ['attributes']
                                                            ['vendedores']
                                                        ['data'][0]
                                                    ['attributes']['Url_Tienda']
                                                .toString();

                                        counterChecks += 1;
                                      } else {
                                        optionsCheckBox[index]['check'] = value;
                                        optionsCheckBox[index]['id'] = '';
                                        counterChecks -= 1;
                                      }
                                    });
                                  })),
                              DataCell(
                                  Text(
                                      "${data[index]['attributes']['Name_Comercial'].toString()}-${data[index]['attributes']['NumeroOrden']}"
                                          .toString()), onTap: () {
                                Navigators().pushNamed(context,
                                    '/layout/logistic/print/info?id=${data[index]['id']}');
                              }),
                              DataCell(Text(data[index]['attributes']
                                      ['CiudadShipping']
                                  .toString())),
                              DataCell(Text(data[index]['attributes']
                                      ['NombreShipping']
                                  .toString())),
                              DataCell(Text(data[index]['attributes']
                                      ['DireccionShipping']
                                  .toString())),
                              DataCell(Text(data[index]['attributes']
                                      ['Cantidad_Total']
                                  .toString())),
                              DataCell(Text(data[index]['attributes']
                                      ['ProductoP']
                                  .toString())),
                              DataCell(Text(data[index]['attributes']
                                      ['ProductoExtra']
                                  .toString())),
                              DataCell(Text(data[index]['attributes']
                                      ['PrecioTotal']
                                  .toString())),
                              DataCell(Text(data[index]['attributes']
                                      ['Estado_Interno']
                                  .toString())),
                              DataCell(Text(data[index]['attributes']
                                      ['Estado_Logistico']
                                  .toString())),
                              DataCell(Text(
                                  "${data[index]['attributes']['transportadora']['data'] != null ? data[index]['attributes']['transportadora']['data']['attributes']['Nombre'].toString() : ''}")),
                            ]))),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _modelTextField({text, controller}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Color.fromARGB(255, 245, 244, 244),
      ),
      child: TextField(
        controller: controller,
        onSubmitted: (value) {
          getLoadingModal(context, false);

          setState(() {
            data = dataTemporal;
          });
          if (value.isEmpty) {
            setState(() {
              data = dataTemporal;
            });
          } else {
            var dataTemp = data
                .where((objeto) =>
                    objeto['attributes']['NumeroOrden'].toString().toLowerCase().contains(value.toLowerCase()) ||
                    objeto['attributes']['CiudadShipping']
                        .toString()
                        .toLowerCase()
                        .contains(value.toLowerCase()) ||
                    objeto['attributes']['NombreShipping']
                        .toString()
                        .toLowerCase()
                        .contains(value.toLowerCase()) ||
                    objeto['attributes']['DireccionShipping']
                        .toString()
                        .toLowerCase()
                        .contains(value.toLowerCase()) ||
                    objeto['attributes']['Cantidad_Total']
                        .toString()
                        .toLowerCase()
                        .contains(value.toLowerCase()) ||
                    objeto['attributes']['ProductoP']
                        .toString()
                        .toLowerCase()
                        .contains(value.toLowerCase()) ||
                    objeto['attributes']['ProductoExtra']
                        .toString()
                        .toLowerCase()
                        .contains(value.toLowerCase()) ||
                    objeto['attributes']['PrecioTotal']
                        .toString()
                        .toLowerCase()
                        .contains(value.toLowerCase()) ||
                    objeto['attributes']['Estado_Interno']
                        .toString()
                        .toLowerCase()
                        .contains(value.toLowerCase()) ||
                    objeto['attributes']['Estado_Logistico']
                        .toString()
                        .toLowerCase()
                        .contains(value.toLowerCase()) ||
                    (objeto['attributes']['transportadora']['data'] != null
                            ? objeto['attributes']['transportadora']['data']['attributes']['Nombre'].toString()
                            : '')
                        .toString()
                        .toLowerCase()
                        .contains(value.toLowerCase()))
                .toList();
            setState(() {
              data = dataTemp;
            });
          }
          Navigator.pop(context);

          // loadData();
        },
        onChanged: (value) {},
        style: TextStyle(fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search),
          suffixIcon: _controllers.search.text.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    getLoadingModal(context, false);
                    setState(() {
                      _controllers.search.clear();
                    });
                    setState(() {
                      data = dataTemporal;
                    });
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.close))
              : null,
          hintText: text,
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(width: 1, color: Color.fromRGBO(237, 241, 245, 1.0)),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(width: 1, color: Color.fromRGBO(237, 241, 245, 1.0)),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusColor: Colors.black,
          iconColor: Colors.black,
        ),
      ),
    );
  }

  Container _buttons() {
    return Container(
      margin: EdgeInsets.all(5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () async {
                getLoadingModal(context, false);
                final doc = pw.Document();

                for (var i = 0; i < optionsCheckBox.length; i++) {
                  if (optionsCheckBox[i]['id'].toString().isNotEmpty &&
                      optionsCheckBox[i]['id'].toString() != '' &&
                      optionsCheckBox[i]['check'] == true) {
                    final capturedImage =
                        await screenshotController.captureFromWidget(Container(
                            child: ModelGuide(
                      address: optionsCheckBox[i]['address'],
                      city: optionsCheckBox[i]['city'],
                      date: optionsCheckBox[i]['date'],
                      extraProduct: optionsCheckBox[i]['extraProduct'],
                      idForBarcode: optionsCheckBox[i]['id'],
                      name: optionsCheckBox[i]['name'],
                      numPedido: optionsCheckBox[i]['numPedido'],
                      observation: optionsCheckBox[i]['obervation'],
                      phone: optionsCheckBox[i]['phone'],
                      price: optionsCheckBox[i]['price'],
                      product: optionsCheckBox[i]['product'],
                      qrLink: optionsCheckBox[i]['qrLink'],
                      quantity: optionsCheckBox[i]['quantity'],
                      transport: optionsCheckBox[i]['transport'],
                    )));

                        doc.addPage(pw.Page(
                        pageFormat: PdfPageFormat.a4,
                        orientation: pw.PageOrientation.portrait,
                        build: (pw.Context context) {
                          return pw.Column(
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              children: [
                                pw.Container(
                                  width: double.infinity,
                                  child: pw.Image(pw.MemoryImage(capturedImage),
                                      fit: pw.BoxFit.contain),
                                  height: 1200,
                                ),
                                pw.Container(
                                  width: double.infinity,
                                  child: pw.Image(pw.MemoryImage(capturedImage),
                                      fit: pw.BoxFit.contain),
                                  height: 1200,
                                )
                              ]); // Center
                        }));
                  }
                }
                Navigator.pop(context);
                await Printing.layoutPdf(
                    onLayout: (PdfPageFormat format) async => await doc.save());
                setState(() {});
              },
              child: Text(
                "IMPRIMIR",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          SizedBox(
            width: 20,
          ),
          ElevatedButton(
              onPressed: () async {
                getLoadingModal(context, false);

                for (var i = 0; i < optionsCheckBox.length; i++) {
                  if (optionsCheckBox[i]['id'].toString().isNotEmpty &&
                      optionsCheckBox[i]['id'].toString() != '' &&
                      optionsCheckBox[i]['check'] == true) {
                    var response = await Connections()
                        .updateOrderInteralStatusLogistic(
                            "NO DESEA", optionsCheckBox[i]['id'].toString());
                  }
                }
                Navigator.pop(context);

                setState(() {});

                await loadData();
              },
              child: Text(
                "NO DESEA",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          SizedBox(
            width: 20,
          ),
          ElevatedButton(
              onPressed: () async {
                getLoadingModal(context, false);

                for (var i = 0; i < optionsCheckBox.length; i++) {
                  if (optionsCheckBox[i]['id'].toString().isNotEmpty &&
                      optionsCheckBox[i]['id'].toString() != '' &&
                      optionsCheckBox[i]['check'] == true) {
                    var response = await Connections()
                        .updateOrderLogisticStatusPrint(
                            "ENVIADO", optionsCheckBox[i]['id'].toString());
                  }
                }
                Navigator.pop(context);

                setState(() {});

                await loadData();
              },
              child: Text(
                "MARCAR ENVIADO",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
        ],
      ),
    );
  }

  sortFunc(name) {
    if (sort) {
      setState(() {
        sort = false;
      });
      data.sort((a, b) => b['attributes'][name]
          .toString()
          .compareTo(a['attributes'][name].toString()));
    } else {
      setState(() {
        sort = true;
      });
      data.sort((a, b) => a['attributes'][name]
          .toString()
          .compareTo(b['attributes'][name].toString()));
    }
  }

  sortFuncTransporte() {
    if (sort) {
      setState(() {
        sort = false;
      });
      data.sort((a, b) => b['attributes']['transportadora']['data']
              ['attributes']['Nombre']
          .toString()
          .compareTo(a['attributes']['transportadora']['data']['attributes']
                  ['Nombre']
              .toString()));
    } else {
      setState(() {
        sort = true;
      });
      data.sort((a, b) => a['attributes']['transportadora']['data']
              ['attributes']['Nombre']
          .toString()
          .compareTo(b['attributes']['transportadora']['data']['attributes']
                  ['Nombre']
              .toString()));
    }
  }
}
