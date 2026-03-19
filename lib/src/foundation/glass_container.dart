import 'dart:ui';
import 'package:flutter/material.dart';
import '../foundation/theme.dart';
import '../foundation/color_system.dart';

/// A premium frosted glass container that uses backdrop filters
class CoolGlassContainer extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final Color? color;
  final double? radius;
  final BorderRadiusGeometry? borderRadius;
  final Border? border;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final List<BoxShadow>? boxShadow;

  const CoolGlassContainer({
    super.key,
    required this.child,
    this.blur = 10.0,
    this.opacity = 0.1,
    this.color,
    this.radius,
    this.borderRadius,
    this.border,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    final coolColors = context.coolColors;
    final effectiveRadius =
        borderRadius ?? BorderRadius.circular(radius ?? context.coolRadius);
    final baseColor =
        color ?? coolColors?.resolve(CoolColorToken.surface) ?? Colors.white;

    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: effectiveRadius,
        boxShadow: boxShadow,
      ),
      child: ClipRRect(
        borderRadius: effectiveRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: baseColor.withValues(alpha: opacity),
              borderRadius: effectiveRadius,
              border:
                  border ??
                  Border.all(
                    color: baseColor.withValues(alpha: 0.2),
                    width: 0.5,
                  ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
