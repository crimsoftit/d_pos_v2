// ignore_for_file: no_logic_in_create_state

import 'package:d_pos_v2/dialogs/helpers/dialog_helper.dart';
import 'package:d_pos_v2/models/inventory_model.dart';
import 'package:d_pos_v2/models/sales_item_model.dart';
import 'package:d_pos_v2/ui/components/custom_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:d_pos_v2/utils/db_helper.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:intl/intl.dart';

class ForSaleItemDialog extends StatefulWidget {
  final InventoryModel inventory = InventoryModel(0, 0, '', 0, 0, 0, '');
  List<InventoryModel> items = [];
  final txtCode = TextEditingController();
  final txtName = TextEditingController();
  final txtQty = TextEditingController();
  final txtUnitPrice = TextEditingController();

  final hiddenField = TextEditingController();

  DbHelper helper = DbHelper();

  bool btnVisible = false;

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
    }

    scanBarcode();

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
                      readOnly: true,
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
                          return 'inventory item NOT found';
                        }
                        return null;
                      },
                    ),
                    Visibility(
                      visible: true,
                      child: TextField(
                        controller: hiddenField,
                        //readOnly: true,
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
                              forSaleItem.productCode = int.parse(txtCode.text);
                              forSaleItem.quantity = int.parse(txtQty.text);
                              forSaleItem.date =
                                  DateFormat.yMMMd().format(DateTime.now());
                              forSaleItem.price = int.parse(txtUnitPrice.text);

                              // update qty in inventory
                              inventory.pCode =
                                  inventory.pCode - int.parse(txtQty.text);
                              helper.onSaleSuccessUpdateInventory(
                                  inventory, inventory.pCode);

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

      int sr = int.parse(scanResults);
      showFetchedItem(sr);
    } on PlatformException {
      scanResults = "failed to get platform version ..";
    }
  }

  Future showFetchedItem(int prCode) async {
    await helper.openDb();

    var fCount = await helper.getFetchedItemCount(prCode);

    hiddenField.text = fCount.toString();

    if (hiddenField.text == "0") {
      setState(() {
        btnVisible = false;
      });
    }

    if (fCount! >= 1) {
      setState(() {
        btnVisible = true;
      });
      items = await helper.getScannedInvList(prCode);

      for (var i = 0; i < items.length; i++) {
        txtCode.text = items[i].pCode.toString();
        txtName.text = items[i].name;
        hiddenField.text = fCount.toString();
        txtUnitPrice.text = items[i].unitSellingPrice.toString();
      }
    } else {
      hiddenField.text = 'item not found in inventory';
    }
  }

  // update item qty in inventory after successful sale
  void updateInvQty() {
    inventory.quantity -= int.parse(txtQty.text);
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }

  void setState(Null Function() param0) {}
}
