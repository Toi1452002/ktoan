import 'z_base_repository.dart';

class ThongTinDoanhNghiepRepository {
  static const name = "T00_TTDN";
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

  Future<void> updateCell(dynamic value, int id) async {
    await _cnn.updateMap(name, {"NoiDung": value}, where: "ID  = $id");
  }
}
