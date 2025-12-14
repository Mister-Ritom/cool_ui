import 'package:flutter/material.dart';
import 'color_system.dart';
import 'radius_scale.dart';
import 'motion.dart';

/// Main theme extension for cool_ui
/// User MUST instantiate this with primaryColor, secondaryColor, and themeMode
class CoolThemeExtension extends ThemeExtension<CoolThemeExtension> {
  final Color primaryColor;
  final Color secondaryColor;
  final ThemeMode themeMode;
  
  // Optional overrides
  final CoolMotionConfig? motionConfig;
  final double? defaultRadius;
  final Map<String, dynamic>? customTokens;
  
  // Internal color system
  late final CoolColorSystem _colorSystem;
  
  CoolThemeExtension({
    required this.primaryColor,
    required this.secondaryColor,
    required this.themeMode,
    this.motionConfig,
    this.defaultRadius,
    this.customTokens,
  }) {
    final isDark = themeMode == ThemeMode.dark || 
        (themeMode == ThemeMode.system && 
         WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark);
    
    _colorSystem = CoolColorSystem(
      primaryColor: primaryColor,
      secondaryColor: secondaryColor,
      isDark: isDark,
    );
    
    if (motionConfig != null) {
      CoolMotion.configure(motionConfig!);
    }
  }
  
  CoolColorSystem get colorSystem => _colorSystem;
  
  bool get isDark {
    if (themeMode == ThemeMode.dark) return true;
    if (themeMode == ThemeMode.light) return false;
    return WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
  }
  
  double get radius => defaultRadius ?? CoolRadiusScale.md;
  
  @override
  CoolThemeExtension copyWith({
    Color? primaryColor,
    Color? secondaryColor,
    ThemeMode? themeMode,
    CoolMotionConfig? motionConfig,
    double? defaultRadius,
    Map<String, dynamic>? customTokens,
  }) {
    return CoolThemeExtension(
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      themeMode: themeMode ?? this.themeMode,
      motionConfig: motionConfig ?? this.motionConfig,
      defaultRadius: defaultRadius ?? this.defaultRadius,
      customTokens: customTokens ?? this.customTokens,
    );
  }
  
  @override
  CoolThemeExtension lerp(
    ThemeExtension<CoolThemeExtension>? other,
    double t,
  ) {
    if (other is! CoolThemeExtension) {
      return this;
    }
    
    return CoolThemeExtension(
      primaryColor: Color.lerp(primaryColor, other.primaryColor, t)!,
      secondaryColor: Color.lerp(secondaryColor, other.secondaryColor, t)!,
      themeMode: t < 0.5 ? themeMode : other.themeMode,
      motionConfig: motionConfig ?? other.motionConfig,
      defaultRadius: defaultRadius ?? other.defaultRadius,
      customTokens: customTokens ?? other.customTokens,
    );
  }
}

/// Helper to get CoolThemeExtension from context
extension CoolThemeExtensionExtension on BuildContext {
  CoolThemeExtension? get coolTheme {
    return Theme.of(this).extension<CoolThemeExtension>();
  }
  
  CoolColorSystem? get coolColors {
    return coolTheme?.colorSystem;
  }
  
  bool get coolIsDark {
    return coolTheme?.isDark ?? false;
  }
  
  double get coolRadius {
    return coolTheme?.radius ?? CoolRadiusScale.md;
  }
}

