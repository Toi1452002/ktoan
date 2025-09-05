import 'package:pm_ketoan/core/core.dart';
import 'package:pm_ketoan/data/data.dart';
import 'package:string_validator/string_validator.dart';

import 'z_base_repository.dart';

class BangLuongRepository {
  final _cnn = BaseRepository();

  static const name = 'TTL_BangLuong';
  static const view = 'VTL_BangLuong';

  Future<List<Map<String, dynamic>>> get(String thang, String nam) async {
    if (thang.length == 1) thang = "0$thang";
    return await _cnn.getListMap(view, where: "strftime('%Y', Ngay) = '$nam' AND strftime('%m', Ngay) = '$thang'");
  }

  Future<int> addMaNV(String maNV, String date) async {
    var ngayCong = await _cnn.getCell(
      BangChamCongRepository.name,
      field: 'TongCong',
      condition: "MaNV = '$maNV' AND Ngay = '$date'",
    );
    final nv = await _cnn.getMap(NhanVienRepository.name, where: "MaNV = '$maNV'", columns: ['ChucDanh', 'LuongCB']);

    if (ngayCong == null || ngayCong == 0) {
      ngayCong = soNgayLamViec(date);
    }

    return await _cnn
        .addMap(name, {
          'MaNV': maNV,
          'Ngay': date,
          'ChucVu': nv['ChucDanh'],
          'LuongCoBan': nv['LuongCB'],
          'NgayCong': ngayCong,
        })
        .whenComplete(() async {
          await tinPhuCap(maNV, ngayCong / soNgayLamViec(date));
          await updatePC(maNV, ngayCong / soNgayLamViec(date), date);
          await updateLuongBHXH(maNV, date);
          await updateGT(maNV, date);
          await updateLuongTG(maNV, ngayCong / soNgayLamViec(date), date, nv['LuongCB']);
          await tamUng(maNV, date);
        });
  }

  Future<bool> updateMaNV(int id, String maNV) async {
    final ngay = await _cnn.getCell(name, field: 'Ngay', condition: 'ID = $id');
    final nv = await _cnn.getMap(NhanVienRepository.name, where: "MaNV = '$maNV'", columns: ['ChucDanh', 'LuongCB']);
    var ngayCong = await _cnn.getCell(
      BangChamCongRepository.name,
      field: 'TongCong',
      condition: "MaNV = '$maNV' AND Ngay = '$ngay'",
    );
    if (ngayCong == null || ngayCong == 0) {
      ngayCong = soNgayLamViec(ngay);
    }
    return await _cnn
        .updateMap(name, {
          'MaNV': maNV,
          'ChucVu': nv['ChucDanh'],
          'LuongCoBan': nv['LuongCB'],
          'NgayCong': ngayCong,
        }, where: "ID = $id")
        .whenComplete(() async {
          await tinPhuCap(maNV, ngayCong / soNgayLamViec(ngay));
          await updatePC(maNV, ngayCong / soNgayLamViec(ngay), ngay);
          await updateLuongBHXH(maNV, ngay);
          await updateGT(maNV, ngay);
          await updateLuongTG(maNV, ngayCong / soNgayLamViec(ngay), ngay, nv['LuongCB']);
          await tamUng(maNV, ngay);
        });
  }

  Future<bool> delete(int id) async {
    return await _cnn.delete(name, where: 'ID = $id');
  }

  Future<bool> updateLuongCB(int id, double val) async {
    final x = await _cnn.getMap(name, where: "ID = $id", columns: ['MaNV', 'Ngay', 'NgayCong']);
    await updateLuongTG(x['MaNV'], x['NgayCong'] / soNgayLamViec(x['Ngay']), x['Ngay'], val);

    return await _cnn.updateMap(name, {'LuongCoBan': val}, where: 'ID = $id');
  }

  Future<bool> updateNgayCong(int id, double val) async {
    final x = await _cnn.getMap(name, where: "ID = $id", columns: ['MaNV', 'Ngay', 'LuongCoBan']);
    await tinPhuCap(x['MaNV'], val / soNgayLamViec(x['Ngay']));
    await updatePC(x['MaNV'], val / soNgayLamViec(x['Ngay']), x['Ngay']);
    await updateLuongTG(x['MaNV'], val / soNgayLamViec(x['Ngay']), x['Ngay'], x['LuongCoBan']);
    return await _cnn.updateMap(name, {'NgayCong': val}, where: 'ID = $id');
  }

  Future<bool> updateTamUng(int id, double val) async {
    return await _cnn.updateMap(name, {'TamUng': val}, where: 'ID = $id');
  }

  Future<void> updateLuongBHXH(String maNV, String ngay) async {
    final x = await _cnn.getMap(NhanVienRepository.name, where: "MaNv = '$maNV'", columns: ['ThoiVu', 'LuongCB']);
    final pcCV = await _cnn.getCell("TDM_PCvaGT", field: 'SoTieuChuan', condition: "MaNV = '$maNV' AND MaPC = 'PC11'");
    if (x['ThoiVu'] == 0) {
      await _cnn.updateMap(
        name,
        {'LuongBHXH': x['LuongCB'] + pcCV},
        where: "MaNV = ?  AND Ngay = ?",
        whereArgs: [maNV, ngay],
      );
    } else {
      await _cnn.updateMap(name, {'LuongBHXH': 0}, where: "MaNV = ?  AND Ngay = ?", whereArgs: [maNV, ngay]);
    }
  }

  Future<void> tinPhuCap(String maNV, double soNgayCong) async {
    final a = await _cnn.getListMap(
      "TDM_PCvaGT",
      where: "MaNV = '$maNV' AND MaPC LIKE 'PC%'",
      columns: ['MaPC', 'SoTieuChuan'],
    );

    for (var x in a) {
      await _cnn.updateMap(
        "TDM_PCvaGT",
        {'SoThucTe': toDouble((soNgayCong * x['SoTieuChuan']).toString()).round()},
        where: "MaNV = ? AND MaPC = ?",
        whereArgs: [maNV, x['MaPC']],
      );
    }
  }

  Future<void> updateGT(String maNV, String ngay) async {
    final gt1 = await _cnn.getCell(
      "TDM_PCvaGT",
      field: "SUM(SoTieuCHuan)",
      condition: "MaNV = '$maNV' AND MaPC LIKE 'GT1%'",
    );
    final gt2 = await _cnn.getCell(
      "TDM_PCvaGT",
      field: "SUM(SoTieuCHuan)",
      condition: "MaNV = '$maNV' AND MaPC LIKE 'GT2%'",
    );
    await _cnn.updateMap(
      name,
      {'GT1': toDouble(gt1.toString()).round(), 'GT2': toDouble(gt2.toString()).round()},
      where: "MaNV = ? AND Ngay = ?",
      whereArgs: [maNV, ngay],
    );
  }

  Future<void> updatePC(String maNV, double soNgayCong, String ngay) async {
    final pc1 = await _cnn.getCell(
      "TDM_PCvaGT",
      field: "SUM(SoTieuCHuan)",
      condition: "MaNV = '$maNV' AND MaPC LIKE 'PC1%'",
    );
    final pc2 = await _cnn.getCell(
      "TDM_PCvaGT",
      field: "SUM(SoTieuCHuan)",
      condition: "MaNV = '$maNV' AND MaPC LIKE 'PC2%'",
    );
    await _cnn.updateMap(
      name,
      {'PC1': toDouble((pc1 * soNgayCong).toString()).round(), 'PC2': toDouble((pc2 * soNgayCong).toString()).round()},
      where: "MaNV = ? AND Ngay = ?",
      whereArgs: [maNV, ngay],
    );
  }

  Future<void> updateLuongTG(String maNV, double soNgayCong, String ngay, dynamic luongCB) async {
    final pc = await _cnn.getCell(name, field: "(PC1+PC2)", condition: "MaNV = '$maNV' AND Ngay   = '$ngay'");
    final gt = await _cnn.getCell(name, field: "(GT2+GT1)", condition: "MaNV = '$maNV' AND Ngay   = '$ngay'");
    final pc2 = await _cnn.getCell(name, field: "PC2", condition: "MaNV = '$maNV' AND Ngay   = '$ngay'");
    final gt1 = await _cnn.getCell(name, field: "GT1", condition: "MaNV = '$maNV' AND Ngay   = '$ngay'");
    final tv = await _cnn.getCell(NhanVienRepository.name, field: 'ThoiVu', condition: "MaNV = '$maNV'");
    final luongTG = (luongCB * soNgayCong).round() + pc;
    await _cnn.updateMap(name, {'LuongThoiGian': luongTG}, where: "MaNV = ? AND Ngay = ?", whereArgs: [maNV, ngay]);
    if (tv == 0) {
      final thueCN = await tienThueTNCN(maNV, max(luongTG - pc2 - gt, 0), tv);
      double thucLanh = toDouble(((luongTG - (gt1 + thueCN)) / 1000).toString()).round() * 1000;
      await _cnn.updateMap(
        name,
        {
          'TNchiuThue': luongTG - pc2,
          'TNtinhThue': max(luongTG - pc2 - gt, 0),
          'ThueCN': thueCN,
          'ThucLanh': thucLanh.round(),
        },
        where: "MaNV = ? AND Ngay = ?",
        whereArgs: [maNV, ngay],
      );
    } else {
      final thueCN = await tienThueTNCN(maNV, max(luongTG - gt, 0), tv);
      double thucLanh = toDouble(((luongTG - (gt1 + thueCN)) / 1000).toString()).round() * 1000;
      await _cnn.updateMap(
        name,
        {'TNchiuThue': luongTG, 'TNtinhThue': max(luongTG - gt, 0), 'ThueCN': thueCN, 'ThucLanh': thucLanh},
        where: "MaNV = ? AND Ngay = ?",
        whereArgs: [maNV, ngay],
      );
    }
  }

  Future<void> tamUng(String maNV, String ngay) async {
    final tamUng = await _cnn.getCell(
      PhieuChiRepository.name,
      field: 'SUM(SoTIen)',
      condition: "MaNV = '$maNV' AND TKNo = '141' AND strftime('%Y-%m',Ngay) = '${ngay.substring(0, 7)}'",
    );
    await _cnn.updateMap(name, {'TamUng': tamUng}, where: "MaNV = ? AND Ngay = ?", whereArgs: [maNV, ngay]);
  }

  Future<int> tienThueTNCN(String maNV, dynamic thuNhap, int thoiVu) async {
    //'co hop dong lao dong >3thang
    const b1 = 5000000; //bac 1: 5tr/thang ->5%
    const b2 = 5000000; //2: >5-10tr->10%
    const b3 = 8000000; //3: >10-18->15%
    const b4 = 14000000; //4:>18-32->20%
    const b5 = 20000000; //5:>32-52->25%
    const b6 = 28000000; //6:>52-80->30%
    double tong = 0;
    if (thoiVu == 0) {
      if (thoiVu >= 0 && thuNhap <= 5000000) {
        tong = thuNhap * 0.05;
      } else if (thuNhap >= 5000001 && thuNhap <= 10000000) {
        tong = b1 * 0.05 + (thuNhap - b1) * 0.1;
      } else if (thuNhap >= 10000001 && thuNhap <= 18000000) {
        tong = b1 * 0.05 + b2 * 0.1 + (thuNhap - b1 - b2) * 0.15;
      } else if (thuNhap >= 18000001 && thuNhap <= 32000000) {
        tong = b1 * 0.05 + b2 * 0.1 + b3 * 0.15 + (thuNhap - b1 - b2 - b3) * 0.2;
      } else if (thuNhap >= 32000001 && thuNhap <= 52000000) {
        tong = b1 * 0.05 + b2 * 0.1 + b3 * 0.15 + b4 * 0.2 + (thuNhap - b1 - b2 - b3 - b4) * 0.25;
      } else if (thuNhap >= 52000001 && thuNhap <= 80000000) {
        tong = b1 * 0.05 + b2 * 0.1 + b3 * 0.15 + b4 * 0.2 + b5 * 0.25 + (thuNhap - b1 - b2 - b3 - b4 - b5) * 0.3;
      } else {
        tong =
            b1 * 0.05 +
            b2 * 0.1 +
            b3 * 0.15 +
            b4 * 0.2 +
            b5 * 0.25 +
            b6 * 0.3 +
            (thuNhap - b1 - b2 - b3 - b4 - b5 - b6) * 0.35;
      }
    } else {
      final x = await _cnn.getMap(NhanVienRepository.name, where: "MaNV = '$maNV'", columns: ['CoCK', 'KhongCuTru']);

      if (thuNhap >= 2000000 && x['CoCK'] == 0 && x['KhongCuTru'] == 0) {
        tong = thuNhap * 0.1;
      } else if (thuNhap >= 2000000 && x['KhongCuTru'] == 1) {
        tong = thuNhap * 0.2;
      }
    }
    return tong.round();

    //7:>80->35%
  }

  dynamic max(dynamic a, dynamic b) {
    return a > b ? a : b;
  }

  int soNgayLamViec(String ngay) {
    int sundayCount = 0;
    final data = toDate(ngay);
    for (int i = 1; i <= data!.day; i++) {
      DateTime currentDay = DateTime(data.year, data.month, i);
      if (currentDay.weekday == DateTime.sunday) {
        sundayCount++;
      }
    }
    return data.day - sundayCount;
  }
}
