import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pm_ketoan/core/core.dart';
import 'package:pm_ketoan/views/kt_bctc_bangcdps/bangcdps_function.dart';
import 'package:pm_ketoan/widgets/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:trina_grid/trina_grid.dart';

class BangCDPSView extends ConsumerStatefulWidget {
  const BangCDPSView({super.key});

  static const name = "Bảng cân đối phát sinh";

  static void show(BuildContext context) =>
      showCustomDialog(context, title: name.toUpperCase(), width: 1240, height: 600, child: BangCDPSView());

  @override
  ConsumerState createState() => _BangCDPSViewState();
}

class _BangCDPSViewState extends ConsumerState<BangCDPSView> {
  int selectedType = 2;
  int selectedThang = DateTime.now().month;
  int selectedQuy = Helper.getQuarterNow();
  int selectSoLieu = 4;
  final txtNam = TextEditingController(text: (DateTime.now().year - 1).toString());
  final fc = BangCDPSFunction();
  late TrinaGridStateManager stateManager;

  @override
  void initState() {
    // TODO: implement initState
    fc.onThucHien(2, txtNam.text, thang: selectedThang, quy: selectedQuy);
    onLoadData(4);
    super.initState();
  }

  void onLoadData(int type) async {
    final data = await fc.xemSoLieu(type: type);
    stateManager.removeAllRows();
    if (data.isNotEmpty) {
      stateManager.appendRows(
        data
            .map(
              (e) => TrinaRow(
                cells: {
                  'MaTK': TrinaCell(value: e['MaTK']),
                  'TenTK': TrinaCell(value: e['TenTK']),
                  'DKNo': TrinaCell(value: e['DKNo']),
                  'DKCo': TrinaCell(value: e['DKCo']),
                  'PSNo': TrinaCell(value: e['PSNo']),
                  'PSCo': TrinaCell(value: e['PSCo']),
                  'CKNo': TrinaCell(value: e['CKNo']),
                  'CKCo': TrinaCell(value: e['CKCo']),
                  'Cap': TrinaCell(value: e['Cap']),
                },
              ),
            )
            .toList(),
      );
    }
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
            Gap(10),
            OutlineButton(onPressed: () {}, size: ButtonSize.small, child: Text('Kết chuyển')),
            Gap(50),
            Combobox(
              value: selectedType,
              items: [
                ComboboxItem(value: 0, text: ['Tháng']),
                ComboboxItem(value: 1, text: ['Quý']),
                ComboboxItem(value: 2, text: ['Năm']),
              ],
              onChanged: (val) {
                setState(() {
                  selectedType = val;
                });
              },
            ).sized(width: 70),
            Gap(15),
            Builder(
              builder: (context) {
                String title = 'Tháng';
                List<int> items = [for (int i = 1; i <= 12; i++) i];

                if (selectedType == 1) {
                  title = 'Quý';
                  items = [for (int i = 1; i <= 4; i++) i];
                }
                if (selectedType == 2) {
                  return SizedBox();
                }
                return Row(
                  children: [
                    Text(title),
                    Gap(5),
                    Combobox(
                      value: selectedType == 1 ? selectedQuy : selectedThang,
                      items: items.map((e) => ComboboxItem(value: e, text: [e.toString()])).toList(),
                      onChanged: (val) {
                        setState(() {
                          if (selectedType == 1) {
                            selectedQuy = val;
                          } else {
                            selectedThang = val;
                          }
                        });
                      },
                    ).sized(width: 50),
                    Gap(15),
                  ],
                );
              },
            ),
            Text('Năm'),
            WidgetTextField(controller: txtNam,isNumber: true, textAlign: TextAlign.center).sized(width: 60),
            OutlineButton(
              onPressed: () async {
                await fc.onThucHien(selectedType, txtNam.text, thang: selectedThang, quy: selectedQuy).whenComplete(() {
                  onLoadData(4);
                });
                setState(() {
                  selectSoLieu = 4;
                });
              },
              size: ButtonSize.small,
              child: Text('Thực hiện'),
            ),
          ],
          trailing: [
            Combobox(
              value: selectSoLieu,
              items: [
                ComboboxItem(value: 0, text: ['Xem tất cả']),
                ComboboxItem(value: 1, text: ['Tài khoản cha']),
                ComboboxItem(value: 2, text: ['Tài khoản con']),
                ComboboxItem(value: 3, text: ['Tài khoản có số phát sinh']),
                ComboboxItem(value: 4, text: ['Tài khoản con có số phát sinh']),
              ],
              onChanged: (val) {
                onLoadData(val);
                setState(() {
                  selectSoLieu = val;
                });
              },
            ).sized(width: 250),
            OutlineButton(
              onPressed: () => fc.onLuu(selectedType, txtNam.text, thang: selectedThang, quy: selectedQuy),
              size: ButtonSize.small,
              child: Text('Lưu số dư'),
            ),
          ],
        ),
      ],
      child: DataGrid(
        cellReadonlyColor: Colors.yellow.shade200.withValues(alpha: .3),
        onLoaded: (e) => stateManager = e.stateManager,
        rowColorCallback: (re) {
          if (re.row.cells['Cap']?.value == 1) {
            return Colors.cyan.shade100;
          }
          return Colors.transparent;
        },
        onRowDoubleTap: (re) => fc.showSoCTTK(re, context, txtNam.text),
        columns: [
          DataGridColumn(
            title: ['Mã TK', 'MaTK'],
            readOnly: true,
            width: 70,
            textStyle: ColumnTextStyle.red(),
            columnAlign: ColumnAlign.center,
          ),
          DataGridColumn(title: ['Mô tả tài khoản', 'TenTK'], width: 300),
          DataGridColumn(
            title: ['Đầu kỳ nợ', 'DKNo'],
            width: 140,
            showFooter: true,
            columnType: ColumnType.num,
            textStyle: ColumnTextStyle.red(),
          ),
          DataGridColumn(
            title: ['Đầu kỳ có', 'DKCo'],
            width: 140,
            showFooter: true,
            columnType: ColumnType.num,
            textStyle: ColumnTextStyle.blue(),
          ),
          DataGridColumn(
            title: ['Phát sinh nợ', 'PSNo'],
            headerColor: Colors.yellow.shade200,

            width: 140,
            showFooter: true,
            columnType: ColumnType.num,
            // padding: 0,
            readOnly: true,
            textStyle: ColumnTextStyle.red(),
            // renderer: (re) => _buildText(re.cell.value, Colors.yellow.shade200, textColor: Colors.red.shade700),
          ),
          DataGridColumn(
            title: ['Phát sinh có', 'PSCo'],
            headerColor: Colors.yellow.shade200,
            // padding: 0,
            readOnly: true,
            // renderer: (re) => _buildText(re.cell.value, Colors.yellow.shade200, textColor: Colors.blue.shade800),
            textStyle: ColumnTextStyle.blue(),
            width: 140,
            showFooter: true,
            columnType: ColumnType.num,
          ),
          DataGridColumn(
            title: ['Cuối kỳ nợ', 'CKNo'],
            width: 140,
            showFooter: true,
            columnType: ColumnType.num,
            textStyle: ColumnTextStyle.red(),
          ),
          DataGridColumn(
            title: ['Cuối kỳ có', 'CKCo'],
            width: 140,
            showFooter: true,
            columnType: ColumnType.num,
            textStyle: ColumnTextStyle.blue(),
          ),
          DataGridColumn(title: ['', 'Cap'], hide: true),
        ],
      ).withPadding(all: 5),
    );
  }

  _buildText(dynamic text, Color color, {Color? textColor}) {
    return Container(
      color: color.withValues(alpha: .3),
      alignment: Alignment.centerRight,
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Text(Helper.numFormat(text)!, style: TextStyle(fontSize: 13, color: textColor)).medium,
    );
  }
}
