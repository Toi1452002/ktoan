import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/application/phieuxuat/phieuxuat_notifier.dart';
import 'package:pm_ketoan/application/phieuxuat/phieuxuatct_notifier.dart';
import 'package:pm_ketoan/data/data.dart';

final phieuXuatProvider = StateNotifierProvider.autoDispose<PhieuXuatNotifier, PhieuXuatModel?>((ref) {
  return PhieuXuatNotifier();
});

final phieuXuatCTProvider = StateNotifierProvider.autoDispose<PhieuXuatCTNotifier, List<Map<String, dynamic>>>((ref) {
  return PhieuXuatCTNotifier();
});
