import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'bangtaikhoan_notifier.dart';

final bangTaiKhoanProvider = StateNotifierProvider.autoDispose<BangTaiKhoanNotifier, List<Map<String, dynamic>>>((ref) {
  return BangTaiKhoanNotifier();
});
