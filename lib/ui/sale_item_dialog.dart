import 'package:d_pos_v2/models/inventory_model.dart';
import 'package:d_pos_v2/models/sales_item_model.dart';
import 'package:flutter/material.dart';
import 'package:d_pos_v2/utils/db_helper.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

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
    TextStyle? textStyle = Theme.of(context).textTheme.bodyMedium;
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
    }

    return AlertDialog(
      title: Text((isNew) ? 'new sale entry' : 'edit sale entry'),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: txtCode,
              decoration: const InputDecoration(
                hintText: 'product barcode',
              ),
            ),
            TextFormField(
              controller: txtName,
              decoration: const InputDecoration(
                hintText: 'product name',
              ),
            ),
            TextFormField(
              controller: txtQty,
              decoration: const InputDecoration(
                hintText: 'quantity',
              ),
            ),
            Text(txt),
            TextFormField(
              controller: txtUnitPrice,
              decoration: const InputDecoration(
                hintText: 'unit price',
              ),
            ),
            ElevatedButton(
              child: Text('sell item'),
              onPressed: () {
                forSaleItem.name = txtName.text;
                forSaleItem.productCode = int.parse(txtCode.text);
                forSaleItem.quantity = int.parse(txtQty.text);
                forSaleItem.date = DateFormat.yMMMd().format(DateTime.now());
                forSaleItem.price = int.parse(txtUnitPrice.text);

                helper.insertSalesItem(forSaleItem);

                Navigator.pop(context);
              },
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
    txtQty.text = (items.length).toString();
    for (var i = 0; i < items.length; i++) {
      txtName.text = items[i].name;
    }
  }
}
