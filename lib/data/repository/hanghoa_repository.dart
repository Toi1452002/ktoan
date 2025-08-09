import 'package:pm_ketoan/data/data.dart';

import 'base_repository.dart';

class HangHoaRepository {
  static const name = "TDM_HangHoa";
  static const view = "V_HangHoa";
  final _baseData = BaseRepository();

  Future<List<Map<String, dynamic>>> getData({int td = 1}) async {
    final rp =  await _baseData.getListMap(view, where: td == 2 ? null : 'TheoDoi = ?', whereArgs: td == 2 ? null : [td]);
    if(rp.status == ResponseType.success){
      return rp.data;
    }else{
      print(rp.message);
      return [];
    }
  }

  Future<int> add(Map<String, dynamic> map) async {
    final rp =  await _baseData.addMap(name, map);
    if(rp.status == ResponseType.success) {
      return rp.data;
    } else {
      print(rp.message);
      return 0;
    }
  }

  Future<bool> update(Map<String, dynamic> map) async {
    final rp =  await _baseData.updateMap(name, map, where: 'ID = ?', whereArgs: [map['ID']]);
    if(rp.status == ResponseType.success){
      return true;
    }else{
      print(rp.message);
      return false;
    }
  }

  Future<bool> delete(int id) async {
    final rp = await _baseData.delete(name, where: 'ID = ?', whereArgs: [id]);
    if(rp.status == ResponseType.success) {
      return true;
    } else {
      print(rp.message);
      return false;
    }
  }

  Future<Map<String, dynamic>> getHangHoa(String ma) async {
    return _baseData.getMap(name, where: "MaHH = ?", whereArgs: [ma]);
  }

  Future<List<Map<String, dynamic>>> getLoaiHang() async {
    final rp =  await _baseData.getListMap('TDM_LoaiHang');
    if(rp.status == ResponseType.success){
      return rp.data;
    }else{
      print(rp.message);
      return [];
    }
  }








}
