import 'package:flutter/material.dart';

/// Radius scale system - ZERO sharp corners, all rounded
class CoolRadiusScale {
  /// Extra small radius (for small badges, chips)
  static const double xs = 4.0;
  
  /// Small radius (for buttons, small cards)
  static const double sm = 8.0;
  
  /// Medium radius (default for most widgets)
  static const double md = 12.0;
  
  /// Large radius (for cards, containers)
  static const double lg = 16.0;
  
  /// Extra large radius (for large surfaces)
  static const double xl = 20.0;
  
  /// Extra extra large radius (for dialogs, sheets)
  static const double xxl = 24.0;
  
  /// Pill shape (for fully rounded elements)
  static const double pill = 9999.0;
  
  /// Get BorderRadius for a given radius value
  static BorderRadius getRadius(double radius) {
    return BorderRadius.circular(radius);
  }
  
  /// Get RoundedRectangleBorder for a given radius value
  static RoundedRectangleBorder getRoundedBorder(double radius) {
    return RoundedRectangleBorder(
      borderRadius: getRadius(radius),
    );
  }
  
  /// Get ShapeBorder for a given radius value
  static ShapeBorder getShapeBorder(double radius) {
    return getRoundedBorder(radius);
  }
}

