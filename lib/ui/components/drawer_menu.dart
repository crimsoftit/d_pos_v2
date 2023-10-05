// ignore_for_file: must_be_immutable

import 'package:d_pos_v2/ui/components/drawer_list_tile.dart';
import 'package:d_pos_v2/constants/constants.dart';
import 'package:d_pos_v2/ui/sold_items_screen.dart';
import 'package:d_pos_v2/ui/stock_list.dart';
import 'package:flutter/material.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(2.0),
            child: Image.asset('assets/images/dhc_logo.png'),
          ),
          DrawerListTile(
            title: 'D A S H B O A R D',
            svgSrc: 'assets/icons/Dashboard.svg',
            tap: () {},
          ),
          DrawerListTile(
            title: 'M E S S A G E S',
            svgSrc: 'assets/icons/Message.svg',
            tap: () {},
          ),
          DrawerListTile(
            title: 'I N V E N T O R Y',
            svgSrc: 'assets/icons/inventory.svg',
            tap: () async {
              await Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                return const StockList();
              }));
            },
          ),
          DrawerListTile(
            title: 'S A L E S',
            svgSrc: 'assets/icons/stock.svg',
            tap: () async {
              await Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                return const SoldItemsScreen();
              }));
            },
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: appPadding * 2),
            child: Divider(
              color: Colors.grey,
              thickness: 0.2,
            ),
          ),
          DrawerListTile(
            title: 'S T A T I S T I CS',
            svgSrc: 'assets/icons/Statistics.svg',
            tap: () {},
          ),
          DrawerListTile(
            title: 'S E T T I N G S',
            svgSrc: 'assets/icons/Settings.svg',
            tap: () {},
          ),
          DrawerListTile(
            title: 'logout',
            svgSrc: 'assets/icons/Logout.svg',
            tap: () {},
          ),
        ],
      ),
    );
  }
}
