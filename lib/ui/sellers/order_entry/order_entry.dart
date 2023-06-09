import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:frontend/config/exports.dart';
import 'package:frontend/connections/connections.dart';
import 'package:frontend/helpers/navigators.dart';
import 'package:frontend/providers/filters_orders/filters_orders.dart';
import 'package:frontend/ui/sellers/order_entry/controllers/controllers.dart';
import 'package:frontend/ui/sellers/order_entry/order_info.dart';
import 'package:frontend/ui/widgets/filters_orders.dart';
import 'package:frontend/ui/widgets/loading.dart';
import 'package:frontend/ui/widgets/routes/routes.dart';
import 'package:frontend/ui/widgets/sellers/add_order.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';
import 'package:frontend/main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class OrderEntry extends StatefulWidget {
  const OrderEntry({super.key});

  @override
  State<OrderEntry> createState() => _OrderEntryState();
}

class _OrderEntryState extends State<OrderEntry> {
  OrderEntryControllers _controllers = OrderEntryControllers();
  List data = [];
  List optionsCheckBox = [];
  int counterChecks = 0;
  bool sort = false;
  List dataTemporal = [];

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
        setState(() {
           
            data.clear();
        });


    response = await Connections()
        .getOrdersSellersByCode(_controllers.searchController.text);

    data = response;
    dataTemporal = response;

    setState(() {
      optionsCheckBox = [];
      counterChecks = 0;
    });
    for (var i = 0; i < data.length; i++) {
      optionsCheckBox.add({"check": false, "id": ""});
    }
    Future.delayed(Duration(milliseconds: 500), () {
      Navigator.pop(context);
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog(
              context: (context),
              builder: (context) {
                return AddOrderSellers();
              });
          await loadData();
        },
        backgroundColor: colors.colorGreen,
        child: Center(
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(height: 10,),
             Align(
              alignment: Alignment.centerRight,
               child: GestureDetector(
                      onTap: ()async{
                       await loadData();
                      },
                      child: Container(
                        color: Colors.transparent,
                        
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                          Icon(Icons.replay_outlined, color: Colors.green,),
                          SizedBox(width: 10,),
                          Text("Recargar Información", style: TextStyle(decoration: TextDecoration.underline, color: Colors.green),),                          SizedBox(width: 10,),

                        ],),
                      ),
                    ),
             ),
                  SizedBox(height: 10,),
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
            Expanded(
              child: DataTable2(
                  headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                  dataTextStyle:
                      TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
                  columnSpacing: 12,
                  horizontalMargin: 12,
                  minWidth: 3500,
                  columns: [
                    DataColumn2(
                      label: Text(''),
                      size: ColumnSize.S,
                    ),
                    DataColumn2(
                      label: Text('Marca de Tiempo'),
                      size: ColumnSize.M,
                      onSort: (columnIndex, ascending) {
                        sortFuncDate("Marca_T_I");
                      },
                    ),
                    DataColumn2(
                      label: Text(''),
                      size: ColumnSize.M,
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
                      label: Text('Observación'),
                      size: ColumnSize.M,
                    ),
                    DataColumn2(
                      label: Text('Estado Pedido'),
                      size: ColumnSize.M,
                      onSort: (columnIndex, ascending) {
                        sortFunc("Status");
                      },
                    ),
                    DataColumn2(
                      label: Text('Estado Confirmado'),
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
                      label: Text('Marca Fecha Confirmación'),
                      size: ColumnSize.M,
                      onSort: (columnIndex, ascending) {
                        sortFuncDate("Fecha_Confirmacion");
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
                                          data[index]['id'];
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
                                    '${data[index]['attributes']['Marca_T_I'].toString()}'),
                                onTap: () {
                             info(context, index);
                            }),
                            DataCell(Row(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    var _url = Uri(
                                        scheme: 'tel',
                                        path:
                                            '${data[index]['attributes']['TelefonoShipping'].toString()}');

                                    if (!await launchUrl(_url)) {
                                      throw Exception('Could not launch $_url');
                                    }
                                  },
                                  child: Icon(
                                    Icons.call,
                                    size: 20,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    var _url = Uri.parse(
                                        """https://api.whatsapp.com/send?phone=${data[index]['attributes']['TelefonoShipping'].toString()}&text=Hola ${data[index]['attributes']['NombreShipping'].toString()}, te saludo de la tienda ${data[index]['attributes']['Tienda_Temporal'].toString()}, Me comunico con usted para confirmar su pedido de compra de: ${data[index]['attributes']['ProductoP'].toString()} y  ${data[index]['attributes']['ProductoExtra'].toString()}, por un valor total de: ${data[index]['attributes']['PrecioTotal'].toString()}. Su dirección de entrega será: ${data[index]['attributes']['DireccionShipping'].toString()} Es correcto...? Desea mas información del producto?""");
                                    if (!await launchUrl(_url)) {
                                      throw Exception('Could not launch $_url');
                                    }
                                  },
                                  child: Icon(
                                    Icons.message_outlined,
                                    size: 20,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    var response = await Connections()
                                        .updateOrderInteralStatus("CONFIRMADO",
                                            data[index]['id'].toString());
                                    setState(() {});
                                    await showDialog(
                                        context: context,
                                        builder: (context) {
                                          return RoutesModal(
                                            idOrder:
                                                data[index]['id'].toString(),
                                            someOrders: false,
                                          );
                                        });
                                    loadData();
                                  },
                                  child: Icon(
                                    Icons.check,
                                    size: 20,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                            data[index]['attributes']
                                        ['Estado_Logistico']
                                    .toString()== "ENVIADO"
                              ? Container()
                              :     GestureDetector(
                                  onTap: () async {
                                    var response = await Connections()
                                        .updateOrderInteralStatus("NO DESEA",
                                            data[index]['id'].toString());
                                    setState(() {});
                                    loadData();
                                  },
                                  child: Icon(
                                    Icons.cancel_outlined,
                                    size: 20,
                                  ),
                                )
                              ],
                            )),
                            DataCell(
                                Text(
                                    "${sharedPrefs!.getString("NameComercialSeller").toString()}-${data[index]['attributes']['NumeroOrden']}"
                                        .toString()), onTap: () {
                                  info(context, index);
                            }),
                            DataCell(
                                Text(data[index]['attributes']['CiudadShipping']
                                    .toString()), onTap: () {
                                      info(context, index);
                            }),
                            DataCell(
                                Text(data[index]['attributes']['NombreShipping']
                                    .toString()), onTap: () {
                   info(context, index);
                            }),
                            DataCell(
                                Text(data[index]['attributes']
                                        ['DireccionShipping']
                                    .toString()), onTap: () {
                                     info(context, index);
                            }),
                            DataCell(
                                Text(data[index]['attributes']
                                        ['TelefonoShipping']
                                    .toString()), onTap: () {
                                       info(context, index);
                            }),
                            DataCell(
                                Text(data[index]['attributes']['Cantidad_Total']
                                    .toString()), onTap: () {
                                      info(context, index);
                            }),
                      
                            DataCell(
                                Text(data[index]['attributes']['ProductoP']
                                    .toString()), onTap: () {
                               info(context, index);
                            }),
                            DataCell(
                                Text(data[index]['attributes']['ProductoExtra']
                                    .toString()), onTap: () {
                                      info(context, index);
                            }),
                            DataCell(
                                Text(data[index]['attributes']['PrecioTotal']
                                    .toString()), onTap: () {
                               info(context, index);
                            }),
                            DataCell(
                                Text(data[index]['attributes']['Observacion']
                                    .toString()), onTap: () {
                          info(context, index);
                            }),
                            DataCell(
                                Text(data[index]['attributes']['Status']
                                    .toString()), onTap: () {
                                    info(context, index);
                            }),
                            DataCell(
                                Text(data[index]['attributes']['Estado_Interno']
                                    .toString()), onTap: () {
                                info(context, index);
                            }),
                            DataCell(
                                Text(data[index]['attributes']
                                        ['Estado_Logistico']
                                    .toString()), onTap: () {
                                       info(context, index);
                            }),
                            DataCell(
                                Text(data[index]['attributes']
                                        ['Fecha_Confirmacion']
                                    .toString()), onTap: () {
                                 info(context, index);
                            }),
                          ]))),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> info(BuildContext context, int index) {
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
                      child: OrderInfo(
                    id: data[index]['id'].toString(),
                  ))
                ],
              ),
            ),
          );
        });
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
                for (var i = 0; i < optionsCheckBox.length; i++) {
                  if (optionsCheckBox[i]['id'].toString().isNotEmpty &&
                      optionsCheckBox[i]['id'].toString() != '' &&
                      optionsCheckBox[i]['check'] == true) {
                    var response = await Connections().updateOrderInteralStatus(
                        "NO DESEA", optionsCheckBox[i]['id'].toString());
                  }
                }
                setState(() {});
                loadData();
              },
              child: Text(
                "No Desea",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          SizedBox(
            width: 20,
          ),
          ElevatedButton(
              onPressed: () async {
                for (var i = 0; i < optionsCheckBox.length; i++) {
                  if (optionsCheckBox[i]['id'].toString().isNotEmpty &&
                      optionsCheckBox[i]['id'].toString() != '' &&
                      optionsCheckBox[i]['check'] == true) {
                    var response = await Connections().updateOrderInteralStatus(
                        "CONFIRMADO", optionsCheckBox[i]['id'].toString());
                  }
                }
                await showDialog(
                    context: context,
                    builder: (context) {
                      return RoutesModal(
                        idOrder: optionsCheckBox,
                        someOrders: true,
                      );
                    });

                setState(() {});
                loadData();
              },
              child: Text(
                "Confirmar",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          SizedBox(
            width: 20,
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
                    objeto['attributes']['Marca_T_I']
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
                    objeto['attributes']['Status'].toString().toLowerCase().contains(value.toLowerCase()) ||
                    objeto['attributes']['Estado_Interno'].toString().toLowerCase().contains(value.toLowerCase()) ||
                    objeto['attributes']['Fecha_Confirmacion'].toString().toLowerCase().contains(value.toLowerCase()) ||
                    objeto['attributes']['Estado_Logistico'].toString().toLowerCase().contains(value.toLowerCase()))
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
}
