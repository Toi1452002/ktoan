import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/data/data.dart';
import 'package:trina_grid/trina_grid.dart';

import '../nx_phieunhap/phieunhap_view.dart';

class BangKeHoaDonMuaVaoFunction {
  Future<List<Map<String, dynamic>>> get({String? thang, int? quy, int nam = 2000}) async {
    return await PhieuNhapRepository().getBKeHangNhap(thang: thang, quy: quy,nam: nam);
  }

  void onShowInfo(TrinaGridOnRowDoubleTapEvent event, BuildContext context,WidgetRef ref){
    if(event.cell.column.field == 'SoCT'){
      final phieu  =  event.row.cells['null']?.value;
      PhieuNhapView.show(context,phieu: phieu);
    }
  }
}
