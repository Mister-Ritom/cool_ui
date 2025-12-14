import 'package:flutter/material.dart';
import '../foundation/color_system.dart';
import '../foundation/theme.dart';
import '../foundation/radius_scale.dart';
import '../foundation/motion.dart';

/// Swipe action item
class CoolSwipeActionItem {
  final String label;
  final IconData? icon;
  final Color? color;
  final VoidCallback? onTap;
  
  const CoolSwipeActionItem({
    required this.label,
    this.icon,
    this.color,
    this.onTap,
  });
}

/// Swipe action widget
class CoolSwipeAction extends StatefulWidget {
  final Widget child;
  final List<CoolSwipeActionItem> leftActions;
  final List<CoolSwipeActionItem> rightActions;
  final double actionWidth;
  
  const CoolSwipeAction({
    super.key,
    required this.child,
    this.leftActions = const [],
    this.rightActions = const [],
    this.actionWidth = 80,
  });
  
  @override
  State<CoolSwipeAction> createState() => _CoolSwipeActionState();
}

class _CoolSwipeActionState extends State<CoolSwipeAction>
    with SingleTickerProviderStateMixin {
  final _controller = ScrollController();
  double _dragOffset = 0.0;
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  void _handleDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.primaryDelta ?? 0;
      _dragOffset = _dragOffset.clamp(
        -widget.rightActions.length * widget.actionWidth,
        widget.leftActions.length * widget.actionWidth,
      );
    });
  }
  
  void _handleDragEnd(DragEndDetails details) {
    final threshold = widget.actionWidth * 0.5;
    if (_dragOffset.abs() < threshold) {
      setState(() => _dragOffset = 0.0);
    } else {
      // Snap to nearest action
      final snapTo = (_dragOffset / widget.actionWidth).round().clamp(
        -widget.rightActions.length,
        widget.leftActions.length,
      );
      setState(() {
        _dragOffset = snapTo * widget.actionWidth;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final coolColors = context.coolColors;
    
    // Use default radius - child should handle its own clipping
    final radius = CoolRadiusScale.md;
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: GestureDetector(
        onHorizontalDragUpdate: _handleDragUpdate,
        onHorizontalDragEnd: _handleDragEnd,
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            // Background actions - positioned based on drag offset
            Positioned.fill(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left actions
                  if (widget.leftActions.isNotEmpty)
                    Row(
                      children: widget.leftActions.map((action) {
                        return Container(
                          width: widget.actionWidth,
                          color: action.color ?? 
                              coolColors?.resolve(CoolColorToken.primary) ??
                              Colors.blue,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: action.onTap,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (action.icon != null)
                                    Icon(
                                      action.icon,
                                      color: Colors.white,
                                    ),
                                  const SizedBox(height: 4),
                                  Text(
                                    action.label,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  const Spacer(),
                  // Right actions
                  if (widget.rightActions.isNotEmpty)
                    Row(
                      children: widget.rightActions.map((action) {
                        return Container(
                          width: widget.actionWidth,
                          color: action.color ?? 
                              coolColors?.resolve(CoolColorToken.error) ??
                              Colors.red,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: action.onTap,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (action.icon != null)
                                    Icon(
                                      action.icon,
                                      color: Colors.white,
                                    ),
                                  const SizedBox(height: 4),
                                  Text(
                                    action.label,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
            // Main content - moves over actions
            AnimatedContainer(
              duration: CoolMotion.config.defaultDuration,
              curve: CoolMotion.config.defaultCurve,
              transform: Matrix4.identity()..translate(_dragOffset),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(radius),
                child: widget.child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

