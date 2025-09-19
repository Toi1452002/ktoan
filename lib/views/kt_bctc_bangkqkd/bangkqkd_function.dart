import 'package:trina_grid/trina_grid.dart';

import '../../core/core.dart';
import '../../data/data.dart';

class BangKQKDFunction{
  final _rp = BCTCRepository();

  Future<List<Map<String, dynamic>>> get() async{
    return _rp.getData(BCTCRepository.tmpKQKD);
  }

  Future<void> thucHien(String nam) async {
    final year = int.tryParse(nam) ?? DateTime.now().year;
    await _rp.khoiTaoVeKhong(BCTCRepository.tmpKQKD, year);
    await _rp.ghiNamTruoc(BCTCRepository.tmpKQKD, 'KQKD', year);

    if (await _rp.checkDKTK(year)) {
      await _rp.ghiSoNamNay(year,BCTCRepository.tmpKQKD);
      await _rp.tinhTongNhom(BCTCRepository.tmpKQKD, year);
    } else {
      CustomAlert.warning('Không có dữ liệu vì chưa chạy Bảng cân đối Tài khoản');
    }
  }

  Future<void> luuSo(String nam) async{
    final year = int.tryParse(nam) ?? DateTime.now().year;
    final result = await _rp.luuNamTruoc(BCTCRepository.tmpKQKD,'KQKD',year);
    if(result){
      CustomAlert.success('Lưu thành công');
    }
  }
  Future<void> updateTM(TrinaGridOnChangedEvent event) async{
    if(event.column.field == "ThuyetMinh"){
      final maSo = event.row.cells['MaSo']?.value;
      await _rp.updateTM(BCTCRepository.tmpKQKD, event.value, maSo);
    }
  }
}