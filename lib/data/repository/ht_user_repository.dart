import 'package:pm_ketoan/core/core.dart';
import 'package:pm_ketoan/data/models/user_model.dart';
import 'package:pm_ketoan/data/repository/z_repository.dart';

import 'z_base_repository.dart';

class UserRepository {
  static const name = 'T00_User';
  final _cnn = BaseRepository();

  Future<UserModel?> login(String userName, String passWord) async {
    try {
      final cnn = await connectData();
      final user = await cnn!.query(name, where: "Username = ? and Password = ?", whereArgs: [userName, passWord]);
      if (user.isEmpty) {
        CustomAlert.warning('Đăng nhập thất bại', title: 'LOGIN');
        return null;
      }
      return UserModel.fromMap(user.first);
    } catch (e) {
      errorSql(e);
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getList() async {
    final rp = await _cnn.getListMap(
      name,
      columns: ['ID', 'Username', 'HoTen', 'Email', 'DienThoai'],
      orderBy: 'Username',
    );
    if (rp.status == ResponseType.success) {
      return rp.data;
    } else {
      errorSql(rp.message);
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getUserPQ() async {
    final rp = await _cnn.getListMap(name, columns: ['ID', 'Username', 'HoTen'], orderBy: 'Username', where: "ID !=1");
    if (rp.status == ResponseType.success) {
      return rp.data;
    } else {
      errorSql(rp.message);
      return [];
    }
  }

  Future<int> addUser(Map<String, dynamic> map) async {
    final rp = await _cnn.addMap(name, map);
    if (rp.status == ResponseType.success) {
      return rp.data;
    } else {
      errorSql(rp.message);
      return 0;
    }
  }

  Future<bool> updateUser(Map<String, dynamic> map) async {
    final rp = await _cnn.updateMap(name, map, where: "ID = ?", whereArgs: [map['ID']]);
    if (rp.status == ResponseType.success) {
      return true;
    } else {
      errorSql(rp.message);
      return false;
    }
  }

  Future<Map<String, dynamic>> getUser(int id) async {
    return await _cnn.getMap(name, where: 'ID = ?', whereArgs: [id]);
  }

  Future<bool> deleteUser(int id) async {
    final rp = await _cnn.delete(name, where: "ID = $id");
    if (rp.status == ResponseType.success) {
      return true;
    } else {
      errorSql(rp.message);
      return false;
    }
  }


}
