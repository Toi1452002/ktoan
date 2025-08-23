import 'package:pm_ketoan/core/core.dart';
import 'package:pm_ketoan/data/repository/z_base_repository.dart';

class MaNghiepVuRepository {
  static const name = "TDM_MaNghiepVu";

  final _baseData = BaseRepository();

  Future<List<Map<String, dynamic>>> getList() async {
    final rp =  await _baseData.getListMap(name);
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
    final rp =  await _baseData.updateMap(name, map, where: "ID = ?", whereArgs: [map['ID']]);
    if(rp.status == ResponseType.success){
      return true;
    }else{
      print(rp.message);
      return false;
    }
  }

  Future<bool> delete(int id) async {
    final rp =  await _baseData.delete(name, where: "ID = ?", whereArgs: [id]);
    if(rp.status == ResponseType.success) {
      return true;
    } else {
      print(rp.message);
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getKNhap() async {
    final rp = await _baseData.getListMap(name, where: "MaNV LIKE 'N%'");;
    if(rp.status == ResponseType.success){
      return rp.data;
    }else{
      CustomAlert.error(rp.message.toString());
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getKXuat() async {
    final rp = await _baseData.getListMap(name, where: "MaNV LIKE 'X%'");;
    if(rp.status == ResponseType.success){
      return rp.data;
    }else{
      CustomAlert.error(rp.message.toString());
      return [];
    }
  }Future<List<Map<String, dynamic>>> getKThu() async {
    final rp = await _baseData.getListMap(name, where: "MaNV LIKE 'T%'");
    if(rp.status == ResponseType.success){
      return rp.data;
    }else{
      CustomAlert.error(rp.message.toString());
      return [];
    }
  }
  Future<List<Map<String, dynamic>>> getKChi() async {
    final rp = await _baseData.getListMap(name, where: "MaNV LIKE 'C%'");
    if(rp.status == ResponseType.success){
      return rp.data;
    }else{
      CustomAlert.error(rp.message.toString());
      return [];
    }
  }
}
