import 'package:flutter/material.dart';
import '../foundation/color_system.dart';
import '../foundation/theme.dart';
import '../foundation/radius_scale.dart';
import '../foundation/motion.dart';
import '../foundation/interaction_state.dart';
import '../foundation/animated_surface.dart';

/// Bottom navigation bar item
class CoolBottomNavItem {
  final IconData icon;
  final String label;
  final Widget? badge;
  
  const CoolBottomNavItem({
    required this.icon,
    required this.label,
    this.badge,
  });
}

/// Bottom navigation bar with animations
class CoolBottomNavigationBar extends StatefulWidget {
  final List<CoolBottomNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? unselectedColor;
  
  const CoolBottomNavigationBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
  });
  
  @override
  State<CoolBottomNavigationBar> createState() => _CoolBottomNavigationBarState();
}

class _CoolBottomNavigationBarState extends State<CoolBottomNavigationBar> {
  final Map<int, CoolInteractionStateManager> _stateManagers = {};
  
  @override
  void dispose() {
    for (final manager in _stateManagers.values) {
      manager.dispose();
    }
    super.dispose();
  }
  
  CoolInteractionStateManager _getStateManager(int index) {
    if (!_stateManagers.containsKey(index)) {
      _stateManagers[index] = CoolInteractionStateManager();
      if (index == widget.currentIndex) {
        _stateManagers[index]!.transitionTo(CoolInteractionState.selected);
      }
    }
    return _stateManagers[index]!;
  }
  
  @override
  Widget build(BuildContext context) {
    final coolColors = context.coolColors;
    final bgColor = widget.backgroundColor ?? 
        coolColors?.resolve(CoolColorToken.surface) ?? 
        Colors.white;
    final selectedColor = widget.selectedColor ?? 
        coolColors?.resolve(CoolColorToken.primary) ?? 
        Colors.blue;
    final unselectedColor = widget.unselectedColor ?? 
        coolColors?.resolve(CoolColorToken.textSecondary) ?? 
        Colors.grey;
    
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(CoolRadiusScale.lg),
        topRight: Radius.circular(CoolRadiusScale.lg),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
        ),
        child: SafeArea(
          top: false,
          child: Container(
            height: 60, // Fixed height to match content
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(
                widget.items.length,
                (index) => _buildNavItem(
                  widget.items[index],
                  index,
                  index == widget.currentIndex,
                  selectedColor,
                  unselectedColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildNavItem(
    CoolBottomNavItem item,
    int index,
    bool isSelected,
    Color selectedColor,
    Color unselectedColor,
  ) {
    final stateManager = _getStateManager(index);
    
    // Update state based on selection
    if (isSelected && stateManager.state != CoolInteractionState.selected) {
      stateManager.transitionTo(CoolInteractionState.selected);
    } else if (!isSelected && stateManager.state == CoolInteractionState.selected) {
      stateManager.transitionTo(CoolInteractionState.idle);
    }
    
    return Expanded(
      child: GestureDetector(
        onTap: () => widget.onTap(index),
        child: MouseRegion(
          onEnter: (_) => stateManager.transitionTo(
            isSelected 
                ? CoolInteractionState.selected 
                : CoolInteractionState.hover,
          ),
          onExit: (_) => stateManager.transitionTo(
            isSelected 
                ? CoolInteractionState.selected 
                : CoolInteractionState.idle,
          ),
          child: Container(
            height: 60, // Match parent height
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    // Rounded tint background - uses animated surface
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: CoolAnimatedSurface(
                        stateManager: stateManager,
                        backgroundColor: Colors.transparent,
                        tintColor: selectedColor,
                        radius: CoolRadiusScale.md,
                        isSelected: isSelected,
                        child: Container(),
                      ),
                    ),
                    // Icon - animated color and scale
                    AnimatedDefaultTextStyle(
                      duration: CoolMotion.config.defaultDuration,
                      curve: CoolMotion.config.defaultCurve,
                      style: TextStyle(
                        color: isSelected ? selectedColor : unselectedColor,
                        fontSize: isSelected ? 24 : 22,
                      ),
                      child: Icon(
                        item.icon,
                        color: isSelected ? selectedColor : unselectedColor,
                        size: isSelected ? 24 : 22,
                      ),
                    ),
                    if (item.badge != null)
                      Positioned(
                        right: -6,
                        top: -6,
                        child: item.badge!,
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                AnimatedDefaultTextStyle(
                  duration: CoolMotion.config.defaultDuration,
                  curve: CoolMotion.config.defaultCurve,
                  style: TextStyle(
                    color: isSelected ? selectedColor : unselectedColor,
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                  child: Text(
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

