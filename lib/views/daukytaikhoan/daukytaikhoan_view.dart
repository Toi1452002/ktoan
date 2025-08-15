import 'package:pm_ketoan/widgets/data_grid/data_grid.dart';
import 'package:pm_ketoan/widgets/dialog_windows/dialog_funtion.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trina_grid/trina_grid.dart';
import 'package:flutter/material.dart' as mt;

import '../../core/utils/helper.dart';
import 'daukytaikhoan_function.dart';

class DauKyBTKView extends ConsumerStatefulWidget {
  const DauKyBTKView({super.key});

  static const title = "Đầu kỳ tài khoản";
  static const name = "Đầu kỳ tài khoản";

  static void show(BuildContext context) {
    showCustomDialog(context, title: title.toUpperCase(), width: 760, height: 600, child: DauKyBTKView());
  }

  @override
  ConsumerState createState() => _DauKyBTKViewState();
}

class _DauKyBTKViewState extends ConsumerState<DauKyBTKView> {
  late TrinaGridStateManager _stateManager;
  List<Map<String, dynamic>> data = [];
  final fc = DauKyBTKFunction();

  @override
  void initState() {
    // TODO: implement initState
    loadData();
    super.initState();
  }

  void loadData() async {
    data = await fc.get();
    if (data.isNotEmpty) {
      _stateManager.removeAllRows();
      _stateManager.appendRows(
        data.map((e) {
          return TrinaRow(
            cells: {
              'null': TrinaCell(value: ''),
              'Ngay': TrinaCell(value: e['Ngay']),
              'MaTK': TrinaCell(value: e['MaTK']),
              'TenTK': TrinaCell(value: e['TenTK']),
              'DKCo': TrinaCell(value: e['DKCo'] ?? 0),
              'DKNo': TrinaCell(value: e['DKNo'] ?? 0),
              'TinhChat': TrinaCell(value: e['TinhChat']),
            },
          );
        }).toList(),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      headers: [
        AppBar(
          padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
          trailing: [
            TextButton(
              child: Text('Cập nhật'),
              onPressed: () async {
                final result = await fc.isCapNhat(_stateManager);
                if (!result) loadData();
              },
            ),
          ],
        ),
      ],
      child: DataGrid(
        onLoaded: (e) => _stateManager = e.stateManager,
        columns: [
          DataGridColumn(title: ['', 'null'], width: 25, render: TypeRender.numIndex),
          DataGridColumn(
            title: ['Ngày', 'Ngay'],
            width: 85,
            columnType: ColumnType.date,
            renderer: (re) {
              return mt.InkWell(
                onTap: () async {
                  re.stateManager.setKeepFocus(true);
                  re.stateManager.setCurrentCell(re.cell, re.rowIdx);
                  final x = Helper.strToDate(re.cell.value);
                  final date = await mt.showDatePicker(
                    builder: (context, child) {
                      return mt.Theme(
                        data: mt.ThemeData(
                          colorSchemeSeed: Colors.blue,
                          datePickerTheme: mt.DatePickerThemeData(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                          ),
                        ),
                        child: child!,
                      );
                    },
                    context: context,
                    firstDate: DateTime(1900),
                    lastDate: DateTime(3000),
                    initialDate: x,
                  );
                  if (date != null) {
                    re.row.cells['Ngay']?.value = Helper.dMy(date);
                    _stateManager.notifyListeners();
                  }
                },
                child: Text(re.cell.value).medium,
              );
            },
          ),
          DataGridColumn(title: ['Mã TK', 'MaTK'], width: 80, cellColor: CellColor.blue),
          DataGridColumn(title: ['Mô tả tài khoản', 'TenTK'], width: 290, cellColor: CellColor.blue),
          DataGridColumn(title: ['TC', 'TinhChat'], width: 50, isEdit: true),
          DataGridColumn(title: ['Đầu kỳ nợ', 'DKNo'], width: 100, isEdit: true, columnType: ColumnType.num),
          DataGridColumn(title: ['Đầu kỳ có', 'DKCo'], width: 100, isEdit: true, columnType: ColumnType.num),
        ],
      ).withPadding(all: 5),
    );
  }
}
