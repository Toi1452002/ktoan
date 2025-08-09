import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/data/data.dart';


class BangTaiKhoanNotifier extends StateNotifier<List<Map<String,dynamic>>> {
  BangTaiKhoanNotifier() : super([]){
    get();
  }

  final _rp = BangTaiKhoanRepository();

  Future<void> get() async => state = await _rp.getList();

  Future<bool> delete(int id) async => await _rp.delete(id);

  Future<int> add(Map<String, dynamic> map) async => await _rp.add(map);

  Future<bool> update(Map<String, dynamic> map) async => await _rp.update(map);

}