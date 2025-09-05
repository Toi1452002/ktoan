import 'package:pm_ketoan/data/repository/z_base_repository.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class PhanQuyenRepository {
  static const mc1 = "T00_NhomMC1";
  static const mc2 = "T00_NhomMC2";
  static const hangMuc = "T00_HangMuc";
  final _cnn = BaseRepository();

  Future<List<Map<String, dynamic>>> getListMC1(String userName) async {
    return await _cnn.getListMap(mc1, where: "Username = '$userName' AND ChoPhep == 0", columns: ['MaC1']);

  }

  Future<List<Map<String, dynamic>>> getListMC2(String userName) async {
    return await _cnn.getListMap(mc2, where: "Username = '$userName' AND ChoPhep == 0", columns: ['MaC2']);

  }

  Future<List<Map<String, dynamic>>> getListHangMuc(String userName) async {
    return await _cnn.getListMap(hangMuc, where: "Username = '$userName' AND ChoPhep == 0", columns: ['TenForm']);

  }

  Future<int> getChoPhep(String userName, int type, String ma) async {
    if (type == 0) {
      return await _cnn.getCell(mc1, field: 'ChoPhep', condition: "MaC1 = '$ma' AND UserName = '$userName'");
    } else if (type == 1) {
      return await _cnn.getCell(mc2, field: 'ChoPhep', condition: "MaC2 = '$ma' AND UserName = '$userName'");
    } else {
      return await _cnn.getCell(hangMuc, field: 'ChoPhep', condition: "TenForm = '$ma' AND UserName = '$userName'");
    }
  }

  Future<bool> updateChoPhep(String userName, int type, String ma, int value) async {
    bool state;
    if (type == 0) {
      state = await _cnn.updateMap(mc1, {'ChoPhep': value}, where: "MaC1 = '$ma' AND UserName = '$userName'");
    } else if (type == 1) {
      state = await _cnn.updateMap(mc2, {'ChoPhep': value}, where: "MaC2 = '$ma' AND UserName = '$userName'");
    } else {
      state = await _cnn.updateMap(hangMuc, {'ChoPhep': value}, where: "TenForm = '$ma' AND UserName = '$userName'");
    }
    return state;
  }
}
