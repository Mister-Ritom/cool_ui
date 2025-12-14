import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../foundation/color_system.dart';
import '../foundation/theme.dart';
import '../foundation/radius_scale.dart';
import '../foundation/motion.dart';
import '../infrastructure/tappable.dart';

/// Tabs widget with animations
class CoolTabs extends StatefulWidget {
  final List<String> tabs;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final Color? selectedColor;
  final Color? unselectedColor;

  const CoolTabs({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.onTap,
    this.selectedColor,
    this.unselectedColor,
  });

  @override
  State<CoolTabs> createState() => _CoolTabsState();
}

class _CoolTabsState extends State<CoolTabs> {
  @override
  Widget build(BuildContext context) {
    final coolColors = context.coolColors;
    final selectedColor =
        widget.selectedColor ??
        coolColors?.resolve(CoolColorToken.primary) ??
        Colors.blue;
    final unselectedColor =
        widget.unselectedColor ??
        coolColors?.resolve(CoolColorToken.textSecondary) ??
        Colors.grey;

    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.tabs.length,
        itemBuilder: (context, index) {
          final isSelected = index == widget.currentIndex;
          return CoolTappable(
            onTap: () => widget.onTap(index),
            selected: isSelected,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: isSelected
                    ? selectedColor.withValues(alpha: 0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(CoolRadiusScale.md),
              ),
              child: Center(
                child:
                    Text(
                          widget.tabs[index],
                          style: TextStyle(
                            color: isSelected ? selectedColor : unselectedColor,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                            fontSize: 14,
                          ),
                        )
                        .animate(target: isSelected ? 1 : 0)
                        .scale(
                          begin: const Offset(1, 1),
                          end: const Offset(1.05, 1.05),
                          duration: CoolMotion.config.shortDuration,
                        ),
              ),
            ),
          );
        },
      ),
    );
  }
}
