import 'package:flutter/material.dart';

class ResponsiveBreakpoints {
  const ResponsiveBreakpoints._();

  static bool isTabletOrWider(double width) => width >= 700;

  static bool isDesktopOrWider(double width) => width >= 1100;

  static int gridColumns(double width) {
    if (isDesktopOrWider(width)) {
      return 3;
    }

    if (isTabletOrWider(width)) {
      return 2;
    }

    return 1;
  }

  static double horizontalPadding(double width) {
    if (isDesktopOrWider(width)) {
      return 48;
    }

    if (isTabletOrWider(width)) {
      return 32;
    }

    return 16;
  }
}

class ResponsiveContent extends StatelessWidget {
  const ResponsiveContent({
    super.key,
    required this.child,
    this.maxWidth = 1000,
    this.padding,
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontalPadding = ResponsiveBreakpoints.horizontalPadding(
          constraints.maxWidth,
        );

        return Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Padding(
              padding:
                  padding ??
                  EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: child,
            ),
          ),
        );
      },
    );
  }
}
