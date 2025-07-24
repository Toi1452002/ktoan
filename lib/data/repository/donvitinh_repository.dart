import 'package:pm_ketoan/data/data.dart';

class DonViTinhRepository {
  static const name = "TDM_DonViTinh";

  Future<List<Map<String, dynamic>>> getList() async {
    try {
      final cnn = await connectData();
      final data = await cnn!.query(name);
      return data;
    } catch (e) {
      errorSql(e);
      return [];
    }
  }

  Future<bool> add(Map<String, dynamic> map) async {
    try {
      final cnn = await connectData();
      await cnn!.insert(name, map);
      return true;
    } catch (e) {
      errorSql(e);
      return false;
    }
  }
  Future<bool> update(Map<String, dynamic> map) async {
    try {
      final cnn = await connectData();
      await cnn!.update(name, map,where: "ID = ?",whereArgs: [map["ID"]]);
      return true;
    } catch (e) {
      errorSql(e);
      return false;
    }
  }
  Future<bool> delete(int id) async {
    try {
      final cnn = await connectData();
      await cnn!.delete(name, where: "ID = ?",whereArgs: [id]);
      return true;
    } catch (e) {
      errorSql(e);
      return false;
    }
  }


}
