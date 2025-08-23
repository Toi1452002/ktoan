import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/core/core.dart';
import 'package:pm_ketoan/data/data.dart';
import 'package:trina_grid/trina_grid.dart';

import '../nx_phieunhap/phieunhap_view.dart';
import '../nx_phieuxuat/phieuxuat_view.dart';
import '../tc_phieuchi/phieuchi_view.dart';
import '../tc_phieuthu/phieuthu_view.dart';

class SoBanHangFunction {
  Future<List<Map<String, dynamic>>> loadKH() async {
    return await KhachHangRepository().getListKhach();
  }

  Future<void> loadData(TrinaGridStateManager state, DateTime tN, DateTime dN, String maKhach) async {
    final data = await CongNoRepository().getSoBanHang(tN: Helper.yMd(tN), dN: Helper.yMd(dN), maKhach: maKhach);
    state.removeAllRows();
    state.appendRows(
      data.map((e) {
        return TrinaRow(
          cells: {
            'null': TrinaCell(value: e['STT']),
            'Ngay': TrinaCell(value: e['Ngay']),
            'Phieu': TrinaCell(value: e['Phieu']),
            'TenHH': TrinaCell(value: e['TenHH']),
            'DVT': TrinaCell(value: e['DVT'] ?? ''),
            'SoLg': TrinaCell(value: e['SoLg']),
            'DonGia': TrinaCell(value: e['DonGia']),
            'No': TrinaCell(value: e['No']),
            'Co': TrinaCell(value: e['Co']),
          },
        );
      }).toList(),
    );
  }

  void showInfo(TrinaGridOnRowDoubleTapEvent event, WidgetRef ref, BuildContext context) {
    if (event.cell.column.field == 'Phieu') {
      final type = event.cell.value[0];
      final stt = event.row.cells['null']?.value;
      if (type == 'T') {
        PhieuThuView.show(context, stt: stt);
      } else if (type == 'C') {
        PhieuChiView.show(context, stt: stt);
      } else if (type == 'N') {
        PhieuNhapView.show(context, stt: stt);
      } else if (type == 'X') {
        PhieuXuatView.show(context, stt: stt);
      }
    }
  }

  Future<List<String>> getNo({DateTime? tN, DateTime? dN, required String maKhach}) async {
    final data = await CongNoRepository().getNoSoMuaHang(tN: Helper.yMd(tN), dN: Helper.yMd(dN), maKhach: maKhach);
    return [Helper.numFormat(data['DKy'])!, Helper.numFormat(data['CKy'])!];
  }
}
