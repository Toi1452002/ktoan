import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/application/application.dart';
import 'package:pm_ketoan/views/dm_nhanvien/nhanvien_function.dart';
import 'package:pm_ketoan/widgets/data_grid/data_grid.dart';
import 'package:pm_ketoan/widgets/dialog_windows/dialog_funtion.dart';
import 'package:pm_ketoan/widgets/widget_icon_button.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:trina_grid/trina_grid.dart';

class NhanVienView extends ConsumerStatefulWidget {
  static const name = "Nhân viên";

  static void show(BuildContext context) =>
      showCustomDialog(context, title: name.toUpperCase(), width: 1030, height: 600, child: NhanVienView());

  const  NhanVienView({super.key});

  @override
  NhanVienViewState createState() => NhanVienViewState();
}

class NhanVienViewState extends ConsumerState<NhanVienView> {

  final fc = NhanVienFunction();
  late TrinaGridStateManager stateManager;
  bool hideFilter = true;
  @override
  Widget build(BuildContext context) {
    ref.listen(nhanVienProvider, (_, state) {
      stateManager.removeAllRows();
      if (state.isNotEmpty) {
        stateManager.appendRows(
          state
              .map(
                (e) =>
                TrinaRow(
                  cells: {
                    'null': TrinaCell(value: ''),
                    'dl': TrinaCell(value: e.ID),
                    'MaNV': TrinaCell(value: e.MaNV),
                    'HoTen': TrinaCell(value: e.HoTen),
                    'Phai': TrinaCell(value: e.Phai ? 'Nữ' : 'Nam'),
                    'NgaySinh': TrinaCell(value: e.NgaySinh),
                    'DiaChi': TrinaCell(value: e.DiaChi),
                    'TrinhDo': TrinaCell(value: e.TrinhDo),
                    'ChuyenMon': TrinaCell(value: e.ChuyenMon),
                  },
                ),
          )
              .toList(),
        );
      }
    });

    return Scaffold(
      headers: [
        AppBar(
          padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
          leading: [
            WidgetIconButton(type: IconType.add, onPressed: () => fc.showInfo(context)),
            WidgetIconButton(type: IconType.filter, onPressed: () {
              setState(() {
                hideFilter =  !hideFilter;
              });
            }),
          ],
        ),
      ],
      child: DataGrid(
        hideFilter: hideFilter,
        onLoaded: (e) => stateManager = e.stateManager,
        onRowDoubleTap: (event) {
          if (event.cell.column.field == 'MaNV') {
            fc.showInfo(context, ref: ref, maNV: event.cell.value);
          }
        },
        columns: [
          DataGridColumn(title: ['', 'null'], width: 25, render: TypeRender.numIndex),
          DataGridColumn(title: ['', 'dl'],
              width: 25,
              render: TypeRender.delete,
              onTapDelete: (val, event) => fc.deleteNV(ref, val, event!)),
          DataGridColumn(title: ['Mã NV', 'MaNV'], width: 100, textColor: TextColor.red),
          DataGridColumn(title: ['Họ tên', 'HoTen'], width: 200),
          DataGridColumn(title: ['Phái', 'Phai'], width: 80),
          DataGridColumn(title: ['Ngày sinh', 'NgaySinh'], width: 110, columnType: ColumnType.date),
          DataGridColumn(title: ['Địa chỉ', 'DiaChi'], width: 200),
          DataGridColumn(title: ['Trình độ', 'TrinhDo'], width: 130),
          DataGridColumn(title: ['Chuyên môn', 'ChuyenMon'], width: 130),
        ],
      ).withPadding(all: 5),
    );
  }
}

