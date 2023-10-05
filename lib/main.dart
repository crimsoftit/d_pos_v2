// ignore_for_file: must_be_immutable

import 'package:d_pos_v2/responsive/desktop_scaffold.dart';
import 'package:d_pos_v2/responsive/mobile_scaffold.dart';
import 'package:d_pos_v2/responsive/responsive_layout.dart';
import 'package:d_pos_v2/responsive/tablet_scaffold.dart';
import 'package:flutter/material.dart';
//import 'package:d_pos_v2/ui/stock_list_dialog.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  //StockListDialog dialog = StockListDialog();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "DuaraPOS",
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const ResponsiveLayout(
        mobileScaffold: MobileScaffold(),
        tabletScaffold: TabletScaffold(),
        desktopScaffold: DesktopScaffold(),
      ),
      //StockList(),
    );
  }
}
