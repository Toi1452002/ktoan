import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/application/application.dart';
import 'package:trina_grid/trina_grid.dart';

import '../../core/core.dart';

class BangTaiKhoanFunction{
  void onTapDelete(WidgetRef ref, int id, TrinaColumnRendererContext re) async{
    final btn =await CustomAlert.question('Có chắc muốn xóa?',title: 'BTK');
    if(btn == AlertButton.okButton){
      final result = await ref.read(bangTaiKhoanProvider.notifier).delete(id);
      if(result) re.stateManager.removeCurrentRow();
    }
  }

  void onChange(TrinaGridOnChangedEvent e, WidgetRef ref, TrinaGridStateManager state) async{
    final field = e.column.field;
    if(e.row.cells['dl']?.value ==''){
      final result  = await  ref.read(bangTaiKhoanProvider.notifier).add({
        field: e.value
      });
      if(result!=0){
        state.appendNewRows();
        state.rows[e.rowIdx].cells['dl']?.value = result;
      }
    }else{
      if(e.column.field == "MAXL"){
        state.notifyListeners();
      }
      ref.read(bangTaiKhoanProvider.notifier).update(
          {
            'ID': e.row.cells['dl']?.value,
            field: e.value
          }
      );
    }
  }
}