import 'dart:ui';

import 'package:flutter/material.dart';

class MobileWrapper extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final Color backgroundColor;

  const MobileWrapper({
    super.key,
    required this.child,
    this.maxWidth = 480,
    this.backgroundColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Color color = theme.colorScheme.primary;
    Color gradientColor = theme.scaffoldBackgroundColor;
    return Stack(
      children: [
        // Blurred background
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.lerp(color, gradientColor, .88)!,
                Color.lerp(color, gradientColor, .99)!,
              ],
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              color: Colors.black.withAlpha(10),
            ),
          ),
        ),
        // Mobile view container
        Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                MediaQuery.of(context).size.width > maxWidth ? 16 : 0,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(20),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: child,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
