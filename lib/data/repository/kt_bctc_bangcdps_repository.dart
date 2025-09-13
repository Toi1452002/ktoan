import 'package:pm_ketoan/data/data.dart';
import 'package:pm_ketoan/data/repository/z_base_repository.dart';
import 'dart:math';

class BangCDPSRepository {
  static const tmp = "tmp_CDPS";

  final _cnn = BaseRepository();

  Future<void> chepBangTaiKhoan() async {
    await _cnn.delete(tmp);
    final btk = await BangTaiKhoanRepository().getList(columns: ['MaTK', 'MAXL as Cap']);
    await _cnn.addRows(tmp, btk);
  }

  Future<void> updateTK(List<Map<String, dynamic>> data) async {
    await _cnn.updateRows(tmp, data, "MaTK");
  }

  Future<List<Map<String, dynamic>>> getPsNo(String tN, String dN) async {
    return await _cnn.getListMap(
      'VKT_SoNKyChung',
      columns: ['TKNo', 'SUM(SoPS) SoPS'],
      orderBy: 'TKNo',
      where: "Ngay BETWEEN ? AND ?",
      whereArgs: [tN, dN],
      groupBy: 'TKNo',
    );
  }

  Future<List<Map<String, dynamic>>> getPsCo(String tN, String dN) async {
    return await _cnn.getListMap(
      'VKT_SoNKyChung',
      columns: ['TKCo', 'SUM(SoPS) SoPS'],
      orderBy: 'TKCo',
      where: "Ngay BETWEEN ? AND ?",
      whereArgs: [tN, dN],
      groupBy: 'TKCo',
    );
  }

  Future<void> tinhSoDuCK() async {
    final data = await _cnn.getListMap(
      tmp,
      columns: ['IFNULL(DKNo,0) DKNo', 'IFNULL(DKCo,0) DKCo', 'IFNULL(PSNo,0) PSNo', 'IFNULL(PSCo,0) PSCo', 'MaTK'],
    );
    List<Map<String, dynamic>> lstUD = [];
    for (var x in data) {
      lstUD.add({
        'MaTK': x['MaTK'],
        'CKNo': max(x['DKNo'] + x['PSNo'] - x['DKCo'] - x['PSCo'], 0),
        'CKCo': max(x['DKCo'] + x['PSCo'] - x['DKNo'] - x['PSNo'], 0),
      });
    }
    await _cnn.updateRows(tmp, lstUD, 'MaTK');
  }

  Future<void> tinhTongNhom() async {
    final data = await _cnn.getListMap(tmp, where: 'Cap = 1');
    List<Map<String, dynamic>> lstUD = [];

    for (var x in data) {
      final doDai = x['MaTK'].toString().length;
      lstUD.add({
        'MaTK': x['MaTK'],
        'DKNo': await _cnn.getCell(tmp, field: 'SUM(DKNo)', condition: "SUBSTR(MaTK, 1, $doDai) = '${x['MaTK']}'"),
        'DKCo': await _cnn.getCell(tmp, field: 'SUM(DKCo)', condition: "SUBSTR(MaTK, 1, $doDai) = '${x['MaTK']}'"),
        'PSNo': await _cnn.getCell(tmp, field: 'SUM(PSNo)', condition: "SUBSTR(MaTK, 1, $doDai) = '${x['MaTK']}'"),
        'PSCo': await _cnn.getCell(tmp, field: 'SUM(PSCo)', condition: "SUBSTR(MaTK, 1, $doDai) = '${x['MaTK']}'"),
        'CKNo': await _cnn.getCell(tmp, field: 'SUM(CKNo)', condition: "SUBSTR(MaTK, 1, $doDai) = '${x['MaTK']}'"),
        'CKCo': await _cnn.getCell(tmp, field: 'SUM(CKCo)', condition: "SUBSTR(MaTK, 1, $doDai) = '${x['MaTK']}'"),
      });
    }
    await _cnn.updateRows(tmp, lstUD, 'MaTK');
  }

  Future<List<Map<String, dynamic>>> xemTatCa() async {
    return await _cnn.getSQL('''
      SELECT a.MaTK, b.TenTK, a.DKNo, a.DKCo, a.PSNo, a.PSCo, a.CKNo, a.CKCo, a.Cap
      FROM $tmp a JOIN TDM_BangTaiKhoan b ON a.MaTK = b.MaTK
      ORDER BY a.MaTK
    ''');
  }

  Future<List<Map<String, dynamic>>> xemTKCha() async {
    return await _cnn.getSQL('''
      SELECT a.MaTK, b.TenTK, a.DKNo, a.DKCo, a.PSNo, a.PSCo, a.CKNo, a.CKCo, a.Cap
      FROM $tmp a JOIN TDM_BangTaiKhoan b ON a.MaTK = b.MaTK
      WHERE a.Cap = 1
      ORDER BY a.MaTK
    ''');
  }

  Future<List<Map<String, dynamic>>> xemTKCon() async {
    return await _cnn.getSQL('''
      SELECT a.MaTK, b.TenTK, a.DKNo, a.DKCo, a.PSNo, a.PSCo, a.CKNo, a.CKCo, a.Cap
      FROM $tmp a JOIN TDM_BangTaiKhoan b ON a.MaTK = b.MaTK
      WHERE a.Cap = 0
      ORDER BY a.MaTK
    ''');
  }

  Future<List<Map<String, dynamic>>> xemTKCoPS() async {
    return await _cnn.getSQL('''
      SELECT a.MaTK, b.TenTK, a.DKNo, a.DKCo, a.PSNo, a.PSCo, a.CKNo, a.CKCo, a.Cap
      FROM $tmp a JOIN TDM_BangTaiKhoan b ON a.MaTK = b.MaTK
      WHERE IFNULL(a.DKNo,0)+IFNULL(a.DKCo,0)+IFNULL(a.PSNo,0)+IFNULL(a.PSCo,0) !=0
      ORDER BY a.MaTK
    ''');
  }

  Future<List<Map<String, dynamic>>> xemTKConCoPS() async {
    return await _cnn.getSQL('''
      SELECT a.MaTK, b.TenTK, a.DKNo, a.DKCo, a.PSNo, a.PSCo, a.CKNo, a.CKCo, a.Cap
      FROM $tmp a JOIN TDM_BangTaiKhoan b ON a.MaTK = b.MaTK
      WHERE IFNULL(a.DKNo,0)+IFNULL(a.DKCo,0)+IFNULL(a.PSNo,0)+IFNULL(a.PSCo,0) !=0 AND Cap = 0
      ORDER BY a.MaTK
    ''');
  }

  Future<List<Map<String, dynamic>>> getTmpGhiDKTK() async {
    return await _cnn.getSQL('''
      SELECT * FROM $tmp
      WHERE (PSNo != 0 AND Cap = 0) 
      OR (PSCo !=0 AND Cap = 0)
      OR (CKNo !=0 AND Cap = 0)
      OR (CKCo!=0 AND Cap = 0) 
    ''');
  }

  Future<void> addDKTK(Map<String, dynamic> m) async {
    await _cnn.addMap(DauKyRepository.nameDkyBTK, m);
  }

  Future<void> updateDKTK(Map<String, dynamic> m) async {
    await _cnn.updateMap(DauKyRepository.nameDkyBTK, m, where: "MaTK = '${m['MaTK']}' AND Thang = '${m['Thang']}'");
  }

  Future<dynamic> tinhLN4211() async {
    final dkNo = await _cnn.getCell(tmp, field: 'DKNo', condition: "MaTK = '4211'");
    if (dkNo != null) {
      final x = await _cnn.getCell(tmp, field: "IFNULL(DKNo,0)-IFNULL(DKCo,0)", condition: "MaTK = '4211'");
      final y = await _cnn.getCell(tmp, field: "IFNULL(PSNo,0)-IFNULL(PSCo,0)", condition: "MaTK = '4212'");
      return x + y;
    } else {
      return null;
    }
  }
}
