import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/application/application.dart';
import 'package:pm_ketoan/core/core.dart';
import 'package:pm_ketoan/data/data.dart';
import 'package:pm_ketoan/views/dm_khachhang/thong_tin_kh_view.dart';
import 'package:string_validator/string_validator.dart';

class PhieuThuFunction {
  Future<List<Map<String, dynamic>>> loadKThu() async => await MaNghiepVuRepository().getKThu();

  Future<List<Map<String, dynamic>>> loadKhach() async => await KhachHangRepository().getListKhach();

  Future<List<Map<String, dynamic>>> loadBTK() async => await BangTaiKhoanRepository().get0();

  Future<void> addPage(WidgetRef ref) async {
    final user = ref.read(userInfoProvider);
    final result = await ref.read(phieuThuProvider.notifier).addPhieuThu(user!.Username, user.HoTen);
    if (result != 0) {
      ref.read(phieuThuProvider.notifier).get();
      ref.refresh(phieuThuCTProvider);
    }
  }

  Future<void> delete(int id, WidgetRef ref) async {
    final btn = await CustomAlert.question('Có chắc muốn xóa?');
    if (btn == AlertButton.okButton) {
      final result = await ref.read(phieuThuProvider.notifier).delete(id);
      if (result) {
        final maID  = await ref.read(phieuThuProvider.notifier).get();
        ref.read(phieuThuCTProvider.notifier).get(maID);
      }
    }
  }

  Future<void> updateKhoa(WidgetRef ref, bool val) async {
    ref.read(phieuThuProvider.notifier).updatedKhoa(val);
  }

  Future<void> updateNgayThu(WidgetRef ref, DateTime val) async {
    ref.read(phieuThuProvider.notifier).updatedNgay(Helper.yMd(val));
  }

  Future<void> updateKThu(WidgetRef ref, String val) async {
    ref.read(phieuThuProvider.notifier).updatedKThu(val);
  }

  Future<void> updateMaKhach(WidgetRef ref, String ma, String ten, String diaChi) async {
    final khach = await KhachHangRepository().getKhach(ma);
    ref.read(phieuThuProvider.notifier).updateMaKhach(ma, khach['TenKH'], khach['DiaChi']);
  }

  Future<void> updateTenKhach(WidgetRef ref, String val) async {
    ref.read(phieuThuProvider.notifier).updatedTenKhach(val);
  }

  Future<void> updateDiaChi(WidgetRef ref, String val) async {
    ref.read(phieuThuProvider.notifier).updatedDiaChi(val);
  }

  Future<void> updateNguoiNop(WidgetRef ref, String val) async {
    ref.read(phieuThuProvider.notifier).updatedNguoiNop(val);
  }

  Future<void> updateNguoiThu(WidgetRef ref, String val) async {
    ref.read(phieuThuProvider.notifier).updatedNguoiThu(val);
  }

  Future<void> updateSoTien(WidgetRef ref, String val,{bool notifier = false}) async {
    ref.read(phieuThuProvider.notifier).updatedSoTien(toDouble(val,),notifier: notifier);
  }

  Future<void> updateTKNo(WidgetRef ref, String val) async {
    ref.read(phieuThuProvider.notifier).updatedTKNo(val);
  }

  Future<void> updateTKCo(WidgetRef ref, String val) async {
    ref.read(phieuThuProvider.notifier).updatedTKCo(val);
  }

  Future<void> updateNoiDung(WidgetRef ref, String val) async {
    ref.read(phieuThuProvider.notifier).updatedNoiDung(val);
  }

  Future<void> updateSoCT(WidgetRef ref, String val) async {
    ref.read(phieuThuProvider.notifier).updatedSoCT(val);
  }

  Future<void> updatePTTT(WidgetRef ref, String val) async {
    ref.read(phieuThuProvider.notifier).updatedPTTT(val);
  }

  void onMovePage(int stt, int type, WidgetRef ref) async {
    final result = await ref.read(phieuThuProvider.notifier).movePage(stt, type);
    ref.read(phieuThuCTProvider.notifier).get(result);
  }

  void showKhachHang(String maKH, BuildContext context)async{
    final x = await KhachHangRepository().getKhach(maKH);
    final k = KhachHangModel.fromMap(x);
    ThongTinKHView.show(context,khach: k,isUpdate: false);
  }
}
