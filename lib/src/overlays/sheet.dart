import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../foundation/color_system.dart';
import '../foundation/theme.dart';
import '../foundation/radius_scale.dart';
import '../foundation/motion.dart';

/// Sheet direction
enum CoolSheetDirection { bottom, top, left, right }

/// Sheet widget with directional support
class CoolSheet extends StatelessWidget {
  final Widget child;
  final String? title;
  final List<Widget>? actions;
  final CoolSheetDirection direction;
  final double? width;
  final double? height;
  final bool isDismissible;
  final bool enableDrag;
  final Color? backgroundColor;

  const CoolSheet({
    super.key,
    required this.child,
    this.title,
    this.actions,
    this.direction = CoolSheetDirection.bottom,
    this.width,
    this.height,
    this.isDismissible = true,
    this.enableDrag = true,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final coolColors = context.coolColors;
    final bgColor =
        backgroundColor ??
        coolColors?.resolve(CoolColorToken.surface) ??
        Colors.white;

    final radius = _getRadiusForDirection();

    Widget sheet = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: bgColor, borderRadius: radius),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null || actions != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color:
                        coolColors?.resolve(CoolColorToken.border) ??
                        Colors.grey.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  if (title != null)
                    Expanded(
                      child: Text(
                        title!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  if (actions != null) ...actions!,
                ],
              ),
            ),
          Flexible(child: child),
        ],
      ),
    );

    // Apply blur backdrop
    sheet = ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: sheet,
      ),
    );

    return sheet
        .animate()
        .fadeIn(duration: CoolMotion.config.defaultDuration)
        .then()
        .slide(
          begin: _getSlideBegin(),
          end: Offset.zero,
          duration: CoolMotion.config.defaultDuration,
        );
  }

  BorderRadius _getRadiusForDirection() {
    switch (direction) {
      case CoolSheetDirection.bottom:
        return const BorderRadius.only(
          topLeft: Radius.circular(CoolRadiusScale.xxl),
          topRight: Radius.circular(CoolRadiusScale.xxl),
        );
      case CoolSheetDirection.top:
        return const BorderRadius.only(
          bottomLeft: Radius.circular(CoolRadiusScale.xxl),
          bottomRight: Radius.circular(CoolRadiusScale.xxl),
        );
      case CoolSheetDirection.left:
        return const BorderRadius.only(
          topRight: Radius.circular(CoolRadiusScale.xxl),
          bottomRight: Radius.circular(CoolRadiusScale.xxl),
        );
      case CoolSheetDirection.right:
        return const BorderRadius.only(
          topLeft: Radius.circular(CoolRadiusScale.xxl),
          bottomLeft: Radius.circular(CoolRadiusScale.xxl),
        );
    }
  }

  Offset _getSlideBegin() {
    switch (direction) {
      case CoolSheetDirection.bottom:
        return const Offset(0, 1);
      case CoolSheetDirection.top:
        return const Offset(0, -1);
      case CoolSheetDirection.left:
        return const Offset(-1, 0);
      case CoolSheetDirection.right:
        return const Offset(1, 0);
    }
  }

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    List<Widget>? actions,
    CoolSheetDirection direction = CoolSheetDirection.bottom,
    double? width,
    double? height,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: Colors.transparent,
      builder: (context) => CoolSheet(
        title: title,
        actions: actions,
        direction: direction,
        width: width,
        height: height,
        isDismissible: isDismissible,
        enableDrag: enableDrag,
        backgroundColor: backgroundColor,
        child: child,
      ),
    );
  }
}
