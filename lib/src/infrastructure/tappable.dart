import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../foundation/color_system.dart';
import '../foundation/state_resolver.dart';
import '../foundation/theme.dart';
import '../foundation/motion.dart';

/// Tappable widget with state-driven animations
class CoolTappable extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onHover;
  final bool enabled;
  final bool selected;
  final Duration? animationDuration;
  
  const CoolTappable({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.onHover,
    this.enabled = true,
    this.selected = false,
    this.animationDuration,
  });
  
  @override
  State<CoolTappable> createState() => _CoolTappableState();
}

class _CoolTappableState extends State<CoolTappable> {
  bool _isHovered = false;
  bool _isPressed = false;
  bool _isFocused = false;
  DateTime? _pressStartTime;
  static const _minPressVisibilityDuration = Duration(milliseconds: 120);
  
  CoolInteractionState get _currentState {
    if (!widget.enabled) return CoolInteractionState.disabled;
    if (widget.selected) return CoolInteractionState.selected;
    if (_isPressed) return CoolInteractionState.pressed;
    if (_isFocused) return CoolInteractionState.focused;
    if (_isHovered) return CoolInteractionState.hover;
    return CoolInteractionState.idle;
  }
  
  @override
  Widget build(BuildContext context) {
    final coolColors = context.coolColors;
    if (coolColors == null) return widget.child;
    
    final stateResolver = CoolStateResolver(
      colorSystem: coolColors,
      state: _currentState,
      isEnabled: widget.enabled,
      isSelected: widget.selected,
    );
    
    final overlayColor = stateResolver.resolveColor(
      _currentState == CoolInteractionState.hover
          ? CoolColorToken.hover
          : _currentState == CoolInteractionState.pressed
              ? CoolColorToken.pressed
              : _currentState == CoolInteractionState.selected
                  ? CoolColorToken.selected
                  : CoolColorToken.surface,
    );
    
    // Animate opacity for tint appearance
    final tintOpacity = _currentState == CoolInteractionState.idle 
        ? 0.0 
        : (_currentState == CoolInteractionState.hover 
            ? 1.0 
            : (_currentState == CoolInteractionState.pressed 
                ? 1.0 
                : (_currentState == CoolInteractionState.selected ? 1.0 : 0.0)));
    
    // Calculate animated alpha
    final baseAlpha = overlayColor.a;
    final animatedAlpha = (baseAlpha * tintOpacity).clamp(0.0, 1.0);
    
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        widget.onHover?.call();
      },
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: widget.enabled ? (_) {
          _pressStartTime = DateTime.now();
          setState(() => _isPressed = true);
        } : null,
        onTapUp: widget.enabled ? (_) {
          final pressDuration = _pressStartTime != null
              ? DateTime.now().difference(_pressStartTime!)
              : Duration.zero;
          
          // Ensure minimum press visibility
          if (pressDuration < _minPressVisibilityDuration) {
            final remainingTime = _minPressVisibilityDuration - pressDuration;
            Future.delayed(remainingTime, () {
              if (mounted) {
                setState(() => _isPressed = false);
                widget.onTap?.call();
              }
            });
          } else {
            setState(() => _isPressed = false);
            widget.onTap?.call();
          }
          _pressStartTime = null;
        } : null,
        onTapCancel: widget.enabled ? () {
          _pressStartTime = null;
          setState(() => _isPressed = false);
        } : null,
        onLongPress: widget.enabled ? widget.onLongPress : null,
        child: ClipRRect(
          borderRadius: BorderRadius.zero, // Will be clipped by parent if needed
          child: AnimatedContainer(
            duration: widget.animationDuration ?? CoolMotion.config.defaultDuration,
            curve: CoolMotion.config.defaultCurve,
            decoration: BoxDecoration(
              color: overlayColor.withValues(alpha: animatedAlpha),
            ),
            child: widget.child,
          ),
        ),
      ),
    )
        .animate(target: _isHovered ? 1 : 0)
        .then()
        .scale(
          begin: const Offset(1, 1),
          end: const Offset(1.02, 1.02),
          duration: CoolMotion.config.shortDuration,
          curve: CoolMotion.config.defaultCurve,
        );
  }
}

