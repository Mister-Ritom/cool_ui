import 'package:flutter/material.dart';
import '../foundation/color_system.dart';
import '../foundation/theme.dart';
import '../foundation/radius_scale.dart';

/// Draggable item widget
class CoolDraggable extends StatefulWidget {
  final Widget child;
  final Object data;
  final VoidCallback? onDragStart;
  final ValueChanged<Offset>? onDragUpdate;
  final VoidCallback? onDragEnd;
  final Widget? feedback;
  final Color? dragColor;
  
  const CoolDraggable({
    super.key,
    required this.child,
    required this.data,
    this.onDragStart,
    this.onDragUpdate,
    this.onDragEnd,
    this.feedback,
    this.dragColor,
  });
  
  @override
  State<CoolDraggable> createState() => _CoolDraggableState();
}

class _CoolDraggableState extends State<CoolDraggable> {
  bool _isDragging = false;
  
  @override
  Widget build(BuildContext context) {
    final coolColors = context.coolColors;
    final primaryColor = coolColors?.resolve(CoolColorToken.primary);
    final dragColor = widget.dragColor ?? 
        (primaryColor != null 
            ? primaryColor.withValues(alpha: 0.1)
            : Colors.blue.withValues(alpha: 0.1));
    
    Widget feedback = widget.feedback ?? widget.child;
    
    // Use GestureDetector with drag priority to avoid conflicts
    return Listener(
      onPointerDown: (_) {
        // Cancel any tap gestures when drag starts
      },
      child: LongPressDraggable<Object>(
        data: widget.data,
        dragAnchorStrategy: pointerDragAnchorStrategy,
        feedback: Material(
          color: Colors.transparent,
          child: Opacity(
            opacity: 0.8,
            child: Transform.scale(
              scale: 1.05,
              child: feedback,
            ),
          ),
        ),
        childWhenDragging: Opacity(
          opacity: 0.3,
          child: widget.child,
        ),
        onDragStarted: () {
          setState(() => _isDragging = true);
          widget.onDragStart?.call();
        },
        onDragUpdate: (details) {
          widget.onDragUpdate?.call(details.localPosition);
        },
        onDragEnd: (_) {
          setState(() => _isDragging = false);
          widget.onDragEnd?.call();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: _isDragging ? dragColor : Colors.transparent,
            borderRadius: BorderRadius.circular(CoolRadiusScale.md),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

/// Draggable layout container
class CoolDraggableLayout extends StatefulWidget {
  final List<Widget> children;
  final ValueChanged<int>? onReorder;
  final Axis direction;
  
  const CoolDraggableLayout({
    super.key,
    required this.children,
    this.onReorder,
    this.direction = Axis.vertical,
  });
  
  @override
  State<CoolDraggableLayout> createState() => _CoolDraggableLayoutState();
}

class _CoolDraggableLayoutState extends State<CoolDraggableLayout> {
  @override
  Widget build(BuildContext context) {
    if (widget.direction == Axis.vertical) {
      // Ensure all children have keys for ReorderableListView
      final keyedChildren = widget.children.asMap().entries.map((entry) {
        final index = entry.key;
        final child = entry.value;
        // If child already has a key, use it; otherwise create one
        return child.key != null 
            ? child 
            : KeyedSubtree(
                key: ValueKey('draggable_$index'),
                child: child,
              );
      }).toList();
      
      return ReorderableListView(
        onReorder: (oldIndex, newIndex) {
          if (newIndex > oldIndex) {
            newIndex -= 1;
          }
          widget.onReorder?.call(oldIndex);
        },
        children: keyedChildren,
      );
    } else {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: widget.children,
        ),
      );
    }
  }
}

