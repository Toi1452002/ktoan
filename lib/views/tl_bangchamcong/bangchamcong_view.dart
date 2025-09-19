import 'package:pm_ketoan/data/data.dart';
import 'package:pm_ketoan/views/tl_bangchamcong/bangchamcon_function.dart';
import 'package:pm_ketoan/widgets/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:string_validator/string_validator.dart';
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
            Map<String, TrinaCell> cells = {'null': TrinaCell(value: ''), 'dl': TrinaCell(value: e['ID'])};
            e.forEach((k, v) {
              if (k != 'Ngay' && k != 'ID') {
                cells.addAll({k: TrinaCell(value: v ?? '')});
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
            OutlineButton(
              child: Text('Thực hiện'),
              size: ButtonSize.small,
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
          DataGridColumn(title: ['', 'null'], width: 25, render: TypeRender.numIndex,frozen: true),
          DataGridColumn(title: ['', 'dl'], width: 25, render: TypeRender.delete,frozen: true,onTapDelete: (val, re)=>fc.delete(ref, val,re!)),
          DataGridColumn(
            padding: 0,
            title: ['Mã NV', 'MaNV'],frozen: true,
            width: 90,
            renderer: (re) {
              return Combobox(
                value: re.cell.value == '' ? null : re.cell.value,
                noBorder: true,
                noSearch: false,
                menuWidth: 230,
                columnWidth: [90, 140],
                items: lstNhanVien.map((e) => ComboboxItem(value: e.MaNV, text: [e.MaNV, e.HoTen!])).toList(),
                onChanged: (val) {
                  re.cell.value = val;
                  fc.onChangedMaNV(ref, re, selectThang, txtNam.text);
                },
              );
            },
          ),
          DataGridColumn(title: ['Tên nhân viên', 'HoTen'], width: 140,frozen: true),
          DataGridColumn(title: ['Cộng', 'TongCong'], width: 70, columnType: ColumnType.num,frozen: true),
          ...[
            for (int i = 1; i <= 31; i++)
              DataGridColumn(
                title: [
                  !fc.ktrNgayTonTai(i, selectThang, txtNam.text) ? '' : '$i\n${fc.getThu(selectThang, txtNam.text, i)}',
                  'N$i',
                ],
                width: 60,
                padding: 0,
                renderer: (re) {
                  if (re.cell.column.title == '') return SizedBox();
                  return Combobox(
                    value: re.cell.value == '' ? null : re.cell.value,
                    // menuWidth: 50,
                    items: lstMaCC.map((e) => ComboboxItem(value: e['Ma'], text: [e['Ma']])).toList(),
                    onChanged: (val) {
                      re.cell.value = val;
                      final gt = lstMaCC.firstWhere((e)=>e['Ma']==val)['SoCong'];
                      fc.onChangedN(ref, re, toDouble(gt.toString()), selectThang, txtNam.text);
                      re.stateManager.notifyListeners();
                    },
                    noSearch: true,
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
