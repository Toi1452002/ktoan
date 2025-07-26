import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/application/application.dart';
import 'package:pm_ketoan/views/khachhang/function/khachhang_function.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:trina_grid/trina_grid.dart';

import '../../widgets/widgets.dart';

class KhachHangView extends ConsumerWidget {
  KhachHangView({super.key});

  static const name = "Khách hàng";

  static void show(BuildContext context) {
    showCustomDialog(
      context,
      title: name.toUpperCase(),
      width: 1100,
      height: 600,
      child: KhachHangView(),
      onClose: () {},
    );
  }

  late TrinaGridStateManager _stateManager;
  final fc = KhachHangFunction();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(khachHangProvider, (context, state) {
      _stateManager.removeAllRows();
      if (state.isNotEmpty) {
        _stateManager.appendRows(
          state
              .map(
                (e) => TrinaRow(
                  cells: {
                    'null': TrinaCell(value: ''),
                    'dl': TrinaCell(value: e.MaKhach),
                    'MaKhach': TrinaCell(value: e.MaKhach),
                    'TenKH': TrinaCell(value: e.TenKH),
                    'DiaChi': TrinaCell(value: e.DiaChi),
                    'MST': TrinaCell(value: e.MST),
                    'DienThoai': TrinaCell(value: e.DienThoai),
                    'LoaiKH': TrinaCell(value: e.LoaiKH),
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
          padding: EdgeInsets.symmetric(horizontal: 5),
          leading: [
            WidgetIconButton(type: IconType.add, onPressed: () => fc.showInfo(context)),
            WidgetIconButton(type: IconType.print, onPressed: () {}),
            WidgetIconButton(type: IconType.excel, onPressed: () {}),
            WidgetIconButton(type: IconType.filter, onPressed: () => fc.showFilter(ref)),
          ],
          trailing: [
            SizedBox(
              width: 300,
              child: Combobox(
                value: ref.watch(khachHangTheoDoiProvider),
                items: [
                  ComboboxItem(value: 1, text: ['Danh sách khách hàng đang theo dõi']),
                  ComboboxItem(value: 0, text: ['Danh sách khách hàng ngưng theo dõi']),
                  ComboboxItem(value: 2, text: ['Tất cả']),
                ],
                onChanged: (val) => fc.filterTheoDoi(ref, val),
              ),
            ),
          ],
        ),
      ],
      child: Padding(
        padding: EdgeInsets.all(5),
        child: DataGrid(
          hideFilter: ref.watch(khachHangHideFilterProvider),
          onLoaded: (e) => _stateManager = e.stateManager,
          onRowDoubleTap: (e) => fc.onShowEdit(context, ref, e),
          columns: [
            DataGridColumn(title: ['', 'null'], width: 25, render: TypeRender.numIndex),
            DataGridColumn(
              title: ['', 'dl'],
              width: 25,
              render: TypeRender.delete,
              onTapDelete: (val, e) => fc.delete(val, e!, ref),
            ),
            DataGridColumn(title: ['Mã KH', 'MaKhach'], width: 120, cellColor: CellColor.red),
            DataGridColumn(title: ['Tên khách hàng', 'TenKH'], width: 300),
            DataGridColumn(title: ['Địa chỉ', 'DiaChi'], width: 250),
            DataGridColumn(title: ['MST', 'MST'], width: 120),
            DataGridColumn(title: ['Di động', 'DienThoai'], width: 120),
            DataGridColumn(title: ['Loại', 'LoaiKH'], width: 80, columnAlign: ColumnAlign.center),
          ],
        ),
      ),
    );
  }
}
