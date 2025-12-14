import 'package:flutter/material.dart';
import 'color_system.dart';

/// Base class for all widget styles
abstract class CoolWidgetStyle {
  const CoolWidgetStyle();
}

/// Animation configuration for a specific state
class CoolStateAnimationConfig {
  final double scale;
  final double opacity;
  final double blur;
  final double glow;
  final Offset offset;
  final double borderWidth;
  final double luminanceShift;
  final Duration duration;
  final Curve curve;

  const CoolStateAnimationConfig({
    this.scale = 1.0,
    this.opacity = 1.0,
    this.blur = 0.0,
    this.glow = 0.0,
    this.offset = Offset.zero,
    this.borderWidth = 1.0,
    this.luminanceShift = 0.0,
    Duration? duration,
    Curve? curve,
  }) : duration = duration ?? const Duration(milliseconds: 300),
       curve = curve ?? Curves.easeInOutCubic;

  CoolStateAnimationConfig copyWith({
    double? scale,
    double? opacity,
    double? blur,
    double? glow,
    Offset? offset,
    double? borderWidth,
    double? luminanceShift,
    Duration? duration,
    Curve? curve,
  }) {
    return CoolStateAnimationConfig(
      scale: scale ?? this.scale,
      opacity: opacity ?? this.opacity,
      blur: blur ?? this.blur,
      glow: glow ?? this.glow,
      offset: offset ?? this.offset,
      borderWidth: borderWidth ?? this.borderWidth,
      luminanceShift: luminanceShift ?? this.luminanceShift,
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
    );
  }
}

/// Complete animation configuration for all states
class CoolAnimationConfig {
  final CoolStateAnimationConfig idle;
  final CoolStateAnimationConfig hover;
  final CoolStateAnimationConfig pressed;
  final CoolStateAnimationConfig focused;
  final CoolStateAnimationConfig selected;
  final CoolStateAnimationConfig disabled;
  final CoolStateAnimationConfig loading;
  final CoolStateAnimationConfig error;
  final CoolStateAnimationConfig success;
  final CoolStateAnimationConfig longPressed;

  // Press/release curve overrides
  final Curve? pressCurve;
  final Curve? releaseCurve;

  // Minimum press duration for visibility
  final Duration minPressDuration;

  const CoolAnimationConfig({
    required this.idle,
    required this.hover,
    required this.pressed,
    required this.focused,
    required this.selected,
    required this.disabled,
    required this.loading,
    required this.error,
    required this.success,
    required this.longPressed,
    this.pressCurve,
    this.releaseCurve,
    Duration? minPressDuration,
  }) : minPressDuration = minPressDuration ?? const Duration(milliseconds: 120);

  CoolStateAnimationConfig forState(CoolInteractionState state) {
    switch (state) {
      case CoolInteractionState.idle:
        return idle;
      case CoolInteractionState.hover:
        return hover;
      case CoolInteractionState.pressed:
        return pressed;
      case CoolInteractionState.focused:
        return focused;
      case CoolInteractionState.selected:
        return selected;
      case CoolInteractionState.disabled:
        return disabled;
      case CoolInteractionState.loading:
        return loading;
      case CoolInteractionState.error:
        return error;
      case CoolInteractionState.success:
        return success;
      case CoolInteractionState.longPressed:
        return longPressed;
    }
  }

  /// Get curve for state transition
  Curve getCurveForTransition(
    CoolInteractionState currentState,
    CoolInteractionState previousState,
  ) {
    // Press: use pressCurve or ease-out
    if (currentState == CoolInteractionState.pressed) {
      return pressCurve ?? Curves.easeOutCubic;
    }
    // Release from pressed: use releaseCurve or ease-in
    if (previousState == CoolInteractionState.pressed &&
        currentState != CoolInteractionState.pressed) {
      return releaseCurve ?? Curves.easeInCubic;
    }
    // Use state's curve
    return forState(currentState).curve;
  }

  CoolAnimationConfig copyWith({
    CoolStateAnimationConfig? idle,
    CoolStateAnimationConfig? hover,
    CoolStateAnimationConfig? pressed,
    CoolStateAnimationConfig? focused,
    CoolStateAnimationConfig? selected,
    CoolStateAnimationConfig? disabled,
    CoolStateAnimationConfig? loading,
    CoolStateAnimationConfig? error,
    CoolStateAnimationConfig? success,
    CoolStateAnimationConfig? longPressed,
    Curve? pressCurve,
    Curve? releaseCurve,
    Duration? minPressDuration,
  }) {
    return CoolAnimationConfig(
      idle: idle ?? this.idle,
      hover: hover ?? this.hover,
      pressed: pressed ?? this.pressed,
      focused: focused ?? this.focused,
      selected: selected ?? this.selected,
      disabled: disabled ?? this.disabled,
      loading: loading ?? this.loading,
      error: error ?? this.error,
      success: success ?? this.success,
      longPressed: longPressed ?? this.longPressed,
      pressCurve: pressCurve ?? this.pressCurve,
      releaseCurve: releaseCurve ?? this.releaseCurve,
      minPressDuration: minPressDuration ?? this.minPressDuration,
    );
  }
}

/// Default animation configs (matches current behavior exactly)
class CoolDefaultAnimationConfigs {
  /// Default animation config for filled buttons
  static CoolAnimationConfig filledButton() {
    return CoolAnimationConfig(
      idle: const CoolStateAnimationConfig(),
      hover: const CoolStateAnimationConfig(
        scale: 1.02,
        opacity: 0.95,
        glow: 4.0,
        luminanceShift: -0.05,
      ),
      pressed: const CoolStateAnimationConfig(
        scale: 0.96,
        opacity: 0.95,
        luminanceShift: 0.1,
      ),
      focused: const CoolStateAnimationConfig(glow: 8.0),
      selected: const CoolStateAnimationConfig(),
      disabled: const CoolStateAnimationConfig(opacity: 0.5),
      loading: const CoolStateAnimationConfig(opacity: 0.8),
      error: const CoolStateAnimationConfig(),
      success: const CoolStateAnimationConfig(scale: 1.05),
      longPressed: const CoolStateAnimationConfig(scale: 0.94, opacity: 0.85),
      pressCurve: Curves.easeOutCubic,
      releaseCurve: Curves.easeInCubic,
      minPressDuration: const Duration(milliseconds: 120),
    );
  }

  /// Default animation config for outline buttons
  static CoolAnimationConfig outlineButton() {
    return CoolAnimationConfig(
      idle: const CoolStateAnimationConfig(),
      hover: const CoolStateAnimationConfig(
        scale: 1.01,
        opacity: 0.9,
        glow: 6.0,
        borderWidth: 2.0,
      ),
      pressed: const CoolStateAnimationConfig(scale: 0.96, opacity: 0.9),
      focused: const CoolStateAnimationConfig(glow: 8.0),
      selected: const CoolStateAnimationConfig(),
      disabled: const CoolStateAnimationConfig(opacity: 0.5),
      loading: const CoolStateAnimationConfig(opacity: 0.8),
      error: const CoolStateAnimationConfig(),
      success: const CoolStateAnimationConfig(scale: 1.05),
      longPressed: const CoolStateAnimationConfig(scale: 0.94, opacity: 0.85),
      pressCurve: Curves.easeOutCubic,
      releaseCurve: Curves.easeInCubic,
      minPressDuration: const Duration(milliseconds: 120),
    );
  }

  /// Default animation config for text buttons
  static CoolAnimationConfig textButton() {
    return CoolAnimationConfig(
      idle: const CoolStateAnimationConfig(),
      hover: const CoolStateAnimationConfig(scale: 1.01, opacity: 0.85),
      pressed: const CoolStateAnimationConfig(scale: 0.96, opacity: 0.9),
      focused: const CoolStateAnimationConfig(glow: 8.0),
      selected: const CoolStateAnimationConfig(),
      disabled: const CoolStateAnimationConfig(opacity: 0.5),
      loading: const CoolStateAnimationConfig(opacity: 0.8),
      error: const CoolStateAnimationConfig(),
      success: const CoolStateAnimationConfig(scale: 1.05),
      longPressed: const CoolStateAnimationConfig(scale: 0.94, opacity: 0.85),
      pressCurve: Curves.easeOutCubic,
      releaseCurve: Curves.easeInCubic,
      minPressDuration: const Duration(milliseconds: 120),
    );
  }

  /// Default animation config for icon buttons
  static CoolAnimationConfig iconButton() {
    return CoolAnimationConfig(
      idle: const CoolStateAnimationConfig(),
      hover: const CoolStateAnimationConfig(scale: 1.02),
      pressed: const CoolStateAnimationConfig(
        scale: 0.9,
        duration: Duration(milliseconds: 150),
      ),
      focused: const CoolStateAnimationConfig(),
      selected: const CoolStateAnimationConfig(),
      disabled: const CoolStateAnimationConfig(opacity: 0.5),
      loading: const CoolStateAnimationConfig(opacity: 0.8),
      error: const CoolStateAnimationConfig(),
      success: const CoolStateAnimationConfig(),
      longPressed: const CoolStateAnimationConfig(),
      pressCurve: Curves.easeOutCubic,
      releaseCurve: Curves.easeInCubic,
      minPressDuration: const Duration(milliseconds: 120),
    );
  }

  /// Default animation config for floating buttons
  static CoolAnimationConfig floatingButton() {
    return CoolAnimationConfig(
      idle: const CoolStateAnimationConfig(),
      hover: const CoolStateAnimationConfig(
        offset: Offset(0, -4),
        duration: Duration(milliseconds: 150),
      ),
      pressed: const CoolStateAnimationConfig(
        scale: 0.9,
        duration: Duration(milliseconds: 150),
      ),
      focused: const CoolStateAnimationConfig(),
      selected: const CoolStateAnimationConfig(),
      disabled: const CoolStateAnimationConfig(opacity: 0.5),
      loading: const CoolStateAnimationConfig(opacity: 0.8),
      error: const CoolStateAnimationConfig(),
      success: const CoolStateAnimationConfig(),
      longPressed: const CoolStateAnimationConfig(),
      pressCurve: Curves.easeOutCubic,
      releaseCurve: Curves.easeInCubic,
      minPressDuration: const Duration(milliseconds: 120),
    );
  }

  /// Default animation config for navigation items
  static CoolAnimationConfig navigationItem() {
    return CoolAnimationConfig(
      idle: const CoolStateAnimationConfig(),
      hover: const CoolStateAnimationConfig(),
      pressed: const CoolStateAnimationConfig(),
      focused: const CoolStateAnimationConfig(),
      selected: const CoolStateAnimationConfig(),
      disabled: const CoolStateAnimationConfig(opacity: 0.5),
      loading: const CoolStateAnimationConfig(),
      error: const CoolStateAnimationConfig(),
      success: const CoolStateAnimationConfig(),
      longPressed: const CoolStateAnimationConfig(),
      minPressDuration: const Duration(milliseconds: 120),
    );
  }
}

/// Style resolution utility
class CoolStyleResolver {
  /// Resolve a value using the cascade: widget style → theme default → fallback
  static T resolve<T>({
    required T? widgetValue,
    required T? themeValue,
    required T fallback,
  }) {
    return widgetValue ?? themeValue ?? fallback;
  }
}

/// Icon Button Style
class CoolIconButtonStyle extends CoolWidgetStyle {
  final double? size;
  final double? radius;
  final Color? iconColor;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final CoolAnimationConfig? animationConfig;

  const CoolIconButtonStyle({
    this.size,
    this.radius,
    this.iconColor,
    this.backgroundColor,
    this.padding,
    this.animationConfig,
  });

  CoolIconButtonStyle copyWith({
    double? size,
    double? radius,
    Color? iconColor,
    Color? backgroundColor,
    EdgeInsets? padding,
    CoolAnimationConfig? animationConfig,
  }) {
    return CoolIconButtonStyle(
      size: size ?? this.size,
      radius: radius ?? this.radius,
      iconColor: iconColor ?? this.iconColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      padding: padding ?? this.padding,
      animationConfig: animationConfig ?? this.animationConfig,
    );
  }
}

/// Floating Button Style
class CoolFloatingButtonStyle extends CoolWidgetStyle {
  final double? size;
  final double? iconSize;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final CoolAnimationConfig? animationConfig;
  final double? hoverOffset;

  const CoolFloatingButtonStyle({
    this.size,
    this.iconSize,
    this.backgroundColor,
    this.foregroundColor,
    this.animationConfig,
    this.hoverOffset,
  });

  CoolFloatingButtonStyle copyWith({
    double? size,
    double? iconSize,
    Color? backgroundColor,
    Color? foregroundColor,
    CoolAnimationConfig? animationConfig,
    double? hoverOffset,
  }) {
    return CoolFloatingButtonStyle(
      size: size ?? this.size,
      iconSize: iconSize ?? this.iconSize,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      animationConfig: animationConfig ?? this.animationConfig,
      hoverOffset: hoverOffset ?? this.hoverOffset,
    );
  }
}

/// Card Style
class CoolCardStyle extends CoolWidgetStyle {
  final double? radius;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? borderWidth;
  final double? borderAlpha;
  final Color? backgroundColor;

  const CoolCardStyle({
    this.radius,
    this.padding,
    this.margin,
    this.borderWidth,
    this.borderAlpha,
    this.backgroundColor,
  });

  CoolCardStyle copyWith({
    double? radius,
    EdgeInsets? padding,
    EdgeInsets? margin,
    double? borderWidth,
    double? borderAlpha,
    Color? backgroundColor,
  }) {
    return CoolCardStyle(
      radius: radius ?? this.radius,
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
      borderWidth: borderWidth ?? this.borderWidth,
      borderAlpha: borderAlpha ?? this.borderAlpha,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }
}

/// Bottom Navigation Bar Style
class CoolBottomNavigationBarStyle extends CoolWidgetStyle {
  final double? height;
  final EdgeInsets? padding;
  final double? bottomPadding;
  final double? selectedIconSize;
  final double? unselectedIconSize;
  final double? iconContainerSize;
  final double? labelFontSize;
  final double? iconLabelSpacing;
  final CoolAnimationConfig? animationConfig;

  const CoolBottomNavigationBarStyle({
    this.height,
    this.padding,
    this.bottomPadding,
    this.selectedIconSize,
    this.unselectedIconSize,
    this.iconContainerSize,
    this.labelFontSize,
    this.iconLabelSpacing,
    this.animationConfig,
  });

  CoolBottomNavigationBarStyle copyWith({
    double? height,
    EdgeInsets? padding,
    double? bottomPadding,
    double? selectedIconSize,
    double? unselectedIconSize,
    double? iconContainerSize,
    double? labelFontSize,
    double? iconLabelSpacing,
    CoolAnimationConfig? animationConfig,
  }) {
    return CoolBottomNavigationBarStyle(
      height: height ?? this.height,
      padding: padding ?? this.padding,
      bottomPadding: bottomPadding ?? this.bottomPadding,
      selectedIconSize: selectedIconSize ?? this.selectedIconSize,
      unselectedIconSize: unselectedIconSize ?? this.unselectedIconSize,
      iconContainerSize: iconContainerSize ?? this.iconContainerSize,
      labelFontSize: labelFontSize ?? this.labelFontSize,
      iconLabelSpacing: iconLabelSpacing ?? this.iconLabelSpacing,
      animationConfig: animationConfig ?? this.animationConfig,
    );
  }
}
