import 'package:flutter/material.dart';

/// Portal widget for rendering content in a different part of the widget tree
class CoolPortal extends StatelessWidget {
  final Widget child;
  final BuildContext? targetContext;
  
  const CoolPortal({
    super.key,
    required this.child,
    this.targetContext,
  });
  
  @override
  Widget build(BuildContext context) {
    // Simple implementation - in production, use Overlay or similar
    return child;
  }
}

