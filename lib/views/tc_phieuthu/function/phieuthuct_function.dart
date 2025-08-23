import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:string_validator/string_validator.dart';
import 'package:trina_grid/trina_grid.dart';

import '../../../application/application.dart';
import '../../../core/core.dart';

class PhieuThuCTFunction {
  Future<void> delete(int id, TrinaColumnRendererContext event, WidgetRef ref) async {
    final btn = await CustomAlert.question('Có chắc muốn xóa?');
    if (btn == AlertButton.okButton) {
      final result = await ref.read(phieuThuCTProvider.notifier).delete(id);
      if (result) {
        event.stateManager.removeCurrentRow();
      }
    }
  }

  Future<void> onChangedCell(TrinaGridOnChangedEvent event, WidgetRef ref, int maID,TrinaGridStateManager state) async {
    final id = event.row.cells['dl']?.value;
    final field = event.column.field;

    if (id == '') {
      int id = 0;
      //Insert
      if (field == 'DienGiai') {
        id = await ref.read(phieuThuCTProvider.notifier).addNoiDung(event.value, maID);
      }
      if (field == 'SoTien') {
        id = await ref.read(phieuThuCTProvider.notifier).addSoTien(toDouble(event.value.toString()), maID);
      }
      event.row.cells['dl']?.value = id;
      if (id != 0) state.appendNewRows();
    } else {
      //update
      if (field == 'DienGiai') {
        await ref.read(phieuThuCTProvider.notifier).updateNoiDung(event.value, id);
      }
      if (field == 'SoTien') {
        await ref.read(phieuThuCTProvider.notifier).updateSoTien(toDouble(event.value.toString()), id);
      }
    }
  }
}
