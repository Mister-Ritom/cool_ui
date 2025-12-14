import 'package:flutter/material.dart';
import '../foundation/color_system.dart';
import '../foundation/theme.dart';

/// Focused outline widget for keyboard navigation
class CoolFocusedOutline extends StatelessWidget {
  final Widget child;
  final bool showOutline;
  final double? radius;
  final double? width;
  
  const CoolFocusedOutline({
    super.key,
    required this.child,
    this.showOutline = false,
    this.radius,
    this.width,
  });
  
  @override
  Widget build(BuildContext context) {
    final coolColors = context.coolColors;
    
    if (!showOutline || coolColors == null) {
      return child;
    }
    
    final borderColor = coolColors.resolve(
      CoolColorToken.borderFocus,
      state: CoolInteractionState.focused,
    );
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          radius ?? context.coolRadius,
        ),
        border: Border.all(
          color: borderColor,
          width: width ?? 2.0,
        ),
      ),
      child: child,
    );
  }
}

