import 'package:pm_ketoan/data/data.dart';

class HangHoaRepository {
  static const name = "TDM_HangHoa";
  static const view = "V_HangHoa";

  Future<List<Map<String, dynamic>>> getData({int td = 1}) async {
    try {
      final cnn = await connectData();
      final data = await cnn!.query(view, where: td == 2 ? null : 'TheoDoi = ?', whereArgs: td == 2 ? null : [td]);
      return data;
    } catch (e) {
      errorSql(e);
      return [];
    }
  }

  Future<bool> add(Map<String, dynamic> map) async{
    try{
      final cnn = await connectData();
      await cnn!.insert(name, map);
      return true;
    }catch(e){
      errorSql(e);
      return false;
    }
  }
  Future<bool> update(Map<String, dynamic> map) async{
    try{
      final cnn = await connectData();
      await cnn!.update(name, map,where: 'ID = ?', whereArgs: [map['ID']]);
      return true;
    }catch(e){
      errorSql(e);
      return false;
    }
  }
  Future<Map<String, dynamic>> getHangHoa(String ma) async{
    try{
      final cnn = await connectData();
      final data = await cnn!.query(name, where: "MaHH = ?", whereArgs: [ma],limit: 1);
      return data.isEmpty ?  {} : data.first;
    }catch(e){
      errorSql(e);
      return {};
    }
  }

  Future<List<Map<String, dynamic>>> getLoaiHang() async {
    try {
      final cnn = await connectData();
      final data = await cnn!.query('TDM_LoaiHang');
      return data;
    } catch (e) {
      errorSql(e);
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getDonViTinh() async {
    try {
      final cnn = await connectData();
      final data = await cnn!.query('TDM_DonViTinh', orderBy: 'DVT');
      return data;
    } catch (e) {
      errorSql(e);
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getNhomHang() async {
    try {
      final cnn = await connectData();
      final data = await cnn!.query('TDM_NhomHang', orderBy: "NhomHang");
      return data;
    } catch (e) {
      errorSql(e);
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getNhaCung() async {
    try {
      final cnn = await connectData();
      final data = await cnn!.query(
        'TDM_KhachHang',
        where: "TheoDoi = ? AND LoaiKH IN (?,?)",
        whereArgs: [1, "NC", "CH"],
      );
      return data;
    } catch (e) {
      errorSql(e);
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getKho() async {
    try {
      final cnn = await connectData();
      final data = await cnn!.query('TDM_BangTaiKhoan', where: "MaLK = ?", whereArgs: ['15']);
      return data;
    } catch (e) {
      errorSql(e);
      return [];
    }
  }
}
