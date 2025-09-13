import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/application/ts_ccdc/ccdc_notifier.dart';

final ccdcProvider = StateNotifierProvider.autoDispose<CCDCNotifier, List<Map<String, dynamic>>>((ref) {
  return CCDCNotifier();
});
