import 'package:get_storage/get_storage.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../../core/core.dart';

class BaseRepository {
  Future<List<Map<String, dynamic>>> getListMap(
    String name, {
    String? where,
    List<String>? columns,
    List<Object?>? whereArgs,
    String? orderBy,
  }) async {
    try {
      final cnn = await connectData();
      final data = await cnn!.query(name, columns: columns, where: where, whereArgs: whereArgs, orderBy: orderBy);
      return data;
    } catch (e) {
      errorSql(e);
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getSQL(String sql) async {
    try {
      final cnn = await connectData();
      final data = await cnn!.rawQuery(sql);
      return data;
    } catch (e) {
      errorSql(e);
      return [];    }
  }

  Future<Map<String, dynamic>> getMap(String name, {String? where, List<Object?>? whereArgs, String? orderBy,List<String>? columns}) async {
    try {
      final cnn = await connectData();
      final data = await cnn!.query(name, where: where,columns: columns, whereArgs: whereArgs, limit: 1, orderBy: orderBy);
      return data.isEmpty ? {} : data.first;
    } catch (e) {
      errorSql(e);
      return {};
    }
  }

  Future<int> addMap(String name, Map<String, dynamic> map) async {
    try {
      final cnn = await connectData();
      final result = await cnn!.insert(name, map);
      return result;
    } catch (e) {
      errorSql(e);
      return 0;
    }
  }

  Future<bool> updateMap(
    String name,
    Map<String, dynamic> map, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    try {
      final cnn = await connectData();
      await cnn!.update(name, map, where: where, whereArgs: whereArgs);
      return true;
    } catch (e) {
      errorSql(e);
      return false;
    }
  }

  Future<bool> delete(String name, {String? where, List<Object?>? whereArgs}) async {
    try {
      final cnn = await connectData();
      await cnn!.delete(name, where: where, whereArgs: whereArgs);
      return true;
    } catch (e) {
      errorSql(e);
      return false;
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

  Future<void> addRows(String name, List<Map<String, dynamic>> data) async {
    try {
      final cnn = await connectData();
      final batch = cnn!.batch();
      for (var x in data) {
        batch.insert(name, x);
      }
      await batch.commit(noResult: true);
    } catch (e) {
      errorSql(e);
    }
  }

  Future<bool> updateRows(String name, List<Map<String, dynamic>> data, String fieldWhere) async {
    try {
      final cnn = await connectData();
      final batch = cnn!.batch();
      for (var x in data) {
        batch.update(name, x, where: "$fieldWhere = ?", whereArgs: [x[fieldWhere]]);
      }
      await batch.commit(noResult: true);
      return true;
    } catch (e) {
      errorSql(e);
      return false;
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

      // if (title.contains('FOREIGN KEY')) title = "Không thể xóa do đang có phát sinh";

      CustomAlert.error(title);
    } catch (err) {
      CustomAlert.error(e.toString());
    }
  } else {
    CustomAlert.error(e.toString());
  }
}

// enum ResponseType { success, error }
//
// class ResponseState {
//   final ResponseType status;
//   final dynamic data;
//   final dynamic message;
//
//   const ResponseState({required this.status, this.message, this.data});
// }
