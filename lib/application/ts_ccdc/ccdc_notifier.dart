import 'package:flutter/material.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/core/core.dart';
import 'package:pm_ketoan/data/data.dart';
import 'package:string_validator/string_validator.dart';
import 'package:trina_grid/trina_grid.dart';

import '../../views/dm_hanghoa/thong_tin_hang_hoa_view.dart';

class CCDCNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  CCDCNotifier() : super([]){
    getCCDC();
  }

  final _rp = CCDCRepository();

  Future<void> getCCDC() async {
    state = await _rp.get();
  }
  Future<List<Map<String, dynamic>>> getListHH() async {
    return await HangHoaRepository().getData(columns: ['MaHH', 'TenHH']);
  }
  Future<List<Map<String, dynamic>>> getListTKChiPhi() async {
    return await BangTaiKhoanRepository().getTKChiPhi();
  }
  Future<List<Map<String, dynamic>>> getListHaoMon() async {
    return await BangTaiKhoanRepository().getTKHaoMon();
  }
  Future<void> delete(int id, TrinaColumnRendererContext event) async {
    final btn = await CustomAlert.question('Có chắc muốn xóa');
    if (btn == AlertButton.okButton) {
      final result = await _rp.delete(id);
      if (result) {
        event.stateManager.removeCurrentRow();
      }
    }
  }

  Future<void> onChangedMaHH(String maHH, TrinaColumnRendererContext event) async {
    final hHoa = await HangHoaRepository().getHangHoa(maHH, columns: ['ID', 'TenHH', 'GiaMua']);
    final id = event.row.cells['dl']?.value;
    if (id == '') {
      final result = await _rp.add(hHoa['ID'], hHoa['GiaMua']);
      if (result != 0) {
        getCCDC();
      }
    } else {
      final result = await _rp.updateMaHH(id, hHoa['ID'], hHoa['GiaMua']);
      if (result) {
        getCCDC();
      }
    }
  }
  Future<DateTime?> getTNgay() async {
    final data = await _rp.getTNgay();
    if (data == null) {
      return null;
    }
    return toDate(data);
  }

  Future<void> onChangedTKChiPhi(String val, TrinaColumnRendererContext event) async {
    final id = event.row.cells['dl']?.value;
    if (id == '') {
      CustomAlert.warning('Chưa chọn mã dc');
    } else {
      await _rp.updateTKChiPhi(val, id);
    }
  }

  Future<void> onChangedTKHaoMon(String val, TrinaColumnRendererContext event) async {
    final id = event.row.cells['dl']?.value;
    if (id == '') {
      CustomAlert.warning('Chưa chọn mã dc');
    } else {
      await _rp.updateTKHaoMon(val, id);
    }
  }
  Future<void> onChanged(TrinaGridOnChangedEvent event) async {
    final id = event.row.cells['dl']?.value;
    var value = event.value;
    if (id == '') {
      CustomAlert.warning('Chưa chọn mã dc');
    } else {
      if (['NgayMua', 'NgaySD'].contains(event.column.field)) {
        final x = Helper.strToDate(event.value);
        value = Helper.yMd(Helper.strToDate(event.value));
        if (x == null || !isDate(x.toString())) {
          event.cell.value = '';
          CustomAlert.error('Ngày không hợp lệ');
          return;
        }
      }
      final result = await _rp.updateCell(event.column.field, value, id);
      if (result) {
        if (event.column.field == 'SoNamPB') {
          getCCDC();
        }
      }
    }
  }

  Future<void> onThucHien(DateTime dN) async {
    try {
      List<Map<String, dynamic>> map = [];
      final data = await _rp.get();
      for (var x in data) {
        final thangSD = (DateTime(dN.year, dN.month, 1).difference(toDate(x['NgaySD'])!).inDays / 30).round() + 1;
        var luyKe;
        if (x['SoThangPB'] == 0) {
          luyKe = x['LuyKe'];
        } else {
          luyKe = toDouble((x['GiaTri'] / x['SoThangPB'] * thangSD).toString()).round();
        }

        final gtcl = x['GiaTri'] - luyKe;
        map.add({
          // 'GiaTriKhauHao': gtkh,
          'LuyKe': luyKe > x['GiaTri'] ? x['GiaTri'] : luyKe,
          'GiaTriConLai': gtcl < 0 ? 0 : gtcl,
          'ID': x['ID'],
        });
      }
      final result = await _rp.thucHien(map);
      if (result) {
        getCCDC();
      }
    } catch (e) {
      CustomAlert.error(e.toString());
    }
  }
  void showHangHoa(String maHH, BuildContext context)async{
    final x = await HangHoaRepository().getHangHoa(maHH);
    final hh = HangHoaModel.fromMap(x);
    ThongTinHangHoaView.show(context,hangHoa: hh,noUD: true);
  }
}