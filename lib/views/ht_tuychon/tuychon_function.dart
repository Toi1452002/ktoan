import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:pm_ketoan/core/core.dart';
import 'package:pm_ketoan/data/data.dart';

class TuyChonFunction {
  Future<List<Map<String, dynamic>>> getQL() async {
    final data = await TuyChonRepository().getTuyChon();
    if (data.isNotEmpty) {
      return data.where((e) => e['Nhom'].toString().startsWith('q')).toList();
    } else {
      return [];
    }
  }

  Future<Map<String, dynamic>> getGV() async {
    final data = await TuyChonRepository().getTuyChon();
    if (data.isNotEmpty) {
      return data.firstWhere((e) => e['Nhom'].toString().startsWith('g'));
    } else {
      return {};
    }
  }

  Future<void> updateTuyChon(Map<String, int> map, BuildContext context) async {
    final result = await TuyChonRepository().updateTuyChon(map);
    if (result) {
      final btn = await CustomAlert.success('Cập nhật thành công');
      if (btn == AlertButton.okButton) {
        if (context.mounted) Navigator.pop(context);
      }
    }
  }
}
