import 'package:pm_ketoan/data/repository/z_base_repository.dart';

class SoNhatKyChungRepository {
  static const _view = "VKT_NhatKyChung";
  final _cnn = BaseRepository();

  Future<List<Map<String, dynamic>>> get(String tN, String dN) async {
    return await _cnn.getListMap(_view, where: "Ngay BETWEEN ? AND ?", whereArgs: [tN, dN]);
  }
}
