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
  final txtPrice = TextEditingController();

  Widget buildDialog(
      BuildContext context, InventoryModel invModel, bool isNew) {
    final formKey = GlobalKey<FormState>();

    DbHelper helper = DbHelper();

    if (!isNew) {
      txtName.text = invModel.name;
      txtCode.text = invModel.pCode.toString();
      txtQty.text = invModel.quantity.toString();
      txtPrice.text = invModel.price.toString();
    } else {
      scanBarcodeNormal();
      txtName.text = "";
      txtCode.text = "";
      txtQty.text = "";
      txtPrice.text = "";
    }

    return AlertDialog(
      title: Text((isNew) ? 'new entry...' : 'edit entry...'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: txtName,
                    decoration: const InputDecoration(hintText: 'product name'),
                  ),
                  TextFormField(
                    controller: txtCode,
                    decoration: const InputDecoration(
                      hintText: 'product code',
                    ),
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
                    decoration: const InputDecoration(hintText: 'quantity'),
                  ),
                  TextFormField(
                    controller: txtPrice,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: false,
                    ),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: const InputDecoration(hintText: 'unit price'),
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
                      invModel.name = txtName.text;
                      invModel.pCode = int.parse(txtCode.text);
                      invModel.quantity = int.parse(txtQty.text);
                      invModel.price = int.parse(txtPrice.text);
                      invModel.date = DateFormat.yMMMd().format(DateTime.now());
                      helper.insertInventoryList(invModel);
                      Navigator.pop(context);
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
