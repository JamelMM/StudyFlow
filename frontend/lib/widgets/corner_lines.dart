import 'package:flutter/material.dart';

class CornerLines extends StatelessWidget {
  const CornerLines({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: -10,
      bottom: 0,
      child: SizedBox(
        width: 100, //40
        height: 100, // 30
        child: Stack(
          children: [
            Positioned(
              right: -15,
              bottom: 0,
              child: Transform.rotate(
                angle: -0.7,
                child: Container(
                  width: 130,
                  height: 3,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            Positioned(
              right: -30,
              bottom: 0,
              child: Transform.rotate(
                angle: -0.7,
                child: Container(
                  width: 130,
                  height: 3,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
