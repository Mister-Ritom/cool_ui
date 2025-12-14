import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../foundation/color_system.dart';
import '../foundation/theme.dart';
import '../foundation/radius_scale.dart';
import '../foundation/motion.dart';
import '../foundation/state_resolver.dart';
import '../infrastructure/tappable.dart';

/// Icon button with state animations
class CoolIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final bool enabled;
  final bool isLoading;
  final double? size;
  final Color? iconColor;
  final Color? backgroundColor;
  final double? radius;
  
  const CoolIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.onLongPress,
    this.enabled = true,
    this.isLoading = false,
    this.size,
    this.iconColor,
    this.backgroundColor,
    this.radius,
  });
  
  @override
  State<CoolIconButton> createState() => _CoolIconButtonState();
}

class _CoolIconButtonState extends State<CoolIconButton> {
  bool _isHovered = false;
  bool _isPressed = false;
  
  @override
  Widget build(BuildContext context) {
    final coolColors = context.coolColors;
    final coolTheme = context.coolTheme;
    
    if (coolColors == null || coolTheme == null) {
      return IconButton(
        icon: Icon(widget.icon),
        onPressed: widget.enabled && !widget.isLoading ? widget.onPressed : null,
      );
    }
    
    final state = _isPressed
        ? CoolInteractionState.pressed
        : _isHovered
            ? CoolInteractionState.hover
            : CoolInteractionState.idle;
    
    final stateResolver = CoolStateResolver(
      colorSystem: coolColors,
      state: state,
      isEnabled: widget.enabled && !widget.isLoading,
    );
    
    final iconSize = widget.size ?? 24.0;
    final radius = widget.radius ?? CoolRadiusScale.md;
    final iconColor = widget.iconColor ?? 
        stateResolver.resolveColor(CoolColorToken.text);
    final bgColor = widget.backgroundColor ?? 
        stateResolver.resolveColor(CoolColorToken.surface);
    
    Widget button = Container(
      width: iconSize + 16,
      height: iconSize + 16,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: widget.isLoading
          ? Center(
              child: SizedBox(
                width: iconSize * 0.6,
                height: iconSize * 0.6,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(iconColor),
                ),
              ),
            )
          : Icon(
              widget.icon,
              size: iconSize,
              color: iconColor,
            ),
    );
    
    if (_isHovered) {
      button = button.animate().fadeIn(
        duration: CoolMotion.config.shortDuration,
      );
    }
    
    if (_isPressed) {
      button = button.animate().scale(
        begin: const Offset(1, 1),
        end: const Offset(0.9, 0.9),
        duration: CoolMotion.config.shortDuration,
      );
    }
    
    return CoolTappable(
      enabled: widget.enabled && !widget.isLoading,
      onTap: widget.onPressed,
      onLongPress: widget.onLongPress,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: button,
      ),
    );
  }
}

