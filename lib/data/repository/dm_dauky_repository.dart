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
    final rp = await _cnn.getListMap(viewDkyKH, orderBy: 'Ngay');
    if (rp.status == ResponseType.success) {
      return rp.data;
    } else {
      CustomAlert.error(rp.message.toString());
      return [];
    }
  }

  Future<void> updateDauKyKhachhang(List<Map<String, dynamic>> data) async {
    await _cnn.delete(nameDkyKH);
    await _cnn.addRows(nameDkyKH, data);
  }

  Future<List<Map<String, dynamic>>> getDauKyHangHoa() async {
    final rp = await _cnn.getListMap(viewDkyHH, orderBy: 'Ngay');
    if (rp.status == ResponseType.success) {
      return rp.data;
    } else {
      CustomAlert.error(rp.message.toString());
      return [];
    }
  }
  Future<void> updateDauKyHangHoa(List<Map<String, dynamic>> data) async {
    await _cnn.delete(nameDkyHH);
    await _cnn.addRows(nameDkyHH, data);
  }


  Future<List<Map<String, dynamic>>> getDauKyBTK() async {
    final rp = await _cnn.getListMap(viewDkyBTK);
    if (rp.status == ResponseType.success) {
      return rp.data;
    } else {
      CustomAlert.error(rp.message.toString());
      return [];
    }
  }
  Future<void> updateDauKyBTK(List<Map<String, dynamic>> data) async {
    await _cnn.delete(nameDkyBTK);
    await _cnn.addRows(nameDkyBTK, data);
  }
}
