import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:frontend/connections/connections.dart';
import 'package:frontend/ui/widgets/loading.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ScannerPrintedTransport extends StatefulWidget {
  const ScannerPrintedTransport({super.key});

  @override
  State<ScannerPrintedTransport> createState() =>
      _ScannerPrintedTransportState();
}

class _ScannerPrintedTransportState extends State<ScannerPrintedTransport> {
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
                  if (!visible) return;
                  getLoadingModal(context, false);

                  var responseOrder = await Connections().getOrderByID(barcode);
                  //var m = responseOrder['Status'];
                  if (responseOrder['attributes']['Status'] == 'NO ENTREGADO' ||
                      responseOrder['attributes']['Status'] == 'NOVEDAD') {
                    setState(() {
                      _barcode =
                          "No se puede alterar el pedido con código ${responseOrder['attributes']['Name_Comercial']}-${responseOrder['attributes']['NumeroOrden']}";
                    });

                    // var responseOrder = await Connections().getOrderByID(barcode);
                  } else {
                    var response = await Connections()
                        .updateOrderReturnTransport(
                            barcode.toString(), "DEVOLUCION EN RUTA");
                    setState(() {
                      _barcode =
                          "${responseOrder['attributes']['Name_Comercial']}-${responseOrder['attributes']['NumeroOrden']}";
                    });
                  }
                  Navigator.pop(context);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text("MARCAR DEVOLUCIÓN COMO EN RUTA",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                        _barcode == null
                            ? 'SCANNER VACIO'
                            : 'ORDEN PROCESADA: $_barcode',
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
