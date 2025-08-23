import 'package:pm_ketoan/core/core.dart';
import 'package:pm_ketoan/data/data.dart';
import 'package:trina_grid/trina_grid.dart';

class TongHopCongNoFunction {
  Future<void> loadData(DateTime date, TrinaGridStateManager state) async {
    final data = await CongNoRepository().getTongHopCongNo(Helper.yMd(date));
    state.removeAllRows();
    state.appendRows(
      data
          .map(
            (e) => TrinaRow(
              cells: {
                'null': TrinaCell(value: ''),
                'MaKhach': TrinaCell(value: e['MaKhach']),
                'TenKH': TrinaCell(value: e['TenKH']),
                'PhaiThu': TrinaCell(value: e['PhaiThu']),
                'PhaiTra': TrinaCell(value: e['PhaiTra']),
              },
            ),
          )
          .toList(),
    );
  }
}
