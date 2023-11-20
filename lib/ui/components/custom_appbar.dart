import 'package:d_pos_v2/ui/components/search_field.dart';
import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: SearchField(),
        ),
      ],
    );
  }
}
