import 'dart:ui';

import 'package:flutter/material.dart';
import '../foundation/color_system.dart';
import '../foundation/theme.dart';
import '../foundation/elevation_model.dart';
import '../infrastructure/tappable.dart';

/// Card widget with blur + tint surface
class CoolCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? radius;
  final int? elevation;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const CoolCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.radius,
    this.elevation,
    this.backgroundColor,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final coolColors = context.coolColors;
    final hasElevation = elevation != null && elevation! > 0;
    final bgColor =
        backgroundColor ??
        (hasElevation
            ? CoolElevationModel.getElevationColor(coolColors!, elevation!)
            : coolColors?.resolve(CoolColorToken.surface)) ??
        Colors.transparent;

    final borderRadius = radius ?? context.coolRadius;
    final blurAmount = hasElevation
        ? CoolElevationModel.getBlurForLevel(elevation!)
        : 0.0;

    Widget card = Container(
      padding: padding ?? const EdgeInsets.all(16),
      margin: margin,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(borderRadius),
        // Add subtle border for elevated cards to create separation
        border: hasElevation
            ? Border.all(
                color:
                    coolColors
                        ?.resolve(CoolColorToken.border)
                        .withValues(alpha: 0.1) ??
                    Colors.black.withValues(alpha: 0.05),
                width: 0.5,
              )
            : null,
      ),
      child: child,
    );

    // Apply blur for elevation
    if (hasElevation && blurAmount > 0) {
      card = ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: blurAmount * 0.5,
            sigmaY: blurAmount * 0.5,
          ),
          child: card,
        ),
      );
    }

    if (onTap != null || onLongPress != null) {
      card = CoolTappable(onTap: onTap, onLongPress: onLongPress, child: card);
    }

    return card;
  }
}
