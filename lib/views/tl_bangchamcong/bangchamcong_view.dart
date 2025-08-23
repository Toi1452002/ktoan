import 'package:pm_ketoan/data/data.dart';
import 'package:pm_ketoan/views/tl_bangchamcong/bangchamcon_function.dart';
import 'package:pm_ketoan/widgets/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trina_grid/trina_grid.dart';

import '../../application/bangchamcong/bangchamcong_provider.dart';

class BangChamCongView extends ConsumerStatefulWidget {
  static const name = "Bảng chấm công";

  static void show(BuildContext context) =>
      showCustomDialog(context, title: name.toUpperCase(), width: 1300, height: 600, child: BangChamCongView());

  const BangChamCongView({super.key});

  @override
  ConsumerState createState() => _BangChamCongViewState();
}

class _BangChamCongViewState extends ConsumerState<BangChamCongView> {
  late TrinaGridStateManager stateManager;
  final fc = BangChamCongFunction();

  int selectThang = DateTime.now().month;
  final txtNam = TextEditingController(text: DateTime.now().year.toString());

  List<NhanVienModel> lstNhanVien = [];
  List<Map<String, dynamic>> lstMaCC = [];

  // List<DataRow2> lstRows = [];

  @override
  void initState() {
    // TODO: implement initState

    loadCBB();
    ref.read(bangChamCongProvider.notifier).get(selectThang, txtNam.text);

    super.initState();
  }

  void loadCBB() async {
    lstNhanVien = await fc.getListNV();
    lstMaCC = await fc.getListMaCC();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(bangChamCongProvider, (context, state) {
      stateManager.removeAllRows();
      if (state.isNotEmpty) {
        stateManager.appendRows(
          state.map((e) {
            Map<String, TrinaCell> cells = {'null': TrinaCell(value: ''), 'dl': TrinaCell(value: '')};
            e.forEach((k, v) {
              if (k != 'Ngay' && k != 'ID') {
                cells.addAll({k: TrinaCell(value: v??'')});
              }
            });
            return TrinaRow(cells: cells);
          }).toList(),
        );
      }

      stateManager.appendNewRows();
    });

    return Scaffold(
      headers: [
        AppBar(
          padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
          leading: [
            Gap(200),
            Text('Tháng').medium,
            Combobox(
              value: selectThang,
              items: [
                for (int i = 1; i <= 12; i++) ComboboxItem(value: i, text: ["$i"]),
              ],
              onChanged: (val) {
                setState(() {
                  selectThang = val;
                });
              },
            ).sized(width: 60),
            Gap(30),
            Text('Năm').medium,
            WidgetTextField(controller: txtNam).sized(width: 60),
            Gap(10),
            TextButton(
              child: Text('Thực hiện'),
              onPressed: () {
                ref.read(bangChamCongProvider.notifier).get(selectThang, txtNam.text);

                for (int i = 1; i <= 31; i++) {
                  stateManager.columns[4 + i].title = !fc.ktrNgayTonTai(i, selectThang, txtNam.text)
                      ? ''
                      : '$i\n${fc.getThu(selectThang, txtNam.text, i)}';
                }
                stateManager.notifyListeners();
              },
            ),
          ],
        ),
      ],
      child: DataGrid(
        columnHeight: 40,
        onLoaded: (e) => stateManager = e.stateManager,
        columns: [
          DataGridColumn(title: ['', 'null'], width: 25, render: TypeRender.numIndex),
          DataGridColumn(title: ['', 'dl'], width: 25, render: TypeRender.delete),
          DataGridColumn(title: ['Mã NV', 'MaNV'], width: 70),
          DataGridColumn(title: ['Tên nhân viên', 'HoTen'], width: 120),
          DataGridColumn(title: ['Cộng', 'TongCong'], width: 70, columnType: ColumnType.num),
          ...[
            for (int i = 1; i <= 31; i++)
              DataGridColumn(
                title: [
                  !fc.ktrNgayTonTai(i, selectThang, txtNam.text) ? '' : '$i\n${fc.getThu(selectThang, txtNam.text, i)}',
                  'N$i',
                ],
                width: 60,
                renderer: (re) {
                  return Combobox(
                    value: re.cell.value == '' ? null : re.cell.value,
                    menuWidth: 50,
                    items: lstMaCC.map((e) => ComboboxItem(value: e['Ma'], text: [e['Ma']])).toList(),
                    onChanged: (val) {
                      re.cell.value = val;
                    },
                    noSearch: false,
                    noBorder: true,
                  );
                },
              ),
          ],
        ],
      ).withPadding(all: 5),
    );
  }
}
