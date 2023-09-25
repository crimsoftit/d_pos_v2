import 'package:d_pos_v2/models/inventory_model.dart';
import 'package:d_pos_v2/utils/db_helper.dart';
import 'package:flutter/material.dart';

class StockListDialog {
  final txtName = TextEditingController();
  final txtCode = TextEditingController();
  final txtQty = TextEditingController();

  Widget buildDialog(
      BuildContext context, InventoryModel invModel, bool isNew) {
    DbHelper helper = DbHelper();

    if (!isNew) {
      txtName.text = invModel.name;
      txtCode.text = invModel.pCode.toString();
      txtQty.text = invModel.quantity.toString();
    } else {
      txtName.text = "";
      txtCode.text = "";
      txtQty.text = "";
    }

    return AlertDialog(
      title: Text((isNew) ? 'new entry' : 'edit entry'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              controller: txtName,
              decoration: const InputDecoration(hintText: 'product name'),
            ),
            TextField(
              controller: txtCode,
              decoration: const InputDecoration(hintText: 'product code'),
            ),
            TextField(
              controller: txtQty,
              decoration: const InputDecoration(hintText: 'quantity'),
            ),
            ElevatedButton(
              child: const Text('save'),
              onPressed: () {
                invModel.name = txtName.text;
                invModel.pCode = int.parse(txtCode.text);
                invModel.quantity = int.parse(txtQty.text);
                helper.insertInventoryList(invModel);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
