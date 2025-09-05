import 'package:pm_ketoan/core/core.dart';
import 'package:pm_ketoan/data/repository/z_base_repository.dart';

class NhanVienRepository {
  static const name = "TDM_NhanVien";
  static const pcGT = "TDM_PCvaGT";
  final _cnn = BaseRepository();

  Future<List<Map<String, dynamic>>> getList({bool? td}) async {
    return await _cnn.getListMap(name, where: td == null ? null : "TheoDoi = 1");
  }

  Future<Map<String, dynamic>> getNV(String maNV) async {
    return await _cnn.getMap(name, where: "MaNV = '$maNV'");
  }

  Future<int> add(Map<String, dynamic> map) async {
    return await _cnn.addMap(name, map);
  }

  Future<bool> update(Map<String, dynamic> map) async {
    return await _cnn.updateMap(name, map, where: "ID  = ?", whereArgs: [map['ID']]);
  }

  Future<bool> delete(int id) async {
    return await _cnn.delete(name, where: "ID  = ?", whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getPCGT({String maNV = ''}) async {
    final data = await _cnn.getSQL('''
        SELECT a.Ma as MaPC, a.MoTa, b.MaNV, b.SoTieuChuan, b.SoThucTe FROM TDM_MoTaPCGTTL a left join TDM_PCvaGT b on a.Ma = b.MaPC and b.MaNV = '$maNV'
      ''');
    return data;
  }

  Future<List<Map<String, dynamic>>> getPCGTBL({String maNV = '', required String ma}) async {
    final data = await _cnn.getSQL('''
        SELECT  a.MoTa, b.SoTieuChuan, b.SoThucTe FROM TDM_MoTaPCGTTL a left join TDM_PCvaGT b on a.Ma = b.MaPC and b.MaNV = '$maNV' WHERE b.MaPC LIKE '$ma%'
      ''');
    return data;
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
