import 'package:flutter/material.dart';
import 'package:frontend/widgets/corner_lines.dart';

class StudyFlowScreenBody extends StatelessWidget {
  const StudyFlowScreenBody({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(children: [child, const CornerLines()]),
    );
  }
}
