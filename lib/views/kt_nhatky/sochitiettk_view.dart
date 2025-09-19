import 'dart:math';

import 'package:pm_ketoan/widgets/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trina_grid/trina_grid.dart';

import '../../core/core.dart';
import '../../data/data.dart';

class SoChiTietTKView extends ConsumerStatefulWidget {
  const SoChiTietTKView({super.key});

  static const name = "Sổ chi tiết tài khoản";

  static void show(BuildContext context) =>
      showCustomDialog(context, title: name.toUpperCase(), width: 1200, height: 600, child: SoChiTietTKView());

  @override
  ConsumerState createState() => _SoChiTietTKViewState();
}

class _SoChiTietTKViewState extends ConsumerState<SoChiTietTKView> {
  late TrinaGridStateManager stateManager;
  DateTime tuNgay = DateTime.now().copyWith(day: 1);
  DateTime denNgay = DateTime.now();
  bool hideFilter = true;
  String? selectBTK;
  List<Map<String, dynamic>> lstBTK = [];
  List<Map<String, dynamic>> lstData = [];
  final txtTenTK = TextEditingController();
  final txtDKNo = TextEditingController(text: '0');
  final txtDKCo = TextEditingController(text: '0');
  final txtCKNo = TextEditingController(text: '0');
  final txtCKCo = TextEditingController(text: '0');

  @override
  void initState() {
    // TODO: implement initState
    loadCBoTK();
    super.initState();
  }

  void loadCBoTK() async {
    lstBTK = await BangTaiKhoanRepository().getTKSoCTTK();
    setState(() {});
  }

  void tinhDK(String maTk) async {
    txtDKNo.text = '0';
    txtDKCo.text = '0';
    txtCKNo.text = '0';
    txtCKCo.text = '0';
    final soNo = await NhatKyRepository().getSoDuDKyNo(Helper.yMd(tuNgay), maTk);
    final soCo = await NhatKyRepository().getSoDuDKyCo(Helper.yMd(tuNgay), maTk);
    final tC = await BangTaiKhoanRepository().getTC(maTk);
    final soDau = await DauKyRepository().getTonDauTK(Helper.yM(tuNgay), 7, maTk);

    final dkNo = max(soNo - soCo + soDau, 0);
    final dkCo = max(soCo - soNo + soDau, 0);

    final sN = await NhatKyRepository().getSoDuDKyNo(Helper.yMd(denNgay), maTk);
    final sC = await NhatKyRepository().getSoDuDKyCo(Helper.yMd(denNgay), maTk);
    if (tC == 'N') {
      txtDKNo.text = Helper.numFormat(dkNo) ?? '0';

      txtCKNo.text = Helper.numFormat(sN - sC + soDau) ?? '0';
    } else if (tC == 'C') {
      txtDKCo.text = Helper.numFormat(dkCo) ?? '0';
      txtCKCo.text = Helper.numFormat(sC - sN + soDau) ?? '0';
    } else {
      if (soNo >= soCo) {
        txtDKNo.text = Helper.numFormat(dkNo) ?? '0';
        txtCKNo.text = Helper.numFormat(sN - sC + soDau) ?? '0';
      } else {
        txtDKCo.text = Helper.numFormat(dkCo) ?? '0';
        txtCKCo.text = Helper.numFormat(sC - sN + soDau) ?? '0';
      }
    }
  }

  void loadData(String maTK) async {
    stateManager.removeAllRows();
    final data = await NhatKyRepository().getSoCTTK(maTK, Helper.yMd(tuNgay), Helper.yMd(denNgay));
    if (data.isNotEmpty) {
      stateManager.appendRows(
        data
            .map(
              (e) => TrinaRow(
                cells: {
                  'null': TrinaCell(value: ''),
                  'Ngay': TrinaCell(value: e['Ngay']),
                  'ChungTu': TrinaCell(value: e['ChungTu']),
                  'NgayCT': TrinaCell(value: e['NgayCT']),
                  'DienGiai': TrinaCell(value: e['DienGiai'] ?? ''),
                  'TKDU': TrinaCell(value: e['TKDU']),
                  'PSNo': TrinaCell(value: e['PSNo']),
                  'PSCo': TrinaCell(value: e['PSCo']),
                  'SDNo': TrinaCell(value: ''),
                  'SDCo': TrinaCell(value: ''),
                },
              ),
            )
            .toList(),
      );
    }
    tinhDK(maTK);
    setState(() {});
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
                Gap(5),
                OutlineButton(
                  onPressed: () {
                    loadData(selectBTK ?? '');
                  },
                  size: ButtonSize.small,
                  child: Text('Thực hiện'),
                ),
              ],
            ),
          ],
        ),
        AppBar(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
          leading: [
            Gap(175),
            Text('Tài khoản').medium,
            Combobox(
              menuWidth: 370,
              noSearch: false,
              columnWidth: [100, 270],
              value: selectBTK,
              items: lstBTK.map((e) => ComboboxItem(value: e['MaTK'], text: [e['MaTK'], e['TenTK']])).toList(),
              onChanged: (val) {
                txtTenTK.text = lstBTK.firstWhere((e) => e['MaTK'] == val)['TenTK'];
                loadData(val);
                setState(() {
                  selectBTK = val;
                });
                // loadData();
              },
            ).sized(width: 100),

            // Gap(2),
            WidgetTextField(controller: txtTenTK, readOnly: true).sized(width: 250),
          ],
          trailing: [
            Text('Số dư đầu kỳ').medium,
            WidgetTextField(controller: txtDKNo, textAlign: TextAlign.end, readOnly: true).sized(width: 120),
            WidgetTextField(controller: txtDKCo, textAlign: TextAlign.end, readOnly: true).sized(width: 120),
            Gap(10),
          ],
        ),
      ],
      footers: [
        AppBar(
          padding: EdgeInsets.only(right: 5, bottom: 10, top: 5),
          trailing: [
            Text('Số dư cuối kỳ').medium,
            WidgetTextField(controller: txtCKNo, textAlign: TextAlign.end, readOnly: true).sized(width: 120),
            WidgetTextField(controller: txtCKCo, textAlign: TextAlign.end, readOnly: true).sized(width: 120),
            Gap(10),
          ],
        ),
      ],
      child: DataGrid(
        hideFilter: hideFilter,
        onLoaded: (e) => stateManager = e.stateManager,
        columns: [
          DataGridColumn(title: ['', 'null'], width: 25, render: TypeRender.numIndex),
          DataGridColumn(
            title: ['Ngày ghi sổ', 'Ngay'],
            width: 110,
            columnType: ColumnType.date,
            columnAlign: ColumnAlign.center,
          ),
          DataGridColumn(
            title: ['Số CT', 'ChungTu'],
            width: 80,
            columnAlign: ColumnAlign.center,
            textStyle: ColumnTextStyle.blue(),
          ),
          DataGridColumn(
            title: ['Ngày CT', 'NgayCT'],
            width: 100,
            columnType: ColumnType.date,
            columnAlign: ColumnAlign.center,
          ),
          DataGridColumn(title: ['Diễn giải', 'DienGiai'], width: 300),
          DataGridColumn(title: ['TKDU', 'TKDU'], width: 80, columnAlign: ColumnAlign.center),
          DataGridColumn(title: ['PS Nợ', 'PSNo'], width: 120, columnType: ColumnType.num, showFooter: true),
          DataGridColumn(title: ['PS Có', 'PSCo'], width: 120, columnType: ColumnType.num, showFooter: true),
          DataGridColumn(title: ['Số dư nợ', 'SDNo'], width: 120, columnType: ColumnType.num, showFooter: true),
          DataGridColumn(title: ['Số dư có', 'SDCo'], width: 120, columnType: ColumnType.num, showFooter: true),
        ],
      ).withPadding(all: 5),
    );
  }
}
