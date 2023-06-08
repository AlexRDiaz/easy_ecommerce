import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:frontend/config/exports.dart';
import 'package:frontend/connections/connections.dart';
import 'package:frontend/ui/logistic/vendor_invoices/controllers/controllers.dart';
import 'package:frontend/ui/utils/utils.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../helpers/navigators.dart';
import '../../widgets/amount_row.dart';
import '../../widgets/loading.dart';

class VendorInvoicesByVendor extends StatefulWidget {
  const VendorInvoicesByVendor({super.key});

  @override
  State<VendorInvoicesByVendor> createState() => _VendorInvoicesByVendorState();
}

class _VendorInvoicesByVendorState extends State<VendorInvoicesByVendor> {
  List data = [];
  bool loading = true;

  loadData() async {
    var response = [];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getLoadingModal(context, false);
    });

    response = await Connections().getOrdersByMonth();
    data = response;

    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.pop(context);
    });
    setState(() {
      bool loading = false;
    });
  }

  @override
  void didChangeDependencies() {
    loadData();
    super.didChangeDependencies();
  }

  final VendorInvoicesControllers _controllers = VendorInvoicesControllers();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigators().pushNamedAndRemoveUntil(context, "/layout/logistic");
          },
          child: const Icon(
            Icons.arrow_back_ios,
          ),
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  return _invoiceTile(
                    date: data[index]["date"],
                    amount: double.parse((data[index]["montoE"] -
                                (data[index]["costo"] + data[index]["costoD"]))
                            .toString())
                        .toStringAsFixed(2),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _invoiceTile({
    required String date,
    required String amount,
    String status = "",
  }) {
    return ListTile(
      onTap: () {},
      trailing: const Icon(
        Icons.arrow_forward_ios_sharp,
        size: 15,
      ),
      title: Row(
        children: [
          Text(
            "$date:",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: UIUtils.getColor(status),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          AmountRow(amount: amount),
        ],
      ),
    );
  }

  _modelTextField({text, controller}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Color.fromARGB(255, 245, 244, 244),
      ),
      child: TextField(
        controller: controller,
        onChanged: (value) {
          setState(() {});
        },
        style: TextStyle(fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search),
          suffixIcon: _controllers.searchController.text.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      _controllers.searchController.clear();
                    });
                  },
                  child: Icon(Icons.close))
              : null,
          hintText: text,
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(width: 1, color: Color.fromRGBO(237, 241, 245, 1.0)),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(width: 1, color: Color.fromRGBO(237, 241, 245, 1.0)),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusColor: Colors.black,
          iconColor: Colors.black,
        ),
      ),
    );
  }
}
