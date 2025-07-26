
import 'package:flutter/services.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:pm_ketoan/widgets/data_grid/button_filter.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';
import 'package:string_validator/string_validator.dart';
import 'package:trina_grid/trina_grid.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'data_column.dart';
import 'package:flutter/material.dart' as mt;

export 'data_column.dart';

class DataGrid extends StatefulWidget {
  final List<DataGridColumn> columns;
  final void Function(TrinaGridOnLoadedEvent)? onLoaded;
  // final List<TrinaRow<dynamic>> rows;
  // final TrinaGridStateManager stateManager;
  final bool hideFilter;
  final void Function(TrinaGridOnRowDoubleTapEvent)? onRowDoubleTap;
  final void Function(TrinaGridOnChangedEvent)? onChange;

  const DataGrid({
    super.key,
    required this.columns,
    this.onLoaded,
    // required this.rows,
    this.hideFilter = true,
    this.onRowDoubleTap,
    this.onChange,
    // required this.stateManager
  });

  @override
  State<DataGrid> createState() => _DataGridState();
}

class _DataGridState extends State<DataGrid> {
  late TrinaGridStateManager _stateManager;
  Map<String, List<dynamic>> filters = {};

  @override
  void initState() {
    // onSetFilterNull();
    super.initState();
  }

  void onSetFilterNull(TrinaGridStateManager state) {
    if (state.rows.isNotEmpty) {
      Map<String, dynamic> a = state.rows.first.toJson();
      for (var x in a.keys) {
        if (!['null', 'dl'].contains(x)) {
          filters.addEntries({x.toString(): []}.entries);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TrinaGrid(
      onLoaded: widget.onLoaded,
      onRowDoubleTap: widget.onRowDoubleTap,
      onChanged: widget.onChange,
      columns: widget.columns.map((e) {
        TrinaColumnType type = TrinaColumnType.text();
        TrinaColumnTextAlign textAlign = TrinaColumnTextAlign.start;
        Widget Function(TrinaColumnRendererContext)? renderer;
        EdgeInsets? cellPadding;
        Widget Function(TrinaColumnTitleRendererContext)? titleRenderer;
        if (e.columnType == ColumnType.num) type = TrinaColumnType.number();
        if (e.columnAlign == ColumnAlign.center) textAlign = TrinaColumnTextAlign.center;
        if (e.columnAlign == ColumnAlign.right || e.columnType == ColumnType.num) {
          textAlign = TrinaColumnTextAlign.right;
        }

        if (e.render == TypeRender.numIndex) {
          renderer = (re) => Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.gray.shade300.withValues(alpha: .7),
              border: Border(right: BorderSide(width: .5)),
            ),
            child: Text("${re.rowIdx + 1}", style: TextStyle(fontSize: 13)).medium,
          );
          cellPadding = EdgeInsets.zero;
          titleRenderer = (re) => Container(
            decoration: BoxDecoration(
              color: Colors.blue.shade200,
              border: Border(right: BorderSide(width: .5)),
            ),
          );
        }

        if (e.render == TypeRender.delete) {
          renderer = (re) => mt.InkWell(
            onTap: () {
              if(re.cell.value!=''){
                e.onTapDelete?.call(re.cell.value, re);
              }

              re.stateManager.setKeepFocus(true);
              re.stateManager.setCurrentCell(re.cell, re.rowIdx);

            },
            child: Icon(PhosphorIcons.trash(), color: Colors.red.shade600),
          );
          titleRenderer = (re) => Container(
            decoration: BoxDecoration(
              color: Colors.blue.shade200,
              border: Border(right: BorderSide(width: .5)),
            ),
          );
          cellPadding = EdgeInsets.zero;
        }

        if (e.cellColor == CellColor.red) {
          renderer = (re) => Text(re.cell.value, style: TextStyle(fontSize: 13, color: Colors.red.shade600)).medium;
        }

        if (e.render != TypeRender.delete && e.render != TypeRender.numIndex) {
          titleRenderer = (re) {
            final List<TrinaRow> filteredRows = re.stateManager.filterRows.isNotEmpty
                ? re.stateManager.filterRows
                : re.stateManager.rows;
            List<dynamic> availableValues = _getUniqueValues(re.column.field, filteredRows);
            Map<String, bool> map = {
              for (var value in availableValues)
                value.toString(): filters.isEmpty ? false : filters[re.column.field]!.contains(value),
            };

            if (widget.hideFilter) {
              onSetFilterNull(re.stateManager);
              re.stateManager.setFilter((re) => true);
            }

            if(!widget.hideFilter && filters.isEmpty){
              onSetFilterNull(re.stateManager);
            }
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: filters.isEmpty
                    ? Colors.blue.shade200
                    : (filters[re.column.field]!.isEmpty ? Colors.blue.shade200 : Colors.green.shade200),
                border: Border(right: BorderSide(width: .5)),
              ),
              child: Row(
                children: [
                  Text(re.column.title).medium,
                  Spacer(),
                  if (!widget.hideFilter)
                    ButtonFilter(
                      items: map,
                      field: re.column.field,
                      onChanged: (val) {
                        filters[re.column.field] = val.entries
                            .where((e) => e.value)
                            .map((e) => availableValues.firstWhere((v) => v.toString() == e.key))
                            .toList();
                        re.stateManager.setFilter((row) {
                          final nameFilter = filters.keys.toList();
                          final List<bool> result = nameFilter.map((e) {
                            var x = row.cells[e]!.value;
                            if (isNumeric(x.toString())) {
                              x = double.parse(x.toString()).toString();
                            }
                            return filters[e]!.isEmpty || filters[e]!.contains(x);
                          }).toList();
                          return result.every((e) => e);
                        });
                        setState(() {});
                      },
                    ),
                ],
              ),
            );
          };
        }

        return TrinaColumn(
          renderer: renderer,
          title: e.title.first,
          field: e.title.last,
          type: type,
          width: e.width,
          enableColumnDrag: false,
          enableContextMenu: false,
          enableDropToResize: false,
          enableFilterMenuItem: false,
          enableSorting: false,
          enableAutoEditing: true,
          backgroundColor: Colors.blue.shade300,
          textAlign: textAlign,
          enableEditingMode: e.isEdit,
          cellPadding: cellPadding,
          titleRenderer: titleRenderer,
        );
      }).toList(),
      rows: [],
      configuration: TrinaGridConfiguration(
        tabKeyAction: TrinaGridTabKeyAction.moveToNextOnEdge,
        enterKeyAction: TrinaGridEnterKeyAction.editingAndMoveRight,
        scrollbar: TrinaGridScrollbarConfig(showHorizontal: true, thickness: 5, isAlwaysShown: true),
        columnSize: const TrinaGridColumnSizeConfig(autoSizeMode: TrinaAutoSizeMode.none),
        shortcut: TrinaGridShortcut(
          actions: {
            ...TrinaGridShortcut.defaultActions,
            LogicalKeySet(LogicalKeyboardKey.escape): CustomEscKeyAction(),
            // LogicalKeySet(LogicalKeyboardKey.keyN,LogicalKeyboardKey.control): CustomEnterKeyAction(),
          },
        ),
        style: TrinaGridStyleConfig(
          columnFilterHeight: 25,
          defaultColumnFilterPadding: EdgeInsets.all(.2),
          borderColor: context.theme.colorScheme.mutedForeground,
          gridBorderRadius: BorderRadius.circular(2),
          activatedBorderColor: context.theme.colorScheme.primary,
          columnHeight: 25,
          activatedColor: context.theme.colorScheme.primary.withValues(alpha: .1),
          rowHeight: 25,
          columnTextStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black),
          rowColor: context.theme.colorScheme.popover,
          cellTextStyle: TextStyle(fontSize: 13, color: context.theme.colorScheme.foreground),
          defaultCellPadding: const EdgeInsets.only(left: 3, right: 4),
        ),
      ),
    );
  }

  // Lấy giá trị duy nhất từ cột dựa trên dữ liệu đã lọc
  List<dynamic> _getUniqueValues(String field, List<TrinaRow> currentRows) {
    final data = currentRows.map((row) => row.cells[field]!.value.toString()).toSet().toList();

    if (data.every((e) => isNumeric(e))) {
      List<double> x = data.map((e) => double.parse(e)).toList();
      x.sort();
      return x.map((e) {
        if (e == 0.0) return '0';
        if (isInt(e.toString())) {
          return e.toInt().toString();
        } else {
          return e.toString();
        }
      }).toList();
    }
    // if (isNgay) {
    //   List<DateTime?> dateList = data.map((e) => Helper.stringToDate(e)).toList();
    //   dateList.sort();
    //   return dateList.map((e) => Helper.dateFormatDMY(e!)).toList();
    // }
    // if(isNumber){
    //   List<double> x = data.map((e) => double.parse(e)).toList();
    //   x.sort();
    //   return x.map((e){
    //     if(e==0.0) return '0';
    //     if(Check().isInteger(e)){
    //       return e.toInt().toString();
    //     }else{
    //       return e.toString();
    //     }
    //   }).toList();
    // }
    data.sort();
    return data;
  }
}

class CustomEscKeyAction extends TrinaGridShortcutAction {
  @override
  void execute({required TrinaKeyManagerEvent keyEvent, required TrinaGridStateManager stateManager}) {
    stateManager.clearCurrentSelecting();
    stateManager.clearCurrentCell();
    stateManager.setKeepFocus(false);
  }
}
