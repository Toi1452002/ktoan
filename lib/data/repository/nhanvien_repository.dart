import 'package:pm_ketoan/core/core.dart';
import 'package:pm_ketoan/data/repository/base_repository.dart';

class NhanVienRepository {
  static const name = "TDM_NhanVien";
  final _cnn = BaseRepository();

  Future<List<Map<String, dynamic>>> getList() async {
    final rp = await _cnn.getListMap(name);
    if (rp.status == ResponseType.success) {
      return rp.data;
    } else {
      CustomAlert.error(rp.message.toString());
      return [];
    }
  }
}
