import 'package:d_pos_v2/constants/constants.dart';
import 'package:d_pos_v2/models/analytic_info_model.dart';
import 'package:d_pos_v2/utils/db_helper.dart';
import 'package:flutter/material.dart';

class AnalyticInfoCard extends StatefulWidget {
  const AnalyticInfoCard({super.key, required this.info});

  final AnalyticInfo info;

  @override
  State<AnalyticInfoCard> createState() => _AnalyticInfoCardState();
}

var helper = DbHelper.instance;

class _AnalyticInfoCardState extends State<AnalyticInfoCard> {
  int totalInventoryValue = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "$totalInventoryValue",
              style: const TextStyle(
                color: textColor,
                fontSize: 18,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
