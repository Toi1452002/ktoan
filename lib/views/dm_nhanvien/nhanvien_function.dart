import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/application/application.dart';
import 'package:pm_ketoan/core/core.dart';
import 'package:pm_ketoan/data/data.dart';
import 'package:pm_ketoan/views/dm_nhanvien/thongtinnhanvien_view.dart';
import 'package:string_validator/string_validator.dart';
import 'package:trina_grid/trina_grid.dart';

class NhanVienFunction {
  void showInfo(BuildContext context, {WidgetRef? ref, String? maNV}) {
    if (ref != null && maNV != null) {
      final nv = ref.read(nhanVienProvider).firstWhere((e) => e.MaNV == maNV);
      ThongTinNhanVienView.show(context, nv: nv);
    } else {
      ThongTinNhanVienView.show(context);
    }
  }

  Future<void> addNV(NhanVienModel nv, WidgetRef ref, BuildContext context) async {
    final result = await ref.read(nhanVienProvider.notifier).add(nv);
    if (result) {
      ref.read(pcgtProvider.notifier).addData(nv.MaNV);
      ref.read(nhanVienProvider.notifier).get();
      if (context.mounted) Navigator.pop(context);
    }
  }

  Future<void> updateNV(NhanVienModel nv, WidgetRef ref, BuildContext context) async {
    final result = await ref.read(nhanVienProvider.notifier).update(nv);
    if (result) {
      ref.read(pcgtProvider.notifier).addData(nv.MaNV);
      ref.read(nhanVienProvider.notifier).get();
      if (context.mounted) Navigator.pop(context);
    }
  }

  Future<void> deleteNV(WidgetRef ref, int id, TrinaColumnRendererContext event) async {
    final btn = await CustomAlert.question('Có chắc muốn xóa');
    if (btn == AlertButton.okButton) {
      final result = await ref.read(nhanVienProvider.notifier).delete(id);
      if (result) {
        event.stateManager.removeCurrentRow();
      }
    }
  }

  void updatePCGT(TrinaGridOnChangedEvent event, WidgetRef ref) {
    final maPC = event.row.cells['null']?.value;
    final value = event.value;
    ref.read(pcgtProvider.notifier).updateData(maPC, toDouble(value.toString()));
  }
}
