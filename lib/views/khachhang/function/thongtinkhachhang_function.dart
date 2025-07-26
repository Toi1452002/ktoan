import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/application/application.dart';
import 'package:pm_ketoan/core/core.dart';
import 'package:pm_ketoan/data/data.dart';

class ThongTinKhachHangFunction{
  void onSubmit(WidgetRef ref, BuildContext context, KhachHangModel khach, {bool isUpdate = false, String maUpdate = ''}) async{
    final user = ref.read(userInfoProvider)?.Username;
    final tDoi = ref.read(khachHangTheoDoiProvider);

    KhachHangModel khachData = khach;

    bool result = false;
    if(!isUpdate){
      khachData = khachData.copyWith(CreatedAt: user);
      result = await ref.read(khachHangProvider.notifier).addKhach(khachData);
    }else{
      khachData = khachData.copyWith(UpdatedBy: user,UpdatedAt: Helper.sqlDateTimeNow(hasTime: true));
      result = await ref.read(khachHangProvider.notifier).updateKhach(khachData, maUpdate);
    }

    if(result){
      ref.read(khachHangProvider.notifier).getListKhach(td: tDoi);
      if (context.mounted) Navigator.pop(context);
    }

  }
}