import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trina_grid/trina_grid.dart';

import '../../core/utils/helper.dart';
import '../../data/data.dart';
import '../tc_phieuchi/phieuchi_view.dart';

class BangKePhieuChiFunction{
  Future<List<Map<String,  dynamic>>> get({DateTime?  tN, DateTime? dN}) async{
    return PhieuChiRepository().getBangKePhieuChi(tN: Helper.yMd(tN),dN: Helper.yMd(dN));
  }

  void onShowInfo(TrinaGridOnRowDoubleTapEvent event, BuildContext context,WidgetRef ref){
    if(event.cell.column.field == 'Phieu'){
      final phieu  =  event.row.cells['null']?.value;
      PhieuChiView.show(context,phieu: phieu);
    }
  }
}