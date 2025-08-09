import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'manghiepvu_notifier.dart';

final maNghiepVuProvider = StateNotifierProvider.autoDispose<MaNghiepVuNotifier, List<Map<String, dynamic>>>((ref) {
  return MaNghiepVuNotifier();
});
