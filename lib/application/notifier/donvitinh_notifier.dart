import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/data/data.dart';

class DonViTinhNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  DonViTinhNotifier() : super([]){
    getDonViTinh();
  }
  final _rp = DonViTinhRepository();

  Future<void> getDonViTinh() async {
    state = await _rp.getList();
  }

  Future<void> add(String value) async{
    await _rp.add({
      'DVT': value
    });
  }
  
  Future<void> update(String value, int id) async{
    await _rp.update({
      'ID': id,
      'DVT': value
    });
  }

  Future<void> delete(int id) async{
    await _rp.delete(id);
  }
}
