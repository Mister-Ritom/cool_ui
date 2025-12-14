import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../foundation/color_system.dart';
import '../foundation/theme.dart';
import '../foundation/motion.dart';
import '../foundation/state_resolver.dart';

/// Text field style
class CoolTextFieldStyle {
  final double? radius;
  final EdgeInsets? padding;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderWidth;
  
  const CoolTextFieldStyle({
    this.radius,
    this.padding,
    this.textStyle,
    this.hintStyle,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
  });
}

/// Text field with state animations
class CoolTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final String? errorText;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final int? maxLines;
  final int? minLines;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final CoolTextFieldStyle? style;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  
  const CoolTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.helperText,
    this.errorText,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.keyboardType,
    this.onChanged,
    this.onTap,
    this.focusNode,
    this.style,
    this.prefixIcon,
    this.suffixIcon,
  });
  
  @override
  State<CoolTextField> createState() => _CoolTextFieldState();
}

class _CoolTextFieldState extends State<CoolTextField> {
  late FocusNode _focusNode;
  bool _hasFocus = false;
  
  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }
  
  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    } else {
      _focusNode.removeListener(_onFocusChange);
    }
    super.dispose();
  }
  
  void _onFocusChange() {
    setState(() {
      _hasFocus = _focusNode.hasFocus;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final coolColors = context.coolColors;
    final coolTheme = context.coolTheme;
    
    if (coolColors == null || coolTheme == null) {
      return TextField(
        controller: widget.controller,
        decoration: InputDecoration(
          hintText: widget.hintText,
          labelText: widget.labelText,
        ),
      );
    }
    
    final hasError = widget.errorText != null;
    final state = hasError
        ? CoolInteractionState.error
        : _hasFocus
            ? CoolInteractionState.focused
            : CoolInteractionState.idle;
    
    final stateResolver = CoolStateResolver(
      colorSystem: coolColors,
      state: state,
      isEnabled: widget.enabled,
      hasError: hasError,
    );
    
    final style = widget.style ?? const CoolTextFieldStyle();
    final radius = style.radius ?? context.coolRadius;
    final padding = style.padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
    final bgColor = style.backgroundColor ?? 
        stateResolver.resolveColor(CoolColorToken.surface);
    final borderColor = style.borderColor ?? 
        (hasError
            ? stateResolver.resolveColor(CoolColorToken.error)
            : _hasFocus
                ? stateResolver.resolveColor(CoolColorToken.borderFocus)
                : stateResolver.resolveColor(CoolColorToken.border));
    final borderWidth = style.borderWidth ?? (_hasFocus ? 2.0 : 1.0);
    
    Widget textField = Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: borderColor,
          width: borderWidth,
        ),
      ),
      child: TextField(
        controller: widget.controller,
        focusNode: _focusNode,
        obscureText: widget.obscureText,
        enabled: widget.enabled,
        readOnly: widget.readOnly,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        keyboardType: widget.keyboardType,
        onChanged: widget.onChanged,
        onTap: widget.onTap,
        style: style.textStyle ?? TextStyle(
          color: stateResolver.resolveColor(CoolColorToken.text),
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          labelText: widget.labelText,
          helperText: widget.helperText,
          errorText: widget.errorText,
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon,
          border: InputBorder.none,
          contentPadding: padding,
          hintStyle: style.hintStyle ?? TextStyle(
            color: stateResolver.resolveColor(CoolColorToken.textSecondary),
          ),
        ),
      ),
    );
    
    // Add focus animation
    if (_hasFocus) {
      textField = textField.animate().fadeIn(
        duration: CoolMotion.config.shortDuration,
      );
    }
    
    // Add error shake
    if (hasError) {
      textField = textField.animate().shake(
        hz: 4,
        offset: const Offset(8, 0),
        duration: CoolMotion.config.defaultDuration,
      );
    }
    
    return textField;
  }
}

