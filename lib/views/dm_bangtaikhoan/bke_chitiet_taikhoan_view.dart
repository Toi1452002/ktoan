import 'package:pm_ketoan/data/data.dart';
import 'package:pm_ketoan/widgets/data_grid/data_grid.dart';
import 'package:pm_ketoan/widgets/dialog_windows/dialog_funtion.dart';
import 'package:pm_ketoan/widgets/widget_icon_button.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trina_grid/trina_grid.dart';

import '../views.dart';

class BangKeChiTietTaiKhoanView extends ConsumerStatefulWidget {
  const BangKeChiTietTaiKhoanView({super.key, required this.year, required this.maTK});

  final String year;
  final String maTK;

  static const name = "Bảng kê chi tiết tài khoản";

  static void show(BuildContext context, String year, String maTK) => showCustomDialog(
    context,
    title: name.toUpperCase(),
    width: 1100,
    height: 500,
    child: BangKeChiTietTaiKhoanView(year: year, maTK: maTK),
  );

  @override
  ConsumerState createState() => _BangKeChiTietTaiKhoanViewState();
}

class _BangKeChiTietTaiKhoanViewState extends ConsumerState<BangKeChiTietTaiKhoanView> {
  late TrinaGridStateManager stateManager;

  @override
  void initState() {
    onLoad();
    super.initState();
  }

  void onLoad() async {
    final data = await BangTaiKhoanRepository().getSoCTTK(widget.year, widget.maTK);
    stateManager.removeAllRows();
    if (data.isNotEmpty) {
      stateManager.appendRows(
        data
            .map(
              (e) => TrinaRow(
                cells: {
                  'null': TrinaCell(value: ''),
                  'Ngay': TrinaCell(value: e['Ngay']),
                  'SoCT': TrinaCell(value: e['SoCT']),
                  'NgayCT': TrinaCell(value: e['NgayCT']),
                  'DienGiai': TrinaCell(value: e['DienGiai'] ?? ""),
                  'TK': TrinaCell(value: e['TK'] ?? ''),
                  'PSNo': TrinaCell(value: e['PSNo']),
                  'PSCo': TrinaCell(value: e['PSCo']),
                  'SDNo': TrinaCell(value: ''),
                  'SDCo': TrinaCell(value: ''),
                },
              ),
            )
            .toList(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      headers: [
        AppBar(
          padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
          leading: [
            WidgetIconButton(type: IconType.print),
            WidgetIconButton(type: IconType.excel),
          ],
        ),
      ],
      child: DataGrid(
        onLoaded: (e) => stateManager = e.stateManager,
        onRowDoubleTap: (event) {
          if (event.cell.column.field == 'SoCT') {
            final type = event.cell.value[0];
            // final phieu = event.row.cells['null']?.value;
            if (type == 'T') {
              PhieuThuView.show(context, phieu: event.cell.value);
            } else if (type == 'C') {
              PhieuChiView.show(context, phieu: event.cell.value);
            } else if (type == 'N') {
              PhieuNhapView.show(context, phieu: event.cell.value);
            } else if (type == 'X') {
              PhieuXuatView.show(context, phieu: event.cell.value);
            }
          }
        },
        columns: [
          DataGridColumn(title: ['', 'null'], width: 25, render: TypeRender.numIndex),
          DataGridColumn(
            title: ['Ngày ghi sổ', 'Ngay'],
            width: 100,
            columnType: ColumnType.date,
            columnAlign: ColumnAlign.center,
          ),
          DataGridColumn(title: ['Số CT', 'SoCT'], width: 80, textStyle: ColumnTextStyle.red()),
          DataGridColumn(
            title: ['Ngày CT', 'NgayCT'],
            width: 100,
            columnType: ColumnType.date,
            columnAlign: ColumnAlign.center,
          ),
          DataGridColumn(title: ['Diễn Giải', 'DienGiai'], width: 300),
          DataGridColumn(title: ['TKDU', 'TK'], width: 70, columnAlign: ColumnAlign.center),
          DataGridColumn(title: ['PS Nợ', 'PSNo'], width: 100, columnType: ColumnType.num),
          DataGridColumn(title: ['PS Có', 'PSCo'], width: 100, columnType: ColumnType.num),
          DataGridColumn(title: ['Số dư nợ', 'SDNo'], width: 100),
          DataGridColumn(title: ['Số dư có', 'SDCo'], width: 100),
        ],
      ).withPadding(all: 5),
    );
  }
}
