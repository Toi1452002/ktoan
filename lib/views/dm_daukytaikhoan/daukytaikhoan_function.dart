import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:intl/intl.dart';
import 'package:pm_ketoan/core/core.dart';
import 'package:pm_ketoan/data/data.dart';
import 'package:string_validator/string_validator.dart';
import 'package:trina_grid/trina_grid.dart';

class DauKyBTKFunction {
  Future<List<Map<String, dynamic>>> get() async {
    return await DauKyRepository().getDauKyBTK();
  }

  Future<bool> isCapNhat(TrinaGridStateManager state, DateTime date) async {
    // state.setFilter((row) {
    //   return row.cells['DKCo']?.value != 0 || row.cells['DKNo']?.value != 0;
    // });
    final tmp = state.rows.where((row) => row.cells['DKCo']?.value != 0 || row.cells['DKNo']?.value != 0);
    final lst = tmp.map((e) {
      // final date = Helper.strToDate(e.cells['Ngay']!.value);

      return {
        'Thang': DateFormat('yyyy-MM').format(DateTime(date.year, date.month - 1)),
        'MaTK': e.cells['MaTK']?.value,
        'DKNo': toDouble(e.cells['DKNo']!.value.toString()),
        'DKCo': toDouble(e.cells['DKCo']!.value.toString()),
        // 'Ngay': Helper.yMd(e.cells['Ngay']?.value),
      };
    }).toList();
    await DauKyRepository().updateDauKyBTK(lst);
    CustomAlert.success('Lưu đầu kỳ thành công');
    return true;
  }
}
