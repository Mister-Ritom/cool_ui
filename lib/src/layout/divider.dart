import 'dart:ui';

import 'package:flutter/material.dart';
import '../foundation/color_system.dart';
import '../foundation/theme.dart';

/// Divider with soft, blurred, or gradient styling
class CoolDivider extends StatelessWidget {
  final double? height;
  final double? thickness;
  final double? indent;
  final double? endIndent;
  final Color? color;
  final bool isVertical;
  final bool isGradient;
  final bool isBlurred;
  
  const CoolDivider({
    super.key,
    this.height,
    this.thickness,
    this.indent,
    this.endIndent,
    this.color,
    this.isVertical = false,
    this.isGradient = false,
    this.isBlurred = false,
  });
  
  @override
  Widget build(BuildContext context) {
    final coolColors = context.coolColors;
    final dividerColor = color ?? 
        coolColors?.resolve(CoolColorToken.border) ?? 
        Colors.grey;
    
    Widget divider;
    
    if (isGradient) {
      divider = Container(
        height: isVertical ? null : (height ?? thickness ?? 1),
        width: isVertical ? (height ?? thickness ?? 1) : null,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              dividerColor.withValues(alpha: 0),
              dividerColor,
              dividerColor.withValues(alpha: 0),
            ],
            begin: isVertical ? Alignment.topCenter : Alignment.centerLeft,
            end: isVertical ? Alignment.bottomCenter : Alignment.centerRight,
          ),
        ),
      );
    } else {
      divider = Container(
        height: isVertical ? null : (height ?? thickness ?? 1),
        width: isVertical ? (height ?? thickness ?? 1) : null,
        color: dividerColor,
      );
    }
    
    if (isBlurred) {
      divider = ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: divider,
        ),
      );
    }
    
    if (indent != null || endIndent != null) {
      divider = Padding(
        padding: EdgeInsets.only(
          left: isVertical ? 0 : (indent ?? 0),
          right: isVertical ? 0 : (endIndent ?? 0),
          top: isVertical ? (indent ?? 0) : 0,
          bottom: isVertical ? (endIndent ?? 0) : 0,
        ),
        child: divider,
      );
    }
    
    return divider;
  }
}

