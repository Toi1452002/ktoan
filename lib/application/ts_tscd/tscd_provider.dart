import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'tscd_notifier.dart';

final tscdProvider = StateNotifierProvider.autoDispose<TSCDNotifier, List<Map<String, dynamic>>>((ref) {
  return TSCDNotifier();
});
