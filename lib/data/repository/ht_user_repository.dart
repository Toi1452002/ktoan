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
    return await _cnn.getListMap(
      name,
      columns: ['ID', 'Username', 'HoTen', 'Email', 'DienThoai'],
      orderBy: 'Username',
    );

  }

  Future<List<Map<String, dynamic>>> getUserPQ() async {
    return await _cnn.getListMap(name, columns: ['ID', 'Username', 'HoTen'], orderBy: 'Username', where: "ID !=1");

  }

  Future<int> addUser(Map<String, dynamic> map) async {
    final rp = await _cnn.addMap(name, map);
    List<String> lstMenu1 = [];
    List<String> lstMenu1HM = [];
    mMenu1.forEach((k, v) {
      if (v.hasChild) {
        lstMenu1.add(k);
      } else {
        lstMenu1HM.add(k);
      }
    });

    for (var e in mMenu2.keys) {
      lstMenu1HM.add(e);
    }

    await _cnn.addRows(
      PhanQuyenRepository.mc1,
      mMenu.keys.map((e) => {'MaC1': e, 'UserName': map['Username']}).toList(),
    );
    await _cnn.addRows(PhanQuyenRepository.mc2, lstMenu1.map((e) => {'MaC2': e, 'UserName': map['Username']}).toList());
    await _cnn.addRows(
      PhanQuyenRepository.hangMuc,
      lstMenu1HM.map((e) => {'TenForm': e, 'UserName': map['Username']}).toList(),
    );

    return rp;
  }

  Future<bool> updateUser(Map<String, dynamic> map) async {
    return await _cnn.updateMap(name, map, where: "ID = ?", whereArgs: [map['ID']]);

  }

  Future<Map<String, dynamic>> getUser(int id) async {
    return await _cnn.getMap(name, where: 'ID = ?', whereArgs: [id]);
  }

  Future<bool> deleteUser(int id) async {
    return await _cnn.delete(name, where: "ID = $id");

  }
}
