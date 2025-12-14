import 'dart:ui';

import 'package:flutter/material.dart';
import '../foundation/color_system.dart';
import '../foundation/theme.dart';

/// Layout container with blur + tint surface
class CoolLayout extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? width;
  final double? height;
  final double? radius;
  final int? elevation;
  final Color? backgroundColor;
  
  const CoolLayout({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.radius,
    this.elevation,
    this.backgroundColor,
  });
  
  @override
  Widget build(BuildContext context) {
    final coolColors = context.coolColors;
    final bgColor = backgroundColor ?? 
        coolColors?.resolve(CoolColorToken.surface) ?? 
        Colors.transparent;
    
    final borderRadius = radius ?? context.coolRadius;
    
    Widget content = Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: child,
    );
    
    if (elevation != null && elevation! > 0) {
      // Apply blur effect for elevation
      content = ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: elevation!.toDouble() * 2,
            sigmaY: elevation!.toDouble() * 2,
          ),
          child: content,
        ),
      );
    }
    
    return content;
  }
}

