import 'package:d_pos_v2/constants/constants.dart';
import 'package:d_pos_v2/ui/components/analytic_cards.dart';
import 'package:flutter/material.dart';

class DashboardContent extends StatefulWidget {
  const DashboardContent({super.key});

  @override
  State<DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> {
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(appPadding),
        child: Column(
          children: [
            AnalyticCards(),
          ],
        ),
      ),
    );
  }
}
