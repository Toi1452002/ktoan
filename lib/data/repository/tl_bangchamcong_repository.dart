import 'package:pm_ketoan/data/repository/z_base_repository.dart';

class BangChamCongRepository {
  final _cnn = BaseRepository();

  static const name = 'TTL_BangCong';
  static const view = 'VTL_BangCong';
  static const maCC = 'TDM_MaCC';

  Future<List<Map<String, dynamic>>> get(String thang, String nam) async {
    if (thang.length == 1) thang = "0$thang";
    final rp = await _cnn.getListMap(view, where: "strftime('%Y', Ngay) = '$nam' AND strftime('%m', Ngay) = '$thang'");
    if (rp.status == ResponseType.success) {
      return rp.data;
    } else {
      errorSql(rp.message);
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getMaCC() async {
    final rp = await _cnn.getListMap(maCC);
    return rp.data;
  }
}
