import 'package:pm_ketoan/data/repository/base_repository.dart';

import '../../core/core.dart';

class PhieuChiRepository {
  static const name = "TTC_PhieuChi";
  static const view = "V_PhieuChi";
  final _cnn = BaseRepository();

  Future<Map<String, dynamic>> get() async {
    return await _cnn.getMap(view, orderBy: "STT DESC");
  }

  Future<Map<String, dynamic>> getTheoSTT(int stt) async {
    return await _cnn.getMap(view, where: "STT = ?", whereArgs: [stt]);
  }

  Future<dynamic> getNumRow() async {
    return await _cnn.getCell(view, field: "COUNT(*)");
  }

  Future<String> getMaPhieuCuoi() async {
    final data = await _cnn.getCell(name, field: 'Phieu', condition: "ID = (SELECT MAX(ID) FROM $name)");
    return data??'';
  }

  Future<bool> delete(int id) async {
    final rp = await _cnn.delete(name, where: "ID = $id");
    if (rp.status == ResponseType.success) {
      return rp.data;
    } else {
      CustomAlert.error(rp.message.toString());
      return false;
    }
  }

  Future<int> add(Map<String, dynamic> map) async {
    final rp = await _cnn.addMap(name, map);
    if (rp.status == ResponseType.success) {
      return rp.data;
    } else {
      Exception(rp.message);
      return 0;
    }
  }

  Future<void> updateKhoa(int value, int id) async => await _cnn.updateMap(name, {'Khoa': value}, where: "ID = $id");

  Future<void> updateNgay(String ngay, int id) async => await _cnn.updateMap(name, {'Ngay': ngay}, where: "ID = $id");

  Future<void> updateKChi(String ma, int id) async => await _cnn.updateMap(name, {'MaTC': ma}, where: "ID = $id");

  Future<void> updateMaKhach(String maKhach, String ten, String diaChi, int id) async =>
      await _cnn.updateMap(name, {'MaKhach': maKhach, 'TenKhach': ten, 'DiaChi': diaChi}, where: "ID = $id");

  Future<void> updateMaNV(String maNV, String ten, String diaChi, int id) async =>
      await _cnn.updateMap(name, {'MaNV': maNV, 'TenKhach': ten, 'DiaChi': diaChi}, where: "ID = $id");

  Future<void> updateTenKhach(String val, int id) async =>
      await _cnn.updateMap(name, {'TenKhach': val}, where: "ID = $id");

  Future<void> updateDiaChi(String val, int id) async => await _cnn.updateMap(name, {'DiaChi': val}, where: "ID = $id");

  Future<void> updateNguoiNhan(String val, int id) async =>
      await _cnn.updateMap(name, {'NguoiNhan': val}, where: "ID = $id");

  Future<void> updateNguoiChi(String val, int id) async =>
      await _cnn.updateMap(name, {'NguoiChi': val}, where: "ID = $id");

  Future<void> updateSoTien(double val, int id) async => await _cnn.updateMap(name, {'SoTien': val}, where: "ID = $id");

  Future<void> updateTKNo(String val, int id) async => await _cnn.updateMap(name, {'TKNo': val}, where: "ID = $id");

  Future<void> updateTKCo(String val, int id) async => await _cnn.updateMap(name, {'TKCo': val}, where: "ID = $id");

  Future<void> updateNoiDung(String val, int id) async =>
      await _cnn.updateMap(name, {'NoiDung': val}, where: "ID = $id");

  Future<void> updateSoCT(String val, int id) async => await _cnn.updateMap(name, {'SoCT': val}, where: "ID = $id");

  Future<void> updatePTTT(String val, int id) async => await _cnn.updateMap(name, {'PTTT': val}, where: "ID = $id");
}
