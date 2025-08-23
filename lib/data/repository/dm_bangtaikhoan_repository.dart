import 'package:pm_ketoan/data/repository/z_base_repository.dart';

class BangTaiKhoanRepository {
  static const name = "TDM_BangTaiKhoan";

  final _baseData = BaseRepository();

  Future<List<Map<String, dynamic>>> getList() async {
    final rp = await _baseData.getListMap(name);
    if (rp.status == ResponseType.success) {
      return rp.data;
    } else {
      return [];
    }
  }

  Future<bool> delete(int id) async {
    final rp = await _baseData.delete(name, where: 'ID = ?', whereArgs: [id]);
    if (rp.status == ResponseType.success) {
      return true;
    } else {
      print(rp.message);
      return false;
    }
  }

  Future<int> add(Map<String, dynamic> map) async {
    final rp = await _baseData.addMap(name, map);
    if (rp.status == ResponseType.success) {
      return rp.data;
    } else {
      print(rp.message);
      return 0;
    }
  }

  Future<bool> update(Map<String, dynamic> map) async {
    final rp = await _baseData.updateMap(name, map, where: "ID = ?", whereArgs: [map['ID']]);
    if (rp.status == ResponseType.success) {
      return true;
    } else {
      print(rp.message);
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getKho15() async {
    final rp = await _baseData.getListMap(name, where: "MaLK = ?", whereArgs: ['15']);
    if (rp.status == ResponseType.success) {
      return rp.data;
    } else {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> get0() async {
    final rp = await _baseData.getListMap(name, where: "MAXL = 0");
    if (rp.status == ResponseType.success) {
      return rp.data;
    } else {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getTKNoPXCT() async {
    final rp = await _baseData.getListMap(name, where: "MaTK IN ('156','632')");
    if (rp.status == ResponseType.success) {
      return rp.data;
    } else {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getTKCoPXCT() async {
    final rp = await _baseData.getListMap(name, where: "MaLK = '15' OR MaTK  = '632'");
    if (rp.status == ResponseType.success) {
      return rp.data;
    } else {
      return [];
    }
  }
}
