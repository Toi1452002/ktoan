import 'package:pm_ketoan/core/core.dart';
import 'package:pm_ketoan/data/data.dart';
import 'package:pm_ketoan/data/repository/z_base_repository.dart';

class BCTCRepository {
  static const tmpCDKT = "tmp_CDKT";
  static const tmpKQKD = "tmp_KQKD";
  static const tmpLCTT = "tmp_LCTT";
  static const tmpTMTC = "tmp_TMTC";
  static const soNamTruoc = "TKT_SoNamTruoc";
  final _cnn = BaseRepository();

  Future<List<Map<String, dynamic>>> getData(String tableName) async {
    return await _cnn.getListMap(
      tableName,
      columns: ['ChiTieu', 'MaSo', 'ThuyetMinh', 'SoNamNay', 'SoNamTruoc', 'PhanCap'],
    );
  }

  Future<void> updateTM(String tableName, String value, String maSo) async {
    await _cnn.updateMap(tableName, {'ThuyetMinh': value}, where: "MaSo = '$maSo'");
  }

  Future<void> khoiTaoVeKhong(String tableName, int nam) async {
    await _cnn.updateMap(tableName, {'SoNamNay': null, 'SoNamTruoc': null});
    await _cnn.updateMap(
      tableName,
      {'ThuyetMinh': "Từ ngày 01/01/$nam đến ngày 31/12/$nam"},
      where: 'MaSo  =?',
      whereArgs: ['II1'],
    );
  }

  Future<void> ghiNamTruoc(String tableName, String form, int nam) async {
    final tkt = await _cnn.getListMap(
      soNamTruoc,
      where: "Form = ? AND Nam = ?",
      whereArgs: [form, nam - 1],
      columns: ['MaSo', 'SoNamTruoc'],
    );
    if (tkt.isNotEmpty) {
      final tkq = await _cnn.getListMap(tableName);
      for (var x in tkt) {
        final s = tkq.indexWhere((e) => e['MaSo'] == x['MaSo']);
        if (s != -1) {
          await _cnn.updateMap(tableName, {'SoNamTruoc': x['SoNamTruoc']}, where: "MaSo = ? ", whereArgs: [x['MaSo']]);
        }
      }
    }
  }

  Future<bool> checkDKTK(int nam) async {
    final a = await _cnn.getCell(DauKyRepository.nameDkyBTK, field: 'COUNT(*)', condition: "Thang = '$nam'");
    return a > 0 ? true : false;
  }

  Future<List<Map<String, dynamic>>> getTmp(String tableName) async {
    return await _cnn.getListMap(tableName, where: "NguonTKno != '' OR NguonTKco != ''");
  }

  Future<dynamic> sumDKNo(int nam, String tkGroup) async {
    return await _cnn.getCell(
          DauKyRepository.nameDkyBTK,
          field: "SUM(DKNo)",
          condition: "Thang = '$nam' AND SUBSTR(MaTK,1,${tkGroup.length}) = '$tkGroup'",
        ) ??
        0;
  }

  Future<dynamic> sumDKCo(int nam, String tkGroup) async {
    return await _cnn.getCell(
          DauKyRepository.nameDkyBTK,
          field: "SUM(DKCo)",
          condition: "Thang = '$nam' AND SUBSTR(MaTK,1,${tkGroup.length}) = '$tkGroup'",
        ) ??
        0;
  }

  Future<dynamic> getSoNamTruoc(int nam, String form) async {
    return await _cnn.getCell(
          soNamTruoc,
          field: "SoNamTruoc",
          condition: "Nam = '$nam' AND Form = '$form' AND MaSo = '60'",
        ) ??
        0;
  }

  Future<dynamic> sumSoCaiTK(
    int nam,
    String tkDU,
    String tkGroup, {
    bool s = false,
    bool noTKDU = false,
    required String field,
  }) async {
    if (noTKDU) {
      return await _cnn.getCell(
            "VKT_SoCaiTK",
            field: "SUM($field)",
            condition: "STRFTIME('%Y', Ngay) = '$nam' AND SUBSTR(TK,1,${tkGroup.length}) = '$tkGroup'",
          ) ??
          0;
    }
    if (s) {
      return await _cnn.getCell(
            "VKT_SoCaiTK",
            field: "SUM($field)",
            condition:
                "STRFTIME('%Y', Ngay) = '$nam' AND SUBSTR(TKDU, 1, ${tkDU.length}) = '$tkDU' AND SUBSTR(TK,1,${tkGroup.length}) = '$tkGroup'",
          ) ??
          0;
    }
    return await _cnn.getCell(
          "VKT_SoCaiTK",
          field: "SUM($field)",
          condition: "STRFTIME('%Y', Ngay) = '$nam' AND TKDU ='$tkDU' AND SUBSTR(TK,1,${tkGroup.length}) = '$tkGroup'",
        ) ??
        0;
  }

  Future<void> ghiSoNamNay(int year, String tableName) async {
    List<String> lstTKno, lstTKco, tkDU = [];
    double soDu, soPS = 0;
    String tkGroup = "";
    final tmp = await getTmp(tableName);
    for (var x in tmp) {
      soDu = 0;
      soPS = 0;
      if (x['NguonTKno'] != null && x['NguonTKno'] != '') {
        lstTKno = x['NguonTKno'].toString().split(',');
        for (String no in lstTKno) {
          tkGroup = "";
          if (no.isNotEmpty && Helper.strLast(no) == '*') {
            tkGroup = no.substring(0, no.length - 1);
          } else {
            tkGroup = no;
          }

          if (x['NguonDL'] == "TDM_DauKyTaiKhoan") {
            if (x['MaSo'] == '60') {
              soDu = soDu + await sumDKNo(year - 1, tkGroup);
            } else {
              soDu = soDu + await sumDKNo(year, tkGroup);
            }
            if (tkGroup == "4211" || tkGroup == "4212") {
              soDu = soDu * -1;
            }
          }
          //1.7 viet them vi thay TNDN k lay so lieu
          if (x['NguonDL'] == "TKT_SoNamTruoc") {
            soDu = soDu + await getSoNamTruoc(year, 'KQKD');
          }
          if (x['NguonDL'] == "VKT_SoCaiTK") {
            if (x['LocTK'] != null || x['LocTK'] != '') {
              if (x['LocTK'].toString().contains('-')) {
                tkDU = x['LocTK'].toString().split('-');
                soDu = soDu + await sumSoCaiTK(year, tkDU.first, tkGroup, field: 'PSNo');
                if (tkDU.length > 1) {
                  soDu = soDu - await sumSoCaiTK(year, tkDU[1], tkGroup, field: 'PSNo');
                }
              } else {
                tkDU = x['LocTK'].toString().split(',');
                for (String t in tkDU) {
                  if (t.isNotEmpty && Helper.strLast(t) == '*') {
                    t = t.substring(0, t.length - 1);
                  }
                  soDu = soDu + await sumSoCaiTK(year, t, tkGroup, field: 'PSNo');
                }
              }
            } else {
              soDu = soDu + await sumSoCaiTK(year, '', tkGroup, noTKDU: true, field: 'PSNo');
            }
          }
        }
      }
      if (x['NguonTKco'] != null && x['NguonTKco'] != '') {
        lstTKco = x['NguonTKco'].toString().split(',');
        for (String co in lstTKco) {
          tkGroup = "";
          if (co.isNotEmpty && Helper.strLast(co) == "*") {
            tkGroup = co.substring(0, co.length - 1);
          } else {
            tkGroup = co;
          }
          if (x['NguonDL'] == "TDM_DauKyTaiKhoan") {
            soDu = soDu + await sumDKNo(year, tkGroup);
          }
          if (x['NguonDL'] == "VKT_SoCaiTK") {
            if (x['LocTK'] != null || x['LocTK'] != '') {
              if (x['LocTK'].toString().contains('-')) {
                tkDU = x['LocTK'].toString().split('-');
                soDu = soDu + await sumSoCaiTK(year, tkDU[0], tkGroup, field: 'PSCo');
                if (tkDU.length > 1) {
                  soDu = soDu - await sumSoCaiTK(year, tkDU[1], tkGroup, field: 'PSCo');
                }
              } else {
                tkDU = x['LocTK'].toString().split(',');
                for (String t in tkDU) {
                  if (t.isNotEmpty && Helper.strLast(t) == "*") {
                    t = t.substring(0, t.length - 1);
                  }
                  soDu = soDu + await sumSoCaiTK(year, t, tkGroup, field: 'PSCo', s: true);
                }
              }
            } else {
              soDu = soDu + await sumSoCaiTK(year, '', tkGroup, field: 'PSCo', noTKDU: true);
            }
          }
        }
      }
      final so = x['GhiAm'] == 1 ? soDu * -1 : soDu;
      await _cnn.updateMap(tableName, {'SoNamNay': so}, where: "MaSo = ?", whereArgs: [x['MaSo']]);
    }
  }

  Future<void> tinhTongNhom(String tableName, int nam) async {
    final mPCap = await _cnn.getCell(tableName, field: 'Max(PhanCap)');
    for (int i = 1; i <= mPCap; i++) {
      final kt = await _cnn.getListMap(tableName, where: "PhanCap = $i", orderBy: "ID");
      if (kt.isNotEmpty) {
        for (var x in kt) {
          if (x['CongThuc'].toString().contains('+') ||
              x['CongThuc'].toString().contains('-') ||
              x['CongThuc'].toString().contains('*') ||
              x['CongThuc'].toString().contains('/')) {
            List<String> lstTK = [], lstDau = ['+'];
            double soDu = 0;
            String cThuc = x['CongThuc'].toString();
            String sMaSo = '';
            String tmp = "";
            for (int c = 0; c < cThuc.length; c++) {
              if (['+', '-', '*', '/'].contains(cThuc[c])) {
                lstTK.add(tmp);
                lstDau.add(cThuc[c]);
                tmp = "";
              } else {
                tmp += cThuc[c];
              }
              if (c == cThuc.length - 1) {
                lstTK.add(tmp);
                tmp = "";
              }
              // print(tmp);
            }
            // for (var c in x['CongThuc']) {
            //   String tmp = "";
            //   tmp += c;
            //   if (['+', '-', '*', '/'].contains(c)) {
            //     lstTK.add(tmp);
            //     lstDau.add(c);
            //     tmp = "";
            //   }
            // }
            for (int j = 0; j < lstTK.length; j++) {
              if (lstDau[j] == "+" && await _cnn.countRows(tableName, '*', where: "MaSo = '${lstTK[j]}'") > 0) {
                soDu =
                    soDu +
                    await _cnn.getCell(tableName, field: 'IFNULL(SoNamNay,0)', condition: "MaSo = '${lstTK[j]}'");
                if (j < lstDau.length - 1) {
                  if (lstDau[j + 1] == '*' || lstDau[j + 1] == '/') {
                    soDu =
                        soDu -
                        await _cnn.getCell(tableName, field: 'IFNULL(SoNamNay,0)', condition: "MaSo = '${lstTK[j]}'");
                  }
                }
              }
              if (lstDau[j] == "-" && await _cnn.countRows(tableName, '*', where: "MaSo = '${lstTK[j]}'") > 0) {
                soDu =
                    soDu -
                    1 * await _cnn.getCell(tableName, field: 'IFNULL(SoNamNay,0)', condition: "MaSo = '${lstTK[j]}'");
                if (j < lstDau.length - 1) {
                  if (lstDau[j + 1] == '*' || lstDau[j + 1] == '/') {
                    soDu =
                        soDu +
                        1 *
                            await _cnn.getCell(
                              tableName,
                              field: 'IFNULL(SoNamNay,0)',
                              condition: "MaSo = '${lstTK[j]}'",
                            );
                  }
                }
                if (tableName == "tmp_TNDN" && ['C1', 'C4'].contains(x['MaSo'])) {
                  if (soDu < 0) soDu = 0;
                }
              }
              if (lstDau[j] == "*") {
                if (tableName == "tmp_TNDNtt") {
                  if (await _cnn.getCell(tableName, field: 'SoNamNay', condition: "MaSo = 'VI'") > 0) {
                    soDu =
                        soDu +
                        await _cnn.getCell(
                              tableName,
                              field: 'IFNULL(SoNamNay,0)',
                              condition: "MaSo = '${lstTK[j - 1]}'",
                            ) *
                            await _cnn.getCell(
                              tableName,
                              field: 'IFNULL(SoNamNay,0)',
                              condition: "MaSo = '${lstTK[j]}'",
                            ) /
                            100;
                  } else {
                    soDu = 0;
                  }
                } else if (tableName == "tmp_TNDN") {
                  if (x['MaSo'] == 'C9') {
                    soDu =
                        soDu +
                        await _cnn.getCell(tableName, field: 'IFNULL(SoNamNay,0)', condition: "MaSo = 'C7'") * 0.2;
                    if (soDu < 0) soDu = 0;
                  }
                  if (x['MaSo'] == 'H') {
                    soDu =
                        soDu +
                        await _cnn.getCell(tableName, field: 'IFNULL(SoNamNay,0)', condition: "MaSo = 'D'") * 0.2;
                  }
                } else {
                  soDu =
                      soDu +
                      await _cnn.getCell(
                            tableName,
                            field: 'IFNULL(SoNamNay,0)',
                            condition: "MaSo = '${lstTK[j - 1]}'",
                          ) *
                          await _cnn.getCell(tableName, field: 'IFNULL(SoNamNay,0)', condition: "MaSo = '${lstTK[j]}'");
                }
              }
              if (lstDau[j] == "/") {
                soDu =
                    soDu +
                    await _cnn.getCell(tableName, field: 'IFNULL(SoNamNay,0)', condition: "MaSo = '${lstTK[j]}'") /
                        await _cnn.getCell(tableName, field: 'IFNULL(SoNamNay,0)', condition: "MaSo = '${lstTK[j]}'");
              }
            }

            if (soDu != 0) {
              sMaSo = x['MaSo'];
              await _cnn.updateMap(tableName, {"SoNamNay": soDu.round()}, where: "MaSo= '$sMaSo'");
            }
            if (tableName == "tmp_TNDN" && x['MaSo'] == "C1") {
              final c3 = await _cnn.getListMap(tableName, where: "MaSo = 'C3'");
              if (c3.isNotEmpty) {
                await _cnn.updateMap(tableName, {"SoNamNay": 0}, where: "MaSo = 'C3'");
                if (x['SoNamNay'] ?? 0 > 0) {
                  final dKy4211 =
                      await _cnn.getCell(
                        DauKyRepository.nameDkyBTK,
                        field: 'DKNo',
                        condition: "Thang = '${nam - 1}' AND MaTK ='4211'",
                      ) ??
                      0;
                  if (dKy4211 > 0) {
                    await _cnn.updateMap(tableName, {"SoNamNay": dKy4211}, where: "MaSo = 'C3'");
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  Future<bool> luuNamTruoc(String tableName, String form, int nam) async {
    try {
      final tmp = await _cnn.getListMap(
        tableName,
        columns: ['MaSo', 'SoNamNay'],
        where: "SoNamNay != 0",
        orderBy: "MaSo",
      );

      for (var x in tmp) {
        final ud = await _cnn.updateMap(
          soNamTruoc,
          {'SoNamTruoc': x['SoNamNay']},
          where: "MaSo = ? AND Form = ? AND Nam = ?",
          whereArgs: [x['MaSo'], form, nam],
        );
        if (!ud) {
          await _cnn.addMap(soNamTruoc, {'MaSo': x['MaSo'], 'Form': form, 'Nam': nam, 'SoNamTruoc': x['SoNamNay']});
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
