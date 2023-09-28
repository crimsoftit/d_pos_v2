import 'package:d_pos_v2/components/drawer_list_tile.dart';
import 'package:d_pos_v2/constants/constants.dart';
import 'package:d_pos_v2/models/inventory_model.dart';
import 'package:d_pos_v2/ui/sold_items_screen.dart';
import 'package:d_pos_v2/ui/stock_list.dart';
import 'package:flutter/material.dart';

class DrawerMenu extends StatelessWidget {
  DrawerMenu({super.key});

  List<InventoryModel> inventoryList = [];

  @override
  Widget build(
    BuildContext context,
  ) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(appPadding),
            child: Image.asset('assets/images/dhc_logo.png'),
          ),
          DrawerListTile(
              title: 'dashboard',
              svgSrc: 'assets/icons/Dashboard.svg',
              tap: () {}),
          DrawerListTile(
              title: 'messages',
              svgSrc: 'assets/icons/Message.svg',
              tap: () {}),
          DrawerListTile(
              title: 'inventory',
              svgSrc: 'assets/icons/inventory.svg',
              tap: () async {
                await Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                  return const StockList();
                }));
              }),
          DrawerListTile(
              title: 'sales',
              svgSrc: 'assets/icons/stock.svg',
              tap: () async {
                await Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                  return SoldItemsScreen();
                }));
              }),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: appPadding * 2),
            child: Divider(
              color: Colors.grey,
              thickness: 0.2,
            ),
          ),
          DrawerListTile(
              title: 'statistics',
              svgSrc: 'assets/icons/Statistics.svg',
              tap: () {}),
          DrawerListTile(
              title: 'settings',
              svgSrc: 'assets/icons/Settings.svg',
              tap: () {}),
          DrawerListTile(
              title: 'logout', svgSrc: 'assets/icons/Logout.svg', tap: () {}),
        ],
      ),
    );
  }
}
