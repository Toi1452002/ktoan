import 'package:get_storage/get_storage.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../../core/core.dart';

class BaseRepository {
  Future<ResponseState> getListMap(String name, {String? where, List<Object?>? whereArgs, String? orderBy}) async {
    try {
      final cnn = await connectData();
      final data = await cnn!.query(name, where: where, whereArgs: whereArgs, orderBy: orderBy);
      return ResponseState(status: ResponseType.success, data: data);
    } catch (e) {
      return ResponseState(status: ResponseType.error, message: e.toString());
    }
  }

  Future<Map<String, dynamic>> getMap(String name, {String? where, List<Object?>? whereArgs, String? orderBy}) async {
    try {
      final cnn = await connectData();
      final data = await cnn!.query(name, where: where, whereArgs: whereArgs, limit: 1, orderBy: orderBy);
      return data.isEmpty ? {} : data.first;
    } catch (e) {
      errorSql(e);
      return {};
    }
  }

  Future<ResponseState> addMap(String name, Map<String, dynamic> map) async {
    try {
      final cnn = await connectData();
      final result = await cnn!.insert(name, map);
      return ResponseState(status: ResponseType.success, data: result);
    } catch (e) {
      return ResponseState(status: ResponseType.error, message: e.toString());
    }
  }

  Future<ResponseState> updateMap(
    String name,
    Map<String, dynamic> map, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    try {
      final cnn = await connectData();
      await cnn!.update(name, map, where: where, whereArgs: whereArgs);
      return ResponseState(status: ResponseType.success);
    } catch (e) {
      return ResponseState(status: ResponseType.error, message: e.toString());
    }
  }

  Future<ResponseState> delete(String name, {String? where, List<Object?>? whereArgs}) async {
    try {
      final cnn = await connectData();
      await cnn!.delete(name, where: where, whereArgs: whereArgs);
      return ResponseState(status: ResponseType.success, data: true);
    } catch (e) {
      return ResponseState(status: ResponseType.error, message: e.toString());
    }
  }

  Future<dynamic> getCell(String name, {required String field, String? condition}) async {
    try {
      final cnn = await connectData();
      final x = await cnn!.rawQuery('''SELECT $field FROM $name ${condition == null ? '' : 'WHERE $condition'} ''');

      return x.isNotEmpty ? x.first[field] : null;
    } catch (e) {
      errorSql(e);
      return null;
    }
  }
}

Future<Database?> connectData() async {
  try {
    final cnn = await databaseFactory.openDatabase(GetStorage().read(GetKey.pathData));
    await cnn.execute('PRAGMA foreign_keys = ON');
    return cnn;
  } catch (e) {
    throw Exception(e);
  }
}

errorSql(Object e) {
  if (e is DatabaseException) {
    try {
      final a = e.toString().indexOf('SqliteException(');
      int b = e.toString().indexOf('Causing ');
      String title = e.toString().substring(a, b);

      if (title.contains('FOREIGN KEY')) title = "Không thể xóa do đang có phát sinh";

      CustomAlert.error(title);
    } catch (err) {
      CustomAlert.error(e.toString());
    }
  } else {
    CustomAlert.error(e.toString());
  }
}

enum ResponseType { success, error }

class ResponseState {
  final ResponseType status;
  final dynamic data;
  final String? message;

  const ResponseState({required this.status, this.message, this.data});
}
