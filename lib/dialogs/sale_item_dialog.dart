import 'package:d_pos_v2/models/inventory_model.dart';
import 'package:d_pos_v2/models/sales_item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:d_pos_v2/utils/db_helper.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:intl/intl.dart';

class ForSaleItemDialog {
  final txtCode = TextEditingController();
  final txtName = TextEditingController();
  final txtQty = TextEditingController();
  final txtUnitPrice = TextEditingController();

  DbHelper helper = DbHelper();

  String txt = "";

  List<InventoryModel> items = [];

  Widget buildAlert(
      BuildContext context, SalesItemModel forSaleItem, bool isNew) {
    final formKey = GlobalKey<FormState>();
    var textStyle = Theme.of(context).textTheme.bodyMedium;
    helper.openDb();

    if (!isNew) {
      txtCode.text = forSaleItem.productCode.toString();
      txtName.text = forSaleItem.name;
      txtQty.text = forSaleItem.quantity.toString();
      txtUnitPrice.text = forSaleItem.price.toString();
    } else {
      txtCode.text = "";
      txtName.text = "";
      txtQty.text = "";
      txtUnitPrice.text = "";
      scanBarcode();

      // if (items.isEmpty) {
      //   Navigator.pop(context);
      // }
    }

    return AlertDialog(
      title: Text((isNew) ? 'new sale entry' : 'edit sale entry'),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // form to process and save input data into the database
            Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: txtCode,
                    //readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'product barcode',
                      labelStyle: textStyle,
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: false,
                      signed: false,
                    ),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
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
                    controller: txtQty,
                    decoration: InputDecoration(
                      labelText: 'quantity/no. of units',
                      labelStyle: textStyle,
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: false,
                      signed: false,
                    ),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: txtUnitPrice,
                    decoration: InputDecoration(
                      labelText: 'unit price',
                      labelStyle: textStyle,
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: false,
                    ),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: ElevatedButton(
                      onPressed: () {
                        // validator returns true if form is valid and vice-versa
                        if (formKey.currentState!.validate()) {
                          forSaleItem.name = txtName.text;
                          forSaleItem.productCode = int.parse(txtCode.text);
                          forSaleItem.quantity = int.parse(txtQty.text);
                          forSaleItem.date =
                              DateFormat.yMMMd().format(DateTime.now());
                          forSaleItem.price = int.parse(txtUnitPrice.text);

                          helper.insertSalesItem(forSaleItem);

                          Navigator.pop(context);
                        }
                      },
                      child: const Text('sell item'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void scanBarcode() async {
    String scanResults;

    try {
      scanResults = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'cancel', true, ScanMode.BARCODE);
      txtCode.text = scanResults;
      txt = scanResults;
      int sr = int.parse(scanResults);
      showFetchedItem(sr);
    } catch (err) {
      scanResults = err.toString();
      debugPrint(err.toString());
    }
  }

  Future showFetchedItem(int prCode) async {
    await helper.openDb();

    items = await helper.getScannedInvList(prCode);

    for (var i = 0; i < items.length; i++) {
      txtName.text = items[i].name;
      txtUnitPrice.text = items[i].unitSellingPrice.toString();
    }
  }
}
