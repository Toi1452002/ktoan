import '../../core/core.dart';
import 'z_base_repository.dart';

class PhieuXuatRepository {
  static const String name = "TNX_PhieuXuat";
  static const String view = "V_PhieuXuat";
  static const String bKePhieuXuat = "VBC_PhieuXuat";
  static const String bKeHangBan = "VNX_BangKeHangBan";

  final _baseData = BaseRepository();

  Future<Map<String, dynamic>> get({int? stt}) async {
    return await _baseData.getMap(view, where: stt == null ? null : "STT = $stt", orderBy: "STT DESC");
  }

  Future<dynamic> getNumRow() async {
    return await _baseData.getCell(view, field: "COUNT(*)");
  }

  Future<Map<String, dynamic>> getTheoSTT(int stt) async {
    return await _baseData.getMap(view, where: "STT = ?", whereArgs: [stt]);
  }

  Future<String> getMaPhieuCuoi() async {
    final data = await _baseData.getMap(view, orderBy: "STT DESC");
    if (data.isEmpty) {
      return '';
    } else {
      return data['Phieu'];
    }
  }

  Future<int> add(Map<String, dynamic> map) async {
    return await _baseData.addMap(name, map);

  }

  Future<void> updateKhoa(int value, int id) async =>
      await _baseData.updateMap(name, {'Khoa': value}, where: "ID = $id");

  Future<void> updateNgay(String ngay, int id) async =>
      await _baseData.updateMap(name, {'Ngay': ngay, 'NgayCT': ngay}, where: "ID = $id");

  Future<void> updateNgayCT(String ngayCT, int id) async =>
      await _baseData.updateMap(name, {'NgayCT': ngayCT}, where: "ID = $id");

  Future<void> updateKXuat(String ma, int id) async => await _baseData.updateMap(name, {'MaNX': ma}, where: "ID = $id");

  Future<void> updateKyHieu(String val, int id) async =>
      await _baseData.updateMap(name, {'KyHieu': val}, where: "ID = $id");

  Future<void> updateSoCT(String val, int id) async =>
      await _baseData.updateMap(name, {'SoHD': val}, where: "ID = $id");

  Future<void> updatePTTT(String val, int id) async =>
      await _baseData.updateMap(name, {'PTTT': val}, where: "ID = $id");

  Future<void> updateMaKhach(String val, int id) async =>
      await _baseData.updateMap(name, {'Makhach': val}, where: "ID = $id");

  Future<void> updateDienGiai(String val, int id) async =>
      await _baseData.updateMap(name, {'DienGiai': val}, where: "ID = $id");

  Future<void> updateTKNo(String val, int id) async =>
      await _baseData.updateMap(name, {'TKNo': val}, where: "ID = $id");

  Future<void> updateTKCo(String val, int id) async =>
      await _baseData.updateMap(name, {'TKCo': val}, where: "ID = $id");

  Future<void> updateTKVatNo(String val, int id) async =>
      await _baseData.updateMap(name, {'TKVatNo': val}, where: "ID = $id");

  Future<void> updateTKVatCo(String val, int id) async =>
      await _baseData.updateMap(name, {'TKVatCo': val}, where: "ID = $id");

  Future<void> updateThueSuat(String val, int id) async =>
      await _baseData.updateMap(name, {'ThueSuat': val}, where: "ID = $id");

  Future<void> updateCongTien(double val, int id) async =>
      await _baseData.updateMap(name, {'CongTien': val}, where: "ID = $id");

  Future<void> updateTienThue(double val, int id) async =>
      await _baseData.updateMap(name, {'TienThue': val}, where: "ID = $id");

  Future<void> updateKChiuThue(int val, int id) async =>
      await _baseData.updateMap(name, {'KChiuThue': val}, where: "ID = $id");

  Future<bool> delete(int id) async {
    return await _baseData.delete(name, where: "ID = $id");

  }

  Future<List<Map<String, dynamic>>> getBKePhieuXuat({String? thang, int? quy, int nam = 2000}) async {
    String? where;
    if (thang == null && quy == null) {
      where = "strftime('%Y', Ngay) = '$nam'";
    }
    if (thang != null) {
      if (thang.length == 1) thang = "0$thang";
      where = "strftime('%Y', Ngay) = '$nam' AND strftime('%m', Ngay) = '$thang'";
    }
    if (quy != null) {
      where =
          '''strftime('%Y', Ngay) = '$nam' AND strftime('%m', Ngay) 
        BETWEEN '${mQuy[quy]?.first}' AND '${mQuy[quy]?.last}'
        ''';
    }
    return await _baseData.getListMap(bKePhieuXuat, where: where);

  }
  Future<List<Map<String, dynamic>>> getBKeHangBan({String? thang, int? quy, int nam = 2000}) async {
    String? where;
    if (thang == null && quy == null) {
      where = "strftime('%Y', Ngay) = '$nam'";
    }
    if (thang != null) {
      if (thang.length == 1) thang = "0$thang";
      where = "strftime('%Y', Ngay) = '$nam' AND strftime('%m', Ngay) = '$thang'";
    }
    if (quy != null) {
      where =
      '''strftime('%Y', Ngay) = '$nam' AND strftime('%m', Ngay) 
        BETWEEN '${mQuy[quy]?.first}' AND '${mQuy[quy]?.last}'
        ''';
    }
    return await _baseData.getListMap(bKeHangBan, where: where);

  }
}
