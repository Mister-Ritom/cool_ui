import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../foundation/color_system.dart';
import '../foundation/theme.dart';
import '../foundation/radius_scale.dart';
import '../foundation/motion.dart';

/// Alert widget
class CoolAlert extends StatelessWidget {
  final String title;
  final String? message;
  final IconData? icon;
  final CoolAlertType type;
  final List<Widget>? actions;
  
  const CoolAlert({
    super.key,
    required this.title,
    this.message,
    this.icon,
    this.type = CoolAlertType.info,
    this.actions,
  });
  
  @override
  Widget build(BuildContext context) {
    final coolColors = context.coolColors;
    
    Color bgColor;
    Color iconColor;
    IconData alertIcon;
    
    switch (type) {
      case CoolAlertType.success:
        bgColor = coolColors?.resolve(CoolColorToken.successContainer) ?? 
            Colors.green.shade100;
        iconColor = coolColors?.resolve(CoolColorToken.success) ?? 
            Colors.green;
        alertIcon = icon ?? Icons.check_circle;
        break;
      case CoolAlertType.error:
        bgColor = coolColors?.resolve(CoolColorToken.errorContainer) ?? 
            Colors.red.shade100;
        iconColor = coolColors?.resolve(CoolColorToken.error) ?? 
            Colors.red;
        alertIcon = icon ?? Icons.error;
        break;
      case CoolAlertType.warning:
        bgColor = coolColors?.resolve(CoolColorToken.warningContainer) ?? 
            Colors.orange.shade100;
        iconColor = coolColors?.resolve(CoolColorToken.warning) ?? 
            Colors.orange;
        alertIcon = icon ?? Icons.warning;
        break;
      case CoolAlertType.info:
        bgColor = coolColors?.resolve(CoolColorToken.infoContainer) ?? 
            Colors.blue.shade100;
        iconColor = coolColors?.resolve(CoolColorToken.info) ?? 
            Colors.blue;
        alertIcon = icon ?? Icons.info;
        break;
    }
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(CoolRadiusScale.md),
      ),
      child: Row(
        children: [
          Icon(alertIcon, color: iconColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: iconColor,
                  ),
                ),
                if (message != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    message!,
                    style: TextStyle(
                      color: iconColor.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (actions != null) ...actions!,
        ],
      ),
    )
        .animate()
        .fadeIn(duration: CoolMotion.config.defaultDuration)
        .slideY(
          begin: -0.1,
          end: 0,
          duration: CoolMotion.config.defaultDuration,
        );
  }
}

enum CoolAlertType {
  info,
  success,
  warning,
  error,
}

