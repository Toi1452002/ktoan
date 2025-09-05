import 'package:pm_ketoan/core/core.dart';
import 'package:pm_ketoan/widgets/data_grid/data_grid.dart';
import 'package:pm_ketoan/widgets/dialog_windows/dialog_funtion.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trina_grid/trina_grid.dart';
import 'package:flutter/material.dart' as mt;

import 'daukykhachhang_function.dart';

class DauKyKhachHangView extends ConsumerStatefulWidget {
  static const title = "Đầu kỳ khách hàng";
  static const name = "Nợ đầu kỳ";

  static void show(BuildContext context) {
    showCustomDialog(context, title: title.toUpperCase(), width: 680, height: 600, child: DauKyKhachHangView());
  }

  const DauKyKhachHangView({super.key});

  @override
  DauKyKhachHangViewState createState() => DauKyKhachHangViewState();
}

class DauKyKhachHangViewState extends ConsumerState<DauKyKhachHangView> {
  late TrinaGridStateManager _stateManager;
  List<Map<String, dynamic>> data = [];

  final fc = DauKyKhachHangFunction();

  @override
  void initState() {
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
              'MaKhach': TrinaCell(value: e['MaKhach']),
              'TenKH': TrinaCell(value: e['TenKH']),
              'SoDuNo': TrinaCell(value: e['SoDuNo'] ?? 0),
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
          DataGridColumn(title: ['Mã khách hàng', 'MaKhach'], width: 140, textStyle: ColumnTextStyle.blue()),
          DataGridColumn(title: ['Tên khách hàng', 'TenKH'], width: 300, textStyle: ColumnTextStyle.blue()),
          DataGridColumn(
            title: ['Số đầu kỳ', 'SoDuNo'],
            width: 100,
            columnType: ColumnType.num,
            isEdit: true,
            showFooter: true,
          ),
        ],
      ).withPadding(all: 5),
    );
  }
}
