import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:qr/qr.dart';
import 'package:frontend/config/exports.dart';

class ModelGuide extends StatefulWidget {
  final String numPedido;
  final String date;
  final String city;
  final String product;
  final String extraProduct;
  final String quantity;
  final String phone;
  final String price;
  final String name;
  final String transport;
  final String address;
  final String observation;
  final String qrLink;
  final String idForBarcode;

  const ModelGuide(
      {super.key,
      required this.numPedido,
      required this.date,
      required this.city,
      required this.product,
      required this.extraProduct,
      required this.quantity,
      required this.phone,
      required this.price,
      required this.name,
      required this.transport,
      required this.address,
      required this.observation,
      required this.qrLink,
      required this.idForBarcode});

  @override
  State<ModelGuide> createState() => _ModelGuideState();
}

double size = 14.0;
double multi = 3.0;

class _ModelGuideState extends State<ModelGuide> {
  @override
  Widget build(BuildContext context) {
    var total = double.parse(widget.price) * double.parse(widget.quantity);
    var Params = [
      {'param': 'Fecha', 'value': widget.date},
      {'param': 'Código', 'value': widget.numPedido},
      {'param': 'Nombre', 'value': widget.name},
      {'param': 'Dirección', 'value': widget.address},
      {'param': 'Teléfono', 'value': widget.phone},
      {'param': 'Cantidad', 'value': widget.quantity},
      {'param': 'Precio', 'value': '\$${widget.price}'},
      {'param': 'Producto', 'value': widget.product},
      {'param': 'Producto extra', 'value': widget.extraProduct},
      {'param': 'Precio total', 'value': '\$$total'}
    ];

    Row addParams() {
      List<Widget> colParams = [];
      List<Widget> colValues = [];
      for (var element in Params) {
        colParams.add(
          Container(
            height: 45,
            child: Text(
              '${element['param'].toString()}: ',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: size),
            ),
          ),
        );

        colValues.add(
          Container(
            height: 45,
            child: Text(
              element['value'].toString(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: size),
            ),
          ),
        );
      }

      return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(left: 10),
              width: 30 * multi,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: colParams,
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10),
              width: 60 * multi,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: colValues),
            )
          ]);
    }

    return Transform.scale(
      scale: 1,
      child: Container(
        width: 165.0 * 3,
        height: 710.0 * 3,
        child: Center(
          child: Container(
            width: 165.0 * 3,
            height: 710.0 * 3,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 0.5)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 0.5)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: _Header(),
                    ),

                    addParams(),
                    // Row(
                    //   children: [
                    //     _4Column(),
                    //   ],
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black, width: 0.5)),
                            height: 50 * multi,
                            width: 300,
                            child: Column(
                              children: [
                                Container(
                                  child: Text(
                                    "TRANSPORTADORA: ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: size),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 3, right: 3),
                                  height: 120,
                                  child: Expanded(
                                    child: BarcodeWidget(
                                      barcode: Barcode.code128(),
                                      data: '${widget.idForBarcode.toString()}',
                                      drawText: true,
                                      height: 40,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(child: _4Column()),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row _4Column() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: Container(
          height: 50 * multi,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 0.5)),
          child: Center(
            child: PrettyQr(
              size: 100,
              data: '${widget.qrLink.toString()}',
              errorCorrectLevel: QrErrorCorrectLevel.M,
              roundEdges: true,
            ),
          ),
        ))
      ],
    );
  }

  Container _Header() {
    return Container(
      padding: EdgeInsets.only(top: 5, bottom: 5),
      child: Center(
        child: Column(
          children: [
            Center(
              child: Container(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      images.logoEasyEcommercce,
                      width: 30,
                    ),
                    Text(
                      "  Easy Ecommerce",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: size * 1.5),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: Center(
                child: Text(
                  "Ciudad: ${widget.city}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: size * 1.3,
                      fontStyle: FontStyle.italic),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Container _1Column() {
  //   return Container(
  //     padding: EdgeInsets.only(left: 10),
  //     width: 60 * multi,
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           "CODIGO:",
  //           style: TextStyle(fontWeight: FontWeight.bold, fontSize: size),
  //         ),
  //         Divider(
  //           color: Colors.black,
  //         ),
  //         Text(
  //           "DIRECCION:",
  //           style: TextStyle(fontWeight: FontWeight.bold, fontSize: size),
  //         ),
  //         Divider(
  //           color: Colors.black,
  //         ),
  //         Text(
  //           "TELEFONO: ",
  //           style: TextStyle(fontWeight: FontWeight.bold, fontSize: size),
  //         ),
  //         Divider(
  //           color: Colors.black,
  //         ),
  //         Text(
  //           "CANTIDAD: ",
  //           style: TextStyle(fontWeight: FontWeight.bold, fontSize: size),
  //         ),
  //         Divider(
  //           color: Colors.black,
  //         ),
  //         Text(
  //           "PRODUCTO: ",
  //           style: TextStyle(fontWeight: FontWeight.bold, fontSize: size),
  //         ),
  //         Divider(
  //           color: Colors.black,
  //         ),
  //         Text(
  //           "PRODUCTO EXTRA: ",
  //           style: TextStyle(fontWeight: FontWeight.bold, fontSize: size),
  //         ),
  //         Divider(
  //           color: Colors.black,
  //         ),
  //         Text(
  //           "PRECIO TOTAL: ",
  //           style: TextStyle(fontWeight: FontWeight.bold, fontSize: size),
  //         ),
  //         Divider(
  //           color: Colors.black,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Container _20Column() {
  //   return Container(
  //     padding: EdgeInsets.only(left: 10),
  //     width: 60 * multi,
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           '${widget.numPedido.toString()}',
  //           style: TextStyle(
  //               fontWeight: FontWeight.bold,
  //               fontSize: size,
  //               overflow: TextOverflow.ellipsis),
  //         ),
  //         Divider(
  //           color: Colors.black,
  //         ),
  //         Text(
  //           '${widget.city.toString()}',
  //           style: TextStyle(
  //               fontWeight: FontWeight.bold,
  //               fontSize: size,
  //               overflow: TextOverflow.ellipsis),
  //         ),
  //         Divider(
  //           color: Colors.black,
  //         ),
  //         Text(
  //           '${widget.phone.toString()}',
  //           style: TextStyle(
  //               fontWeight: FontWeight.bold,
  //               fontSize: size,
  //               overflow: TextOverflow.ellipsis),
  //         ),
  //         Divider(
  //           color: Colors.black,
  //         ),
  //         Text(
  //           '${widget.quantity.toString()}',
  //           style: TextStyle(fontWeight: FontWeight.bold, fontSize: size),
  //         ),
  //         Divider(
  //           color: Colors.black,
  //         ),
  //         Text(
  //           '${widget.product.toString()}',
  //           style: TextStyle(
  //               fontWeight: FontWeight.bold,
  //               fontSize: size,
  //               overflow: TextOverflow.ellipsis),
  //         ),
  //         Divider(
  //           color: Colors.black,
  //         ),
  //         Text(
  //           '${widget.extraProduct.toString()}',
  //           style: TextStyle(
  //               fontWeight: FontWeight.bold,
  //               fontSize: size,
  //               overflow: TextOverflow.ellipsis),
  //         ),
  //         Divider(
  //           color: Colors.black,
  //         ),
  //         Text(
  //           '${(double.parse(widget.quantity) * double.parse(widget.price.toString()))}',
  //           style: TextStyle(
  //               fontWeight: FontWeight.bold,
  //               fontSize: size,
  //               overflow: TextOverflow.ellipsis),
  //         ),
  //         Divider(
  //           color: Colors.black,
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
