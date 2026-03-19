import 'package:flutter/material.dart';
import 'list_tile.dart';
import '../foundation/color_system.dart';
import '../foundation/theme.dart';
import '../foundation/radius_scale.dart';

class CoolSettingsTile extends StatelessWidget {
  final Widget title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? leadingColor;
  final IconData? icon;

  const CoolSettingsTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.leadingColor,
    this.icon,
  }) : assert(leading != null || icon != null || leading == null);

  @override
  Widget build(BuildContext context) {
    final coolColors = context.coolColors;

    Widget? activeLeading = leading;
    if (icon != null && leading == null) {
      activeLeading = Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color:
              (leadingColor ??
                      coolColors?.resolve(CoolColorToken.primary) ??
                      Colors.blue)
                  .withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(CoolRadiusScale.sm),
        ),
        child: Icon(
          icon,
          color:
              leadingColor ??
              coolColors?.resolve(CoolColorToken.primary) ??
              Colors.blue,
          size: 20,
        ),
      );
    }

    return CoolListTile(
      title: title,
      subtitle: subtitle,
      leading: activeLeading,
      trailing:
          trailing ??
          Icon(
            Icons.chevron_right,
            color:
                coolColors?.resolve(CoolColorToken.textTertiary) ?? Colors.grey,
            size: 20,
          ),
      onTap: onTap,
    );
  }
}

class CoolSettingsSection extends StatelessWidget {
  final String? title;
  final List<Widget> children;

  const CoolSettingsSection({super.key, this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    final coolColors = context.coolColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Text(
              title!.toUpperCase(),
              style: TextStyle(
                color:
                    coolColors?.resolve(CoolColorToken.textSecondary) ??
                    Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
        Container(
          decoration: BoxDecoration(
            color: coolColors?.resolve(CoolColorToken.surface) ?? Colors.white,
            borderRadius: BorderRadius.circular(context.coolRadius),
          ),
          child: Column(
            children: List.generate(children.length, (index) {
              return Column(
                children: [
                  children[index],
                  if (index < children.length - 1)
                    Divider(
                      height: 1,
                      indent: 56,
                      color:
                          coolColors?.resolve(CoolColorToken.borderVariant) ??
                          Colors.grey.withValues(alpha: 0.1),
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}
