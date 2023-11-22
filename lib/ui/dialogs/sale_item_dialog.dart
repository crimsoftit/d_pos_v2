// ignore_for_file: no_logic_in_create_state, must_be_immutable

import 'package:d_pos_v2/models/inventory_model.dart';
import 'package:d_pos_v2/models/sales_item_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:d_pos_v2/utils/db_helper.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:intl/intl.dart';

class ForSaleItemDialog extends StatefulWidget {
  List<InventoryModel> items = [];
  final txtCode = TextEditingController();
  final txtName = TextEditingController();
  final txtQty = TextEditingController();
  final txtUnitPrice = TextEditingController();
  final txtInvQtyAvailable = TextEditingController();

  final hiddenField = TextEditingController();

  DbHelper helper = DbHelper();

  int? invItemQty;
  int? totalCost;

  ForSaleItemDialog({super.key});

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

      totalCost = forSaleItem.quantity * forSaleItem.price;
      setState(() {
        totalCost = totalCost;
      });
    } else {
      txtCode.text = "";
      txtName.text = "";
      txtQty.text = "";
      txtUnitPrice.text = "";
      scanBarcode();
    }

    return AlertDialog(
      title: Text((isNew) ? 'new sale entry' : 'edit sale entry'),
      content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return SingleChildScrollView(
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
                      readOnly: true,
                      decoration: InputDecoration(
                          labelText: 'product barcode',
                          labelStyle: textStyle,
                          hintStyle:
                              const TextStyle(fontStyle: FontStyle.italic)),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: false,
                        signed: false,
                      ),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'inventory item NOT found';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: txtName,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'product name',
                        labelStyle: textStyle,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'inventory item NOT found';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: txtQty,
                      decoration: InputDecoration(
                        labelText: (invItemQty) != null
                            ? 'quantity/no. of units ($invItemQty available)'
                            : 'quantity/no. of units',
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
                        } else if (int.parse(value) > invItemQty!) {
                          return 'only $invItemQty item(s) available in stock...';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        totalCost =
                            int.parse(value) * int.parse(txtUnitPrice.text);

                        setState(() {
                          totalCost = totalCost;
                        });
                      },
                    ),
                    TextFormField(
                      controller: txtUnitPrice,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'unit price',
                        labelStyle: textStyle,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'inventory item NOT found';
                        }
                        return null;
                      },
                    ),
                    Card(
                      elevation: 2.0,
                      color: Colors.white,
                      child: SizedBox(
                        height: 40,
                        child: Text('Total cost - $totalCost'),
                      ),
                    ),
                    Visibility(
                      visible: true,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: ElevatedButton(
                          onPressed: () {
                            // validator returns true if form is valid and vice-versa
                            if (formKey.currentState!.validate()) {
                              forSaleItem.name = txtName.text;
                              forSaleItem.productCode = txtCode.text;
                              forSaleItem.quantity = int.parse(txtQty.text);
                              forSaleItem.date =
                                  DateFormat.yMMMd().format(DateTime.now());
                              forSaleItem.price = int.parse(txtUnitPrice.text);

                              // update qty in inventory
                              int pQty = int.parse(txtInvQtyAvailable.text) -
                                  int.parse(txtQty.text);
                              helper.onSaleSuccessUpdateInventory(
                                  pQty, forSaleItem.productCode);

                              helper.insertSalesItem(forSaleItem);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Processing Data')),
                              );
                              Navigator.pop(context);
                            }
                          },
                          child: const Text('sell item'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Future scanBarcode() async {
    String scanResults;

    try {
      scanResults = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'cancel', true, ScanMode.BARCODE);

      showFetchedItem(scanResults);
    } on PlatformException {
      scanResults = "failed to get platform version ..";
    }
  }

  Future showFetchedItem(String prCode) async {
    await helper.openDb();

    var fCount = await helper.getFetchedItemCount(prCode);

    hiddenField.text = fCount.toString();

    if (fCount! >= 1) {
      items = await helper.getScannedInvList(prCode);

      for (var i = 0; i < items.length; i++) {
        invItemQty = items[i].quantity;

        txtCode.text = items[i].pCode;
        txtName.text = items[i].name;
        txtInvQtyAvailable.text = items[i].quantity.toString();
        txtUnitPrice.text = items[i].unitSellingPrice.toString();
      }
    } else {
      hiddenField.text = 'item not found in inventory';
    }
  }

  // update item qty in inventory after successful sale

  @override
  State<StatefulWidget> createState() {
    throw UnimplementedError();
  }

  void setState(Null Function() param0) {}
}
