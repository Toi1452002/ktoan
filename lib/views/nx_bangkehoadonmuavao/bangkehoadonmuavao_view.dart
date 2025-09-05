import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/core/core.dart';
import 'package:pm_ketoan/widgets/combobox.dart';
import 'package:pm_ketoan/widgets/data_grid/data_grid.dart';
import 'package:pm_ketoan/widgets/dialog_windows/dialog_funtion.dart';
import 'package:pm_ketoan/widgets/widget_icon_button.dart';
import 'package:pm_ketoan/widgets/widget_textfield.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:trina_grid/trina_grid.dart';

import 'bangkehoadonmuavao_function.dart';

class BangKeHoaDonMuaVaoView extends ConsumerStatefulWidget {
  static const name = "Bảng kê hóa đơn mua vào";
  static const title = "Bảng kê hóa đơn hàng hóa dịch vụ mua vào";

  static void show(BuildContext context) {
    showCustomDialog(context, title: title.toUpperCase(), width: 1220, height: 600, child: BangKeHoaDonMuaVaoView());
  }

  const BangKeHoaDonMuaVaoView({super.key});

  @override
  ConsumerState createState() => _BangKeHoaDonMuaVaoViewState();
}

class _BangKeHoaDonMuaVaoViewState extends ConsumerState<BangKeHoaDonMuaVaoView> {
  final lstThang = [for (int i = 1; i <= 12; i++) i];
  final txtNam = TextEditingController(text: DateTime.now().year.toString());
  final fc = BangKeHoaDonMuaVaoFunction();
  late TrinaGridStateManager stateManager;

  int selectChon = 1;
  int selectThang = DateTime.now().month;
  int selectQuy = Helper.getQuarterNow();
  bool hideFilter = true;

  @override
  void initState() {
    // TODO: implement initState
    onLoadData(quy: Helper.getQuarterNow(), nam: DateTime.now().year);
    super.initState();
  }

  void onLoadData({String? thang, int? quy, int nam = 2000}) async {
    final data = await fc.get(thang: thang, quy: quy, nam: nam);
    stateManager.removeAllRows();
    stateManager.appendRows(
      data.map((e) {
        return TrinaRow(
          cells: {
            'null': TrinaCell(value: e['STT']),
            'KyHieu': TrinaCell(value: e['KyHieu'] ?? ''),
            'SoCT': TrinaCell(value: e['SoCT'] ?? ''),
            'NgayCT': TrinaCell(value: e['NgayCT'] ?? ''),
            'TenKH': TrinaCell(value: e['TenKH'] ?? ''),
            'MST': TrinaCell(value: e['MST'] ?? ''),
            'CongTien': TrinaCell(value: e['CongTien']),
            'TienThue': TrinaCell(value: e['TienThue']),
            'DienGiai': TrinaCell(value: e['DienGiai'] ?? ''),
          },
        );
      }).toList(),
    );
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
                Text('Chọn').medium,
                Combobox(
                  value: selectChon,
                  items: [
                    ComboboxItem(value: 0, text: ['Tháng']),
                    ComboboxItem(value: 1, text: ['Quý']),
                    ComboboxItem(value: 2, text: ['Năm']),
                  ],
                  onChanged: (val) {
                    setState(() {
                      selectChon = val;
                    });
                  },
                ).sized(width: 100),
                Gap(10),
                Builder(
                  builder: (context) {
                    if (selectChon == 0) {
                      return Row(
                        spacing: 5,
                        children: [
                          Text('Tháng').medium,
                          Combobox(
                            value: selectThang,
                            items: lstThang.map((e) => ComboboxItem(value: e, text: ['$e'])).toList(),
                            onChanged: (val) {},
                          ).sized(width: 60),
                        ],
                      );
                    } else if (selectChon == 1) {
                      return Row(
                        spacing: 5,
                        children: [
                          Text('Quý').medium,
                          Combobox(
                            value: selectQuy,
                            items: List.generate(4, (i) => ComboboxItem(value: i + 1, text: ['${i + 1}'])),
                            onChanged: (val) {
                              setState(() {
                                selectQuy = val;
                              });
                            },
                          ).sized(width: 70),
                        ],
                      );
                    } else {
                      return SizedBox();
                    }
                  },
                ).sized(width: 120),
                Gap(10),
                Text('Năm').medium,
                WidgetTextField(controller: txtNam).sized(width: 50),
                TextButton(
                  child: Text('Thực hiện'),
                  onPressed: () {
                    try {
                      if (selectChon == 0) {
                        onLoadData(thang: selectThang.toString(), nam: int.parse(txtNam.text));
                      } else if (selectChon == 1) {
                        onLoadData(quy: selectQuy, nam: int.parse(txtNam.text));
                      } else {
                        onLoadData(nam: int.parse(txtNam.text));
                      }
                    } catch (e) {
                      CustomAlert.error(e.toString());
                    }
                  },
                ),
              ],
            )
          ],

        ),
      ],
      child: DataGrid(
        hideFilter: hideFilter,
        onLoaded: (e) => stateManager = e.stateManager,
        onRowDoubleTap: (event) => fc.onShowInfo(event, context, ref),
        columns: [
          DataGridColumn(title: ['', 'null'], width: 25, render: TypeRender.numIndex),
          DataGridColumn(title: ['Ký hiệu', 'KyHieu'], width: 85),
          DataGridColumn(title: ['Số HD', 'SoCT'], width: 80, textStyle: ColumnTextStyle.red()),
          DataGridColumn(title: ['Ngày HD', 'NgayCT'], width: 100, columnType: ColumnType.date),
          DataGridColumn(title: ['Tên khách hàng', 'TenKH'], width: 300),
          DataGridColumn(title: ['Mã số thuế', 'MST'], width: 120),
          DataGridColumn(title: ['Tiền chưa VAT', 'CongTien'], width: 125, columnType: ColumnType.num,showFooter: true),
          DataGridColumn(title: ['Tiền thuế', 'TienThue'], width: 125, columnType: ColumnType.num,showFooter: true),
          DataGridColumn(title: ['Ghi chú', 'DienGiai'], width: 230),
        ],
      ).withPadding(all: 5),
    );
  }
}
