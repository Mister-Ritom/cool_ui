import 'package:flutter/material.dart';
import '../foundation/theme.dart';
import '../foundation/color_system.dart';
import '../foundation/animated_surface.dart';
import '../foundation/interaction_state.dart';

class CoolListTile extends StatefulWidget {
  final Widget? title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double? radius;
  final EdgeInsetsGeometry? padding;
  final bool isSelected;

  const CoolListTile({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.radius,
    this.padding,
    this.isSelected = false,
  });

  @override
  State<CoolListTile> createState() => _CoolListTileState();
}

class _CoolListTileState extends State<CoolListTile> {
  late final CoolInteractionStateManager _stateManager;
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _stateManager = CoolInteractionStateManager();
    if (widget.isSelected) {
      _stateManager.transitionTo(CoolInteractionState.selected);
    }
  }

  @override
  void didUpdateWidget(CoolListTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      _stateManager.transitionTo(CoolInteractionState.selected);
    } else if (!widget.isSelected && oldWidget.isSelected) {
      _stateManager.transitionTo(CoolInteractionState.idle);
    }
  }

  @override
  void dispose() {
    _stateManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final coolColors = context.coolColors;

    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        if (!_isPressed) _stateManager.transitionTo(CoolInteractionState.hover);
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        if (!_isPressed) _stateManager.transitionTo(CoolInteractionState.idle);
      },
      child: GestureDetector(
        onTapDown: (_) {
          setState(() => _isPressed = true);
          _stateManager.transitionTo(CoolInteractionState.pressed);
        },
        onTapUp: (_) {
          setState(() => _isPressed = false);
          if (_isHovered) {
            _stateManager.transitionTo(CoolInteractionState.hover);
          } else {
            _stateManager.transitionTo(CoolInteractionState.idle);
          }
          widget.onTap?.call();
        },
        onTapCancel: () {
          setState(() => _isPressed = false);
          _stateManager.transitionTo(CoolInteractionState.idle);
        },
        onLongPress: widget.onLongPress,
        child: CoolAnimatedSurface(
          stateManager: _stateManager,
          radius: widget.radius ?? context.coolRadius,
          isSelected: widget.isSelected,
          tintColor: coolColors
              ?.resolve(CoolColorToken.primary)
              .withValues(alpha: 0.1),
          child: Padding(
            padding:
                widget.padding ??
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                if (widget.leading != null) ...[
                  widget.leading!,
                  const SizedBox(width: 16),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.title != null)
                        DefaultTextStyle(
                          style: TextStyle(
                            color:
                                coolColors?.resolve(CoolColorToken.text) ??
                                Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          child: widget.title!,
                        ),
                      if (widget.subtitle != null) ...[
                        const SizedBox(height: 2),
                        DefaultTextStyle(
                          style: TextStyle(
                            color:
                                coolColors?.resolve(
                                  CoolColorToken.textSecondary,
                                ) ??
                                Colors.grey,
                            fontSize: 14,
                          ),
                          child: widget.subtitle!,
                        ),
                      ],
                    ],
                  ),
                ),
                if (widget.trailing != null) ...[
                  const SizedBox(width: 16),
                  widget.trailing!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
