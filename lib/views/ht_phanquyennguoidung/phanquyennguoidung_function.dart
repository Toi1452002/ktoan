import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/application/application.dart';
import 'package:pm_ketoan/data/data.dart';

import '../../core/app_contraint/menu_app.dart';

class PhanQuyenNguoiDungFunction {
  Future<List<UserModel>> getUser() async {
    final data = await UserRepository().getUserPQ();
    return data.map((e) => UserModel.fromMap(e)).toList();
  }

  Future<List<String>>  getListKChoPhep(String userName) async {
    List<String> x = [];
    final data = await PhanQuyenRepository().getListMC1(userName);
    final data1 = await PhanQuyenRepository().getListMC2(userName);
    final data2 = await PhanQuyenRepository().getListHangMuc(userName);
    if (data.isNotEmpty) {
      x.addAll(data.map((e) => e['MaC1'].toString()).toList());
    }
    if (data1.isNotEmpty) {
      x.addAll(data1.map((e) => e['MaC2'].toString()).toList());
    }
    if (data2.isNotEmpty) {
      x.addAll(data2.map((e) => e['TenForm'].toString()).toList());
    }
    return x;
  }

  Future<void> getChoPhep(String userName, int type, String ma, WidgetRef ref) async {
    getListKChoPhep(userName);
    final result = await PhanQuyenRepository().getChoPhep(userName, type, ma);
    if (result == 1) {
      ref.read(choPhepProvider.notifier).state = true;
    } else {
      ref.read(choPhepProvider.notifier).state = false;
    }
  }

  Future<void> updateChoPhep(String userName, int type, String ma, bool value, WidgetRef ref) async {
    final result = await PhanQuyenRepository().updateChoPhep(userName, type, ma, value ? 1 : 0);
    if (result) {
      ref.read(choPhepProvider.notifier).state = value;
    }
  }

  MapEntry? getMa(String title) {
    final m = mMenu.entries.where((e) => e.value.title == title);
    final m1 = mMenu1.entries.where((e) => e.value.title == title);
    final m2 = mMenu2.entries.where((e) => e.value.title == title);

    if (m.isNotEmpty) {
      return MapEntry(m.first.key, 0);
    }
    if (m1.isNotEmpty) {
      if(m1.first.value.hasChild){
        return MapEntry(m1.first.key, 1);
      }else{
        return MapEntry(m1.first.key, 2);
      }

    }
    if (m2.isNotEmpty) {
      return MapEntry(m2.first.key, 2);
    }

    return null;
  }
}
