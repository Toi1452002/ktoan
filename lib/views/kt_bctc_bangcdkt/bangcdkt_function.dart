import 'package:flutter/material.dart';
import 'package:pm_ketoan/core/core.dart';
import 'package:pm_ketoan/data/repository/kt_bctc_repository.dart';
import 'package:trina_grid/trina_grid.dart';

class BangCDKTFunction {
  final _rp = BCTCRepository();

  Future<List<Map<String, dynamic>>> get() async{
    return _rp.getData(BCTCRepository.tmpCDKT);
  }

  Future<void> updateTM(TrinaGridOnChangedEvent event) async{
    if(event.column.field == "ThuyetMinh"){
      final maSo = event.row.cells['MaSo']?.value;
      await _rp.updateTM(BCTCRepository.tmpCDKT, event.value, maSo);
    }
  }

  Future<void> thucHien(String nam) async {
    final year = int.tryParse(nam) ?? DateTime.now().year;
    await _rp.khoiTaoVeKhong(BCTCRepository.tmpCDKT, year);
    await _rp.ghiNamTruoc(BCTCRepository.tmpCDKT, 'CDKT', year);

    if (await _rp.checkDKTK(year)) {
      await _rp.ghiSoNamNay(year,BCTCRepository.tmpCDKT);
      await _rp.tinhTongNhom(BCTCRepository.tmpCDKT, year);
    } else {
      CustomAlert.warning('Không có dữ liệu vì chưa chạy Bảng cân đối Tài khoản');
    }
  }

  Future<void> luuSo(String nam) async{
    final year = int.tryParse(nam) ?? DateTime.now().year;
    final result = await _rp.luuNamTruoc(BCTCRepository.tmpCDKT,'CDKT',year);
    if(result){
      CustomAlert.success('Lưu thành công');
    }
  }
}
