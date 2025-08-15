import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/application/phieuchi/phieuchi_notifier.dart';
import 'package:pm_ketoan/application/phieuchi/phieuchict_notifier.dart';
import 'package:pm_ketoan/data/data.dart';

final phieuChiProvider = StateNotifierProvider.autoDispose<PhieuChiNotifier, PhieuChiModel?>((ref) {
  return PhieuChiNotifier();
});

final phieuChiCTProvider = StateNotifierProvider.autoDispose<PhieuChiCTNotifier, List<Map<String, dynamic>>>((ref) {
  return PhieuChiCTNotifier();
});
