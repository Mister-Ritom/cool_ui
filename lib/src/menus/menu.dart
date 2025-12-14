import 'package:flutter/material.dart';
import '../foundation/color_system.dart';
import '../foundation/theme.dart';
import '../foundation/radius_scale.dart';

/// Menu item
class CoolMenuItem {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool enabled;
  final bool isDestructive;

  const CoolMenuItem({
    required this.label,
    this.icon,
    this.onTap,
    this.enabled = true,
    this.isDestructive = false,
  });
}

/// Menu button (three-dot / overflow menu)
class CoolMenuButton extends StatelessWidget {
  final List<CoolMenuItem> items;
  final IconData icon;
  final String? tooltip;
  final CoolMenuPosition position;

  const CoolMenuButton({
    super.key,
    required this.items,
    this.icon = Icons.more_vert,
    this.tooltip,
    this.position = CoolMenuPosition.bottomEnd,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<CoolMenuItem>(
      icon: Icon(icon),
      tooltip: tooltip,
      position: _convertPosition(position),
      itemBuilder: (context) => items
          .map(
            (item) => PopupMenuItem<CoolMenuItem>(
              enabled: item.enabled,
              value: item,
              child: Row(
                children: [
                  if (item.icon != null) ...[
                    Icon(
                      item.icon,
                      size: 20,
                      color: item.isDestructive
                          ? Theme.of(context).colorScheme.error
                          : null,
                    ),
                    const SizedBox(width: 12),
                  ],
                  Text(
                    item.label,
                    style: TextStyle(
                      color: item.isDestructive
                          ? Theme.of(context).colorScheme.error
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
      onSelected: (item) => item.onTap?.call(),
    );
  }

  PopupMenuPosition _convertPosition(CoolMenuPosition position) {
    switch (position) {
      case CoolMenuPosition.topStart:
        return PopupMenuPosition.over;
      case CoolMenuPosition.topEnd:
        return PopupMenuPosition.over;
      case CoolMenuPosition.bottomStart:
        return PopupMenuPosition.under;
      case CoolMenuPosition.bottomEnd:
        return PopupMenuPosition.under;
    }
  }
}

enum CoolMenuPosition { topStart, topEnd, bottomStart, bottomEnd }

/// Popup menu widget (anchored popup)
class CoolPopupMenu extends StatelessWidget {
  final List<CoolMenuItem> items;
  final Widget child;
  final CoolMenuPosition position;
  final double? width;

  const CoolPopupMenu({
    super.key,
    required this.items,
    required this.child,
    this.position = CoolMenuPosition.bottomEnd,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final coolColors = context.coolColors;
    final bgColor = coolColors?.resolve(CoolColorToken.surface) ?? Colors.white;

    return PopupMenuButton<CoolMenuItem>(
      position: _convertPosition(position),
      itemBuilder: (context) => items
          .map(
            (item) => PopupMenuItem<CoolMenuItem>(
              enabled: item.enabled,
              value: item,
              child: Container(
                width: width,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: Row(
                  children: [
                    if (item.icon != null) ...[
                      Icon(
                        item.icon,
                        size: 20,
                        color: item.isDestructive
                            ? coolColors?.resolve(CoolColorToken.error)
                            : coolColors?.resolve(CoolColorToken.text),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: Text(
                        item.label,
                        style: TextStyle(
                          color: item.isDestructive
                              ? coolColors?.resolve(CoolColorToken.error)
                              : coolColors?.resolve(CoolColorToken.text),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
      onSelected: (item) {
        if (item.onTap != null) {
          item.onTap!();
        }
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(CoolRadiusScale.md),
      ),
      color: bgColor,
      child: child,
    );
  }

  PopupMenuPosition _convertPosition(CoolMenuPosition position) {
    switch (position) {
      case CoolMenuPosition.topStart:
        return PopupMenuPosition.over;
      case CoolMenuPosition.topEnd:
        return PopupMenuPosition.over;
      case CoolMenuPosition.bottomStart:
        return PopupMenuPosition.under;
      case CoolMenuPosition.bottomEnd:
        return PopupMenuPosition.under;
    }
  }
}
