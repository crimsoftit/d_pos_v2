import 'package:d_pos_v2/ui/sale_item_dialog.dart';
import 'package:d_pos_v2/utils/db_helper.dart';
import 'package:flutter/material.dart';

import 'package:d_pos_v2/models/sales_item_model.dart';

class SoldItemsScreen extends StatefulWidget {
  SoldItemsScreen({super.key});

  @override
  _SoldItemsScreenState createState() => _SoldItemsScreenState();
}

class _SoldItemsScreenState extends State<SoldItemsScreen> {
  _SoldItemsScreenState();

  DbHelper helper = DbHelper();

  List<SalesItemModel> forSaleItems = [];

  ForSaleItemDialog dialog = ForSaleItemDialog();

  @override
  void initState() {
    dialog = ForSaleItemDialog();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    showFetchedItems();
    return Scaffold(
      appBar: AppBar(
        title: Text('Sales'),
      ),
      body: ListView.builder(
        itemCount: (forSaleItems != null) ? forSaleItems.length : 0,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(forSaleItems[index].name),
            subtitle: Text(
                'qty: ${forSaleItems[index].quantity} - date: ${forSaleItems[index].date} - barcode: ${forSaleItems[index].productCode}'),
            onTap: () {},
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => dialog.buildAlert(
                          context,
                          forSaleItems[index],
                          false,
                        ));
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) =>
                dialog.buildAlert(context, SalesItemModel(0, "", 0, ""), true),
          );
        },
        backgroundColor: Colors.pink,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future showFetchedItems() async {
    await helper.openDb();
    forSaleItems = await helper.getSalesList();
    setState(() {
      forSaleItems = forSaleItems;
    });
  }
}
