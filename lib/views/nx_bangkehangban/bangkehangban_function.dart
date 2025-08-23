import '../../data/data.dart';

class BangKeHangBanFunction{
  Future<List<Map<String, dynamic>>> get({String? thang, int? quy, int nam = 2000}) async {
    return await PhieuXuatRepository().getBKeHangBan(thang: thang, quy: quy,nam: nam);
  }
}