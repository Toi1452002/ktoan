import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/widgets/data_grid/data_grid.dart';
import 'package:pm_ketoan/widgets/dialog_windows/dialog_funtion.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class BangTaiKhoanView extends ConsumerStatefulWidget {
  const BangTaiKhoanView({super.key});

  static const name = "Bảng tài khoản";

  static void show(BuildContext context) => showCustomDialog(
    context,
    title: name.toUpperCase(),
    width: 970,
    height: 700,
    child: BangTaiKhoanView(),
    onClose: () {},
  );

  @override
  ConsumerState createState() => _BangTaiKhoanViewState();
}

class _BangTaiKhoanViewState extends ConsumerState<BangTaiKhoanView> {
  @override
  Widget build(BuildContext context) {
    return DataGrid(columns: [
      DataGridColumn(title: ['', 'null'], width: 25, render:TypeRender.numIndex),
      DataGridColumn(title: ['', 'dl'], width: 25, render:TypeRender.delete),
      DataGridColumn(title: ['Mã TK', 'MaTK'], width: 100),
      DataGridColumn(title: ['Mô tả', 'TenTK'], width: 350),
      DataGridColumn(title: ['TC', 'TinhChat'], width: 70),
      DataGridColumn(title: ['Ghi chú', 'GhiChu'], width: 250),
      DataGridColumn(title: ['Nhóm', 'MAXL'], width: 100),
    ]);
  }
}
