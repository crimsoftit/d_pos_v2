import 'package:d_pos_v2/utils/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:d_pos_v2/models/inventory_model.dart';
import 'package:d_pos_v2/models/sales_item_model.dart';

class SoldItemsScreen extends StatefulWidget {
  final InventoryModel fetchedInvItems;

  SoldItemsScreen(this.fetchedInvItems, {super.key});

  @override
  _SoldItemsScreenState createState() =>
      _SoldItemsScreenState(this.fetchedInvItems);
}

class _SoldItemsScreenState extends State<SoldItemsScreen> {
  final InventoryModel fetchedInvItems;
  _SoldItemsScreenState(this.fetchedInvItems);

  DbHelper helper = DbHelper();

  List<SalesItemModel> forSaleItems = [];

  @override
  Widget build(BuildContext context) {
    showFetchedItems(fetchedInvItems.pCode);
    return Scaffold(
      appBar: AppBar(
        title: Text(fetchedInvItems.name),
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
              onPressed: () {},
            ),
          );
        },
      ),
    );
  }

  Future showFetchedItems(int pCode) async {
    await helper.openDb();
    forSaleItems = await helper.getInvItemDetails(pCode);
    setState(() {
      forSaleItems = forSaleItems;
    });
  }
}
