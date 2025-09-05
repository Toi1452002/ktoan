import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/application/application.dart';
import 'package:pm_ketoan/views/ht_danhsachnguoidung/danhsachnguoidung_function.dart';
import 'package:pm_ketoan/widgets/data_grid/data_grid.dart';
import 'package:pm_ketoan/widgets/dialog_windows/dialog_funtion.dart';
import 'package:pm_ketoan/widgets/widget_icon_button.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:trina_grid/trina_grid.dart';

class DanhSachNguoiDungView extends ConsumerWidget {
  DanhSachNguoiDungView({super.key});

  static const name = 'Danh sách người dùng';

  static void show(BuildContext context) =>
      showCustomDialog(context, title: name.toUpperCase(), width: 830, height: 600, child: DanhSachNguoiDungView());

  late TrinaGridStateManager stateManager;
  final fc = DanhSachNguoiDungFunction();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.read(userInfoProvider);
    ref.listen(userProvider, (_, state) {
      stateManager.removeAllRows();
      if (state.isNotEmpty) {
        stateManager.appendRows(
          state
              .map(
                (e) => TrinaRow(
                  cells: {
                    'null': TrinaCell(value: e.ID),
                    'dl': TrinaCell(value: e.ID),
                    'Username': TrinaCell(value: e.Username),
                    'HoTen': TrinaCell(value: e.HoTen),
                    'Email': TrinaCell(value: e.Email),
                    'DienThoai': TrinaCell(value: e.DienThoai),
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
            WidgetIconButton(
              type: IconType.add,
              enabled: userInfo?.ID == 1,
              onPressed: () => fc.showInfo(context, ref),
            ),
          ],
        ),
      ],
      child: DataGrid(
        onLoaded: (e) => stateManager = e.stateManager,
        onRowDoubleTap: (re) {
          if (re.cell.column.field == 'Username' && userInfo?.ID == 1) {
            fc.showInfo(context, ref, id: re.row.cells['null']?.value);
          } else if (re.cell.column.field == 'Username' && userInfo?.ID != 1 && re.cell.value == userInfo?.Username) {
            fc.showThayDoiTaiKhoan(context);
          }
        },
        columns: [
          DataGridColumn(title: ['', 'null'], width: 25, render: TypeRender.numIndex),
          DataGridColumn(
            title: ['', 'dl'],
            width: 25,
            render: TypeRender.delete,
            onTapDelete: (val, re) => fc.onTapDelete(val, re!, userInfo!.ID!, ref),
          ),
          DataGridColumn(title: ['Username', 'Username'], width: 150, textStyle: ColumnTextStyle.red()),
          DataGridColumn(title: ['Họ và tên', 'HoTen'], width: 200),
          DataGridColumn(title: ['Email', 'Email'], width: 200),
          DataGridColumn(title: ['Điện thoại', 'DienThoai'], width: 200),
        ],
      ).withPadding(all: 5),
    );
  }
}
