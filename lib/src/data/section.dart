import 'package:flutter/material.dart';
import '../foundation/color_system.dart';
import '../foundation/theme.dart';
import '../foundation/radius_scale.dart';
import '../foundation/motion.dart';
import '../infrastructure/tappable.dart';
import '../layout/row_column.dart';
import 'collapsible.dart';

/// Section header widget
class CoolSectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isExpanded;
  final EdgeInsets? padding;
  
  const CoolSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.isExpanded = false,
    this.padding,
  });
  
  @override
  Widget build(BuildContext context) {
    final coolColors = context.coolColors;
    final padding = this.padding ?? const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 12,
    );
    
    return CoolTappable(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: coolColors?.resolve(CoolColorToken.surface) ?? Colors.transparent,
          borderRadius: BorderRadius.circular(CoolRadiusScale.md),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 12,
                        color: coolColors?.resolve(CoolColorToken.textSecondary),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 8),
              trailing!,
            ] else ...[
              AnimatedRotation(
                turns: isExpanded ? 0.5 : 0.0,
                duration: CoolMotion.config.defaultDuration,
                curve: CoolMotion.config.defaultCurve,
                child: Icon(
                  Icons.expand_more,
                  color: coolColors?.resolve(CoolColorToken.textSecondary),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Section widget (collapsible with header)
class CoolSection extends StatefulWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final Widget child;
  final bool initialExpanded;
  final CoolCollapsibleStyle? style;
  
  const CoolSection({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    required this.child,
    this.initialExpanded = false,
    this.style,
  });
  
  @override
  State<CoolSection> createState() => _CoolSectionState();
}

class _CoolSectionState extends State<CoolSection> {
  late bool _isExpanded;
  
  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initialExpanded;
  }
  
  @override
  Widget build(BuildContext context) {
    return CoolColumn(
      children: [
        CoolSectionHeader(
          title: widget.title,
          subtitle: widget.subtitle,
          trailing: widget.trailing,
          isExpanded: _isExpanded,
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
        ),
        CoolCollapsible(
          isExpanded: _isExpanded,
          style: widget.style,
          expandedChild: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: widget.child,
          ),
        ),
      ],
    );
  }
}

