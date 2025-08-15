import 'package:pm_ketoan/views/daukyhanghoa/daukyhanghoa_function.dart';
import 'package:pm_ketoan/widgets/data_grid/data_grid.dart';
import 'package:pm_ketoan/widgets/dialog_windows/dialog_funtion.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trina_grid/trina_grid.dart';
import 'package:flutter/material.dart' as mt;

import '../../core/utils/helper.dart';

class DauKyHangHoaView extends ConsumerStatefulWidget {
  const DauKyHangHoaView({super.key});

  static const title = "Đầu kỳ hàng hóa";
  static const name = "Tồn đầu kỳ";

  static void show(BuildContext context) {
    showCustomDialog(context, title: title.toUpperCase(), width: 720, height: 600, child: DauKyHangHoaView());
  }

  @override
  ConsumerState createState() => _DauKyHangHoaViewState();
}

class _DauKyHangHoaViewState extends ConsumerState<DauKyHangHoaView> {
  late TrinaGridStateManager _stateManager;
  List<Map<String, dynamic>> data = [];
  final fc = DauKyHangHoaFunction();

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
              'null': TrinaCell(value: e['ItemID']),
              'Ngay': TrinaCell(value: e['Ngay']),
              'MaHH': TrinaCell(value: e['MaHH']),
              'TenHH': TrinaCell(value: e['TenHH']),
              'SoTon': TrinaCell(value: e['SoTon'] ?? 0),
              'GiaVon': TrinaCell(value: e['GiaVon'] ?? 0),
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
          DataGridColumn(title: ['Mã hàng', 'MaHH'], width: 100, cellColor: CellColor.blue),
          DataGridColumn(title: ['Tên hàng', 'TenHH'], width: 290, cellColor: CellColor.blue),
          DataGridColumn(title: ['Số lượng', 'SoTon'], width: 90, isEdit: true, columnType: ColumnType.num),
          DataGridColumn(title: ['Giá vốn', 'GiaVon'], width: 100, isEdit: true, columnType: ColumnType.num),
        ],
      ).withPadding(all: 5),
    );
  }
}
