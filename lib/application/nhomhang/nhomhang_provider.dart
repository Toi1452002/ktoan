import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'nhomhang_notifier.dart';


final nhomHangProvider = StateNotifierProvider.autoDispose<NhomHangNotifier,List<Map<String, dynamic>> >((ref) {
  return NhomHangNotifier();
});
