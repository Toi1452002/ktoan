import 'package:pm_ketoan/data/data.dart';

import 'z_base_repository.dart';

class DonViTinhRepository {
  static const name = "TDM_DonViTinh";
  final _baseData = BaseRepository();

  Future<List<Map<String, dynamic>>> getList() async {
    final rp = await _baseData.getListMap(name);
    if (rp.status == ResponseType.success) {
      return rp.data;
    } else {
      return [];
    }
  }

  Future<int> add(Map<String, dynamic> map) async {
    final rp = await _baseData.addMap(name, map);
    if(rp.status==ResponseType.success){
      return rp.data;
    }else{
      print(rp.message);
      return 0;
    }
  }

  Future<bool> update(Map<String, dynamic> map) async {
    final rp = await _baseData.updateMap(name, map, where: "ID = ?", whereArgs: [map["ID"]]);
    if (rp.status == ResponseType.success) {
      return true;
    } else {
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

  Future<List<Map<String, dynamic>>> getDonViTinh() async {
    final rp = await _baseData.getListMap('TDM_DonViTinh', orderBy: 'DVT');
    if (rp.status == ResponseType.success) {
      return rp.data;
    } else {
      return [];
    }
  }
}
