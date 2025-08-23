import 'package:pm_ketoan/core/core.dart';
import 'package:pm_ketoan/data/repository/z_base_repository.dart';

class PhieuNhapRepository {
  static const String name = "TNX_PhieuNhap";
  static const String view = "V_PhieuNhap";
  static const String bKePhieuNhap = "VBC_PhieuNhap";

  final _baseData = BaseRepository();

  Future<Map<String, dynamic>> get({int? stt}) async {
    return await _baseData.getMap(view, orderBy: "STT DESC",where: stt==null?null:"STT = $stt");
  }

  Future<Map<String, dynamic>> getTheoSTT(int stt) async {
    return await _baseData.getMap(view, where: "STT = ?", whereArgs: [stt]);
  }

  Future<dynamic> getNumRow() async {
    return await _baseData.getCell(view, field: "COUNT(*)");
  }

  Future<int> add(Map<String, dynamic> map) async {
    final rp = await _baseData.addMap(name, map);
    if (rp.status == ResponseType.success) {
      return rp.data;
    } else {
      Exception(rp.message);
      return 0;
    }
  }

  Future<String> getMaPhieuCuoi() async {
    final data = await _baseData.getMap(view, orderBy: "STT DESC");
    if (data.isEmpty) {
      return '';
    } else {
      return data['Phieu'];
    }
  }

  Future<void> updateKhoa(int value, int id) async =>
      await _baseData.updateMap(name, {'Khoa': value}, where: "ID = $id");

  Future<void> updateNgay(String ngay, int id) async =>
      await _baseData.updateMap(name, {'Ngay': ngay, 'NgayCT': ngay}, where: "ID = $id");

  Future<void> updateNgayCT(String ngayCT, int id) async =>
      await _baseData.updateMap(name, {'NgayCT': ngayCT}, where: "ID = $id");

  Future<void> updateKNhap(String ma, int id) async => await _baseData.updateMap(name, {'MaNX': ma}, where: "ID = $id");

  Future<void> updateKyHieu(String val, int id) async =>
      await _baseData.updateMap(name, {'KyHieu': val}, where: "ID = $id");

  Future<void> updateSoCT(String val, int id) async =>
      await _baseData.updateMap(name, {'SoCT': val}, where: "ID = $id");

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

  Future<bool> delete(int id) async {
    final rp = await _baseData.delete(name, where: "ID = $id");
    if (rp.status == ResponseType.success) {
      return true;
    } else {
      CustomAlert.error(rp.message.toString());
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getBKeHangNhap({String? thang, int? quy, int nam = 2000}) async {
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
    final rp = await _baseData.getListMap(bKePhieuNhap, where: where);
    if (rp.status == ResponseType.success) {
      return rp.data;
    } else {
      errorSql(rp.message);
      return [];
    }
  }
}
