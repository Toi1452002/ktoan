import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:trina_grid/trina_grid.dart';

import '../../widgets/widgets.dart';
import 'bangkephieuthu_function.dart';

class BangKePhieuThuView extends ConsumerStatefulWidget {
  static const name = "Bảng kê phiếu thu";

  static void show(BuildContext context) =>
      showCustomDialog(context, title: name.toUpperCase(), width: 1300, height: 600, child: BangKePhieuThuView());

  const BangKePhieuThuView({super.key});

  @override
  ConsumerState createState() => _BangKePhieuThuViewState();
}

class _BangKePhieuThuViewState extends ConsumerState<BangKePhieuThuView> {
  late TrinaGridStateManager stateManager;
  final fc = BangKePhieuThuFunction();
  bool hideFilter = true;
  DateTime tuNgay = DateTime.now().copyWith(day: 1);
  DateTime denNgay = DateTime.now();
  @override
  void initState() {
    // TODO: implement initState
    onLoadData();
    super.initState();
  }

  void onLoadData({DateTime? tN, DateTime? dN}) async {
    final data = await fc.get(tN: tN,dN: dN);
    stateManager.removeAllRows();
    stateManager.appendRows(data.map((e){
      return TrinaRow(cells: {
        'null':  TrinaCell(value: e['Phieu']),
        'Ngay':  TrinaCell(value: e['Ngay']),
        'Phieu':  TrinaCell(value: e['Phieu']??''),
        'MaTC':  TrinaCell(value: e['MaTC']??''),
        'MaKhach':  TrinaCell(value: e['MaKhach']??''),
        'TenKhach':  TrinaCell(value: e['TenKhach']??''),
        'PTTT':  TrinaCell(value: e['PTTT']??''),
        'Noidung':  TrinaCell(value: e['Noidung']??''),
        'SoTien':  TrinaCell(value: e['SoTien']),
        'TKNo':  TrinaCell(value: e['TKNo']),
        'TKCo':  TrinaCell(value: e['TKCo']),
      });
    }).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      headers: [
        AppBar(
          padding: EdgeInsets.symmetric(vertical: 3,horizontal: 5),
          leading: [
            WidgetIconButton(type: IconType.print),
            WidgetIconButton(type: IconType.excel),
            WidgetIconButton(type: IconType.filter,onPressed: (){
              setState(() {
                hideFilter = !hideFilter;
              });
            },),
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
                    ).expanded()
                  ],
                ).sized(width: 150),
                Gap(10),
                Row(spacing: 5,children: [
                  Text('Đến ngày').medium,
                  WidgetDateBox(
                    onChanged: (val) {
                      denNgay = val!;
                      setState(() {});
                    },
                    initialDate: denNgay,
                    showClear: false,
                  ).expanded()
                ],).sized(width: 160),
                TextButton(child: Text('Thực hiện'),onPressed: (){
                  onLoadData(tN: tuNgay,dN: denNgay);
                },)
              ],
            )
          ],

        )
      ],
      child: DataGrid(
        onLoaded: (e) => stateManager = e.stateManager,
        hideFilter: hideFilter,
        onRowDoubleTap: (event)=>fc.onShowInfo(event, context, ref),
        columns: [
          DataGridColumn(title: ['', 'null'], width: 25, render: TypeRender.numIndex),
          DataGridColumn(title: ['Ngày', 'Ngay'], width: 80,columnType: ColumnType.date),
          DataGridColumn(title: ['Phiếu', 'Phieu'], width: 70,textStyle: ColumnTextStyle.red()),
          DataGridColumn(title: ['Kiểu thu', 'MaTC'], width: 90),
          DataGridColumn(title: ['Mã KH', 'MaKhach'], width: 80),
          DataGridColumn(title: ['Tên khách', 'TenKhach'], width: 300),
          DataGridColumn(title: ['PTTT', 'PTTT'], width: 75),
          DataGridColumn(title: ['Lý do thu', 'Noidung'], width: 280),
          DataGridColumn(title: ['Số tiền', 'SoTien'], width: 100,columnType: ColumnType.num,showFooter: true),
          DataGridColumn(title: ['TK nợ', 'TKNo'], width: 75),
          DataGridColumn(title: ['TK có', 'TKCo'], width: 75),
        ],
      ).withPadding(all: 5),
    );
  }
}
