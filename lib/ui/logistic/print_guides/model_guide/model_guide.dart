import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:qr/qr.dart';

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

double size = 12.0;
double multi = 3.0;

class _ModelGuideState extends State<ModelGuide> {
  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1,
      child: Container(
        width: 297.0 * 3,
        height: 210.0 * 3,
        child: Center(
          child: Container(
            width: 297.0 * 3,
            height: 210.0 * 3,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 0.5)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 0.5)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [_1Column(), _2Column()],
                    ),
                    _4Column(),
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Container(
                            width: 200,
                            height: 60,
                            child: BarcodeWidget(
                              barcode: Barcode.code128(),
                              data: '${widget.idForBarcode.toString()}',
                              drawText: true,
                              height: 60,
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                      ],
                    ))
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
        Container(
          width: 150 * multi,
          child: Column(
            children: [
              Container(
                width: 150 * multi,
                height: 5.2 * multi,
                child: Center(
                  child: Text(
                    "DATOS DE ENVIO",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: size),
                  ),
                ),
              ),
              Divider(
                color: Colors.black,
              ),
              Container(
                width: 150 * multi,
                height: 20.2 * multi,
                child: Center(
                  child: Text(
                    '${widget.address.toString()}',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: size),
                    maxLines: 3,
                  ),
                ),
              ),
              Divider(
                color: Colors.black,
              ),
              Container(
                width: 150 * multi,
                height: 5.2 * multi,
                child: Center(
                  child: Text(
                    "OBSERVACIÓN:",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: size),
                  ),
                ),
              ),
              Divider(
                color: Colors.black,
              ),
              Container(
                width: 150 * multi,
                height: 20.2 * multi,
                child: Center(
                  child: Text(
                    '${widget.observation.toString()}',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: size),
                    maxLines: 3,
                  ),
                ),
              ),
              Divider(
                color: Colors.black,
              ),
            ],
          ),
        ),
        Expanded(
            child: Container(
          height: 70 * multi,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 0.5)),
          child: Center(
            child: PrettyQr(
              size: 200,
              data: '${widget.qrLink.toString()}',
              errorCorrectLevel: QrErrorCorrectLevel.M,
              roundEdges: true,
            ),
          ),
        ))
      ],
    );
  }

  Expanded _2Column() {
    return Expanded(
        child: Column(
      children: [
        Container(
          height: 27 * multi,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 0.5)),
          child: Row(
            children: [
              Container(
                width: 112 * multi,
                height: double.infinity,
                child: Center(
                  child: Text(
                    '${widget.city.toString()}',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: size),
                  ),
                ),
              ),
              Container(
                width: 0.5,
                height: double.infinity,
                color: Colors.black,
              ),
              Container(
                width: 112 * multi,
                height: double.infinity,
                child: Center(
                  child: Text(
                    "FECHA: '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}'",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: size),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 10.5 * multi,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 0.5)),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: Text(
                '${widget.product.toString()}',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: size,
                    overflow: TextOverflow.ellipsis),
              ),
            ),
          ),
        ),
        Container(
          height: 10.2 * multi,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 0.5)),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: Text(
                '${widget.extraProduct.toString()}',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: size,
                    overflow: TextOverflow.ellipsis),
              ),
            ),
          ),
        ),
        Container(
          height: 10.2 * multi,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 0.5)),
          child: Row(
            children: [
              Container(
                width: 60 * multi,
                height: double.infinity,
                child: Center(
                  child: Text(
                    '${widget.quantity.toString()}',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: size),
                  ),
                ),
              ),
              Container(
                width: 0.5,
                height: double.infinity,
                color: Colors.black,
              ),
              Container(
                width: 60 * multi,
                height: double.infinity,
                child: Center(
                  child: Text(
                    "TELÉFONO",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: size),
                  ),
                ),
              ),
              Container(
                width: 0.5,
                height: double.infinity,
                color: Colors.black,
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Center(
                    child: Text(
                      '${widget.phone.toString()}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: size,
                          overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 10.2 * multi,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 0.5)),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: Text(
                '${widget.price.toString()}',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: size,
                    overflow: TextOverflow.ellipsis),
              ),
            ),
          ),
        ),
        Container(
          height: 10.2 * multi,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 0.5)),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: Text(
                '${widget.name.toString()}',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: size,
                    overflow: TextOverflow.ellipsis),
              ),
            ),
          ),
        ),
        Container(
          height: 10.2 * multi,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 0.5)),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: Text(
                '${widget.city.toString()}',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: size,
                    overflow: TextOverflow.ellipsis),
              ),
            ),
          ),
        ),
        Container(
          height: 11 * multi,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 0.5)),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: Text(
                '${widget.transport.toString()}',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: size,
                    overflow: TextOverflow.ellipsis),
              ),
            ),
          ),
        ),
      ],
    ));
  }

  Container _1Column() {
    return Container(
      width: 60 * multi,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.black))),
            child: Center(
              child: Text(
                "NUM. PEDIDO",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: size),
              ),
            ),
          ),
          Divider(
            color: Colors.black,
          ),
          Container(
            height: 15.2 * multi,
            child: Center(
              child: Text(
                '${widget.numPedido.toString()}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: size),
                maxLines: 3,
              ),
            ),
          ),
          Divider(
            color: Colors.black,
          ),
          Center(
            child: Text(
              "Producto:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: size),
            ),
          ),
          Divider(
            color: Colors.black,
          ),
          Center(
            child: Text(
              "Producto Extra: ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: size),
            ),
          ),
          Divider(
            color: Colors.black,
          ),
          Center(
            child: Text(
              "Cantidad: ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: size),
            ),
          ),
          Divider(
            color: Colors.black,
          ),
          Center(
            child: Text(
              "Precio: ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: size),
            ),
          ),
          Divider(
            color: Colors.black,
          ),
          Center(
            child: Text(
              "Cliente: ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: size),
            ),
          ),
          Divider(
            color: Colors.black,
          ),
          Center(
            child: Text(
              "Ciudad: ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: size),
            ),
          ),
          Divider(
            color: Colors.black,
          ),
          Center(
            child: Text(
              "Transportadora: ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: size),
            ),
          ),
          Divider(
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
