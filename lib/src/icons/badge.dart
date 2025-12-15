import 'package:flutter/material.dart';
import '../foundation/color_system.dart';
import '../foundation/theme.dart';
import '../foundation/radius_scale.dart';

/// Badge widget that can be attached to icons, avatars, buttons, etc.
class CoolBadge extends StatelessWidget {
  final Widget? child;
  final String? text;
  final Color? backgroundColor;
  final Color? textColor;
  final double? radius;
  final EdgeInsets? padding;
  final CoolBadgePosition position;
  final Offset? offset;

  const CoolBadge({
    super.key,
    this.child,
    this.text,
    this.backgroundColor,
    this.textColor,
    this.radius,
    this.padding,
    this.position = CoolBadgePosition.topRight,
    this.offset,
  }) : assert(
         child != null || text != null,
         'Either child or text must be provided',
       );

  @override
  Widget build(BuildContext context) {
    final coolColors = context.coolColors;
    final bgColor =
        backgroundColor ??
        coolColors?.resolve(CoolColorToken.error) ??
        Colors.red;
    final txtColor =
        textColor ??
        coolColors?.resolve(CoolColorToken.onError) ??
        Colors.white;
    final badgeRadius = radius ?? CoolRadiusScale.pill;
    final badgePadding =
        padding ?? const EdgeInsets.symmetric(horizontal: 6, vertical: 2);
    final off = offset ?? Offset.zero;

    Widget badge = Container(
      padding: badgePadding,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(badgeRadius),
      ),
      child:
          child ??
          Text(
            text!,
            style: TextStyle(
              color: txtColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
    );

    if (child == null) {
      return Transform.translate(offset: off, child: badge);
    }

    double? top;
    double? bottom;
    double? left;
    double? right;

    switch (position) {
      case CoolBadgePosition.topLeft:
        top = 0;
        left = 0;
        break;
      case CoolBadgePosition.topRight:
        top = 0;
        right = 0;
        break;
      case CoolBadgePosition.bottomLeft:
        bottom = 0;
        left = 0;
        break;
      case CoolBadgePosition.bottomRight:
        bottom = 0;
        right = 0;
        break;
      case CoolBadgePosition.center:
        top = 0;
        left = 0;
        break;
    }

    Widget positionedBadge = Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Transform.translate(
        offset: position == CoolBadgePosition.center
            ? off
            : Offset(
                position == CoolBadgePosition.topRight ||
                        position == CoolBadgePosition.bottomRight
                    ? -off.dx
                    : off.dx,
                position == CoolBadgePosition.bottomLeft ||
                        position == CoolBadgePosition.bottomRight
                    ? -off.dy
                    : off.dy,
              ),
        child: position == CoolBadgePosition.center
            ? Align(alignment: Alignment.center, child: badge)
            : badge,
      ),
    );

    return Stack(clipBehavior: Clip.none, children: [child!, positionedBadge]);
  }
}

enum CoolBadgePosition { topLeft, topRight, bottomLeft, bottomRight, center }
