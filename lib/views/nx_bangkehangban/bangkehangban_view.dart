import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:trina_grid/trina_grid.dart';
import '../../core/core.dart';
import '../../widgets/widgets.dart';
import 'bangkehangban_function.dart';

class BangKeHangBanView extends ConsumerStatefulWidget {
  static const name = "Bảng kê hàng bán";

  static void show(BuildContext context) =>
      showCustomDialog(context, title: name.toUpperCase(), width: 1100, height: 600, child: BangKeHangBanView());

  const BangKeHangBanView({super.key});

  @override
  ConsumerState createState() => _BangKeHangBanViewState();
}

class _BangKeHangBanViewState extends ConsumerState<BangKeHangBanView> {
  final lstThang = [for (int i = 1; i <= 12; i++) i];
  final fc = BangKeHangBanFunction();
  late TrinaGridStateManager stateManager;

  int selectChon = 1;
  int selectThang = DateTime.now().month;
  int selectQuy = Helper.getQuarterNow();
  bool hideFilter = true;
  final txtNam = TextEditingController(text: DateTime.now().year.toString());

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
            'null': TrinaCell(value: ''),
            'MaHH': TrinaCell(value: e['MaHH'] ?? ''),
            'TenHH': TrinaCell(value: e['TenHH'] ?? ''),
            'DVT': TrinaCell(value: e['DVT'] ?? ''),
            'SoLg': TrinaCell(value: e['SoLg']),
            'ThanhTien': TrinaCell(value: e['ThanhTien']),
            'ThueSuat': TrinaCell(value: e['ThueSuat']),
            'TienThue': TrinaCell(value: e['TienThue']),
            'CongTien': TrinaCell(value: e['CongTien']),
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
                Gap(5),
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
                Gap(10),
                OutlineButton(
                  size: ButtonSize.small,
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
            ),
          ],
        ),
      ],
      child: DataGrid(
        onLoaded: (e) => stateManager = e.stateManager,
        hideFilter: hideFilter,
        columns: [
          DataGridColumn(title: ['', 'null'], width: 25, render: TypeRender.numIndex),
          DataGridColumn(title: ['Mã hàng', 'MaHH'], width: 100, textStyle: ColumnTextStyle.red()),
          DataGridColumn(title: ['Tên hàng', 'TenHH'], width: 300),
          DataGridColumn(title: ['ĐVT', 'DVT'], width: 80),
          DataGridColumn(title: ['Số lg', 'SoLg'], width: 80, columnType: ColumnType.num),
          DataGridColumn(
            title: ['Tiền chưa VAT', 'ThanhTien'],
            width: 130,
            columnType: ColumnType.num,
            showFooter: true,
          ),
          DataGridColumn(title: ['Thuế', 'ThueSuat'], width: 100, columnType: ColumnType.num),
          DataGridColumn(title: ['Tiền thuế', 'TienThue'], width: 130, columnType: ColumnType.num, showFooter: true),
          DataGridColumn(title: ['Cộng tiền', 'CongTien'], width: 130, columnType: ColumnType.num, showFooter: true),
        ],
      ).withPadding(all: 5),
    );
  }
}
