import 'package:flutter/material.dart';

class boxValues extends StatelessWidget {
  const boxValues({
    super.key,
    required this.totalValoresRecibidos,
    required this.costoDeEntregas,
    required this.devoluciones,
    required this.utilidad,
  });

  final double totalValoresRecibidos;
  final double costoDeEntregas;
  final double devoluciones;
  final double utilidad;

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
                'Val. recibidos:',
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
        Container(
          padding: EdgeInsets.all(3),
          width: 80,
          decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          child: Column(
            children: [
              const Text(
                'Devoluciones:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 9,
                  color: Colors.black,
                ),
              ),
              Text(
                '\$${devoluciones.toStringAsFixed(2)}',
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
                'Utilidad:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 9,
                  color: Colors.black,
                ),
              ),
              Text(
                '\$${utilidad.toStringAsFixed(2)}',
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
