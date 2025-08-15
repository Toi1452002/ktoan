// ignore_for_file: type=lint

import 'package:string_validator/string_validator.dart';

class PhieuChiModel {
  final int? ID;
  final String Phieu;
  final String Ngay;
  final String? MaTC;
  final String? MaKhach;
  final String? MaNV;
  String? TenKhach;
  String? DiaChi;
  String? NguoiChi;
  String? NguoiNhan;
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

  PhieuChiModel({
    this.ID,
    required this.Phieu,
    required this.Ngay,
    this.MaTC,
    this.MaKhach,
    this.MaNV,
    this.TenKhach,
    this.DiaChi,
    this.NguoiChi,
    this.NguoiNhan,
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
      'MaNV': this.MaNV,
      'TenKhach': this.TenKhach,
      'DiaChi': this.DiaChi,
      'NguoiChi': this.NguoiChi,
      'NguoiNhan': this.NguoiNhan,
      'SoTien': this.SoTien??0,
      'NoiDung': this.NoiDung,
      'PTTT': this.PTTT ?? "CK",
      'Khoa': this.Khoa ? 1 : 0,
      'CreatedAt': this.CreatedAt,
      'CreatedBy': this.CreatedBy,
      'UpdatedAt': this.UpdatedAt,
      'UpdatedBy': this.UpdatedBy,
      'SoCT': this.SoCT,
      'TKNo': this.TKNo,
      'TKCo': this.TKCo,
    };
  }

  factory PhieuChiModel.fromMap(Map<String, dynamic> map) {
    return PhieuChiModel(
      ID: map['ID'],
      Phieu: map['Phieu'],
      Ngay: map['Ngay'],
      MaTC: map['MaTC'],
      MaKhach: map['MaKhach'],
      MaNV: map['MaNV'],
      TenKhach: map['TenKhach'] ?? '',
      DiaChi: map['DiaChi'] ?? '',
      NguoiChi: map['NguoiChi'] ?? '',
      NguoiNhan: map['NguoiNhan'] ?? '',
      SoTien: toDouble(map['SoTien'].toString()),
      NoiDung: map['NoiDung'] ?? '',
      PTTT: map['PTTT'],
      Khoa: toBoolean(map['Khoa'].toString()),
      CreatedAt: map['CreatedAt'] ?? '',
      CreatedBy: map['CreatedBy'] ?? "",
      UpdatedAt: map['UpdatedAt'] ?? '',
      UpdatedBy: map['UpdatedBy'] ?? '',
      SoCT: map['SoCT'],
      TKNo: map['TKNo'],
      TKCo: map['TKCo'],
      STT: map['STT'],
      Count: map['Count'],
    );
  }

  PhieuChiModel copyWith({
    int? ID,
    String? Phieu,
    String? Ngay,
    String? MaTC,
    String? MaKhach,
    String? MaNV,
    String? TenKhach,
    String? DiaChi,
    String? NguoiChi,
    String? NguoiNhan,
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
    int? STT,
    int? Count,
  }) {
    return PhieuChiModel(
      ID: ID ?? this.ID,
      Phieu: Phieu ?? this.Phieu,
      Ngay: Ngay ?? this.Ngay,
      MaTC: MaTC ?? this.MaTC,
      MaKhach: MaKhach ?? this.MaKhach,
      MaNV: MaNV ?? this.MaNV,
      TenKhach: TenKhach ?? this.TenKhach,
      DiaChi: DiaChi ?? this.DiaChi,
      NguoiChi: NguoiChi ?? this.NguoiChi,
      NguoiNhan: NguoiNhan ?? this.NguoiNhan,
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
      STT: STT ?? this.STT,
      Count: Count ?? this.Count,
    );
  }
}
