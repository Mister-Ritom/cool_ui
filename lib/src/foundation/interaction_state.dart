import 'package:flutter/material.dart';
import 'color_system.dart';

/// Centralized interaction state management
class CoolInteractionStateManager extends ChangeNotifier {
  CoolInteractionState _state = CoolInteractionState.idle;
  CoolInteractionState _previousState = CoolInteractionState.idle;
  
  CoolInteractionState get state => _state;
  CoolInteractionState get previousState => _previousState;
  
  bool get isHovered => _state == CoolInteractionState.hover;
  bool get isPressed => _state == CoolInteractionState.pressed;
  bool get isSelected => _state == CoolInteractionState.selected;
  bool get isDisabled => _state == CoolInteractionState.disabled;
  bool get isLoading => _state == CoolInteractionState.loading;
  
  /// Transition to a new state (triggers animation)
  void transitionTo(CoolInteractionState newState) {
    if (_state != newState) {
      _previousState = _state;
      _state = newState;
      notifyListeners();
    }
  }
  
  /// Reset to idle
  void reset() {
    transitionTo(CoolInteractionState.idle);
  }
  
}

/// Animation values derived from state
class CoolAnimationValues {
  final double scale;
  final double opacity;
  final double blur;
  final double glow;
  final Offset offset;
  final double borderWidth;
  final double luminanceShift; // For filled buttons: brightness adjustment
  
  const CoolAnimationValues({
    this.scale = 1.0,
    this.opacity = 1.0,
    this.blur = 0.0,
    this.glow = 0.0,
    this.offset = Offset.zero,
    this.borderWidth = 1.0,
    this.luminanceShift = 0.0, // 0 = no change, positive = lighter, negative = darker
  });
  
  /// Get animation values for a state
  static CoolAnimationValues forState(
    CoolInteractionState state, {
    bool isFilled = false,
    bool isOutline = false,
    bool isSelected = false,
  }) {
    switch (state) {
      case CoolInteractionState.idle:
        return const CoolAnimationValues();
        
      case CoolInteractionState.hover:
        if (isFilled) {
          // Filled buttons: subtle lift + slight darkening
          return const CoolAnimationValues(
            scale: 1.02,
            opacity: 0.95,
            glow: 4.0,
            luminanceShift: -0.05, // Slightly darker on hover
          );
        } else if (isOutline) {
          // Outline buttons: glow, opacity, and border
          return const CoolAnimationValues(
            scale: 1.01,
            opacity: 0.9,
            glow: 6.0,
            borderWidth: 2.0,
          );
        } else {
          // Text/other: subtle scale + opacity
          return const CoolAnimationValues(
            scale: 1.01,
            opacity: 0.85,
          );
        }
        
      case CoolInteractionState.pressed:
        // Press: compression + luminance shift for filled buttons
        if (isFilled) {
          return const CoolAnimationValues(
            scale: 0.96,
            opacity: 0.95,
            luminanceShift: 0.1, // Slightly lighter on press
          );
        } else {
          return const CoolAnimationValues(
            scale: 0.96,
            opacity: 0.9,
          );
        }
        
      case CoolInteractionState.selected:
        // Selection: reveal animation
        return CoolAnimationValues(
          scale: isSelected ? 1.0 : 0.95,
          opacity: isSelected ? 1.0 : 0.0,
          blur: isSelected ? 0.0 : 2.0,
        );
        
      case CoolInteractionState.focused:
        return const CoolAnimationValues(
          scale: 1.0,
          opacity: 1.0,
          glow: 8.0,
        );
        
      case CoolInteractionState.disabled:
        return const CoolAnimationValues(
          scale: 1.0,
          opacity: 0.5,
        );
        
      case CoolInteractionState.loading:
        return const CoolAnimationValues(
          scale: 1.0,
          opacity: 0.8,
        );
        
      case CoolInteractionState.error:
        return const CoolAnimationValues(
          scale: 1.0,
          opacity: 1.0,
        );
        
      case CoolInteractionState.success:
        return const CoolAnimationValues(
          scale: 1.05,
          opacity: 1.0,
        );
        
      case CoolInteractionState.longPressed:
        return const CoolAnimationValues(
          scale: 0.94,
          opacity: 0.85,
        );
    }
  }
}

