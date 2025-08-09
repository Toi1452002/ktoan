import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/data/data.dart';

import 'khachhang_notifier.dart';

final khachHangProvider = StateNotifierProvider.autoDispose<KhachHangNotifier,List<KhachHangModel> >((ref) {
  return KhachHangNotifier();
});

final khachHangHideFilterProvider = StateProvider.autoDispose<bool>((ref) {
  return true;
});


final khachHangTheoDoiProvider = StateProvider.autoDispose<int>((ref) {
  return 1;
});