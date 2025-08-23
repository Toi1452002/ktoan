import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/application/nhanvien/nhanvien_notifier.dart';
import 'package:pm_ketoan/application/nhanvien/pcgt_notifier.dart';
import 'package:pm_ketoan/data/data.dart';

final nhanVienProvider = StateNotifierProvider.autoDispose<NhanVienNotifier, List<NhanVienModel>>((ref) {
  return NhanVienNotifier();
});

final pcgtProvider = StateNotifierProvider.autoDispose<PCGTNotifier, List<PCGTModel>>((ref) {
  return PCGTNotifier();
});
