import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/application/application.dart';


final nhomHangProvider = StateNotifierProvider.autoDispose<NhomHangNotifier,List<Map<String, dynamic>> >((ref) {
  return NhomHangNotifier();
});
