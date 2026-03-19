import 'package:flutter/material.dart';
import '../foundation/color_system.dart';
import '../foundation/theme.dart';
import '../foundation/radius_scale.dart';

class CoolTabItem {
  final String label;
  final IconData? icon;

  const CoolTabItem({required this.label, this.icon});
}

class CoolTabs extends StatefulWidget {
  final List<CoolTabItem> tabs;
  final TabController? controller;
  final int? currentIndex;
  final ValueChanged<int>? onTap;
  final Color? selectedColor;
  final Color? unselectedColor;

  const CoolTabs({
    super.key,
    required this.tabs,
    this.controller,
    this.currentIndex,
    this.onTap,
    this.selectedColor,
    this.unselectedColor,
  }) : assert(controller != null || (currentIndex != null && onTap != null));

  @override
  State<CoolTabs> createState() => _CoolTabsState();
}

class _CoolTabsState extends State<CoolTabs>
    with SingleTickerProviderStateMixin {
  late final TabController _internalController;
  late final bool _isInternal;

  @override
  void initState() {
    super.initState();
    _isInternal = widget.controller == null;
    if (_isInternal) {
      _internalController = TabController(
        length: widget.tabs.length,
        vsync: this,
        initialIndex: widget.currentIndex ?? 0,
      );
    } else {
      widget.controller!.addListener(_handleTabChange);
    }
  }

  void _handleTabChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    if (_isInternal) {
      _internalController.dispose();
    } else {
      widget.controller!.removeListener(_handleTabChange);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller ?? _internalController;
    final coolColors = context.coolColors;
    final selectedColor =
        widget.selectedColor ??
        coolColors?.resolve(CoolColorToken.primary) ??
        Colors.blue;
    final unselectedColor =
        widget.unselectedColor ??
        coolColors?.resolve(CoolColorToken.textSecondary) ??
        Colors.grey;

    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color:
            coolColors?.resolve(CoolColorToken.surfaceContainer) ??
            Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(CoolRadiusScale.lg),
      ),
      child: TabBar(
        controller: controller,
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: coolColors?.resolve(CoolColorToken.surface) ?? Colors.white,
          borderRadius: BorderRadius.circular(CoolRadiusScale.md),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        labelColor: selectedColor,
        unselectedLabelColor: unselectedColor,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 14,
        ),
        onTap: widget.onTap,
        tabs: widget.tabs
            .map(
              (tab) => Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (tab.icon != null) ...[
                      Icon(tab.icon, size: 18),
                      const SizedBox(width: 8),
                    ],
                    Text(tab.label),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
