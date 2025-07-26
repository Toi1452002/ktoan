// ignore_for_file: type=lint

import 'package:string_validator/string_validator.dart';

class KhachHangModel {
  final String MaKhach;
  final String TenKH;
  final String DiaChi;
  final String DienThoai;
  final String DiDong;
  final String Fax;
  final String Email;
  final String MST;
  final String SoTK;
  final String NganHang;
  final String GhiChu;
  final String? LoaiKH;
  final bool TheoDoi;
  final String? CreatedAt;
  final String? CreatedBy;
  final String? UpdatedAt;
  final String? UpdatedBy;

  const KhachHangModel({
    required this.MaKhach,
    required this.TenKH,
    required this.DiaChi,
    required this.DienThoai,
    required this.DiDong,
    required this.Fax,
    required this.Email,
    required this.MST,
    required this.SoTK,
    required this.NganHang,
    required this.GhiChu,
    this.LoaiKH,
    required this.TheoDoi,
    this.CreatedAt,
    this.CreatedBy,
    this.UpdatedAt,
    this.UpdatedBy,
  });

  Map<String, dynamic> toMap() {
    return {
      'MaKhach': this.MaKhach,
      'TenKH': this.TenKH,
      'DiaChi': this.DiaChi,
      'DienThoai': this.DienThoai,
      'DiDong': this.DiDong,
      'Fax': this.Fax,
      'Email': this.Email,
      'MST': this.MST,
      'SoTK': this.SoTK,
      'NganHang': this.NganHang,
      'GhiChu': this.GhiChu,
      'LoaiKH': this.LoaiKH,
      'TheoDoi': this.TheoDoi ? 1 : 0,
      'CreatedAt': this.CreatedAt,
      'CreatedBy': this.CreatedBy,
      'UpdatedAt': this.UpdatedAt,
      'UpdatedBy': this.UpdatedBy,
    };
  }

  factory KhachHangModel.fromMap(Map<String, dynamic> map) {
    return KhachHangModel(
      MaKhach: map['MaKhach'],
      TenKH: map['TenKH'],
      DiaChi: map['DiaChi'] ?? '',
      DienThoai: map['DienThoai'] ?? '',
      DiDong: map['DiDong'] ?? '',
      Fax: map['Fax'] ?? '',
      Email: map['Email'] ?? '',
      MST: map['MST'] ?? '',
      SoTK: map['SoTK'] ?? '',
      NganHang: map['NganHang'] ?? '',
      GhiChu: map['GhiChu'] ?? '',
      LoaiKH: map['LoaiKH'] ?? '',
      TheoDoi: toBoolean(map['TheoDoi'].toString()),
      CreatedAt: map['CreatedAt'] ?? '',
      CreatedBy: map['CreatedBy'] ?? '',
      UpdatedAt: map['UpdatedAt'] ?? '',
      UpdatedBy: map['UpdatedBy'] ?? '',
    );
  }

  KhachHangModel copyWith({
    String? MaKhach,
    String? TenKH,
    String? DiaChi,
    String? DienThoai,
    String? DiDong,
    String? Fax,
    String? Email,
    String? MST,
    String? SoTK,
    String? NganHang,
    String? GhiChu,
    String? LoaiKH,
    bool? TheoDoi,
    String? CreatedAt,
    String? CreatedBy,
    String? UpdatedAt,
    String? UpdatedBy,
  }) {
    return KhachHangModel(
      MaKhach: MaKhach ?? this.MaKhach,
      TenKH: TenKH ?? this.TenKH,
      DiaChi: DiaChi ?? this.DiaChi,
      DienThoai: DienThoai ?? this.DienThoai,
      DiDong: DiDong ?? this.DiDong,
      Fax: Fax ?? this.Fax,
      Email: Email ?? this.Email,
      MST: MST ?? this.MST,
      SoTK: SoTK ?? this.SoTK,
      NganHang: NganHang ?? this.NganHang,
      GhiChu: GhiChu ?? this.GhiChu,
      LoaiKH: LoaiKH ?? this.LoaiKH,
      TheoDoi: TheoDoi ?? this.TheoDoi,
      CreatedAt: CreatedAt ?? this.CreatedAt,
      CreatedBy: CreatedBy ?? this.CreatedBy,
      UpdatedAt: UpdatedAt ?? this.UpdatedAt,
      UpdatedBy: UpdatedBy ?? this.UpdatedBy,
    );
  }
}
