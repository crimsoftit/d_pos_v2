// ignore_for_file: unnecessary_null_comparison, unused_import

import 'package:d_pos_v2/constants/constants.dart';
import 'package:d_pos_v2/ui/dialogs/sale_item_dialog.dart';
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

  int? fCount;

  @override
  void initState() {
    dialog = ForSaleItemDialog();
    super.initState();
    showSoldItems();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? subTitleStyle = Theme.of(context).textTheme.bodySmall;
    showSoldItems();
    return RefreshIndicator(
      onRefresh: () async {
        showSoldItems();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('S A L E S'),
          foregroundColor: Colors.white,
          backgroundColor: primaryColor,
        ),
        body: ListView.builder(
          itemCount: (soldItems != null) ? soldItems.length : 0,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              color: Colors.white,
              elevation: 1.0,
              child: ListTile(
                title: Text(soldItems[index].name),
                leading: CircleAvatar(
                  backgroundColor: primaryColor,
                  child: Text(soldItems[index].name[0]),
                ),
                subtitle: Text(
                  soldItems[index].date,
                  style: subTitleStyle,
                ),
                //'qty: ${soldItems[index].quantity} - date: ${soldItems[index].date} - barcode: ${soldItems[index].productCode} - unit price: ${soldItems[index].price}'
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => dialog.buildAlert(
                            context,
                            soldItems[index],
                            false,
                          ));
                },
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
              ),
            );
          },
        ),
        //backgroundColor: myDefaultBackground,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            //showScannedItems(fetchedCode!);
            //ScanItem();

            showDialog(
              context: context,
              builder: (BuildContext context) => dialog.buildAlert(
                  context, SalesItemModel("", "", 0, 0, ""), true),
            );
          },
          backgroundColor: Colors.brown,
          foregroundColor: Colors.white,
          hoverColor: Colors.orange,
          splashColor: Colors.tealAccent,
          focusColor: Colors.blue,
          child: const Icon(Icons.add),
        ),
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
