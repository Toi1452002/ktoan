import 'package:flutter/material.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/application/application.dart';
import 'package:pm_ketoan/application/phieuchi/phieuchi_provider.dart';
import 'package:pm_ketoan/views/dm_nhanvien/thongtinnhanvien_view.dart';
import 'package:string_validator/string_validator.dart';

import '../../../core/core.dart';
import '../../../data/data.dart';
import '../../dm_khachhang/thong_tin_kh_view.dart';

class PhieuChiFunction {
  Future<List<Map<String, dynamic>>> loadKChi() async => await MaNghiepVuRepository().getKChi();

  Future<List<Map<String, dynamic>>> loadKhach() async => await KhachHangRepository().getNhaCung();

  Future<List<Map<String, dynamic>>> loadNhanVien() async => await NhanVienRepository().getList();

  Future<List<Map<String, dynamic>>> loadBTK() async => await BangTaiKhoanRepository().get0();

  Future<void> addPage(WidgetRef ref) async {
    final user = ref.read(userInfoProvider);
    final result = await ref.read(phieuChiProvider.notifier).addPhieu(user!.Username, user.HoTen);
    if (result != 0) {
      ref.read(phieuChiProvider.notifier).get();
      ref.refresh(phieuChiCTProvider);
    }
  }

  Future<void> delete(int id, WidgetRef ref) async {
    final btn = await CustomAlert.question('Có chắc muốn xóa?');
    if (btn == AlertButton.okButton) {
      final result = await ref.read(phieuChiProvider.notifier).delete(id);
      if (result) {
        final maID = await ref.read(phieuChiProvider.notifier).get();
        ref.read(phieuChiCTProvider.notifier).get(maID);
      }
    }
  }

  Future<void> updateKhoa(WidgetRef ref, bool val) async {
    ref.read(phieuChiProvider.notifier).updatedKhoa(val);
  }
  Future<void> updateNgay(WidgetRef ref, DateTime val) async {
    ref.read(phieuChiProvider.notifier).updatedNgay(Helper.yMd(val));
  }

  Future<void> updateKChi(WidgetRef ref, String val) async {
    ref.read(phieuChiProvider.notifier).updatedKChi(val);
  }
  Future<void> updateMaKhach(WidgetRef ref, String ma) async {
    final k = await KhachHangRepository().getKhach(ma);
    ref.read(phieuChiProvider.notifier).updateMaKhach(ma, k['TenKH']??'', k['DiaChi']??'');
  }

  Future<void> updateMaNV(WidgetRef ref, String ma) async {
    final nv = await NhanVienRepository().getNV(ma,columns: ['HoTen','DiaChi']);
    ref.read(phieuChiProvider.notifier).updateMaNV(ma, nv['HoTen']??'', nv['DiaChi']??'');
  }
  Future<void> updateTenKhach(WidgetRef ref, String val) async {
    ref.read(phieuChiProvider.notifier).updatedTenKhach(val);
  }

  Future<void> updateDiaChi(WidgetRef ref, String val) async {
    ref.read(phieuChiProvider.notifier).updatedDiaChi(val);
  }
  Future<void> updateNguoiNhan(WidgetRef ref, String val) async {
    ref.read(phieuChiProvider.notifier).updatedNguoiNhan(val);
  }

  Future<void> updateNguoiChi(WidgetRef ref, String val) async {
    ref.read(phieuChiProvider.notifier).updatedNguoiChi(val);
  }

  Future<void> updateSoTien(WidgetRef ref, String val,{bool notifier = false}) async {
    ref.read(phieuChiProvider.notifier).updatedSoTien(toDouble(val,),notifier: notifier);
  }

  Future<void> updateTKNo(WidgetRef ref, String val) async {
    ref.read(phieuChiProvider.notifier).updatedTKNo(val);
  }

  Future<void> updateTKCo(WidgetRef ref, String val) async {
    ref.read(phieuChiProvider.notifier).updatedTKCo(val);
  }

  Future<void> updateNoiDung(WidgetRef ref, String val) async {
    ref.read(phieuChiProvider.notifier).updatedNoiDung(val);
  }

  Future<void> updateSoCT(WidgetRef ref, String val) async {
    ref.read(phieuChiProvider.notifier).updatedSoCT(val);
  }

  Future<void> updatePTTT(WidgetRef ref, String val) async {
    ref.read(phieuChiProvider.notifier).updatedPTTT(val);
  }

  void onMovePage(int stt, int type, WidgetRef ref) async {
    final result = await ref.read(phieuChiProvider.notifier).movePage(stt, type);
    ref.read(phieuChiCTProvider.notifier).get(result);
  }

  void showKhachHang(String maKH, BuildContext context)async{
    final x = await KhachHangRepository().getKhach(maKH);
    final k = KhachHangModel.fromMap(x);
    ThongTinKHView.show(context,khach: k,isUpdate: false);
  }
  void showNhanVien(String maNV, BuildContext context)async{
    final x = await NhanVienRepository().getNV(maNV);
    final nv = NhanVienModel.fromMap(x);
    ThongTinNhanVienView.show(context,nv: nv,udMa: false);
  }
}
