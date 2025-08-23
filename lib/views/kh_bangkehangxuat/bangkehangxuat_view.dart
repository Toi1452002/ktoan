import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/views/kh_bangkehangxuat/bangkehangxuat_function.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:trina_grid/trina_grid.dart';

import '../../widgets/widgets.dart';

class BangKeHangXuatView extends ConsumerStatefulWidget {
  static const name = 'Bảng kê hàng xuất';

  static void show(BuildContext context) =>
      showCustomDialog(context, title: name.toUpperCase(), width: 1050, height: 600, child: BangKeHangXuatView());

  const BangKeHangXuatView({super.key});

  @override
  ConsumerState createState() => _BangKeHangXuatViewState();
}

class _BangKeHangXuatViewState extends ConsumerState<BangKeHangXuatView> {
  late TrinaGridStateManager stateManager;
  final fc = BangKeHangXuatFunction();
  DateTime tuNgay = DateTime.now().copyWith(day: 1);
  DateTime denNgay = DateTime.now();
  bool hideFilter = true;

  @override
  void initState() {
    // TODO: implement initState
    loadData();
    super.initState();
  }

  void loadData() async {
    await Future.delayed(Duration(milliseconds: 100));
    await fc.get(stateManager, tN: tuNgay, dN: denNgay);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      headers: [
        AppBar(
          padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
          leading: [
            WidgetIconButton(type: IconType.print, onPressed: () {}),
            WidgetIconButton(type: IconType.excel, onPressed: () {}),
            WidgetIconButton(
              type: IconType.filter,
              onPressed: () {
                setState(() {
                  hideFilter = !hideFilter;
                });
              },
            ),
            Gap(50),
            Row(
              children: [
                Row(
                  spacing: 5,
                  children: [
                    Text('Từ ngày').medium,
                    WidgetDateBox(
                      onChanged: (val) {
                        tuNgay = val!;
                        setState(() {});
                      },
                      initialDate: tuNgay,
                      showClear: false,
                    ).expanded(),
                  ],
                ).sized(width: 150),
                Gap(10),
                Row(
                  spacing: 5,
                  children: [
                    Text('Đến ngày').medium,
                    WidgetDateBox(
                      onChanged: (val) {
                        denNgay = val!;
                        setState(() {});
                      },
                      initialDate: denNgay,
                      showClear: false,
                    ).expanded(),
                  ],
                ).sized(width: 160),
                TextButton(onPressed: loadData, child: Text('Thực hiện')),
              ],
            ),
          ],
        ),
      ],
      child: DataGrid(
        hideFilter: hideFilter,
        onLoaded: (e) => stateManager = e.stateManager,
        onRowDoubleTap: (event) => fc.showInfo(event, ref, context),
        columns: [
          DataGridColumn(title: ['', 'null'], width: 25, render: TypeRender.numIndex),
          DataGridColumn(title: ['Ngày', 'Ngay'], width: 80, columnType: ColumnType.date),
          DataGridColumn(title: ['Phiếu', 'Phieu'], width: 80, textColor: TextColor.red),
          DataGridColumn(title: ['Kiểu', 'MaNX'], width: 70),
          DataGridColumn(title: ['Mã khách', 'MaKhach'], width: 100),
          DataGridColumn(title: ['Mã hàng', 'MaHH'], width: 120),
          DataGridColumn(title: ['Tên hàng', 'TenHH']),
          DataGridColumn(title: ['ĐVT', 'DVT'], width: 70),
          DataGridColumn(title: ['SoLg', 'SoLg'], width: 70, columnType: ColumnType.num),
          DataGridColumn(title: ['Đơn giá', 'DonGia'], width: 100, columnType: ColumnType.num),
          DataGridColumn(title: ['Thành tiền', 'ThanhTien'], width: 110, columnType: ColumnType.num, showFooter: true),
        ],
      ).withPadding(all: 5),
    );
  }
}
