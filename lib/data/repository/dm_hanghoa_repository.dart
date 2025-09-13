import 'package:pm_ketoan/data/data.dart';

import 'z_base_repository.dart';

class HangHoaRepository {
  static const name = "TDM_HangHoa";
  static const view = "V_HangHoa";
  final _baseData = BaseRepository();

  Future<List<Map<String, dynamic>>> getData({int td = 1,List<String>? columns}) async {
    return await _baseData.getListMap(view, where: td == 2 ? null : 'TheoDoi = ?', whereArgs: td == 2 ? null : [td],columns: columns);
  }

  Future<int> add(Map<String, dynamic> map) async {
    return await _baseData.addMap(name, map);
  }

  Future<bool> update(Map<String, dynamic> map) async {
    return await _baseData.updateMap(name, map, where: 'ID = ?', whereArgs: [map['ID']]);
  }

  Future<bool> delete(int id) async {
    return await _baseData.delete(name, where: 'ID = ?', whereArgs: [id]);
  }

  Future<Map<String, dynamic>> getHangHoa(String ma,{List<String>? columns}) async {
    return _baseData.getMap(name, where: "MaHH = ?", whereArgs: [ma],columns: columns);
  }

  Future<List<Map<String, dynamic>>> getLoaiHang() async {
    return await _baseData.getListMap('TDM_LoaiHang');
  }
}
