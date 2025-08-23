import 'package:pm_ketoan/data/data.dart';
import 'package:trina_grid/trina_grid.dart';

class ThongTinDoanhNghiepFunction {
  Future<void> getData(TrinaGridStateManager state) async {
    final data = await ThongTinDoanhNghiepRepository().getList();
    state.removeAllRows();
    state.appendRows(
      data
          .map(
            (e) => TrinaRow(
              cells: {
                'null': TrinaCell(value: e['ID']),
                'TieuDe': TrinaCell(value: e['TieuDe']),
                'NoiDung': TrinaCell(value: e['NoiDung']),
              },
            ),
          )
          .toList(),
    );
  }

  Future<void> onChanged(TrinaGridOnChangedEvent event) async {
    await ThongTinDoanhNghiepRepository().updateCell(event.value, event.row.cells['null']?.value);
  }
}
