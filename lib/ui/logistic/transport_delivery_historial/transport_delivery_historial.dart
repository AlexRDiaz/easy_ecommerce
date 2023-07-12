import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:frontend/config/exports.dart';
import 'package:frontend/connections/connections.dart';
import 'package:frontend/main.dart';
import 'package:frontend/ui/logistic/print_guides/model_guide/model_guide.dart';
import 'package:frontend/ui/logistic/transport_delivery_historial/transport_delivery_details.dart';
import 'package:frontend/ui/logistic/vendor_invoices/controllers/controllers.dart';
import 'package:frontend/ui/utils/utils.dart';
import 'package:frontend/ui/widgets/amount_row.dart';
import 'package:frontend/ui/widgets/routes/routes.dart';
import 'package:frontend/ui/widgets/routes/sub_routes_historial.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../helpers/navigators.dart';
import '../../widgets/loading.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:screenshot/screenshot.dart';

class TransportDeliveryHistorial extends StatefulWidget {
  const TransportDeliveryHistorial({super.key});

  @override
  State<TransportDeliveryHistorial> createState() =>
      _TransportDeliveryHistorialState();
}

class _TransportDeliveryHistorialState
    extends State<TransportDeliveryHistorial> {
  TextEditingController _search = TextEditingController();
  List data = [];
  bool sort = false;
  ScreenshotController screenshotController = ScreenshotController();

  List<DateTime?> _datesDesde = [];
  List<DateTime?> _datesHasta = [];
  bool search = false;
  String option = "";
  String url = "";
  int counterChecks = 0;
  List optionsCheckBox = [];

  List bools = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  List titlesFilters = [
    "Fecha",
    "Código",
    "Ciudad",
    "Nombre Cliente",
    "Dirección",
    "Teléfono Cliente",
    "Cantidad",
    "Producto",
    "Producto Extra",
    "Precio Total",
    "Observación",
    "Comentario",
    "Status",
    "Fecha Entrega",
    "Est. Devolución",
    "Vendedor",
    "Transportadora",
    "Operador",
    "Estado Pago",
    "Est. logistic",
    "Est. Confir",
    "Ruta",
    "SubRuta"
  ];
  @override
  void didChangeDependencies() {
    loadData();
    super.didChangeDependencies();
  }

  loadData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getLoadingModal(context, false);
    });
    setState(() {
      data = [];
    });

    if (_controllers.searchController.text.isEmpty) {
      setState(() {
        search = false;
      });
      var response =
          await Connections().getOrdersForHistorialTransportByDates();
      setState(() {
        data = response;
      });
    } else {
      setState(() {
        search = true;
      });
      var response = await Connections()
          .getOrdersForHistorialTransportByCode(_search.text, url);

      setState(() {
        data = response;
      });
    }
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

    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.pop(context);
    });
    setState(() {});
  }

  final VendorInvoicesControllers _controllers = VendorInvoicesControllers();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            counterChecks != 0
                ? _buttons()
                : SizedBox(
                    width: double.infinity,
                    child: _modelTextField(
                        text: "Busqueda",
                        controller: _controllers.searchController),
                  ),
            counterChecks != 0 ? Container() : _filters(context),
            SizedBox(
              height: 10,
            ),
            Text(
              "BUSQUEDA POR RANGO DE FECHA",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            _dates(context),
            Expanded(
                child: DataTable2(
                    headingTextStyle: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                    dataTextStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    columnSpacing: 12,
                    horizontalMargin: 6,
                    minWidth: 5000,
                    showCheckboxColumn: false,
                    columns: [
                      DataColumn2(
                        label: Text(''),
                        size: ColumnSize.S,
                      ),
                      DataColumn2(
                        label: Text('Marca de Tiempo'),
                        size: ColumnSize.M,
                        onSort: (columnIndex, ascending) {
                          sortFunc("Marca_T_I");
                        },
                      ),
                      DataColumn2(
                        label: Text('Fecha'),
                        size: ColumnSize.M,
                        onSort: (columnIndex, ascending) {
                          sortFunc("Fecha");
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
                        size: ColumnSize.L,
                        onSort: (columnIndex, ascending) {
                          sortFunc("CiudadShipping");
                        },
                      ),
                      DataColumn2(
                        label: Text('Nombre Cliente'),
                        size: ColumnSize.M,
                        numeric: true,
                        onSort: (columnIndex, ascending) {
                          sortFunc("NombreShipping");
                        },
                      ),
                      DataColumn2(
                        label: Text('Dirección'),
                        size: ColumnSize.M,
                        numeric: true,
                        onSort: (columnIndex, ascending) {
                          sortFunc("DireccionShipping");
                        },
                      ),
                      DataColumn2(
                        label: Text('Teléfono Cliente'),
                        size: ColumnSize.M,
                        numeric: true,
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
                        numeric: true,
                        size: ColumnSize.M,
                        onSort: (columnIndex, ascending) {
                          sortFunc("ProductoP");
                        },
                      ),
                      DataColumn2(
                        label: Text('Producto Extra'),
                        size: ColumnSize.M,
                        numeric: true,
                        onSort: (columnIndex, ascending) {
                          sortFunc("ProductoExtra");
                        },
                      ),
                      DataColumn2(
                        label: Text('Precio Total'),
                        size: ColumnSize.L,
                        onSort: (columnIndex, ascending) {
                          sortFunc("PrecioTotal");
                        },
                      ),
                      DataColumn2(
                        label: Text('Observación'),
                        size: ColumnSize.M,
                        numeric: true,
                        onSort: (columnIndex, ascending) {
                          sortFunc("Observacion");
                        },
                      ),
                      DataColumn2(
                        label: Text('Comentario'),
                        size: ColumnSize.L,
                        onSort: (columnIndex, ascending) {
                          sortFunc("Comentario");
                        },
                      ),
                      DataColumn2(
                        label: Text('Estado de Entrega'),
                        size: ColumnSize.M,
                        numeric: true,
                        onSort: (columnIndex, ascending) {
                          sortFunc("Status");
                        },
                      ),
                      DataColumn2(
                        label: Text('Tipo de Pago'),
                        size: ColumnSize.M,
                        onSort: (columnIndex, ascending) {
                          sortFunc("TipoPago");
                        },
                      ),
                      DataColumn2(
                        label: Text('Ruta Asignada'),
                        size: ColumnSize.S,
                        onSort: (columnIndex, ascending) {
                          sortFunc("DireccionShipping");
                        },
                      ),
                      DataColumn2(
                        label: Text('Transportadora'),
                        size: ColumnSize.S,
                        onSort: (columnIndex, ascending) {
                          sortFunc("DireccionShipping");
                        },
                      ),
                      DataColumn2(
                        label: Text('Sub Ruta'),
                        size: ColumnSize.S,
                        onSort: (columnIndex, ascending) {
                          sortFunc("DireccionShipping");
                        },
                      ),
                      DataColumn2(
                        label: Text('Operador'),
                        size: ColumnSize.M,
                        onSort: (columnIndex, ascending) {
                          sortFunc("DireccionShipping");
                        },
                      ),
                      DataColumn2(
                        label: Text('Fecha Entrega'),
                        size: ColumnSize.M,
                        onSort: (columnIndex, ascending) {
                          sortFunc("Fecha_Entrega");
                        },
                      ),
                      DataColumn2(
                        label: Text('Vendedor'),
                        size: ColumnSize.M,
                        numeric: true,
                        onSort: (columnIndex, ascending) {
                          sortFunc("Name_Comercial");
                        },
                      ),
                      DataColumn2(
                        label: Text('Estado Confirmacion'),
                        size: ColumnSize.M,
                        numeric: true,
                        onSort: (columnIndex, ascending) {
                          sortFunc("Estado_Interno");
                        },
                      ),
                      DataColumn2(
                        label: Text('Estado Logistico'),
                        size: ColumnSize.M,
                        numeric: true,
                        onSort: (columnIndex, ascending) {
                          sortFunc("Estado_Logistico");
                        },
                      ),
                      DataColumn2(
                        label: Text('Costo Trans'),
                        size: ColumnSize.M,
                        numeric: true,
                        onSort: (columnIndex, ascending) {
                          sortFunc("DireccionShipping");
                        },
                      ),
                      DataColumn2(
                        label: Text('Costo Operador'),
                        size: ColumnSize.M,
                        numeric: true,
                        onSort: (columnIndex, ascending) {
                          sortFunc("DireccionShipping");
                        },
                      ),
                      DataColumn2(
                        label: Text('Costo Entrega'),
                        size: ColumnSize.M,
                        numeric: true,
                        onSort: (columnIndex, ascending) {
                          sortFunc("DireccionShipping");
                        },
                      ),
                      DataColumn2(
                        label: Text('Costo Devolucion'),
                        size: ColumnSize.M,
                        numeric: true,
                        onSort: (columnIndex, ascending) {
                          sortFunc("DireccionShipping");
                        },
                      ),
                      DataColumn2(
                        label: Text('Estado Devolución'),
                        size: ColumnSize.M,
                        numeric: true,
                        onSort: (columnIndex, ascending) {
                          sortFunc("Estado_Devolucion");
                        },
                      ),
                      DataColumn2(
                        label: Text('Marca Tiempo Devolucion '),
                        size: ColumnSize.M,
                        numeric: true,
                        onSort: (columnIndex, ascending) {
                          sortFunc("Marca_T_D");
                        },
                      ),
                      DataColumn2(
                        label: Text('Est. Pago Logistico'),
                        size: ColumnSize.M,
                        numeric: true,
                        onSort: (columnIndex, ascending) {
                          sortFunc("Estado_Pagado");
                        },
                      ),
                    ],
                    rows: List<DataRow>.generate(data.length, (index) {
                      Color rowColor = Colors.black;

                      return DataRow(cells: getRows(index));
                    }))),
          ],
        ),
      ),
    );
  }

  _buttons() {
    return Wrap(
      runSpacing: 10.0,
      spacing: 10.0,
      children: [
        ElevatedButton(
            onPressed: () async {
              showDialog(
                  context: (context),
                  builder: (context) {
                    return AlertDialog(
                      content: Container(
                        width: 500,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Icon(Icons.close)),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return RoutesModal(
                                            idOrder: optionsCheckBox,
                                            someOrders: true,
                                            phoneClient: "",
                                            codigo: "");
                                      });

                                  setState(() {});
                                  await loadData();
                                },
                                child: Text(
                                  "Asignar Ruta",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return SubRoutesModalHistorial(
                                          idOrder: optionsCheckBox,
                                          someOrders: true,
                                        );
                                      });

                                  setState(() {});
                                  await loadData();
                                },
                                child: Text(
                                  "Asignar SubRuta y Operador",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  getLoadingModal(context, false);

                                  for (var i = 0;
                                      i < optionsCheckBox.length;
                                      i++) {
                                    if (optionsCheckBox[i]['id']
                                            .toString()
                                            .isNotEmpty &&
                                        optionsCheckBox[i]['id'].toString() !=
                                            '' &&
                                        optionsCheckBox[i]['check'] == true) {
                                      var response = await Connections()
                                          .updateOrderLogisticStatus(
                                              "IMPRESO",
                                              optionsCheckBox[i]['id']
                                                  .toString());
                                    }
                                  }

                                  Navigator.pop(context);
                                  await loadData();
                                },
                                child: Text(
                                  "IMPRESO",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  getLoadingModal(context, false);

                                  for (var i = 0;
                                      i < optionsCheckBox.length;
                                      i++) {
                                    if (optionsCheckBox[i]['id']
                                            .toString()
                                            .isNotEmpty &&
                                        optionsCheckBox[i]['id'].toString() !=
                                            '' &&
                                        optionsCheckBox[i]['check'] == true) {
                                      var response = await Connections()
                                          .updateOrderLogisticStatusPrint(
                                              "ENVIADO",
                                              optionsCheckBox[i]['id']
                                                  .toString());
                                    }
                                  }

                                  Navigator.pop(context);
                                  await loadData();
                                },
                                child: Text(
                                  "ENVIADO",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  const double point = 1.0;
                                  const double inch = 72.0;
                                  const double cm = inch / 2.54;
                                  const double mm = inch / 25.4;
                                  getLoadingModal(context, false);
                                  final doc = pw.Document();

                                  for (var i = 0;
                                      i < optionsCheckBox.length;
                                      i++) {
                                    if (optionsCheckBox[i]['id']
                                            .toString()
                                            .isNotEmpty &&
                                        optionsCheckBox[i]['id'].toString() !=
                                            '' &&
                                        optionsCheckBox[i]['check'] == true) {
                                      final capturedImage =
                                          await screenshotController
                                              .captureFromWidget(Container(
                                                  child: ModelGuide(
                                        address: optionsCheckBox[i]['address'],
                                        city: optionsCheckBox[i]['city'],
                                        date: optionsCheckBox[i]['date'],
                                        extraProduct: optionsCheckBox[i]
                                            ['extraProduct'],
                                        idForBarcode: optionsCheckBox[i]['id'],
                                        name: optionsCheckBox[i]['name'],
                                        numPedido: optionsCheckBox[i]
                                            ['numPedido'],
                                        observation: optionsCheckBox[i]
                                            ['obervation'],
                                        phone: optionsCheckBox[i]['phone'],
                                        price: optionsCheckBox[i]['price'],
                                        product: optionsCheckBox[i]['product'],
                                        qrLink: optionsCheckBox[i]['qrLink'],
                                        quantity: optionsCheckBox[i]
                                            ['quantity'],
                                        transport: optionsCheckBox[i]
                                            ['transport'],
                                      )));
                                      doc.addPage(pw.Page(
                                        pageFormat: PdfPageFormat(
                                            21.0 * cm, 21.0 * cm,
                                            marginAll: 0.1 * cm),
                                        build: (pw.Context context) {
                                          return pw.Row(
                                            children: [
                                              pw.Image(
                                                  pw.MemoryImage(capturedImage),
                                                  fit: pw.BoxFit.contain)
                                            ],
                                          );
                                        },
                                      ));
                                    }
                                  }
                                  Navigator.pop(context);
                                  await Printing.layoutPdf(
                                      onLayout: (PdfPageFormat format) async =>
                                          await doc.save());
                                },
                                child: Text(
                                  "Imprimir",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                          ],
                        ),
                      ),
                    );
                  });
            },
            child: Text(
              "Logistico",
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
        ElevatedButton(
            onPressed: () async {
              showDialog(
                  context: (context),
                  builder: (context) {
                    return AlertDialog(
                      content: Container(
                        width: 500,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Icon(Icons.close)),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  getLoadingModal(context, false);

                                  for (var i = 0;
                                      i < optionsCheckBox.length;
                                      i++) {
                                    if (optionsCheckBox[i]['id']
                                            .toString()
                                            .isNotEmpty &&
                                        optionsCheckBox[i]['id'].toString() !=
                                            '' &&
                                        optionsCheckBox[i]['check'] == true) {
                                      var response = await Connections()
                                          .updateOrderInteralStatusHistorial(
                                              "PENDIENTE",
                                              optionsCheckBox[i]['id']
                                                  .toString());
                                    }
                                  }

                                  Navigator.pop(context);
                                  await loadData();
                                },
                                child: Text(
                                  "Pendiente",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  getLoadingModal(context, false);

                                  for (var i = 0;
                                      i < optionsCheckBox.length;
                                      i++) {
                                    if (optionsCheckBox[i]['id']
                                            .toString()
                                            .isNotEmpty &&
                                        optionsCheckBox[i]['id'].toString() !=
                                            '' &&
                                        optionsCheckBox[i]['check'] == true) {
                                      var response = await Connections()
                                          .updateOrderInteralStatusHistorial(
                                              "CONFIRMADO",
                                              optionsCheckBox[i]['id']
                                                  .toString());
                                    }
                                  }

                                  Navigator.pop(context);
                                  await loadData();
                                },
                                child: Text(
                                  "Confirmar",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  getLoadingModal(context, false);

                                  for (var i = 0;
                                      i < optionsCheckBox.length;
                                      i++) {
                                    if (optionsCheckBox[i]['id']
                                            .toString()
                                            .isNotEmpty &&
                                        optionsCheckBox[i]['id'].toString() !=
                                            '' &&
                                        optionsCheckBox[i]['check'] == true) {
                                      var response = await Connections()
                                          .updateOrderInteralStatusHistorial(
                                              "NO DESEA",
                                              optionsCheckBox[i]['id']
                                                  .toString());
                                    }
                                  }

                                  Navigator.pop(context);
                                  await loadData();
                                },
                                child: Text(
                                  "No Desea",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                          ],
                        ),
                      ),
                    );
                  });
            },
            child: Text(
              "Confirmado",
              style: TextStyle(fontWeight: FontWeight.bold),
            )),

        ElevatedButton(
            onPressed: () async {
              showDialog(
                  context: (context),
                  builder: (context) {
                    return AlertDialog(
                      content: Container(
                        width: 500,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Icon(Icons.close)),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  getLoadingModal(context, false);

                                  for (var i = 0;
                                      i < optionsCheckBox.length;
                                      i++) {
                                    if (optionsCheckBox[i]['id']
                                            .toString()
                                            .isNotEmpty &&
                                        optionsCheckBox[i]['id'].toString() !=
                                            '' &&
                                        optionsCheckBox[i]['check'] == true) {
                                      await Connections().updateOrderReturnAll(
                                          optionsCheckBox[i]['id'].toString());
                                    }
                                  }

                                  Navigator.pop(context);
                                  await loadData();
                                },
                                child: Text(
                                  "PENDIENTE",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  getLoadingModal(context, false);

                                  for (var i = 0;
                                      i < optionsCheckBox.length;
                                      i++) {
                                    if (optionsCheckBox[i]['id']
                                            .toString()
                                            .isNotEmpty &&
                                        optionsCheckBox[i]['id'].toString() !=
                                            '' &&
                                        optionsCheckBox[i]['check'] == true) {
                                      await Connections()
                                          .updateOrderReturnOperator(
                                              optionsCheckBox[i]['id']
                                                  .toString());
                                    }
                                  }

                                  Navigator.pop(context);
                                  await loadData();
                                },
                                child: Text(
                                  "En Oficina",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  getLoadingModal(context, false);

                                  for (var i = 0;
                                      i < optionsCheckBox.length;
                                      i++) {
                                    if (optionsCheckBox[i]['id']
                                            .toString()
                                            .isNotEmpty &&
                                        optionsCheckBox[i]['id'].toString() !=
                                            '' &&
                                        optionsCheckBox[i]['check'] == true) {
                                      await Connections()
                                          .updateOrderReturnLogistic(
                                              optionsCheckBox[i]['id']
                                                  .toString());
                                    }
                                  }

                                  Navigator.pop(context);
                                  await loadData();
                                },
                                child: Text(
                                  "En Bodega",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                          ],
                        ),
                      ),
                    );
                  });
            },
            child: Text(
              "Devolución",
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
        ElevatedButton(
            onPressed: () async {
              showDialog(
                  context: (context),
                  builder: (context) {
                    return AlertDialog(
                      content: Container(
                        width: 500,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Icon(Icons.close)),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  for (var i = 0;
                                      i < optionsCheckBox.length;
                                      i++) {
                                    if (optionsCheckBox[i]['id']
                                            .toString()
                                            .isNotEmpty &&
                                        optionsCheckBox[i]['id'].toString() !=
                                            '' &&
                                        optionsCheckBox[i]['check'] == true) {
                                      var _url = Uri.parse(
                                          """https://api.whatsapp.com/send?phone=${optionsCheckBox[i]['phone'].toString()}""");
                                      if (!await launchUrl(_url)) {
                                        throw Exception(
                                            'Could not launch $_url');
                                      }
                                    }
                                  }
                                },
                                child: Text(
                                  "WhatsApp",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  for (var i = 0;
                                      i < optionsCheckBox.length;
                                      i++) {
                                    if (optionsCheckBox[i]['id']
                                            .toString()
                                            .isNotEmpty &&
                                        optionsCheckBox[i]['id'].toString() !=
                                            '' &&
                                        optionsCheckBox[i]['check'] == true) {
                                      var _url = Uri(
                                          scheme: 'tel',
                                          path:
                                              '${optionsCheckBox[i]['phone'].toString()}');

                                      if (!await launchUrl(_url)) {
                                        throw Exception(
                                            'Could not launch $_url');
                                      }
                                    }
                                  }
                                },
                                child: Text(
                                  "Llamada",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ))
                          ],
                        ),
                      ),
                    );
                  });
            },
            child: Text(
              "Llamadas",
              style: TextStyle(fontWeight: FontWeight.bold),
            )),

        // ElevatedButton(
        //     onPressed: () async {
        //       var response = await Connections().getSellersByIdMasterOnly(
        //           "${data['attributes']['IdComercial'].toString()}");
        //       await showDialog(
        //           context: context,
        //           builder: (context) {
        //             return UpdateStatusOperator(
        //               numberTienda:
        //                   response['vendedores'][0]['Telefono2'].toString(),
        //               codigo:
        //                   "${data['attributes']['Name_Comercial']}-${data['attributes']['NumeroOrden']}",
        //               numberCliente:
        //                   "${data['attributes']['TelefonoShipping']}",
        //             );
        //           });
        //       await loadData();
        //     },
        //     child: Text(
        //       "Estado Entrega",
        //       style: TextStyle(fontWeight: FontWeight.bold),
        //     )),
      ],
    );
  }

  List<DataCell> getRows(index) {
    Color rowColor = Colors.black;

    if (_controllers.searchController.text.isEmpty) {
      return [
        DataCell(Checkbox(
            value: optionsCheckBox[index]['check'],
            onChanged: (value) {
              setState(() {
                if (value!) {
                  optionsCheckBox[index]['check'] = value;
                  optionsCheckBox[index]['id'] = data[index]['id'].toString();
                  optionsCheckBox[index]['numPedido'] =
                      "${data[index]['users'] != null ? data[index]['users'][0]['vendedores'][0]['Nombre_Comercial'] : data[index]['Tienda_Temporal'].toString()}-${data[index]['NumeroOrden']}"
                          .toString();
                  optionsCheckBox[index]['date'] =
                      data[index]['pedido_fecha']['Fecha'].toString();
                  optionsCheckBox[index]['city'] =
                      data[index]['CiudadShipping'].toString();
                  optionsCheckBox[index]['product'] =
                      data[index]['ProductoP'].toString();
                  optionsCheckBox[index]['extraProduct'] =
                      data[index]['ProductoExtra'].toString();
                  optionsCheckBox[index]['quantity'] =
                      data[index]['Cantidad_Total'].toString();
                  optionsCheckBox[index]['phone'] =
                      data[index]['TelefonoShipping'].toString();
                  optionsCheckBox[index]['price'] =
                      data[index]['PrecioTotal'].toString();
                  optionsCheckBox[index]['name'] =
                      data[index]['NombreShipping'].toString();
                  optionsCheckBox[index]['transport'] =
                      "${data[index]['transportadora'] != null ? data[index]['transportadora']['Nombre'].toString() : ""}";
                  optionsCheckBox[index]['address'] =
                      data[index]['DireccionShipping'].toString();
                  optionsCheckBox[index]['obervation'] =
                      data[index]['Observacion'].toString();
                  optionsCheckBox[index]['qrLink'] = data[index]['users'] !=
                          null
                      ? data[index]['users'][0]['vendedores'][0]['Url_Tienda']
                          .toString()
                      : "";

                  counterChecks += 1;
                } else {
                  optionsCheckBox[index]['check'] = value;
                  optionsCheckBox[index]['id'] = '';
                  counterChecks -= 1;
                }
              });
            })),
        DataCell(Text('${data[index]['Marca_T_I'].toString()}'), onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          ),
                        ),
                        Expanded(
                            child: TransportDeliveryHistoryDetails(
                          id: data[index]['id'].toString(),
                        ))
                      ],
                    ),
                  ),
                );
              });
        }),
        DataCell(
            Text(
              data[index]['Marca_T_I'].toString().split(' ')[0].toString(),
              style: TextStyle(
                color: rowColor,
              ),
            ), onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          ),
                        ),
                        Expanded(
                            child: TransportDeliveryHistoryDetails(
                          id: data[index]['id'].toString(),
                        ))
                      ],
                    ),
                  ),
                );
              });
        }),
        DataCell(
            Text(
              "${data[index]['users'] != null && data[index]['users'].toString() != "[]" ? data[index]['users'][0]['vendedores'][0]['Nombre_Comercial'] : data[index]['Tienda_Temporal']}-${data[index]['NumeroOrden']}",
              style: TextStyle(
                color: rowColor,
              ),
            ), onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          ),
                        ),
                        Expanded(
                            child: TransportDeliveryHistoryDetails(
                          id: data[index]['id'].toString(),
                        ))
                      ],
                    ),
                  ),
                );
              });
        }),
        DataCell(
            Text(
              '${data[index]['CiudadShipping'].toString()}',
              style: TextStyle(
                color: rowColor,
              ),
            ), onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          ),
                        ),
                        Expanded(
                            child: TransportDeliveryHistoryDetails(
                          id: data[index]['id'].toString(),
                        ))
                      ],
                    ),
                  ),
                );
              });
        }),
        DataCell(
            Text(
              data[index]['NombreShipping'].toString(),
              style: TextStyle(
                color: rowColor,
              ),
            ), onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          ),
                        ),
                        Expanded(
                            child: TransportDeliveryHistoryDetails(
                          id: data[index]['id'].toString(),
                        ))
                      ],
                    ),
                  ),
                );
              });
        }),

        DataCell(
            Text(
              '${data[index]['DireccionShipping'].toString()}',
              style: TextStyle(
                color: rowColor,
              ),
            ), onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          ),
                        ),
                        Expanded(
                            child: TransportDeliveryHistoryDetails(
                          id: data[index]['id'].toString(),
                        ))
                      ],
                    ),
                  ),
                );
              });
        }),
        DataCell(
            Text(
              data[index]['TelefonoShipping'].toString(),
              style: TextStyle(
                color: rowColor,
              ),
            ), onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          ),
                        ),
                        Expanded(
                            child: TransportDeliveryHistoryDetails(
                          id: data[index]['id'].toString(),
                        ))
                      ],
                    ),
                  ),
                );
              });
        }),
        DataCell(
            Text(
              data[index]['Cantidad_Total'].toString(),
              style: TextStyle(
                color: rowColor,
              ),
            ), onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          ),
                        ),
                        Expanded(
                            child: TransportDeliveryHistoryDetails(
                          id: data[index]['id'].toString(),
                        ))
                      ],
                    ),
                  ),
                );
              });
        }),
        DataCell(
            Text(
              data[index]['ProductoP'].toString(),
              style: TextStyle(
                color: rowColor,
              ),
            ), onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          ),
                        ),
                        Expanded(
                            child: TransportDeliveryHistoryDetails(
                          id: data[index]['id'].toString(),
                        ))
                      ],
                    ),
                  ),
                );
              });
        }),
        DataCell(
            Text(
              data[index]['ProductoExtra'].toString(),
              style: TextStyle(
                color: rowColor,
              ),
            ), onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          ),
                        ),
                        Expanded(
                            child: TransportDeliveryHistoryDetails(
                          id: data[index]['id'].toString(),
                        ))
                      ],
                    ),
                  ),
                );
              });
        }),
        DataCell(
            Text(
              data[index]['PrecioTotal'].toString(),
              style: TextStyle(
                color: rowColor,
              ),
            ), onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          ),
                        ),
                        Expanded(
                            child: TransportDeliveryHistoryDetails(
                          id: data[index]['id'].toString(),
                        ))
                      ],
                    ),
                  ),
                );
              });
        }),
        DataCell(
            Text(
              data[index]['Observacion'].toString(),
              style: TextStyle(
                color: rowColor,
              ),
            ), onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          ),
                        ),
                        Expanded(
                            child: TransportDeliveryHistoryDetails(
                          id: data[index]['id'].toString(),
                        ))
                      ],
                    ),
                  ),
                );
              });
        }),

        DataCell(
            Text(
              '${data[index]['Comentario'].toString()}',
              style: TextStyle(
                color: rowColor,
              ),
            ), onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          ),
                        ),
                        Expanded(
                            child: TransportDeliveryHistoryDetails(
                          id: data[index]['id'].toString(),
                        ))
                      ],
                    ),
                  ),
                );
              });
        }),

        DataCell(
            Text(
              data[index]['Status'].toString(),
              style: TextStyle(
                color: rowColor,
              ),
            ), onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          ),
                        ),
                        Expanded(
                            child: TransportDeliveryHistoryDetails(
                          id: data[index]['id'].toString(),
                        ))
                      ],
                    ),
                  ),
                );
              });
        }),

        DataCell(
            Text(
              data[index]['TipoPago'].toString(),
              style: TextStyle(
                color: rowColor,
              ),
            ), onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          ),
                        ),
                        Expanded(
                            child: TransportDeliveryHistoryDetails(
                          id: data[index]['id'].toString(),
                        ))
                      ],
                    ),
                  ),
                );
              });
        }),
        DataCell(
            Text(
              data[index]['ruta'] != null &&
                      data[index]['ruta'].toString() != "[]"
                  ? data[index]['ruta']['Titulo'].toString()
                  : "",
              style: TextStyle(
                color: rowColor,
              ),
            ), onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          ),
                        ),
                        Expanded(
                            child: TransportDeliveryHistoryDetails(
                          id: data[index]['id'].toString(),
                        ))
                      ],
                    ),
                  ),
                );
              });
        }),
        DataCell(
            Text(
              data[index]['transportadora'] != null &&
                      data[index]['transportadora'].toString() != "[]"
                  ? data[index]['transportadora']['Nombre'].toString()
                  : "",
              style: TextStyle(
                color: rowColor,
              ),
            ), onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          ),
                        ),
                        Expanded(
                            child: TransportDeliveryHistoryDetails(
                          id: data[index]['id'].toString(),
                        ))
                      ],
                    ),
                  ),
                );
              });
        }),
        DataCell(
            Text(
              data[index]['sub_ruta'] != null &&
                      data[index]['sub_ruta'].toString() != "[]"
                  ? data[index]['sub_ruta']['Titulo'].toString()
                  : "",
              style: TextStyle(
                color: rowColor,
              ),
            ), onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          ),
                        ),
                        Expanded(
                            child: TransportDeliveryHistoryDetails(
                          id: data[index]['id'].toString(),
                        ))
                      ],
                    ),
                  ),
                );
              });
        }),
        DataCell(
            Text(
              data[index]['operadore'] != null &&
                      data[index]['operadore'].toString() != "[]"
                  ? data[index]['operadore']['user']['username'].toString()
                  : "",
              style: TextStyle(
                color: rowColor,
              ),
            ), onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          ),
                        ),
                        Expanded(
                            child: TransportDeliveryHistoryDetails(
                          id: data[index]['id'].toString(),
                        ))
                      ],
                    ),
                  ),
                );
              });
        }),
        DataCell(
            Text(
              data[index]['Fecha_Entrega'].toString(),
              style: TextStyle(
                color: rowColor,
              ),
            ), onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          ),
                        ),
                        Expanded(
                            child: TransportDeliveryHistoryDetails(
                          id: data[index]['id'].toString(),
                        ))
                      ],
                    ),
                  ),
                );
              });
        }),
        DataCell(
            Text(
              data[index]['Tienda_Temporal'].toString(),
              style: TextStyle(
                color: rowColor,
              ),
            ), onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          ),
                        ),
                        Expanded(
                            child: TransportDeliveryHistoryDetails(
                          id: data[index]['id'].toString(),
                        ))
                      ],
                    ),
                  ),
                );
              });
        }),
        DataCell(
            Text(
              data[index]['Estado_Interno'].toString(),
              style: TextStyle(
                color: rowColor,
              ),
            ), onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          ),
                        ),
                        Expanded(
                            child: TransportDeliveryHistoryDetails(
                          id: data[index]['id'].toString(),
                        ))
                      ],
                    ),
                  ),
                );
              });
        }),
        DataCell(
            Text(
              data[index]['Estado_Logistico'].toString(),
              style: TextStyle(
                color: rowColor,
              ),
            ), onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          ),
                        ),
                        Expanded(
                            child: TransportDeliveryHistoryDetails(
                          id: data[index]['id'].toString(),
                        ))
                      ],
                    ),
                  ),
                );
              });
        }),

        DataCell(
            Text(
              data[index]['transportadora'] != null &&
                      data[index]['transportadora'].toString() != "[]"
                  ? data[index]['transportadora']['Costo_Transportadora']
                      .toString()
                  : "",
              style: TextStyle(
                color: rowColor,
              ),
            ), onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          ),
                        ),
                        Expanded(
                            child: TransportDeliveryHistoryDetails(
                          id: data[index]['id'].toString(),
                        ))
                      ],
                    ),
                  ),
                );
              });
        }),
        DataCell(
            Text(
              data[index]['operadore'] != null &&
                      data[index]['operadore'].toString() != "[]"
                  ? data[index]['operadore']['Costo_Operador'].toString()
                  : "",
              style: TextStyle(
                color: rowColor,
              ),
            ), onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          ),
                        ),
                        Expanded(
                            child: TransportDeliveryHistoryDetails(
                          id: data[index]['id'].toString(),
                        ))
                      ],
                    ),
                  ),
                );
              });
        }),

        DataCell(
            Text(data[index]['users'] != null &&
                    data[index]['users'].toString() != "[]"
                ? data[index]['users'][0]['vendedores'][0]['CostoEnvio']
                    .toString()
                : ""), onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          ),
                        ),
                        Expanded(
                            child: TransportDeliveryHistoryDetails(
                          id: data[index]['id'].toString(),
                        ))
                      ],
                    ),
                  ),
                );
              });
        }),
        DataCell(
            Text(data[index]['users'] != null &&
                    data[index]['users'].toString() != "[]"
                ? data[index]['users'][0]['vendedores'][0]['CostoDevolucion']
                    .toString()
                : ""), onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          ),
                        ),
                        Expanded(
                            child: TransportDeliveryHistoryDetails(
                          id: data[index]['id'].toString(),
                        ))
                      ],
                    ),
                  ),
                );
              });
        }),

        // DataCell(Text(
        //   data[index]['operadore']['Costo_Operador'].toString(),
        //   style: TextStyle(
        //     color: rowColor,
        //   ),
        // )),
        DataCell(
            Text(
              data[index]['Estado_Devolucion'].toString(),
              style: TextStyle(
                color: rowColor,
              ),
            ), onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          ),
                        ),
                        Expanded(
                            child: TransportDeliveryHistoryDetails(
                          id: data[index]['id'].toString(),
                        ))
                      ],
                    ),
                  ),
                );
              });
        }),
        DataCell(
            Text(
              data[index]['Marca_T_D'].toString(),
              style: TextStyle(
                color: rowColor,
              ),
            ), onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          ),
                        ),
                        Expanded(
                            child: TransportDeliveryHistoryDetails(
                          id: data[index]['id'].toString(),
                        ))
                      ],
                    ),
                  ),
                );
              });
        }),
        DataCell(
            Text(
              data[index]['Estado_Pago_Logistica'].toString(),
              style: TextStyle(
                color: rowColor,
              ),
            ), onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          ),
                        ),
                        Expanded(
                            child: TransportDeliveryHistoryDetails(
                          id: data[index]['id'].toString(),
                        ))
                      ],
                    ),
                  ),
                );
              });
        }),
      ];
    } else {
      return [
        DataCell(Checkbox(
            value: optionsCheckBox[index]['check'],
            onChanged: (value) {
              setState(() {
                if (value!) {
                  optionsCheckBox[index]['check'] = value;
                  optionsCheckBox[index]['id'] = data[index]['id'].toString();
                  optionsCheckBox[index]['numPedido'] =
                      "${data[index]['attributes']['users']['data'] != null ? data[index]['attributes']['users']['data'][0]['attributes']['vendedores']['data'][0]['attributes']['Nombre_Comercial'] : data[index]['attributes']['Tienda_Temporal'].toString()}-${data[index]['attributes']['NumeroOrden']}"
                          .toString();
                  optionsCheckBox[index]['date'] = data[index]['attributes']
                          ['pedido_fecha']['data']['attributes']['Fecha']
                      .toString();
                  optionsCheckBox[index]['city'] =
                      data[index]['attributes']['CiudadShipping'].toString();
                  optionsCheckBox[index]['product'] =
                      data[index]['attributes']['ProductoP'].toString();
                  optionsCheckBox[index]['extraProduct'] =
                      data[index]['attributes']['ProductoExtra'].toString();
                  optionsCheckBox[index]['quantity'] =
                      data[index]['attributes']['Cantidad_Total'].toString();
                  optionsCheckBox[index]['phone'] =
                      data[index]['attributes']['TelefonoShipping'].toString();
                  optionsCheckBox[index]['price'] =
                      data[index]['attributes']['PrecioTotal'].toString();
                  optionsCheckBox[index]['name'] =
                      data[index]['attributes']['NombreShipping'].toString();
                  optionsCheckBox[index]['transport'] =
                      "${data[index]['attributes']['transportadora']['data'] != null ? data[index]['attributes']['transportadora']['data']['attributes']['Nombre'].toString() : ''}";
                  optionsCheckBox[index]['address'] =
                      data[index]['attributes']['DireccionShipping'].toString();
                  optionsCheckBox[index]['obervation'] =
                      data[index]['attributes']['Observacion'].toString();
                  optionsCheckBox[index]['qrLink'] = data[index]['attributes']
                              ['users']['data'][0]['attributes']['vendedores']
                          ['data'][0]['attributes']['Url_Tienda']
                      .toString();

                  counterChecks += 1;
                } else {
                  optionsCheckBox[index]['check'] = value;
                  optionsCheckBox[index]['id'] = '';
                  counterChecks -= 1;
                }
              });
            })),
        DataCell(Text('${data[index]['attributes']['Marca_T_I'].toString()}'),
            onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          ),
                        ),
                        Expanded(
                            child: TransportDeliveryHistoryDetails(
                          id: data[index]['id'].toString(),
                        ))
                      ],
                    ),
                  ),
                );
              });
        }),
        DataCell(
            Text(
              data[index]['attributes']['Marca_T_I'].toString(),
              style: TextStyle(
                color: rowColor,
              ),
            ), onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          ),
                        ),
                        Expanded(
                            child: TransportDeliveryHistoryDetails(
                          id: data[index]['id'].toString(),
                        ))
                      ],
                    ),
                  ),
                );
              });
        }),
        DataCell(
            Text(
              "${data[index]['attributes']['users']['data'] != null ? data[index]['attributes']['users']['data'][0]['attributes']['vendedores']['data'][0]['attributes']['Nombre_Comercial'] : data[index]['attributes']['Tienda_Temporal'].toString()}-${data[index]['attributes']['NumeroOrden']}",
              style: TextStyle(
                color: rowColor,
              ),
            ), onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          ),
                        ),
                        Expanded(
                            child: TransportDeliveryHistoryDetails(
                          id: data[index]['id'].toString(),
                        ))
                      ],
                    ),
                  ),
                );
              });
        }),
        DataCell(
            Text(
              '${data[index]['attributes']['CiudadShipping'].toString()}',
              style: TextStyle(
                color: rowColor,
              ),
            ), onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          ),
                        ),
                        Expanded(
                            child: TransportDeliveryHistoryDetails(
                          id: data[index]['id'].toString(),
                        ))
                      ],
                    ),
                  ),
                );
              });
        }),
        DataCell(
            Text(
              data[index]['attributes']['NombreShipping'].toString(),
              style: TextStyle(
                color: rowColor,
              ),
            ), onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          ),
                        ),
                        Expanded(
                            child: TransportDeliveryHistoryDetails(
                          id: data[index]['id'].toString(),
                        ))
                      ],
                    ),
                  ),
                );
              });
        }),

        DataCell(
            Text(
              '${data[index]['attributes']['DireccionShipping'].toString()}',
              style: TextStyle(
                color: rowColor,
              ),
            ), onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          ),
                        ),
                        Expanded(
                            child: TransportDeliveryHistoryDetails(
                          id: data[index]['id'].toString(),
                        ))
                      ],
                    ),
                  ),
                );
              });
        }),
        DataCell(
            Text(
              data[index]['attributes']['TelefonoShipping'].toString(),
              style: TextStyle(
                color: rowColor,
              ),
            ), onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          ),
                        ),
                        Expanded(
                            child: TransportDeliveryHistoryDetails(
                          id: data[index]['id'].toString(),
                        ))
                      ],
                    ),
                  ),
                );
              });
        }),
        DataCell(
            Text(
              data[index]['attributes']['Cantidad_Total'].toString(),
              style: TextStyle(
                color: rowColor,
              ),
            ), onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          ),
                        ),
                        Expanded(
                            child: TransportDeliveryHistoryDetails(
                          id: data[index]['id'].toString(),
                        ))
                      ],
                    ),
                  ),
                );
              });
        }),
        DataCell(
            Text(
              data[index]['attributes']['ProductoP'].toString(),
              style: TextStyle(
                color: rowColor,
              ),
            ), onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          ),
                        ),
                        Expanded(
                            child: TransportDeliveryHistoryDetails(
                          id: data[index]['id'].toString(),
                        ))
                      ],
                    ),
                  ),
                );
              });
        }),
        DataCell(
            Text(
              data[index]['attributes']['ProductoExtra'].toString(),
              style: TextStyle(
                color: rowColor,
              ),
            ), onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          ),
                        ),
                        Expanded(
                            child: TransportDeliveryHistoryDetails(
                          id: data[index]['id'].toString(),
                        ))
                      ],
                    ),
                  ),
                );
              });
        }),
        DataCell(
            Text(
              data[index]['attributes']['PrecioTotal'].toString(),
              style: TextStyle(
                color: rowColor,
              ),
            ), onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          ),
                        ),
                        Expanded(
                            child: TransportDeliveryHistoryDetails(
                          id: data[index]['id'].toString(),
                        ))
                      ],
                    ),
                  ),
                );
              });
        }),
        DataCell(
            Text(
              data[index]['attributes']['Observacion'].toString(),
              style: TextStyle(
                color: rowColor,
              ),
            ), onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          ),
                        ),
                        Expanded(
                            child: TransportDeliveryHistoryDetails(
                          id: data[index]['id'].toString(),
                        ))
                      ],
                    ),
                  ),
                );
              });
        }),

        DataCell(
            Text(
              '${data[index]['attributes']['Comentario'].toString()}',
              style: TextStyle(
                color: rowColor,
              ),
            ), onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          ),
                        ),
                        Expanded(
                            child: TransportDeliveryHistoryDetails(
                          id: data[index]['id'].toString(),
                        ))
                      ],
                    ),
                  ),
                );
              });
        }),

        DataCell(
            Text(
              data[index]['attributes']['Status'].toString(),
              style: TextStyle(
                color: rowColor,
              ),
            ), onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          ),
                        ),
                        Expanded(
                            child: TransportDeliveryHistoryDetails(
                          id: data[index]['id'].toString(),
                        ))
                      ],
                    ),
                  ),
                );
              });
        }),

        DataCell(
            Text(
              data[index]['attributes']['TipoPago'].toString(),
              style: TextStyle(
                color: rowColor,
              ),
            ), onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          ),
                        ),
                        Expanded(
                            child: TransportDeliveryHistoryDetails(
                          id: data[index]['id'].toString(),
                        ))
                      ],
                    ),
                  ),
                );
              });
        }),
        DataCell(
            Text(
              data[index]['attributes']['ruta']['data'] != null
                  ? data[index]['attributes']['ruta']["data"]['attributes']
                          ['Titulo']
                      .toString()
                  : "",
              style: TextStyle(
                color: rowColor,
              ),
            ), onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          ),
                        ),
                        Expanded(
                            child: TransportDeliveryHistoryDetails(
                          id: data[index]['id'].toString(),
                        ))
                      ],
                    ),
                  ),
                );
              });
        }),
        DataCell(
            Text(
              data[index]['attributes']['transportadora']['data'] != null
                  ? data[index]['attributes']['transportadora']['data']
                          ['attributes']['Nombre']
                      .toString()
                  : "",
              style: TextStyle(
                color: rowColor,
              ),
            ), onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          ),
                        ),
                        Expanded(
                            child: TransportDeliveryHistoryDetails(
                          id: data[index]['id'].toString(),
                        ))
                      ],
                    ),
                  ),
                );
              });
        }),
        DataCell(
            Text(
              data[index]['attributes']['sub_ruta']['data'] != null
                  ? data[index]['attributes']['sub_ruta']['data']['attributes']
                          ['Titulo']
                      .toString()
                  : "",
              style: TextStyle(
                color: rowColor,
              ),
            ), onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          ),
                        ),
                        Expanded(
                            child: TransportDeliveryHistoryDetails(
                          id: data[index]['id'].toString(),
                        ))
                      ],
                    ),
                  ),
                );
              });
        }),
        DataCell(
            Text(
              data[index]['attributes']['operadore']['data'] != null
                  ? data[index]['attributes']['operadore']['data']['attributes']
                          ['user']['data']['attributes']['username']
                      .toString()
                  : "",
              style: TextStyle(
                color: rowColor,
              ),
            ), onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          ),
                        ),
                        Expanded(
                            child: TransportDeliveryHistoryDetails(
                          id: data[index]['id'].toString(),
                        ))
                      ],
                    ),
                  ),
                );
              });
        }),
        DataCell(
            Text(
              data[index]['attributes']['Fecha_Entrega'].toString(),
              style: TextStyle(
                color: rowColor,
              ),
            ), onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          ),
                        ),
                        Expanded(
                            child: TransportDeliveryHistoryDetails(
                          id: data[index]['id'].toString(),
                        ))
                      ],
                    ),
                  ),
                );
              });
        }),
        DataCell(
            Text(
              data[index]['attributes']['Tienda_Temporal'].toString(),
              style: TextStyle(
                color: rowColor,
              ),
            ), onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          ),
                        ),
                        Expanded(
                            child: TransportDeliveryHistoryDetails(
                          id: data[index]['id'].toString(),
                        ))
                      ],
                    ),
                  ),
                );
              });
        }),
        DataCell(
            Text(
              data[index]['attributes']['Estado_Interno'].toString(),
              style: TextStyle(
                color: rowColor,
              ),
            ), onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          ),
                        ),
                        Expanded(
                            child: TransportDeliveryHistoryDetails(
                          id: data[index]['id'].toString(),
                        ))
                      ],
                    ),
                  ),
                );
              });
        }),
        DataCell(
            Text(
              data[index]['attributes']['Estado_Logistico'].toString(),
              style: TextStyle(
                color: rowColor,
              ),
            ), onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          ),
                        ),
                        Expanded(
                            child: TransportDeliveryHistoryDetails(
                          id: data[index]['id'].toString(),
                        ))
                      ],
                    ),
                  ),
                );
              });
        }),

        DataCell(
            Text(
              data[index]['attributes']['transportadora']['data'] != null
                  ? data[index]['attributes']['transportadora']['data']
                          ['attributes']['Costo_Transportadora']
                      .toString()
                  : "",
              style: TextStyle(
                color: rowColor,
              ),
            ), onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          ),
                        ),
                        Expanded(
                            child: TransportDeliveryHistoryDetails(
                          id: data[index]['id'].toString(),
                        ))
                      ],
                    ),
                  ),
                );
              });
        }),
        DataCell(
            Text(
              data[index]['attributes']['operadore']['data'] != null
                  ? data[index]['attributes']['operadore']['data']['attributes']
                          ['Costo_Operador']
                      .toString()
                  : "", //este,

              style: TextStyle(
                color: rowColor,
              ),
            ), onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          ),
                        ),
                        Expanded(
                            child: TransportDeliveryHistoryDetails(
                          id: data[index]['id'].toString(),
                        ))
                      ],
                    ),
                  ),
                );
              });
        }),

        DataCell(
            Text(data[index]['attributes']['users'] != null
                ? data[index]['attributes']['users']['data'][0]['attributes']
                        ['vendedores']['data'][0]['attributes']['CostoEnvio']
                    .toString()
                : ""), onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          ),
                        ),
                        Expanded(
                            child: TransportDeliveryHistoryDetails(
                          id: data[index]['id'].toString(),
                        ))
                      ],
                    ),
                  ),
                );
              });
        }),
        DataCell(
            Text(data[index]['attributes']['users']['data'] != null
                ? data[index]['attributes']['users']['data'][0]['attributes']
                            ['vendedores']['data'][0]['attributes']
                        ['CostoDevolucion']
                    .toString()
                : ""), onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          ),
                        ),
                        Expanded(
                            child: TransportDeliveryHistoryDetails(
                          id: data[index]['id'].toString(),
                        ))
                      ],
                    ),
                  ),
                );
              });
        }),

        // DataCell(Text(
        //   data[index]['operadore']['Costo_Operador'].toString(),
        //   style: TextStyle(
        //     color: rowColor,
        //   ),
        // )),
        DataCell(
            Text(
              data[index]['attributes']['Estado_Devolucion'].toString(),
              style: TextStyle(
                color: rowColor,
              ),
            ), onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          ),
                        ),
                        Expanded(
                            child: TransportDeliveryHistoryDetails(
                          id: data[index]['id'].toString(),
                        ))
                      ],
                    ),
                  ),
                );
              });
        }),
        DataCell(
            Text(
              data[index]['attributes']['Marca_T_D'].toString(),
              style: TextStyle(
                color: rowColor,
              ),
            ), onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          ),
                        ),
                        Expanded(
                            child: TransportDeliveryHistoryDetails(
                          id: data[index]['id'].toString(),
                        ))
                      ],
                    ),
                  ),
                );
              });
        }),
        DataCell(
            Text(
              data[index]['attributes']['Estado_Pago_Logistica'].toString(),
              style: TextStyle(
                color: rowColor,
              ),
            ), onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close),
                          ),
                        ),
                        Expanded(
                            child: TransportDeliveryHistoryDetails(
                          id: data[index]['id'].toString(),
                        ))
                      ],
                    ),
                  ),
                );
              });
        }),
      ];
    }
  }

  SizedBox _dates(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextButton(
              onPressed: () async {
                var results = await showCalendarDatePicker2Dialog(
                  context: context,
                  config: CalendarDatePicker2WithActionButtonsConfig(
                    dayTextStyle: TextStyle(fontWeight: FontWeight.bold),
                    yearTextStyle: TextStyle(fontWeight: FontWeight.bold),
                    selectedYearTextStyle:
                        TextStyle(fontWeight: FontWeight.bold),
                    weekdayLabelTextStyle:
                        TextStyle(fontWeight: FontWeight.bold),
                  ),
                  dialogSize: const Size(325, 400),
                  value: _datesDesde,
                  borderRadius: BorderRadius.circular(15),
                );
                setState(() {
                  if (results != null) {
                    String fechaOriginal = results![0]
                        .toString()
                        .split(" ")[0]
                        .split('-')
                        .reversed
                        .join('-')
                        .replaceAll("-", "/");
                    List<String> componentes = fechaOriginal.split('/');

                    String dia = int.parse(componentes[0]).toString();
                    String mes = int.parse(componentes[1]).toString();
                    String anio = componentes[2];

                    String nuevaFecha = "$dia/$mes/$anio";

                    sharedPrefs!
                        .setString("dateDesdeTransportHistorial", nuevaFecha);
                  }
                });
              },
              child: Text(
                "DESDE: ${sharedPrefs!.getString("dateDesdeTransportHistorial")}",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          SizedBox(
            width: 10,
          ),
          TextButton(
              onPressed: () async {
                var results = await showCalendarDatePicker2Dialog(
                  context: context,
                  config: CalendarDatePicker2WithActionButtonsConfig(
                    dayTextStyle: TextStyle(fontWeight: FontWeight.bold),
                    yearTextStyle: TextStyle(fontWeight: FontWeight.bold),
                    selectedYearTextStyle:
                        TextStyle(fontWeight: FontWeight.bold),
                    weekdayLabelTextStyle:
                        TextStyle(fontWeight: FontWeight.bold),
                  ),
                  dialogSize: const Size(325, 400),
                  value: _datesHasta,
                  borderRadius: BorderRadius.circular(15),
                );
                setState(() {
                  if (results != null) {
                    String fechaOriginal = results![0]
                        .toString()
                        .split(" ")[0]
                        .split('-')
                        .reversed
                        .join('-')
                        .replaceAll("-", "/");
                    List<String> componentes = fechaOriginal.split('/');

                    String dia = int.parse(componentes[0]).toString();
                    String mes = int.parse(componentes[1]).toString();
                    String anio = componentes[2];

                    String nuevaFecha = "$dia/$mes/$anio";

                    sharedPrefs!
                        .setString("dateHastaTransportHistorial", nuevaFecha);
                  }
                });
              },
              child: Text(
                "HASTA: ${sharedPrefs!.getString("dateHastaTransportHistorial")}",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          SizedBox(
            width: 10,
          ),
          ElevatedButton(
              onPressed: () async {
                setState(() {
                  _search.clear();
                });
                await loadData();
              },
              child: Text(
                "BUSCAR",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          SizedBox(
            width: 10,
          )
        ],
      ),
    );
  }

  _filters(BuildContext context) {
    return Row(
      children: [
        IconButton(
            onPressed: () async {
              await showDialog(
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(builder: (context, setState) {
                      return AlertDialog(
                        content: Container(
                          width: 500,
                          height: MediaQuery.of(context).size.height,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Icon(Icons.close)),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Filtros:",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Expanded(
                                child: Center(
                                  child: ListView(
                                    children: [
                                      Wrap(
                                        children: [
                                          ...List.generate(
                                              titlesFilters.length,
                                              (index) => Container(
                                                    width: 140,
                                                    child: Row(
                                                      children: [
                                                        Checkbox(
                                                            value: bools[index],
                                                            onChanged: (v) {
                                                              if (bools[
                                                                      index] ==
                                                                  true) {
                                                                setState(() {
                                                                  bools[index] =
                                                                      false;
                                                                  option = "";
                                                                });
                                                              } else {
                                                                setState(() {
                                                                  bools[index] =
                                                                      true;
                                                                  option =
                                                                      titlesFilters[
                                                                          index];
                                                                  for (int i =
                                                                          0;
                                                                      i <
                                                                          bools
                                                                              .length;
                                                                      i++) {
                                                                    if (i !=
                                                                        index) {
                                                                      bools[i] =
                                                                          false;
                                                                    }
                                                                  }
                                                                });
                                                              }
                                                              Navigator.pop(
                                                                  context);
                                                            }),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          titlesFilters[index],
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 12),
                                                        )
                                                      ],
                                                    ),
                                                  ))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
                  });
              setState(() {});
            },
            icon: Icon(Icons.filter_alt_outlined)),
        Flexible(
            child: Text(
          "Activo: $option",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
        ))
      ],
    );
  }

  _invoiceTile({
    required String name,
    required int id,
    String status = "",
  }) {
    return ListTile(
      onTap: () {
        Navigators().pushNamed(
          context,
          '/layout/logistic/transport-delivery-history-by-transport?id=$id',
        );
      },
      trailing: const Icon(
        Icons.arrow_forward_ios_sharp,
        size: 15,
      ),
      title: Row(
        children: [
          Text(
            "$name",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
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
        onSubmitted: (value) async {
          setState(() {
            data = [];
          });
          switch (option) {
            case "Fecha":
              setState(() {
                url =
                    "&filters[\$or][1][Marca_Tiempo_Envio][\$contains]=${_controllers.searchController.text}";
              });
              break;
            case "Código":
              setState(() {
                url =
                    "&filters[\$or][1][NumeroOrden][\$contains]=${_controllers.searchController.text}";
              });

              break;
            case "Ciudad":
              setState(() {
                url =
                    "&filters[\$or][1][CiudadShipping][\$contains]=${_controllers.searchController.text}";
              });

              break;
            case "Nombre Cliente":
              setState(() {
                url =
                    "&filters[\$or][1][NombreShipping][\$contains]=${_controllers.searchController.text}";
              });

              break;
            case "Dirección":
              setState(() {
                url =
                    "&filters[\$or][1][DireccionShipping][\$contains]=${_controllers.searchController.text}";
              });

              break;
            case "Teléfono Cliente":
              setState(() {
                url =
                    "&filters[\$or][1][TelefonoShipping][\$contains]=${_controllers.searchController.text}";
              });

              break;
            case "Cantidad":
              setState(() {
                url =
                    "&filters[\$or][1][Cantidad_Total][\$contains]=${_controllers.searchController.text}";
              });

              break;
            case "Producto":
              setState(() {
                url =
                    "&filters[\$or][1][ProductoP][\$contains]=${_controllers.searchController.text}";
              });

              break;
            case "Producto Extra":
              setState(() {
                url =
                    "&filters[\$or][1][ProductoExtra][\$contains]=${_controllers.searchController.text}";
              });

              break;
            case "Precio Total":
              setState(() {
                url =
                    "&filters[\$or][1][PrecioTotal][\$contains]=${_controllers.searchController.text}";
              });

              break;
            case "Observación":
              setState(() {
                url =
                    "&filters[\$or][1][Observacion][\$contains]=${_controllers.searchController.text}";
              });

              break;
            case "Comentario":
              setState(() {
                url =
                    "&filters[\$or][1][Comentario][\$contains]=${_controllers.searchController.text}";
              });

              break;
            case "Status":
              setState(() {
                url =
                    "&filters[\$or][1][Status][\$contains]=${_controllers.searchController.text}";
              });

              break;
            case "Fecha Entrega":
              setState(() {
                url =
                    "&filters[\$or][1][Fecha_Entrega][\$contains]=${_controllers.searchController.text}";
              });

              break;

            case "Devolución":
              setState(() {
                url =
                    "&filters[\$or][1][Estado_Devolucion][\$contains]=${_controllers.searchController.text}";
              });

              break;
            case "Vendedor":
              setState(() {
                url =
                    "&filters[\$or][1][Tienda_Temporal][\$contains]=${_controllers.searchController.text}";
              });

              break;
            case "Transportadora":
              setState(() {
                url =
                    "&filters[\$or][1][transportadora][Nombre][\$contains]=${_controllers.searchController.text}";
              });

              break;
            case "Operador":
              setState(() {
                url =
                    "&filters[\$or][1][operadore][user][username][\$contains]=${_controllers.searchController.text}";
              });

              break;
            case "Estado Pago":
              setState(() {
                url =
                    "&filters[\$or][1][Estado_Pagado][\$contains]=${_controllers.searchController.text}";
              });

              break;
            case "Est. logistic":
              setState(() {
                url =
                    "&filters[\$or][1][Estado_Logistico][\$contains]=${_controllers.searchController.text}";
              });

              break;
            case "Est. Confir":
              setState(() {
                url =
                    "&filters[\$or][1][Estado_Interno][\$contains]=${_controllers.searchController.text}";
              });

              break;
            case "Ruta":
              setState(() {
                url =
                    "&filters[\$or][1][ruta][Titulo][\$contains]=${_controllers.searchController.text}";
              });

              break;
            case "SubRuta":
              setState(() {
                url =
                    "&filters[\$or][1][sub_ruta][Titulo][\$contains]=${_controllers.searchController.text}";
              });

              break;
            default:
              setState(() {
                url =
                    "&filters[\$or][0][NumeroOrden][\$contains]=${_controllers.searchController.text}&filters[\$or][1][Marca_Tiempo_Envio][\$contains]=${_controllers.searchController.text}&filters[\$or][2][NumeroOrden][\$contains]=${_controllers.searchController.text}&filters[\$or][3][CiudadShipping][\$contains]=${_controllers.searchController.text}&filters[\$or][4][NombreShipping][\$contains]=${_controllers.searchController.text}&filters[\$or][5][DireccionShipping][\$contains]=${_controllers.searchController.text}&filters[\$or][6][TelefonoShipping][\$contains]=${_controllers.searchController.text}&filters[\$or][7][Cantidad_Total][\$contains]=${_controllers.searchController.text}&filters[\$or][8][ProductoP][\$contains]=${_controllers.searchController.text}&filters[\$or][9][ProductoExtra][\$contains]=${_controllers.searchController.text}&filters[\$or][10][PrecioTotal][\$contains]=${_controllers.searchController.text}&filters[\$or][11][Observacion][\$contains]=${_controllers.searchController.text}&filters[\$or][12][Comentario][\$contains]=${_controllers.searchController.text}&filters[\$or][13][Status][\$contains]=${_controllers.searchController.text}&filters[\$or][14][Fecha_Entrega][\$contains]=${_controllers.searchController.text}&filters[\$or][15][Estado_Devolucion][\$contains]=${_controllers.searchController.text}&filters[\$or][16][Tienda_Temporal][\$contains]=${_controllers.searchController.text}&filters[\$or][17][transportadora][Nombre][\$contains]=${_controllers.searchController.text}&filters[\$or][18][operadore][user][username][\$contains]=${_controllers.searchController.text}&filters[\$or][19][Estado_Pagado][\$contains]=${_controllers.searchController.text}&filters[\$or][20][Estado_Logistico][\$contains]=${_controllers.searchController.text}&filters[\$or][21][Estado_Interno][\$contains]=${_controllers.searchController.text}&filters[\$or][22][ruta][Titulo][\$contains]=${_controllers.searchController.text}&filters[\$or][23][sub_ruta][Titulo][\$contains]=${_controllers.searchController.text}";
              });
              break;
          }
          Future.delayed(const Duration(milliseconds: 500), () {
            loadData();
          });
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
                    loadData();
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
    if (search == false) {
      if (sort) {
        setState(() {
          sort = false;
        });
        data.sort((a, b) => b[name].toString().compareTo(a[name].toString()));
      } else {
        setState(() {
          sort = true;
        });
        data.sort((a, b) => a[name].toString().compareTo(b[name].toString()));
      }
    } else {
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
  }

  sortFuncrutaAsignada() {
    if (search == false) {
      if (sort) {
        setState(() {
          sort = false;
        });
        data.sort((a, b) => b['ruta']['Titulo']
            .toString()
            .compareTo(a['ruta']['Titulo'].toString()));
      } else {
        setState(() {
          sort = true;
        });
        data.sort((a, b) => a['ruta']['Titulo']
            .toString()
            .compareTo(b['ruta']['Titulo'].toString()));
      }
    } else {
      if (sort) {
        setState(() {
          sort = false;
        });
        data.sort((a, b) => b['attributes']['ruta']["data"]['attributes']
                ['Titulo']
            .toString()
            .compareTo(a['attributes']['ruta']["data"]['attributes']['Titulo']
                .toString()));
      } else {
        setState(() {
          sort = true;
        });
        data.sort((a, b) => a['attributes']['ruta']["data"]['attributes']
                ['Titulo']
            .toString()
            .compareTo(b['attributes']['ruta']["data"]['attributes']['Titulo']
                .toString()));
      }
    }
  }

  sortFuncTransportadora() {
    if (search == false) {
      if (sort) {
        setState(() {
          sort = false;
        });
        data.sort((a, b) => b['transportadora']['Nombre']
            .toString()
            .compareTo(a['transportadora']['Nombre'].toString()));
      } else {
        setState(() {
          sort = true;
        });
        data.sort((a, b) => a['transportadora']['Nombre']
            .toString()
            .compareTo(b['transportadora']['Nombre'].toString()));
      }
    } else {
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

  sortFuncSubRuta() {
    if (search == false) {
      if (sort) {
        setState(() {
          sort = false;
        });
        data.sort((a, b) => b['sub_ruta'] != null
            ? b['sub_ruta']['Titulo']
            : "".toString().compareTo(a['sub_ruta'] != null
                ? a['sub_ruta']['Titulo'].toString()
                : ""));
      } else {
        setState(() {
          sort = true;
        });
        data.sort((a, b) => a['sub_ruta'] != null
            ? a['sub_ruta']['Titulo']
            : "".toString().compareTo(b['sub_ruta'] != null
                ? b['sub_ruta']['Titulo'].toString()
                : ""));
      }
    } else {
      if (sort) {
        setState(() {
          sort = false;
        });
        data.sort((a, b) => b['attributes']['sub_ruta']['data']['attributes']
                ['Titulo']
            .toString()
            .compareTo(a['attributes']['sub_ruta']['data']['attributes']
                    ['Titulo']
                .toString()));
      } else {
        setState(() {
          sort = true;
        });
        data.sort((a, b) => a['attributes']['sub_ruta']['data']['attributes']
                ['Titulo']
            .toString()
            .compareTo(b['attributes']['sub_ruta']['data']['attributes']
                    ['Titulo']
                .toString()));
      }
    }
  }

  sortFuncOperador() {
    if (search == false) {
      if (sort) {
        setState(() {
          sort = false;
        });
        data.sort((a, b) => b['operadore']['user']['username']
            .toString()
            .compareTo(a['operadore']['user']['username'].toString()));
      } else {
        setState(() {
          sort = true;
        });
        data.sort((a, b) => a['operadore']['user']['username']
            .toString()
            .compareTo(b['operadore']['user']['username'].toString()));
      }
    } else {
      if (sort) {
        setState(() {
          sort = false;
        });
        data.sort((a, b) => b['attributes']['operadore']['data']['attributes']
                ['user']['data']['attributes']['username']
            .toString()
            .compareTo(a['attributes']['operadore']['data']['attributes']
                    ['user']['data']['attributes']['username']
                .toString()));
      } else {
        setState(() {
          sort = true;
        });
        data.sort((a, b) => a['attributes']['operadore']['data']['attributes']
                ['user']['data']['attributes']['username']
            .toString()
            .compareTo(b['attributes']['operadore']['data']['attributes']
                    ['user']['data']['attributes']['username']
                .toString()));
      }
    }
  }

  sortFuncCostoTrans() {
    if (search == false) {
      if (sort) {
        setState(() {
          sort = false;
        });
        data.sort((a, b) => b['transportadora']['Costo_Transportadora']
            .toString()
            .compareTo(a['transportadora']['Costo_Transportadora'].toString()));
      } else {
        setState(() {
          sort = true;
        });
        data.sort((a, b) => a['transportadora']['Costo_Transportadora']
            .toString()
            .compareTo(b['transportadora']['Costo_Transportadora'].toString()));
      }
    } else {
      if (sort) {
        setState(() {
          sort = false;
        });
        data.sort((a, b) => b['attributes']['transportadora']['data']
                ['attributes']['Costo_Transportadora']
            .toString()
            .compareTo(a['attributes']['transportadora']['data']['attributes']
                    ['Costo_Transportadora']
                .toString()));
      } else {
        setState(() {
          sort = true;
        });
        data.sort((a, b) => a['attributes']['transportadora']['data']
                ['attributes']['Costo_Transportadora']
            .toString()
            .compareTo(b['attributes']['transportadora']['data']['attributes']
                    ['Costo_Transportadora']
                .toString()));
      }
    }
  }

  sortFuncCostoOperador() {
    if (search == false) {
      if (sort) {
        setState(() {
          sort = false;
        });
        data.sort((a, b) => b['operadore']['Costo_Operador']
            .toString()
            .compareTo(a['operadore']['Costo_Operador'].toString()));
      } else {
        setState(() {
          sort = true;
        });
        data.sort((a, b) => a['operadore']['Costo_Operador']
            .toString()
            .compareTo(b['operadore']['Costo_Operador'].toString()));
      }
    } else {
      if (sort) {
        setState(() {
          sort = false;
        });
        data.sort((a, b) => b['attributes']['operadore']['data']['attributes']
                ['Costo_Operador']
            .toString()
            .compareTo(a['attributes']['operadore']['data']['attributes']
                    ['Costo_Operador']
                .toString()));
      } else {
        setState(() {
          sort = true;
        });
        data.sort((a, b) => a['attributes']['operadore']['data']['attributes']
                ['Costo_Operador']
            .toString()
            .compareTo(b['attributes']['operadore']['data']['attributes']
                    ['Costo_Operador']
                .toString()));
      }
    }
  }

  sortFuncCostoEntrega() {
    if (search == false) {
      if (sort) {
        setState(() {
          sort = false;
        });
        data.sort((a, b) => b['users'][0]['vendedores'][0]['CostoEnvio']
            .toString()
            .compareTo(
                a['users'][0]['vendedores'][0]['CostoEnvio'].toString()));
      } else {
        setState(() {
          sort = true;
        });
        data.sort((a, b) => a['users'][0]['vendedores'][0]['CostoEnvio']
            .toString()
            .compareTo(
                b['users'][0]['vendedores'][0]['CostoEnvio'].toString()));
      }
    } else {
      if (sort) {
        setState(() {
          sort = false;
        });
        data.sort((a, b) => b['attributes']['users']['data'][0]['attributes']
                ['vendedores']['data'][0]['attributes']['CostoEnvio']
            .toString()
            .compareTo(a['attributes']['users']['data'][0]['attributes']
                    ['vendedores']['data'][0]['attributes']['CostoEnvio']
                .toString()));
      } else {
        setState(() {
          sort = true;
        });
        data.sort((a, b) => a['attributes']['users']['data'][0]['attributes']
                ['vendedores']['data'][0]['attributes']['CostoEnvio']
            .toString()
            .compareTo(b['attributes']['users']['data'][0]['attributes']
                    ['vendedores']['data'][0]['attributes']['CostoEnvio']
                .toString()));
      }
    }
  }

  sortFuncDevolucion() {
    if (search == false) {
      if (sort) {
        setState(() {
          sort = false;
        });
        data.sort((a, b) => b['users'][0]['vendedores'][0]['CostoDevolucion']
            .toString()
            .compareTo(
                a['users'][0]['vendedores'][0]['CostoDevolucion'].toString()));
      } else {
        setState(() {
          sort = true;
        });
        data.sort((a, b) => a['users'][0]['vendedores'][0]['CostoDevolucion']
            .toString()
            .compareTo(
                b['users'][0]['vendedores'][0]['CostoDevolucion'].toString()));
      }
    } else {
      if (sort) {
        setState(() {
          sort = false;
        });
        data.sort((a, b) => b['attributes']['users']['data'][0]['attributes']
                ['vendedores']['data'][0]['attributes']['CostoDevolucion']
            .toString()
            .compareTo(a['attributes']['users']['data'][0]['attributes']
                    ['vendedores']['data'][0]['attributes']['CostoDevolucion']
                .toString()));
      } else {
        setState(() {
          sort = true;
        });
        data.sort((a, b) => a['attributes']['users']['data'][0]['attributes']
                ['vendedores']['data'][0]['attributes']['CostoDevolucion']
            .toString()
            .compareTo(b['attributes']['users']['data'][0]['attributes']
                    ['vendedores']['data'][0]['attributes']['CostoDevolucion']
                .toString()));
      }
    }
  }
}
