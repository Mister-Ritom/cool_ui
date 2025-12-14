import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../foundation/color_system.dart';
import '../foundation/theme.dart';
import '../foundation/radius_scale.dart';
import '../foundation/motion.dart';

/// Dialog widget
class CoolDialog extends StatelessWidget {
  final Widget? title;
  final Widget? content;
  final List<Widget>? actions;
  final double? width;
  final double? maxWidth;
  
  const CoolDialog({
    super.key,
    this.title,
    this.content,
    this.actions,
    this.width,
    this.maxWidth,
  });
  
  @override
  Widget build(BuildContext context) {
    final coolColors = context.coolColors;
    final bgColor = coolColors?.resolve(CoolColorToken.surface) ?? 
        Colors.white;
    
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: width,
        constraints: maxWidth != null ? BoxConstraints(maxWidth: maxWidth!) : null,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(CoolRadiusScale.xxl),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null) ...[
              title!,
              const SizedBox(height: 16),
            ],
            if (content != null) ...[
              Flexible(child: content!),
              if (actions != null) const SizedBox(height: 24),
            ],
            if (actions != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: actions!,
              ),
          ],
        ),
      )
          .animate()
          .fadeIn(duration: CoolMotion.config.defaultDuration)
          .scale(
            begin: const Offset(0.9, 0.9),
            end: const Offset(1, 1),
            duration: CoolMotion.config.defaultDuration,
          ),
    );
  }
  
  static Future<T?> show<T>({
    required BuildContext context,
    Widget? title,
    Widget? content,
    List<Widget>? actions,
    double? width,
    double? maxWidth,
  }) {
    return showDialog<T>(
      context: context,
      builder: (context) => CoolDialog(
        title: title,
        content: content,
        actions: actions,
        width: width,
        maxWidth: maxWidth,
      ),
    );
  }
}

