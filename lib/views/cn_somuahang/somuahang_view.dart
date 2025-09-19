import 'package:pm_ketoan/views/cn_somuahang/somuahang_function.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trina_grid/trina_grid.dart';

import '../../widgets/widgets.dart';

class SoMuaHangView extends ConsumerStatefulWidget {
  static const name = "Sổ mua hàng";

  static void show(BuildContext context) =>
      showCustomDialog(context, title: name.toUpperCase(), width: 1000, height: 600, child: SoMuaHangView());

  const SoMuaHangView({super.key});

  @override
  ConsumerState createState() => _SoMuaHangViewState();
}

class _SoMuaHangViewState extends ConsumerState<SoMuaHangView> {
  late TrinaGridStateManager stateManager;
  final fc = SoMuaHangFunction();

  DateTime tuNgay = DateTime.now().copyWith(day: 1);
  DateTime denNgay = DateTime.now();
  String? selectNC;
  bool hideFilter = true;
  final txtTenKH = TextEditingController();
  List<Map<String, dynamic>> lstNC = [];
  final txtDKy = TextEditingController();
  final txtCKy = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    loadNC();
    super.initState();
  }

  void loadNC() async {
    lstNC = await fc.loadNC();
    setState(() {});
  }

  void loadNo() async{
    final data = await fc.getNo(maKhach: selectNC??'',tN: tuNgay, dN: denNgay);
    txtDKy.text = data.first;
    txtCKy.text = data.last;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      headers: [
        AppBar(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
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
                Gap(10),
                OutlineButton(
                  size: ButtonSize.small,
                  child: Text('Thực hiện'),
                  onPressed: () async {
                    fc.loadData(stateManager, tuNgay, denNgay, selectNC ?? '');
                    loadNo();
                  },
                ),
              ],
            ),
          ],
        ),
        AppBar(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
          leading: [
            Gap(175),
            Text('Mã NC').medium,
            Combobox(
              menuWidth: 370,
              columnWidth: [100, 270],
              noSearch: false,
              value: selectNC,
              items: lstNC.map((e) => ComboboxItem(value: e['MaKhach'], text: [e['MaKhach'], e['TenKH']])).toList(),
              onChanged: (val) {
                txtTenKH.text = lstNC.firstWhere((e) => e['MaKhach'] == val)['TenKH'];
                fc.loadData(stateManager, tuNgay, denNgay, val ?? '');

                setState(() {
                  selectNC = val;
                });
                loadNo();
              },
            ).sized(width: 100),
            Gap(5),
            WidgetTextField(controller: txtTenKH, readOnly: true).sized(width: 250),
          ],
          trailing: [Text('Nợ đầu kỳ').medium, WidgetTextField(controller: txtDKy,textAlign: TextAlign.end,readOnly: true).sized(width: 150), Gap(20)],
        ),
      ],
      footers: [
        AppBar(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          trailing: [Text('Nợ cuối kỳ').medium, WidgetTextField(controller: txtCKy,textAlign: TextAlign.end,readOnly: true).sized(width: 150), Gap(20)],
        ),
      ],
      child: DataGrid(
        hideFilter: hideFilter,
        onLoaded: (e) => stateManager = e.stateManager,
        onRowDoubleTap: (event)=>fc.showInfo(event, ref, context),
        columns: [
          DataGridColumn(title: ['', 'null'], width: 25, render: TypeRender.numIndex),
          DataGridColumn(title: ['Ngày', 'Ngay'], width: 90, columnType: ColumnType.date),
          DataGridColumn(title: ['Phiếu', 'Phieu'], width: 90, textStyle: ColumnTextStyle.red()),
          DataGridColumn(title: ['Tên hàng hóa', 'TenHH'], width: 250),
          DataGridColumn(title: ['ĐVT', 'DVT'], width: 80),
          DataGridColumn(title: ['Số lg', 'SoLg'], width: 80,columnType: ColumnType.num),
          DataGridColumn(title: ['Đơn giá', 'DonGia'], width: 120,columnType: ColumnType.num),
          DataGridColumn(title: ['Nợ', 'No'], width: 120,columnType: ColumnType.num,showFooter: true),
          DataGridColumn(title: ['Có', 'Co'], width: 120,columnType: ColumnType.num,showFooter: true),
        ],
      ).withPadding(all: 5),
    );
  }
}
