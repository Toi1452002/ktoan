import 'package:pm_ketoan/data/data.dart';
import 'package:pm_ketoan/data/repository/base_repository.dart';

class NhomhangRepository {
  static const name = "TDM_NhomHang";

  final _baseData = BaseRepository();
  Future<List<Map<String, dynamic>>> getList() async {
    final rp = await _baseData.getListMap(name);
    if(rp.status == ResponseType.success){
      return rp.data;
    }else{
      print(rp.message);
      return [];
    }
  }

  Future<int> add(Map<String, dynamic> map) async {
    final rp = await _baseData.addMap(name, map);
    if(rp.status == ResponseType.success) {
      return rp.data;
    } else {
      Exception(rp.message);
      return 0;
    }
  }
  Future<bool> update(Map<String, dynamic> map) async {
    final rp = await _baseData.updateMap(name, map,where: "ID = ?",whereArgs: [map["ID"]]);
    if(rp.status == ResponseType.success){
      return true;
    }else{
      print(rp.message);
      return false;
    }
  }
  Future<bool> delete(int id) async {
    final rp =  await _baseData.delete(name, where: "ID = ?",whereArgs: [id]);
    if(rp.status == ResponseType.success) {
      return true;
    } else {
      Exception(rp.message);
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getNhomHang() async {
    final rp = await _baseData.getListMap(name, orderBy: 'NhomHang');
    if(rp.status == ResponseType.success){
      return rp.data;
    }else{
      print(rp.message);
      return [];
    }
  }

}
