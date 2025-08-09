import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/application/application.dart';
import 'package:pm_ketoan/core/core.dart';
import 'package:pm_ketoan/data/data.dart';
import 'package:pm_ketoan/views/hanghoa/donvitinh_view.dart';
import 'package:pm_ketoan/views/hanghoa/nhomhang_view.dart';

class ThongTinHangHoaFunction {
  Future<void> submitHangHoa(
    WidgetRef ref,
    BuildContext context, {
    required String ma,
    required String ten,
    int? loaiHang,
    int? donViTinh,
    int? nhomHang,
    String? nhaCung,
    required String kho,
    required String giaMua,
    required String giaBan,
    String? ghiChu,
    bool tt = true,
    bool td = true,
    bool isUpdate = false,
    int? id,
  }) async {
    final user = ref.read(userInfoProvider)?.Username;
    final tDoi = ref.read(hangHoaTheoDoiProvider);
    HangHoaModel hangHoa = HangHoaModel(
      MaHH: ma,
      LoaiHHID: loaiHang,
      TenHH: ten,
      GiaMua: Helper.numToDouble(giaMua),
      GiaBan: Helper.numToDouble(giaBan),
      MaNC: nhaCung,
      GhiChu: ghiChu,
      NhomID: nhomHang,
      DVTID: donViTinh,
      TinhTon: tt,
      TheoDoi: td,
      TKkho: kho,
      CreatedBy: user!,
    );
    bool result = false;
    if (!isUpdate) {
      result = await ref.read(hangHoaProvider.notifier).addHangHoa(hangHoa);
    } else {
      hangHoa = hangHoa.copyWith(ID: id, UpdatedAt: Helper.sqlDateTimeNow(hasTime: true), UpdatedBy: user);
      result = await ref.read(hangHoaProvider.notifier).updateHangHoa(hangHoa);
    }

    if (result) {
      ref.read(hangHoaProvider.notifier).getListHangHoa(td: tDoi);
      if (context.mounted) Navigator.pop(context);
    }
  }

  String changedNumSubmit(String text) {
    if (text.isNotEmpty) {
      return Helper.numFormat(text)!;
    }
    return '';
  }

  void onFocusChanged(bool b, TextEditingController controller, FocusNode focus) {
    b ? focus.requestFocus() : controller.text = changedNumSubmit(controller.text);
  }

  Future<List<Map<String, dynamic>>> getLoaiHang() async {
    return await HangHoaRepository().getLoaiHang();
  }

  Future<List<Map<String, dynamic>>> getKho() async {
    return await BangTaiKhoanRepository().getKho15();
  }

  Future<List<Map<String, dynamic>>> getNhaCung() async {
    return await KhachHangRepository().getNhaCung();
  }

  Future<List<Map<String, dynamic>>> getDonViTinh() async {
    return await DonViTinhRepository().getDonViTinh();
  }

  Future<List<Map<String, dynamic>>> getNhomHang() async {
    return await NhomhangRepository().getNhomHang();
  }

  void showDonViTinh(BuildContext context,void Function() onClose){
    DonViTinhView.show(context, onClose);
  }

  void showNhomHang(BuildContext context, void Function() onClose){
    NhomHangView.show(context, onClose);
  }
}
