import 'package:pm_ketoan/core/core.dart';
import 'package:pm_ketoan/data/repository/base_repository.dart';
import 'package:pm_ketoan/data/repository/repository.dart';

class KhachHangRepository {
  static const name = "TDM_KhachHang";
  final _baseData = BaseRepository();

  Future<List<Map<String, dynamic>>> getData({int td = 1}) async {
    final rp = await _baseData.getListMap(
      name,
      where: td == 2 ? null : 'TheoDoi = ?',
      whereArgs: td == 2 ? null : [td],
    );
    if (rp.status == ResponseType.success) {
      return rp.data;
    } else {
      print(rp.message);
      return [];
    }
  }

  Future<int> add(Map<String, dynamic> map) async {
    final rp = await _baseData.addMap(name, map);
    if (rp.status == ResponseType.success) {
      return rp.data;
    } else {
     errorSql(rp.message);
      return 0;
    }
  }

  Future<bool> update(Map<String, dynamic> map, String maKH) async {
    final rp = await _baseData.updateMap(name, map, where: "MaKhach = ?", whereArgs: [maKH]);
    if (rp.status == ResponseType.success) {
      return true;
    } else {
      print(rp.message);
      return false;
    }
  }

  Future<bool> delete(String maKH) async {
    final rp = await _baseData.delete(name, where: "MaKhach = ?", whereArgs: [maKH]);
    if (rp.status == ResponseType.success) {
      return true;
    } else {
      print(rp.message);
      return false;
    }
  }

  Future<Map<String, dynamic>> getKhach(String maKhach) async {
    return await _baseData.getMap(name, where: "MaKhach = ?", whereArgs: [maKhach]);
  }

  Future<List<Map<String, dynamic>>> getNhaCung() async {
    final rp = await _baseData.getListMap(name, where: "TheoDoi = ? AND LoaiKH IN (?,?)", whereArgs: [1, "NC", "CH"]);
    if (rp.status == ResponseType.success) {
      return rp.data;
    } else {
      print(rp.message);
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getListKhach() async {
    final rp = await _baseData.getListMap(name, where: "TheoDoi = ? AND LoaiKH IN (?,?)", whereArgs: [1, "KH", "CH"]);
    if (rp.status == ResponseType.success) {
      return rp.data;
    } else {
      CustomAlert.error(rp.message.toString());
      return [];
    }
  }
}
