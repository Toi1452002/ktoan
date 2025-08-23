import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/data/data.dart';
import 'package:string_validator/string_validator.dart';

import '../../core/core.dart';

class PhieuXuatNotifier extends StateNotifier<PhieuXuatModel?> {
  PhieuXuatNotifier() : super(null) {
    getPhieuXuat();
  }

  final _rp = PhieuXuatRepository();

  Future<int> getPhieuXuat({int? stt}) async {
    final data = await _rp.get(stt: stt);
    final num = await _rp.getNumRow();
    if (data.isNotEmpty) {
      state = PhieuXuatModel.fromMap(data).copyWith(countRow: num.toString());
      return state!.ID!;
    }else{
      state =  null;
    }
   return 0;
  }

  Future<int> movePage(int stt, int type) async {
    final num = await _rp.getNumRow();
    if (type == 0 && stt != 1) stt = 1;
    if (type == 1 && stt != 1) stt -= 1;
    if (type == 2 && stt != num) stt += 1;
    if (type == 3 && stt != num) stt = num;
    final data = await _rp.getTheoSTT(stt);
    state = PhieuXuatModel.fromMap(data).copyWith(countRow: num.toString());
    return state!.ID!;
  }

  Future<int> addPhieuXuat(String userName) async {
    final rpTuyChon = TuyChonRepository();
    String phieu = 'X000000';

    final lastP = await _rp.getMaPhieuCuoi();
    final pNN = await rpTuyChon.getPnN();
    final pNC = await rpTuyChon.getPnC();
    final pTN = await rpTuyChon.getTnN();
    final pTC = await rpTuyChon.getTnC();
    final ts = await rpTuyChon.getTS();
    final k = await  rpTuyChon.getQlKPC();

    if (lastP.isNotEmpty) {
      final num = int.parse(lastP.substring(1)) + 1;
      phieu = 'X${'0' * (6 - num.toString().length)}$num';
    }
    if(k==1){
      changedKhoa(true);
    }
    return _rp.add(
      PhieuXuatModel(
        Ngay: Helper.sqlDateTimeNow(),
        Phieu: phieu,
        CreatedBy: userName,
        ThueSuat: toDouble(ts.toString()),
        NgayCT: Helper.sqlDateTimeNow(),
        TKNo: pNN.toString(),
        TKCo: pNC.toString(),
        TKVatNo: pTN.toString(),
        TKVatCo: pTC.toString(),
        CreatedAt: Helper.sqlDateTimeNow(hasTime: true),
        KChiuThue: ts != 0 ? true : false,
      ).toMap(),
    );
  }

  Future<void> changedKhoa(bool value) async {
    await _rp.updateKhoa(value ? 1 : 0, state!.ID!);
    state = state?.copyWith(Khoa: value);
  }

  Future<void> changedNgay(String ngay) async {
    await _rp.updateNgay(ngay, state!.ID!);
    state = state?.copyWith(Ngay: ngay, NgayCT: ngay);
  }

  Future<void> changedKXuat(String val) async {
    await _rp.updateKXuat(val, state!.ID!);
    state = state?.copyWith(MaNX: val);
  }

  Future<void> changedKyHieu(String val) async {
    await _rp.updateKyHieu(val, state!.ID!);
    state?.KyHieu = val;
  }

  Future<void> changedSoCT(String val) async {
    await _rp.updateSoCT(val, state!.ID!);
    state?.SoHD = val;
  }

  Future<void> changedDienGiai(String val) async {
    await _rp.updateDienGiai(val, state!.ID!);
    state?.DienGiai = val;
  }

  Future<void> changedKChiuThue(bool val) async {
    await _rp.updateKChiuThue(val ? 1 : 0, state!.ID!);
    state = state?.copyWith(KChiuThue: val);
  }

  Future<void> changedThueSuat(String val) async {
    await _rp.updateThueSuat(val, state!.ID!);
    state?.ThueSuat = toDouble(val.toString());
  }

  Future<void> changedCongTien(double val) async {
    await _rp.updateCongTien(val, state!.ID!);
    state = state?.copyWith(CongTien: val);
  }

  Future<void> changedTienThue(double val, {bool notifier = false}) async {
    await _rp.updateTienThue(val, state!.ID!);
    if (notifier) {
      state = state?.copyWith(TienThue: val);
    } else {
      state?.TienThue = val;
    }
  }

  Future<void> changedPTTT(String val) async {
    await _rp.updatePTTT(val, state!.ID!);
    state = state?.copyWith(PTTT: val);
  }

  Future<void> changedNgayCT(String val) async {
    await _rp.updateNgayCT(val, state!.ID!);
    state = state?.copyWith(NgayCT: val);
  }

  Future<void> changedMaKhach(String val) async {
    final x = "Bán hàng cho $val";
    await _rp.updateMaKhach(val, state!.ID!);
    await _rp.updateDienGiai(x, state!.ID!);
    state = state?.copyWith(MaKhach: val, DienGiai: x);
  }

  Future<void> changedTkNo(String val) async {
    await _rp.updateTKNo(val, state!.ID!);
    state = state?.copyWith(TKNo: val);
  }

  Future<void> changedTkCo(String val) async {
    await _rp.updateTKCo(val, state!.ID!);
    state = state?.copyWith(TKCo: val);
  }

  Future<void> changedTkVatNo(String val) async {
    await _rp.updateTKVatNo(val, state!.ID!);
    state = state?.copyWith(TKVatNo: val);
  }

  Future<void> changedTkVatCo(String val) async {
    await _rp.updateTKVatCo(val, state!.ID!);
    state = state?.copyWith(TKVatCo: val);
  }

  Future<bool> deletePhieu(int id) async => await _rp.delete(id);
}
