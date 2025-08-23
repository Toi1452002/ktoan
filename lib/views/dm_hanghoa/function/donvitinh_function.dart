import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/application/application.dart';
import 'package:pm_ketoan/core/core.dart';
import 'package:trina_grid/trina_grid.dart';

class DonViTinhFunction{
  void onChangedData(TrinaGridOnChangedEvent e, TrinaGridStateManager state, WidgetRef ref) async{
    if(e.row.cells['dl']?.value ==''){
     final result  = await  ref.read(donViTinhProvider.notifier).add(e.value);
     if(result!=0){
       state.appendNewRows();
       state.rows[e.rowIdx].cells['dl']?.value = result;
     }
    }else{
      ref.read(donViTinhProvider.notifier).update(e.value,e.row.cells['dl']?.value);
    }
  }

  void onTapDelete(WidgetRef ref, int id, TrinaColumnRendererContext re) async{
    final btn =await CustomAlert.question('Có chắc muốn xóa?',title: 'ĐVT');
    if(btn == AlertButton.okButton){
      final result = await ref.read(donViTinhProvider.notifier).delete(id);
      if(result) re.stateManager.removeCurrentRow();
    }
  }
}