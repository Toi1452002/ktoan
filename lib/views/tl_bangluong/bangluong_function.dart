import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/application/application.dart';
import 'package:pm_ketoan/views/dm_nhanvien/thongtinnhanvien_view.dart';
import 'package:pm_ketoan/views/tl_bangluong/pcgt_view.dart';
import 'package:string_validator/string_validator.dart';
import 'package:trina_grid/trina_grid.dart';

import '../../core/core.dart';
import '../../data/data.dart';

class BangLuongFunction {
  Future<List<NhanVienModel>> getListNV() async {
    final data = await NhanVienRepository().getList(td: true);
    return data.map((e) => NhanVienModel.fromMap(e)).toList();
  }

  Future<void> onChangedMaNV(
    WidgetRef ref,
    TrinaColumnRendererContext re,
    int thang,
    String nam,
  ) async {
    final id = re.row.cells['dl']?.value;
    if (id == '') {
      final date = DateTime(int.parse(nam), thang + 1, 0).day;
      final result = await ref
          .read(bangLuongProvider.notifier)
          .addMaNV(re.cell.value, Helper.yMd(DateTime(int.parse(nam), thang, date)));
      if (result != 0) {
        ref.read(bangLuongProvider.notifier).getData(thang: thang.toString(), nam: nam);
        re.row.cells['dl']?.value = result;
      }
    } else {
      final result = await ref.read(bangLuongProvider.notifier).updateMaNV(id, re.cell.value);
      if (result) {
        ref.read(bangLuongProvider.notifier).getData(thang: thang.toString(), nam: nam);
      }
    }
  }

  Future<void> delete(WidgetRef ref, int id, TrinaColumnRendererContext re) async {
    final btn = await CustomAlert.question('Có chắc muốn xóa');
    if (btn == AlertButton.okButton) {
      final result = await ref.read(bangLuongProvider.notifier).delete(id);
      if (result) {
        re.stateManager.removeCurrentRow();
      }
    }
  }

  Future<void> onChangedCell(WidgetRef ref, TrinaGridOnChangedEvent re, int thang, String nam) async {
    final id = re.row.cells['dl']?.value;
    final field = re.column.field;
    if (id == '') {
      CustomAlert.warning('Chọn mã nhân viên');
      re.row.cells[field]?.value = 0;
    } else {
      bool result = false;
      if (field == "LuongCoBan") {
        result = await ref.read(bangLuongProvider.notifier).updateLuongCB(id, toDouble(re.value.toString()));
      }
      if (field == "NgayCong") {
        result = await ref.read(bangLuongProvider.notifier).updateNgayCong(id, toDouble(re.value.toString()));
      }
      if (field == "TamUng") {
        result = await ref.read(bangLuongProvider.notifier).updateTamUng(id, toDouble(re.value.toString()));
      }
      if (result) {
        ref.read(bangLuongProvider.notifier).getData(thang: thang.toString(), nam: nam);
      }
    }
  }

  void showNhanVien(BuildContext context, WidgetRef ref, String maNV) async {
    final x = await NhanVienRepository().getNV(maNV);
    final nv = NhanVienModel.fromMap(x);
    ThongTinNhanVienView.show(context, nv: nv, udMa: false);
  }

  void showPCGT(BuildContext context, TrinaGridOnRowDoubleTapEvent event){
    final field = event.cell.column.field;
    if(['PC1','PC2','GT1','GT2'].contains(field)){
      final maNV = event.row.cells['MaNV']?.value;
      PCGTView.show(context, maNV, field);
    }
  }
}
