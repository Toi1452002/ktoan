import 'package:pm_ketoan/data/repository/base_repository.dart';

class BangTaiKhoanRepository{
  static const name = "TDM_BangTaiKhoan";

  final _baseData = BaseRepository();

  Future<List<Map<String, dynamic>>> getList() async=> await _baseData.getListMap(name);

  

}