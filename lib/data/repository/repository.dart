import 'package:get_storage/get_storage.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../../core/core.dart';


export 'user_repository.dart';
export 'hanghoa_repository.dart';
export 'donvitinh_repository.dart';

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



