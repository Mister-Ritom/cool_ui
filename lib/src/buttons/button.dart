import 'package:flutter/material.dart';
import '../foundation/color_system.dart';
import '../foundation/theme.dart';
import '../foundation/state_resolver.dart';
import '../foundation/interaction_state.dart';
import '../foundation/animated_surface.dart';

/// Button style configuration
class CoolButtonStyle {
  final double? radius;
  final EdgeInsets? padding;
  final double? elevation;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final TextStyle? textStyle;
  
  const CoolButtonStyle({
    this.radius,
    this.padding,
    this.elevation,
    this.backgroundColor,
    this.foregroundColor,
    this.textStyle,
  });
  
  CoolButtonStyle copyWith({
    double? radius,
    EdgeInsets? padding,
    double? elevation,
    Color? backgroundColor,
    Color? foregroundColor,
    TextStyle? textStyle,
  }) {
    return CoolButtonStyle(
      radius: radius ?? this.radius,
      padding: padding ?? this.padding,
      elevation: elevation ?? this.elevation,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      textStyle: textStyle ?? this.textStyle,
    );
  }
}

/// Main button widget with state-driven animations
class CoolButton extends StatefulWidget {
  final Widget? child;
  final String? text;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final bool enabled;
  final bool isLoading;
  final CoolButtonStyle? style;
  final CoolButtonVariant variant;
  final CoolButtonSize size;
  
  const CoolButton({
    super.key,
    this.child,
    this.text,
    this.onPressed,
    this.onLongPress,
    this.enabled = true,
    this.isLoading = false,
    this.style,
    this.variant = CoolButtonVariant.primary,
    this.size = CoolButtonSize.medium,
  }) : assert(child != null || text != null, 'Either child or text must be provided');
  
  @override
  State<CoolButton> createState() => _CoolButtonState();
}

enum CoolButtonVariant {
  primary,
  secondary,
  accent,
  outline,
  text,
}

enum CoolButtonSize {
  small,
  medium,
  large,
}

class _CoolButtonState extends State<CoolButton> {
  late final CoolInteractionStateManager _stateManager;
  bool _isHovered = false;
  bool _isPressed = false;
  DateTime? _pressStartTime;
  static const _minPressVisibilityDuration = Duration(milliseconds: 120);
  
  @override
  void initState() {
    super.initState();
    _stateManager = CoolInteractionStateManager();
    if (!widget.enabled || widget.isLoading) {
      _stateManager.transitionTo(CoolInteractionState.disabled);
    }
  }
  
  @override
  void didUpdateWidget(CoolButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.enabled || widget.isLoading) {
      _stateManager.transitionTo(CoolInteractionState.disabled);
    } else if (_stateManager.state == CoolInteractionState.disabled) {
      _stateManager.transitionTo(CoolInteractionState.idle);
    }
  }
  
  @override
  void dispose() {
    _stateManager.dispose();
    super.dispose();
  }
  
  void _handlePointerDown() {
    if (widget.enabled && !widget.isLoading) {
      _pressStartTime = DateTime.now();
      setState(() => _isPressed = true);
      _stateManager.transitionTo(CoolInteractionState.pressed);
    }
  }
  
  void _handlePointerUp() {
    if (widget.enabled && !widget.isLoading) {
      final pressDuration = _pressStartTime != null
          ? DateTime.now().difference(_pressStartTime!)
          : Duration.zero;
      
      // Ensure minimum press visibility
      if (pressDuration < _minPressVisibilityDuration) {
        final remainingTime = _minPressVisibilityDuration - pressDuration;
        Future.delayed(remainingTime, () {
          if (mounted) {
            setState(() => _isPressed = false);
            // Transition based on current hover state
            if (_isHovered) {
              _stateManager.transitionTo(CoolInteractionState.hover);
            } else {
              _stateManager.transitionTo(CoolInteractionState.idle);
            }
            widget.onPressed?.call();
          }
        });
      } else {
        setState(() => _isPressed = false);
        // Transition based on current hover state
        if (_isHovered) {
          _stateManager.transitionTo(CoolInteractionState.hover);
        } else {
          _stateManager.transitionTo(CoolInteractionState.idle);
        }
        widget.onPressed?.call();
      }
      _pressStartTime = null;
    }
  }
  
  void _handlePointerCancel() {
    if (widget.enabled && !widget.isLoading) {
      _pressStartTime = null;
      setState(() => _isPressed = false);
      // Always go to idle on cancel
      _stateManager.transitionTo(CoolInteractionState.idle);
    }
  }
  
  void _handleLongPress() {
    if (widget.enabled && !widget.isLoading) {
      _stateManager.transitionTo(CoolInteractionState.longPressed);
      widget.onLongPress?.call();
      // After long press, release
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          _handlePointerUp();
        }
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final coolColors = context.coolColors;
    final coolTheme = context.coolTheme;
    
    if (coolColors == null || coolTheme == null) {
      return _buildFallbackButton();
    }
    
    final stateResolver = CoolStateResolver(
      colorSystem: coolColors,
      state: _stateManager.state,
      isEnabled: widget.enabled && !widget.isLoading,
    );
    
    final style = widget.style ?? const CoolButtonStyle();
    final radius = style.radius ?? context.coolRadius;
    final padding = style.padding ?? _getPaddingForSize(widget.size);
    
    // Resolve colors based on variant
    Color bgColor;
    Color fgColor;
    final isFilled = widget.variant != CoolButtonVariant.outline && 
                     widget.variant != CoolButtonVariant.text;
    final isOutline = widget.variant == CoolButtonVariant.outline;
    
    switch (widget.variant) {
      case CoolButtonVariant.primary:
        bgColor = stateResolver.resolveColor(CoolColorToken.primary);
        fgColor = stateResolver.resolveColor(CoolColorToken.onPrimary);
        break;
      case CoolButtonVariant.secondary:
        bgColor = stateResolver.resolveColor(CoolColorToken.secondary);
        fgColor = stateResolver.resolveColor(CoolColorToken.onSecondary);
        break;
      case CoolButtonVariant.accent:
        bgColor = stateResolver.resolveColor(CoolColorToken.accent);
        fgColor = stateResolver.resolveColor(CoolColorToken.onAccent);
        break;
      case CoolButtonVariant.outline:
        bgColor = Colors.transparent;
        fgColor = stateResolver.resolveColor(CoolColorToken.primary);
        break;
      case CoolButtonVariant.text:
        bgColor = Colors.transparent;
        fgColor = stateResolver.resolveColor(CoolColorToken.primary);
        break;
    }
    
    // Override with style if provided
    bgColor = style.backgroundColor ?? bgColor;
    fgColor = style.foregroundColor ?? fgColor;
    
    // Get tint colors for states
    final hoverTint = stateResolver.resolveColor(CoolColorToken.hover);
    final pressedTint = stateResolver.resolveColor(CoolColorToken.pressed);
    final tintColor = _stateManager.isPressed 
        ? pressedTint 
        : (_stateManager.isHovered ? hoverTint : null);
    
    Widget buttonContent = widget.child ?? 
        Text(
          widget.text!,
          style: style.textStyle ?? TextStyle(
            color: fgColor,
            fontSize: _getFontSizeForSize(widget.size),
            fontWeight: FontWeight.w600,
          ),
        );
    
    if (widget.isLoading) {
      _stateManager.transitionTo(CoolInteractionState.loading);
      buttonContent = SizedBox(
        width: _getFontSizeForSize(widget.size),
        height: _getFontSizeForSize(widget.size),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(fgColor),
        ),
      );
    }
    
    Widget button = CoolAnimatedSurface(
      stateManager: _stateManager,
      backgroundColor: bgColor,
      tintColor: tintColor,
      radius: radius,
      isFilled: isFilled,
      isOutline: isOutline,
      border: isOutline
          ? Border.all(
              color: stateResolver.resolveColor(CoolColorToken.primary),
              width: 1.5,
            )
          : null,
      child: Container(
        padding: padding,
        child: Center(child: buttonContent),
      ),
    );
    
    return GestureDetector(
      onTapDown: widget.enabled && !widget.isLoading 
          ? (_) => _handlePointerDown()
          : null,
      onTapUp: widget.enabled && !widget.isLoading 
          ? (_) => _handlePointerUp()
          : null,
      onTapCancel: widget.enabled && !widget.isLoading 
          ? () => _handlePointerCancel()
          : null,
      onLongPress: widget.enabled && !widget.isLoading ? _handleLongPress : null,
      child: MouseRegion(
        onEnter: widget.enabled && !widget.isLoading
            ? (_) {
                setState(() => _isHovered = true);
                if (!_isPressed) {
                  _stateManager.transitionTo(CoolInteractionState.hover);
                }
              }
            : null,
        onExit: widget.enabled && !widget.isLoading
            ? (_) {
                setState(() => _isHovered = false);
                if (!_isPressed) {
                  _stateManager.transitionTo(CoolInteractionState.idle);
                }
              }
            : null,
        child: button,
      ),
    );
  }
  
  Widget _buildFallbackButton() {
    return ElevatedButton(
      onPressed: widget.enabled && !widget.isLoading ? widget.onPressed : null,
      child: widget.child ?? Text(widget.text ?? ''),
    );
  }
  
  EdgeInsets _getPaddingForSize(CoolButtonSize size) {
    switch (size) {
      case CoolButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
      case CoolButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
      case CoolButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 16);
    }
  }
  
  double _getFontSizeForSize(CoolButtonSize size) {
    switch (size) {
      case CoolButtonSize.small:
        return 14;
      case CoolButtonSize.medium:
        return 16;
      case CoolButtonSize.large:
        return 18;
    }
  }
}

