import 'package:pm_ketoan/core/core.dart';
import 'package:pm_ketoan/data/data.dart';
import 'package:pm_ketoan/data/repository/z_base_repository.dart';

class SoTienRepository {
  static const soTienGui = "VTC_SoTienGui";
  static const soTienMat = "VTC_SoTienMat";

  final _cnn = BaseRepository();

  Future<List<Map<String, dynamic>>> getSoTienMat({String? tN, String? dN}) async {
    if (tN == 'null') tN = Helper.yMd(DateTime.now().copyWith(day: 1));
    if (dN == 'null') dN = Helper.sqlDateTimeNow();
    final rp = await _cnn.getListMap(soTienMat, where: "Ngay BETWEEN '$tN' AND '$dN'");
    if (rp.status == ResponseType.success) {
      return rp.data;
    } else {
      errorSql(rp.data);
      return [];
    }
  }

  Future<Map<String, dynamic>> getTonSoTienMat({String? tN, String? dN}) async {
    if (tN == 'null') tN = Helper.yMd(DateTime.now().copyWith(day: 1));
    if (dN == 'null') dN = Helper.sqlDateTimeNow();
    final dKyTaiKhoan = await _cnn.getCell(
      DauKyRepository.nameDkyBTK,
      field: 'SUM(DKNo)',
      condition: "MaTK LIKE '111%'",
    )??0;
    final ton = await _cnn.getCell(soTienMat, field: "SUM(Thu)-SUM(Chi)", condition: "Ngay < '$tN'")??0;
    final tonHT = await _cnn.getCell(soTienMat, field: "SUM(Thu)-SUM(Chi)", condition: "Ngay BETWEEN '$tN' AND '$dN'")??0;

    final x = dKyTaiKhoan + ton ;
    final y =  tonHT;
    return {'DKy': x, 'CKy': y + x};
  }

  Future<List<Map<String, dynamic>>> getSoTienGui({String? tN, String? dN}) async {
    if (tN == 'null') tN = Helper.yMd(DateTime.now().copyWith(day: 1));
    if (dN == 'null') dN = Helper.sqlDateTimeNow();
    final rp = await _cnn.getListMap(soTienGui, where: "Ngay BETWEEN '$tN' AND '$dN'");
    if (rp.status == ResponseType.success) {
      return rp.data;
    } else {
      errorSql(rp.data);
      return [];
    }
  }

  Future<Map<String, dynamic>> getTonSoTienGui({String? tN, String? dN}) async {
    if (tN == 'null') tN = Helper.yMd(DateTime.now().copyWith(day: 1));
    if (dN == 'null') dN = Helper.sqlDateTimeNow();
    final dKyTaiKhoan = await _cnn.getCell(
      DauKyRepository.nameDkyBTK,
      field: 'SUM(DKNo)',
      condition: "MaTK LIKE '112%'",
    )??0;
    final ton = await _cnn.getCell(soTienGui, field: "SUM(Thu)-SUM(Chi)", condition: "Ngay < '$tN'")??0;
    final tonHT = await _cnn.getCell(soTienGui, field: "SUM(Thu)-SUM(Chi)", condition: "Ngay BETWEEN '$tN' AND '$dN'")??0;

    final x = dKyTaiKhoan + ton ;
    final y =  tonHT;
    return {'DKy': x, 'CKy': y + x};
  }
}
