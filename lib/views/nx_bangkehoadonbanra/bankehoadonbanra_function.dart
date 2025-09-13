import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/data/data.dart';
import 'package:trina_grid/trina_grid.dart';

import '../nx_phieuxuat/phieuxuat_view.dart';

class BangKeHoaDonBanRaFunction {
  Future<List<Map<String, dynamic>>> get({String? thang, int? quy, int nam = 2000}) async {
    return await PhieuXuatRepository().getBKePhieuXuat(thang: thang, quy: quy,nam: nam);
  }

  void onShowInfo(TrinaGridOnRowDoubleTapEvent event, BuildContext context,WidgetRef ref){
    if(event.cell.column.field == 'SoHD'){
      final phieu  =  event.row.cells['null']?.value;
      PhieuXuatView.show(context,phieu: phieu);
    }
  }
}
