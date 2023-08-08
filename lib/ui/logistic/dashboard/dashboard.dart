import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:frontend/connections/connections.dart';
import 'package:frontend/helpers/responsive.dart';
import 'package:frontend/main.dart';

import 'package:frontend/ui/sellers/dashboard/filter_details.dart';
import 'package:frontend/ui/sellers/dashboard/storage_info_card.dart';
import 'package:frontend/ui/widgets/cartesian_chart_dashboard.dart';
import 'package:frontend/ui/widgets/loading.dart';
import 'package:frontend/ui/widgets/pie_chart_dashboard.dart';

class DashBoardLogistic extends StatefulWidget {
  const DashBoardLogistic({super.key});

  @override
  State<DashBoardLogistic> createState() => _DashBoardLogisticState();
}

class _DashBoardLogisticState extends State<DashBoardLogistic> {
  bool entregado = false;
  bool noEntregado = false;
  bool novedad = false;
  bool reagendado = false;
  bool enRuta = false;
  bool enOficina = false;
  bool programado = false;
  bool openStatus = false;
  List checks = [];
  TextEditingController _search = TextEditingController();
  List sections = [];
  List routes = [];
  List<String> sellers = [];
  List data = [];
  List subData = [];
  List tableData = [];
  List subFilters = [];
  String? selectValueTransport = null;
  String? selectValueSeller = null;

  String startDate = "";
  String endDate = "";

  String idTransport = "";

  List<String> transports = [];
  String? selectValueOperator = null;
  List<String> operators = [];
  List<Map<String, dynamic>> dataChart = [];
  List<DateTime?> _datesDesde = [];
  List<DateTime?> _datesHasta = [];
  List counters = [];

  bool sort = false;
  String currentValue = "";
  int total = 0;
  int entregados = 0;
  int noEntregados = 0;
  int conNovedad = 0;
  int reagendados = 0;
  int regEnRuta = 0;
  int regEnOficina = 0;
  int regPedidoProgramado = 0;
  double totalValoresRecibidos = 0;
  double costoTransportadora = 0;
  double costoDevoluciones = 0;
  double utilidades = 0;

  bool isFirst = true;
  int counterLoad = 0;
  String transporterOperator = 'TODO';
  int currentPage = 1;
  int pageSize = 70;
  int pageCount = 100;
  bool isLoading = false;
  List<String> listOperators = [];
  Color currentColor = Color.fromARGB(255, 108, 108, 109);
  List<Map<dynamic, dynamic>> arrayFiltersAndEq = [];
  var arrayDateRanges = [];

  List arrayFiltersAnd = [];

  List populate = [
    'pedido_fecha',
    'transportadora',
    'ruta',
    'sub_ruta',
    'operadore',
    "operadore.user",
    "users",
    "users.vendedores"
  ];

  @override
  void didChangeDependencies() {
    initializeDates();
    loadRoutes();

    loadConfigs();
    loadData();
    super.didChangeDependencies();
  }

  loadRoutes() async {
    routes = await Connections().getRoutes();
    for (var route in routes) {
      route['check'] = false;
    }
  }

  initializeDates() {
    if (sharedPrefs!.getString("dateDesdeLogistica") == null) {
      sharedPrefs!.setString("dateDesdeLogistica",
          "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}");
    }
    if (sharedPrefs!.getString("dateHastaLogistica") == null) {
      sharedPrefs!.setString("dateHastaLogistica",
          "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}");
    }
  }

  String capitalize(String input) {
    if (input == null || input.isEmpty) {
      return '';
    }
    return input[0].toUpperCase() + input.substring(1).toLowerCase();
  }

  loadConfigs() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getLoadingModal(context, false);
    });
    var responseOperator = [];
    setState(() {
      sellers = [];
      transports = [];
      operators = [];
    });

    var responseSellers = await Connections().getAllSellers();
    var responseTransports = await Connections().getAllTransportators();
    if (selectValueTransport != null) {
      responseOperator =
          await Connections().getAllOperatorsAndByTransport(idTransport);
    } else {
      responseOperator = await Connections().getAllOperators();
    }

    for (var i = 0; i < responseSellers.length; i++) {
      if (!sellers.contains(
          '${responseSellers[i]['vendedores'] != null && responseSellers[i]['vendedores'].toString() != "[]" ? responseSellers[i]['vendedores'][0]['Nombre_Comercial'] : ""}-${responseSellers[i]['vendedores'] != null && responseSellers[i]['vendedores'].toString() != "[]" ? responseSellers[i]['vendedores'][0]['Id_Master'] : ""}')) {
        setState(() {
          sellers.add(
              '${responseSellers[i]['vendedores'] != null && responseSellers[i]['vendedores'].toString() != "[]" ? responseSellers[i]['vendedores'][0]['Nombre_Comercial'] : ""}-${responseSellers[i]['vendedores'] != null && responseSellers[i]['vendedores'].toString() != "[]" ? responseSellers[i]['vendedores'][0]['Id_Master'] : ""}');
        });
      }
    }

    for (var i = 0; i < responseTransports.length; i++) {
      setState(() {
        transports.add(
            '${responseTransports[i]['attributes']['Nombre']}-${responseTransports[i]['id']}');
      });
    }
    for (var i = 0; i < responseOperator.length; i++) {
      setState(() {
        operators.add(
            '${responseOperator[i]['username']}-${responseOperator[i]['operadore'] != null ? responseOperator[i]['operadore']['id'] : '0'}');
      });
    }

    Future.delayed(Duration(milliseconds: 500), () {
      Navigator.pop(context);
    });
    // setState(() {});
  }

  loadData() async {
    isLoading = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getLoadingModal(context, false);
    });

    // loadConfigs();
    setState(() {
      data = [];
      subFilters = [];
      sections = [];
    });
    // for (FilterCheckModel filter in filters) {
    //   setState(() {
    //     filter.check = false;
    //   });
    // }

    var response = await Connections()
        .getOrdersDashboardLogistic(populate, arrayFiltersAnd);
    setState(() {
      data = response;

      total = data.length;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.pop(context);
    });

    //addCounts();

    //  updateChartValues();
    // calculateValues();

    setState(() {
      loadCounterStates();
    });
  }

  updateChartValues() {
    subData =
        data.where((elemento) => elemento['Status'] == 'ENTREGADO').toList();
    var m = subData;
  }

  bool _isMenuOpen = false;
  final double _menuWidth = 300.0; // Ancho del menú lateral

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  loadCounterStates() {
    for (var d in data) {
      switch (d['Status']) {
        case "ENTREGADO":
          entregados++;
          break;
        case "NO ENTREGADO":
          noEntregados++;
          break;
        case "NOVEDAD":
          conNovedad++;
          break;
        case "REAGENDADO":
          reagendados++;
          break;
        case "EN RUTA":
          regEnRuta++;
          break;
        case "EN OFICINA":
          regEnOficina++;
          break;

        case "PEDIDO PROGRAMADO":
          regPedidoProgramado++;
          break;
        default:
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<FilterCheckModel> filters = [
      FilterCheckModel(
          color: Colors.red,
          numOfFiles: entregados,
          percentage: entregados.toDouble(),
          svgSrc: "assets/icons/Documents.svg",
          title: "Entregados",
          filter: "ENTREGADO",
          check: false),
      FilterCheckModel(
          color: Color.fromARGB(255, 2, 51, 22),
          numOfFiles: noEntregados,
          percentage: noEntregados.toDouble(),
          svgSrc: "assets/icons/Documents.svg",
          title: "No entregado",
          filter: "NO ENTREGADO",
          check: false),
      FilterCheckModel(
          color: const Color.fromARGB(255, 76, 54, 244),
          numOfFiles: conNovedad,
          percentage: conNovedad.toDouble(),
          svgSrc: "assets/icons/Documents.svg",
          title: "Novedad",
          filter: "NOVEDAD",
          check: false),
      FilterCheckModel(
          color: Color.fromARGB(255, 42, 163, 67),
          numOfFiles: reagendados,
          percentage: reagendados.toDouble(),
          svgSrc: "assets/icons/Documents.svg",
          title: "Reagendado",
          filter: "REAGENDADO",
          check: false),
      FilterCheckModel(
          color: Color.fromARGB(255, 146, 76, 29),
          numOfFiles: regEnRuta,
          percentage: regEnRuta.toDouble(),
          svgSrc: "assets/icons/Documents.svg",
          title: "En ruta",
          filter: "EN RUTA",
          check: false),
      FilterCheckModel(
          color: Color.fromARGB(255, 11, 6, 123),
          numOfFiles: regEnOficina,
          percentage: regEnOficina.toDouble(),
          svgSrc: "assets/icons/Documents.svg",
          title: "En oficina",
          filter: "EN OFICINA",
          check: false),
      FilterCheckModel(
          color: Color.fromARGB(255, 146, 18, 73),
          numOfFiles: regPedidoProgramado,
          percentage: regPedidoProgramado.toDouble(),
          svgSrc: "assets/icons/Documents.svg",
          title: "Pedido programado",
          filter: "PEDIDO PROGRAMADO",
          check: false),
    ];

    return Scaffold(
        body: Center(
            child: Row(
      children: [
        // Contenido principal de la página
        Expanded(
          child: Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
            child: Column(
              children: [
                _dates(context),
                responsive(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(3)),
                              height: MediaQuery.of(context).size.height * 0.8,
                              width: 200,
                              child: DynamicPieChart(
                                filters: filters,
                              )),
                        ),
                        Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(3)),
                              height: MediaQuery.of(context).size.height * 0.8,
                              width: 200,
                              child: CartesianChartDashboard()),
                        ),
                      ],
                    ),

                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     Expanded(
                    //       child: Container(
                    //         height: MediaQuery.of(context).size.height * 0.73,
                    //         padding: EdgeInsets.only(left: 20),
                    //         child: InputDecorator(
                    //           decoration: InputDecoration(
                    //             labelText: 'Estados de entrega',
                    //             border: OutlineInputBorder(
                    //               borderRadius: BorderRadius.circular(10.0),
                    //             ),
                    //           ),
                    //           child: Container(
                    //             child: Row(
                    //               crossAxisAlignment: CrossAxisAlignment.center,
                    //               children: [
                    //                 Chart(
                    //                   sections: sections,
                    //                   total: calculatetotal(),
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),

                    //  Text("hola mundo"),

                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(8),
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(
                                left: 20, right: 14, bottom: 20),
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'Estados de entrega',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              child: Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: filters
                                            .map((elemento) => FilterInfoCard(
                                                  svgSrc: elemento.svgSrc!,
                                                  title: elemento.title!,
                                                  filter: elemento.filter!,
                                                  color: elemento.color!,
                                                  details: addTableRows,
                                                  percentage:
                                                      elemento.percentage!,
                                                  numOfFiles:
                                                      elemento.numOfFiles!,
                                                  function: changeValue,
                                                ))
                                            .toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Row(
                          //   children: [
                          //     Expanded(
                          //       child: Container(
                          //         height:
                          //             MediaQuery.of(context).size.height * 0.53,
                          //         padding: EdgeInsets.only(
                          //             left: 18, right: 13, bottom: 20),
                          //         child: InputDecorator(
                          //           decoration: InputDecoration(
                          //             labelText: 'Porcentajes por estado',
                          //             border: OutlineInputBorder(
                          //               borderRadius: BorderRadius.circular(10.0),
                          //             ),
                          //           ),
                          //           child: StreamBuilder<Object>(
                          //               stream: null,
                          //               builder: (context, snapshot) {
                          //                 return Row(
                          //                   crossAxisAlignment:
                          //                       CrossAxisAlignment.center,
                          //                   children: [
                          //                     Chart(
                          //                       sections: sections,
                          //                       total: calculatetotal(),
                          //                     ),
                          //                   ],
                          //                 );
                          //               }),
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),

                          FilterDetails(
                              total: totalValoresRecibidos,
                              costoEntregas: costoTransportadora,
                              costoDevoluciones: costoDevoluciones,
                              utilidades: utilidades),
                          dataTableDetails()
                        ],
                      ),
                    ),
                    context)
              ],
            ),
          ),
        ),
        IconButton(
          icon: Icon(_isMenuOpen
              ? Icons.arrow_right_outlined
              : Icons.arrow_left_outlined),
          onPressed: _toggleMenu,
        ),

        // Menú lateral desplegable
        Visibility(
          visible: _isMenuOpen,
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              border: Border(left: BorderSide(color: Colors.black)),
              color: Colors
                  .white, // Agregamos un color de fondo blanco para que el menú se vea más limpio
            ),
            width: _isMenuOpen ? _menuWidth : 0,
            child: _isMenuOpen
                ? SingleChildScrollView(
                    // Usamos SingleChildScrollView para que el contenido pueda desplazarse si se desborda
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const ListTile(
                          title: Text(
                            'Configuraciones',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 7),
                          child: ExpansionTile(
                            title: Text("Entidades"),
                            children: [
                              Container(
                                padding: EdgeInsets.only(left: 20),
                                child: Row(
                                  children: [
                                    Container(
                                        width: 100,
                                        child: Text("Vendedores: ")),
                                    _sellers(context)
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 20),
                                child: Row(
                                  children: [
                                    Container(
                                        width: 100,
                                        child: Text("Transportistas: ")),
                                    _sellersTransport(context)
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 20),
                                child: Row(
                                  children: [
                                    Container(
                                        width: 100,
                                        child: Text("Operadores: ")),
                                    _operators(context)
                                  ],
                                ),
                              ),
                              //  _sellers(context),
                            ],
                          ),
                        ),

                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 16),
                        //   child: ExpansionTile(
                        //     title: Text("Entidades"),
                        //     children: filters
                        //         .map((filter) => Row(
                        //               children: [
                        //                 Container(
                        //                   width: 200,
                        //                   child: Text(
                        //                     filter.title.toString(),
                        //                     style: TextStyle(fontSize: 16),
                        //                   ),
                        //                 ),
                        //                 Checkbox(
                        //                   checkColor: filter.color,
                        //                   activeColor:
                        //                       filter.color!.withOpacity(0.5),
                        //                   focusColor:
                        //                       filter.color!.withOpacity(0.8),
                        //                   value: filter.check,
                        //                   onChanged: (value) => sendFilter(
                        //                       filter.filter.toString(), value!),
                        //                 )
                        //               ],
                        //             ))
                        //         .toList(),
                        //   ),
                        // ),

                        // const ListTile(
                        //   title: Text(
                        //     'Ciudades',
                        //     style: TextStyle(
                        //       fontWeight: FontWeight.bold,
                        //       fontSize: 18,
                        //     ),
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 7),
                          child: ExpansionTile(
                            title: Text("Ciudades"),
                            children: routes
                                .map((route) => Container(
                                      padding: EdgeInsets.only(left: 20),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 200,
                                            child: Text(
                                              capitalize(route['attributes']
                                                      ['Titulo']
                                                  .toString()),
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ),
                                          Checkbox(
                                            value: route['check'],
                                            onChanged: (value) {},
                                          )
                                        ],
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(),
          ),
        ),

        // Container(
        //   width: 1235,
        // ),
        // Positioned(
        // RightSideWidget(),
        //   bottom: 0.0,
        //   top: 0.0,
        //   right: 0.0,
        // )
        // Container(
        //   padding: EdgeInsets.only(left: 20, right: 15, top: 20, bottom: 20),
        //   child: InputDecorator(
        //     decoration: InputDecoration(
        //       labelText: 'Configuraciones',
        //       border: OutlineInputBorder(
        //         borderRadius: BorderRadius.circular(10.0),
        //       ),
        //     ),
        //     child: Column(children: [
        //       _dates(context),
        //       _sellers(context),
        //       _sellersTransport(context),
        //       _operators(context),
        //     ]),
        //   ),
        // ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.start,
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     Container(
        //       child: Expanded(
        //         child: GridView.count(
        //           crossAxisCount:
        //               2, // Puedes cambiar a 3 si quieres tres columnas
        //           crossAxisSpacing: 8.0,
        //           mainAxisSpacing: 8.0,
        //           shrinkWrap: true,
        //           children: filters
        //               .map((elemento) => FilterStatus(
        //                     svgSrc: elemento.svgSrc!,
        //                     title: elemento.title!,
        //                     filter: elemento.filter!,
        //                     color: elemento.color!,
        //                     details: addTableRows,
        //                     percentage: elemento.percentage!,
        //                     numOfFiles: elemento.numOfFiles!,
        //                     function: changeValue,
        //                   ))
        //               .toList(),
        //         ),
        //       ),
        //     ),
        //   ],
        // )
      ],
    )));
  }

  Widget _expansionPanel() {
    final List _data = [
      ['1', '2', '3', '4']
    ];

    return ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            openStatus = !openStatus;
          });
        },
        children: [
          ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return Expanded(child: Text("fvdvd"));
            },
            body: Expanded(child: Text("fvdvd")),
            isExpanded: openStatus,
          )
        ]);
  }

  Container dataTableDetails() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.48,
      width: 690,
      padding: EdgeInsets.only(left: 15, right: 15),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Datos',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }

  Future<void> applyDateFilter() async {
    if (startDate != '' && endDate != '') {
      if (compareDates(startDate, endDate)) {
        var aux = endDate;

        setState(() {
          endDate = startDate;

          startDate = aux;
        });
      }
    }
    arrayDateRanges.add({
      'body_param': 'start',
      'value': startDate != "" ? startDate : '1/1/1991'
    });

    arrayDateRanges.add(
        {'body_param': 'end', 'value': endDate != "" ? endDate : '1/1/2200'});

    await loadData();
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

                    sharedPrefs!.setString("dateDesdeLogistica", nuevaFecha);
                  }
                });
              },
              child: Text(
                "${sharedPrefs!.getString("dateDesdeLogistica")}",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          Text("-"),
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

                    sharedPrefs!.setString("dateHastaLogistica", nuevaFecha);
                  }
                });
              },
              child: Text(
                "${sharedPrefs!.getString("dateHastaLogistica")}",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          SizedBox(
            width: 10,
          ),
          ElevatedButton(
              onPressed: () async {
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

  // addCounts() {
  //   for (var filter in filters) {
  //     subData = [];
  //     for (var element in data) {
  //       if (element['Status'] == filter.filter) {
  //         subData.add(element);
  //       }
  //     }
  //     setState(() {
  //       filter.numOfFiles = subData.length;
  //     });
  //     subFilters.add({
  //       "title": filter.filter,
  //       "total": subData.length,
  //       "color": filter.color
  //     });
  //   }
  // }

  addTableRows(value) {
    tableData = [];
    List arrTable = [];
    for (var element in data) {
      if (element['Status'] == value) {
        arrTable.add(element);
      }
    }

    setState(() {
      tableData = arrTable;
    });
  }

  calculateValues() {
    totalValoresRecibidos = 0;
    costoTransportadora = 0;
    costoDevoluciones = 0;
    utilidades = 0;
    double total = 0;
    double costoEntregas = 0;
    double devol = 0;

    for (var element in data) {
      if (element['Status'] == 'ENTREGADO') {
        print("precioTotal" + element['PrecioTotal']);
        element['PrecioTotal'] =
            element['PrecioTotal'].toString().replaceAll(',', '.');
        total += double.parse(element['PrecioTotal']);
      }

      if (element['Status'] == 'ENTREGADO' ||
          element['Status'] == 'NO ENTREGADO') {
        element['users'][0]['vendedores'][0]['CostoEnvio'] =
            element['users'][0]['vendedores'][0]['CostoEnvio'] ?? 0;

        element['users'][0]['vendedores'][0]['CostoEnvio'] = element['users'][0]
                ['vendedores'][0]['CostoEnvio']
            .toString()
            .replaceAll(',', '.');
        costoEntregas +=
            double.parse(element['users'][0]['vendedores'][0]['CostoEnvio']);
      }

      if (element['Status'] == 'NOVEDAD' &&
          element['Estado_Devolucion'] != 'PENDIENTE') {
        element['users'][0]['vendedores'][0]['CostoDevolucion'] =
            element['users'][0]['vendedores'][0]['CostoDevolucion'] ?? 0;
        element['users'][0]['vendedores'][0]['CostoDevolucion'] =
            element['users'][0]['vendedores'][0]['CostoDevolucion']
                .toString()
                .replaceAll(',', '.');
        devol += double.parse(
            element['users'][0]['vendedores'][0]['CostoDevolucion']);
      }
    }
    setState(() {
      totalValoresRecibidos = total;
      costoTransportadora = costoEntregas;
      costoDevoluciones = devol;
      utilidades =
          totalValoresRecibidos - costoTransportadora - costoDevoluciones;
    });
  }

  calculatetotal() {
    int total = 0;
    for (var section in sections) {
      total += int.parse(section['value'].toString());
    }
    return total;
  }

  changeValue(value) {
    if (value['value']) {
      for (var subFilter in subFilters) {
        if (value['filter'] == subFilter['title']) {
          var sec = {
            'color': subFilter['color'],
            'value': subFilter["total"],
            'showTitle': true,
            'title': subFilter["title"],
            'radius': 20,
          };

          if (!sections.contains(sec)) {
            var color = subFilter['color'] as Color;
            setState(() {
              sections.add({
                'color': color.withOpacity(0.7),
                'value': subFilter["total"],
                'showTitle': true,
                'title': subFilter["title"],
                'radius': 20,
              });
            });
          }
        }
      }
    } else {
      setState(() {
        sections.removeWhere((element) => element['title'] == value['filter']);
      });
    }
  }

  _sellersTransport(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        dropdownWidth: 200,
        buttonWidth: 100,
        isExpanded: true,
        hint: Text(
          'Transporte',
          style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).hintColor,
              fontWeight: FontWeight.bold),
        ),
        items: transports
            .map((item) => DropdownMenuItem(
                  value: item,
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          item.split('-')[0],
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                          onTap: () async {
                            setState(() {
                              idTransport = "";
                              selectValueTransport = null;
                              selectValueOperator = null;
                            });
                            // await loadData();
                          },
                          child: Icon(Icons.close))
                    ],
                  ),
                ))
            .toList(),
        value: selectValueTransport,
        onChanged: (value) async {
          setState(() {
            selectValueTransport = value as String;
            idTransport = value.split('-')[1];
            selectValueOperator = null;
          });
          //  await loadData();
        },

        //This to clear the search value when you close the menu
        onMenuStateChange: (isOpen) {
          if (!isOpen) {}
        },
      ),
    );
  }

  DropdownButtonHideUnderline _operators(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        dropdownWidth: 200,
        buttonWidth: 100,
        isExpanded: true,
        hint: Text(
          'Operadores',
          style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).hintColor,
              fontWeight: FontWeight.bold),
        ),
        items: operators
            .map((item) => DropdownMenuItem(
                  value: item,
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          item.split('-')[0],
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                          onTap: () async {
                            setState(() {
                              selectValueOperator = null;
                            });
                            //  await loadData();
                          },
                          child: Icon(Icons.close))
                    ],
                  ),
                ))
            .toList(),
        value: selectValueOperator,
        onChanged: (value) async {
          setState(() {
            selectValueOperator = value as String;
          });
        },

        //This to clear the search value when you close the menu
        onMenuStateChange: (isOpen) {
          if (!isOpen) {}
        },
      ),
    );
  }

  DropdownButtonHideUnderline _sellers(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        dropdownWidth: 200,
        buttonWidth: 100,
        isExpanded: true,
        hint: Text(
          'Vendedores',
          style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).hintColor,
              fontWeight: FontWeight.bold),
        ),
        items: sellers
            .map((item) => DropdownMenuItem(
                  value: item,
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          item.split('-')[0],
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                          onTap: () async {
                            setState(() {
                              selectValueSeller = null;
                            });
                            //       await loadData();
                          },
                          child: Icon(Icons.close))
                    ],
                  ),
                ))
            .toList(),
        value: selectValueSeller,
        onChanged: (value) async {
          arrayFiltersAnd
              .removeWhere((element) => element.containsKey("Tienda_Temporal"));
          setState(() {
            arrayFiltersAnd.add({"Tienda_Temporal": value!.split("-")[0]});
            selectValueSeller = value as String;
          });
        },

        //This to clear the search value when you close the menu
        onMenuStateChange: (isOpen) {
          if (!isOpen) {}
        },
      ),
    );
  }

  // sendFilter(String selectedFilter, bool currentValue) {
  //   for (var filter in filters) {
  //     if (filter.filter == selectedFilter) {
  //       setState(() {
  //         filter.check = currentValue;
  //       });
  //     }
  //   }
  // }
}
