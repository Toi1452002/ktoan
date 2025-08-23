import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/core/core.dart';
import 'package:pm_ketoan/data/data.dart';

class BangChamCongFunction {
  // Future<List<Map<String,  dynamic>>> getData(int thang, String name,  WidgetRef ref) async{
  //
  // }

  Future<List<NhanVienModel>> getListNV() async {
    final data = await NhanVienRepository().getList();
    return data.map((e) => NhanVienModel.fromMap(e)).toList();
  }

  Future<List<Map<String, dynamic>>> getListMaCC() async {
    return await BangChamCongRepository().getMaCC();
  }

  String getThu(int thang, String nam, int ngay) {
    String thu = "";
    final data = DateTime(int.tryParse(nam) ?? DateTime.now().year, thang, ngay).weekday + 1;
    if (data == 8) {
      thu = "CN";
    } else {
      thu = "T$data";
    }
    return thu;
  }

  bool ktrNgayTonTai(int ngay, int thang, String nam) {
    final date = DateTime(int.parse(nam), thang + 1, 0).day;

    if (date >= ngay) {
      return true;
    } else {
      return false;
    }
  }
}
