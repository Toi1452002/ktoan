import '../../core/utils/alert.dart';
import 'base_repository.dart';

class PhieuThuCTRepository {
  static const name = "TTC_PhieuThuCT";
  final _cnn = BaseRepository();

  Future<List<Map<String, dynamic>>> get(int maID) async {
    final rp = await _cnn.getListMap(name, where: "MaID = ?", whereArgs: [maID]);
    if (rp.status == ResponseType.success) {
      return rp.data;
    } else {
      CustomAlert.error(rp.message.toString());
      return [];
    }
  }

  Future<bool> deleteRow(int id) async {
    final rp = await _cnn.delete(name, where: 'ID =  $id');
    if (rp.status == ResponseType.success) {
      return true;
    } else {
      CustomAlert.error(rp.message.toString());
      return false;
    }
  }

  Future<int> addNoiDung(String val, int maID) async {
    final rp = await _cnn.addMap(name, {'MaID': maID, 'DienGiai': val});
    if (rp.status == ResponseType.success) {
      return rp.data;
    } else {
      return 0;
    }
  }

  Future<int> addSoTien(double val, int maID) async {
    final rp = await _cnn.addMap(name, {'MaID': maID, 'SoTien': val});
    if (rp.status == ResponseType.success) {
      return rp.data;
    } else {
      return 0;
    }
  }

  Future<void> updateNoiDung(String val, int id) async {
    await _cnn.updateMap(name, {'DienGiai': val}, where: "ID= $id");
  }

  Future<void> updateSoTien(double val, int id) async {
    await _cnn.updateMap(name, {'SoTien': val}, where: "ID= $id");
  }
}
