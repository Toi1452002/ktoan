import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/application/application.dart';
import 'package:pm_ketoan/views/ht_phanquyennguoidung/phanquyennguoidung_function.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../views/views.dart';

class MenuModel {
  final String title;
  final bool hasChild;
  final String? parent;

  const MenuModel({required this.title, this.hasChild = false, this.parent});
}

final getKChoPhepProvider = FutureProvider.autoDispose<List<String>>((ref) async {
  final user = ref.watch(userInfoProvider);
  return await PhanQuyenNguoiDungFunction().getListKChoPhep(user!.Username);
});

final menuProvider = StateProvider.autoDispose<List<TreeNode>>((ref) {
  final lstPQ = ref.watch(getKChoPhepProvider).value;

  List<TreeNode> result = [];
  // Map<String, MenuModel> m = {...mMenu};
  // Map<String, MenuModel> m1 = {...mMenu1};
  // Map<String, MenuModel> m2 = {...mMenu2};

  if(lstPQ!=null){
    mMenu.forEach((k,v){
      List<TreeNode> a =  [];
      mMenu1.forEach((k1,v1){
        if(v1.parent == k){
          if(v1.hasChild){
            List<TreeNode> b =  [];
            mMenu2.forEach((k2,v2){
              if(v2.parent==k1 && !lstPQ.contains(k2)){
                b.add(TreeItem(data: v2.title));
              }
            });
            if(!lstPQ.contains(k1)){
              a.add(TreeItem(data: v1.title,children: b));
            }
          }else{
            if(!lstPQ.contains(k1)){
              a.add(TreeItem(data: v1.title));
            }
          }
        }
      });
      if(!lstPQ.contains(k)){
        result.add(TreeItem(data: v.title,children: a));
      }
    });
  }


  return result;
});


// final menuProvider = StateProvider.autoDispose<List<TreeNode>>((ref) {
//   final lstKChoPhep = ref.watch(getKChoPhepProvider);
//   Map mMenuCopy = Map.from(mMenu);
//   var mMenu1Copy = {...mMenu1};
//   var mMenu2Copy = {...mMenu2};
//
//   if (lstKChoPhep.hasValue) {
//     final mCopy = mMenuCopy.keys.toList();
//     final m1Copy = rmParent(mMenu1Copy);
//     final m2Copy = rmParent(mMenu2Copy);
//     for (var x in mCopy) {
//       if (lstKChoPhep.value!.contains(x)) {
//         mMenuCopy.removeWhere((k, v) => k == x);
//       }
//     }
//     for (var x in m1Copy) {
//       for (var y in x.value) {
//         if (lstKChoPhep.value!.contains(y)) {
//           mMenu1Copy[x.key]?.removeWhere((k, v) => k == y);
//         }
//       }
//       // if (lstKChoPhep.value!.contains(x)) {
//       //   print(x);
//       //   mMenu1Copy.removeWhere((k, v) => k == x);
//       // }
//     }
//     for (var x in m2Copy) {
//       for (var y in x.value) {
//         if (lstKChoPhep.value!.contains(y)) {
//           mMenu2Copy[x.key]?.removeWhere((k, v) => k == y);
//         }
//       }
//       // if (lstKChoPhep.value!.contains(x)) {
//       //   mMenu2Copy.removeWhere((k, v) => k == x);
//       // }
//     }
//   }
//   List<TreeNode> result = mMenuCopy.entries.map((e) {
//     if (!e.value.hasChild) {
//       return TreeItem(data: e.value.title);
//     } else {
//       Map<String, MenuModel>? m1 = mMenu1Copy[e.key];
//       return TreeItem(
//         data: e.value.title,
//         children: [
//           ...?m1?.entries.map((e1) {
//             if (e1.value.hasChild) {
//               final m2 = mMenu2Copy[e1.key];
//               List<TreeNode> lstItem = [];
//               m2?.forEach((k, v) {
//                 lstItem.add(TreeItem(data: v.title));
//               });
//               return TreeItem(data: e1.value.title, children: lstItem);
//             } else {
//               return TreeItem(data: e1.value.title);
//             }
//           }),
//         ],
//       );
//     }
//   }).toList();
//   return result;
// });

List<MapEntry> rmParent(Map<String, Map<String, MenuModel>> map) {
  List<MapEntry> result = [];
  map.forEach((k, v) {
    result.add(MapEntry(k, v.keys.toList()));
  });
  return result;
}

const Map<String, MenuModel> mMenu = {
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

const Map<String, MenuModel> mMenu1 = {
  'FDM_BkeHangHoa': MenuModel(title: 'Hàng hóa', parent: 'TDM'),
  'FDM_BkeKhachHang': MenuModel(title: 'Khách hàng', parent: 'TDM'),
  'FDM_BkeNhanVien': MenuModel(title: NhanVienView.name, parent: 'TDM'),
  'FDM_MaNghiepVu': MenuModel(title: 'Mã nghiệp vụ', parent: 'TDM'),
  'FDM_BangTaiKhoan': MenuModel(title: 'Bảng tài khoản', parent: 'TDM'),
  'TDM1': MenuModel(title: 'Đầu kỳ', hasChild: true, parent: 'TDM'),

  'FNX_PhieuNhap': MenuModel(title: 'Mua hàng', parent: 'TNX'),
  'FNX_PhieuXuat': MenuModel(title: 'Bán hàng', parent: 'TNX'),
  'TNX1': MenuModel(title: 'Báo cáo', hasChild: true, parent: 'TNX'),

  'FTC_PhieuThu': MenuModel(title: 'Phiếu thu', parent: 'TTC'),
  'FTC_PhieuChi': MenuModel(title: 'Phiếu chi', parent: 'TTC'),
  'TTC1': MenuModel(title: 'Báo cáo', hasChild: true, parent: 'TTC'),

  'FCN_SoMuaHang': MenuModel(title: SoMuaHangView.name, parent: 'TCN'),
  'FCN_SoBanHang': MenuModel(title: SoBanHangView.name, parent: 'TCN'),
  'FCN_TongHopCongNo': MenuModel(title: TongHopCongNoView.name, parent: 'TCN'),

  'FNX_BkeHangNhap': MenuModel(title: BangKeHangNhapView.name, parent: 'TKH'),
  'FNX_BkeHangXuat': MenuModel(title: BangKeHangXuatView.name, parent: 'TKH'),
  'FNX_NhapXuatTon': MenuModel(title: NhapXuatTonKhoView.name, parent: 'TKH'),

  'FGT_TinhGiaVon': MenuModel(title: 'Tính toán giá vốn', parent: 'TGT'),
  'GT1': MenuModel(title: 'Định mức sản xuất', parent: 'TGT'),
  'GT2': MenuModel(title: 'Bảng tính giá thành', parent: 'TGT'),
  'GT3': MenuModel(title: 'Thẻ tính giá thành', parent: 'TGT'),
  'GT4': MenuModel(title: 'Sổ chi phí SXKD', parent: 'TGT'),

  'TKT1': MenuModel(title: 'Nhật ký', hasChild: true, parent: 'TKT'),
  'TKT2': MenuModel(title: 'Báo cáo tài chính', hasChild: true, parent: 'TKT'),
  'TKT3': MenuModel(title: 'Báo cáo thuế', hasChild: true, parent: 'TKT'),

  'FTL_BangCong': MenuModel(title: 'Bảng chấm công', parent: 'TLU'),
  'FTL_BangLuong': MenuModel(title: 'Bảng thanh toán lương', parent: 'TLU'),

  'FTS_BangKHTSCD': MenuModel(title: 'Bảng khấu hao TSCĐ', parent: 'TTS'),
  'FTS_BangPBCCDC': MenuModel(title: 'Bảng phân bổ CCDC', parent: 'TTS'),

  'F00_CusInfo': MenuModel(title: ThongTinDoanhNghiepView.name, parent: 'THT'),
  'F00_DSUser': MenuModel(title: DanhSachNguoiDungView.name, parent: 'THT'),
  'F00_PhanQuyenUser': MenuModel(title: 'Phân quyền người dùng', parent: 'THT'),
  'F00_TuyChon': MenuModel(title: TuyChonView.name, parent: 'THT'),
};
const Map<String, MenuModel> mMenu2 = {
  'FDM_DkyKhachHang': MenuModel(title: 'Nợ đầu kỳ', parent: 'TDM1'),
  'FDM_DkyHangHoa': MenuModel(title: 'Tồn đầu kỳ', parent: 'TDM1'),
  'FDM_DKyTaiKhoan': MenuModel(title: 'Đầu kỳ tài khoản', parent: 'TDM1'),

    'FNX_BkeHoaDonMua': MenuModel(title: BangKeHoaDonMuaVaoView.name,parent: 'TNX1'),
    'FNX_BkeHoaDonBan': MenuModel(title: BangKeHoaDonBanRaView.name,parent: 'TNX1'),
    'FNX_BkeHangBan': MenuModel(title: BangKeHangBanView.name,parent: 'TNX1'),

    'FTC_BkePhieuThu': MenuModel(title: BangKePhieuThuView.name,parent: 'TTC1'),
    'FTC_BkePhieuChi': MenuModel(title: BangKePhieuChiView.name,parent: 'TTC1'),
    'FTC_SoQuyTM': MenuModel(title: SoTienMatView.name,parent: 'TTC1'),
    'FTC_SoTGNH': MenuModel(title: SoTienGuiView.name,parent: 'TTC1'),


    'FKT_SoNKChung': MenuModel(title: 'Sổ nhật ký chung',parent: 'TKT1'),
    'FKT_SoCaiTK': MenuModel(title: 'Sổ cái tài khoản',parent: 'TKT1'),
    'FKT_SoChiTietTK': MenuModel(title: 'Sổ chi tiết tài khoản',parent: 'TKT1'),

    'FKT_BangCDPS': MenuModel(title: 'Bảng cân đối phát sinh',parent: 'TKT2'),
    'FKT_BangCDKT': MenuModel(title: 'Bảng cân đối kế toán',parent: 'TKT2'),
    'FKT_BaoCaoKQKD': MenuModel(title: 'Báo cáo KQKD',parent: 'TKT2'),
    'FKT_BaoCaoLCTT': MenuModel(title: 'Báo cáo LCTT',parent: 'TKT2'),
    'FKT_BaoCaoTMTC': MenuModel(title: 'Thuyết minh BCTC',parent: 'TKT2'),

    'FKT_ThueTNDNtt': MenuModel(title: 'Thuế tạm tính',parent: 'TKT3'),
    'FKT_ChuyenLo': MenuModel(title: 'Chuyển lỗ',parent: 'TKT3'),
    'FKT_ThueTNDN': MenuModel(title: 'Thuế TNDN',parent: 'TKT3'),
    'FKT_ThueTNCN': MenuModel(title: 'Thuế TNCN',parent: 'TKT3'),
    'FKT_SoThue': MenuModel(title: 'Sổ thuế',parent: 'TKT3'),
};
// const Map<String, Map<String, MenuModel>> mMenu1 = {
//   'TDM': {
//     'FDM_BkeHangHoa': MenuModel(title: 'Hàng hóa'),
//     'FDM_BkeKhachHang': MenuModel(title: 'Khách hàng'),
//     'FDM_BkeNhanVien': MenuModel(title: NhanVienView.name),
//     'FDM_MaNghiepVu': MenuModel(title: 'Mã nghiệp vụ'),
//     'FDM_BangTaiKhoan': MenuModel(title: 'Bảng tài khoản'),
//     'TDM1': MenuModel(title: 'Đầu kỳ', hasChild: true),
//   },
//   'TNX': {
//     'FNX_PhieuNhap': MenuModel(title: 'Mua hàng'),
//     'FNX_PhieuXuat': MenuModel(title: 'Bán hàng'),
//     'TNX1': MenuModel(title: 'Báo cáo', hasChild: true),
//   },
//
//   'TTC': {
//     'FTC_PhieuThu': MenuModel(title: 'Phiếu thu'),
//     'FTC_PhieuChi': MenuModel(title: 'Phiếu chi'),
//     'TTC1': MenuModel(title: 'Báo cáo', hasChild: true),
//   },
//   'TCN': {
//     'FCN_SoMuaHang': MenuModel(title: SoMuaHangView.name),
//     'FCN_SoBanHang': MenuModel(title: SoBanHangView.name),
//     'FCN_TongHopCongNo': MenuModel(title: TongHopCongNoView.name),
//   },
//   'TKH': {
//     'FNX_BkeHangNhap': MenuModel(title: BangKeHangNhapView.name),
//     'FNX_BkeHangXuat': MenuModel(title: BangKeHangXuatView.name),
//     'FNX_NhapXuatTon': MenuModel(title: NhapXuatTonKhoView.name),
//   },
//   'TGT': {
//     'FGT_TinhGiaVon': MenuModel(title: 'Tính toán giá vốn'),
//     'GT1': MenuModel(title: 'Định mức sản xuất'),
//     'GT2': MenuModel(title: 'Bảng tính giá thành'),
//     'GT3': MenuModel(title: 'Thẻ tính giá thành'),
//     'GT4': MenuModel(title: 'Sổ chi phí SXKD'),
//   },
//   'TKT': {
//     'TKT1': MenuModel(title: 'Nhật ký', hasChild: true),
//     'TKT2': MenuModel(title: 'Báo cáo tài chính', hasChild: true),
//     'TKT3': MenuModel(title: 'Báo cáo thuế', hasChild: true),
//   },
//   'TLU': {
//     'FTL_BangCong': MenuModel(title: 'Bảng chấm công'),
//     'FTL_BangLuong': MenuModel(title: 'Bảng thanh toán lương'),
//   },
//
//   'TTS': {
//     'FTS_BangKHTSCD': MenuModel(title: 'Bảng khấu hao TSCĐ'),
//     'FTS_BangPBCCDC': MenuModel(title: 'Bảng phân bổ CCDC'),
//   },
//   'THT': {
//     'F00_CusInfo': MenuModel(title: ThongTinDoanhNghiepView.name),
//     'F00_DSUser': MenuModel(title: DanhSachNguoiDungView.name),
//     'F00_PhanQuyenUser': MenuModel(title: 'Phân quyền người dùng'),
//     'F00_TuyChon': MenuModel(title: TuyChonView.name),
//   },
// };

// const Map<String, Map<String, MenuModel>> mMenu2 = {
//   'TDM1': {
//     'FDM_DkyKhachHang': MenuModel(title: 'Nợ đầu kỳ'),
//     'FDM_DkyHangHoa': MenuModel(title: 'Tồn đầu kỳ'),
//     'FDM_DKyTaiKhoan': MenuModel(title: 'Đầu kỳ tài khoản'),
//   },
//   'TNX1': {
//     'FNX_BkeHoaDonMua': MenuModel(title: BangKeHoaDonMuaVaoView.name),
//     'FNX_BkeHoaDonBan': MenuModel(title: BangKeHoaDonBanRaView.name),
//     'FNX_BkeHangBan': MenuModel(title: BangKeHangBanView.name),
//   },
//   'TTC1': {
//     'FTC_BkePhieuThu': MenuModel(title: BangKePhieuThuView.name),
//     'FTC_BkePhieuChi': MenuModel(title: BangKePhieuChiView.name),
//     'FTC_SoQuyTM': MenuModel(title: SoTienMatView.name),
//     'FTC_SoTGNH': MenuModel(title: SoTienGuiView.name),
//   },
//   'TKT1': {
//     'FKT_SoNKChung': MenuModel(title: 'Sổ nhật ký chung'),
//     'FKT_SoCaiTK': MenuModel(title: 'Sổ cái tài khoản'),
//     'FKT_SoChiTietTK': MenuModel(title: 'Sổ chi tiết tài khoản'),
//   },
//   'TKT2': {
//     'FKT_BangCDPS': MenuModel(title: 'Bảng cân đối phát sinh'),
//     'FKT_BangCDKT': MenuModel(title: 'Bảng cân đối kế toán'),
//     'FKT_BaoCaoKQKD': MenuModel(title: 'Báo cáo KQKD'),
//     'FKT_BaoCaoLCTT': MenuModel(title: 'Báo cáo LCTT'),
//     'FKT_BaoCaoTMTC': MenuModel(title: 'Thuyết minh BCTC'),
//   },
//   'TKT3': {
//     'FKT_ThueTNDNtt': MenuModel(title: 'Thuế tạm tính'),
//     'FKT_ChuyenLo': MenuModel(title: 'Chuyển lỗ'),
//     'FKT_ThueTNDN': MenuModel(title: 'Thuế TNDN'),
//     'FKT_ThueTNCN': MenuModel(title: 'Thuế TNCN'),
//     'FKT_SoThue': MenuModel(title: 'Sổ thuế'),
//   },
// };
