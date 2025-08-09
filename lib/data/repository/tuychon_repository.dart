import 'package:pm_ketoan/data/repository/base_repository.dart';

class TuyChonRepository {
  static const name = "T00_TuyChon";

  final _baseData = BaseRepository();

  Future<dynamic> getPnN() async => await _baseData.getCell(name, field: 'GiaTri', condition: "Nhom = 'PNn'");

  Future<dynamic> getPnC() async => await _baseData.getCell(name, field: 'GiaTri', condition: "Nhom = 'PNc'");

  Future<dynamic> getTnN() async => await _baseData.getCell(name, field: 'GiaTri', condition: "Nhom = 'TNn'");

  Future<dynamic> getTnC() async => await _baseData.getCell(name, field: 'GiaTri', condition: "Nhom = 'TNc'");

  Future<dynamic> getTS() async => await _baseData.getCell(name, field: 'GiaTri', condition: "Nhom = 'TS'");
}
