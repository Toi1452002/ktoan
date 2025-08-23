// ignore_for_file: type=lint

import 'package:string_validator/string_validator.dart';

class NhanVienModel {
  final int? ID;
  final String MaNV;
  final String? HoTen;
  final bool Phai;
  final String NgaySinh;
  final String? CCCD;
  final String? MST;
  final String? DiaChi;
  final String? DienThoai;
  final String? TrinhDo;
  final String? ChuyenMon;
  final String NgayVao;
  final String? ChucDanh;
  final double? LuongCB;
  final bool ThoiVu;
  final bool KhongCuTru;
  final bool CoCK;
  final String GhiChu;
  final bool TheoDoi;

  const NhanVienModel({
    this.ID,
    required this.MaNV,
    this.HoTen,
    required this.Phai,
    required this.NgaySinh,
    this.CCCD,
    this.MST,
    this.DiaChi,
    this.DienThoai,
    this.TrinhDo,
    this.ChuyenMon,
    required this.NgayVao,
    this.ChucDanh,
    this.LuongCB,
    required this.ThoiVu,
    required this.KhongCuTru,
    required this.CoCK,
    required this.GhiChu,
    required this.TheoDoi,
  });

  Map<String, dynamic> toMap() {
    return {
      'ID': this.ID,
      'MaNV': this.MaNV,
      'HoTen': this.HoTen,
      'Phai': this.Phai ? 1 : 0,
      'NgaySinh': this.NgaySinh,
      'CCCD': this.CCCD,
      'MST': this.MST,
      'DiaChi': this.DiaChi,
      'DienThoai': this.DienThoai,
      'TrinhDo': this.TrinhDo,
      'ChuyenMon': this.ChuyenMon,
      'NgayVao': this.NgayVao,
      'ChucDanh': this.ChucDanh,
      'LuongCB': this.LuongCB,
      'ThoiVu': this.ThoiVu ? 1 : 0,
      'KhongCuTru': this.KhongCuTru ? 1 : 0,
      'CoCK': this.CoCK ? 1 : 0,
      'GhiChu': this.GhiChu,
      'TheoDoi': this.TheoDoi ? 1 : 0,
    };
  }

  factory NhanVienModel.fromMap(Map<String, dynamic> map) {
    return NhanVienModel(
      ID: map['ID'],
      MaNV: map['MaNV'],
      HoTen: map['HoTen'] ?? '',
      Phai: toBoolean(map['Phai'].toString()),
      NgaySinh: map['NgaySinh']??'',
      CCCD: map['CCCD'] ?? '',
      MST: map['MST'] ?? '',
      DiaChi: map['DiaChi'] ?? '',
      DienThoai: map['DienThoai'] ?? '',
      TrinhDo: map['TrinhDo'] ?? '',
      ChuyenMon: map['ChuyenMon'] ?? '',
      NgayVao: map['NgayVao']??'',
      ChucDanh: map['ChucDanh'] ?? '',
      LuongCB: toDouble(map['LuongCB'].toString()),
      ThoiVu: toBoolean(map['ThoiVu'].toString()),
      KhongCuTru: toBoolean(map['KhongCuTru'].toString()),
      CoCK: toBoolean(map['CoCK'].toString()),
      GhiChu: map['GhiChu'] ?? "",
      TheoDoi: toBoolean(map['TheoDoi'].toString()),
    );
  }

  NhanVienModel copyWith({
    int? ID,
    String? MaNV,
    String? HoTen,
    bool? Phai,
    String? NgaySinh,
    String? CCCD,
    String? MST,
    String? DiaChi,
    String? DienThoai,
    String? TrinhDo,
    String? ChuyenMon,
    String? NgayVao,
    String? ChucDanh,
    double? LuongCB,
    bool? ThoiVu,
    bool? KhongCuTru,
    bool? CoCK,
    String? GhiChu,
    bool? TheoDoi,
  }) {
    return NhanVienModel(
      ID: ID ?? this.ID,
      MaNV: MaNV ?? this.MaNV,
      HoTen: HoTen ?? this.HoTen,
      Phai: Phai ?? this.Phai,
      NgaySinh: NgaySinh ?? this.NgaySinh,
      CCCD: CCCD ?? this.CCCD,
      MST: MST ?? this.MST,
      DiaChi: DiaChi ?? this.DiaChi,
      DienThoai: DienThoai ?? this.DienThoai,
      TrinhDo: TrinhDo ?? this.TrinhDo,
      ChuyenMon: ChuyenMon ?? this.ChuyenMon,
      NgayVao: NgayVao ?? this.NgayVao,
      ChucDanh: ChucDanh ?? this.ChucDanh,
      LuongCB: LuongCB ?? this.LuongCB,
      ThoiVu: ThoiVu ?? this.ThoiVu,
      KhongCuTru: KhongCuTru ?? this.KhongCuTru,
      CoCK: CoCK ?? this.CoCK,
      GhiChu: GhiChu ?? this.GhiChu,
      TheoDoi: TheoDoi ?? this.TheoDoi,
    );
  }
}
