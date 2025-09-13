import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/data/data.dart';

class HangHoaNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  HangHoaNotifier() : super([]) {
    getListHangHoa();
  }

  final _rp = HangHoaRepository();

  Future<void> getListHangHoa({int td = 1}) async {
    final x = await _rp.getData(td: td);
    if(mounted){
      state = x;
    }
  }

  Future<bool> addHangHoa(HangHoaModel hangHoa) async {
    return await _rp.add(hangHoa.toMap()) != 0;
  }

  Future<bool> updateHangHoa(HangHoaModel hangHoa) async {
    return await _rp.update(hangHoa.toMap());
  }

  Future<HangHoaModel> getHangHoa(String ma) async {
    final result = await _rp.getHangHoa(ma);
    return HangHoaModel.fromMap(result);
  }

  Future<bool> delete(int id) async {
    return await _rp.delete(id);
  }
}
