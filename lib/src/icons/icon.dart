import 'package:flutter/material.dart';
import '../foundation/color_system.dart';
import '../foundation/theme.dart';

/// Icon widget with cool_ui styling
class CoolIcon extends StatelessWidget {
  final IconData icon;
  final double? size;
  final Color? color;
  final String? semanticLabel;
  
  const CoolIcon({
    super.key,
    required this.icon,
    this.size,
    this.color,
    this.semanticLabel,
  });
  
  @override
  Widget build(BuildContext context) {
    final coolColors = context.coolColors;
    final iconColor = color ?? 
        coolColors?.resolve(CoolColorToken.text) ?? 
        Colors.black;
    
    return Icon(
      icon,
      size: size ?? 24,
      color: iconColor,
      semanticLabel: semanticLabel,
    );
  }
}

