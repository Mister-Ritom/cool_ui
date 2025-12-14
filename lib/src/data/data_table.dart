import 'package:flutter/material.dart';
import '../foundation/color_system.dart';
import '../foundation/theme.dart';
import '../foundation/radius_scale.dart';
import '../foundation/interaction_state.dart';
import '../infrastructure/tappable.dart';

/// Data table column definition
class CoolDataTableColumn {
  final String label;
  final double? width;
  final TextAlign? alignment;

  const CoolDataTableColumn({required this.label, this.width, this.alignment});
}

/// Data table row
class CoolDataTableRow {
  final List<Widget> cells;
  final Object? data;
  final bool isSelected;

  const CoolDataTableRow({
    required this.cells,
    this.data,
    this.isSelected = false,
  });
}

/// Data table widget
class CoolDataTable extends StatelessWidget {
  final List<CoolDataTableColumn> columns;
  final List<CoolDataTableRow> rows;
  final ValueChanged<int>? onRowTap;
  final ValueChanged<int>? onRowSelect;
  final bool showHeader;
  final EdgeInsets? padding;

  const CoolDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.onRowTap,
    this.onRowSelect,
    this.showHeader = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final coolColors = context.coolColors;
    final headerColor =
        coolColors?.resolve(CoolColorToken.surfaceContainer) ??
        Colors.grey.shade200;
    final borderColor =
        coolColors?.resolve(CoolColorToken.border) ?? Colors.grey.shade300;

    return Container(
      decoration: BoxDecoration(
        color: coolColors?.resolve(CoolColorToken.surface),
        borderRadius: BorderRadius.circular(CoolRadiusScale.md),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          if (showHeader) _buildHeader(context, headerColor, borderColor),
          ...rows.asMap().entries.map((entry) {
            final index = entry.key;
            final row = entry.value;
            return _buildRow(context, index, row, borderColor);
          }),
        ],
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    Color headerColor,
    Color borderColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: headerColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(CoolRadiusScale.md),
          topRight: Radius.circular(CoolRadiusScale.md),
        ),
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      child: Row(
        children: columns.map((column) {
          return Expanded(
            flex: column.width != null ? (column.width! ~/ 10) : 1,
            child: Text(
              column.label,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              textAlign: column.alignment ?? TextAlign.start,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRow(
    BuildContext context,
    int index,
    CoolDataTableRow row,
    Color borderColor,
  ) {
    final stateManager = CoolInteractionStateManager();
    if (row.isSelected) {
      stateManager.transitionTo(CoolInteractionState.selected);
    }

    return CoolTappable(
      onTap: () {
        onRowTap?.call(index);
        onRowSelect?.call(index);
      },
      selected: row.isSelected,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: borderColor.withValues(alpha: 0.5),
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: row.cells.asMap().entries.map((entry) {
            final cellIndex = entry.key;
            final cell = entry.value;
            final column = columns[cellIndex];

            return Expanded(
              flex: column.width != null ? (column.width! ~/ 10) : 1,
              child: cell,
            );
          }).toList(),
        ),
      ),
    );
  }
}
