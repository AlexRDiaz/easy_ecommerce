import 'package:frontend/ui/utils/utils.dart';
import 'package:frontend/ui/widgets/forms/date_input.dart';
import 'package:frontend/ui/widgets/forms/row_label.dart';
import 'package:frontend/ui/widgets/forms/text_input.dart';
import 'package:frontend/ui/widgets/loading.dart';
import 'package:frontend/ui/widgets/options_modal.dart';
import 'package:get/route_manager.dart';
import 'package:frontend/helpers/server.dart';
import 'package:flutter/material.dart';
import '../../../config/exports.dart';
import '../../../connections/connections.dart';
import '../../../helpers/navigators.dart';
import '../../widgets/forms/image_row.dart';
import 'controllers/controllers.dart';

class SellerReturnDetails extends StatefulWidget {
  const SellerReturnDetails({super.key});

  @override
  State<SellerReturnDetails> createState() => _SellerReturnDetailsState();
}

class _SellerReturnDetailsState extends State<SellerReturnDetails> {
  String id = "";

  @override
  void initState() {
    super.initState();
    if (Get.parameters['id'] != null) {
      id = Get.parameters['id'] as String;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //  getLoadingModal(context, false);
    });
  }

  var data = {};
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

    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.pop(context);
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Color color = UIUtils.getColor('NOVEDAD');
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
            onTap: () {
              Navigators().pushNamedAndRemoveUntil(context, "/layout/sellers");
            },
            child: const Icon(Icons.arrow_back_ios, color: Colors.black)),
        centerTitle: true,
        title: const Text(
          "Detalles",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
        ),
      ),
      body: Container(
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(22.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 500,
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          await showDialog(
                              context: context,
                              builder: (context) {
                                return OptionsModal(
                                    options: const [
                                      'ENTREGADO EN OFICINA',
                                      'DEVOLUCION EN RUTA',
                                      'EN BODEGA'
                                    ],
                                    onCancel: () {
                                      Navigator.of(context).pop();
                                    },
                                    onConfirm: (String selected) {});
                              });
                        },
                        child: const Text(
                          "Devolución",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                RowLabel(
                  title: 'Marca de Tiempo Envío',
                  value: '24/3/2023 18:00:35',
                  color: Colors.black,
                ),
                RowLabel(
                  title: 'Estado Pago',
                  value: '12/02/2022',
                  color: Colors.black,
                ),
                RowLabel(
                  title: 'Marca de Tiempo',
                  value: '1 REPARADOR DE VIDRIO',
                  color: color,
                ),
                RowLabel(
                  title: 'Fecha',
                  value: '1.0',
                  color: color,
                ),
                RowLabel(
                  title: 'Cantidad',
                  value: 'ECUTRENDS2-12809',
                  color: color,
                ),
                RowLabel(
                  title: 'Código',
                  value: '41,97',
                  color: color,
                ),
                RowLabel(
                  title: 'Precio Total',
                  value: '1 REPARADOR DE VIDRIO',
                  color: color,
                ),
                RowLabel(
                  title: 'Producto',
                  value: 'Quito',
                  color: color,
                ),
                RowLabel(
                  title: 'Ciudad',
                  value: 'NOVEDAD',
                  color: color,
                ),
                RowLabel(
                  title: 'Status',
                  value: 'cliente no desea el valor indica que esta muy caro',
                  color: color,
                ),
                RowImage(
                  title: "Comprobante",
                  value:
                      "https://www.state.gov/wp-content/uploads/2019/04/Ecuador-e1556042668750-2501x1406.jpg",
                ),
                RowLabel(
                  title: 'Comentario',
                  value: 'Quito',
                  color: color,
                ),
                RowLabel(
                  title: 'Operador',
                  value: 'Halcon Pro',
                  color: color,
                ),
                RowLabel(
                  title: 'Vendedor',
                  value: 'ECU TRENDS',
                  color: color,
                ),
                RowLabel(
                  title: 'Fecha de Entrega',
                  value: '01/23/2022',
                  color: color,
                ),
                RowLabel(
                  title: 'Nombre de Cliente',
                  value: 'Wilmer AlfredoMarquez Loza',
                  color: color,
                ),
                RowLabel(
                  title: 'Teléfono',
                  value: '0959142813',
                  color: color,
                ),
                RowLabel(
                  title: 'ESTADODEVOLUCION',
                  value: '0.00',
                  color: color,
                ),
                RowLabel(
                  title: 'COSTO_DEVOLUCION',
                  value: '0.00',
                  color: color,
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
