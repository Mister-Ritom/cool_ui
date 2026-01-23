import 'package:flutter/material.dart';
import '../foundation/color_system.dart';
import '../foundation/theme.dart';
import '../foundation/state_resolver.dart';
import '../foundation/interaction_state.dart';
import '../foundation/animated_surface.dart';
import '../foundation/radius_scale.dart';

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
  final String? tooltip;

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
    this.tooltip,
  });

  @override
  State<CoolIconButton> createState() => _CoolIconButtonState();
}

class _CoolIconButtonState extends State<CoolIconButton> {
  late final CoolInteractionStateManager _stateManager;
  final GlobalKey<TooltipState> _tooltipKey = GlobalKey<TooltipState>();

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
  void didUpdateWidget(CoolIconButton oldWidget) {
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

  void _showTooltip() {
    if (widget.tooltip != null && widget.tooltip!.isNotEmpty) {
      _tooltipKey.currentState?.ensureTooltipVisible();
    }
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

      void complete() {
        if (!mounted) return;
        setState(() => _isPressed = false);
        _stateManager.transitionTo(
          _isHovered ? CoolInteractionState.hover : CoolInteractionState.idle,
        );
        widget.onPressed?.call();
      }

      if (pressDuration < _minPressVisibilityDuration) {
        Future.delayed(_minPressVisibilityDuration - pressDuration, complete);
      } else {
        complete();
      }

      _pressStartTime = null;
    }
  }

  void _handlePointerCancel() {
    if (widget.enabled && !widget.isLoading) {
      _pressStartTime = null;
      setState(() => _isPressed = false);
      _stateManager.transitionTo(CoolInteractionState.idle);
    }
  }

  void _handleLongPress() {
    if (widget.enabled && !widget.isLoading) {
      _showTooltip();
      _stateManager.transitionTo(CoolInteractionState.longPressed);
      widget.onLongPress?.call();
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) _handlePointerUp();
      });
    }
  }

  Color _tooltipBackgroundColor(CoolColorSystem colors, Color defaultBg) {
    final bg = defaultBg == Colors.transparent
        ? colors.primaryColor
        : defaultBg;
    return Color.alphaBlend(Color(0x0D000000), bg);
  }

  Color _tooltipTextColor(Color background) {
    return background.computeLuminance() > 0.35 ? Colors.black : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final coolColors = context.coolColors;
    final coolTheme = context.coolTheme;

    if (coolColors == null || coolTheme == null) {
      return Tooltip(
        key: _tooltipKey,
        triggerMode: TooltipTriggerMode.manual,
        message: widget.tooltip ?? '',
        child: IconButton(
          icon: Icon(widget.icon),
          onPressed: widget.enabled && !widget.isLoading
              ? widget.onPressed
              : null,
        ),
      );
    }

    final stateResolver = CoolStateResolver(
      colorSystem: coolColors,
      state: _stateManager.state,
      isEnabled: widget.enabled && !widget.isLoading,
    );

    final size = widget.size ?? 24;
    final radius = widget.radius ?? CoolRadiusScale.md;
    final bgColor = widget.backgroundColor ?? Colors.transparent;

    final iconColor =
        widget.iconColor ?? stateResolver.resolveColor(CoolColorToken.text);

    final hoverTint = stateResolver.resolveColor(CoolColorToken.hover);
    final pressedTint = stateResolver.resolveColor(CoolColorToken.pressed);
    final tintColor = _isPressed
        ? pressedTint
        : (_isHovered ? hoverTint : null);

    Widget content = widget.isLoading
        ? SizedBox(
            width: size * 0.6,
            height: size * 0.6,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(iconColor),
            ),
          )
        : Icon(widget.icon, size: size, color: iconColor);

    Widget button = CoolAnimatedSurface(
      stateManager: _stateManager,
      backgroundColor: bgColor,
      tintColor: tintColor,
      radius: radius,
      isFilled: true,
      child: SizedBox(
        width: size + 16,
        height: size + 16,
        child: Center(child: content),
      ),
    );

    Widget interactive = GestureDetector(
      onTapDown: widget.enabled && !widget.isLoading
          ? (_) => _handlePointerDown()
          : null,
      onTapUp: widget.enabled && !widget.isLoading
          ? (_) => _handlePointerUp()
          : null,
      onTapCancel: widget.enabled && !widget.isLoading
          ? _handlePointerCancel
          : null,
      onLongPress: widget.enabled && !widget.isLoading
          ? _handleLongPress
          : null,
      child: MouseRegion(
        onEnter: widget.enabled && !widget.isLoading
            ? (_) {
                setState(() => _isHovered = true);
                _showTooltip();
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

    if (widget.tooltip == null || widget.tooltip!.isEmpty) return interactive;

    final tooltipBg = _tooltipBackgroundColor(coolColors, bgColor);
    return Tooltip(
      key: _tooltipKey,
      triggerMode: TooltipTriggerMode.manual,
      message: widget.tooltip!,
      decoration: BoxDecoration(
        color: tooltipBg,
        borderRadius: BorderRadius.circular(6),
      ),
      textStyle: TextStyle(
        color: _tooltipTextColor(tooltipBg),
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
      child: interactive,
    );
  }
}
