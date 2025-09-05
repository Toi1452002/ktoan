import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/application/bangluong/bangluong_notifier.dart';

final bangLuongProvider = StateNotifierProvider.autoDispose<BangLuongNotifier, List<Map<String, dynamic>>>((ref) {
  return BangLuongNotifier();
});
