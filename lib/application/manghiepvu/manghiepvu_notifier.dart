import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/data/data.dart';

class MaNghiepVuNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  MaNghiepVuNotifier() : super([]){
    getListMNV();
  }

  final _rp = MaNghiepVuRepository();

  Future<void> getListMNV() async => state = await _rp.getList();

  Future<int> addMNV(Map<String, dynamic> map) async => await _rp.add(map);

  Future<bool> updateMNV(Map<String, dynamic> map) async => await _rp.update(map);

  Future<bool> deleteMNV(int id) async => await _rp.delete(id);
}
