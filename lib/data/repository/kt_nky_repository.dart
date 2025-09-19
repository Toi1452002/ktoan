import 'package:pm_ketoan/data/data.dart';
import 'package:pm_ketoan/data/repository/z_base_repository.dart';

class NhatKyRepository {
  static const _viewNKChung = "VKT_NhatKyChung";
  static const _viewSoCaiTK = "VKT_SoCaiTK";
  static const _viewSoCTTK = "VKT_SoCTTK";
  final _cnn = BaseRepository();

  Future<List<Map<String, dynamic>>> getNKChung(String tN, String dN) async {
    return await _cnn.getListMap(_viewNKChung, where: "Ngay BETWEEN ? AND ?", whereArgs: [tN, dN]);
  }

  Future<List<Map<String, dynamic>>> getSoCaiTK(String tN, String dN, String maTK) async {
    return await _cnn.getSQL('''
      SELECT Ngay, ChungTu, NgayCT, DienGiai, TKDU, SUM(PSNo) PSNo, SUM(PSCo) PSCo
      FROM $_viewSoCaiTK
      WHERE substr(TK, 1,3) = '$maTK'
      GROUP BY Ngay, ChungTu, NgayCT, DienGiai, TKDU
      HAVING Ngay BETWEEN '$tN' AND '$dN'
      
      UNION
      
      SELECT Ngay, ChungTu, NgayCT, DienGiai, TKDU, SUM(PSNo) PSNo, SUM(PSCo) PSCo
      FROM $_viewSoCaiTK
      WHERE TK = '$maTK'
      GROUP BY Ngay, ChungTu, NgayCT, DienGiai, TKDU
      HAVING Ngay BETWEEN '$tN' AND '$dN'
      
      ORDER BY Ngay
    ''');
  }

  Future<dynamic> getSoDuDKyCo(String ngay, String ma) async {
    try {
      final data = await _cnn.getSQL('''
      SELECT DKCo SoDuCo
      FROM ${DauKyRepository.nameDkyBTK}
      WHERE MaTK  LIKE '$ma%' AND Dky = 1
      UNION ALL 
      SELECT SUM(SoPS) SoDuCo
      FROM VKT_SoNKChung
      WHERE TKCo LIKE '$ma%' AND Ngay<'$ngay'
    ''');
      return data.first['SoDuCo'] ?? 0;
    } catch (e) {
      print(e);
      return 0;
    }
  }

  Future<dynamic> getSoDuDKyNo(String ngay, String ma) async {
    try {
      final data = await _cnn.getSQL('''
      SELECT DKNo SoDuNo
      FROM ${DauKyRepository.nameDkyBTK}
      WHERE MaTK  LIKE '$ma%' AND Dky = 1
      UNION ALL
      SELECT SUM(SoPS) SoDuNo
      FROM VKT_SoNKChung
      WHERE TKCo LIKE '$ma%' AND Ngay< '$ngay'
    ''');
      return data.first['SoDuNo'] ?? 0;
    } catch (e) {
      print(e);
      return 0;
    }
  }

  Future<List<Map<String, dynamic>>> getSoCTTK(String maTK, String tN, String dN) async {
    return await _cnn.getListMap(
      _viewSoCTTK,
      where: "Ngay BETWEEN ? AND ? AND TK = ?",
      whereArgs: [tN, dN, maTK],
      columns: ['Ngay', 'SoCT ChungTu', 'NgayCT', 'DienGiai', 'TKDU', 'PSCo PSNo', 'PSNo PSCo', 'TK'],
      orderBy: "Ngay",
    );
  }
}
