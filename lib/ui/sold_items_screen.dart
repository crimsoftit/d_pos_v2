// ignore_for_file: unnecessary_null_comparison

import 'package:d_pos_v2/dialogs/sale_item_dialog.dart';
import 'package:d_pos_v2/utils/db_helper.dart';
import 'package:flutter/material.dart';

import 'package:d_pos_v2/models/sales_item_model.dart';

class SoldItemsScreen extends StatefulWidget {
  const SoldItemsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _SoldItemsScreenState createState() => _SoldItemsScreenState();
}

class _SoldItemsScreenState extends State<SoldItemsScreen> {
  _SoldItemsScreenState();

  DbHelper helper = DbHelper();

  List<SalesItemModel> soldItems = [];

  ForSaleItemDialog dialog = ForSaleItemDialog();

  @override
  void initState() {
    dialog = ForSaleItemDialog();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    showSoldItems();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales'),
      ),
      body: ListView.builder(
        itemCount: (soldItems != null) ? soldItems.length : 0,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(soldItems[index].name),
            subtitle: Text(
                'qty: ${soldItems[index].quantity} - date: ${soldItems[index].date} - barcode: ${soldItems[index].productCode} - unit price: ${soldItems[index].price}'),
            onTap: () {},
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => dialog.buildAlert(
                          context,
                          soldItems[index],
                          false,
                        ));
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //showScannedItems(fetchedCode!);
          showDialog(
            context: context,
            builder: (BuildContext context) => dialog.buildAlert(
                context, SalesItemModel(0, "", 0, 0, ""), true),
          );
        },
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
        hoverColor: Colors.orange,
        splashColor: Colors.tealAccent,
        focusColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future showSoldItems() async {
    await helper.openDb();
    soldItems = await helper.getSalesList();
    setState(() {
      soldItems = soldItems;
    });
  }
}
