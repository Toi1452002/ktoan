import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/application/application.dart';


final hangHoaProvider = StateNotifierProvider.autoDispose<HangHoaNotifier, List<Map<String,dynamic>>>((ref) {
  return HangHoaNotifier();
});


final hangHoaHideFilterProvider = StateProvider.autoDispose<bool>((ref) {
  return true;
});

final hangHoaTheoDoiProvider = StateProvider.autoDispose<int>((ref) {
  return 1;
});


