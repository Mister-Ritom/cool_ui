import 'package:flutter/material.dart';
import 'color_system.dart';

/// Elevation model using translucency instead of shadows
class CoolElevationModel {
  /// Get elevation color based on level (0-5)
  static Color getElevationColor(
    CoolColorSystem colorSystem,
    int level, {
    CoolInteractionState state = CoolInteractionState.idle,
  }) {
    final baseColor = colorSystem.resolve(
      CoolColorToken.surface,
      state: state,
    );
    
    // Use translucency layers instead of shadows
    final opacity = _getOpacityForLevel(level);
    final overlayColor = colorSystem.resolve(
      CoolColorToken.overlay,
      state: state,
    );
    
    return Color.lerp(
      baseColor,
      overlayColor,
      opacity,
    ) ?? baseColor;
  }
  
  static double _getOpacityForLevel(int level) {
    switch (level) {
      case 0:
        return 0.0;
      case 1:
        return 0.05;
      case 2:
        return 0.08;
      case 3:
        return 0.12;
      case 4:
        return 0.16;
      case 5:
        return 0.20;
      default:
        return 0.0;
    }
  }
  
  /// Get blur amount for elevation level
  static double getBlurForLevel(int level) {
    switch (level) {
      case 0:
        return 0.0;
      case 1:
        return 4.0;
      case 2:
        return 8.0;
      case 3:
        return 12.0;
      case 4:
        return 16.0;
      case 5:
        return 20.0;
      default:
        return 0.0;
    }
  }
}

