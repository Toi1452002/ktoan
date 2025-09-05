import 'package:pm_ketoan/data/repository/z_base_repository.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../core/core.dart';
import '../data.dart';

class CongNoRepository {
  static const soMuaHang = "VBC_SoMuaHang";
  static const soBanHang = "VBC_SoBanHang";
  final _cnn = BaseRepository();

  Future<List<Map<String, dynamic>>> getSoMuaHang({
    required String tN,
    required String dN,
    required String maKhach,
  }) async {
    return await _cnn.getListMap(soMuaHang, where: "Ngay BETWEEN '$tN' AND '$dN' AND MaKhach = '$maKhach'");
    // if (rp.status == ResponseType.success) {
    //   return rp.data;
    // } else {
    //   errorSql(rp.message);
    //   return [];
    // }
  }

  Future<Map<String, dynamic>> getNoSoMuaHang({String? tN, String? dN, String maKhach = ''}) async {
    if (tN == 'null') tN = Helper.yMd(DateTime.now().copyWith(day: 1));
    if (dN == 'null') dN = Helper.sqlDateTimeNow();
    final noDauKy =
        await _cnn.getCell(DauKyRepository.nameDkyKH, field: 'SoDuNo', condition: "MaKhach = '$maKhach'") ?? 0;
    if (noDauKy != 0) {
      final ton =
          await _cnn.getCell(soMuaHang, field: "SUM(No)-SUM(Co)", condition: "Ngay < '$tN' AND MaKhach = '$maKhach'") ??
          0;
      final tonHT =
          await _cnn.getCell(
            soMuaHang,
            field: "SUM(No)-SUM(Co)",
            condition: "Ngay BETWEEN '$tN' AND '$dN'AND MaKhach = '$maKhach'",
          ) ??
          0;
      final x = noDauKy  + ton;
      final y = tonHT ;
      return {'DKy': x, 'CKy': y + x};
    } else {
      return {'DKy': 0, 'CKy': 0};
    }
  }

  Future<List<Map<String, dynamic>>> getSoBanHang({
    required String tN,
    required String dN,
    required String maKhach,
  }) async {
    return  await _cnn.getListMap(soBanHang, where: "Ngay BETWEEN '$tN' AND '$dN' AND MaKhach = '$maKhach'");
    // if (rp.status == ResponseType.success) {
    //   return rp.data;
    // } else {
    //   errorSql(rp.message);
    //   return [];
    // }
  }

  Future<Map<String, dynamic>> getNoSoBanHang({String? tN, String? dN, String maKhach = ''}) async {
    if (tN == 'null') tN = Helper.yMd(DateTime.now().copyWith(day: 1));
    if (dN == 'null') dN = Helper.sqlDateTimeNow();
    final noDauKy =
        await _cnn.getCell(DauKyRepository.nameDkyKH, field: 'SoDuNo', condition: "MaKhach = '$maKhach'") ?? 0;
    if (noDauKy != 0) {
      final ton =
          await _cnn.getCell(soBanHang, field: "SUM(No)-SUM(Co)", condition: "Ngay < '$tN' AND MaKhach = '$maKhach'") ??
              0;
      final tonHT =
          await _cnn.getCell(
            soBanHang,
            field: "SUM(No)-SUM(Co)",
            condition: "Ngay BETWEEN '$tN' AND '$dN'AND MaKhach = '$maKhach'",
          ) ??
              0;
      final x = noDauKy  + ton;
      final y = tonHT ;
      return {'DKy': x, 'CKy': y + x};
    } else {
      return {'DKy': 0, 'CKy': 0};
    }
  }

  Future<List<Map<String,  dynamic>>> getTongHopCongNo(String date) async{
    final rp = await _cnn.getSQL('''
      SELECT MaKhach, TenKH, LoaiKH, SoDuNo, 
      Sum(IIF(Kieu=='Thu', SoTien, 0)) PhaiThu,
      Sum(IIF(Kieu=='Tra', SoTien, 0)) PhaiTra
      FROM VBC_TongHopCongNo WHERE Ngay <= '$date'
      Group By MaKhach
    ''');
    // if(rp.status == ResponseType.success){
      List<Map<String, dynamic>> data = rp;
      return data.map((e)=>{
        'MaKhach': e['MaKhach']??'',
        'TenKH': e['TenKH'],
        'PhaiTra': e['PhaiTra']+(['NC','CH'].contains(e['LoaiKH']) ? e['SoDuNo']??0 :0),
        'PhaiThu': e['PhaiThu'] + (e['LoaiKH']=='KH' ? e['SoDuNo']??0 :0)
      }).toList();
    // }else{
    //   errorSql(rp.message);
    //   return [];
    // }
  }
}
