import 'dart:math';

import 'package:pm_ketoan/core/core.dart';
import 'package:pm_ketoan/data/data.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trina_grid/trina_grid.dart';

import '../../widgets/widgets.dart';

class SoCaiTKView extends ConsumerStatefulWidget {
  const SoCaiTKView({super.key});

  static const name = "Sổ cái tài khoản";

  static void show(BuildContext context) =>
      showCustomDialog(context, title: name.toUpperCase(), width: 1000, height: 600, child: SoCaiTKView());

  @override
  ConsumerState createState() => _SoCaiTKViewState();
}

class _SoCaiTKViewState extends ConsumerState<SoCaiTKView> {
  late TrinaGridStateManager stateManager;
  DateTime tuNgay = DateTime.now().copyWith(day: 1);
  DateTime denNgay = DateTime.now();
  bool hideFilter = true;
  String? selectBTK;
  List<Map<String, dynamic>> lstBTK = [];
  List<Map<String, dynamic>> lstData = [];
  final txtTenTK = TextEditingController();
  final txtDKNo = TextEditingController();
  final txtDKCo = TextEditingController();
  final txtCKNo = TextEditingController();
  final txtCKCo = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    loadCBoTK();
    super.initState();
  }

  void loadCBoTK() async {
    lstBTK = await BangTaiKhoanRepository().getTKSoCai();
    setState(() {});
  }

  void tinhDk(String maTk) async {
    txtDKNo.clear();
    txtDKCo.clear();
    txtCKNo.clear();
    txtCKCo.clear();
    if(maTk.isEmpty) return;
    final soNo = await NhatKyRepository().getSoDuDKyNo(Helper.yMd(tuNgay), maTk);
    final soCo = await NhatKyRepository().getSoDuDKyCo(Helper.yMd(tuNgay), maTk);
    final soDau = await DauKyRepository().getTonDauTK(Helper.yM(tuNgay), 7, maTk);

    final tNo = lstData.fold(0.0, (a, b) => a + b['PSNo']);
    final tCo = lstData.fold(0.0, (a, b) => a + b['PSCo']);
    final dkNo = max(soNo - soCo + soDau, 0);
    final dkCo = max(soCo - soNo + soDau, 0);
    if (maTk[0] == '1' || maTk[0] == '2') {
      txtDKNo.text = Helper.numFormat(dkNo) ?? '0';
      txtCKNo.text = Helper.numFormat(max(dkNo + tNo - dkCo - tCo, 0)) ?? '0';
    }
    if (maTk[0] == '3' || maTk[0] == '4') {
      txtDKCo.text = Helper.numFormat(dkCo) ?? '0';
      txtCKCo.text = Helper.numFormat(max(dkCo + tCo - dkNo - tNo, 0)) ?? "0";
    }
    if (['159', '131', '214', '331'].contains(maTk) || ['421', '333'].contains(maTk.substring(0, 3))) {
      if (soNo >= soCo) {
        txtDKNo.text = Helper.numFormat(soNo - soCo + soDau) ?? '0';
        txtCKCo.text = '0';
        txtCKNo.text = Helper.numFormat((soNo - soCo + soDau) + tNo - dkCo - tCo) ?? '0';
      } else {
        txtDKCo.text = Helper.numFormat(soCo - soNo + soDau) ?? "0";
        txtCKNo.text = '0';
        txtCKCo.text = Helper.numFormat((soCo - soNo + soDau) + tCo - dkNo - tNo) ?? '0';
      }
    }
  }

  void loadData(String maTk) async {
    stateManager.removeAllRows();
    lstData = await NhatKyRepository().getSoCaiTK(Helper.yMd(tuNgay), Helper.yMd(denNgay), maTk);
    if (lstData.isNotEmpty) {
      stateManager.appendRows(
        lstData
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
                },
              ),
            )
            .toList(),
      );
    }

    tinhDk(maTk);
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
          trailing: [Text('Số dư đầu kỳ').medium, Gap(220)],
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
            WidgetTextField(controller: txtDKNo, textAlign: TextAlign.end, readOnly: true).sized(width: 130),
            WidgetTextField(controller: txtDKCo, textAlign: TextAlign.end, readOnly: true).sized(width: 130),
            Gap(30),
          ],
        ),
      ],
      footers: [
        AppBar(
          padding: EdgeInsets.only(right: 5, bottom: 10, top: 5),
          trailing: [
            Text('Số dư cuối kỳ').medium,
            WidgetTextField(controller: txtCKNo, textAlign: TextAlign.end, readOnly: true).sized(width: 130),
            WidgetTextField(controller: txtCKCo, textAlign: TextAlign.end, readOnly: true).sized(width: 130),
            Gap(28),
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
          DataGridColumn(title: ['Nợ', 'PSNo'], width: 130, columnType: ColumnType.num, showFooter: true),
          DataGridColumn(title: ['Có', 'PSCo'], width: 130, columnType: ColumnType.num, showFooter: true),
        ],
      ).withPadding(all: 5),
    );
  }
}
