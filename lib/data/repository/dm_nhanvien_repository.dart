import 'package:pm_ketoan/core/core.dart';
import 'package:pm_ketoan/data/repository/z_base_repository.dart';

class NhanVienRepository {
  static const name = "TDM_NhanVien";
  static const pcGT = "TDM_PCvaGT";
  final _cnn = BaseRepository();

  Future<List<Map<String, dynamic>>> getList() async {
    final rp = await _cnn.getListMap(name);
    if (rp.status == ResponseType.success) {
      return rp.data;
    } else {
      errorSql(rp.message);
      return [];
    }
  }

  Future<int> add(Map<String, dynamic> map) async {
    final rp = await _cnn.addMap(name, map);
    if (rp.status == ResponseType.success) {
      return rp.data;
    } else {
      errorSql(rp.message);
      return 0;
    }
  }

  Future<bool> update(Map<String, dynamic> map) async {
    final rp = await _cnn.updateMap(name, map, where: "ID  = ?", whereArgs: [map['ID']]);
    if (rp.status == ResponseType.success) {
      return true;
    } else {
      errorSql(rp.message);
      return false;
    }
  }

  Future<bool> delete(int id) async {
    final rp = await _cnn.delete(name, where: "ID  = ?", whereArgs: [id]);
    if (rp.status == ResponseType.success) {
      return true;
    } else {
      errorSql(rp.message);
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getPCGT({String maNV = ''}) async {
    final data = await _cnn.getSQL('''
        SELECT a.Ma as MaPC, a.MoTa, b.MaNV, b.SoTieuChuan, b.SoThucTe FROM TDM_MoTaPCGTTL a left join TDM_PCvaGT b on a.Ma = b.MaPC and b.MaNV = '$maNV'
      ''');
    return data.data;
  }

  Future<void> deletePCGT(String maNV) async {
    await _cnn.delete(pcGT, where: 'MaNV = ?', whereArgs: [maNV]);
  }

  Future<void> addPCGT(List<Map<String, dynamic>> data) async {
    try {
      await _cnn.addRows(pcGT, data);
    } catch (e) {
      errorSql(e);
    }
  }
}
