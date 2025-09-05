import 'package:pm_ketoan/data/data.dart';

import 'z_base_repository.dart';

class DonViTinhRepository {
  static const name = "TDM_DonViTinh";
  final _baseData = BaseRepository();

  Future<List<Map<String, dynamic>>> getList() async {
    return  await _baseData.getListMap(name);

  }

  Future<int> add(Map<String, dynamic> map) async {
    return  await _baseData.addMap(name, map);

  }

  Future<bool> update(Map<String, dynamic> map) async {
    return  await _baseData.updateMap(name, map, where: "ID = ?", whereArgs: [map["ID"]]);

  }

  Future<bool> delete(int id) async {
    return  await _baseData.delete(name, where: "ID = ?", whereArgs: [id]);

  }

  Future<List<Map<String, dynamic>>> getDonViTinh() async {
    return await _baseData.getListMap('TDM_DonViTinh', orderBy: 'DVT');

  }
}
