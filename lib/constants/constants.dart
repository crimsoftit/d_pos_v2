import 'package:d_pos_v2/ui/components/drawer_list_tile.dart';
import 'package:flutter/material.dart';

var myDefaultBackground = Colors.orange[100];

// Default App Padding
const appPadding = 2.0;

var myAppBar = AppBar(
  backgroundColor: myDefaultBackground,
);

var myDrawer = Drawer(
  backgroundColor: myDefaultBackground,
  child: Column(
    children: [
      DrawerHeader(
        child: Image.asset('assets/images/dhc_logo.png'),
      ),
      const ListTile(
        leading: Icon(Icons.home),
        title: Text('D A S H B O A R D'),
      ),
      const ListTile(
        leading: Icon(Icons.inventory),
        title: Text(''),
      ),
      DrawerListTile(
          title: 'I N V E N T O R Y',
          svgSrc: 'assets/icons/inventory.svg',
          tap: () {}),
      const ListTile(
        leading: Icon(Icons.currency_exchange_outlined),
        title: Text('I N V E N T O R Y'),
      ),
    ],
  ),
);
