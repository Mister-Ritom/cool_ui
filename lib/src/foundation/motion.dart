import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Motion configuration for animations
class CoolMotionConfig {
  final Duration defaultDuration;
  final Duration shortDuration;
  final Duration longDuration;
  final Curve defaultCurve;
  final Curve enterCurve;
  final Curve exitCurve;
  final double delayMultiplier;

  const CoolMotionConfig({
    this.defaultDuration = const Duration(milliseconds: 300),
    this.shortDuration = const Duration(milliseconds: 150),
    this.longDuration = const Duration(milliseconds: 500),
    this.defaultCurve = Curves.easeInOutCubic,
    this.enterCurve = Curves.easeOutCubic,
    this.exitCurve = Curves.easeInCubic,
    this.delayMultiplier = 0.1,
  });

  static const CoolMotionConfig standard = CoolMotionConfig();

  static const CoolMotionConfig fast = CoolMotionConfig(
    defaultDuration: Duration(milliseconds: 200),
    shortDuration: Duration(milliseconds: 100),
    longDuration: Duration(milliseconds: 300),
  );

  static const CoolMotionConfig slow = CoolMotionConfig(
    defaultDuration: Duration(milliseconds: 500),
    shortDuration: Duration(milliseconds: 250),
    longDuration: Duration(milliseconds: 800),
  );
}

/// Motion abstraction layer - all animations go through this
class CoolMotion {
  static CoolMotionConfig _config = CoolMotionConfig.standard;

  static void configure(CoolMotionConfig config) {
    _config = config;
  }

  static CoolMotionConfig get config => _config;

  /// Fade in animation
  static Effect fadeIn({Duration? duration, Curve? curve, double delay = 0}) {
    return FadeEffect(
      duration: duration ?? _config.defaultDuration,
      curve: curve ?? _config.enterCurve,
      delay: Duration(milliseconds: (delay * 1000).round()),
    );
  }

  /// Fade out animation
  static Effect fadeOut({Duration? duration, Curve? curve, double delay = 0}) {
    return FadeEffect(
      begin: 1,
      end: 0,
      duration: duration ?? _config.defaultDuration,
      curve: curve ?? _config.exitCurve,
      delay: Duration(milliseconds: (delay * 1000).round()),
    );
  }

  /// Scale in animation
  static Effect scaleIn({
    Duration? duration,
    Curve? curve,
    double begin = 0.8,
    double end = 1.0,
    double delay = 0,
  }) {
    return ScaleEffect(
      begin: Offset(begin, begin),
      end: const Offset(1, 1),
      duration: duration ?? _config.defaultDuration,
      curve: curve ?? _config.enterCurve,
      delay: Duration(milliseconds: (delay * 1000).round()),
    );
  }

  /// Scale out animation
  static Effect scaleOut({
    Duration? duration,
    Curve? curve,
    double end = 0.8,
    double delay = 0,
  }) {
    return ScaleEffect(
      begin: const Offset(1, 1),
      end: Offset(end, end),
      duration: duration ?? _config.defaultDuration,
      curve: curve ?? _config.exitCurve,
      delay: Duration(milliseconds: (delay * 1000).round()),
    );
  }

  /// Slide animation
  static Effect slideIn({
    Duration? duration,
    Curve? curve,
    Offset? begin,
    Offset end = Offset.zero,
    double delay = 0,
  }) {
    return SlideEffect(
      begin: begin ?? const Offset(0, 0.1),
      end: end,
      duration: duration ?? _config.defaultDuration,
      curve: curve ?? _config.enterCurve,
      delay: Duration(milliseconds: (delay * 1000).round()),
    );
  }

  /// Slide out animation
  static Effect slideOut({
    Duration? duration,
    Curve? curve,
    Offset? end,
    double delay = 0,
  }) {
    return SlideEffect(
      begin: Offset.zero,
      end: end ?? const Offset(0, -0.1),
      duration: duration ?? _config.defaultDuration,
      curve: curve ?? _config.exitCurve,
      delay: Duration(milliseconds: (delay * 1000).round()),
    );
  }

  /// Blur in animation
  static Effect blurIn({
    Duration? duration,
    Curve? curve,
    double begin = 0,
    double end = 8,
    double delay = 0,
  }) {
    return BlurEffect(
      begin: Offset(begin, begin),
      end: Offset(end, end),
      duration: duration ?? _config.defaultDuration,
      curve: curve ?? _config.enterCurve,
      delay: Duration(milliseconds: (delay * 1000).round()),
    );
  }

  /// Blur out animation
  static Effect blurOut({
    Duration? duration,
    Curve? curve,
    double begin = 8,
    double end = 0,
    double delay = 0,
  }) {
    return BlurEffect(
      begin: Offset(begin, begin),
      end: Offset(end, end),
      duration: duration ?? _config.defaultDuration,
      curve: curve ?? _config.exitCurve,
      delay: Duration(milliseconds: (delay * 1000).round()),
    );
  }

  /// Glow pulse animation (simplified - using fade)
  static Effect glowPulse({
    Duration? duration,
    Curve? curve,
    Color? color,
    double begin = 0,
    double end = 8,
    double delay = 0,
  }) {
    // Simplified glow using fade effect
    return FadeEffect(
      begin: 1.0,
      end: 0.8,
      duration: duration ?? _config.defaultDuration,
      curve: curve ?? _config.defaultCurve,
      delay: Duration(milliseconds: (delay * 1000).round()),
    );
  }

  /// Hover float animation
  static Effect hoverFloat({
    Duration? duration,
    Curve? curve,
    double offset = 4,
    double delay = 0,
  }) {
    return MoveEffect(
      begin: const Offset(0, 0),
      end: Offset(0, -offset),
      duration: duration ?? _config.defaultDuration,
      curve: curve ?? _config.defaultCurve,
      delay: Duration(milliseconds: (delay * 1000).round()),
    );
  }

  /// Press compression animation
  static Effect pressCompress({
    Duration? duration,
    Curve? curve,
    double scale = 0.95,
    double delay = 0,
  }) {
    return ScaleEffect(
      begin: const Offset(1, 1),
      end: Offset(scale, scale),
      duration: duration ?? _config.shortDuration,
      curve: curve ?? Curves.easeInOut,
      delay: Duration(milliseconds: (delay * 1000).round()),
    );
  }

  /// Shake animation (for errors)
  static Effect shake({
    Duration? duration,
    Curve? curve,
    double hz = 4,
    double offset = 8,
    double delay = 0,
  }) {
    return ShakeEffect(
      hz: hz,
      offset: Offset(offset, 0),
      duration: duration ?? _config.defaultDuration,
      curve: curve ?? _config.defaultCurve,
      delay: Duration(milliseconds: (delay * 1000).round()),
    );
  }

  /// Bounce animation (for success)
  static Effect bounce({Duration? duration, Curve? curve, double delay = 0}) {
    return ScaleEffect(
      begin: const Offset(1, 1),
      end: const Offset(1.1, 1.1),
      duration: duration ?? _config.shortDuration,
      curve: Curves.elasticOut,
      delay: Duration(milliseconds: (delay * 1000).round()),
    );
  }

  /// Combine multiple effects
  static List<Effect> combine(List<Effect> effects) {
    return effects;
  }
}
