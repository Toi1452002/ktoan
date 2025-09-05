import 'package:pm_ketoan/core/core.dart';
import 'package:pm_ketoan/data/repository/z_base_repository.dart';

class DauKyRepository {
  static const viewDkyKH = "VDM_DKyKhachHang";
  static const nameDkyKH = "TDM_DKyKhachHang";
  static const viewDkyHH = "VDM_DKyHangHoa";
  static const nameDkyHH = "TDM_DKyHangHoa";
  static const viewDkyBTK = "VDM_DKyTaiKhoan";
  static const nameDkyBTK = "TDM_DKyTaiKhoan";
  final _cnn = BaseRepository();

  Future<List<Map<String, dynamic>>> getDauKyKhachHang() async {
    return await _cnn.getListMap(viewDkyKH, orderBy: 'Ngay');

  }

  Future<void> updateDauKyKhachhang(List<Map<String, dynamic>> data) async {
    await _cnn.delete(nameDkyKH);
    await _cnn.addRows(nameDkyKH, data);
  }

  Future<List<Map<String, dynamic>>> getDauKyHangHoa() async {
    return await _cnn.getListMap(viewDkyHH, orderBy: 'Ngay');

  }
  Future<void> updateDauKyHangHoa(List<Map<String, dynamic>> data) async {
    await _cnn.delete(nameDkyHH);
    await _cnn.addRows(nameDkyHH, data);
  }


  Future<List<Map<String, dynamic>>> getDauKyBTK() async {
    return await _cnn.getListMap(viewDkyBTK);

  }
  Future<void> updateDauKyBTK(List<Map<String, dynamic>> data) async {
    try{
      final cnn = await connectData();
      final batch = cnn!.batch();
      // print(data);
      for(var x in data){
        final tmp = await _cnn.getMap(nameDkyBTK,where: "Thang = ? AND MaTK = ?",whereArgs: [x['Thang'], x['MaTK']]);
        if(tmp.isNotEmpty){
          batch.update(nameDkyBTK, x,where: "Thang = ? AND MaTK = ?",whereArgs: [x['Thang'], x['MaTK']]);
        }else{
          batch.insert(nameDkyBTK, x);
        }
      }
      await batch.commit(noResult: true);
    }catch(e){
      errorSql(e);
    }
    // print(data);
    // await _cnn.delete(nameDkyBTK);
    // await _cnn.addRows(nameDkyBTK, data);
  }
}
