import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/data/data.dart';

class BangChamCongNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  BangChamCongNotifier() : super([]);
  final _rp = BangChamCongRepository();

  Future<void> get(int thang, String nam) async {
    state = await _rp.get(thang.toString(), nam);
  }
}
