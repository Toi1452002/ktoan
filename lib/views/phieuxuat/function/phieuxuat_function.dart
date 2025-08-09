import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/application.dart';
import '../../../core/core.dart';
import '../../../data/data.dart';

class PhieuXuatFunction {
  Future<List<Map<String, dynamic>>> getKXuat() async {
    final rp = MaNghiepVuRepository();
    return await rp.getKXuat();
  }

  Future<void> onAdd(WidgetRef ref) async {
    final userName = ref.read(userInfoProvider)!.Username;
    final result = await ref.read(phieuXuatProvider.notifier).addPhieuXuat(userName);
    if (result != 0) ref.read(phieuXuatProvider.notifier).getPhieuXuat();
  }

  Future<List<Map<String, dynamic>>> getKH() async {
    return await KhachHangRepository().getListKhach();
  }

  Future<List<Map<String, dynamic>>> getBTK0() async {
    return await BangTaiKhoanRepository().get0();
  }

  Future<void> onChangedKhoa(bool value, WidgetRef ref) async {
    ref.read(phieuXuatProvider.notifier).changedKhoa(value);
  }

  Future<void> onChangedNgay(DateTime ngay, WidgetRef ref) async {
    ref.read(phieuXuatProvider.notifier).changedNgay(Helper.yMd(ngay));
  }

  Future<void> onChangedKXuat(String val, WidgetRef ref) async {
    ref.read(phieuXuatProvider.notifier).changedKXuat(val);
  }

  Future<void> onChangedKyHieu(String val, WidgetRef ref) async {
    ref.read(phieuXuatProvider.notifier).changedKyHieu(val);
  }

  Future<void> onChangedSoCT(String val, WidgetRef ref) async {
    ref.read(phieuXuatProvider.notifier).changedSoCT(val);
  }

  Future<void> onChangedDienGiai(String val, WidgetRef ref) async {
    ref.read(phieuXuatProvider.notifier).changedDienGiai(val);
  }

  Future<void> onChangedNgayCT(DateTime val, WidgetRef ref) async {
    ref.read(phieuXuatProvider.notifier).changedNgayCT(Helper.yMd(val));
  }

  Future<void> onChangedPTTT(String val, WidgetRef ref) async {
    ref.read(phieuXuatProvider.notifier).changedPTTT(val);
  }

  Future<void> onChangedKChiuThue(bool val, WidgetRef ref) async {
    ref.read(phieuXuatProvider.notifier).changedKChiuThue(val);
  }

  Future<void> onChangedMaKhach(String val, WidgetRef ref) async {
    ref.read(phieuXuatProvider.notifier).changedMaKhach(val);
  }

  Future<void> onChangedTKNo(String val, WidgetRef ref) async {
    ref.read(phieuXuatProvider.notifier).changedTkNo(val);
  }

  Future<void> onChangedTKCo(String val, WidgetRef ref) async {
    ref.read(phieuXuatProvider.notifier).changedTkCo(val);
  }

  Future<void> onChangedTKVatNo(String val, WidgetRef ref) async {
    ref.read(phieuXuatProvider.notifier).changedTkVatNo(val);
  }

  Future<void> onChangedTKVatCo(String val, WidgetRef ref) async {
    ref.read(phieuXuatProvider.notifier).changedTkVatCo(val);
  }

  Future<void> onChangedThueSuat(String val, WidgetRef ref) async {
    ref.read(phieuXuatProvider.notifier).changedThueSuat(val);
  }

  Future<void> onChangedCongTien(double val, WidgetRef ref) async {
    ref.read(phieuXuatProvider.notifier).changedCongTien(val);
  }

  Future<void> onChangedTienThue(double val, WidgetRef ref, {bool notifier = false}) async {
    ref.read(phieuXuatProvider.notifier).changedTienThue(val, notifier: notifier);
  }

  void onMovePage(int stt, int type, WidgetRef ref, int id) async {
    final result = await ref.read(phieuXuatProvider.notifier).movePage(stt, type);
    ref.read(phieuXuatCTProvider.notifier).getPXCT(result);
  }

  Future<void> onDeletePhieu(int id, WidgetRef ref) async {
    final btn = await CustomAlert.question('Có chắc muốn xóa?');
    if (btn == AlertButton.okButton) {
      final result = await ref.read(phieuXuatProvider.notifier).deletePhieu(id);
      if (result) {
        ref.read(phieuXuatProvider.notifier).getPhieuXuat();
      }
    }
  }
}
