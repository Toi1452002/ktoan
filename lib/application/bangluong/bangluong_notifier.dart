import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/data/data.dart';

class BangLuongNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  BangLuongNotifier() : super([]) {
    getData();
  }

  final _rp = BangLuongRepository();

  Future<void> getData({String? thang, String? nam}) async {
    state = await _rp.get(thang ?? DateTime.now().month.toString(), nam ?? DateTime.now().year.toString());
  }

  Future<int> addMaNV(String maNV, String date) async =>
      await _rp.addMaNV(maNV, date);

  Future<bool> updateMaNV(int id, String maNV) async =>
      await _rp.updateMaNV(id, maNV);

  Future<bool> updateLuongCB(int id, double val) async => await _rp.updateLuongCB(id, val);

  Future<bool> updateNgayCong(int id, double val) async => await _rp.updateNgayCong(id, val);

  Future<bool> updateTamUng(int id, double val) async => await _rp.updateTamUng(id, val);

  Future<bool> delete(int id) async => await _rp.delete(id);
}
