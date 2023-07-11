import 'dart:js_util';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:frontend/connections/connections.dart';
import 'package:frontend/helpers/responsive.dart';
import 'package:frontend/main.dart';
import 'package:frontend/ui/transport/delivery_status_transport/delivery_details.dart';
import 'package:frontend/ui/transport/my_orders_prv/controllers/controllers.dart';
import 'package:frontend/ui/widgets/loading.dart';
import 'package:intl/intl.dart';
import 'package:number_paginator/number_paginator.dart';

class DeliveryStatusTransport extends StatefulWidget {
  const DeliveryStatusTransport({super.key});

  @override
  State<DeliveryStatusTransport> createState() =>
      _DeliveryStatusTransportState();
}

class _DeliveryStatusTransportState extends State<DeliveryStatusTransport> {
  MyOrdersPRVTransportControllers _controllers =
      MyOrdersPRVTransportControllers();
  List allData = [];

  List data = [];
  //List<String> transporterOperators = [];

  List<DateTime?> _dates = [];
  bool sort = false;

  int total = 0;
  int entregados = 0;
  int noEntregados = 0;
  int conNovedad = 0;
  int reagendados = 0;
  int enRuta = 0;
  double totalValoresRecibidos = 0;
  double costoTransportadora = 0;
  bool isFirst = true;
  int counterLoad = 0;
  String transporterOperator = 'TODO';
  int currentPage = 1;
  int pageSize = 70;
  int pageCount = 100;
  bool isLoading = false;

  List<Map<dynamic, dynamic>> arrayFiltersAndEq = [];
  var arrayDateRanges = [];
  var arrayFiltersNotEq = [
    // {'Status': 'PEDIDO PROGRAMADO'}
  ];

  List populate = [
    'transportadora.operadores.user',
    'pedido_fecha',
    'sub_ruta',
    'operadore',
    'operadore.user',
    'users',
    'users.vendedores'
  ];
  List filtersDefaultAnd = [
    {
      'filter': 'transportadora',
      'value': sharedPrefs!.getString("idTransportadora").toString()
    }
  ];
  List filtersOrCont = [
    {'filter': 'Fecha_Entrega'},
    {'filter': 'NumeroOrden'},
    {'filter': 'NombreShipping'},
    {'filter': 'CiudadShipping'},
    {'filter': 'DireccionShipping'},
    {'filter': 'TelefonoShipping'},
    {'filter': 'Cantidad_Total'},
    {'filter': 'ProductoP'},
    {'filter': 'ProductoExtra'},
    {'filter': 'PrecioTotal'},
    {'filter': 'Observacion'},
    {'filter': 'Comentario'},
    {'filter': 'Status'},
    {'filter': 'TipoPago'},
    {'filter': 'Marca_T_D'},
    {'filter': 'Marca_T_D_L'},
    {'filter': 'Marca_T_D_T'},
    {'filter': 'Marca_T_I'},
    {'filter': 'Estado_Pagado'},
  ];

  NumberPaginatorController paginatorController = NumberPaginatorController();

  @override
  void didChangeDependencies() {
    if (_controllers.startDateController.text == "") {
      _controllers.startDateController.text = getCurrentDate();
    }

    loadData();
    super.didChangeDependencies();
  }

  loadData() async {
    isLoading = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getLoadingModal(context, false);
    });
    var response = [];
    var operators = [];
    currentPage = 1;
    response = await Connections().getOrdersForSellerStateSearchForDate(
        _controllers.searchController.text,
        filtersOrCont,
        arrayFiltersAndEq,
        arrayDateRanges,
        arrayFiltersNotEq,
        filtersDefaultAnd,
        [],
        populate);

    allData = response;
    pageCount = calcularTotalPaginas(allData.length, pageSize);
    //if (allData.isEmpty) {
    paginate();
    //}
    paginatorController.navigateToPage(0);

    updateCounters();

    Future.delayed(Duration(milliseconds: 500), () {
      Navigator.pop(context);
    });
    setState(() {});
    isFirst = false;
    isLoading = false;
  }

  loadDataNoCounts() async {
    isLoading = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getLoadingModal(context, false);
    });
    var response = [];
    var operators = [];
    currentPage = 1;
    response = await Connections().getOrdersForSellerStateSearchForDate(
        _controllers.searchController.text,
        filtersOrCont,
        arrayFiltersAndEq,
        arrayDateRanges,
        arrayFiltersNotEq,
        filtersDefaultAnd,
        [],
        populate);

    allData = response;
    pageCount = calcularTotalPaginas(allData.length, pageSize);
    //if (allData.isEmpty) {
    paginate();
    //}
    paginatorController.navigateToPage(0);

    Future.delayed(Duration(milliseconds: 500), () {
      Navigator.pop(context);
    });
    setState(() {});
    isFirst = false;
    isLoading = false;
  }

  paginateData() {
    paginate();
  }

  paginate() {
    if (allData.isNotEmpty) {
      if (currentPage == pageCount) {
        data = allData.sublist((pageSize * (currentPage - 1)), allData.length);
      } else {
        data = allData.sublist(
            (pageSize * (currentPage - 1)), (pageSize * currentPage));
      }
    } else {
      data = [];
    }
    var res = 1;
  }

  int calcularTotalPaginas(int totalRegistros, int registrosPorPagina) {
    final int totalPaginas = totalRegistros ~/ registrosPorPagina;
    final int registrosRestantes = totalRegistros % registrosPorPagina;

    return registrosRestantes > 0
        ? totalPaginas + 1
        : totalPaginas == 0
            ? 1
            : totalPaginas;
  }

  String getCurrentDate() {
    DateTime now = DateTime.now();
    String formattedDate =
        "${now.day}/${now.month}/20${now.year.toString().substring(2)}";
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    String operatorVal = transporterOperator;
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
                      child: Text(total.toString(),
                          style: TextStyle(fontSize: 10)),
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

                    loadDataNoCounts();
                  },
                  child: Chip(
                    label: Text('Entregado'),
                    backgroundColor: Colors.green,
                    labelStyle: TextStyle(color: Colors.white),
                    avatar: CircleAvatar(
                      backgroundColor: Colors.white70,
                      child: Text(entregados.toString(),
                          style: TextStyle(fontSize: 10)),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isFirst = false;
                      arrayFiltersAndEq = [];
                      arrayFiltersAndEq
                          .add({'filter': 'Status', 'value': 'NO ENTREGADO'});

                      loadDataNoCounts();
                    });
                  },
                  child: Chip(
                    label: Text('No entregado'),
                    backgroundColor: Colors.red,
                    labelStyle: TextStyle(color: Colors.white),
                    avatar: CircleAvatar(
                      backgroundColor: Colors.white70,
                      child: Text(noEntregados.toString(),
                          style: TextStyle(fontSize: 10)),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isFirst = false;
                      arrayFiltersAndEq = [];
                      arrayFiltersAndEq
                          .add({'filter': 'Status', 'value': 'NOVEDAD'});

                      loadDataNoCounts();
                    });
                  },
                  child: Chip(
                    label: Text('Novedad'),
                    backgroundColor: Color.fromARGB(255, 200, 255, 0),
                    labelStyle: TextStyle(color: Colors.white),
                    avatar: CircleAvatar(
                      backgroundColor: Colors.white70,
                      child: Text(conNovedad.toString(),
                          style: TextStyle(fontSize: 10)),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    isFirst = false;
                    setState(() {
                      arrayFiltersAndEq = [];
                      arrayFiltersAndEq
                          .add({'filter': 'Status', 'value': 'REAGENDADO'});

                      loadDataNoCounts();
                    });
                  },
                  child: Chip(
                    label: Text('Reagendado'),
                    backgroundColor: Colors.purple,
                    labelStyle: TextStyle(color: Colors.white),
                    avatar: CircleAvatar(
                      backgroundColor: Colors.white70,
                      child: Text(reagendados.toString(),
                          style: TextStyle(fontSize: 10)),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isFirst = false;
                      arrayFiltersAndEq = [];
                      arrayFiltersAndEq
                          .add({'filter': 'Status', 'value': 'EN RUTA'});

                      loadDataNoCounts();
                    });
                  },
                  child: Chip(
                    label: Text('En ruta'),
                    backgroundColor: Color.fromARGB(255, 62, 59, 232),
                    labelStyle: TextStyle(color: Colors.white),
                    avatar: CircleAvatar(
                      backgroundColor: Colors.white70,
                      child: Text(enRuta.toString(),
                          style: TextStyle(fontSize: 10)),
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
                      // boxValuesTransport(
                      //   totalValoresRecibidos: totalValoresRecibidos,
                      //   costoDeEntregas: costoTransportadora,
                      // ),
                      Expanded(child: numberPaginator()),
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
                      // boxValuesTransport(
                      //   totalValoresRecibidos: totalValoresRecibidos,
                      //   costoDeEntregas: costoTransportadora,
                      // ),
                      Expanded(child: numberPaginator()),
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
                  headingRowHeight: 83,
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
                      label: Text('Fecha'),
                      size: ColumnSize.M,
                      onSort: (columnIndex, ascending) {
                        sortFuncDate("Marca_Tiempo_Envio");
                      },
                    ),
                    DataColumn2(
                      label: Text('Fecha de Entrega'),
                      size: ColumnSize.M,
                      onSort: (columnIndex, ascending) {
                        sortFuncDate("Fecha_Entrega");
                      },
                    ),
                    DataColumn2(
                      label: Text('Código'),
                      size: ColumnSize.S,
                      onSort: (columnIndex, ascending) {
                        sortFunc("NumeroOrden");
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
                      label: Text('Observación'),
                      size: ColumnSize.M,
                      numeric: true,
                      onSort: (columnIndex, ascending) {
                        sortFunc("Observacion");
                      },
                    ),
                    DataColumn2(
                      label: Text('Comentario'),
                      size: ColumnSize.M,
                      numeric: true,
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
                      label: Text('Tipo de Pago'),
                      size: ColumnSize.M,
                      onSort: (columnIndex, ascending) {
                        sortFunc("TipoPago");
                      },
                    ),
                    DataColumn2(
                      label: Text('Sub Ruta'),
                      size: ColumnSize.M,
                      onSort: (columnIndex, ascending) {
                        sortFuncSubRoute();
                      },
                    ),
                    DataColumn2(
                      label:
                          //Column(

                          // children: [
                          const Text('Operador'),
                      // DropdownButton<String>(
                      //   value: operatorVal,
                      //   elevation: 10,
                      //   isExpanded: true,
                      //   onChanged: (String? value) {
                      //     AddFilterAndEq(value, 'operadore');
                      //     // confirmado = value!;

                      //     transporterOperator = value!;
                      //   },
                      //   items: transporterOperators
                      //       .map<DropdownMenuItem<String>>((String value) {
                      //     return DropdownMenuItem<String>(
                      //       value: value,
                      //       child: Text(value),
                      //     );
                      //   }).toList(),
                      // ),
                      //  ],
                      // ),
                      size: ColumnSize.M,
                      onSort: (columnIndex, ascending) {
                        sortFuncOperator();
                      },
                    ),
                    DataColumn2(
                      label: Text('Est. Dev'),
                      size: ColumnSize.M,
                      onSort: (columnIndex, ascending) {
                        sortFunc("Estado_Devolucion");
                      },
                    ),
                    DataColumn2(
                      label: Text('MDT. OF.'),
                      size: ColumnSize.M,
                      onSort: (columnIndex, ascending) {
                        sortFunc("Marca_T_D");
                      },
                    ),
                    DataColumn2(
                      label: Text('MDT. BOD'),
                      size: ColumnSize.M,
                      onSort: (columnIndex, ascending) {
                        sortFuncDate("Marca_T_D_L");
                      },
                    ),
                    DataColumn2(
                      label: Text('MDT. RUTA'),
                      size: ColumnSize.M,
                      onSort: (columnIndex, ascending) {
                        sortFuncDate("Marca_T_D_T");
                      },
                    ),
                    DataColumn2(
                      label: Text('MTD. INP'),
                      size: ColumnSize.M,
                      onSort: (columnIndex, ascending) {
                        sortFuncDate("Marca_T_I");
                      },
                    ),
                    DataColumn2(
                      label: Text('Estado de Pago'),
                      size: ColumnSize.M,
                      onSort: (columnIndex, ascending) {
                        sortFunc("Estado_Pagado");
                      },
                    ),
                  ],
                  rows: List<DataRow>.generate(
                      data.isNotEmpty ? data.length : [].length,
                      (index) => DataRow(cells: [
                            DataCell(
                                Text(data[index]['attributes']
                                        ['Marca_Tiempo_Envio']
                                    .toString()
                                    .split(" ")[0]), onTap: () {
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
                                                child:
                                                    TransportProDeliveryHistoryDetails(
                                              id: data[index]['id'].toString(),
                                            ))
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            }),
                            DataCell(
                                Text(data[index]['attributes']['Fecha_Entrega']
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
                                                child:
                                                    TransportProDeliveryHistoryDetails(
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
                                                child:
                                                    TransportProDeliveryHistoryDetails(
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
                                                child:
                                                    TransportProDeliveryHistoryDetails(
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
                                                child:
                                                    TransportProDeliveryHistoryDetails(
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
                                                child:
                                                    TransportProDeliveryHistoryDetails(
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
                                                child:
                                                    TransportProDeliveryHistoryDetails(
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
                                                child:
                                                    TransportProDeliveryHistoryDetails(
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
                                                child:
                                                    TransportProDeliveryHistoryDetails(
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
                                                child:
                                                    TransportProDeliveryHistoryDetails(
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
                                                child:
                                                    TransportProDeliveryHistoryDetails(
                                              id: data[index]['id'].toString(),
                                            ))
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            }),
                            DataCell(
                                Text(data[index]['attributes']['Observacion']
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
                                                child:
                                                    TransportProDeliveryHistoryDetails(
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
                                                child:
                                                    TransportProDeliveryHistoryDetails(
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
                                                child:
                                                    TransportProDeliveryHistoryDetails(
                                              id: data[index]['id'].toString(),
                                            ))
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            }),
                            DataCell(
                                Text(data[index]['attributes']['TipoPago']
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
                                                child:
                                                    TransportProDeliveryHistoryDetails(
                                              id: data[index]['id'].toString(),
                                            ))
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            }),
                            DataCell(
                                Text(data[index]['attributes']['sub_ruta'] !=
                                        null
                                    ? data[index]['attributes']['sub_ruta']
                                            ['Titulo']
                                        .toString()
                                    : ""), onTap: () {
                              ShowDialogMessage(context, index);
                            }),
                            DataCell(
                                Text(data[index]['attributes']['operadore'] !=
                                        null
                                    ? data[index]['attributes']['operadore']
                                        ['user']['username']
                                    : "".toString()), onTap: () {
                              ShowDialogMessage(context, index);
                            }),
                            DataCell(
                                Text(data[index]['attributes']
                                        ['Estado_Devolucion']
                                    .toString()), onTap: () {
                              ShowDialogMessage(context, index);
                            }),
                            DataCell(
                                Text(data[index]['attributes']['Marca_T_D']
                                    .toString()), onTap: () {
                              ShowDialogMessage(context, index);
                            }),
                            DataCell(
                                Text(data[index]['attributes']['Marca_T_D_L']
                                    .toString()), onTap: () {
                              ShowDialogMessage(context, index);
                            }),
                            DataCell(
                                Text(data[index]['attributes']['Marca_T_D_T']
                                    .toString()), onTap: () {
                              ShowDialogMessage(context, index);
                            }),
                            DataCell(
                                Text(data[index]['attributes']['Marca_T_I']
                                    .toString()), onTap: () {
                              ShowDialogMessage(context, index);
                            }),
                            DataCell(
                                Text(data[index]['attributes']['Estado_Pagado']
                                    .toString()), onTap: () {
                              ShowDialogMessage(context, index);
                            }),
                          ]))),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> ShowDialogMessage(BuildContext context, int index) {
    return showDialog(
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
                      child: TransportProDeliveryHistoryDetails(
                    id: data[index]['id'].toString(),
                  ))
                ],
              ),
            ),
          );
        });
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
                    getLoadingModal(context, false);
                    setState(() {
                      _controllers.searchController.clear();
                    });

                    setState(() {
                      loadData();
                    });
                    Navigator.pop(context);
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

  sortFuncOperator() {
    if (sort) {
      setState(() {
        sort = false;
      });
      data.sort((a, b) => b['attributes']['operadore']['data']['attributes']
              ['user']['data']['attributes']['username']
          .toString()
          .compareTo(a['attributes']['operadore']['data']['attributes']['user']
                  ['data']['attributes']['username']
              .toString()));
    } else {
      setState(() {
        sort = true;
      });
      data.sort((a, b) => a['attributes']['operadore']['data']['attributes']
              ['user']['data']['attributes']['username']
          .toString()
          .compareTo(b['attributes']['operadore']['data']['attributes']['user']
                  ['data']['attributes']['username']
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

  Future<void> applyDateFilter() async {
    isFirst = true;
    arrayDateRanges = [];
    arrayFiltersAndEq = [];
    _controllers.searchController.text = '';
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
    }
    arrayDateRanges.add({
      'body_param': 'start',
      'value': _controllers.startDateController.text != ""
          ? _controllers.startDateController.text
          : '1/1/1991'
    });

    arrayDateRanges.add({
//        'filter': 'Fecha_Entrega',
      'body_param': 'end',
      'value': _controllers.endDateController.text != ""
          ? _controllers.endDateController.text
          : '1/1/2200'
    });

    await loadData();
    // calculateValues();
    isFirst = false;
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

  updateCounters() {
    total = 0;
    entregados = 0;
    noEntregados = 0;
    conNovedad = 0;
    reagendados = 0;
    enRuta = 0;
    total = allData.length;
    // print(data.toString());
    for (var element in allData) {
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

  AddFilterAndEq(value, filtro) {
    setState(() {
      if (value != 'TODO') {
        bool contains = false;

        for (var filter in arrayFiltersAndEq) {
          if (filter['filter'] == filtro) {
            contains = true;
            break;
          }
        }
        if (contains == false) {
          arrayFiltersAndEq.add({
            'filter': filtro,
            'value': {
              'user': {'username': value}
            }
          });
        } else {
          for (var filter in arrayFiltersAndEq) {
            if (filter['filter'] == filtro) {
              filter['value'] = {
                'user': {'username': value}
              };
              break;
            }
          }
        }
      } else {
        for (var filter in arrayFiltersAndEq) {
          if (filter['filter'] == filtro) {
            arrayFiltersAndEq.remove(filter);
            break;
          }
        }
      }
    });
    loadData();
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

  calculateValues() {
    totalValoresRecibidos = 0;
    costoTransportadora = 0;

    for (var element in data) {
      // if (element['id'] == 567) {
      //   print('hello');
      // }
      // var test =
      //     element['attributes']['users'][0]['vendedores'][0]['CostoEnvio'];
      // print("aqui esta el test" + test);
      // var m = 2;
      element['attributes']['PrecioTotal'] =
          element['attributes']['PrecioTotal'].replaceAll(',', '.');
      if (element['attributes']['users'][0]['vendedores'][0]['CostoEnvio'] !=
          null) {
        element['attributes']['users'][0]['vendedores'][0]['CostoEnvio'] =
            element['attributes']['users'][0]['vendedores'][0]['CostoEnvio']
                .replaceAll(',', '.');
      } else {
        element['attributes']['users'][0]['vendedores'][0]['CostoEnvio'] = 0;
      }

      if (element['attributes']['users'][0]['vendedores'][0]
              ['CostoDevolucion'] !=
          null) {
        element['attributes']['users'][0]['vendedores'][0]['CostoDevolucion'] =
            element['attributes']['users'][0]['vendedores'][0]
                    ['CostoDevolucion']
                .replaceAll(',', '.');
      } else {
        element['attributes']['users'][0]['vendedores'][0]['CostoDevolucion'] =
            0;
      }

      if (element['attributes']['Status'] == 'ENTREGADO') {
        totalValoresRecibidos +=
            double.parse(element['attributes']['PrecioTotal']);
      }

      if (element['attributes']['Status'] == 'ENTREGADO' ||
          element['attributes']['Status'] == 'NO ENTREGADO') {
        costoTransportadora += double.parse(element['attributes']
                ['transportadora']['Costo_Transportadora'] ??
            0);
      }
    }
  }

  NumberPaginator numberPaginator() {
    return NumberPaginator(
      config: NumberPaginatorUIConfig(
        buttonShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5), // Customize the button shape
        ),
      ),
      controller: paginatorController,
      numberPages: pageCount > 0 ? pageCount : 1,
      // initialPage: 0,
      onPageChange: (index) async {
        //  print("indice="+index.toString());
        setState(() {
          currentPage = index + 1;
        });
        if (!isLoading) {
          await paginateData();
        }
      },
    );
  }

  sortFuncSubRoute() {
    if (sort) {
      setState(() {
        sort = false;
      });
      data.sort((a, b) => b['attributes']['sub_ruta']['data']['attributes']
              ['Titulo']
          .toString()
          .compareTo(a['attributes']['sub_ruta']['data']['attributes']['Titulo']
              .toString()));
    } else {
      setState(() {
        sort = true;
      });
      data.sort((a, b) => a['attributes']['sub_ruta']['data']['attributes']
              ['Titulo']
          .toString()
          .compareTo(b['attributes']['sub_ruta']['data']['attributes']['Titulo']
              .toString()));
    }
  }
}
