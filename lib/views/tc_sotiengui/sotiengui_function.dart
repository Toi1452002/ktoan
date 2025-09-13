import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/core/core.dart';
import 'package:pm_ketoan/data/data.dart';
import 'package:pm_ketoan/views/views.dart';
import 'package:trina_grid/trina_grid.dart';

class SoTienGuiFunction {
  Future<List<Map<String, dynamic>>> get({DateTime? tN, DateTime? dN}) async {
    return await SoTienRepository().getSoTienGui(tN: Helper.yMd(tN), dN: Helper.yMd(dN));
  }

  Future<List<String>> getTon({DateTime? tN, DateTime? dN}) async {
    final data = await SoTienRepository().getTonSoTienGui(tN: Helper.yMd(tN), dN: Helper.yMd(dN));
    return [Helper.numFormat(data['DKy'])!, Helper.numFormat(data['CKy'])!];
  }

  void showInfo(TrinaGridOnRowDoubleTapEvent event, WidgetRef ref, BuildContext context) {
    if (event.cell.column.field == 'Phieu') {
      final type = event.cell.value[0];
      final stt = event.row.cells['null']?.value;
      if (type == 'T') {
        PhieuThuView.show(context, phieu: event.cell.value);
      } else if (type == 'C') {
        PhieuChiView.show(context, phieu: event.cell.value);
      } else if (type == 'N') {
        PhieuNhapView.show(context, phieu: event.cell.value);
      } else if (type == 'X') {
        PhieuXuatView.show(context, phieu: event.cell.value);
      }
    }
  }
}
