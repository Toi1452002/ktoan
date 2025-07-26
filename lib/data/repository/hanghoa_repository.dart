import 'package:pm_ketoan/data/data.dart';

import 'base_repository.dart';

class HangHoaRepository {
  static const name = "TDM_HangHoa";
  static const view = "V_HangHoa";
  final _baseData = BaseRepository();

  Future<List<Map<String, dynamic>>> getData({int td = 1}) async {
    return await _baseData.getListMap(view, where: td == 2 ? null : 'TheoDoi = ?', whereArgs: td == 2 ? null : [td]);
  }

  Future<int> add(Map<String, dynamic> map) async {
    return await _baseData.addMap(name, map);
    // try{
    //   final cnn = await connectData();
    //   await cnn!.insert(name, map);
    //   return true;
    // }catch(e){
    //   errorSql(e);
    //   return false;
    // }
  }

  Future<bool> update(Map<String, dynamic> map) async {
    return await _baseData.updateMap(name, map, where: 'ID = ?', whereArgs: [map['ID']]);
    // try{
    //   final cnn = await connectData();
    //   await cnn!.update(name, map,where: 'ID = ?', whereArgs: [map['ID']]);
    //   return true;
    // }catch(e){
    //   errorSql(e);
    //   return false;
    // }
  }

  Future<bool> delete(int id) async {
    return _baseData.delete(name, where: 'ID = ?', whereArgs: [id]);
    // try{
    //   final cnn = await connectData();
    //   await cnn!.delete(name,where: 'ID = ?', whereArgs: [id]);
    //   return true;
    // }catch(e){
    //   errorSql(e);
    //   return false;
    // }
  }

  Future<Map<String, dynamic>> getHangHoa(String ma) async {
    return _baseData.getMap(name, where: "MaHH = ?", whereArgs: [ma]);
    try {
      final cnn = await connectData();
      final data = await cnn!.query(name, where: "MaHH = ?", whereArgs: [ma], limit: 1);
      return data.isEmpty ? {} : data.first;
    } catch (e) {
      errorSql(e);
      return {};
    }
  }

  Future<List<Map<String, dynamic>>> getLoaiHang() async {
    return await _baseData.getListMap('TDM_LoaiHang');
    try {
      final cnn = await connectData();
      final data = await cnn!.query('TDM_LoaiHang');
      return data;
    } catch (e) {
      errorSql(e);
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getDonViTinh() async {
    return _baseData.getListMap('TDM_DonViTinh', orderBy: 'DVT');
  }

  Future<List<Map<String, dynamic>>> getNhomHang() async {
    return _baseData.getListMap('TDM_NhomHang', orderBy: 'NhomHang');
  }

  Future<List<Map<String, dynamic>>> getNhaCung() async {
    return _baseData.getListMap('TDM_KhachHang', where: "TheoDoi = ? AND LoaiKH IN (?,?)", whereArgs: [1, "NC", "CH"]);

    try {
      final cnn = await connectData();
      final data = await cnn!.query(
        'TDM_KhachHang',
        where: "TheoDoi = ? AND LoaiKH IN (?,?)",
        whereArgs: [1, "NC", "CH"],
      );
      return data;
    } catch (e) {
      errorSql(e);
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getKho() async {
    return _baseData.getListMap('TDM_BangTaiKhoan', where: "MaLK = ?", whereArgs: ['15']);
  }
}
