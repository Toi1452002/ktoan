import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/data/data.dart';

class PhieuThuCTNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  PhieuThuCTNotifier() : super([]);
  final _rp = PhieuThuCTRepository();

  Future<void> get(int maID) async {
    state = await _rp.get(maID);
  }

  Future<bool> delete(int id) async {
    return await _rp.deleteRow(id);
  }

  Future<int> addNoiDung(String val, int maID) async {
    return await _rp.addNoiDung(val, maID);
  }

  Future<int> addSoTien(double val, int maID) async {
    return await _rp.addSoTien(val, maID);
  }

  Future<void> updateNoiDung(String val, int id) async {
    return await _rp.updateNoiDung(val, id);
  }

  Future<void> updateSoTien(double val, int maID) async {
    return await _rp.updateSoTien(val, maID);
  }
}
