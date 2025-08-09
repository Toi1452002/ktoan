import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/application/phieunhap/phieunhap_notiifier.dart';
import 'package:pm_ketoan/application/phieunhap/phieunhapct_notifier.dart';
import 'package:pm_ketoan/data/data.dart';

final phieuNhapProvider = StateNotifierProvider.autoDispose<PhieuNhapNotifier, PhieuNhapModel?>((ref) {
  return PhieuNhapNotifier();
});

//Phieu nhap chi tiet
final phieuNhapCTProvider = StateNotifierProvider.autoDispose<PhieuNhapCTNotifier, List<Map<String, dynamic>>>((ref) {
  return PhieuNhapCTNotifier();
});
