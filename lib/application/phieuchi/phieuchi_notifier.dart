import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/data/data.dart';

import '../../core/utils/helper.dart';

class PhieuChiNotifier extends StateNotifier<PhieuChiModel?> {
  PhieuChiNotifier() : super(null);

  final _rp = PhieuChiRepository();

  Future<int> get({String? phieu}) async {
    final data = await _rp.get(phieu: phieu);
    final num = await _rp.getNumRow();
    if (data.isNotEmpty) {
      state = PhieuChiModel.fromMap(data).copyWith(Count: num);
      return state!.ID!;
    } else {
      state = null;
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
    state = PhieuChiModel.fromMap(data).copyWith(Count: num);
    return state!.ID!;
  }

  Future<int> addPhieu(String userName, String nguoiChi) async {
    final rpTuyChon = TuyChonRepository();
    String phieu = 'C000000';

    final lastP = await _rp.getMaPhieuCuoi();
    final pCN = await rpTuyChon.getPcN();
    final pCC = await rpTuyChon.getPcC();
    final k = await rpTuyChon.getQlKPC();

    if (lastP.isNotEmpty) {
      final num = int.parse(lastP.substring(1)) + 1;
      phieu = 'C${'0' * (6 - num.toString().length)}$num';
    }
    if (k == 1) {
      updatedKhoa(true);
    }
    return _rp.add(
      PhieuChiModel(
        Ngay: Helper.sqlDateTimeNow(),
        Phieu: phieu,
        CreatedBy: userName,
        NguoiChi: nguoiChi,
        TKNo: pCN.toString(),
        TKCo: pCC.toString(),
        CreatedAt: Helper.sqlDateTimeNow(hasTime: true),
        Khoa: false,
      ).toMap(),
    );
  }

  Future<bool> delete(int id) async => await _rp.delete(id);

  Future<void> updatedKhoa(bool val) async {
    await _rp.updateKhoa(val ? 1 : 0, state!.ID!);
    state = state?.copyWith(Khoa: val);
  }

  Future<void> updatedNgay(String ngay) async {
    await _rp.updateNgay(ngay, state!.ID!);
    state = state?.copyWith(Ngay: ngay);
  }

  Future<void> updateMaKhach(String maKhach, String tenKhach, String diaChi) async {
    await _rp.updateMaKhach(maKhach, tenKhach, diaChi, state!.ID!);
    state = state?.copyWith(MaKhach: maKhach, TenKhach: tenKhach, DiaChi: diaChi);
  }

  Future<void> updateMaNV(String maNV, String tenKhach, String diaChi) async {
    await _rp.updateMaNV(maNV, tenKhach, diaChi, state!.ID!);
    state = state?.copyWith(MaNV: maNV, TenKhach: tenKhach, DiaChi: diaChi);
  }

  Future<void> updatedKChi(String val) async {
    await _rp.updateKChi(val, state!.ID!);
    state = state?.copyWith(MaTC: val);
  }

  Future<void> updatedTenKhach(String val) async {
    await _rp.updateTenKhach(val, state!.ID!);
    state?.TenKhach = val;
  }

  Future<void> updatedDiaChi(String val) async {
    await _rp.updateDiaChi(val, state!.ID!);
    state?.DiaChi = val;
  }

  Future<void> updatedNguoiNhan(String val) async {
    await _rp.updateNguoiNhan(val, state!.ID!);
    state?.NguoiNhan = val;
  }

  Future<void> updatedNguoiChi(String val) async {
    await _rp.updateNguoiChi(val, state!.ID!);
    state?.NguoiChi = val;
  }

  Future<void> updatedSoTien(double val, {bool notifier = false}) async {
    await _rp.updateSoTien(val, state!.ID!);
    if (notifier) {
      state = state?.copyWith(SoTien: val);
    } else {
      state?.SoTien = val;
    }
  }

  Future<void> updatedTKNo(String val) async {
    await _rp.updateTKNo(val, state!.ID!);
    state = state?.copyWith(TKNo: val);
  }

  Future<void> updatedTKCo(String val) async {
    await _rp.updateTKCo(val, state!.ID!);
    state = state?.copyWith(TKCo: val);
  }

  Future<void> updatedNoiDung(String val) async {
    await _rp.updateNoiDung(val, state!.ID!);
    state?.NoiDung = val;
  }

  Future<void> updatedSoCT(String val) async {
    await _rp.updateSoCT(val, state!.ID!);
    state?.SoCT = val;
  }

  Future<void> updatedPTTT(String val) async {
    await _rp.updatePTTT(val, state!.ID!);
    state = state?.copyWith(PTTT: val);
  }
}
