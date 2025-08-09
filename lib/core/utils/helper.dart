import 'package:intl/intl.dart';

class Helper{
  static String? numFormat(dynamic number){

    if(number==null) {
      return null;
    } else{
      try{
        String strNum = number.toString();
        if(strNum.contains(',')) strNum = strNum.replaceAll(',', '');
        final num = double.parse(strNum);
        return NumberFormat('#,###.##',"en_US").format(num);

      }catch(e){
        return number;
      }
    }

  }

  static double numToDouble(String value, {bool keepChar = false}){
    if(value.isNotEmpty){

      if(keepChar){
        value = value.replaceAll(',', '.');
      }else{
        value = value.replaceAll(',', '');
      }
      return double.parse(value);
    }
    return 0;
  }

  static String sqlDateTimeNow({bool hasTime = false}){
    if(hasTime){
      return  DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    }else{
      return  DateFormat('yyyy-MM-dd').format(DateTime.now());

    }
  }

  static String dMy(dynamic date){
    if(date.runtimeType == DateTime){
      return DateFormat('dd/MM/yyyy').format(date);
    }
    return date.toString();
  }
  static String yMd(dynamic date){
    if(date.runtimeType == DateTime){
      return DateFormat('yyyy-MM-dd').format(date);
    }
    if(date.runtimeType == String){
      final tmp = date.toString().split('/');
      return "${tmp.last}-${tmp[1]}-${tmp.first}";
    }
    return date.toString();
  }

}