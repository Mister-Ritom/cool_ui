import 'package:flutter/material.dart';

/// Stack widget with cool_ui styling
class CoolStack extends StatelessWidget {
  final List<Widget> children;
  final AlignmentGeometry alignment;
  final TextDirection? textDirection;
  final StackFit fit;
  final Clip clipBehavior;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  
  const CoolStack({
    super.key,
    required this.children,
    this.alignment = AlignmentDirectional.topStart,
    this.textDirection,
    this.fit = StackFit.loose,
    this.clipBehavior = Clip.hardEdge,
    this.padding,
    this.margin,
  });
  
  @override
  Widget build(BuildContext context) {
    Widget stack = Stack(
      alignment: alignment,
      textDirection: textDirection,
      fit: fit,
      clipBehavior: clipBehavior,
      children: children,
    );
    
    if (padding != null || margin != null) {
      stack = Container(
        padding: padding,
        margin: margin,
        child: stack,
      );
    }
    
    return stack;
  }
}

