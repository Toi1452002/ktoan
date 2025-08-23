import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/data/data.dart';

class PCGTNotifier extends StateNotifier<List<PCGTModel>> {
  PCGTNotifier() : super([]);
  final _rp = NhanVienRepository();

  Future<void> getPCGT({String maNV = ''}) async {
    final data = await _rp.getPCGT(maNV: maNV);
    state = data.map((e) => PCGTModel.fromMap(e)).toList();
  }

  void updateData(String maPC, dynamic value) {
    state.firstWhere((e) => e.MaPC == maPC).SoTieuChuan = value;
  }

  Future<void> addData(String maNV) async {
    await _rp.deletePCGT(maNV);
    await _rp.addPCGT(
      state.map((e) {
        e = e.copyWith(MaNV: maNV);
        return e.toMap();
      }).toList(),
    );
  }
}
