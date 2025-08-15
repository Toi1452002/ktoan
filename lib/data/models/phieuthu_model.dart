// ignore_for_file: type=lint

import 'package:string_validator/string_validator.dart';

class PhieuThuModel {
  final int? ID;
  final String Phieu;
  final String? Ngay;
  final String? MaTC;
  final String? MaKhach;
   String? TenKhach;
   String? DiaChi;
   String? NguoiNop;
   String? NguoiThu;
   double? SoTien;
   String? NoiDung;
  final String? PTTT;
  final bool Khoa;
  final String? CreatedAt;
  final String? CreatedBy;
  final String? UpdatedAt;
  final String? UpdatedBy;
   String? SoCT;
  final String? TKNo;
  final String? TKCo;
  final int? STT;
  final int? Count;

   PhieuThuModel({
     this.ID,
    required this.Phieu,
    this.Ngay,
    this.MaTC,
    this.MaKhach,
    this.TenKhach,
    this.DiaChi,
    this.NguoiNop,
    this.NguoiThu,
    this.SoTien,
    this.NoiDung,
    this.PTTT,
    required this.Khoa,
    this.CreatedAt,
    this.CreatedBy,
    this.UpdatedAt,
    this.UpdatedBy,
    this.SoCT,
    this.TKNo,
    this.TKCo,
    this.STT,
    this.Count,
  });

  Map<String, dynamic> toMap() {
    return {
      'ID': this.ID,
      'Phieu': this.Phieu,
      'Ngay': this.Ngay,
      'MaTC': this.MaTC,
      'MaKhach': this.MaKhach,
      'TenKhach': this.TenKhach,
      'DiaChi': this.DiaChi,
      'NguoiNop': this.NguoiNop,
      'NguoiThu': this.NguoiThu,
      'SoTien': this.SoTien??0,
      'NoiDung': this.NoiDung,
      'PTTT': this.PTTT??'CK',
      'Khoa': this.Khoa?1:0,
      'CreatedAt': this.CreatedAt,
      'CreatedBy': this.CreatedBy,
      'UpdatedAt': this.UpdatedAt,
      'UpdatedBy': this.UpdatedBy,
      'SoCT': this.SoCT,
      'TKNo': this.TKNo,
      'TKCo': this.TKCo,
    };
  }

  factory PhieuThuModel.fromMap(Map<String, dynamic> map) {
    return PhieuThuModel(
      ID: map['ID'] ,
      Phieu: map['Phieu'] ,
      Ngay: map['Ngay'] ,
      MaTC: map['MaTC'] ,
      MaKhach: map['MaKhach'] ,
      TenKhach: map['TenKhach'] ??'',
      DiaChi: map['DiaChi'] ??'',
      NguoiNop: map['NguoiNop'] ??'',
      NguoiThu: map['NguoiThu'] ??'',
      SoTien: toDouble(map['SoTien'].toString()),
      NoiDung: map['NoiDung'] ??'',
      PTTT: map['PTTT'] ,
      Khoa: toBoolean(map['Khoa'].toString()) ,
      CreatedAt: map['CreatedAt'] ??'',
      CreatedBy: map['CreatedBy'] ??'',
      UpdatedAt: map['UpdatedAt'] ??'',
      UpdatedBy: map['UpdatedBy'] ??'',
      SoCT: map['SoCT'] ??'',
      TKNo: map['TKNo'] ,
      TKCo: map['TKCo'] ,
      STT: map['STT'] ,
      Count: map['Count'] ,
    );
  }

  PhieuThuModel copyWith({
    int? ID,
    String? Phieu,
    String? Ngay,
    String? MaTC,
    String? MaKhach,
    String? TenKhach,
    String? DiaChi,
    String? NguoiNop,
    String? NguoiThu,
    double? SoTien,
    String? NoiDung,
    String? PTTT,
    bool? Khoa,
    String? CreatedAt,
    String? CreatedBy,
    String? UpdatedAt,
    String? UpdatedBy,
    String? SoCT,
    String? TKNo,
    String? TKCo,
    int? Stt,
    int? Count,
  }) {
    return PhieuThuModel(
      ID: ID ?? this.ID,
      Phieu: Phieu ?? this.Phieu,
      Ngay: Ngay ?? this.Ngay,
      MaTC: MaTC ?? this.MaTC,
      MaKhach: MaKhach ?? this.MaKhach,
      TenKhach: TenKhach ?? this.TenKhach,
      DiaChi: DiaChi ?? this.DiaChi,
      NguoiNop: NguoiNop ?? this.NguoiNop,
      NguoiThu: NguoiThu ?? this.NguoiThu,
      SoTien: SoTien ?? this.SoTien,
      NoiDung: NoiDung ?? this.NoiDung,
      PTTT: PTTT ?? this.PTTT,
      Khoa: Khoa ?? this.Khoa,
      CreatedAt: CreatedAt ?? this.CreatedAt,
      CreatedBy: CreatedBy ?? this.CreatedBy,
      UpdatedAt: UpdatedAt ?? this.UpdatedAt,
      UpdatedBy: UpdatedBy ?? this.UpdatedBy,
      SoCT: SoCT ?? this.SoCT,
      TKNo: TKNo ?? this.TKNo,
      TKCo: TKCo ?? this.TKCo,
      STT: Stt ?? this.STT,
      Count: Count ?? this.Count,
    );
  }
}
