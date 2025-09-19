import 'package:intl/intl.dart';
import 'package:string_validator/string_validator.dart';

class Helper {
  static String? numFormat(dynamic number) {
    if (number == null) {
      return null;
    } else {
      try {
        String strNum = number.toString();
        if (strNum.contains(',')) strNum = strNum.replaceAll(',', '');
        final num = double.parse(strNum);
        return NumberFormat('#,###.##', "en_US").format(num);
      } catch (e) {
        return number;
      }
    }
  }

  static double numToDouble(String value, {bool keepChar = false}) {
    if (value.isNotEmpty) {
      if (keepChar) {
        value = value.replaceAll(',', '.');
      } else {
        value = value.replaceAll(',', '');
      }
      return double.parse(value);
    }
    return 0;
  }

  static String sqlDateTimeNow({bool hasTime = false}) {
    if (hasTime) {
      return DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    } else {
      return DateFormat('yyyy-MM-dd').format(DateTime.now());
    }
  }

  static String dMy(dynamic date) {
    if (date == null) return '';
    if (date.runtimeType == DateTime) {
      return DateFormat('dd/MM/yyyy').format(date);
    } else if (date.runtimeType == String) {
      return DateFormat('dd/MM/yyyy').format(toDate(date)!);
    }

    return date.toString();
  }

  static String yM(dynamic date) {
    return DateFormat('yyyy-MM').format(date);
  }

  static String yMd(dynamic date) {
    if (date.runtimeType == DateTime) {
      return DateFormat('yyyy-MM-dd').format(date);
    }
    if (date.runtimeType == String) {
      final tmp = date.toString().split('/');
      return "${tmp.last}-${tmp[1]}-${tmp.first}";
    }
    return date.toString();
  }

  static DateTime? strToDate(String date) {
    if (date.contains('/')) {
      final str = date.split('/');
      final x = "${str.last}-${str[1]}-${str.first}";
      return toDate(x);
    } else {
      return null;
    }
  }

  static int getQuarterNow() {
    int month = DateTime.now().month;
    int quarter = ((month - 1) ~/ 3) + 1;
    return quarter;
  }

  static String strLast(String value) {
    return value[value.length - 1];
  }

  static int strCount(String value, String char) {
    final lst = value.split(char).length;
    return lst == 0 ? 0 : lst - 1;
  }
}
