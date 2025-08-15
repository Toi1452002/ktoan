import 'package:pm_ketoan/core/app_contraint/menu_app.dart';
import 'package:pm_ketoan/views/home/components/info_cty.dart';
import 'package:pm_ketoan/views/views.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menu = ref.watch(menuProvider);
    return Scaffold(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OutlinedContainer(
            width: 300,
            height: double.infinity,
            child: TreeView(
              nodes: menu,
              onSelectionChanged: TreeView.defaultSelectionHandler(menu, (value) {
                ref.read(menuProvider.notifier).state = value;
              }),
              builder: (context, node) {
                return TreeItemView(
                  onExpand: TreeView.defaultItemExpandHandler(menu, node, (value) {
                    ref.read(menuProvider.notifier).state = value;
                    // treeItems = value;
                  }),
                  onPressed: (){
                    if(node.data == HangHoaView.name) HangHoaView.show(context);
                    if(node.data == KhachHangView.name) KhachHangView.show(context);
                    if(node.data == MaNghiepVuView.name) MaNghiepVuView.show(context);
                    if(node.data == BangTaiKhoanView.name) BangTaiKhoanView.show(context);
                    if(node.data == DauKyKhachHangView.name) DauKyKhachHangView.show(context);
                    if(node.data == DauKyHangHoaView.name) DauKyHangHoaView.show(context);
                    if(node.data == DauKyBTKView.name) DauKyBTKView.show(context);

                    if(node.data == PhieuNhapView.name) PhieuNhapView.show(context);
                    if(node.data == PhieuXuatView.name) PhieuXuatView.show(context);
                    if(node.data == BangKeHoaDonMuaVaoView.name) BangKeHoaDonMuaVaoView.show(context);
                    if(node.data == BangKeHoaDonBanRaView.name) BangKeHoaDonBanRaView.show(context);
                    if(node.data == BangKeHangBanView.name) BangKeHangBanView.show(context);

                    if(node.data == PhieuThuView.name) PhieuThuView.show(context);
                    if(node.data == PhieuChiView.name) PhieuChiView.show(context);
                  },
                  child: Text(node.data),
                );
              },
            ),
          ),
          Expanded(child: InfoCty()),
        ],
      ),
    );
  }
}
