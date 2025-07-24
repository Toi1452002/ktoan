import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/core/core.dart';
import 'package:pm_ketoan/data/data.dart';

abstract class HangHoaState {}

class HangHoaInit extends HangHoaState {}

class HangHoaLoading extends HangHoaState {}

class HangHoaData extends HangHoaState {
  final List<Map<String,dynamic>> data;

  HangHoaData({required this.data});
}

class HangHoaNotifier extends StateNotifier<HangHoaState> {
  HangHoaNotifier() : super(HangHoaInit()){
    getListHangHoa();
  }

  final _rp = HangHoaRepository();

  Future<void> getListHangHoa({int td = 1}) async {
    state = HangHoaLoading();
    await Future.delayed(Duration(milliseconds: 300));
    state = HangHoaData(data: await _rp.getData(td: td));
  }

  Future<bool> addHangHoa(HangHoaModel hangHoa) async{
    try{
      return await _rp.add(hangHoa.toMap());
    }catch(e){
      CustomAlert.error(e.toString());
      return false;
    }
  }

  Future<bool> updateHangHoa(HangHoaModel hangHoa) async{
    try{
      return await _rp.update(hangHoa.toMap());
    }catch(e){
      CustomAlert.error(e.toString());
      return false;
    }
  }

  Future<HangHoaModel> getHangHoa(String ma) async{
    final result = await _rp.getHangHoa(ma);
    return HangHoaModel.fromMap(result);
  }
}
