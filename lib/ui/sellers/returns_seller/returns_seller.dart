import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:frontend/config/exports.dart';
import 'package:frontend/connections/connections.dart';
import 'package:frontend/ui/logistic/income_and_expenses/controllers/controllers.dart';
import 'package:frontend/ui/logistic/returns/controllers/controllers.dart';
import 'package:frontend/ui/utils/utils.dart';
import 'package:frontend/ui/widgets/loading.dart';
import 'package:frontend/helpers/navigators.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import 'controllers/controllers.dart';

class ReturnsSeller extends StatefulWidget {
  const ReturnsSeller({super.key});

  @override
  State<ReturnsSeller> createState() => _ReturnsSellerState();
}

class _ReturnsSellerState extends State<ReturnsSeller> {
  final ReturnsControllers _controllers = ReturnsControllers();
  List data = [];
  List dataTemporal = [];
  bool sort = false;

  String option = "";
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
    "Devolución"
  ];
  loadData() async {
    var response = [];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getLoadingModal(context, false);
    });

    response = await Connections()
        .getOrdersForReturnsSellers(_controllers.searchController.text);
    data = response;
    dataTemporal = response;

    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.pop(context);
    });
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    loadData();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: _modelTextField(
                  text: "Búsqueda", controller: _controllers.searchController),
            ),
            _filters(context),
            Expanded(
              child: DataTable2(
                headingTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                dataTextStyle:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
                columnSpacing: 12,
                horizontalMargin: 6,
                minWidth: 2000,
                showCheckboxColumn: false,
                columns: [
                  DataColumn2(
                    label: Text('Fecha'),
                    size: ColumnSize.M,
                    onSort: (columnIndex, ascending) {
                      sortFuncDate("Fecha_Entrega");
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
                    label: Text('Nombre Cliente'),
                    size: ColumnSize.M,
                    onSort: (columnIndex, ascending) {
                      sortFunc("NombreShipping");
                    },
                  ),
                  DataColumn2(
                    label: Text('Detalle'),
                    size: ColumnSize.L,
                    onSort: (columnIndex, ascending) {
                      sortFunc("DireccionShipping");
                    },
                  ),
                  DataColumn2(
                    label: Text('Teléfono'),
                    numeric: true,
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
                    size: ColumnSize.L,
                    onSort: (columnIndex, ascending) {
                      sortFunc("ProductoP");
                    },
                  ),
                  DataColumn2(
                    label: Text('Producto Extra'),
                    size: ColumnSize.L,
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
                    label: Text('Status'),
                    size: ColumnSize.S,
                    onSort: (columnIndex, ascending) {
                      sortFunc("Status");
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
                    label: Text('Marca Fecha Confirmación'),
                    size: ColumnSize.M,
                    onSort: (columnIndex, ascending) {
                      sortFuncDate("Fecha_Confirmacion");
                    },
                  ),
                ],
                rows: List<DataRow>.generate(
                  data.length,
                  (index) {
                    Color rowColor = Colors.black;
                    return DataRow(
                      onSelectChanged: (bool? selected) {
                        showDialog(
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
                                          "Fecha: ${data[index]['attributes']['Fecha_Entrega'].toString()}"),
                                      _model(
                                          "Código: ${data[index]['attributes']['Name_Comercial']}-${data[index]['attributes']['NumeroOrden']}"),
                                      _model(
                                          "Ciudad: ${data[index]['attributes']['CiudadShipping']}"),
                                      _model(
                                          "Nombre Cliente: ${data[index]['attributes']['NombreShipping']}"),
                                      _model(
                                          "Detalle: ${data[index]['attributes']['DireccionShipping']}"),
                                      _model(
                                          "Teléfono: ${data[index]['attributes']['TelefonoShipping']}"),
                                      _model(
                                          "Cantidad: ${data[index]['attributes']['Cantidad_Total']}"),
                                      _model(
                                          "Producto: ${data[index]['attributes']['ProductoP']}"),
                                      _model(
                                          "Producto Extra: ${data[index]['attributes']['ProductoExtra']}"),
                                      _model(
                                          "Precio Total: ${data[index]['attributes']['PrecioTotal']}"),
                                      _model(
                                          "Status: ${data[index]['attributes']['Status']}"),
                                      _model(
                                          "Estado Devolución: ${data[index]['attributes']['Estado_Devolucion']}"),
                                      _model(
                                          "Marca Fecha Confirmación: ${data[index]['attributes']['Fecha_Confirmacion']}")
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                      cells: [
                        DataCell(Text(
                          data[index]['attributes']['Fecha_Entrega'].toString(),
                          style: TextStyle(
                            color: rowColor,
                          ),
                        )),
                        DataCell(
                          Text(
                            "${data[index]['attributes']['Name_Comercial']}-${data[index]['attributes']['NumeroOrden']}",
                            style: TextStyle(
                              color: rowColor,
                            ),
                          ),
                        ),
                        DataCell(Text(
                            '${data[index]['attributes']['CiudadShipping'].toString()}')),
                        DataCell(Text(
                          data[index]['attributes']['NombreShipping']
                              .toString(),
                          style: TextStyle(
                            color: rowColor,
                          ),
                        )),
                        DataCell(Text(
                          data[index]['attributes']['DireccionShipping']
                              .toString(),
                          style: TextStyle(
                            color: rowColor,
                          ),
                        )),
                        DataCell(Text(
                          data[index]['attributes']['TelefonoShipping']
                              .toString(),
                          style: TextStyle(
                            color: rowColor,
                          ),
                        )),
                        DataCell(Text(
                          data[index]['attributes']['Cantidad_Total']
                              .toString(),
                          style: TextStyle(
                            color: rowColor,
                          ),
                        )),
                        DataCell(Text(
                          '${data[index]['attributes']['ProductoP'].toString()}',
                          style: TextStyle(
                            color: rowColor,
                          ),
                        )),
                        DataCell(Text(
                          '${data[index]['attributes']['ProductoExtra'].toString()}',
                          style: TextStyle(
                            color: rowColor,
                          ),
                        )),
                        DataCell(Text(
                          '\$${data[index]['attributes']['PrecioTotal'].toString()}',
                          style: TextStyle(
                            color: rowColor,
                          ),
                        )),
                        DataCell(Text(
                          data[index]['attributes']['Status'].toString(),
                          style: TextStyle(
                            color: rowColor,
                          ),
                        )),
                        DataCell(Text(
                          data[index]['attributes']['Estado_Devolucion']
                              .toString(),
                          style: TextStyle(
                            color: rowColor,
                          ),
                        )),
                        DataCell(Text(
                          data[index]['attributes']['Fecha_Confirmacion']
                              .toString(),
                          style: TextStyle(
                            color: rowColor,
                          ),
                        )),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
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

  sortFuncDate(name) {
    if (sort) {
      setState(() {
        sort = false;
      });
      data.sort((a, b) {
        DateTime? dateA = a['attributes'][name] != null
            ? DateFormat("d/M/yyyy").parse(a['attributes'][name].toString())
            : null;
        DateTime? dateB = b['attributes'][name] != null
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
        DateTime? dateA = a['attributes'][name] != null
            ? DateFormat("d/M/yyyy").parse(a['attributes'][name].toString())
            : null;
        DateTime? dateB = b['attributes'][name] != null
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

  Padding _model(text) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold),
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
            if (option.isEmpty) {
              var dataTemp = data
                  .where((objeto) =>
                      objeto['attributes']['Marca_Tiempo_Envio']
                          .toString()
                          .split(" ")[0]
                          .toString()
                          .toLowerCase()
                          .contains(value.toLowerCase()) ||
                      objeto['attributes']['NumeroOrden']
                          .toString()
                          .toLowerCase()
                          .contains(value.toLowerCase()) ||
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
                      objeto['attributes']['TelefonoShipping']
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
                      objeto['attributes']['Observacion'].toString().toLowerCase().contains(value.toLowerCase()) ||
                      objeto['attributes']['Comentario'].toString().toLowerCase().contains(value.toLowerCase()) ||
                      objeto['attributes']['Status'].toString().toLowerCase().contains(value.toLowerCase()) ||
                      objeto['attributes']['Fecha_Entrega'].toString().toLowerCase().contains(value.toLowerCase()) ||
                      objeto['attributes']['DO'].toString().toLowerCase().contains(value.toLowerCase()))
                  .toList();
              setState(() {
                data = dataTemp;
              });
            } else {
              switch (option) {
                case "Fecha":
                  var dataTemp = data
                      .where((objeto) => objeto['attributes']
                              ['Marca_Tiempo_Envio']
                          .toString()
                          .toLowerCase()
                          .contains(value.toLowerCase()))
                      .toList();
                  setState(() {
                    data = dataTemp;
                  });
                  break;
                case "Código":
                  var dataTemp = data
                      .where((objeto) => objeto['attributes']['NumeroOrden']
                          .toString()
                          .toLowerCase()
                          .contains(value.toLowerCase()))
                      .toList();
                  setState(() {
                    data = dataTemp;
                  });
                  break;
                case "Ciudad":
                  var dataTemp = data
                      .where((objeto) => objeto['attributes']['CiudadShipping']
                          .toString()
                          .toLowerCase()
                          .contains(value.toLowerCase()))
                      .toList();
                  setState(() {
                    data = dataTemp;
                  });
                  break;
                case "Nombre Cliente":
                  var dataTemp = data
                      .where((objeto) => objeto['attributes']['NombreShipping']
                          .toString()
                          .toLowerCase()
                          .contains(value.toLowerCase()))
                      .toList();
                  setState(() {
                    data = dataTemp;
                  });
                  break;
                case "Dirección":
                  var dataTemp = data
                      .where((objeto) => objeto['attributes']
                              ['DireccionShipping']
                          .toString()
                          .toLowerCase()
                          .contains(value.toLowerCase()))
                      .toList();
                  setState(() {
                    data = dataTemp;
                  });
                  break;
                case "Teléfono Cliente":
                  var dataTemp = data
                      .where((objeto) => objeto['attributes']
                              ['TelefonoShipping']
                          .toString()
                          .toLowerCase()
                          .contains(value.toLowerCase()))
                      .toList();
                  setState(() {
                    data = dataTemp;
                  });
                  break;
                case "Cantidad":
                  var dataTemp = data
                      .where((objeto) => objeto['attributes']['Cantidad_Total']
                          .toString()
                          .toLowerCase()
                          .contains(value.toLowerCase()))
                      .toList();
                  setState(() {
                    data = dataTemp;
                  });
                  break;
                case "Producto":
                  var dataTemp = data
                      .where((objeto) => objeto['attributes']['ProductoP']
                          .toString()
                          .toLowerCase()
                          .contains(value.toLowerCase()))
                      .toList();
                  setState(() {
                    data = dataTemp;
                  });
                  break;
                case "Producto Extra":
                  var dataTemp = data
                      .where((objeto) => objeto['attributes']['ProductoExtra']
                          .toString()
                          .toLowerCase()
                          .contains(value.toLowerCase()))
                      .toList();
                  setState(() {
                    data = dataTemp;
                  });
                  break;
                case "Precio Total":
                  var dataTemp = data
                      .where((objeto) => objeto['attributes']['PrecioTotal']
                          .toString()
                          .toLowerCase()
                          .contains(value.toLowerCase()))
                      .toList();
                  setState(() {
                    data = dataTemp;
                  });
                  break;
                case "Observación":
                  var dataTemp = data
                      .where((objeto) => objeto['attributes']['Observacion']
                          .toString()
                          .toLowerCase()
                          .contains(value.toLowerCase()))
                      .toList();
                  setState(() {
                    data = dataTemp;
                  });
                  break;
                case "Comentario":
                  var dataTemp = data
                      .where((objeto) => objeto['attributes']['Comentario']
                          .toString()
                          .toLowerCase()
                          .contains(value.toLowerCase()))
                      .toList();
                  setState(() {
                    data = dataTemp;
                  });
                  break;
                case "Status":
                  var dataTemp = data
                      .where((objeto) => objeto['attributes']['Status']
                          .toString()
                          .toLowerCase()
                          .contains(value.toLowerCase()))
                      .toList();
                  setState(() {
                    data = dataTemp;
                  });
                  break;
                case "Fecha Entrega":
                  var dataTemp = data
                      .where((objeto) => objeto['attributes']['Fecha_Entrega']
                          .toString()
                          .toLowerCase()
                          .contains(value.toLowerCase()))
                      .toList();
                  setState(() {
                    data = dataTemp;
                  });
                  break;

                case "Devolución":
                  var dataTemp = data
                      .where((objeto) => objeto['attributes']['DO']
                          .toString()
                          .toLowerCase()
                          .contains(value.toLowerCase()))
                      .toList();
                  setState(() {
                    data = dataTemp;
                  });
                  break;
                default:
              }
            }
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
}
