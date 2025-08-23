import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/core/core.dart';
import 'package:pm_ketoan/data/data.dart';
import 'package:trina_grid/trina_grid.dart';

import '../nx_phieunhap/phieunhap_view.dart';

class BangKeHangNhapFunction {
  Future<void> get(TrinaGridStateManager state,{DateTime? tN, DateTime? dN}) async {
    final data = await KhoHangRepository().getBKHangNhap(tN: Helper.yMd(tN), dN: Helper.yMd(dN));
    state.removeAllRows();
    state.appendRows(data.map((e)=>TrinaRow(cells: {
      'null':TrinaCell(value: e['STT']),
      'Ngay':TrinaCell(value: e['Ngay']),
      'Phieu':TrinaCell(value: e['Phieu']),
      'MaNX':TrinaCell(value: e['MaNX']),
      'MaKhach':TrinaCell(value: e['MaKhach']??''),
      'MaHH':TrinaCell(value: e['MaHH']??''),
      'TenHH':TrinaCell(value: e['TenHH']??''),
      'DVT':TrinaCell(value: e['DVT']??''),
      'SoLg':TrinaCell(value: e['SoLg']),
      'DonGia':TrinaCell(value: e['DonGia']),
      'ThanhTien':TrinaCell(value: e['ThanhTien']),
    })).toList());
  }

  void showInfo(TrinaGridOnRowDoubleTapEvent event, WidgetRef ref, BuildContext context) {
    if (event.cell.column.field == 'Phieu') {
      final stt = event.row.cells['null']?.value;
      PhieuNhapView.show(context, stt: stt);
    }
  }

}
