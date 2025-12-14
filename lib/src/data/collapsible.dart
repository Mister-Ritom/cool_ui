import 'package:flutter/material.dart';
import '../foundation/motion.dart';

/// Collapsible widget style
class CoolCollapsibleStyle {
  final Duration? duration;
  final Curve? curve;
  final double? radius;
  final EdgeInsets? padding;

  const CoolCollapsibleStyle({
    this.duration,
    this.curve,
    this.radius,
    this.padding,
  });
}

/// Base collapsible widget with animated expand/collapse
class CoolCollapsible extends StatefulWidget {
  final Widget? collapsedChild;
  final Widget expandedChild;
  final bool isExpanded;
  final ValueChanged<bool>? onExpandedChanged;
  final CoolCollapsibleStyle? style;

  const CoolCollapsible({
    super.key,
    this.collapsedChild,
    required this.expandedChild,
    this.isExpanded = false,
    this.onExpandedChanged,
    this.style,
  });

  @override
  State<CoolCollapsible> createState() => _CoolCollapsibleState();
}

class _CoolCollapsibleState extends State<CoolCollapsible>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    final duration =
        widget.style?.duration ?? CoolMotion.config.defaultDuration;
    final curve = widget.style?.curve ?? CoolMotion.config.defaultCurve;

    _controller = AnimationController(duration: duration, vsync: this);

    _expandAnimation = CurvedAnimation(parent: _controller, curve: curve);

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: curve);

    if (widget.isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(CoolCollapsible oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: _expandAnimation,
      axisAlignment: -1.0,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: widget.isExpanded || _controller.value > 0
            ? widget.expandedChild
            : (widget.collapsedChild ?? const SizedBox.shrink()),
      ),
    );
  }
}
