import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:frontend/connections/connections.dart';
import 'package:frontend/ui/widgets/loading.dart';

class AddOrderSellers extends StatefulWidget {
  const AddOrderSellers({super.key});

  @override
  State<AddOrderSellers> createState() => _AddOrderSellersState();
}

class _AddOrderSellersState extends State<AddOrderSellers> {
  List<DateTime?> _dates = [];
  TextEditingController _cantidad = TextEditingController();
  TextEditingController _codigo = TextEditingController();
  TextEditingController _nombre = TextEditingController();
  TextEditingController _direccion = TextEditingController();
  TextEditingController _ciudad = TextEditingController();
  TextEditingController _telefono = TextEditingController();
  TextEditingController _producto = TextEditingController();
  TextEditingController _productoE = TextEditingController();
  TextEditingController _precioT = TextEditingController();
  TextEditingController _observacion = TextEditingController();
  bool pendiente = true;
  bool confirmado = false;
  bool noDesea = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        width: 500,
        height: MediaQuery.of(context).size.height,
        child: ListView(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                TextField(
                  style: TextStyle(fontWeight: FontWeight.bold),
                  controller: _ciudad,
                  decoration: InputDecoration(
                      hintText: "Ciudad",
                      hintStyle: TextStyle(fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  style: TextStyle(fontWeight: FontWeight.bold),
                  controller: _codigo,
                  decoration: InputDecoration(
                      hintText: "Código",
                      hintStyle: TextStyle(fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  style: TextStyle(fontWeight: FontWeight.bold),
                  controller: _nombre,
                  decoration: InputDecoration(
                      hintText: "Nombre Cliente",
                      hintStyle: TextStyle(fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  style: TextStyle(fontWeight: FontWeight.bold),
                  controller: _direccion,
                  decoration: InputDecoration(
                      hintText: "Dirección",
                      hintStyle: TextStyle(fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  style: TextStyle(fontWeight: FontWeight.bold),
                  controller: _telefono,
                  decoration: InputDecoration(
                      hintText: "Teléfono",
                      hintStyle: TextStyle(fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  style: TextStyle(fontWeight: FontWeight.bold),
                  controller: _cantidad,
                  decoration: InputDecoration(
                      hintText: "CANTIDAD",
                      hintStyle: TextStyle(fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  style: TextStyle(fontWeight: FontWeight.bold),
                  controller: _producto,
                  decoration: InputDecoration(
                      hintText: "Producto",
                      hintStyle: TextStyle(fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  style: TextStyle(fontWeight: FontWeight.bold),
                  controller: _productoE,
                  decoration: InputDecoration(
                      hintText: "Producto Extra",
                      hintStyle: TextStyle(fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  style: TextStyle(fontWeight: FontWeight.bold),
                  controller: _precioT,
                  decoration: InputDecoration(
                      hintText: "Precio Total",
                      hintStyle: TextStyle(fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  style: TextStyle(fontWeight: FontWeight.bold),
                  controller: _observacion,
                  decoration: InputDecoration(
                      hintText: "Observación",
                      hintStyle: TextStyle(fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Checkbox(
                        value: pendiente,
                        onChanged: (v) {
                          setState(() {
                            pendiente = true;
                            confirmado = false;
                            noDesea = false;
                          });
                        }),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                        child: Text(
                      "Pendiente",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ))
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Checkbox(
                        value: confirmado,
                        onChanged: (v) {
                          setState(() {
                            pendiente = false;
                            confirmado = true;
                            noDesea = false;
                          });
                        }),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                        child: Text(
                      "Confirmado",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ))
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Checkbox(
                        value: noDesea,
                        onChanged: (v) {
                          setState(() {
                            pendiente = false;
                            confirmado = false;
                            noDesea = true;
                          });
                        }),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                        child: Text(
                      "No Desea",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ))
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "CANCELAR",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          getLoadingModal(context, false);
                          String valueState = "";
                          String fechaC = "";
                          if (pendiente) {
                            valueState = "PENDIENTE";
                          }
                          if (confirmado) {
                            valueState = "CONFIRMADO";
                            fechaC =
                                "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";
                          }
                          if (noDesea) {
                            valueState = "NO DESEA";
                          }
                          var dateC = await Connections().createDateOrder(
                              "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}");

                          var response = await Connections().createOrder(
                              _codigo.text,
                              _direccion.text,
                              _nombre.text,
                              _telefono.text,
                              _precioT.text,
                              _observacion.text,
                              _ciudad.text,
                              valueState,
                              _producto.text,
                              _productoE.text,
                              _cantidad.text,
                              "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                              fechaC,
                              dateC[1]);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Text(
                          "GUARDAR",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
