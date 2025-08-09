import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/data/data.dart';

class PhieuXuatCTNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  PhieuXuatCTNotifier() : super([]);

  final _rp = PhieuXuatCTRepository();

  Future<void> getPXCT(int maID) async {
    state = await _rp.get(maID);
  }

  Future<bool> updateMaHang(int ma, int id, {double soLg = 0}) async => await _rp.updateMaHang(ma, id, soLg: soLg);

  Future<int> addMaHang(int idHH, int maID) async => await _rp.addMaHang(idHH, maID);

  Future<void> updateTenHH(String val, int id) async => await _rp.updateTenHH(val, id);

  Future<void> updateDVT(String val, int id) async => await _rp.updateDVT(val, id);

  Future<void> updateSoLg(double val, int id, double thanhTien) async => await _rp.updateSoLg(val, id, thanhTien);

  Future<void> updateDonGia(double val, int id, double thanhTien) async => await _rp.updateDonGia(val, id, thanhTien);

  Future<void> updateThanhTien(double val, int id, double donGia) async => await _rp.updateThanhTien(val, id, donGia);

  Future<void> updateTkNo(String val, int id) async => await _rp.updateTkNo(val, id);

  Future<void> updateTkCo(String val, int id) async => await _rp.updateTkCo(val, id);

  Future<bool> deleteRow(int id) async => await _rp.deleteRow(id);
}
