import 'package:pm_ketoan/data/repository/z_base_repository.dart';

class BangTaiKhoanRepository {
  static const name = "TDM_BangTaiKhoan";
  static const soCTTK = "VKT_SoCTTK";

  final _baseData = BaseRepository();

  Future<List<Map<String, dynamic>>> getList({List<String>? columns}) async {
    return await _baseData.getListMap(name, columns: columns);
  }

  Future<bool> delete(int id) async {
    return await _baseData.delete(name, where: 'ID = ?', whereArgs: [id]);
  }

  Future<int> add(Map<String, dynamic> map) async {
    return await _baseData.addMap(name, map);
  }

  Future<bool> update(Map<String, dynamic> map) async {
    return await _baseData.updateMap(name, map, where: "ID = ?", whereArgs: [map['ID']]);
  }

  Future<List<Map<String, dynamic>>> getKho15() async {
    return await _baseData.getListMap(name, where: "MaLK = ?", whereArgs: ['15']);
  }

  Future<List<Map<String, dynamic>>> get0() async {
    return await _baseData.getListMap(name, where: "MAXL = 0");
  }

  Future<List<Map<String, dynamic>>> getTKNoPXCT() async {
    return await _baseData.getListMap(name, where: "MaTK IN ('156','632')");
  }

  Future<List<Map<String, dynamic>>> getTKCoPXCT() async {
    return await _baseData.getListMap(name, where: "MaLK = '15' OR MaTK  = '632'");
  }

  Future<List<Map<String, dynamic>>> getTKChiPhi() async {
    return await _baseData.getListMap(
      name,
      where: "MAXL = '0'  AND MaTK LIKE '6%'",
      columns: ['MaTK', 'TenTK'],
      orderBy: 'MaTK',
    );
  }

  Future<List<Map<String, dynamic>>> getTKHaoMon() async {
    return await _baseData.getListMap(
      name,
      where: "MAXL = '0' AND MaTK LIKE '2%'",
      columns: ['MaTK', 'TenTK'],
      orderBy: 'MaTK',
    );
  }

  Future<List<Map<String, dynamic>>> getSoCTTK(String year, String maTK) async {
    final data = await _baseData.getListMap(
      soCTTK,
      where: "strftime('%Y',Ngay) = ? AND TKDU = ?",
      whereArgs: [year, maTK],
    );
    return data;
  }
}
