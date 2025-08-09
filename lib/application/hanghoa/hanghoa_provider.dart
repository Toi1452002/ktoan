import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'hanghoa_notifer.dart';


final hangHoaProvider = StateNotifierProvider.autoDispose<HangHoaNotifier, List<Map<String,dynamic>>>((ref) {
  return HangHoaNotifier();
});


final hangHoaHideFilterProvider = StateProvider.autoDispose<bool>((ref) {
  return true;
});

final hangHoaTheoDoiProvider = StateProvider.autoDispose<int>((ref) {
  return 1;
});


