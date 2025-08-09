import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/application/hanghoa/hanghoa_provider.dart';
import 'package:pm_ketoan/core/core.dart';
import 'package:flutter/material.dart';
import 'package:pm_ketoan/views/hanghoa/thong_tin_hang_hoa_view.dart';
import 'package:trina_grid/trina_grid.dart';


class HangHoaFunction extends ViewFunction{


  @override
  void showInfo(BuildContext context) {
    ThongTinHangHoaView.show(context);
    super.showInfo(context);
  }

  @override
  void showFilter(WidgetRef ref) {
    final x = ref.watch(hangHoaHideFilterProvider);
    ref.read(hangHoaHideFilterProvider.notifier).state = !x;
    super.showFilter(ref);
  }

  void filterTheoDoi(WidgetRef ref, int td) {
    ref.read(hangHoaProvider.notifier).getListHangHoa(td: td);
    ref.read(hangHoaTheoDoiProvider.notifier).state = td;
  }


  void showEdit(TrinaGridOnRowDoubleTapEvent row, BuildContext context, WidgetRef ref) async{
    if(row.cell.column.field == 'MaHH'){
      final maHH = row.cell.value;
      final hangHoa = await ref.read(hangHoaProvider.notifier).getHangHoa(maHH);
      if(context.mounted){
        ThongTinHangHoaView.show(context,hangHoa: hangHoa);
      }
    }
  }


  void delete(int id, TrinaColumnRendererContext re, WidgetRef ref) async{
    final btn =await CustomAlert.question('Có chắc muốn xóa?',title: 'Hàng hóa');
    if(btn == AlertButton.okButton){
      final result = await ref.read(hangHoaProvider.notifier).delete(id);
      if(result) re.stateManager.removeCurrentRow();
    }

  }


}
