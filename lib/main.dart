// ignore_for_file: must_be_immutable

import 'package:d_pos_v2/ui/controllers/controller.dart';
import 'package:d_pos_v2/ui/responsive/desktop_scaffold.dart';
import 'package:d_pos_v2/ui/responsive/mobile_scaffold.dart';
import 'package:d_pos_v2/ui/responsive/responsive_layout.dart';
import 'package:d_pos_v2/ui/responsive/tablet_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:d_pos_v2/ui/stock_list_dialog.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  //StockListDialog dialog = StockListDialog();

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "DuaraPOS",
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => Controller(),
          ),
        ],
        child: const ResponsiveLayout(
          mobileScaffold: MobileScaffold(),
          tabletScaffold: TabletScaffold(),
          desktopScaffold: DesktopScaffold(),
        ),
      ),

      //StockList(),
    );
  }
}
