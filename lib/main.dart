// ignore_for_file: must_be_immutable

import 'package:d_pos_v2/ui/stock_list.dart';
import 'package:flutter/material.dart';
import 'package:d_pos_v2/ui/stock_list_dialog.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  StockListDialog dialog = StockListDialog();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "inventory list",
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const StockList(),
    );
  }
}
