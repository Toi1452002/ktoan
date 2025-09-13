import 'package:pm_ketoan/data/repository/z_base_repository.dart';

class TSCDRepository {
  // TSCDRepository._();
  final String _view = "VTS_TSCD";
  final String _name = "TTS_TSCD";

  final _cnn = BaseRepository();

  Future<List<Map<String, dynamic>>> get() async {
    return await _cnn.getListMap(_view);
  }

  Future<int> add(int itemID, dynamic giaMua) async {
    return await _cnn.addMap(_name, {'ItemID': itemID, 'NguyenGia': giaMua});
  }

  Future<bool> updateMaHH(int id, int itemID, dynamic gia) async {
    return await _cnn.updateMap(_name, {'ItemID': itemID, 'NguyenGia': gia}, where: 'ID = $id');
  }

  Future<bool> updateCell(String field, dynamic value, int id) async {
    return await _cnn.updateMap(_name, {field: value}, where: "ID = $id");
  }

  Future<bool> updateTKChiPhi(String val, int id)async{
    return await _cnn.updateMap(_name, {'TkChiPhi': val}, where: "ID = $id");
  }
  Future<bool> updateTKHaoMon(String val, int id)async{
    return await _cnn.updateMap(_name, {'TKHaoMon': val}, where: "ID = $id");
  }

  Future<dynamic> getTNgay() async{
    return await _cnn.getCell("$_name ORDER BY NgayMua  LIMIT 1 ", field: 'NgayMua' );
  }

  Future<bool> thucHien(List<Map<String, dynamic>> data) async{
    return await _cnn.updateRows(_name, data, 'ID');
  }

  Future<bool> delete(int id) async{
    return await _cnn.delete(_name,where: "ID = $id");
  }
}
