import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:frontend/config/exports.dart';
import 'package:frontend/connections/connections.dart';
import 'package:frontend/helpers/navigators.dart';
import 'package:frontend/providers/filters_orders/filters_orders.dart';
import 'package:frontend/ui/logistic/print_guides/controllers/controllers.dart';
import 'package:frontend/ui/logistic/print_guides/model_guide/model_guide.dart';
import 'package:frontend/ui/sellers/order_entry/controllers/controllers.dart';
import 'package:frontend/ui/widgets/filters_orders.dart';
import 'package:frontend/ui/widgets/loading.dart';
import 'package:frontend/ui/widgets/routes/routes.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';
import 'package:frontend/main.dart';
import 'package:screenshot/screenshot.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PrintGuides extends StatefulWidget {
  const PrintGuides({super.key});

  @override
  State<PrintGuides> createState() => _PrintGuidesState();
}

class _PrintGuidesState extends State<PrintGuides> {
  PrintGuidesControllers _controllers = PrintGuidesControllers();
  List data = [];
  List optionsCheckBox = [];
  int counterChecks = 0;
  Uint8List? _imageFile = null;
  bool sort = false;
  List dataTemporal = [];

  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void didChangeDependencies() {
    if (Provider.of<FiltersOrdersProviders>(context).indexActive == 2) {
      setState(() {
        _controllers.searchController.text = "d/m/a,d/m/a";
        data = [];
      });
    } else {
      setState(() {
        data = [];

        _controllers.searchController.clear();
      });
    }
    loadData();
    super.didChangeDependencies();
  }

  loadData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getLoadingModal(context, false);
    });
    var response = [];

    response = await Connections()
        .getOrdersForPrintGuides(_controllers.searchController.text);

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
      body: Container(
        width: double.infinity,
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
                              controller: _controllers.searchController)),
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
              children: [
                Text(
                  counterChecks > 0 ? "Seleccionados: ${counterChecks}" : "",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "Contador: ${data.length}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: DataTable2(
                  headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                  dataTextStyle:
                      TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
                  columnSpacing: 12,
                  horizontalMargin: 12,
                  minWidth: 2500,
                  columns: [
                    DataColumn2(
                      label: Text(''),
                      size: ColumnSize.S,
                    ),
                    DataColumn2(
                      label: Text('Nombre Cliente'),
                      size: ColumnSize.M,
                      onSort: (columnIndex, ascending) {
                        sortFunc("NombreShipping");
                      },
                    ),
                    DataColumn2(
                      label: Text('Fecha'),
                      size: ColumnSize.S,
                      onSort: (columnIndex, ascending) {
                        sortFuncFecha();
                      },
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
                      label: Text('Dirección'),
                      size: ColumnSize.M,
                      onSort: (columnIndex, ascending) {
                        sortFunc("DireccionShipping");
                      },
                    ),
                    DataColumn2(
                      label: Text('Teléfono Cliente'),
                      size: ColumnSize.M,
                      onSort: (columnIndex, ascending) {
                        sortFunc("TelefonoShipping");
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
                      label: Text('Transportadora'),
                      size: ColumnSize.M,
                      onSort: (columnIndex, ascending) {
                        sortFuncTransporte();
                      },
                    ),
                    DataColumn2(
                      label: Text('Status'),
                      size: ColumnSize.M,
                      onSort: (columnIndex, ascending) {
                        sortFunc("Status");
                      },
                    ),
                    DataColumn2(
                      label: Text('Confirmado?'),
                      size: ColumnSize.M,
                      onSort: (columnIndex, ascending) {
                        sortFunc("Estado_Interno");
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
                      label: Text('Observación'),
                      size: ColumnSize.M,
                      onSort: (columnIndex, ascending) {
                        sortFunc("Observacion");
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
                                          "${data[index]['attributes']['users']['data']!=null?data[index]['attributes']['users']['data'][0]['attributes']['vendedores']['data'][0]['attributes']['Nombre_Comercial']:data[index]['attributes']['Tienda_Temporal'].toString()}-${data[index]['attributes']['NumeroOrden']}"
                                              .toString();
                                      optionsCheckBox[index]['date'] =
                                          data[index]['attributes']
                                                      ['pedido_fecha']['data']
                                                  ['attributes']['Fecha']
                                              .toString();
                                      optionsCheckBox[index]['city'] =
                                          data[index]['attributes']
                                                  ['CiudadShipping']
                                              .toString();
                                      optionsCheckBox[index]['product'] =
                                          data[index]['attributes']['ProductoP']
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
                                      optionsCheckBox[index]
                                          ['qrLink'] = data[index]['attributes']
                                                          ['users']['data'][0]
                                                      ['attributes']
                                                  ['vendedores']['data'][0]
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
                                Text(data[index]['attributes']['NombreShipping']
                                    .toString()), onTap: () {
                              getInfoModal(index);
                            }),
                            DataCell(
                                Text(data[index]['attributes']['pedido_fecha']
                                        ['data']['attributes']['Fecha']
                                    .toString()), onTap: () {
                              getInfoModal(index);
                            }),
                            DataCell(Text(
                                "${data[index]['attributes']['Name_Comercial'].toString()}-${data[index]['attributes']['NumeroOrden']}"
                                    .toString())),
                            DataCell(
                                Text(data[index]['attributes']['CiudadShipping']
                                    .toString()), onTap: () {
                              getInfoModal(index);
                            }),
                            DataCell(
                                Text(data[index]['attributes']
                                        ['DireccionShipping']
                                    .toString()), onTap: () {
                              getInfoModal(index);
                            }),
                            DataCell(
                                Text(data[index]['attributes']
                                        ['TelefonoShipping']
                                    .toString()), onTap: () {
                              getInfoModal(index);
                            }),
                            DataCell(
                                Text(data[index]['attributes']['Cantidad_Total']
                                    .toString()), onTap: () {
                              getInfoModal(index);
                            }),
                            DataCell(
                                Text(data[index]['attributes']['ProductoP']
                                    .toString()), onTap: () {
                              getInfoModal(index);
                            }),
                            DataCell(
                                Text(data[index]['attributes']['ProductoExtra']
                                    .toString()), onTap: () {
                              getInfoModal(index);
                            }),
                            DataCell(
                                Text(data[index]['attributes']['PrecioTotal']
                                    .toString()), onTap: () {
                              getInfoModal(index);
                            }),
                            DataCell(
                                Text(
                                    "${data[index]['attributes']['transportadora']['data'] != null ? data[index]['attributes']['transportadora']['data']['attributes']['Nombre'].toString() : ''}"),
                                onTap: () {
                              getInfoModal(index);
                            }),
                            DataCell(
                                Text(data[index]['attributes']['Status']
                                    .toString()), onTap: () {
                              getInfoModal(index);
                            }),
                            DataCell(
                                Text(data[index]['attributes']['Estado_Interno']
                                    .toString()), onTap: () {
                              getInfoModal(index);
                            }),
                            DataCell(
                                Text(data[index]['attributes']
                                        ['Estado_Logistico']
                                    .toString()), onTap: () {
                              getInfoModal(index);
                            }),
                            DataCell(
                                Text(data[index]['attributes']['Observacion']
                                    .toString()), onTap: () {
                              getInfoModal(index);
                            }),
                          ]))),
            ),
          ],
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
                    var response = await Connections()
                        .updateOrderLogisticStatus(
                            "IMPRESO", optionsCheckBox[i]['id'].toString());
                  }
                }
                Navigator.pop(context);
                await Printing.layoutPdf(
                    onLayout: (PdfPageFormat format) async => await doc.save());
                _controllers.searchController.clear();
                setState(() {});

                loadData();
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
                await showDialog(
                    context: context,
                    builder: (context) {
                      return RoutesModal(
                        idOrder: optionsCheckBox,
                        someOrders: true,
                      );
                    });

                setState(() {});
                await loadData();
              },
              child: Text(
                "Asignar Ruta",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
        ],
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
                    objeto['attributes']['Status']
                        .toString()
                        .toLowerCase()
                        .contains(value.toLowerCase()) ||
                    objeto['attributes']['Observacion']
                        .toString()
                        .toLowerCase()
                        .contains(value.toLowerCase()) ||
                    objeto['attributes']['Estado_Logistico']
                        .toString()
                        .toLowerCase()
                        .contains(value.toLowerCase()) ||
                    (objeto['attributes']['transportadora']['data'] != null ? objeto['attributes']['transportadora']['data']['attributes']['Nombre'].toString() : '').toString().toLowerCase().contains(value.toLowerCase()))
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
          suffixIcon: _controllers.searchController.text.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    getLoadingModal(context, false);
                    setState(() {
                      _controllers.searchController.clear();
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

  getInfoModal(index) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              width: 500,
              height: MediaQuery.of(context).size.height,
              child: ListView(
                children: [
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close)),
                      )
                    ],
                  ),
                  _model(
                      "Código: ${data[index]['attributes']['Name_Comercial']}-${data[index]['attributes']['NumeroOrden']}"),
                  _model(
                      "Fecha: ${data[index]['attributes']['pedido_fecha']['data']['attributes']['Fecha'].toString()}"),
                  _model(
                      "Nombre Cliente: ${data[index]['attributes']['NombreShipping']}"),
                  _model(
                      "Teléfono: ${data[index]['attributes']['TelefonoShipping']}"),
                  _model(
                      "Detalle: ${data[index]['attributes']['DireccionShipping']}"),
                  _model(
                      "Cantidad: ${data[index]['attributes']['Cantidad_Total']}"),
                  _model(
                      "Precio Total: ${data[index]['attributes']['PrecioTotal']}"),
                  _model("Producto: ${data[index]['attributes']['ProductoP']}"),
                  _model(
                      "Producto Extra: ${data[index]['attributes']['ProductoExtra']}"),
                  _model(
                      "Ciudad: ${data[index]['attributes']['CiudadShipping']}"),
                  _model("Status: ${data[index]['attributes']['Status']}"),
                  _model(
                      "Comentario: ${data[index]['attributes']['Comentario']}"),
                  _model(
                      "Fecha de Entrega: ${data[index]['attributes']['Fecha_Entrega']}"),
                  _model(
                      "Marca de Tiempo Envio: ${data[index]['attributes']['Marca_Tiempo_Envio']}"),
                  _model(
                      "Estado Logistico: ${data[index]['attributes']['Estado_Devolucion']}"),
                  _model(
                      "Observación: ${data[index]['attributes']['Observacion']}"),
                ],
              ),
            ),
          );
        });
  }

  Padding _model(text) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  sortFuncFecha() {
    if (sort) {
      setState(() {
        sort = false;
      });
      data.sort((a, b) => b['attributes']['pedido_fecha']['data']['attributes']
              ['Fecha']
          .toString()
          .compareTo(a['attributes']['pedido_fecha']['data']['attributes']
                  ['Fecha']
              .toString()));
    } else {
      setState(() {
        sort = true;
      });
      data.sort((a, b) => a['attributes']['pedido_fecha']['data']['attributes']
              ['Fecha']
          .toString()
          .compareTo(b['attributes']['pedido_fecha']['data']['attributes']
                  ['Fecha']
              .toString()));
    }
  }
}
