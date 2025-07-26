import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class MenuModel {
  final String title;
  final bool hasChild;
  final bool enabled;

  const MenuModel({required this.title, this.hasChild = false, this.enabled = true});

  MenuModel copyWith({String? title, bool? hasChild, bool? enabled}) {
    return MenuModel(title: title ?? this.title, hasChild: hasChild ?? this.hasChild, enabled: enabled ?? this.enabled);
  }
}

final menuProvider = StateProvider<List<TreeNode>>((ref) {
  List<TreeNode> result = mMenu.entries.map((e){
    if(!e.value.hasChild){
      return TreeItem(data: e.value.title);
    }else{
      final m1 = mMenu1[e.key];

      return TreeItem(data: e.value.title, children: [
       ...?m1?.entries.map((e1){
         if(e1.value.hasChild){
           final m2 = mMenu2[e1.key];
           List<TreeNode> lstItem = [];
           m2?.forEach((k,v){
             lstItem.add(TreeItem(data: v.title));
           });
           return TreeItem(data: e1.value.title,children: lstItem);
         }else{
           return TreeItem(data: e1.value.title);
         }
       })
      ]);
    }
  }).toList();

  return result;
});


Map<String, MenuModel> mMenu = {
  'TDM': MenuModel(title: 'DANH MỤC', hasChild: true),
  'TNX': MenuModel(title: 'MUA BÁN', hasChild: true),
  'TTC': MenuModel(title: 'THU CHI', hasChild: true),
  'TCN': MenuModel(title: 'CÔNG NỢ', hasChild: true),
  'TKH': MenuModel(title: 'KHO HÀNG', hasChild: true),
  'TGT': MenuModel(title: 'GIÁ THÀNH', hasChild: true),
  'TLU': MenuModel(title: 'TIỀN LƯƠNG', hasChild: true),
  'TTS': MenuModel(title: 'TÀI SẢN', hasChild: true),
  'TKT': MenuModel(title: 'KẾ TOÁN', hasChild: true),
  'THT': MenuModel(title: 'HỆ THỐNG', hasChild: true),
};

Map<String, Map<String, MenuModel>> mMenu1 = {
  'TDM': {
    'FDM_BkeHangHoa': MenuModel(title: 'Hàng hóa'),
    'FDM_BkeKhachHang': MenuModel(title: 'Khách hàng'),
    'FDM_MaNghiepVu': MenuModel(title: 'Mã nghiệp vụ'),
    'FDM_BangTaiKhoan': MenuModel(title: 'Bảng tài khoản'),
    'TDM1': MenuModel(title: 'Đầu kỳ', hasChild: true),
  },
};

Map<String, Map<String, MenuModel>> mMenu2 = {
  'TDM1':{
    'FDM_DkyKhachHang': MenuModel(title: 'Nợ đầu kỳ'),
    'FDM_DkyHangHoa': MenuModel(title: 'Tồn đầu kỳ'),
    'FDM_DKyTaiKhoan': MenuModel(title: 'Đầu kỳ tài khoản'),
  }
};