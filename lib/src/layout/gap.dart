import 'package:flutter/material.dart';

/// Gap widget for spacing (vertical or horizontal)
class CoolGap extends StatelessWidget {
  final double size;
  final bool isVertical;
  
  const CoolGap({
    super.key,
    required this.size,
    this.isVertical = true,
  });
  
  const CoolGap.vertical({
    super.key,
    required this.size,
  }) : isVertical = true;
  
  const CoolGap.horizontal({
    super.key,
    required this.size,
  }) : isVertical = false;
  
  @override
  Widget build(BuildContext context) {
    if (isVertical) {
      return SizedBox(height: size);
    } else {
      return SizedBox(width: size);
    }
  }
}

