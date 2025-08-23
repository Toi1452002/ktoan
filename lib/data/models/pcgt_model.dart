// ignore_for_file: type=lint

import 'package:string_validator/string_validator.dart';

class PCGTModel {
  final int? ID;
  final String MaNV;
  final String MaPC;
  final String MoTa;
  double SoTieuChuan;
  final double SoThucTe;

  PCGTModel({
    this.ID,
    required this.MaNV,
    required this.MaPC,
    required this.MoTa,
    required this.SoTieuChuan,
    required this.SoThucTe,
  });

  Map<String, dynamic> toMap() {
    return {
      'ID': this.ID,
      'MaNV': this.MaNV,
      'MaPC': this.MaPC,
      'SoTieuChuan': this.SoTieuChuan,
      'SoThucTe': this.SoThucTe,
    };
  }

  factory PCGTModel.fromMap(Map<String, dynamic> map) {
    return PCGTModel(
      ID: map['ID'],
      MaNV: map['MaNV'] ?? '',
      MaPC: map['MaPC'] ?? '',
      MoTa: map['MoTa'] ?? "",
      SoTieuChuan: toDouble(map['SoTieuChuan'].toString()),
      SoThucTe: toDouble(map['SoThucTe'].toString()),
    );
  }

  PCGTModel copyWith({int? ID, String? MaNV, String? MaPC, String? MoTa, double? SoTieuChuan, double? SoThucTe}) {
    return PCGTModel(
      ID: ID ?? this.ID,
      MaNV: MaNV ?? this.MaNV,
      MaPC: MaPC ?? this.MaPC,
      MoTa: MoTa ?? this.MoTa,
      SoTieuChuan: SoTieuChuan ?? this.SoTieuChuan,
      SoThucTe: SoThucTe ?? this.SoThucTe,
    );
  }
}
