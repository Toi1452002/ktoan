import 'package:pm_ketoan/data/data.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../../core/core.dart';
class BaseRepository{
  Future<List<Map<String, dynamic>>> getListMap(String name,{String? where, List<Object?>? whereArgs,String? orderBy}) async{
    try{
      final cnn = await connectData();
      final data = await cnn!.query(name,where: where, whereArgs: whereArgs,orderBy:orderBy );
      return data;
    }catch(e){
      errorSql(e);
      return [];
    }
  }

  Future<Map<String, dynamic>> getMap(String name,{String? where, List<Object?>? whereArgs}) async{
    try{
      final cnn = await connectData();
      final data = await cnn!.query(name, where: where, whereArgs: whereArgs,limit: 1);
      return data.isEmpty ?  {} : data.first;
    }catch(e){
      errorSql(e);
      return {};
    }
  }

  Future<int> addMap(String name,Map<String, dynamic> map) async{
    try {
      final cnn = await connectData();
      return await cnn!.insert(name, map);
    } catch (e) {
      errorSql(e);
      return 0;
    }
  }

  Future<bool> updateMap(String name,Map<String, dynamic> map,{String? where, List<Object?>? whereArgs}) async{
    try {
      final cnn = await connectData();
      await cnn!.update(name, map,where: where, whereArgs: whereArgs);
      return true;
    } catch (e) {
      errorSql(e);
      return false;
    }
  }

  Future<bool> delete(String name,{String? where, List<Object?>? whereArgs} ) async{
    try {
      final cnn = await connectData();
      await cnn!.delete(name,where: where, whereArgs: whereArgs);
      return true;
    } catch (e) {
      errorSql(e);
      return false;
    }
  }
}


Future<Database?> connectData() async{
  try{
    final cnn = await databaseFactory.openDatabase(GetStorage().read(GetKey.pathData));
    await cnn.execute('PRAGMA foreign_keys = ON');
    return cnn;
  }catch(e){
    throw Exception(e);
  }
}

errorSql(Object e) {
  if (e is DatabaseException) {
    try {
      final a = e.toString().indexOf('SqliteException(');
      int b = e.toString().indexOf('Causing ');
      String title = e.toString().substring(a, b);

      if(title.contains('FOREIGN KEY')) title = "Không thể xóa do đang có phát sinh";

      CustomAlert.error(title);
    } catch (err) {
      CustomAlert.error(e.toString());
    }
  } else {
    CustomAlert.error(e.toString());
  }
}


