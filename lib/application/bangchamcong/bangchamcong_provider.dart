import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/application/bangchamcong/bangchamcong_notifier.dart';

final bangChamCongProvider = StateNotifierProvider.autoDispose<BangChamCongNotifier, List<Map<String, dynamic>>>((ref) {
  return BangChamCongNotifier();
});
