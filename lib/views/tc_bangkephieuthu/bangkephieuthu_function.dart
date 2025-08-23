import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/core/core.dart';
import 'package:pm_ketoan/data/data.dart';
import 'package:trina_grid/trina_grid.dart';

import '../tc_phieuthu/phieuthu_view.dart';

class BangKePhieuThuFunction{
  Future<List<Map<String,  dynamic>>> get({DateTime?  tN, DateTime? dN}) async{
    return PhieuThuRepository().getBangKePhieuThu(tN: Helper.yMd(tN),dN: Helper.yMd(dN));
  }

  void onShowInfo(TrinaGridOnRowDoubleTapEvent event, BuildContext context,WidgetRef ref){
    if(event.cell.column.field == 'Phieu'){
      final stt  =  event.row.cells['null']?.value;
      PhieuThuView.show(context,stt: stt);
    }
  }
}