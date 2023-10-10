// ignore_for_file: unnecessary_null_comparison

import 'package:d_pos_v2/dialogs/stock_list_dialog.dart';
import 'package:d_pos_v2/utils/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:d_pos_v2/models/inventory_model.dart';

class StockList extends StatefulWidget {
  const StockList({super.key});

  @override
  State<StockList> createState() => _StockListState();
}

class _StockListState extends State<StockList> {
  List<InventoryModel> inventoryList = [];
  DbHelper helper = DbHelper();
  StockListDialog dialog = StockListDialog();

  @override
  void initState() {
    dialog = StockListDialog();
    super.initState();
    //showInventoryData();
  }

  @override
  Widget build(BuildContext context) {
    showInventoryData();

    return RefreshIndicator(
      onRefresh: () async {
        await helper.openDb();
        inventoryList = await helper.getInventoryList();
        setState(() {
          inventoryList = inventoryList;
        });
      },
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: const Text(
            'inventory list',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
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
                    child: Text(inventoryList[index].quantity.toString()),
                  ),
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) =>
                    //         SoldItemsScreen(inventoryList[index]),
                    //   ),
                    // );
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => dialog.buildDialog(
                        context,
                        inventoryList[index],
                        false,
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
                InventoryModel(0, 0, '', 0, 0, 0, ''),
                true,
              ),
            );
          },
          backgroundColor: Colors.brown,
          foregroundColor: Colors.white,
          child: const Icon(
            Icons.add,
          ),
        ),
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
