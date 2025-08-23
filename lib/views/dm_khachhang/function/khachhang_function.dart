import 'package:flutter/material.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/application/application.dart';
import 'package:pm_ketoan/core/core.dart';
import 'package:trina_grid/trina_grid.dart';

import '../thong_tin_kh_view.dart';

class KhachHangFunction  {
  void filterTheoDoi(WidgetRef ref, int td) {
    ref.read(khachHangProvider.notifier).getListKhach(td: td);
    ref.read(khachHangTheoDoiProvider.notifier).state = td;
  }

  void showFilter(WidgetRef ref) {
    final state = ref.watch(khachHangHideFilterProvider);
    ref.read(khachHangHideFilterProvider.notifier).state = !state;
    // TODO: implement showFilter
  }

  void showInfo(BuildContext context) {
    ThongTinKHView.show(context);
  }

  void onShowEdit(BuildContext context, WidgetRef ref, TrinaGridOnRowDoubleTapEvent row) async {
    if(row.cell.column.field == "MaKhach"){
      final ma = row.cell.value;
      final khach = await ref.read(khachHangProvider.notifier).getKhach(ma);
      if(context.mounted) ThongTinKHView.show(context, khach: khach);
    }
  }

  void delete(String ma, TrinaColumnRendererContext re, WidgetRef ref) async{
    final btn =await CustomAlert.question('Có chắc muốn xóa?',title: 'Khách hàng');
    if(btn == AlertButton.okButton){
      final result = await ref.read(khachHangProvider.notifier).deleteKhach(ma);
      if(result) re.stateManager.removeCurrentRow();
    }

  }
}
