import 'package:d_pos_v2/models/sales_item_model.dart';
import 'package:flutter/material.dart';
import 'package:d_pos_v2/utils/db_helper.dart';
import 'package:intl/intl.dart';

class ForSaleItemDialog {
  final txtCode = TextEditingController();
  final txtName = TextEditingController();
  final txtQty = TextEditingController();

  Widget buildAlert(
      BuildContext context, SalesItemModel forSaleItem, bool isNew) {
    DbHelper helper = DbHelper();
    helper.openDb();

    if (!isNew) {
      txtCode.text = (forSaleItem.productCode.toString());
      txtName.text = forSaleItem.name;
      txtQty.text = (forSaleItem.quantity.toString());
    }

    return AlertDialog(
      title: Text((isNew) ? 'new stock entry' : 'edit stock entry'),
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
            ElevatedButton(
              child: const Text('save'),
              onPressed: () {
                forSaleItem.name = txtName.text;
                forSaleItem.productCode = int.parse(txtCode.text);
                forSaleItem.quantity = int.parse(txtQty.text);
                forSaleItem.date = DateFormat.yMMMd().format(DateTime.now());

                helper.insertSalesItem(forSaleItem);

                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
