import 'package:flutter/material.dart';
import 'package:trina_grid/trina_grid.dart';

enum ColumnType { text, num, date }

enum ColumnAlign { left, center, right }

enum TypeRender { numIndex, delete }

enum TextColor { red, blue, black }

class DataGridColumn {
  final List<String> title;
  final ColumnType columnType;
  final ColumnAlign columnAlign;
  final double width;
  final bool isEdit;
  final TypeRender? render;
  final TextColor? textColor;
  final void Function(dynamic value, TrinaColumnRendererContext? event)? onTapDelete;
  final Widget Function(TrinaColumnRendererContext)? renderer;
  final double? padding;
  final Color? headerColor;
  final bool showFooter;

  const DataGridColumn({
    required this.title,
    this.columnType = ColumnType.text,
    this.width = 200,
    this.columnAlign = ColumnAlign.left,
    this.isEdit = false,
    this.render,
    this.textColor,
    this.onTapDelete,
    this.renderer,
    this.padding,
    this.headerColor,
    this.showFooter = false,
  });
}
