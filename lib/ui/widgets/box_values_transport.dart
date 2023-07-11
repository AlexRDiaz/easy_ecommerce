import 'package:flutter/material.dart';

class boxValuesTransport extends StatelessWidget {
  const boxValuesTransport({
    super.key,
    required this.totalValoresRecibidos,
    required this.costoDeEntregas,
  });

  final double totalValoresRecibidos;
  final double costoDeEntregas;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          padding: EdgeInsets.all(3),
          width: 80,
          decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          child: Column(
            children: [
              const Text(
                'Valores recibidos:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 9,
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
          width: 80,
          decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          child: Column(
            children: [
              const Text(
                'Costo de envío:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 9,
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
      ],
    );
  }
}
