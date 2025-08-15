import 'package:pm_ketoan/data/repository/base_repository.dart';

class TuyChonRepository {
  static const name = "T00_TuyChon";

  final _baseData = BaseRepository();

  Future<dynamic> getPnN() async => await _baseData.getCell(name, field: 'GiaTri', condition: "Nhom = 'PNn'");

  Future<dynamic> getPnC() async => await _baseData.getCell(name, field: 'GiaTri', condition: "Nhom = 'PNc'");

  Future<dynamic> getTnN() async => await _baseData.getCell(name, field: 'GiaTri', condition: "Nhom = 'TNn'");

  Future<dynamic> getTnC() async => await _baseData.getCell(name, field: 'GiaTri', condition: "Nhom = 'TNc'");

  Future<dynamic> getPtN() async => await _baseData.getCell(name, field: 'GiaTri', condition: "Nhom = 'PTn'");

  Future<dynamic> getPtC() async => await _baseData.getCell(name, field: 'GiaTri', condition: "Nhom = 'PTc'");

  Future<dynamic> getPcN() async => await _baseData.getCell(name, field: 'GiaTri', condition: "Nhom = 'PCn'");

  Future<dynamic> getPcC() async => await _baseData.getCell(name, field: 'GiaTri', condition: "Nhom = 'PCc'");

  Future<dynamic> getTS() async => await _baseData.getCell(name, field: 'GiaTri', condition: "Nhom = 'TS'");
}
