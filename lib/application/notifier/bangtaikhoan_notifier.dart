import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/data/data.dart';


class BangTaiKhoanNotifier extends StateNotifier<List<Map<String,dynamic>>> {
  BangTaiKhoanNotifier() : super([]){
    get();
  }

  final _rp = BangTaiKhoanRepository();

  Future<void> get() async => state = await _rp.getList();

}