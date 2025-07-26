import 'package:trina_grid/trina_grid.dart';

enum ColumnType { text, num }

enum ColumnAlign { left, center, right }

enum TypeRender { numIndex, delete }

enum CellColor {red, blue}

class DataGridColumn {
  final List<String> title;
  final ColumnType columnType;
  final ColumnAlign columnAlign;
  final double width;
  final bool isEdit;
  final TypeRender? render;
  final CellColor? cellColor;
  final void Function(dynamic value, TrinaColumnRendererContext? re)? onTapDelete;

  const DataGridColumn({
    required this.title,
    this.columnType = ColumnType.text,
    this.width = 200,
    this.columnAlign = ColumnAlign.left,
    this.isEdit = false,
    this.render,
    this.cellColor,
    this.onTapDelete
  });
}
