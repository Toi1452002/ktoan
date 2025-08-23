import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'sotienmat_function.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:trina_grid/trina_grid.dart';

import '../../widgets/widgets.dart';

class SoTienMatView extends ConsumerStatefulWidget {
  const SoTienMatView({super.key});

  static const name = "Sổ tiền mặt";

  static void show(BuildContext context) =>
      showCustomDialog(context, title: name.toUpperCase(), width: 1080, height: 600, child: SoTienMatView());

  @override
  ConsumerState createState() => _SoTienMatViewState();
}

class _SoTienMatViewState extends ConsumerState<SoTienMatView> {
  late TrinaGridStateManager stateManager;
  final fc = SoTienMatFunction();
  bool hideFilter = true;
  DateTime tuNgay = DateTime.now().copyWith(day: 1);
  DateTime denNgay = DateTime.now();
  final txtDKy = TextEditingController();
  final txtCKy = TextEditingController();

  @override
  void initState() {
    loadData();
    loadTon();
    super.initState();
  }

  void loadTon({DateTime? tN, DateTime? dN}) async {
    final data = await fc.getTon(tN: tN, dN: dN);
    txtDKy.text = data.first;
    txtCKy.text = data.last;
  }

  void loadData({DateTime? tN, DateTime? dN}) async {
    final data = await fc.get(tN: tN, dN: dN);
    stateManager.removeAllRows();
    stateManager.appendRows(
      data.map((e) {
        return TrinaRow(
          cells: {
            'null': TrinaCell(value: e['STT']),
            'Ngay': TrinaCell(value: e['Ngay']),
            'Phieu': TrinaCell(value: e['Phieu']),
            'NoiDung': TrinaCell(value: e['NoiDung'] ?? ''),
            'Kieu': TrinaCell(value: e['Kieu'] ?? ''),
            'PTTT': TrinaCell(value: e['PTTT']),
            'SoCT': TrinaCell(value: e['SoCT']),
            'TKDU': TrinaCell(value: e['TKDU']),
            'Thu': TrinaCell(value: e['Thu']),
            'Chi': TrinaCell(value: e['Chi']),
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
            WidgetIconButton(type: IconType.print),
            WidgetIconButton(type: IconType.excel),
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
                TextButton(
                  child: Text('Thực hiện'),
                  onPressed: () async {
                    loadData(tN: tuNgay, dN: denNgay);
                    loadTon(tN: tuNgay, dN: denNgay);
                  },
                ),
              ],
            ),
          ],
          trailing: [
            Text('Tồn đầu kỳ').medium,
            WidgetTextField(controller: txtDKy, readOnly: true,textAlign: TextAlign.end,).sized(width: 150),
            Gap(20),
          ],
        ),
      ],
      footers: [
        AppBar(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          trailing: [
            Text('Tồn cuối kỳ').medium,
            WidgetTextField(controller: txtCKy, readOnly: true,textAlign: TextAlign.end).sized(width: 150),
            Gap(20),
          ],
        ),
      ],
      child: DataGrid(
        onLoaded: (e) => stateManager = e.stateManager,
        onRowDoubleTap: (event)=>fc.showInfo(event, ref, context),
        hideFilter: hideFilter,
        columns: [
          DataGridColumn(title: ['', 'null'], width: 25, render: TypeRender.numIndex),
          DataGridColumn(title: ['Ngày', 'Ngay'], width: 90, columnType: ColumnType.date),
          DataGridColumn(title: ['Phiếu', 'Phieu'], width: 90, textColor: TextColor.red),
          DataGridColumn(title: ['Lý do', 'NoiDung'], width: 250),
          DataGridColumn(title: ['Kiểu', 'Kieu'], width: 100),
          DataGridColumn(title: ['PTTT', 'PTTT'], width: 80),
          DataGridColumn(title: ['Số CT', 'SoCT'], width: 90),
          DataGridColumn(title: ['TKĐƯ', 'TKDU'], width: 80),
          DataGridColumn(title: ['Thu', 'Thu'], width: 120, columnType: ColumnType.num,showFooter: true),
          DataGridColumn(title: ['Chi', 'Chi'], width: 120, columnType: ColumnType.num,showFooter: true),
        ],
      ).withPadding(all: 5),
    );
  }
}
