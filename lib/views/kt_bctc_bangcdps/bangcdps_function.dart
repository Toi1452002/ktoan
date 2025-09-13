import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:pm_ketoan/core/core.dart';
import 'package:pm_ketoan/data/data.dart';
import 'package:pm_ketoan/views/dm_bangtaikhoan/bke_chitiet_taikhoan_view.dart';
import 'package:string_validator/string_validator.dart';
import 'package:trina_grid/trina_grid.dart';

class BangCDPSFunction {
  final _rp = BangCDPSRepository();

  Future<List<Map<String, dynamic>>> xemSoLieu({int type = 4}) async {
    switch (type) {
      case 0:
        return await _rp.xemTatCa();
      case 1:
        return await _rp.xemTKCha();
      case 2:
        return await _rp.xemTKCon();
      case 3:
        return await _rp.xemTKCoPS();
      case 4:
        return await _rp.xemTKConCoPS();
      default:
        return [];
    }
  }

  Future<void> onThucHien(int type, String nam, {required int thang, required int quy}) async {
    await _rp.chepBangTaiKhoan();
    String tuNgay = '';
    String denNgay = '';
    int year = int.tryParse(nam) ?? DateTime.now().year;
    switch (type) {
      case 0: //Thang
        tuNgay = Helper.yMd(DateTime(year, thang, 1));
        denNgay = Helper.yMd(DateTime(year, thang, ngayCuoiThang(year, thang)));
        break;
      case 1: //Quy
        tuNgay = '$year-${mQuy[quy]?.first}-01';
        denNgay = '$year-${mQuy[quy]?.last}-${ngayCuoiThang(year, int.parse(mQuy[quy]!.last))}';
        break;
      case 2: //nam
        tuNgay = '$year-01-01';
        denNgay = '$year-12-31';
        break;
    }

    await layPSDKy(tuNgay);
    await ghiPSNo(tuNgay, denNgay);
    await ghiPSCo(tuNgay, denNgay);
    await _rp.tinhSoDuCK();
    await _rp.tinhTongNhom();
  }

  void onLuu(int type, String nam, {required int thang, required int quy}) async {
    String denNgay = '';
    int year = int.tryParse(nam) ?? DateTime.now().year;

    switch (type) {
      case 0: //Thang
        denNgay = DateFormat('yyyy-MM').format(DateTime(year, thang, 1));
        break;
      case 1: //Quy
        denNgay = '$year-${mQuy[quy]?.last}';
        break;
      case 2: //nam
        denNgay = '$year';
        break;
    }
    await ghiDKTK(denNgay);
  }

  Future<void> layPSDKy(String thang) async {
    final lThang = DateFormat('yyyy-MM').format(toDate(luiThang(thang))!);
    final btk = await DauKyRepository().getCDPS_BTK(lThang);
    List<Map<String, dynamic>> lstUD = [];
    for (var x in btk) {
      if (x['MaTK'] != '4212') {
        lstUD.add({'MaTK': x['MaTK'], 'DKNo': x['DKNo'], 'DKCo': x['DKCo']});
      }
    }
    await _rp.updateTK(lstUD);
  }

  Future<void> ghiPSNo(String tuNgay, String denNgay) async {
    final data = await _rp.getPsNo(tuNgay, denNgay);
    List<Map<String, dynamic>> lstUD = [];
    for (var x in data) {
      lstUD.add({'MaTK': x['TKNo'], 'PSNo': x['SoPS']});
    }
    await _rp.updateTK(lstUD);
  }

  Future<void> ghiPSCo(String tuNgay, String denNgay) async {
    final data = await _rp.getPsCo(tuNgay, denNgay);
    List<Map<String, dynamic>> lstUD = [];
    for (var x in data) {
      lstUD.add({'MaTK': x['TKCo'], 'PSCo': x['SoPS']});
    }
    await _rp.updateTK(lstUD);
  }

  Future<void> ghiDKTK(String thang) async {
    final tmp = await _rp.getTmpGhiDKTK();
    final dkTK = await BangTaiKhoanRepository().getList();

    for (var x in tmp) {
      if (toInt(x['MaTK'].toString()[0]) <= 4) {
        if (dkTK.indexWhere((e) => e['Thang'] == thang && e['MaTK'] == x['MaTK']) == -1) {
          //Insert
          if ((x['CKNo'] ?? 0 + x['CKCo'] ?? 0) != 0) {
            await _rp.addDKTK({'MaTK': x['MaTK'], 'Thang': thang, 'DKy': 0});
            // lstADD.add();
          }
        }

        if ((x['CKNo'] ?? 0 + x['CKCo'] ?? 0) != 0 && x['MaTK'] != '4212') {
          await _rp.updateDKTK({'MaTK': x['MaTK'], 'Thang': thang, 'DKNo': x['CKNo'] ?? 0, 'DKCo': x['CKCo'] ?? 0});
          // lstUD.add();
        }

        ///tinh toan loi nhuan nam nay gop vao nam truoc
        if (x['MaTK'] == '4212') {
          if (dkTK.indexWhere((e) => e['Thang'] == thang && e['MaTK'] == '4211') == -1) {
            await _rp.addDKTK({'MaTK': '4211', 'Thang': thang});
          }
          final ln4211 = await _rp.tinhLN4211();
          if (ln4211 != null) {
            if (ln4211 > 0) {
              await _rp.updateDKTK({'MaTK': '4211', 'Thang': thang, 'DKNo': ln4211});
            } else {
              await _rp.updateDKTK({'MaTK': '4211', 'Thang': thang, 'DKCo': ln4211 * -1});
            }
          }
        }
      }
    }

    CustomAlert.success('Lưu thành công');
  }

  void showSoCTTK(TrinaGridOnRowDoubleTapEvent event, BuildContext context, String year){
    if(event.cell.column.field == 'MaTK'){
      BangKeChiTietTaiKhoanView.show(context, year, event.cell.value);
    }
  }

  int ngayCuoiThang(int nam, int thang) {
    return DateTime(nam, thang + 1, 0).day;
  }

  String luiThang(String thang) {
    final date = toDate(thang);
    int newMonth = date!.month - 1;
    int newYear = date.year;

    // Nếu tháng giảm về 0, chuyển về tháng 12 của năm trước
    if (newMonth == 0) {
      newMonth = 12;
      newYear -= 1;
    }

    // Kiểm tra ngày hợp lệ (tránh trường hợp ngày không tồn tại trong tháng mới)
    int newDay = date.day;
    int daysInNewMonth = DateTime(newYear, newMonth + 1, 0).day;
    if (newDay > daysInNewMonth) {
      newDay = daysInNewMonth; // Lấy ngày cuối cùng của tháng mới
    }

    return Helper.yMd(DateTime(newYear, newMonth, newDay));
  }
}
