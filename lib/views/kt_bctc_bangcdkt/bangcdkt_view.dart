import 'package:pm_ketoan/widgets/dialog_windows/dialog_funtion.dart';
import 'package:pm_ketoan/widgets/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trina_grid/trina_grid.dart';

import 'bangcdkt_function.dart';

class BangCDKTView extends ConsumerStatefulWidget {
  const BangCDKTView({super.key});

  static const name = "Bảng cân đối kế toán";

  static void show(BuildContext context) =>
      showCustomDialog(context, title: name.toUpperCase(), width: 1000, height: 600, child: BangCDKTView());

  @override
  ConsumerState createState() => _BangCDKTViewState();
}

class _BangCDKTViewState extends ConsumerState<BangCDKTView> {
  final fc = BangCDKTFunction();
  final txtNam = TextEditingController(text: (DateTime.now().year - 1).toString());
  late TrinaGridStateManager stateManager;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  void onLoad() async {
    await fc.thucHien(txtNam.text).whenComplete(() async {
      stateManager.removeAllRows();
      final data = await fc.get();
      stateManager.appendRows(
        data
            .map(
              (e) => TrinaRow(
                cells: {
                  'null': TrinaCell(value: e['PhanCap']),
                  'ChiTieu': TrinaCell(value: e['ChiTieu']),
                  'MaSo': TrinaCell(value: e['MaSo']),
                  'ThuyetMinh': TrinaCell(value: e['ThuyetMinh'] ?? ''),
                  'SoNamNay': TrinaCell(value: e['SoNamNay']),
                  'SoNamTruoc': TrinaCell(value: e['SoNamTruoc']),
                },
              ),
            )
            .toList(),
      );
    });
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

            Gap(100),
            Text('Năm').medium,
            WidgetTextField(controller: txtNam, isNumber: true).sized(width: 70),
            OutlineButton(size: ButtonSize.small, onPressed: () => onLoad(), child: Text('Thực hiện')),
          ],
          trailing: [
            OutlineButton(
              size: ButtonSize.small,
              onPressed: () => fc.luuSo(txtNam.text),
              child: Text('Lưu lại số năm nay'),
            ),
          ],
        ),
      ],
      child: DataGrid(
        onChange: (event)=>fc.updateTM(event),
        onLoaded: (e) {
          stateManager = e.stateManager;
          onLoad();
        },
        rowColorCallback: (re) {
          if (re.row.cells['null']?.value == 2) {
            return Colors.amber.shade100;
          } else if (re.row.cells['null']?.value == 1) {
            return Colors.cyan.shade100;
          } else {
            return Colors.transparent;
          }
        },
        columns: [
          DataGridColumn(title: ['', 'null'], width: 25, render: TypeRender.numIndex),
          DataGridColumn(title: ['Chỉ tiêu', 'ChiTieu'], width: 300, textStyle: ColumnTextStyle.blue()),
          DataGridColumn(
            title: ['Mã số', 'MaSo'],
            width: 70,
            columnAlign: ColumnAlign.center,
            textStyle: ColumnTextStyle.blue(),
          ),
          DataGridColumn(title: ['Thuyết minh', 'ThuyetMinh'], width: 300,isEdit: true),
          DataGridColumn(
            title: ['Số năm nay', 'SoNamNay'],
            width: 130,
            columnType: ColumnType.num,
            textStyle: ColumnTextStyle.red(),
          ),
          DataGridColumn(
            title: ['Số năm trước', 'SoNamTruoc'],
            width: 130,
            columnType: ColumnType.num,
            textStyle: ColumnTextStyle.blue(),
          ),
        ],
      ).withPadding(all: 5),
    );
  }
}
