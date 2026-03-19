import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../foundation/theme.dart';
import '../foundation/color_system.dart';
import '../foundation/motion.dart';
import '../foundation/glass_container.dart';
import '../infrastructure/tappable.dart';

class CoolBottomNavItem {
  final IconData icon;
  final IconData? activeIcon;
  final String? label;
  final Widget? badge;

  const CoolBottomNavItem({
    required this.icon,
    this.activeIcon,
    this.label,
    this.badge,
  });
}

class CoolBottomNavigationBar extends StatelessWidget {
  final List<CoolBottomNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final bool isFloating;

  const CoolBottomNavigationBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.isFloating = true,
  });

  @override
  Widget build(BuildContext context) {
    final coolColors = context.coolColors;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    Widget navBar = Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: isFloating ? 12 : (12 + bottomPadding),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final item = items[index];
          final isSelected = index == currentIndex;

          return _NavBarItem(
            item: item,
            isSelected: isSelected,
            onTap: () => onTap(index),
            activeColor:
                coolColors?.resolve(CoolColorToken.primary) ?? Colors.blue,
            inactiveColor:
                coolColors?.resolve(CoolColorToken.textSecondary) ??
                Colors.grey,
          );
        }),
      ),
    );

    if (isFloating) {
      navBar = Padding(
        padding: EdgeInsets.fromLTRB(24, 0, 24, 16 + bottomPadding),
        child: CoolGlassContainer(
          blur: 20,
          opacity: context.coolIsDark ? 0.6 : 0.8,
          radius: 32,
          child: navBar,
        ),
      );
    } else {
      navBar = CoolGlassContainer(
        blur: 20,
        opacity: context.coolIsDark ? 0.8 : 0.9,
        radius: 0,
        border: Border(
          top: BorderSide(
            color:
                coolColors?.resolve(CoolColorToken.border) ??
                Colors.grey.withValues(alpha: 0.1),
            width: 0.5,
          ),
        ),
        child: navBar,
      );
    }

    return navBar;
  }
}

class _NavBarItem extends StatelessWidget {
  final CoolBottomNavItem item;
  final bool isSelected;
  final VoidCallback onTap;
  final Color activeColor;
  final Color inactiveColor;

  const _NavBarItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    Widget icon = Icon(
      isSelected ? (item.activeIcon ?? item.icon) : item.icon,
      color: isSelected ? activeColor : inactiveColor,
      size: 26,
    );

    if (item.badge != null) {
      icon = Stack(
        clipBehavior: Clip.none,
        children: [
          icon,
          Positioned(top: -4, right: -4, child: item.badge!),
        ],
      );
    }

    return CoolTappable(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon
              .animate(target: isSelected ? 1 : 0)
              .scale(
                begin: const Offset(1, 1),
                end: const Offset(1.2, 1.2),
                duration: CoolMotion.config.shortDuration,
                curve: Curves.easeOutBack,
              ),
          if (item.label != null) ...[
            const SizedBox(height: 4),
            Text(
              item.label!,
              style: TextStyle(
                color: isSelected ? activeColor : inactiveColor,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
