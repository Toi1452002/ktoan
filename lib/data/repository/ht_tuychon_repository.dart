import 'package:pm_ketoan/data/repository/z_base_repository.dart';

class TuyChonRepository {
  static const name = "T00_TuyChon";

  final _baseData = BaseRepository();

  Future<List<Map<String, dynamic>>> getTuyChon() async {
    final rp = await _baseData.getListMap(
      name,
      where: "Nhom IN (?,?,?,?,?)",
      whereArgs: ['gvPPT', 'qlPNK', 'qlPXK', 'qlKPC', 'qlXBC'],
    );
    if (rp.status == ResponseType.success) {
      return rp.data;
    } else {
      errorSql(rp.message);
      return [];
    }
  }

  Future<bool> updateTuyChon(Map<String, int> x) async {
    List<Map<String, dynamic>> lstData = [];
    x.forEach((k, v) {
      lstData.add({'Nhom': k, 'GiaTri': v});
    });

    final rp = await _baseData.updateRows(name, lstData, 'Nhom');
    if (rp.status == ResponseType.success) {
      return true;
    } else {
      errorSql(rp.message);
      return false;
    }
  }

  Future<dynamic> getQlKPC() async => await _baseData.getCell(name, field: 'GiaTri', condition: "Nhom = 'qlKPC'");

  Future<dynamic> getPnN() async => await _baseData.getCell(name, field: 'GiaTri', condition: "Nhom = 'PNn'");

  Future<dynamic> getPnC() async => await _baseData.getCell(name, field: 'GiaTri', condition: "Nhom = 'PNc'");

  Future<dynamic> getTnN() async => await _baseData.getCell(name, field: 'GiaTri', condition: "Nhom = 'TNn'");

  Future<dynamic> getTnC() async => await _baseData.getCell(name, field: 'GiaTri', condition: "Nhom = 'TNc'");

  Future<dynamic> getPtN() async => await _baseData.getCell(name, field: 'GiaTri', condition: "Nhom = 'PTn'");

  Future<dynamic> getPtC() async => await _baseData.getCell(name, field: 'GiaTri', condition: "Nhom = 'PTc'");

  Future<dynamic> getPcN() async => await _baseData.getCell(name, field: 'GiaTri', condition: "Nhom = 'PCn'");

  Future<dynamic> getPcC() async => await _baseData.getCell(name, field: 'GiaTri', condition: "Nhom = 'PCc'");

  Future<dynamic> getTS() async => await _baseData.getCell(name, field: 'GiaTri', condition: "Nhom = 'TS'");
}
