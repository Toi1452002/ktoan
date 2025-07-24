import 'package:flutter/material.dart';

class WidgetTableRow extends StatelessWidget {
  final Map<int, TableColumnWidth>? columnWidths;
  final List<Widget> items;

  const WidgetTableRow({super.key, this.columnWidths, required this.items});

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: columnWidths,
      children: [
        TableRow(
          children: items
              .map((e) => TableCell(verticalAlignment: TableCellVerticalAlignment.middle, child: e))
              .toList(),
        ),
      ],
    );
  }
}
