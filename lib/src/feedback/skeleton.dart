import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../foundation/color_system.dart';
import '../foundation/theme.dart';
import '../foundation/radius_scale.dart';
import '../foundation/motion.dart';

/// Skeleton widget for loading states
class CoolSkeleton extends StatelessWidget {
  final double? width;
  final double? height;
  final double? radius;
  final CoolSkeletonType type;
  
  const CoolSkeleton({
    super.key,
    this.width,
    this.height,
    this.radius,
    this.type = CoolSkeletonType.rectangle,
  });
  
  const CoolSkeleton.text({
    super.key,
    this.width,
    this.height = 16,
    this.radius,
  }) : type = CoolSkeletonType.text;
  
  const CoolSkeleton.avatar({
    super.key,
    this.width,
    this.height,
    this.radius,
  }) : type = CoolSkeletonType.avatar;
  
  const CoolSkeleton.card({
    super.key,
    this.width,
    this.height = 100,
    this.radius,
  }) : type = CoolSkeletonType.card;
  
  @override
  Widget build(BuildContext context) {
    final coolColors = context.coolColors;
    final baseColor = coolColors?.resolve(CoolColorToken.surfaceContainer) ??
        Colors.grey.shade300;
    final highlightColor = coolColors?.resolve(CoolColorToken.surface) ??
        Colors.grey.shade100;
    
    double finalWidth = width ?? 100;
    double finalHeight = height ?? 20;
    double finalRadius = radius ?? 
        (type == CoolSkeletonType.avatar 
            ? CoolRadiusScale.pill 
            : CoolRadiusScale.sm);
    
    Widget skeleton = Container(
      width: finalWidth,
      height: finalHeight,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(finalRadius),
      ),
    );
    
    // Add shimmer animation
    return skeleton
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(
          duration: const Duration(milliseconds: 1500),
          color: highlightColor,
        )
        .fadeIn(
          duration: CoolMotion.config.defaultDuration,
        );
  }
}

enum CoolSkeletonType {
  rectangle,
  text,
  avatar,
  card,
}

