import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/application/donvitinh/donvitinh_notifier.dart';


final donViTinhProvider = StateNotifierProvider.autoDispose<DonViTinhNotifier,List<Map<String, dynamic>> >((ref) {
  return DonViTinhNotifier();
});
