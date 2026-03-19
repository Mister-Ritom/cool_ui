import 'package:flutter/material.dart';
import '../foundation/theme.dart';
import '../foundation/color_system.dart';
import '../foundation/elevation_model.dart';
import '../foundation/glass_container.dart';

/// A premium AppBar with glassmorphism and adaptive features
class CoolAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool centerTitle;
  final double elevation;
  final bool useGlass;
  final Color? backgroundColor;
  final PreferredSizeWidget? bottom;
  final double height;

  const CoolAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.centerTitle = false,
    this.elevation = 0,
    this.useGlass = true,
    this.backgroundColor,
    this.bottom,
    this.height = kToolbarHeight,
  });

  @override
  Size get preferredSize =>
      Size.fromHeight(height + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    final coolColors = context.coolColors;
    final bgColor =
        backgroundColor ??
        coolColors?.resolve(CoolColorToken.surface) ??
        Theme.of(context).appBarTheme.backgroundColor ??
        Colors.white;

    Widget content = AppBar(
      title: title,
      leading: leading,
      actions: actions,
      centerTitle: centerTitle,
      elevation: 0,
      backgroundColor: useGlass ? Colors.transparent : bgColor,
      surfaceTintColor: Colors.transparent,
      bottom: bottom,
    );

    if (useGlass) {
      content = CoolGlassContainer(
        blur: 20,
        opacity: context.coolIsDark ? 0.7 : 0.8,
        color: bgColor,
        radius: 0,
        border: Border(
          bottom: BorderSide(
            color:
                coolColors?.resolve(CoolColorToken.border) ??
                Colors.grey.withValues(alpha: 0.1),
            width: 0.5,
          ),
        ),
        child: content,
      );
    } else if (elevation > 0) {
      final elevatedColor = CoolElevationModel.getElevationColor(
        coolColors!,
        elevation.toInt(),
      );
      content = Container(
        decoration: BoxDecoration(
          color: elevatedColor,
          border: Border(
            bottom: BorderSide(
              color: coolColors.resolve(CoolColorToken.border),
              width: 0.5,
            ),
          ),
        ),
        child: content,
      );
    }

    return content;
  }
}
