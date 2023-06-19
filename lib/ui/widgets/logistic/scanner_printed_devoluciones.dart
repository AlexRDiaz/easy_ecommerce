import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:frontend/connections/connections.dart';
import 'package:frontend/ui/widgets/loading.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ScannerPrintedDevoluciones extends StatefulWidget {
  const ScannerPrintedDevoluciones({super.key});

  @override
  State<ScannerPrintedDevoluciones> createState() =>
      _ScannerPrintedDevolucionesState();
}

class _ScannerPrintedDevolucionesState
    extends State<ScannerPrintedDevoluciones> {
  String? _barcode;
  late bool visible;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            VisibilityDetector(
              onVisibilityChanged: (VisibilityInfo info) {
                visible = info.visibleFraction > 0;
              },
              key: Key('visible-detector-key'),
              child: BarcodeKeyboardListener(
                bufferDuration: Duration(milliseconds: 200),
                onBarcodeScanned: (barcode) async {
                  
                  AwesomeDialog(
                    width: 500,
                    context: context,
                    dialogType: DialogType.info,
                    animType: AnimType.rightSlide,
                    title: '¿Estás seguro de devolver este pedido a BODEGA?',
                    desc: '',
                    btnOkText: "Confirmar",
                    btnCancelText: "Cancelar",
                    btnOkColor: Colors.blueAccent,
                    btnCancelOnPress: () {},
                    btnOkOnPress: () async {
                      if (!visible) return;
                      getLoadingModal(context, false);

                      var responseOrder =
                          await Connections().getOrderByID(barcode);

                      if (responseOrder['attributes']['Estado_Devolucion']
                              .toString() !=
                          "EN BODEGA") {
                        var response = await Connections()
                            .updateOrderReturnLogistic(barcode.toString());
                      }

                      setState(() {
                        _barcode =
                            "${responseOrder['attributes']['Name_Comercial']}-${responseOrder['attributes']['NumeroOrden']}";
                      });
                      Navigator.pop(context);
                    },
                  ).show();
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Text("MARCAR ORDENES COMO DEVUELTAS",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                        _barcode == null
                            ? 'SCANNER VACIO'
                            : 'ORDEN DEVUELTA A BODEGA: $_barcode',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _barcode == null
                                ? Colors.redAccent
                                : Colors.green)),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("CERRAR",
                      style: TextStyle(fontWeight: FontWeight.bold))),
            )
          ],
        ),
      ),
    );
  }
}
