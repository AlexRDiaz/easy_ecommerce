import 'package:flutter/material.dart';

class Opcion {
  final Icon icono;
  final String titulo;
  final int valor;
  final Color color;

  Opcion(
      {required this.icono,
      required this.titulo,
      required this.valor,
      required this.color});
}
