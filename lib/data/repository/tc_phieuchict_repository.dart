import '../../core/utils/alert.dart';
import 'z_base_repository.dart';

class PhieuChiCTRepository {
  static const name = "TTC_PhieuChiCT";
  final _cnn = BaseRepository();

  Future<List<Map<String, dynamic>>> get(int maID) async {
    return await _cnn.getListMap(name, where: "MaID = ?", whereArgs: [maID]);

  }

  Future<bool> deleteRow(int id) async {
    return await _cnn.delete(name, where: 'ID =  $id');

  }

  Future<int> addNoiDung(String val, int maID) async {
    return await _cnn.addMap(name, {'MaID': maID, 'DienGiai': val});

  }

  Future<int> addSoTien(double val, int maID) async {
    return await _cnn.addMap(name, {'MaID': maID, 'SoTien': val});

  }

  Future<void> updateNoiDung(String val, int id) async {
    await _cnn.updateMap(name, {'DienGiai': val}, where: "ID= $id");
  }

  Future<void> updateSoTien(double val, int id) async {
    await _cnn.updateMap(name, {'SoTien': val}, where: "ID= $id");
  }
}
