import 'package:flutter/material.dart';
import 'color_system.dart';
import 'motion.dart';

/// Resolves widget state and applies appropriate styling
class CoolStateResolver {
  final CoolColorSystem colorSystem;
  final CoolInteractionState state;
  final bool isEnabled;
  final bool isSelected;
  final bool isLoading;
  final bool hasError;
  final bool hasSuccess;
  
  CoolStateResolver({
    required this.colorSystem,
    this.state = CoolInteractionState.idle,
    this.isEnabled = true,
    this.isSelected = false,
    this.isLoading = false,
    this.hasError = false,
    this.hasSuccess = false,
  });
  
  CoolInteractionState get resolvedState {
    if (!isEnabled) return CoolInteractionState.disabled;
    if (hasError) return CoolInteractionState.error;
    if (hasSuccess) return CoolInteractionState.success;
    if (isLoading) return CoolInteractionState.loading;
    if (isSelected) return CoolInteractionState.selected;
    return state;
  }
  
  Color resolveColor(CoolColorToken token) {
    return colorSystem.resolve(token, state: resolvedState);
  }
  
  /// Get animation effects for state transition
  List<dynamic> getStateTransitionEffects({
    required CoolInteractionState fromState,
    required CoolInteractionState toState,
  }) {
    final effects = <dynamic>[];
    
    if (toState == CoolInteractionState.hover) {
      effects.add(CoolMotion.glowPulse(
        duration: CoolMotion.config.shortDuration,
      ));
    } else if (toState == CoolInteractionState.pressed) {
      effects.add(CoolMotion.pressCompress());
    } else if (toState == CoolInteractionState.error) {
      effects.add(CoolMotion.shake());
    } else if (toState == CoolInteractionState.success) {
      effects.add(CoolMotion.bounce());
    }
    
    return effects;
  }
}

