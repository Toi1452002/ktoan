import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trina_grid/trina_grid.dart';
import '../../widgets/widgets.dart';
import 'daukytaikhoan_function.dart';

class DauKyBTKView extends ConsumerStatefulWidget {
  const DauKyBTKView({super.key});

  static const title = "Đầu kỳ tài khoản";
  static const name = "Đầu kỳ tài khoản";

  static void show(BuildContext context) {
    showCustomDialog(context, title: title.toUpperCase(), width: 700, height: 600, child: DauKyBTKView());
  }

  @override
  ConsumerState createState() => _DauKyBTKViewState();
}

class _DauKyBTKViewState extends ConsumerState<DauKyBTKView> {
  late TrinaGridStateManager _stateManager;
  int thang = DateTime.now().month;
  final txtNam = TextEditingController(text: DateTime.now().year.toString());
  List<Map<String, dynamic>> data = [];
  final fc = DauKyBTKFunction();

  @override
  void initState() {
    // TODO: implement initState
    loadData();
    super.initState();
  }

  void loadData() async {
    data = await fc.get();
    if (data.isNotEmpty) {
      _stateManager.removeAllRows();
      _stateManager.appendRows(
        data.map((e) {
          return TrinaRow(
            cells: {
              'null': TrinaCell(value: ''),
              'MaTK': TrinaCell(value: e['MaTK']),
              'TenTK': TrinaCell(value: e['TenTK']),
              'DKCo': TrinaCell(value: e['DKCo'] ?? 0),
              'DKNo': TrinaCell(value: e['DKNo'] ?? 0),
              'TinhChat': TrinaCell(value: e['TinhChat']),
            },
          );
        }).toList(),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      headers: [
        AppBar(
          padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
          leading: [
            Gap(100),
            Text('Tháng'),
            Combobox(
              value: thang,
              items: [
                for (int i = 1; i <= 12; i++) ComboboxItem(value: i, text: ['$i']),
              ],
              onChanged: (val) {
                setState(() {
                  thang = val;
                });
              },
            ).sized(width: 60),
            Gap(10),
            Text('Năm'),
            WidgetTextField(controller: txtNam, isNumber: true).sized(width: 60),
          ],
          trailing: [
            TextButton(
              child: Text('Thực hiện lưu đầu kỳ'),
              onPressed: () async {
                final result = await fc.isCapNhat(_stateManager, DateTime(int.parse(txtNam.text), thang));
                if (!result) loadData();
              },
            ),
          ],
        ),
      ],
      child: DataGrid(
        onLoaded: (e) => _stateManager = e.stateManager,
        columns: [
          DataGridColumn(title: ['', 'null'], width: 25, render: TypeRender.numIndex),
          DataGridColumn(title: ['Mã TK', 'MaTK'], width: 80, textStyle: ColumnTextStyle.blue()),
          DataGridColumn(title: ['Mô tả tài khoản', 'TenTK'], width: 290, textStyle: ColumnTextStyle.blue()),
          DataGridColumn(title: ['TC', 'TinhChat'], width: 50, isEdit: true),
          DataGridColumn(
            title: ['Đầu kỳ nợ', 'DKNo'],
            width: 100,
            isEdit: true,
            columnType: ColumnType.num,
            showFooter: true,
          ),
          DataGridColumn(
            title: ['Đầu kỳ có', 'DKCo'],
            width: 100,
            isEdit: true,
            columnType: ColumnType.num,
            showFooter: true,
          ),
        ],
      ).withPadding(all: 5),
    );
  }
}
