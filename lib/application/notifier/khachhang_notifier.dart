import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/data/data.dart';

class KhachHangNotifier extends StateNotifier<List<KhachHangModel>> {
  KhachHangNotifier() : super([]) {
    getListKhach();
  }

  final _rp = KhachHangRepository();

  Future<void> getListKhach({int td = 1}) async {
    final data = await _rp.getData(td: td);
    state = data.isEmpty ? [] : data.map((e) => KhachHangModel.fromMap(e)).toList();
  }

  Future<bool> addKhach(KhachHangModel khach) async {
    return await _rp.add(khach.toMap()) != 0;
  }

  Future<bool> updateKhach(KhachHangModel khach, String maKH) async {
    return await _rp.update(khach.toMap(), maKH) ;
  }

  Future<bool> deleteKhach(String maKH) async{
    return await _rp.delete(maKH);
  }

  Future<KhachHangModel> getKhach(String maKhach) async{
    final data = await _rp.getKhach(maKhach);
    return KhachHangModel.fromMap(data);
  }
}
