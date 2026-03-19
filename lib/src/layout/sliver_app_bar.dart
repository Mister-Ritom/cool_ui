import 'package:flutter/material.dart';
import '../foundation/theme.dart';
import '../foundation/color_system.dart';

class CoolSliverAppBar extends StatelessWidget {
  final Widget? title;
  final Widget? leading;
  final List<Widget>? actions;
  final Widget? background;
  final double expandedHeight;
  final bool pinned;
  final bool floating;
  final Color? backgroundColor;
  final PreferredSizeWidget? bottom;

  const CoolSliverAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.background,
    this.expandedHeight = 200,
    this.pinned = true,
    this.floating = false,
    this.backgroundColor,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    final coolColors = context.coolColors;
    final bgColor =
        backgroundColor ??
        coolColors?.resolve(CoolColorToken.surface) ??
        Theme.of(context).appBarTheme.backgroundColor ??
        Colors.white;

    return SliverAppBar(
      expandedHeight: expandedHeight,
      pinned: pinned,
      floating: floating,
      leading: leading,
      title: title,
      actions: actions,
      backgroundColor: bgColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      bottom: bottom,
      flexibleSpace: FlexibleSpaceBar(
        background: background,
        title: title,
        centerTitle: true,
        titlePadding: const EdgeInsets.only(bottom: 16),
      ),
    );
  }
}
