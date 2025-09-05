import 'package:pm_ketoan/core/core.dart';
import 'package:pm_ketoan/data/repository/z_base_repository.dart';

class BangChamCongRepository {
  final _cnn = BaseRepository();

  static const name = 'TTL_BangCong';
  static const view = 'VTL_BangCong';
  static const maCC = 'TDM_MaCC';

  Future<List<Map<String, dynamic>>> get(String thang, String nam) async {
    if (thang.length == 1) thang = "0$thang";
    return await _cnn.getListMap(view, where: "strftime('%Y', Ngay) = '$nam' AND strftime('%m', Ngay) = '$thang'");

  }

  Future<List<Map<String, dynamic>>> getListMaCC() async {
    return await _cnn.getListMap(maCC);
   }

  Future<bool> updateMaNV(String maNV, int id) async {
    return await _cnn.updateMap(name, {'MaNV': maNV}, where: 'ID = $id');

  }

  Future<int> addMaNV(String maNV, String date) async {
    return await _cnn.addMap(name, {'MaNV': maNV, 'Ngay': date});

  }

  Future<bool> updateCongTien(double tien, int id) async {
    return await _cnn.updateMap(name, {'TongCong': tien}, where: 'ID = $id');

  }

  Future<bool> updateN(String n, String field, int id) async {
    return await _cnn.updateMap(name, {field: n}, where: 'ID = $id');

  }
  Future<bool> delete(int id) async {
    return await _cnn.delete(name,where: 'ID = $id');

  }
  
  Future<String> getN(int id, String field) async{
    return await _cnn.getCell(name, field: field,condition: "ID = $id")??"";
  }
  Future<dynamic> getSoCong(String ma) async{
    return await _cnn.getCell(maCC, field: 'SoCong',condition: "Ma = '$ma'");
  }
}
