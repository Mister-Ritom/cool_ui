import 'dart:ui';

import 'package:cooler_ui/cooler_ui.dart';
import 'package:flutter/material.dart';
import 'motion.dart';
import 'interaction_state.dart';
import 'radius_scale.dart';

/// Animated surface that responds to state changes
class CoolAnimatedSurface extends StatefulWidget {
  final Widget child;
  final CoolInteractionStateManager stateManager;
  final Color? backgroundColor;
  final Color? tintColor;
  final double? radius;
  final bool isFilled;
  final bool isOutline;
  final bool isSelected;
  final Border? border;
  final Duration? duration;

  const CoolAnimatedSurface({
    super.key,
    required this.child,
    required this.stateManager,
    this.backgroundColor,
    this.tintColor,
    this.radius,
    this.isFilled = false,
    this.isOutline = false,
    this.isSelected = false,
    this.border,
    this.duration,
  });

  @override
  State<CoolAnimatedSurface> createState() => _CoolAnimatedSurfaceState();
}

class _CoolAnimatedSurfaceState extends State<CoolAnimatedSurface>
    with TickerProviderStateMixin {
  late CoolAnimationValues _currentValues;
  late AnimationController _rippleController;
  late Animation<double> _rippleProgress;

  @override
  void initState() {
    super.initState();
    _rippleController = AnimationController(
      vsync: this,
      duration: CoolMotion.config.shortDuration,
    );

    _rippleProgress = CurvedAnimation(
      parent: _rippleController,
      curve: Curves.easeOut,
    );

    _currentValues = CoolAnimationValues.forState(
      widget.stateManager.state,
      isFilled: widget.isFilled,
      isOutline: widget.isOutline,
      isSelected: widget.isSelected || widget.stateManager.isSelected,
    );
    widget.stateManager.addListener(_onStateChanged);
  }

  @override
  void dispose() {
    _rippleController.dispose();

    widget.stateManager.removeListener(_onStateChanged);
    super.dispose();
  }

  void _onStateChanged() {
    if (widget.stateManager.state == CoolInteractionState.pressed) {
      _rippleController.forward(from: 0);
    }

    setState(() {
      _currentValues = CoolAnimationValues.forState(
        widget.stateManager.state,
        isFilled: widget.isFilled,
        isOutline: widget.isOutline,
        isSelected: widget.isSelected || widget.stateManager.isSelected,
      );
    });
  }

  Widget _buildRipple(double radius) {
    if (!_rippleController.isAnimating &&
        widget.stateManager.state != CoolInteractionState.pressed) {
      return const SizedBox.shrink();
    }

    final rippleColor = widget.tintColor ?? Colors.white.withValues(alpha: 0.2);

    return AnimatedBuilder(
      animation: _rippleProgress,
      builder: (_, __) {
        return Positioned.fill(
          child: CustomPaint(
            painter: _RipplePainter(
              progress: _rippleProgress.value,
              color: rippleColor,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final radius = widget.radius ?? CoolRadiusScale.md;
    final duration = widget.duration ?? CoolMotion.config.defaultDuration;

    // Get tint color with animated opacity
    Color? tint;
    final isSelectedState = widget.isSelected || widget.stateManager.isSelected;

    if (widget.tintColor != null) {
      if (isSelectedState) {
        // Selection: animate opacity from 0 to target (0.15)
        final targetAlpha = 0.15;
        tint = widget.tintColor!.withValues(
          alpha: targetAlpha * _currentValues.opacity,
        );
      } else if (widget.stateManager.isHovered ||
          widget.stateManager.isPressed) {
        // Hover/press: use opacity value
        final baseAlpha = widget.tintColor!.a / 255.0;
        tint = widget.tintColor!.withValues(
          alpha: baseAlpha * _currentValues.opacity,
        );
      } else {
        tint = null;
      }
    }

    // Blend background with tint and apply luminance shift for filled buttons
    Color? finalColor;
    if (widget.backgroundColor != null) {
      Color baseColor = widget.backgroundColor!;

      // Apply luminance shift for filled buttons (press/hover states)
      if (widget.isFilled && _currentValues.luminanceShift != 0.0) {
        final hsl = HSLColor.fromColor(baseColor);
        baseColor = hsl
            .withLightness(
              (hsl.lightness + _currentValues.luminanceShift).clamp(0.0, 1.0),
            )
            .toColor();
      }

      if (tint != null && tint.a > 0) {
        finalColor = Color.lerp(baseColor, tint, tint.a / 255.0);
      } else {
        finalColor = baseColor.a == 0
            ? baseColor
            : baseColor.withValues(alpha: baseColor.a * _currentValues.opacity);
      }
    } else if (tint != null && tint.a > 0) {
      finalColor = tint;
    }

    Widget surface = AnimatedContainer(
      duration: duration,
      curve: CoolMotion.config.defaultCurve,
      transform: Matrix4.identity()..scale(_currentValues.scale),
      decoration: BoxDecoration(
        color: finalColor,
        borderRadius: BorderRadius.circular(radius),
        border:
            widget.border ??
            (widget.isOutline
                ? Border.all(
                    color: widget.tintColor ?? Colors.transparent,
                    width: _currentValues.borderWidth,
                  )
                : null),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Stack(
          fit: StackFit.passthrough,
          children: [_buildRipple(radius), widget.child],
        ),
      ),
    );

    // Apply blur if needed
    if (_currentValues.blur > 0) {
      surface = ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: _currentValues.blur,
            sigmaY: _currentValues.blur,
          ),
          child: surface,
        ),
      );
    }

    // Apply glow effect via shadow
    if (_currentValues.glow > 0 && widget.tintColor != null) {
      surface = Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [
            BoxShadow(
              color: widget.tintColor!.withValues(
                alpha: (widget.tintColor!.a * 0.3).clamp(0.0, 1.0),
              ),
              blurRadius: _currentValues.glow,
              spreadRadius: _currentValues.glow * 0.5,
            ),
          ],
        ),
        child: surface,
      );
    }

    return surface;
  }
}

class _RipplePainter extends CustomPainter {
  final double progress;
  final Color color;

  _RipplePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final maxRadius = size.longestSide * 0.6;

    final paint = Paint()
      ..color = color.withValues(alpha: (0.25 * (1 - progress)))
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, maxRadius * progress, paint);
  }

  @override
  bool shouldRepaint(covariant _RipplePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
