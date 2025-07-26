import 'package:pm_ketoan/data/repository/base_repository.dart';

class MaNghiepVuRepository{
  static const name = "TDM_MaNghiepVu";

  final _baseData = BaseRepository();

  Future<List<Map<String, dynamic>>> getList() async{
    return await _baseData.getListMap(name);
  }
  Future<int> add(Map<String, dynamic> map) async{
    return await _baseData.addMap(name, map);
  }
  Future<bool> update(Map<String, dynamic> map) async{
    return await _baseData.updateMap(name, map,where: "ID = ?", whereArgs: [map['ID']]);
  }
  Future<bool> delete(int id) async{
    return await _baseData.delete(name, where: "ID = ?", whereArgs: [id]);
  }
}