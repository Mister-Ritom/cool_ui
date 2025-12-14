import 'package:flutter/material.dart';

/// Semantic color tokens that resolve based on theme and interaction state
enum CoolColorToken {
  // Surface colors
  surface,
  surfaceVariant,
  surfaceContainer,
  surfaceContainerHigh,
  surfaceContainerHighest,

  // Background colors
  background,
  backgroundVariant,

  // Primary colors
  primary,
  primaryContainer,
  onPrimary,
  onPrimaryContainer,

  // Secondary colors
  secondary,
  secondaryContainer,
  onSecondary,
  onSecondaryContainer,

  // Accent colors
  accent,
  accentContainer,
  onAccent,
  onAccentContainer,

  // Text colors
  text,
  textSecondary,
  textTertiary,
  textDisabled,
  textOnPrimary,
  textOnSecondary,
  textOnAccent,

  // Border colors
  border,
  borderVariant,
  borderFocus,

  // State colors
  error,
  errorContainer,
  onError,
  onErrorContainer,

  warning,
  warningContainer,
  onWarning,
  onWarningContainer,

  success,
  successContainer,
  onSuccess,
  onSuccessContainer,

  info,
  infoContainer,
  onInfo,
  onInfoContainer,

  // Interactive states
  hover,
  pressed,
  focused,
  selected,
  disabled,

  // Overlay colors
  overlay,
  overlayScrim,
  shadow,
}

/// Interaction states for widgets
enum CoolInteractionState {
  idle,
  hover,
  focused,
  pressed,
  longPressed,
  selected,
  disabled,
  loading,
  error,
  success,
}

/// Color system that resolves colors based on tokens, theme, and state
class CoolColorSystem {
  final Color primaryColor;
  final Color secondaryColor;
  final bool isDark;

  // Generated color palette
  late final Color _primaryContainer;
  late final Color _secondaryContainer;
  late final Color _accent;
  late final Color _accentContainer;
  late final Color _error;
  late final Color _errorContainer;
  late final Color _warning;
  late final Color _warningContainer;
  late final Color _success;
  late final Color _successContainer;
  late final Color _info;
  late final Color _infoContainer;

  // Surface colors
  late final Color _surface;
  late final Color _surfaceVariant;
  late final Color _surfaceContainer;
  late final Color _surfaceContainerHigh;
  late final Color _surfaceContainerHighest;
  late final Color _background;
  late final Color _backgroundVariant;

  // Text colors
  late final Color _text;
  late final Color _textSecondary;
  late final Color _textTertiary;
  late final Color _textDisabled;

  // Border colors
  late final Color _border;
  late final Color _borderVariant;
  late final Color _borderFocus;

  // Interactive colors
  late final Color _hover;
  late final Color _pressed;
  late final Color _focused;
  late final Color _selected;
  late final Color _disabled;

  // Overlay colors
  late final Color _overlay;
  late final Color _overlayScrim;
  late final Color _shadow;

  CoolColorSystem({
    required this.primaryColor,
    required this.secondaryColor,
    required this.isDark,
  }) {
    _generatePalette();
  }

  void _generatePalette() {
    // Generate surface colors FIRST (needed for _tintColor)
    if (isDark) {
      _background = const Color(0xFF0A0A0A);
      _backgroundVariant = const Color(0xFF1A1A1A);
      _surface = const Color(0xFF1E1E1E);
      _surfaceVariant = const Color(0xFF2A2A2A);
      _surfaceContainer = const Color(0xFF2E2E2E);
      _surfaceContainerHigh = const Color(0xFF3A3A3A);
      _surfaceContainerHighest = const Color(0xFF464646);

      _text = const Color(0xFFE0E0E0);
      _textSecondary = const Color(0xFFB0B0B0);
      _textTertiary = const Color(0xFF808080);
      _textDisabled = const Color(0xFF505050);

      _border = const Color(0xFF3A3A3A);
      _borderVariant = const Color(0xFF2A2A2A);
      _borderFocus = primaryColor.withValues(alpha: 0.6);

      _hover = Colors.white.withValues(alpha: 0.08);
      _pressed = Colors.white.withValues(alpha: 0.12);
      _focused = primaryColor.withValues(alpha: 0.2);
      _selected = primaryColor.withValues(alpha: 0.15);
      _disabled = Colors.white.withValues(alpha: 0.05);

      _overlay = const Color(0xFF2A2A2A);
      _overlayScrim = Colors.black.withValues(alpha: 0.6);
      _shadow = Colors.black.withValues(alpha: 0.3);
    } else {
      _background = const Color(0xFFFAFAFA);
      _backgroundVariant = const Color(0xFFF5F5F5);
      _surface = Colors.white;
      _surfaceVariant = const Color(0xFFF8F8F8);
      _surfaceContainer = const Color(0xFFF0F0F0);
      _surfaceContainerHigh = const Color(0xFFE8E8E8);
      _surfaceContainerHighest = const Color(0xFFE0E0E0);

      _text = const Color(0xFF1A1A1A);
      _textSecondary = const Color(0xFF606060);
      _textTertiary = const Color(0xFF909090);
      _textDisabled = const Color(0xFFB0B0B0);

      _border = const Color(0xFFE0E0E0);
      _borderVariant = const Color(0xFFF0F0F0);
      _borderFocus = primaryColor.withValues(alpha: 0.5);

      _hover = Colors.black.withValues(alpha: 0.04);
      _pressed = Colors.black.withValues(alpha: 0.08);
      _focused = primaryColor.withValues(alpha: 0.12);
      _selected = primaryColor.withValues(alpha: 0.08);
      _disabled = Colors.black.withValues(alpha: 0.02);

      _overlay = Colors.grey;
      _overlayScrim = Colors.black.withValues(alpha: 0.4);
      _shadow = Colors.black.withValues(alpha: 0.1);
    }

    // Now generate containers with tinted backgrounds (after _surface is initialized)
    _primaryContainer = _tintColor(primaryColor, 0.1);
    _secondaryContainer = _tintColor(secondaryColor, 0.1);

    // Generate accent from secondary
    _accent = _adjustBrightness(secondaryColor, isDark ? 0.2 : -0.2);
    _accentContainer = _tintColor(_accent, 0.1);

    // Generate semantic colors
    _error = isDark ? const Color(0xFFCF6679) : const Color(0xFFBA1A1A);
    _errorContainer = _tintColor(_error, 0.1);

    _warning = isDark ? const Color(0xFFFFB84D) : const Color(0xFFFF8C00);
    _warningContainer = _tintColor(_warning, 0.1);

    _success = isDark ? const Color(0xFF4CAF50) : const Color(0xFF2E7D32);
    _successContainer = _tintColor(_success, 0.1);

    _info = isDark ? const Color(0xFF64B5F6) : const Color(0xFF1976D2);
    _infoContainer = _tintColor(_info, 0.1);
  }

  Color _tintColor(Color color, double amount) {
    return Color.lerp(isDark ? _surface : Colors.white, color, amount)!;
  }

  Color _adjustBrightness(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness + amount).clamp(0.0, 1.0))
        .toColor();
  }

  /// Resolve a color token based on interaction state
  Color resolve(
    CoolColorToken token, {
    CoolInteractionState state = CoolInteractionState.idle,
  }) {
    Color baseColor;

    switch (token) {
      case CoolColorToken.primary:
        baseColor = primaryColor;
        break;
      case CoolColorToken.primaryContainer:
        baseColor = _primaryContainer;
        break;
      case CoolColorToken.onPrimary:
        baseColor = _getOnColor(primaryColor);
        break;
      case CoolColorToken.onPrimaryContainer:
        baseColor = _getOnColor(_primaryContainer);
        break;
      case CoolColorToken.secondary:
        baseColor = secondaryColor;
        break;
      case CoolColorToken.secondaryContainer:
        baseColor = _secondaryContainer;
        break;
      case CoolColorToken.onSecondary:
        baseColor = _getOnColor(secondaryColor);
        break;
      case CoolColorToken.onSecondaryContainer:
        baseColor = _getOnColor(_secondaryContainer);
        break;
      case CoolColorToken.accent:
        baseColor = _accent;
        break;
      case CoolColorToken.accentContainer:
        baseColor = _accentContainer;
        break;
      case CoolColorToken.onAccent:
        baseColor = _getOnColor(_accent);
        break;
      case CoolColorToken.onAccentContainer:
        baseColor = _getOnColor(_accentContainer);
        break;
      case CoolColorToken.surface:
        baseColor = _surface;
        break;
      case CoolColorToken.surfaceVariant:
        baseColor = _surfaceVariant;
        break;
      case CoolColorToken.surfaceContainer:
        baseColor = _surfaceContainer;
        break;
      case CoolColorToken.surfaceContainerHigh:
        baseColor = _surfaceContainerHigh;
        break;
      case CoolColorToken.surfaceContainerHighest:
        baseColor = _surfaceContainerHighest;
        break;
      case CoolColorToken.background:
        baseColor = _background;
        break;
      case CoolColorToken.backgroundVariant:
        baseColor = _backgroundVariant;
        break;
      case CoolColorToken.text:
        baseColor = _text;
        break;
      case CoolColorToken.textSecondary:
        baseColor = _textSecondary;
        break;
      case CoolColorToken.textTertiary:
        baseColor = _textTertiary;
        break;
      case CoolColorToken.textDisabled:
        baseColor = _textDisabled;
        break;
      case CoolColorToken.textOnPrimary:
        baseColor = _getOnColor(primaryColor);
        break;
      case CoolColorToken.textOnSecondary:
        baseColor = _getOnColor(secondaryColor);
        break;
      case CoolColorToken.textOnAccent:
        baseColor = _getOnColor(_accent);
        break;
      case CoolColorToken.border:
        baseColor = _border;
        break;
      case CoolColorToken.borderVariant:
        baseColor = _borderVariant;
        break;
      case CoolColorToken.borderFocus:
        baseColor = _borderFocus;
        break;
      case CoolColorToken.error:
        baseColor = _error;
        break;
      case CoolColorToken.errorContainer:
        baseColor = _errorContainer;
        break;
      case CoolColorToken.onError:
        baseColor = _getOnColor(_error);
        break;
      case CoolColorToken.onErrorContainer:
        baseColor = _getOnColor(_errorContainer);
        break;
      case CoolColorToken.warning:
        baseColor = _warning;
        break;
      case CoolColorToken.warningContainer:
        baseColor = _warningContainer;
        break;
      case CoolColorToken.onWarning:
        baseColor = _getOnColor(_warning);
        break;
      case CoolColorToken.onWarningContainer:
        baseColor = _getOnColor(_warningContainer);
        break;
      case CoolColorToken.success:
        baseColor = _success;
        break;
      case CoolColorToken.successContainer:
        baseColor = _successContainer;
        break;
      case CoolColorToken.onSuccess:
        baseColor = _getOnColor(_success);
        break;
      case CoolColorToken.onSuccessContainer:
        baseColor = _getOnColor(_successContainer);
        break;
      case CoolColorToken.info:
        baseColor = _info;
        break;
      case CoolColorToken.infoContainer:
        baseColor = _infoContainer;
        break;
      case CoolColorToken.onInfo:
        baseColor = _getOnColor(_info);
        break;
      case CoolColorToken.onInfoContainer:
        baseColor = _getOnColor(_infoContainer);
        break;
      case CoolColorToken.hover:
        baseColor = _hover;
        break;
      case CoolColorToken.pressed:
        baseColor = _pressed;
        break;
      case CoolColorToken.focused:
        baseColor = _focused;
        break;
      case CoolColorToken.selected:
        baseColor = _selected;
        break;
      case CoolColorToken.disabled:
        baseColor = _disabled;
        break;
      case CoolColorToken.overlay:
        baseColor = _overlay;
        break;
      case CoolColorToken.overlayScrim:
        baseColor = _overlayScrim;
        break;
      case CoolColorToken.shadow:
        baseColor = _shadow;
        break;
    }

    // Apply state-based modifications
    return _applyStateModification(baseColor, state);
  }

  Color _applyStateModification(Color color, CoolInteractionState state) {
    switch (state) {
      case CoolInteractionState.idle:
        return color;
      case CoolInteractionState.hover:
        return _blendColor(color, _hover);
      case CoolInteractionState.focused:
        return _blendColor(color, _focused);
      case CoolInteractionState.pressed:
        return _blendColor(color, _pressed);
      case CoolInteractionState.longPressed:
        return _blendColor(color, _pressed);
      case CoolInteractionState.selected:
        return _blendColor(color, _selected);
      case CoolInteractionState.disabled:
        return color.withValues(alpha: 0.5);
      case CoolInteractionState.loading:
        return color;
      case CoolInteractionState.error:
        return _blendColor(color, _error.withValues(alpha: 0.2));
      case CoolInteractionState.success:
        return _blendColor(color, _success.withValues(alpha: 0.2));
    }
  }

  Color _blendColor(Color base, Color overlay) {
    return Color.lerp(base, overlay, overlay.a / 255.0) ?? base;
  }

  Color _getOnColor(Color color) {
    // Determine if color is light or dark
    final luminance = color.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}
