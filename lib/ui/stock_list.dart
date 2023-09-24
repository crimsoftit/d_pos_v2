// ignore_for_file: unnecessary_null_comparison

import 'package:d_pos_v2/ui/inventory_items_screen.dart';
import 'package:d_pos_v2/ui/stock_list_dialog.dart';
import 'package:d_pos_v2/utils/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:d_pos_v2/models/inventory_model.dart';

class StockList extends StatefulWidget {
  const StockList({super.key});

  @override
  State<StockList> createState() => _StockListState();
}

class _StockListState extends State<StockList> {
  late List<InventoryModel> inventoryList = [];
  DbHelper helper = DbHelper();
  StockListDialog dialog = StockListDialog();

  @override
  void initState() {
    dialog = StockListDialog();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    showInventoryData();

    return Scaffold(
      appBar: AppBar(
        title: const Text('inventory list'),
      ),
      body: ListView.builder(
          itemCount: (inventoryList != null) ? inventoryList.length : 0,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              key: Key(inventoryList[index].name),
              onDismissed: (direction) {
                String strName = inventoryList[index].name;
                helper.deleteInventoryItem(inventoryList[index]);
                setState(() {
                  inventoryList.removeAt(index);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("$strName deleted"),
                  ),
                );
              },
              child: ListTile(
                title: Text(inventoryList[index].name),
                leading: CircleAvatar(
                  child: Text(inventoryList[index].priority.toString()),
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => dialog.buildDialog(
                      context,
                      InventoryModel(0, 0, '', 0),
                      true,
                    ),
                  );
                },
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => dialog.buildDialog(
                              context,
                              inventoryList[index],
                              false,
                            ));
                  },
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => dialog.buildDialog(
              context,
              InventoryModel(0, 0, '', 0),
              true,
            ),
          );
        },
        backgroundColor: Colors.pink,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future showInventoryData() async {
    await helper.openDb();
    inventoryList = await helper.getInventoryList();
    setState(() {
      inventoryList = inventoryList;
    });
  }
}