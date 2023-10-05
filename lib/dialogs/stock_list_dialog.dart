import 'package:d_pos_v2/models/inventory_model.dart';
import 'package:d_pos_v2/utils/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class StockListDialog {
  final txtName = TextEditingController();
  final txtCode = TextEditingController();
  final txtQty = TextEditingController();
  final txtBP = TextEditingController();
  final txtUnitSP = TextEditingController();

  Widget buildDialog(
      BuildContext context, InventoryModel invModel, bool isNew) {
    final formKey = GlobalKey<FormState>();
    var textStyle = Theme.of(context).textTheme.bodyMedium;

    DbHelper helper = DbHelper();

    if (!isNew) {
      txtName.text = invModel.name;
      txtCode.text = invModel.pCode.toString();
      txtQty.text = invModel.quantity.toString();
      txtBP.text = invModel.buyingPrice.toString();
      txtUnitSP.text = invModel.unitSellingPrice.toString();
    } else {
      txtName.text = "";
      txtCode.text = "";
      txtQty.text = "";
      txtBP.text = "";
      txtUnitSP.text = "";
      scanBarcodeNormal();
    }

    return AlertDialog(
      title: Text((isNew) ? 'new entry...' : 'edit entry...'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // form to handle input data
            Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: txtName,
                    decoration: InputDecoration(
                      labelText: 'product name',
                      labelStyle: textStyle,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: txtCode,
                    //readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'barcode value',
                      labelStyle: textStyle,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please enter some text';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: txtQty,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: false,
                      signed: false,
                    ),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                      labelText: 'quantity/no. of units',
                      labelStyle: textStyle,
                    ),
                  ),
                  TextFormField(
                    controller: txtBP,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: false,
                    ),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                      labelText: 'buying price',
                      labelStyle: textStyle,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please enter some text';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: txtUnitSP,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: false,
                    ),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                      labelText: 'unit selling price',
                      labelStyle: textStyle,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please enter some text';
                      }
                      return null;
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.adf_scanner_outlined,
                    ),
                    onPressed: () {
                      scanBarcodeNormal();
                    },
                  ),
                  ElevatedButton(
                    child: const Text('save'),
                    onPressed: () {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (formKey.currentState!.validate()) {
                        invModel.name = txtName.text;
                        invModel.pCode = int.parse(txtCode.text);
                        invModel.quantity = int.parse(txtQty.text);
                        invModel.buyingPrice = int.parse(txtBP.text);
                        invModel.unitSellingPrice = int.parse(txtUnitSP.text);
                        invModel.date =
                            DateFormat.yMMMd().format(DateTime.now());
                        helper.insertInventoryList(invModel);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')),
                        );
                        Navigator.pop(context, true);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void scanBarcodeNormal() async {
    String scanResults;

    try {
      scanResults = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'cancel', true, ScanMode.BARCODE);
      txtCode.text = scanResults;
    } on PlatformException {
      scanResults = "ERROR!! failed to get platform version";
    }
    txtCode.text = scanResults;
  }
}
