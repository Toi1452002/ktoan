import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/application/phieuthu/phieuthu_notifier.dart';
import 'package:pm_ketoan/application/phieuthu/phieuthuct_notifier.dart';

import '../../data/data.dart';

final phieuThuProvider = StateNotifierProvider.autoDispose<PhieuThuNotifier, PhieuThuModel?>((ref) {
  return PhieuThuNotifier();
});

final phieuThuCTProvider = StateNotifierProvider.autoDispose<PhieuThuCTNotifier, List<Map<String, dynamic>>>((ref) {
  return PhieuThuCTNotifier();
});
