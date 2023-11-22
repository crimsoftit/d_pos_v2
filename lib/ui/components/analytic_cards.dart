import 'package:d_pos_v2/constants/constants.dart';
import 'package:d_pos_v2/data/data.dart';
import 'package:d_pos_v2/ui/components/analytic_info_card.dart';
import 'package:flutter/material.dart';

class AnalyticCards extends StatelessWidget {
  const AnalyticCards({super.key});

  @override
  Widget build(BuildContext context) {
    return const AnalyticInfoCardsGridView();
  }
}

class AnalyticInfoCardsGridView extends StatelessWidget {
  const AnalyticInfoCardsGridView({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: SizedBox(
        width: double.infinity,
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: analyticData.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: appPadding * 2,
          ),
          itemBuilder: (context, index) => AnalyticInfoCard(
            info: analyticData[index],
          ),
        ),
      ),
    );
  }
}
