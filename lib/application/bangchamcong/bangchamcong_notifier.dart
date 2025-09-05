import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/data/data.dart';
import 'package:string_validator/string_validator.dart';

class BangChamCongNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  BangChamCongNotifier() : super([]);
  final _rp = BangChamCongRepository();

  Future<void> get(int thang, String nam) async {
    state = await _rp.get(thang.toString(), nam);
  }

  Future<bool> updateMaNV(String maNV, int id) async => await _rp.updateMaNV(maNV, id);

  Future<bool> updateN(String n, String field, int id) async => await _rp.updateN(n, field, id);
  Future<bool> updateConTien(double tien, int id, String n, String maCCM) async {
    final getMaCC = await _rp.getN(id, n);
    final getSoCongCu = await _rp.getSoCong(getMaCC)??0;
    final getSoCongMoi = await _rp.getSoCong(maCCM)??0;
    final soCong =toDouble(getSoCongMoi.toString()) - toDouble(getSoCongCu.toString());
    return await _rp.updateCongTien(tien+soCong, id);
  }

  Future<int> addMaNV(String maNV, String date) async => await _rp.addMaNV(maNV, date);

  Future<bool> delete(int id) async => await _rp.delete(id);
}
