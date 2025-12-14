import 'package:flutter/material.dart';
import '../foundation/color_system.dart';
import '../foundation/theme.dart';
import '../foundation/radius_scale.dart';

/// Progress indicator - supports both determinate (0.0-1.0) and indeterminate
class CoolProgressIndicator extends StatelessWidget {
  final double? value; // 0.0 to 1.0 for determinate, null for indeterminate
  final Color? color;
  final double? strokeWidth;
  final double? size;
  final bool isLinear; // Linear vs circular
  
  const CoolProgressIndicator({
    super.key,
    this.value,
    this.color,
    this.strokeWidth,
    this.size,
    this.isLinear = false,
  });
  
  @override
  Widget build(BuildContext context) {
    final coolColors = context.coolColors;
    final progressColor = color ?? 
        coolColors?.resolve(CoolColorToken.primary) ?? 
        Colors.blue;
    
    if (isLinear) {
      // Linear progress bar
      return SizedBox(
        height: strokeWidth ?? 4,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(CoolRadiusScale.pill),
          child: LinearProgressIndicator(
            value: value,
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            backgroundColor: progressColor.withValues(alpha: 0.1),
            minHeight: strokeWidth ?? 4,
          ),
        ),
      );
    }
    
    // Circular progress indicator
    if (value != null) {
      // Determinate progress (0.0 to 1.0)
      return SizedBox(
        width: size ?? 40,
        height: size ?? 40,
        child: CircularProgressIndicator(
          value: value!.clamp(0.0, 1.0),
          valueColor: AlwaysStoppedAnimation<Color>(progressColor),
          strokeWidth: strokeWidth ?? 4,
        ),
      );
    }
    
    // Indeterminate progress
    return SizedBox(
      width: size ?? 40,
      height: size ?? 40,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(progressColor),
        strokeWidth: strokeWidth ?? 4,
      ),
    );
  }
}

