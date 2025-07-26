import 'package:pm_ketoan/data/repository/base_repository.dart';
import 'package:pm_ketoan/data/repository/repository.dart';

class KhachHangRepository {
  static const name = "TDM_KhachHang";
  final _baseData = BaseRepository();

  Future<List<Map<String, dynamic>>> getData({int td = 1}) async {
    return await _baseData.getListMap(name, where: td == 2 ? null : 'TheoDoi = ?', whereArgs: td == 2 ? null : [td]);
  }

  Future<int> add(Map<String, dynamic> map) async {
    return await _baseData.addMap(name, map);
  }

  Future<bool> update(Map<String, dynamic> map, String maKH) async {
    return await _baseData.updateMap(name, map,where: "MaKhach = ?", whereArgs: [maKH] );
  }

  Future<bool> delete(String maKH) async {
    return await _baseData.delete(name, where: "MaKhach = ?", whereArgs:  [maKH]);
  }

  Future<Map<String, dynamic>> getKhach(String maKhach) async{
    return await _baseData.getMap(name,where: "MaKhach = ?", whereArgs: [maKhach]);
  }
}
