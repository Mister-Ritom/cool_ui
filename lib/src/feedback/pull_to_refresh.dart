import 'package:flutter/material.dart';
import '../foundation/theme.dart';
import '../foundation/color_system.dart';

class CoolPullToRefresh extends StatelessWidget {
  final Widget child;
  final RefreshCallback onRefresh;
  final Color? color;
  final Color? backgroundColor;

  const CoolPullToRefresh({
    super.key,
    required this.child,
    required this.onRefresh,
    this.color,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final coolColors = context.coolColors;

    return RefreshIndicator(
      onRefresh: onRefresh,
      color:
          color ?? coolColors?.resolve(CoolColorToken.primary) ?? Colors.blue,
      backgroundColor:
          backgroundColor ??
          coolColors?.resolve(CoolColorToken.surface) ??
          Colors.white,
      strokeWidth: 2.5,
      displacement: 40,
      edgeOffset: 0,
      child: child,
    );
  }
}
