import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/data/data.dart';

class NhomHangNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  NhomHangNotifier() : super([]) {
    getNhomHang();
  }

  final _rp = NhomhangRepository();

  Future<void> getNhomHang() async {
    state = await _rp.getList();
  }

  Future<int> add(String value) async {
    return await _rp.add({'NhomHang': value});
  }

  Future<void> update(String value, int id) async {
    await _rp.update({'ID': id, 'NhomHang': value});
  }

  Future<bool> delete(int id) async {
    return await _rp.delete(id);
  }
}
