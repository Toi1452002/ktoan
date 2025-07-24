// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

import 'package:string_validator/string_validator.dart';

class HangHoaModel  {
  final int? ID;
  final String MaHH;
  final String TenHH;
  final int? DVTID;
  final int? LoaiHHID;
  final int? NhomID;
  final double GiaMua;
  final double GiaBan;
  final String? MaNC;
  final String? GhiChu;
  final bool TinhTon;
  final bool TheoDoi;
  final String TKkho;
  final String? CreatedAt;
  final String CreatedBy;
  final String? UpdatedAt;
  final String? UpdatedBy;

  const HangHoaModel({
    this.ID,
    required this.MaHH,
    required this.TenHH,
    this.DVTID,
    this.LoaiHHID,
    this.NhomID,
    required this.GiaMua,
    required this.GiaBan,
    this.MaNC,
    this.GhiChu,
    required this.TinhTon,
    required this.TheoDoi,
    required this.TKkho,
    this.CreatedAt,
    required this.CreatedBy,
    this.UpdatedAt,
    this.UpdatedBy,
  });

  Map<String, dynamic> toMap() {
    return {
      'ID': this.ID,
      'MaHH': this.MaHH,
      'TenHH': this.TenHH,
      'DVTID': this.DVTID,
      'LoaiHHID': this.LoaiHHID,
      'NhomID': this.NhomID,
      'GiaMua': this.GiaMua,
      'GiaBan': this.GiaBan,
      'MaNC': this.MaNC,
      'GhiChu': this.GhiChu,
      'TinhTon': this.TinhTon?1:0,
      'TheoDoi': this.TheoDoi?1:0,
      'TKkho': this.TKkho,
      'CreatedAt': this.CreatedAt,
      'CreatedBy': this.CreatedBy,
      'UpdatedAt': this.UpdatedAt,
      'UpdatedBy': this.UpdatedBy,
    };
  }

  factory HangHoaModel.fromMap(Map<String, dynamic> map) {
    return HangHoaModel(
      ID: map['ID'] ,
      MaHH: map['MaHH'] ,
      TenHH: map['TenHH'] ,
      DVTID: map['DVTID'] ,
      LoaiHHID: map['LoaiHHID'] ,
      NhomID: map['NhomID'] ,
      GiaMua: toDouble(map['GiaMua'].toString()),
      GiaBan: toDouble(map['GiaBan'].toString()) ,
      MaNC: map['MaNC'] ,
      GhiChu: map['GhiChu'] ,
      TinhTon: toBoolean(map['TinhTon'].toString()) ,
      TheoDoi: toBoolean(map['TheoDoi'].toString()) ,
      TKkho: map['TKkho'] ,
      CreatedAt: map['CreatedAt'] ??'',
      CreatedBy: map['CreatedBy']??'' ,
      UpdatedAt: map['UpdatedAt'] ??'',
      UpdatedBy: map['UpdatedBy'] ??'',
    );
  }

  HangHoaModel copyWith({
    int? ID,
    String? MaHH,
    String? TenHH,
    int? DVTID,
    int? LoaiHHID,
    int? NhomID,
    double? GiaMua,
    double? GiaBan,
    String? MaNC,
    String? GhiChu,
    bool? TinhTon,
    bool? TheoDoi,
    String? TKkho,
    String? CreatedAt,
    String? CreatedBy,
    String? UpdatedAt,
    String? UpdatedBy,
  }) {
    return HangHoaModel(
      ID: ID ?? this.ID,
      MaHH: MaHH ?? this.MaHH,
      TenHH: TenHH ?? this.TenHH,
      DVTID: DVTID ?? this.DVTID,
      LoaiHHID: LoaiHHID ?? this.LoaiHHID,
      NhomID: NhomID ?? this.NhomID,
      GiaMua: GiaMua ?? this.GiaMua,
      GiaBan: GiaBan ?? this.GiaBan,
      MaNC: MaNC ?? this.MaNC,
      GhiChu: GhiChu ?? this.GhiChu,
      TinhTon: TinhTon ?? this.TinhTon,
      TheoDoi: TheoDoi ?? this.TheoDoi,
      TKkho: TKkho ?? this.TKkho,
      CreatedAt: CreatedAt ?? this.CreatedAt,
      CreatedBy: CreatedBy ?? this.CreatedBy,
      UpdatedAt: UpdatedAt ?? this.UpdatedAt,
      UpdatedBy: UpdatedBy ?? this.UpdatedBy,
    );
  }
}
