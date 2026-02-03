import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../foundation/color_system.dart';
import '../foundation/theme.dart';
import '../foundation/motion.dart';
import '../foundation/state_resolver.dart';
import '../infrastructure/tappable.dart';

/// Floating action button with animations
class CoolFloatingButton extends StatefulWidget {
  final Widget? child;
  final IconData? icon;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final bool enabled;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? size;
  final String? tooltip;
  
  const CoolFloatingButton({
    super.key,
    this.child,
    this.icon,
    this.onPressed,
    this.onLongPress,
    this.enabled = true,
    this.isLoading = false,
    this.backgroundColor,
    this.foregroundColor,
    this.size,
    this.tooltip,
  }) : assert(child != null || icon != null, 'Either child or icon must be provided');
  
  @override
  State<CoolFloatingButton> createState() => _CoolFloatingButtonState();
}

class _CoolFloatingButtonState extends State<CoolFloatingButton> {
  bool _isHovered = false;
  final bool _isPressed = false;
  
  @override
  Widget build(BuildContext context) {
    final coolColors = context.coolColors;
    final coolTheme = context.coolTheme;
    
    if (coolColors == null || coolTheme == null) {
      return FloatingActionButton(
        onPressed: widget.enabled && !widget.isLoading ? widget.onPressed : null,
        child: widget.child ?? Icon(widget.icon),
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
    
    final size = widget.size ?? 56.0;
    final bgColor = widget.backgroundColor ?? 
        stateResolver.resolveColor(CoolColorToken.primary);
    final fgColor = widget.foregroundColor ?? 
        stateResolver.resolveColor(CoolColorToken.onPrimary);
    
    Widget content = widget.child ?? 
        Icon(
          widget.icon,
          color: fgColor,
          size: 24,
        );
    
    if (widget.isLoading) {
      content = SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(fgColor),
        ),
      );
    }
    
    Widget button = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: Center(child: content),
    );
    
    // Add hover float animation
    if (_isHovered) {
      button = button.animate().moveY(
        begin: 0,
        end: -4,
        duration: CoolMotion.config.shortDuration,
        curve: CoolMotion.config.defaultCurve,
      );
    }
    
    // Add press compression
    if (_isPressed) {
      button = button.animate().scale(
        begin: const Offset(1, 1),
        end: const Offset(0.9, 0.9),
        duration: CoolMotion.config.shortDuration,
      );
    }
    
    Widget result = CoolTappable(
      enabled: widget.enabled && !widget.isLoading,
      onTap: widget.onPressed,
      onLongPress: widget.onLongPress,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: button,
      ),
    );
    
    if (widget.tooltip != null) {
      result = Tooltip(
        message: widget.tooltip!,
        child: result,
      );
    }
    
    return result;
  }
}

