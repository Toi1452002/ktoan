import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/application/bangchamcong/bangchamcong_provider.dart';
import 'package:pm_ketoan/core/core.dart';
import 'package:pm_ketoan/data/data.dart';
import 'package:string_validator/string_validator.dart';
import 'package:trina_grid/trina_grid.dart';

class BangChamCongFunction {
  Future<void> onChangedMaNV(WidgetRef ref, TrinaColumnRendererContext re, int thang, String nam) async {
    final id = re.row.cells['dl']?.value;
    if (id == '') {
      final date = DateTime(int.parse(nam), thang+1,  0).day;
      final result = await ref.read(bangChamCongProvider.notifier).addMaNV(re.cell.value,Helper.yMd(DateTime(int.parse(nam), thang,date)));
      if (result != 0) {
        ref.read(bangChamCongProvider.notifier).get(thang, nam);
        re.row.cells['dl']?.value = result;
      }
    } else {
      final result = await ref.read(bangChamCongProvider.notifier).updateMaNV(re.cell.value, id);
      if (result) {
        ref.read(bangChamCongProvider.notifier).get(thang, nam);
      }
    }
  }

  Future<void> onChangedN(WidgetRef ref, TrinaColumnRendererContext re, double gt, int thang, String nam) async {
    final id = re.row.cells['dl']?.value;
    if (id == '') {
      CustomAlert.warning('Chọn mã nhân viên');
    } else {
      final cong = re.row.cells['TongCong']?.value;
      final cTien = toDouble(cong.toString());
      final result1 = await ref
          .read(bangChamCongProvider.notifier)
          .updateConTien(cTien, id, re.column.field, re.cell.value);
      final result = await ref.read(bangChamCongProvider.notifier).updateN(re.cell.value, re.column.field, id);
      if (result && result1) {
        ref.read(bangChamCongProvider.notifier).get(thang, nam);
      }
    }
  }

  Future<List<NhanVienModel>> getListNV() async {
    final data = await NhanVienRepository().getList(td: true);
    return data.map((e) => NhanVienModel.fromMap(e)).toList();
  }

  Future<List<Map<String, dynamic>>> getListMaCC() async {
    return await BangChamCongRepository().getListMaCC();
  }

  Future<void> delete(WidgetRef ref, int id, TrinaColumnRendererContext re) async {
    final btn = await CustomAlert.question('Có chắc muốn xóa');
    if (btn == AlertButton.okButton) {
      final result = await ref.read(bangChamCongProvider.notifier).delete(id);
      if (result) {
        re.stateManager.removeCurrentRow();
      }
    }
  }

  String getThu(int thang, String nam, int ngay) {
    String thu = "";
    final data = DateTime(int.tryParse(nam) ?? DateTime.now().year, thang, ngay).weekday + 1;
    if (data == 8) {
      thu = "CN";
    } else {
      thu = "T$data";
    }
    return thu;
  }

  bool ktrNgayTonTai(int ngay, int thang, String nam) {
    final date = DateTime(int.parse(nam), thang + 1, 0).day;

    if (date >= ngay) {
      return true;
    } else {
      return false;
    }
  }
}
