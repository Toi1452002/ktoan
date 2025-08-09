import 'package:pm_ketoan/core/core.dart';
import 'package:pm_ketoan/data/data.dart';
import 'package:pm_ketoan/data/repository/base_repository.dart';

class PhieuXuatCTRepository {
  static const view = "V_PhieuXuatCT";
  static const name = "TNX_PhieuXuatCT";
  final _baseData = BaseRepository();

  Future<List<Map<String, dynamic>>> get(int maID) async {
    final rp = await _baseData.getListMap(view, where: "MaID = ?", whereArgs: [maID]);
    if (rp.status == ResponseType.success) {
      return rp.data;
    } else {
      CustomAlert.error(rp.message.toString());
      return [];
    }
  }

  Future<bool> updateMaHang(int ma, int id, {double soLg = 0}) async {
    final data = await _baseData.getMap(HangHoaRepository.view, where: "ID = ?", whereArgs: [ma]);
    final rp = await _baseData.updateMap(
      name,
      {
        'ItemID': ma,
        'TenHH': data['TenHH'],
        'DonGia': data['GiaBan'],
        'DVT': data['DVT'],
        'ThanhTien': data['GiaBan'] * soLg,
      },
      where: "ID = ?",
      whereArgs: [id],
    );
    if (rp.status == ResponseType.success) {
      return true;
    } else {
      errorSql(rp.message!);
      return false;
    }
  }

  Future<int> addMaHang(int idHH, int maID) async {
    final data = await _baseData.getMap(HangHoaRepository.view, where: "ID = ?", whereArgs: [idHH]);
    final rp = await _baseData.addMap(name, {
      'ItemID': idHH,
      'MaID': maID,
      'TenHH': data['TenHH'],
      'DonGia': data['GiaBan'],
      'DVT': data['DVT'],
    });
    if (rp.status == ResponseType.success) {
      return rp.data;
    } else {
      errorSql(rp.message!);
      return 0;
    }
  }

  Future<void> updateTenHH(String val, int id) async {
    await _baseData.updateMap(name, {'TenHH': val}, where: "ID = $id");
  }

  Future<void> updateDVT(String val, int id) async {
    await _baseData.updateMap(name, {'DVT': val}, where: "ID = $id");
  }

  Future<void> updateSoLg(double val, int id, double thanhTien) async {
    await _baseData.updateMap(name, {'SoLg': val, 'ThanhTien': thanhTien}, where: "ID = $id");
  }

  Future<void> updateDonGia(double val, int id, double thanhTien) async {
    await _baseData.updateMap(name, {'DonGia': val, 'ThanhTien': thanhTien}, where: "ID = $id");
  }

  Future<void> updateThanhTien(double val, int id, double donGia) async {
    await _baseData.updateMap(name, {'ThanhTien': val, 'DonGia': donGia}, where: "ID = $id");
  }

  Future<void> updateTkNo(String val, int id) async {
    await _baseData.updateMap(name, {'TKgv': val}, where: "ID = $id");
  }

  Future<void> updateTkCo(String val, int id) async {
    await _baseData.updateMap(name, {'TKkho': val}, where: "ID = $id");
  }

  Future<bool> deleteRow(int id) async {
    final rp = await _baseData.delete(name, where: 'ID =  $id');
    if (rp.status == ResponseType.success) {
      return true;
    } else {
      CustomAlert.error(rp.message.toString());
      return false;
    }
  }
}
