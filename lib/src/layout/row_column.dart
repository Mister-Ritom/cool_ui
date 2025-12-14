import 'package:flutter/material.dart';

/// Row widget with cool_ui styling
class CoolRow extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final TextDirection? textDirection;
  final VerticalDirection verticalDirection;
  final TextBaseline? textBaseline;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  
  const CoolRow({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.textBaseline,
    this.padding,
    this.margin,
  });
  
  @override
  Widget build(BuildContext context) {
    Widget row = Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      children: children,
    );
    
    if (padding != null || margin != null) {
      row = Container(
        padding: padding,
        margin: margin,
        child: row,
      );
    }
    
    return row;
  }
}

/// Column widget with cool_ui styling
class CoolColumn extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final TextDirection? textDirection;
  final VerticalDirection verticalDirection;
  final TextBaseline? textBaseline;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Widget? divider; // Optional divider between children
  
  const CoolColumn({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.textBaseline,
    this.padding,
    this.margin,
    this.divider,
  });
  
  @override
  Widget build(BuildContext context) {
    List<Widget> finalChildren = children;
    
    // Insert divider between children if provided
    if (divider != null && children.length > 1) {
      finalChildren = <Widget>[];
      for (int i = 0; i < children.length; i++) {
        finalChildren.add(children[i]);
        if (i < children.length - 1) {
          finalChildren.add(divider!);
        }
      }
    }
    
    Widget column = Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      children: finalChildren,
    );
    
    if (padding != null || margin != null) {
      column = Container(
        padding: padding,
        margin: margin,
        child: column,
      );
    }
    
    return column;
  }
}

