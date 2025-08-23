import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/application/application.dart';
import 'package:pm_ketoan/core/core.dart';
import 'package:pm_ketoan/data/data.dart';
import 'package:string_validator/string_validator.dart';
import 'package:trina_grid/trina_grid.dart';

class PhieuNhapCTFunction {
  Future<List<Map<String, dynamic>>> loadHH() async => await HangHoaRepository().getData();

  Future<List<Map<String, dynamic>>> loadBTK() async => await BangTaiKhoanRepository().getKho15();

  Future<void> onChangedMaHang(WidgetRef ref, TrinaColumnRendererContext re,  int  maID) async {
    // final maID = re.row.cells['null']!.value;
    final id = re.row.cells['dl']?.value;
    if (id == null) {
      // Insert ma hang
      final result = await ref.read(phieuNhapCTProvider.notifier).addMaHang(re.cell.value, maID);
      if (result != 0) {
        ref.read(phieuNhapCTProvider.notifier).getPNCT(maID);
        re.row.cells['dl']?.value = result;
      }
    } else {
      //Update ma hang
      final soLg = toDouble(re.row.cells['SoLg']!.value.toString());
      final result = await ref.read(phieuNhapCTProvider.notifier).updateMaHang(re.cell.value, id, soLg: soLg);
      if (result) {
        await ref.read(phieuNhapCTProvider.notifier).getPNCT(maID).whenComplete((){
          ref.read(phieuNhapProvider.notifier).changedCongTien(tongThanhTien(re.stateManager));
        });
      }
    }
  }

  void updateKho(TrinaColumnRendererContext re, WidgetRef ref) {
    final id = re.row.cells['dl']?.value;
    if (id == null) {
      CustomAlert.warning('Chọn mã hàng trước');
      re.cell.value=null;
    } else {
      ref.read(phieuNhapCTProvider.notifier).updateKho(re.cell.value, id);
    }
  }

  void onChanged(TrinaGridOnChangedEvent event, WidgetRef ref,TrinaGridStateManager state) {
    final id = event.row.cells['dl']?.value;
    final field = event.column.field;
    final notifier = ref.read(phieuNhapCTProvider.notifier);
    if (id == null) {
      // insert
      CustomAlert.warning('Chọn mã hàng trước');
      event.row.cells[field]?.value = '';
    } else {
      final donGia = event.row.cells['DonGia']!.value;
      final soLg = event.row.cells['SoLg']!.value;
      final thanhTien = event.row.cells['ThanhTien']!.value;

      if (field == 'TenHH') notifier.updateTenHH(event.value, id);
      if (field == 'DVT') notifier.updateDVT(event.value, id);
      if (field == 'SoLg') {
        event.row.cells['ThanhTien']!.value = soLg * donGia;
        notifier.updateSoLg(
          toDouble(event.value.toString()),
          id,
          toDouble(event.row.cells['ThanhTien']!.value.toString()),
        );
      }
      if (field == 'DonGia') {
        event.row.cells['ThanhTien']!.value = soLg * donGia;
        notifier.updateDonGia(
          toDouble(event.value.toString()),
          id,
          toDouble(event.row.cells['ThanhTien']!.value.toString()),
        );
      }
      if (field == 'ThanhTien') {
        event.row.cells['DonGia']!.value = thanhTien / soLg;
        notifier.updateThanhTien(
          toDouble(event.value.toString()),
          id,
          toDouble(event.row.cells['DonGia']!.value.toString()),
        );
      }

      ref.read(phieuNhapProvider.notifier).changedCongTien(tongThanhTien(state));

    }
  }

  void onDeleteRow(int id, TrinaColumnRendererContext event, WidgetRef  ref) async{
    final btn =  await  CustomAlert.question('Có chắc muốn xóa?');
    if(btn  ==  AlertButton.okButton){
      final result =  await  ref.read(phieuNhapCTProvider.notifier).deleteRow(id);
      if(result){
        event.stateManager.removeCurrentRow();
        ref.read(phieuNhapProvider.notifier).changedCongTien(tongThanhTien(event.stateManager));
      }
    }
  }


  dynamic  tongThanhTien(TrinaGridStateManager state){
    double tongTien = 0;
    for(var x  in state.rows){
      tongTien += x.cells['ThanhTien']!.value;
    }
    return tongTien;
  }
}
