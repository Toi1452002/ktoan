import 'package:pm_ketoan/core/core.dart';
import 'package:pm_ketoan/data/data.dart';
import 'package:trina_grid/trina_grid.dart';

class NhapXuatTonKhoFunction {
  Future<List<Map<String, dynamic>>> loadBTK() async {
    return await BangTaiKhoanRepository().getKho15();
  }

  Future<void> get(TrinaGridStateManager state,{DateTime? tN, DateTime? dN, String kho = ''}) async {
    final data = await KhoHangRepository().getNhapXuatTonKho(kho: kho, tN: Helper.yMd(tN), dN: Helper.yMd(dN));
    state.removeAllRows();
    state.appendRows(data.map((e)=>TrinaRow(cells: {
      'null': TrinaCell(value: ''),
      'TenHH': TrinaCell(value: e['TenHH']),
      'DVT': TrinaCell(value: e['DVT']),
      'SoTon': TrinaCell(value: e['SoTon']),
      'TienDauKy': TrinaCell(value: e['TienDauKy']),
      'SoLgN': TrinaCell(value: e['SoLgN']),
      'TienNhap': TrinaCell(value: e['TienNhap']),
      'SoLgX': TrinaCell(value: e['SoLgX']),
      'DonGiaXuat': TrinaCell(value: e['DonGiaXuat']),
      'TienXuat': TrinaCell(value: e['TienXuat']),
      'SoLgConLai': TrinaCell(value: e['SoLgConLai']),
      'TienConTai': TrinaCell(value: e['TienConTai']),
    })).toList());
  }
}
