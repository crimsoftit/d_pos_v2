import 'package:d_pos_v2/utils/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:d_pos_v2/models/inventory_model.dart';
import 'package:d_pos_v2/models/sales_item.dart';

class InventoryItemsScreen extends StatefulWidget {
  final InventoryModel inventoryModel;

  const InventoryItemsScreen(this.inventoryModel, {super.key});

  @override
  _ItemsScreenState createState() => _ItemsScreenState(this.inventoryModel);
}

class _ItemsScreenState extends State<InventoryItemsScreen> {
  final InventoryModel inventoryModel;

  _ItemsScreenState(this.inventoryModel);

  DbHelper helper = DbHelper();

  late List<InventoryModel> stockItems;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(inventoryModel.name),
      ),
      body: ListView.builder(
        itemCount: (stockItems != null) ? stockItems.length : 0,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(stockItems[index].name),
            subtitle: Text('qty: ${stockItems[index].priority}'),
            onTap: () {},
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {},
            ),
          );
        },
      ),
    );
  }

  // Future showInventoryDetails(int pCode) async {
  //   await helper.openDb();
  //   stockItems = await helper.getInventoryList(pCode);
  //   setState(() {
  //     stockItems = stockItems;
  //   });
  // }
}
