import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/application/application.dart';
import 'package:trina_grid/trina_grid.dart';

class DonViTinhFunction{
  void onChangedData(TrinaGridOnChangedEvent e, TrinaGridStateManager state, WidgetRef ref) async{
    if(e.row.cells['dl']?.value ==''){
      ref.read(donViTinhProvider.notifier).add(e.value);
      state.appendNewRows();
    }else{
      ref.read(donViTinhProvider.notifier).update(e.value,e.row.cells['dl']?.value);
    }
  }
}