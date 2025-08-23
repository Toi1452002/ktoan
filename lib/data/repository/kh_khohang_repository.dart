import 'package:pm_ketoan/data/data.dart';
import 'package:pm_ketoan/data/repository/z_base_repository.dart';

import '../../core/core.dart';

class KhoHangRepository {
  static const bkHangNhap = "VBC_BangKeHangNhap";
  static const bkHangXuat = "VBC_BangKeHangXuat";
  final _cnn = BaseRepository();

  Future<List<Map<String, dynamic>>> getBKHangNhap({String? tN, String? dN}) async {
    if (tN == 'null') tN = Helper.yMd(DateTime.now().copyWith(day: 1));
    if (dN == 'null') dN = Helper.sqlDateTimeNow();
    final rp = await _cnn.getListMap(bkHangNhap, where: "Ngay BETWEEN ? AND  ?", whereArgs: [tN, dN]);
    if (rp.status == ResponseType.success) {
      return rp.data;
    } else {
      errorSql(rp.message);
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getBKHangXuat({String? tN, String? dN}) async {
    if (tN == 'null') tN = Helper.yMd(DateTime.now().copyWith(day: 1));
    if (dN == 'null') dN = Helper.sqlDateTimeNow();
    final rp = await _cnn.getListMap(bkHangXuat, where: "Ngay BETWEEN ? AND  ?", whereArgs: [tN, dN]);
    if (rp.status == ResponseType.success) {
      return rp.data;
    } else {
      errorSql(rp.message);
      return [];
    }
  }

  Future<List<dynamic>> getNhapXuatTonKho({String? tN, String? dN, String kho = ''}) async {
    if (tN == 'null') tN = Helper.yMd(DateTime.now().copyWith(day: 1));
    if (dN == 'null') dN = Helper.sqlDateTimeNow();
    final getTonKho = await _cnn.getListMap(DauKyRepository.viewDkyHH, where: "SoTon NOT NULL");
    final getHangNhap = await _cnn.getSQL('''
      SELECT MaHH, TenHH, SUM(SoLg) SoLgNhap, SUM(ThanhTien) ThanhTienNhap,DVT FROM $bkHangNhap WHERE Ngay BETWEEN '$tN' AND '$dN'
      AND TKkho = '$kho'
      GROUP BY MaHH
    ''');
    final getHangXuat = await _cnn.getSQL('''
      SELECT MaHH, TenHH, SUM(SoLg) SoLgXuat, SUM(DonGia) DonGiaXuat, SUM(ThanhTien) ThanhTienXuat FROM $bkHangXuat WHERE Ngay BETWEEN '$tN' AND '$dN'
       AND TKkho = '$kho'
      GROUP BY MaHH
    ''');
    final lst = getTonKho.data.map((e) {
      final n = getHangNhap.data.firstWhere(
        (n) => n['MaHH'] == e['MaHH'],
        orElse: () => {'DVT': '', 'SoLgNhap': 0, 'ThanhTienNhap': 0},
      );
      final x = getHangXuat.data.firstWhere(
        (x) => x['MaHH'] == e['MaHH'],
        orElse: () => {'SoLgXuat': 0, 'DonGiaXuat': 0, 'ThanhTienXuat': 0},
      );
      return {
        'TenHH': e['TenHH'].toString(),
        'DVT': n['DVT'].toString(),
        'SoTon': e['SoTon'],
        'TienDauKy': e['GiaVon'],
        'SoLgN': n['SoLgNhap'],
        'TienNhap': n['ThanhTienNhap'],
        'SoLgX': x['SoLgXuat'],
        'DonGiaXuat': x['DonGiaXuat'],
        'TienXuat': x['ThanhTienXuat'],
        'SoLgConLai': e['SoTon'] + n['SoLgNhap'] - x['SoLgXuat'],
        'TienConTai': e['GiaVon'] + n['ThanhTienNhap'] + x['ThanhTienXuat'],
      };
    }).toList();

    return lst;
  }
}
