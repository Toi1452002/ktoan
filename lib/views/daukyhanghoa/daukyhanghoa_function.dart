import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:intl/intl.dart';
import 'package:pm_ketoan/core/core.dart';
import 'package:pm_ketoan/data/data.dart';
import 'package:string_validator/string_validator.dart';
import 'package:trina_grid/trina_grid.dart';

class DauKyHangHoaFunction {
  Future<List<Map<String, dynamic>>> get() async {
    return await DauKyRepository().getDauKyHangHoa();
  }

  Future<bool> isCapNhat(TrinaGridStateManager state) async {
    state.setFilter((row) {
      return row.cells['GiaVon']?.value != 0;
    });
    final btn = await CustomAlert.question('Danh sách trên sẽ được cập nhật vào SỔ ĐẦU KỲ');
    if (btn == AlertButton.okButton) {
      final lst = state.rows.map((e) {
        final date = Helper.strToDate(e.cells['Ngay']!.value);

        return {
          'Thang': DateFormat('yyyy-MM').format(DateTime(date!.year, date.month - 1)),
          'ItemID': e.cells['null']?.value,
          'SoTon': toDouble(e.cells['SoTon']!.value.toString()),
          'GiaVon': toDouble(e.cells['GiaVon']!.value.toString()),
          'Ngay': Helper.yMd(e.cells['Ngay']?.value),
        };
      }).toList();
      await DauKyRepository().updateDauKyHangHoa(lst);
      CustomAlert.success('Cập nhật thành công');
      return true;
    } else {
      return false;
    }
  }
}
