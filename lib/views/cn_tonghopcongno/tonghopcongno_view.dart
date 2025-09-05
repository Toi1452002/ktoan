import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/views/cn_tonghopcongno/tonghopcongno_function.dart';
import 'package:pm_ketoan/widgets/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:trina_grid/trina_grid.dart';

class TongHopCongNoView extends ConsumerStatefulWidget {
  static const name = "Tổng hợp công nợ";

  static void show(BuildContext context) =>
      showCustomDialog(context, title: name.toUpperCase(), width: 650, height: 700, child: TongHopCongNoView());

  const TongHopCongNoView({super.key});

  @override
  ConsumerState createState() => _TongHopCongNoViewState();
}

class _TongHopCongNoViewState extends ConsumerState<TongHopCongNoView> {
  late TrinaGridStateManager stateManager;
  final fc = TongHopCongNoFunction();
  DateTime ngay = DateTime.now();
  @override
  void initState() {
    // TODO: implement initState
    load(DateTime.now());
    super.initState();
  }

  void load(DateTime date) async{
    await Future.delayed(Duration(milliseconds: 100));
    await fc.loadData(date, stateManager);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      headers: [
        AppBar(
          padding: EdgeInsets.symmetric(horizontal: 5,vertical: 3),
          leading: [
            WidgetIconButton(type: IconType.print),
            WidgetIconButton(type: IconType.excel),
          ],
          trailing: [
            WidgetDateBox(initialDate: ngay,onChanged: (val){
              setState(() {
                ngay = val!;
              });
            },).sized(width: 120),
            TextButton(onPressed: (){
              load(ngay);
            },child: Text('Thực hiện'),)
          ],
        )
      ],
      child: DataGrid(
        onLoaded: (e) => stateManager = e.stateManager,
        columnGroups: [
          // TrinaColumnGroup(title: 'Khách hàng', backgroundColor: Colors.blue.shade300, fields: ['MaKhach', 'TenKH']),
          TrinaColumnGroup(
            title: 'Số dư cuối kỳ',
            backgroundColor: Colors.blue.shade300,
            fields: ['PhaiThu', 'PhaiTra'],
          ),
        ],
        columns: [
          DataGridColumn(title: ['', 'null'], width: 25, render: TypeRender.numIndex),
          DataGridColumn(title: ['Mã KH', 'MaKhach'], width: 100,textStyle: ColumnTextStyle.blue()),
          DataGridColumn(title: ['Tên khách hàng', 'TenKH'], width: 250,textStyle: ColumnTextStyle.blue()),
          DataGridColumn(title: ['Phải thu', 'PhaiThu'], width: 120, columnType: ColumnType.num,showFooter: true),
          DataGridColumn(title: ['Phải trả', 'PhaiTra'], width: 120, columnType: ColumnType.num,showFooter: true),
        ],
      ).withPadding(all: 5),
    );
  }
}
