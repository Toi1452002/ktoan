import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/application/application.dart';

final maNghiepVuProvider = StateNotifierProvider.autoDispose<MaNghiepVuNotifier, List<Map<String, dynamic>>>((ref) {
  return MaNghiepVuNotifier();
});
