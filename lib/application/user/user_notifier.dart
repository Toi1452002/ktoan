import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/data/data.dart';

class UserNotifier extends StateNotifier<List<UserModel>> {
  UserNotifier() : super([]) {
    get();
  }

  final _rp = UserRepository();

  Future<void> get() async {
    final data = await _rp.getList();
    state = data.map((e) => UserModel.fromMap(e)).toList();
  }

  Future<int> add(UserModel user) async {
    return await _rp.addUser(user.toMap());
  }

  Future<bool> update(UserModel user) async {
    return await _rp.updateUser(user.toMap());
  }

  Future<UserModel> getUser(int id) async {
    final data = await _rp.getUser(id);
    return UserModel.fromMap(data);
  }

  Future<bool> delete(int  id) async{
    return await _rp.deleteUser(id);
  }
}
