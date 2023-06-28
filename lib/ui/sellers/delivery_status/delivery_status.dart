import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:frontend/connections/connections.dart';
import 'package:frontend/helpers/responsive.dart';
import 'package:frontend/main.dart';
import 'package:frontend/ui/sellers/delivery_status/info_delivery.dart';
import 'package:frontend/ui/transport/my_orders_prv/controllers/controllers.dart';
import 'package:frontend/ui/widgets/loading.dart';
import 'package:intl/intl.dart';

class DeliveryStatus extends StatefulWidget {
  const DeliveryStatus({super.key});

  @override
  State<DeliveryStatus> createState() => _DeliveryStatusState();
}

class _DeliveryStatusState extends State<DeliveryStatus> {
  MyOrdersPRVTransportControllers _controllers =
      MyOrdersPRVTransportControllers();
  List data = [];
  List<DateTime?> _dates = [];
  bool sort = false;
  int total = 0;
  int entregados = 0;
  int noEntregados = 0;
  int conNovedad = 0;
  int reagendados = 0;
  int enRuta = 0;
  double totalValoresRecibidos = 0;
  double costoDeEntregas = 0;
  double devoluciones = 0;
  double utilidad = 0;
  bool isFirst = true;
  int counterLoad = 0;
  var arrayFiltersAndEq = [];
  var arraysFiltersRanges = [];
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  @override
  void didChangeDependencies() {
    loadData();
    super.didChangeDependencies();
  }

  loadData() async {
    var response = [];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getLoadingModal(context, false);
    });

    if (_controllers.searchController.text.isEmpty &&
        arraysFiltersRanges.isEmpty) {
      response = await Connections()
          .getOrdersForSellerState(_controllers.searchController.text);
    } else {
      response = await Connections().getOrdersForSellerStateSearch(
          _controllers.searchController.text,
          [
            {'filter': 'NumeroOrden'},
            {'filter': 'Fecha_Entrega'},
            {'filter': 'CiudadShipping'},
            {'filter': 'NombreShipping'},
            {'filter': 'DireccionShipping'},
            {'filter': 'TelefonoShipping'},
            {'filter': 'Cantidad_Total'},
            {'filter': 'ProductoP'},
            {'filter': 'ProductoExtra'},
            {'filter': 'PrecioTotal'},
            {'filter': 'Comentario'},
            {'filter': 'Status'},
            {'filter': 'Estado_Interno'},
            {'filter': 'Estado_Logistico'},
            {'filter': 'Estado_Devolucion'},
            {'filter': 'Marca_T_I'},
          ],
          arrayFiltersAndEq,
          arraysFiltersRanges);
    }

    data = response;
    //calculateValues();
    // print(data);
    if (arrayFiltersAndEq.length == 0) {
      // print('arreglo de est' + arrayFiltersAndEq.length.toString());

      updateCounters();
    }
    Future.delayed(Duration(milliseconds: 500), () {
      Navigator.pop(context);
    });
    setState(() {
      counterLoad++;
    });
    if (counterLoad <= 1) {
      _controllers.startDateController.text =
          sharedPrefs!.getString("dateOperatorState")!;
    }
  }

  updateCounters() {
    if (isFirst) {
      total = 0;
      entregados = 0;
      noEntregados = 0;
      conNovedad = 0;
      reagendados = 0;
      enRuta = 0;
      total = data.length;
      // print(data.toString());
      for (var element in data) {
        element['attributes']['Status'];
        switch (element['attributes']['Status']) {
          case 'ENTREGADO':
            entregados++;
            break;

          case 'NO ENTREGADO':
            noEntregados++;
            break;

          case 'NOVEDAD':
            conNovedad++;
            break;
          case 'REAGENDADO':
            reagendados++;
            break;
          case 'EN RUTA':
            enRuta++;
            break;

          default:
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(15),
        color: Colors.grey[100],
        child: Column(
          children: [
            Wrap(
              alignment: WrapAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isFirst = false;
                      arrayFiltersAndEq = [];
                    });

                    loadData();
                  },
                  child: Chip(
                    label: Text('Total'),
                    backgroundColor: const Color.fromARGB(255, 31, 32, 32),
                    labelStyle: TextStyle(color: Colors.white),
                    avatar: CircleAvatar(
                      backgroundColor: Colors.white70,
                      child: Text(total.toString()),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isFirst = false;
                      arrayFiltersAndEq = [];
                      arrayFiltersAndEq
                          .add({'filter': 'Status', 'value': 'ENTREGADO'});
                    });

                    loadData();
                  },
                  child: Chip(
                    label: Text('Entregado'),
                    backgroundColor: Colors.green,
                    labelStyle: TextStyle(color: Colors.white),
                    avatar: CircleAvatar(
                      backgroundColor: Colors.white70,
                      child: Text(entregados.toString()),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      arrayFiltersAndEq = [];
                      arrayFiltersAndEq
                          .add({'filter': 'Status', 'value': 'NO ENTREGADO'});

                      loadData();
                    });
                  },
                  child: Chip(
                    label: Text('No entregado'),
                    backgroundColor: Colors.red,
                    labelStyle: TextStyle(color: Colors.white),
                    avatar: CircleAvatar(
                      backgroundColor: Colors.white70,
                      child: Text(noEntregados.toString()),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      arrayFiltersAndEq = [];
                      arrayFiltersAndEq
                          .add({'filter': 'Status', 'value': 'NOVEDAD'});

                      loadData();
                    });
                  },
                  child: Chip(
                    label: Text('Novedad'),
                    backgroundColor: Color.fromARGB(255, 200, 255, 0),
                    labelStyle: TextStyle(color: Colors.white),
                    avatar: CircleAvatar(
                      backgroundColor: Colors.white70,
                      child: Text(conNovedad.toString()),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      arrayFiltersAndEq = [];
                      arrayFiltersAndEq
                          .add({'filter': 'Status', 'value': 'REAGENDADO'});

                      loadData();
                    });
                  },
                  child: Chip(
                    label: Text('Reagendado'),
                    backgroundColor: Colors.purple,
                    labelStyle: TextStyle(color: Colors.white),
                    avatar: CircleAvatar(
                      backgroundColor: Colors.white70,
                      child: Text(reagendados.toString()),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      arrayFiltersAndEq = [];
                      arrayFiltersAndEq
                          .add({'filter': 'Status', 'value': 'EN RUTA'});

                      loadData();
                    });
                  },
                  child: Chip(
                    label: Text('En ruta'),
                    backgroundColor: Color.fromARGB(255, 62, 59, 232),
                    labelStyle: TextStyle(color: Colors.white),
                    avatar: CircleAvatar(
                      backgroundColor: Colors.white70,
                      child: Text(enRuta.toString()),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: EdgeInsets.only(top: 5, bottom: 5),
              child: responsive(
                  Row(
                    children: [
                      Expanded(
                        child: _modelTextField(
                            text: "Buscar",
                            controller: _controllers.searchController),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.only(left: 15, right: 5),
                              child: responsive(
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: fechaFinFechaIni(),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: fechaFinFechaIni(),
                                  ),
                                  context),
                            ),
                          ],
                        ),
                      ),
                      boxValues(
                          totalValoresRecibidos: totalValoresRecibidos,
                          costoDeEntregas: costoDeEntregas,
                          devoluciones: devoluciones,
                          utilidad: utilidad),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        child: _modelTextField(
                            text: "Buscar",
                            controller: _controllers.searchController),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 15, right: 5),
                            child: responsive(
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: fechaFinFechaIni(),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: fechaFinFechaIni(),
                              ),
                              context,
                            ),
                          ),
                        ],
                      ),
                      boxValues(
                          totalValoresRecibidos: totalValoresRecibidos,
                          costoDeEntregas: costoDeEntregas,
                          devoluciones: devoluciones,
                          utilidad: utilidad),
                    ],
                  ),
                  context),
            ),
            Expanded(
              child: DataTable2(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    border: Border.all(color: Colors.blueGrey),
                  ),
                  headingTextStyle: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                  dataTextStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  columnSpacing: 12,
                  horizontalMargin: 12,
                  minWidth: 2500,
                  columns: [
                    DataColumn2(
                      label: Text('Fecha de Entrega'),
                      size: ColumnSize.M,
                      onSort: (columnIndex, ascending) {
                        sortFuncDate("Fecha_Entrega");
                      },
                    ),
                    DataColumn2(
                      label: const Text('Código'),
                      size: ColumnSize.S,
                      onSort: (columnIndex, ascending) {
                        sortFunc("NumeroOrden");
                      },
                    ),
                    DataColumn2(
                      label: const Text('Ciudad'),
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
                      label: Text('Teléfono Cliente'),
                      size: ColumnSize.M,
                      onSort: (columnIndex, ascending) {
                        sortFunc("TelefonoShipping");
                      },
                    ),
                    DataColumn2(
                      label: Text('Cantidad'),
                      size: ColumnSize.M,
                      numeric: true,
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
                      numeric: true,
                      onSort: (columnIndex, ascending) {
                        sortFunc("PrecioTotal");
                      },
                    ),
                    DataColumn2(
                      label: Text('Comentario'),
                      size: ColumnSize.M,
                      onSort: (columnIndex, ascending) {
                        sortFunc("Comentario");
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
                      label: Text('Confirmado'),
                      size: ColumnSize.M,
                      onSort: (columnIndex, ascending) {
                        sortFunc("Estado_Interno");
                      },
                    ),
                    DataColumn2(
                      label: Text('Estado Logístico'),
                      size: ColumnSize.M,
                      onSort: (columnIndex, ascending) {
                        sortFunc("Estado_Logistico");
                      },
                    ),
                    DataColumn2(
                      label: Text('Estado Devolución'),
                      size: ColumnSize.M,
                      onSort: (columnIndex, ascending) {
                        sortFunc("Estado_Devolucion");
                      },
                    ),
                    DataColumn2(
                      label: Text('Costo Entrega'),
                      size: ColumnSize.S,
                      onSort: (columnIndex, ascending) {
                        sortFuncCost("CostoEnvio");
                      },
                    ),
                    DataColumn2(
                      label: Text('Costo Devolución'),
                      size: ColumnSize.S,
                      onSort: (columnIndex, ascending) {
                        sortFuncCost("CostoDevolucion");
                      },
                    ),
                    DataColumn2(
                      label: Text('Fecha Ingreso'),
                      size: ColumnSize.M,
                      onSort: (columnIndex, ascending) {
                        sortFuncDate("Marca_T_I");
                      },
                    ),
                  ],
                  rows: List<DataRow>.generate(
                      data.isNotEmpty ? data.length : [].length,
                      (index) => DataRow(cells: [
                            DataCell(
                                Row(
                                  children: [
                                    Text(data[index]['attributes']
                                            ['Fecha_Entrega']
                                        .toString()),
                                    data[index]['attributes']['Status'] ==
                                                'NOVEDAD' &&
                                            data[index]['attributes']
                                                    ['Estado_Devolucion'] ==
                                                'PENDIENTE'
                                        ? IconButton(
                                            icon: Icon(Icons.schedule_outlined),
                                            onPressed: () async {
                                              reSchedule(data[index]['id'],
                                                  'REAGENDADO');
                                            },
                                          )
                                        : Container(),
                                  ],
                                ), onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height,
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
                                                child: DeliveryStatusSellerInfo(
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
                                    style: TextStyle(
                                        color: GetColor(data[index]
                                                ['attributes']['Status']
                                            .toString())!),
                                    '${data[index]['attributes']['Name_Comercial'].toString()}-${data[index]['attributes']['NumeroOrden'].toString()}'),
                                onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height,
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
                                                child: DeliveryStatusSellerInfo(
                                              id: data[index]['id'].toString(),
                                            ))
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            }),
                            DataCell(
                                Text(data[index]['attributes']['CiudadShipping']
                                    .toString()), onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height,
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
                                                child: DeliveryStatusSellerInfo(
                                              id: data[index]['id'].toString(),
                                            ))
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            }),
                            DataCell(
                                Text(data[index]['attributes']['NombreShipping']
                                    .toString()), onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height,
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
                                                child: DeliveryStatusSellerInfo(
                                              id: data[index]['id'].toString(),
                                            ))
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            }),
                            DataCell(
                                Text(data[index]['attributes']
                                        ['DireccionShipping']
                                    .toString()), onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height,
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
                                                child: DeliveryStatusSellerInfo(
                                              id: data[index]['id'].toString(),
                                            ))
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            }),
                            DataCell(
                                Text(data[index]['attributes']
                                        ['TelefonoShipping']
                                    .toString()), onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height,
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
                                                child: DeliveryStatusSellerInfo(
                                              id: data[index]['id'].toString(),
                                            ))
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            }),
                            DataCell(
                                Text(data[index]['attributes']['Cantidad_Total']
                                    .toString()), onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height,
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
                                                child: DeliveryStatusSellerInfo(
                                              id: data[index]['id'].toString(),
                                            ))
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            }),
                            DataCell(
                                Text(data[index]['attributes']['ProductoP']
                                    .toString()), onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height,
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
                                                child: DeliveryStatusSellerInfo(
                                              id: data[index]['id'].toString(),
                                            ))
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            }),
                            DataCell(
                                Text(data[index]['attributes']['ProductoExtra']
                                    .toString()), onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height,
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
                                                child: DeliveryStatusSellerInfo(
                                              id: data[index]['id'].toString(),
                                            ))
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            }),
                            DataCell(
                                Text(data[index]['attributes']['PrecioTotal']
                                    .toString()), onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height,
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
                                                child: DeliveryStatusSellerInfo(
                                              id: data[index]['id'].toString(),
                                            ))
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            }),
                            DataCell(
                                Text(data[index]['attributes']['Comentario']
                                    .toString()), onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height,
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
                                                child: DeliveryStatusSellerInfo(
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
                                    style: TextStyle(
                                        color: GetColor(data[index]
                                                ['attributes']['Status']
                                            .toString())!),
                                    data[index]['attributes']['Status']
                                        .toString()), onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height,
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
                                                child: DeliveryStatusSellerInfo(
                                              id: data[index]['id'].toString(),
                                            ))
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            }),
                            DataCell(
                                Text(data[index]['attributes']['Estado_Interno']
                                    .toString()), onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height,
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
                                                child: DeliveryStatusSellerInfo(
                                              id: data[index]['id'].toString(),
                                            ))
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            }),
                            DataCell(
                                Text(data[index]['attributes']
                                        ['Estado_Logistico']
                                    .toString()), onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height,
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
                                                child: DeliveryStatusSellerInfo(
                                              id: data[index]['id'].toString(),
                                            ))
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            }),
                            DataCell(
                                Text(data[index]['attributes']
                                        ['Estado_Devolucion']
                                    .toString()), onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height,
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
                                                child: DeliveryStatusSellerInfo(
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
                                    ? data[index]['attributes']['Status']
                                                    .toString() ==
                                                "ENTREGADO" ||
                                            data[index]['attributes']['Status']
                                                    .toString() ==
                                                "NO ENTREGADO"
                                        ? data[index]['attributes']['users']
                                                            ['data'][0]
                                                        ['attributes']
                                                    ['vendedores']['data'][0]
                                                ['attributes']['CostoEnvio']
                                            .toString()
                                        : ""
                                    : ""), onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height,
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
                                                child: DeliveryStatusSellerInfo(
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
                                    ? data[index]['attributes']['Status'].toString() ==
                                            "NOVEDAD"
                                        ? data[index]['attributes']['Estado_Devolucion']
                                                        .toString() ==
                                                    "ENTREGADO EN OFICINA" ||
                                                data[index]['attributes']['Status']
                                                        .toString() ==
                                                    "EN RUTA" ||
                                                data[index]['attributes']['Estado_Devolucion']
                                                        .toString() ==
                                                    "EN BODEGA"
                                            ? data[index]['attributes']['users']
                                                            ['data'][0]['attributes']
                                                        ['vendedores']['data'][0]
                                                    ['attributes']['CostoDevolucion']
                                                .toString()
                                            : ""
                                        : ""
                                    : ""), onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height,
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
                                                child: DeliveryStatusSellerInfo(
                                              id: data[index]['id'].toString(),
                                            ))
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            }),
                            DataCell(
                                Text(data[index]['attributes']['Marca_T_I']
                                    .toString()), onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height,
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
                                                child: DeliveryStatusSellerInfo(
                                              id: data[index]['id'].toString(),
                                            ))
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            }),
                          ]))),
            ),
          ],
        ),
      ),
    );
  }

  sortFuncCost(name) {
    if (sort) {
      setState(() {
        sort = false;
      });
      data.sort((a, b) => b['attributes']['users']['data'][0]['attributes']
              ['vendedores']['data'][0]['attributes']['$name']
          .toString()
          .compareTo(a['attributes']['users']['data'][0]['attributes']
                  ['vendedores']['data'][0]['attributes']['$name']
              .toString()));
    } else {
      setState(() {
        sort = true;
      });
      data.sort((a, b) => a['attributes']['users']['data'][0]['attributes']
              ['vendedores']['data'][0]['attributes']['$name']
          .toString()
          .compareTo(b['attributes']['users']['data'][0]['attributes']
                  ['vendedores']['data'][0]['attributes']['$name']
              .toString()));
    }
  }

  sortFuncDate(name) {
    if (sort) {
      setState(() {
        sort = false;
      });
      data.sort((a, b) {
        DateTime? dateA = a['attributes'][name] != null &&
                a['attributes'][name].toString().isNotEmpty
            ? DateFormat("d/M/yyyy").parse(a['attributes'][name].toString())
            : null;
        DateTime? dateB = b['attributes'][name] != null &&
                b['attributes'][name].toString().isNotEmpty
            ? DateFormat("d/M/yyyy").parse(b['attributes'][name].toString())
            : null;
        if (dateA == null && dateB == null) {
          return 0;
        } else if (dateA == null) {
          return 1;
        } else if (dateB == null) {
          return -1;
        } else {
          return dateB.compareTo(dateA);
        }
      });
    } else {
      setState(() {
        sort = true;
      });
      data.sort((a, b) {
        DateTime? dateA = a['attributes'][name] != null &&
                a['attributes'][name].toString().isNotEmpty
            ? DateFormat("d/M/yyyy").parse(a['attributes'][name].toString())
            : null;
        DateTime? dateB = b['attributes'][name] != null &&
                b['attributes'][name].toString().isNotEmpty
            ? DateFormat("d/M/yyyy").parse(b['attributes'][name].toString())
            : null;
        if (dateA == null && dateB == null) {
          return 0;
        } else if (dateA == null) {
          return -1;
        } else if (dateB == null) {
          return 1;
        } else {
          return dateA.compareTo(dateB);
        }
      });
    }
  }

  _modelTextField({text, controller}) {
    setState(() {
      isFirst = true;
    });
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Color.fromARGB(255, 245, 244, 244),
      ),
      child: TextField(
        controller: controller,
        onSubmitted: (value) {
          arrayFiltersAndEq = [];
          loadData();
        },
        onChanged: (value) {
          setState(() {});
        },
        style: TextStyle(fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          fillColor: Colors.grey[500],
          prefixIcon: Icon(Icons.search),
          suffixIcon: _controllers.searchController.text.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      _controllers.searchController.clear();
                    });
                  },
                  child: Icon(Icons.close))
              : null,
          hintText: text,
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
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

  bool compareDates(String string1, String string2) {
    List<String> parts1 = string1.split('/');
    List<String> parts2 = string2.split('/');

    int day1 = int.parse(parts1[0]);
    int month1 = int.parse(parts1[1]);
    int year1 = int.parse(parts1[2]);

    int day2 = int.parse(parts2[0]);
    int month2 = int.parse(parts2[1]);
    int year2 = int.parse(parts2[2]);

    if (year1 > year2) {
      return true;
    } else if (year1 < year2) {
      return false;
    } else {
      if (month1 > month2) {
        return true;
      } else if (month1 < month2) {
        return false;
      } else {
        if (day1 > day2) {
          return true;
        } else {
          return false;
        }
      }
    }
  }

  Color? GetColor(state) {
    int color = 0xFF000000;

    switch (state) {
      case "ENTREGADO":
        color = 0xFF33FF6D;
        break;
      case "NOVEDAD":
        color = 0xFFD6DC27;
        break;
      case "NO ENTREGADO":
        color = 0xFFFF3333;
        break;
      case "REAGENDADO":
        color = 0xFFFA37BF;
        break;
      case "EN RUTA":
        color = 0xFF3341FF;
        break;
      case "EN OFICINA":
        color = 0xFF4B4C4B;
        break;

      default:
        color = 0xFF000000;
    }

    return Color(color);
  }

  Future<void> applyDateFilter() async {
    arraysFiltersRanges = [];
    if (_controllers.startDateController.text != '' &&
        _controllers.endDateController.text != '') {
      if (compareDates(_controllers.startDateController.text,
          _controllers.endDateController.text)) {
        var aux = _controllers.endDateController.text;

        setState(() {
          _controllers.endDateController.text =
              _controllers.startDateController.text;

          _controllers.startDateController.text = aux;
        });
      }
    } else {
      arraysFiltersRanges
          .add({'filter': 'Fecha_Entrega', 'operator': '\$ne', 'value': ''});
    }
    if (_controllers.startDateController.text != '') {
      arraysFiltersRanges.add({
        'filter': 'Fecha_Entrega',
        'operator': '\$gte',
        'value': _controllers.startDateController.text
      });
    }
    if (_controllers.endDateController.text != '') {
      arraysFiltersRanges.add({
        'filter': 'Fecha_Entrega',
        'operator': '\$lte',
        'value': _controllers.endDateController.text
      });
    }
    await loadData();
    calculateValues();
  }

  calculateValues() {
    totalValoresRecibidos = 0;
    costoDeEntregas = 0;
    devoluciones = 0;
    for (var element in data) {
      // print(element['attributes']['PrecioTotal']);
      if (element['attributes']['Status'] == 'ENTREGADO') {
        totalValoresRecibidos +=
            double.parse(element['attributes']['PrecioTotal']);
      }

      if (element['attributes']['Status'] == 'ENTREGADO' ||
          element['attributes']['Status'] == 'NO ENTREGADO') {
        costoDeEntregas += double.parse(element['attributes']['users']['data']
                        [0]['attributes']['vendedores']['data'][0]['attributes']
                    ['CostoEnvio'] !=
                null
            ? element['attributes']['users']['data'][0]['attributes']
                ['vendedores']['data'][0]['attributes']['CostoEnvio']
            : 0);
      }
      if (element['attributes']['Status'] == 'NOVEDAD' &&
          element['attributes']['Estado_Devolucion'] != 'PENDIENTE') {
        devoluciones += double.parse(element['attributes']['users']['data'][0]
                ['attributes']['vendedores']['data'][0]['attributes']
            ['CostoDevolucion']);
      }
    }
    utilidad = totalValoresRecibidos - costoDeEntregas - devoluciones;
  }

  Future<String> OpenCalendar() async {
    String nuevaFecha = "";

    var results = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        dayTextStyle: TextStyle(fontWeight: FontWeight.bold),
        yearTextStyle: TextStyle(fontWeight: FontWeight.bold),
        selectedYearTextStyle: TextStyle(fontWeight: FontWeight.bold),
        weekdayLabelTextStyle: TextStyle(fontWeight: FontWeight.bold),
      ),
      dialogSize: const Size(325, 400),
      value: _dates,
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

        nuevaFecha = "$dia/$mes/$anio";
      }
    });
    return nuevaFecha;
  }

  fechaFinFechaIni() {
    return [
      Row(
        children: [
          const Text('Desde:'),
          Text(_controllers.startDateController.text),
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () async {
              _controllers.startDateController.text = await OpenCalendar();
              _focusNode2.requestFocus();
            },
          ),
          const SizedBox(
            width: 5,
          ),
          const Text('Hasta:'),
          Text(
            _controllers.endDateController.text,
          ),
          IconButton(
            icon: Icon(Icons.calendar_month),
            onPressed: () async {
              _controllers.endDateController.text = await OpenCalendar();
            },
          ),
        ],
      ),
      ElevatedButton(
          onPressed: () async {
            await applyDateFilter();
          },
          child: Text('Fitrar'))
    ];
  }

  Future<void> reSchedule(id, estado) async {
    var fecha = await OpenCalendar();
    print(fecha);

    confirmDialog(id, estado, fecha);
  }

  confirmDialog(id, estado, fecha) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor:
              Colors.transparent, // Establece el fondo transparente

          child: Container(
            width: 400.0, // Ancho deseado para el AlertDialog
            height: 300.0,
            child: AlertDialog(
              title: Text('Ateneción'),
              content: Column(
                children: [
                  Text('Se reagendará esta entrega para $fecha'),
                ],
              ),
              actions: [
                TextButton(
                  child: const Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Continuar'),
                  onPressed: () async {
                    await Connections()
                        .updateDateDeliveryAndState(id, fecha, estado);
                    loadData();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class boxValues extends StatelessWidget {
  const boxValues({
    super.key,
    required this.totalValoresRecibidos,
    required this.costoDeEntregas,
    required this.devoluciones,
    required this.utilidad,
  });

  final double totalValoresRecibidos;
  final double costoDeEntregas;
  final double devoluciones;
  final double utilidad;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          padding: EdgeInsets.all(3),
          width: 100,
          decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          child: Column(
            children: [
              const Text(
                'Valores recibidos:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  color: Colors.black,
                ),
              ),
              Text(
                '\$${totalValoresRecibidos.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(3),
          width: 100,
          decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          child: Column(
            children: [
              const Text(
                'Costo de envío:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  color: Colors.black,
                ),
              ),
              Text(
                '\$${costoDeEntregas.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(3),
          width: 100,
          decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          child: Column(
            children: [
              const Text(
                'Devoluciones:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  color: Colors.black,
                ),
              ),
              Text(
                '\$${devoluciones.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(3),
          width: 100,
          decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          child: Column(
            children: [
              const Text(
                'Utilidad:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  color: Colors.black,
                ),
              ),
              Text(
                '\$${utilidad.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
