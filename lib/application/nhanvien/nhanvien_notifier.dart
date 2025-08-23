import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/data/data.dart';

class NhanVienNotifier extends StateNotifier<List<NhanVienModel>> {
  NhanVienNotifier() : super([]){
    get();
  }
  final _rp = NhanVienRepository();

  Future<void> get() async {
    final data = await _rp.getList();
    state = data.map((e) => NhanVienModel.fromMap(e)).toList();
  }

  Future<bool> add(NhanVienModel nhanVien) async {
    final result = await _rp.add(nhanVien.toMap());
    if (result == 0) {
      return false;
    }
    return true;
  }

  Future<bool> update(NhanVienModel nhanVien) async {
    return await _rp.update(nhanVien.toMap());
  }

  Future<bool> delete(int id) async {
    return await _rp.delete(id);
  }
}

