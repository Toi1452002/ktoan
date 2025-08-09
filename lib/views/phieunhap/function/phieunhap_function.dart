import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/application/application.dart';
import 'package:pm_ketoan/core/core.dart';
import 'package:pm_ketoan/data/data.dart';

class PhieuNhapFunction {
  Future<void> onAdd(WidgetRef ref) async {
    final userName = ref.read(userInfoProvider)!.Username;
    final result = await ref.read(phieuNhapProvider.notifier).addPhieuNhap(userName);
    if (result != 0) ref.read(phieuNhapProvider.notifier).getPhieuNhap();
  }

  Future<void> onChangedKhoa(bool value, WidgetRef ref) async {
    ref.read(phieuNhapProvider.notifier).changedKhoa(value);
  }

  Future<void> onChangeNgay(DateTime ngay, WidgetRef ref) async {
    ref.read(phieuNhapProvider.notifier).changedNgay(Helper.yMd(ngay));
  }

  Future<void> onChangedKNhap(String val, WidgetRef ref) async {
    ref.read(phieuNhapProvider.notifier).changedKNhap(val);
  }

  Future<void> onChangedKyHieu(String val, WidgetRef ref) async {
    ref.read(phieuNhapProvider.notifier).changedKyHieu(val);
  }

  Future<void> onChangedSoCT(String val, WidgetRef ref) async {
    ref.read(phieuNhapProvider.notifier).changedSoCT(val);
  }

  Future<void> onChangedDienGiai(String val, WidgetRef ref) async {
    ref.read(phieuNhapProvider.notifier).changedDienGiai(val);
  }

  Future<void> onChangedNgayCT(DateTime val, WidgetRef ref) async {
    ref.read(phieuNhapProvider.notifier).changedNgayCT(Helper.yMd(val));
  }

  Future<void> onChangedPTTT(String val, WidgetRef ref) async {
    ref.read(phieuNhapProvider.notifier).changedPTTT(val);
  }

  Future<void> onChangedMaKhach(String val, WidgetRef ref) async {
    ref.read(phieuNhapProvider.notifier).changedMaKhach(val);
  }

  Future<void> onChangedTKNo(String val, WidgetRef ref) async {
    ref.read(phieuNhapProvider.notifier).changedTkNo(val);
  }

  Future<void> onChangedTKCo(String val, WidgetRef ref) async {
    ref.read(phieuNhapProvider.notifier).changedTkCo(val);
  }

  Future<void> onChangedTKVatNo(String val, WidgetRef ref) async {
    ref.read(phieuNhapProvider.notifier).changedTkVatNo(val);
  }

  Future<void> onChangedTKVatCo(String val, WidgetRef ref) async {
    ref.read(phieuNhapProvider.notifier).changedTkVatCo(val);
  }

  Future<void> onChangedThueSuat(String val, WidgetRef ref) async {
    ref.read(phieuNhapProvider.notifier).changedThueSuat(val);
  }

  Future<void> onChangedCongTien(double val, WidgetRef ref) async {
    ref.read(phieuNhapProvider.notifier).changedCongTien(val);
  }

  Future<void> onChangedTienThue(double val, WidgetRef ref, {bool notifier = false}) async {
    ref.read(phieuNhapProvider.notifier).changedTienThue(val, notifier: notifier);
  }

  Future<List<Map<String, dynamic>>> getKNhap() async {
    final rp = MaNghiepVuRepository();
    return await rp.getKNhap();
  }

  Future<List<Map<String, dynamic>>> getNCung() async {
    return await KhachHangRepository().getNhaCung();
  }

  Future<List<Map<String, dynamic>>> getBTK0() async {
    return await BangTaiKhoanRepository().get0();
  }

  void onMovePage(int stt, int type, WidgetRef ref, int id)  async{
    final result = await ref.read(phieuNhapProvider.notifier).movePage(stt, type);
    ref.read(phieuNhapCTProvider.notifier).getPNCT(result);
  }

  Future<void> onDeletePhieu(int id, WidgetRef ref) async{
    final btn  =  await CustomAlert.question('Có chắc muốn xóa?');
    if(btn == AlertButton.okButton){
      final  result  =  await ref.read(phieuNhapProvider.notifier).deletePhieu(id);
      if(result){
        ref.read(phieuNhapProvider.notifier).getPhieuNhap();
      }
    }
  }
}
