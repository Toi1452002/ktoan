// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter
class UserModel  {
  final int? ID;
  final String Username;
  final String Password;
  final int Level;
  final String HoTen;
  final String DienThoai;
  final String DiaChi;
  final String Email;
  final String GhiChu;

  const UserModel({
    this.ID,
    required this.Username,
    required this.Password,
    required this.Level,
    required this.HoTen,
    required this.DienThoai,
    required this.DiaChi,
    required this.Email,
    required this.GhiChu,
  });

  Map<String, dynamic> toMap() {
    return {
      'ID': this.ID,
      'Username': this.Username,
      'Password': this.Password,
      'Level': this.Level,
      'HoTen': this.HoTen,
      'DienThoai': this.DienThoai,
      'DiaChi': this.DiaChi,
      'Email': this.Email,
      'GhiChu': this.GhiChu,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      ID: map['ID'] ,
      Username: map['Username'] ,
      Password: map['Password'] ??"",
      Level: map['Level'] ??1,
      HoTen: map['HoTen'] ??'',
      DienThoai: map['DienThoai']??'' ,
      DiaChi: map['DiaChi'] ??'',
      Email: map['Email'] ??'',
      GhiChu: map['GhiChu'] ??'',
    );
  }

  UserModel copyWith({
    int? ID,
    String? Username,
    String? Password,
    int? Level,
    String? HoTen,
    String? DienThoai,
    String? DiaChi,
    String? Email,
    String? GhiChu,
  }) {
    return UserModel(
      ID: ID ?? this.ID,
      Username: Username ?? this.Username,
      Password: Password ?? this.Password,
      Level: Level ?? this.Level,
      HoTen: HoTen ?? this.HoTen,
      DienThoai: DienThoai ?? this.DienThoai,
      DiaChi: DiaChi ?? this.DiaChi,
      Email: Email ?? this.Email,
      GhiChu: GhiChu ?? this.GhiChu,
    );
  }
}