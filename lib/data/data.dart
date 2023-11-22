import 'package:d_pos_v2/constants/constants.dart';
import 'package:d_pos_v2/models/analytic_info_model.dart';
import 'package:d_pos_v2/ui/components/analytic_info_card.dart';
import 'package:d_pos_v2/utils/db_helper.dart';
import 'package:flutter/material.dart';

int totalInventoryValue = 0;

DbHelper helper = DbHelper();

class AnalyticData extends StatefulWidget {
  const AnalyticData({super.key});

  @override
  State<AnalyticData> createState() => _AnalyticDataState();
}

class _AnalyticDataState extends State<AnalyticData> {
  void calcInvValue() async {
    await helper.openDb();
    var tInvValue = (await helper.getInventoryValue())[0]['T_INV'];
    print(tInvValue);
    setState(() {
      totalInventoryValue = tInvValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

List analyticData = [
  AnalyticInfo(
    title: "Inventory value",
    totalValue: 530,
    svgSrc: "assets/icons/Subscribers.svg",
    color: primaryColor,
  ),
  AnalyticInfo(
    title: "Total Sales",
    totalValue: 820,
    svgSrc: "assets/icons/Post.svg",
    color: purple,
  ),
  AnalyticInfo(
    title: "Total Credit",
    totalValue: 920,
    svgSrc: "assets/icons/Pages.svg",
    color: orange,
  ),
  AnalyticInfo(
    title: "Comments",
    totalValue: 920,
    svgSrc: "assets/icons/Comments.svg",
    color: green,
  ),
];
