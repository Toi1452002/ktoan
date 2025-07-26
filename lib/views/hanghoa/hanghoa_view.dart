import 'package:pm_ketoan/application/application.dart';
import 'package:pm_ketoan/views/hanghoa/function/hanghoa_function.dart';
import 'package:pm_ketoan/widgets/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trina_grid/trina_grid.dart';

class HangHoaView extends ConsumerWidget {
  HangHoaView({super.key});

  static const name = 'Hàng hóa';

  static void show(BuildContext context) {
    showCustomDialog(
      context,
      title: name.toUpperCase(),
      width: 1220,
      height: 600,
      child: HangHoaView(),
      onClose: () {},
    );
  }

  final HangHoaFunction fc = HangHoaFunction();
  late TrinaGridStateManager _stateManager;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(hangHoaProvider, (context, state) {
      _stateManager.removeAllRows();
      if (state.isNotEmpty) {
        _stateManager.appendRows(
          state
              .map(
                (e) => TrinaRow(
                  cells: {
                    'null': TrinaCell(value: e['ID']),
                    'dl': TrinaCell(value: e['ID']),
                    'MaHH': TrinaCell(value: e['MaHH']),
                    'TenHH': TrinaCell(value: e['TenHH']),
                    'DVT': TrinaCell(value: e['DVT'] ?? ''),
                    'GiaMua': TrinaCell(value: e['GiaMua']),
                    'GiaBan': TrinaCell(value: e['GiaBan']),
                    'LoaiHang': TrinaCell(value: e['LoaiHang'] ?? ''),
                    'NhomHang': TrinaCell(value: e['NhomHang'] ?? ''),
                    'MaNC': TrinaCell(value: e['MaNC'] ?? ''),
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
                value: ref.watch(hangHoaTheoDoiProvider),
                items: [
                  ComboboxItem(value: 1, text: ['Danh sách hàng hóa đang theo dõi']),
                  ComboboxItem(value: 0, text: ['Danh sách hàng hóa ngưng theo dõi']),
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
          onLoaded: (e) => _stateManager = e.stateManager,
          hideFilter: ref.watch(hangHoaHideFilterProvider),
          onRowDoubleTap: (row) => fc.showEdit(row, context, ref),
          columns: [
            DataGridColumn(title: ['', 'null'], width: 25, render: TypeRender.numIndex),
            DataGridColumn(
              title: ['', 'dl'],
              width: 25,
              render: TypeRender.delete,
              onTapDelete: (val, re) => fc.delete(val, re!, ref),
            ),
            DataGridColumn(title: ['Mã', 'MaHH'], width: 135, cellColor: CellColor.red),
            DataGridColumn(title: ['Tên vật tư-hàng hóa', 'TenHH'], width: 300),
            DataGridColumn(title: ['Đơn vị tính', 'DVT'], width: 110, columnAlign: ColumnAlign.center),
            DataGridColumn(title: ['Giá mua', 'GiaMua'], width: 140, columnType: ColumnType.num),
            DataGridColumn(title: ['Giá bán', 'GiaBan'], width: 140, columnType: ColumnType.num),
            DataGridColumn(title: ['Loại hàng', 'LoaiHang'], width: 100, columnAlign: ColumnAlign.center),
            DataGridColumn(title: ['Nhóm hàng', 'NhomHang'], width: 110, columnAlign: ColumnAlign.center),
            DataGridColumn(title: ['Nhà cung', 'MaNC'], width: 95, columnAlign: ColumnAlign.center),
          ],
        ),
      ),
    );
  }
}
