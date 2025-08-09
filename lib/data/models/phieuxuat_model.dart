// ignore_for_file: type=lint

import 'package:string_validator/string_validator.dart';

class PhieuXuatModel {
  final int? STT;
  final int? ID;
  final String Ngay;
  final String Phieu;
  final String? MaKhach;
  final String? MaNX;
  String? DienGiai;
  double? CongTien;
  double ThueSuat;
  double? TienThue;
  final bool? Khoa;
  final String? CreatedBy;
  final String? CreatedAt;
  final String? UpdatedBy;
  final String? UpdatedAt;
  String? KyHieu;
  String? SoHD;
  final String NgayCT;
  final String TKNo;
  final String TKCo;
  final String TKVatNo;
  final String TKVatCo;
  final String? PTTT;
  final bool? KChiuThue;
  final String? countRow;

  PhieuXuatModel({
    this.STT,
    this.ID,
    required this.Ngay,
    required this.Phieu,
    this.MaKhach,
    this.MaNX,
    this.DienGiai,
    this.CongTien,
    required this.ThueSuat,
    this.TienThue,
    this.Khoa,
    this.CreatedBy,
    this.CreatedAt,
    this.UpdatedBy,
    this.UpdatedAt,
    this.KyHieu,
    this.SoHD,
    required this.NgayCT,
    required this.TKNo,
    required this.TKCo,
    required this.TKVatNo,
    required this.TKVatCo,
    this.PTTT,
    this.KChiuThue,
    this.countRow,
  });

  Map<String, dynamic> toMap() {
    return {
      'ID': this.ID,
      'Ngay': this.Ngay,
      'Phieu': this.Phieu,
      'MaKhach': this.MaKhach,
      'MaNX': this.MaNX ?? 'XB',
      'DienGiai': this.DienGiai,
      'CongTien': this.CongTien ?? 0,
      'ThueSuat': this.ThueSuat,
      'TienThue': this.TienThue ?? 0,
      'Khoa': this.Khoa ?? false ? 1 : 0,
      'CreatedBy': this.CreatedBy,
      'CreatedAt': this.CreatedAt,
      'UpdatedBy': this.UpdatedBy,
      'UpdatedAt': this.UpdatedAt,
      'KyHieu': this.KyHieu,
      'SoHD': this.SoHD,
      'NgayCT': this.NgayCT,
      'TKNo': this.TKNo,
      'TKCo': this.TKCo,
      'TKVatNo': this.TKVatNo,
      'TKVatCo': this.TKVatCo,
      'PTTT': this.PTTT ?? 'TM/CK',
      'KChiuThue': this.KChiuThue ?? false ? 1 : 0,
    };
  }

  factory PhieuXuatModel.fromMap(Map<String, dynamic> map) {
    return PhieuXuatModel(
      STT: map['STT'],
      ID: map['ID'],
      Ngay: map['Ngay'] ?? '',
      Phieu: map['Phieu'] ?? '',
      MaKhach: map['MaKhach'],
      MaNX: map['MaNX'],
      DienGiai: map['DienGiai'] ?? '',
      CongTien: toDouble(map['CongTien'].toString()),
      ThueSuat: toDouble(map['ThueSuat'].toString()),
      TienThue: toDouble(map['TienThue'].toString()),
      Khoa: toBoolean(map['Khoa'].toString()),
      CreatedBy: map['CreatedBy'],
      CreatedAt: map['CreatedAt'],
      UpdatedBy: map['UpdatedBy'],
      UpdatedAt: map['UpdatedAt'],
      KyHieu: map['KyHieu'] ?? '',
      SoHD: map['SoHD'] ?? '',
      NgayCT: map['NgayCT'] ?? '',
      TKNo: map['TKNo'] ?? '',
      TKCo: map['TKCo'] ?? '',
      TKVatNo: map['TKVatNo'] ?? '',
      TKVatCo: map['TKVatCo'] ?? '',
      PTTT: map['PTTT'],
      KChiuThue: toBoolean(map['KChiuThue'].toString()),
      countRow: map['countRow'],
    );
  }

  PhieuXuatModel copyWith({
    int? STT,
    int? ID,
    String? Ngay,
    String? Phieu,
    String? MaKhach,
    String? MaNX,
    String? DienGiai,
    double? CongTien,
    double? ThueSuat,
    double? TienThue,
    bool? Khoa,
    String? CreatedBy,
    String? CreatedAt,
    String? UpdatedBy,
    String? UpdatedAt,
    String? KyHieu,
    String? SoHD,
    String? NgayCT,
    String? TKNo,
    String? TKCo,
    String? TKVatNo,
    String? TKVatCo,
    String? PTTT,
    bool? KChiuThue,
    String? countRow,
  }) {
    return PhieuXuatModel(
      STT: STT ?? this.STT,
      ID: ID ?? this.ID,
      Ngay: Ngay ?? this.Ngay,
      Phieu: Phieu ?? this.Phieu,
      MaKhach: MaKhach ?? this.MaKhach,
      MaNX: MaNX ?? this.MaNX,
      DienGiai: DienGiai ?? this.DienGiai,
      CongTien: CongTien ?? this.CongTien,
      ThueSuat: ThueSuat ?? this.ThueSuat,
      TienThue: TienThue ?? this.TienThue,
      Khoa: Khoa ?? this.Khoa,
      CreatedBy: CreatedBy ?? this.CreatedBy,
      CreatedAt: CreatedAt ?? this.CreatedAt,
      UpdatedBy: UpdatedBy ?? this.UpdatedBy,
      UpdatedAt: UpdatedAt ?? this.UpdatedAt,
      KyHieu: KyHieu ?? this.KyHieu,
      SoHD: SoHD ?? this.SoHD,
      NgayCT: NgayCT ?? this.NgayCT,
      TKNo: TKNo ?? this.TKNo,
      TKCo: TKCo ?? this.TKCo,
      TKVatNo: TKVatNo ?? this.TKVatNo,
      TKVatCo: TKVatCo ?? this.TKVatCo,
      PTTT: PTTT ?? this.PTTT,
      KChiuThue: KChiuThue ?? this.KChiuThue,
      countRow: countRow ?? this.countRow,
    );
  }
}
