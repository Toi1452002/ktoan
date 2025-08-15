import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/widgets/data_grid/data_grid.dart';
import 'package:pm_ketoan/widgets/dialog_windows/dialog_funtion.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class BangKePhieuThuView extends ConsumerStatefulWidget {
  static const name = "Bảng kê phiếu thu";

  static void show(BuildContext context) =>
      showCustomDialog(context, title: name.toUpperCase(), width: 1300, height: 600, child: BangKePhieuThuView());

  const BangKePhieuThuView({super.key});

  @override
  ConsumerState createState() => _BangKePhieuThuViewState();
}

class _BangKePhieuThuViewState extends ConsumerState<BangKePhieuThuView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(child: DataGrid(columns: [
      DataGridColumn(title: ['', 'null'], width: 25, render: TypeRender.numIndex),
      DataGridColumn(title: ['Ngày', 'Ngay'], width: 25),
      DataGridColumn(title: ['Phiếu', 'Phieu'], width: 25),
      DataGridColumn(title: ['Kiểu thu', 'MaTC'], width: 25),
      DataGridColumn(title: ['Mã KH', 'MaKhach'], width: 25),
      DataGridColumn(title: ['Tên khách', 'TenKhach'], width: 25),
      DataGridColumn(title: ['PTTT', 'PTTT'], width: 25),
      DataGridColumn(title: ['Lý do thu', 'Noidung'], width: 25),
      DataGridColumn(title: ['Số tiền', 'SoTien'], width: 25),
      DataGridColumn(title: ['TK nợ', 'TKNo'], width: 25),
      DataGridColumn(title: ['TK có', 'TKCo'], width: 25),

    ]));
  }
}
