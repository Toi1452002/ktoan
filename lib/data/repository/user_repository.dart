import 'package:pm_ketoan/core/core.dart';
import 'package:pm_ketoan/data/models/user_model.dart';
import 'package:pm_ketoan/data/repository/repository.dart';

import 'base_repository.dart';

class UserRepository {
  static const name = 'T00_User';

  Future<UserModel?> login(String userName, String passWord) async {
    try {
      final cnn = await connectData();
      final user = await cnn!.query(name, where: "Username = ? and Password = ?", whereArgs: [userName, passWord]);
      if(user.isEmpty){
        CustomAlert.warning('Đăng nhập thất bại',title: 'LOGIN');
        return null;
      }
      return UserModel.fromMap(user.first);
    } catch (e) {
      errorSql(e);
      return null;
    }
  }
}
