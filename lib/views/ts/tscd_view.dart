import 'package:pm_ketoan/application/application.dart';
import 'package:pm_ketoan/core/core.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trina_grid/trina_grid.dart';

import '../../widgets/widgets.dart';

class TSCDView extends ConsumerStatefulWidget {
  const TSCDView({super.key});

  static const name = "Bảng khấu hao TSCĐ";
  static const title = "Bảng khấu hao tài sản cố định";

  static void show(BuildContext context) {
    showCustomDialog(context, title: title.toUpperCase(), width: 1300, height: 600, child: TSCDView());
  }

  @override
  ConsumerState createState() => _TSCDViewState();
}

class _TSCDViewState extends ConsumerState<TSCDView> {
  late TrinaGridStateManager _stateManager;
  List<Map<String, dynamic>> lstHH = [];
  List<Map<String, dynamic>> lstTKChiPhi = [];
  List<Map<String, dynamic>> lstTKHaoMon = [];

  DateTime? tN;
  DateTime dN = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    loadCBB();
    super.initState();
  }

  void loadCBB() async {
    lstHH = await ref.read(tscdProvider.notifier).getListHH();
    lstTKChiPhi = await ref.read(tscdProvider.notifier).getListTKChiPhi();
    lstTKHaoMon = await ref.read(tscdProvider.notifier).getListHaoMon();
    tN = await ref.read(tscdProvider.notifier).getTNgay();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(tscdProvider, (_, state) {
      _stateManager.removeAllRows();
      if (state.isNotEmpty) {
        _stateManager.appendRows(
          state
              .map(
                (e) => TrinaRow(
                  cells: {
                    'null': TrinaCell(value: ''),
                    'dl': TrinaCell(value: e['ID']),
                    'MaHH': TrinaCell(value: e['MaHH']),
                    'TenHH': TrinaCell(value: e['TenHH']),
                    'BoPhanSD': TrinaCell(value: e['BoPhanSD'] ?? ''),
                    'NguyenGia': TrinaCell(value: e['NguyenGia'] ?? 0),
                    'NgayMua': TrinaCell(value: Helper.dMy(e['NgayMua']) ?? ''),
                    'NgaySD': TrinaCell(value: Helper.dMy(e['NgaySD']) ?? ""),
                    'SoNamPB': TrinaCell(value: e['SoNamPB'] ?? 0),
                    'SoThangPB': TrinaCell(value: e['SoThangPB'] ?? 0),
                    'GiaTriKhauHao': TrinaCell(value: e['GiaTriKhauHao'] ?? 0),
                    'LuyKe': TrinaCell(value: e['LuyKe'] ?? 0),
                    'GiaTriConLai': TrinaCell(value: e['GiaTriConLai'] ?? 0),
                    'TKChiPhi': TrinaCell(value: e['TKChiPhi'] ?? ''),
                    'TKHaoMon': TrinaCell(value: e['TKHaoMon'] ?? ''),
                  },
                ),
              )
              .toList(),
        );
      }

      _stateManager.appendNewRows();
    });

    return Scaffold(
      headers: [
        AppBar(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
          leading: [
            WidgetIconButton(type: IconType.print),
            WidgetIconButton(type: IconType.excel),
            Gap(30),
            Text('Từ ngày').medium,
            WidgetDateBox(
              initialDate: tN,
              onChanged: (val) {
                setState(() {
                  tN = val;
                });
              },
            ).sized(width: 100),
            Gap(10),
            Text('Đến ngày').medium,
            WidgetDateBox(
              initialDate: dN,
              onChanged: (val) {
                setState(() {
                  dN = val!;
                });
              },
            ).sized(width: 100),
            OutlineButton(
              size: ButtonSize.small,
              child: Text('Thực hiện'),
              onPressed: () => ref.read(tscdProvider.notifier).onThucHien(dN),
            ),
          ],
        ),
      ],
      child: DataGrid(
        onLoaded: (e) => _stateManager = e.stateManager,
        onChange: (e) => ref.read(tscdProvider.notifier).onChanged(e),
        columns: [
          DataGridColumn(title: ['', 'null'], width: 25, render: TypeRender.numIndex),
          DataGridColumn(
            title: ['', 'dl'],
            width: 25,
            render: TypeRender.delete,
            onTapDelete: (val, event) => ref.read(tscdProvider.notifier).delete(val, event!),
          ),
          DataGridColumn(
            title: ['Mã TS', 'MaHH'],
            padding: 0,
            width: 90,
            renderer: (re) {
              return Combobox(
                value: re.cell.value == '' ? null : re.cell.value,
                noSearch: false,
                noBorder: true,
                menuWidth: 280,
                columnWidth: [90, 190],
                items: lstHH.map((e) => ComboboxItem(value: e['MaHH'], text: [e['MaHH'], e['TenHH']])).toList(),
                onChanged: (val) {
                  re.cell.value = val;
                  ref.read(tscdProvider.notifier).onChangedMaHH(val, re);
                },
                onDoubleTap: () {
                  ref.read(tscdProvider.notifier).showHangHoa(re.cell.value , context);
                },
              );
            },
          ),
          DataGridColumn(title: ['Mô tả tài sản cố định', 'TenHH'], width: 190, textStyle: ColumnTextStyle.blue()),
          DataGridColumn(title: ['Bộ phận\nsử dụng', 'BoPhanSD'], width: 80, isEdit: true),
          DataGridColumn(
            title: ['Nguyên giá\n(giá mua+chi)', 'NguyenGia'],
            width: 100,
            showFooter: true,
            isEdit: true,
            columnType: ColumnType.num,
          ),
          DataGridColumn(title: ['Ngày mua', 'NgayMua'], width: 90, isEdit: true, columnAlign: ColumnAlign.center),
          DataGridColumn(
            title: ['Ngày đưa\nvào sử dụng', 'NgaySD'],
            width: 90,
            isEdit: true,
            columnAlign: ColumnAlign.center,
          ),
          DataGridColumn(
            title: ['Số năm\nphân bổ', 'SoNamPB'],
            width: 70,
            isEdit: true,
            columnType: ColumnType.num,
            columnAlign: ColumnAlign.center,
          ),
          DataGridColumn(
            title: ['Số tháng\nphân bổ', 'SoThangPB'],
            width: 70,
            columnType: ColumnType.num,
            columnAlign: ColumnAlign.center,
            textStyle: ColumnTextStyle.blue(),
          ),
          DataGridColumn(
            title: ['Tháng này', 'GiaTriKhauHao'],
            width: 100,
            columnType: ColumnType.num,
            textStyle: ColumnTextStyle.blue(),
          ),
          DataGridColumn(
            title: ['Lũy kế', 'LuyKe'],
            width: 100,
            columnType: ColumnType.num,
            textStyle: ColumnTextStyle.blue(),
          ),
          DataGridColumn(
            title: ['Giá trị còn lại', 'GiaTriConLai'],
            width: 100,
            showFooter: true,
            columnType: ColumnType.num,
            textStyle: ColumnTextStyle.blue(),
          ),
          DataGridColumn(
            title: ['TK chi\nphí', 'TKChiPhi'],
            width: 70,
            padding: 0,
            renderer: (re) {
              return Combobox(
                noBorder: true,
                menuWidth: 250,
                columnWidth: [70, 180],
                value: re.cell.value == '' ? null : re.cell.value,
                onChanged: (val) {
                  re.cell.value = val;
                  re.stateManager.notifyListeners();
                  ref.read(tscdProvider.notifier).onChangedTKChiPhi(val, re);
                },
                items: lstTKChiPhi.map((e) => ComboboxItem(value: e['MaTK'], text: [e['MaTK'], e['TenTK']])).toList(),
              );
            },
          ),
          DataGridColumn(
            title: ['TK hao\nmòn', 'TKHaoMon'],
            width: 70,
            renderer: (re) {
              return Combobox(
                noBorder: true,
                menuWidth: 250,
                value: re.cell.value == '' ? null : re.cell.value,
                columnWidth: [70, 180],
                onChanged: (val) {
                  re.cell.value = val;
                  re.stateManager.notifyListeners();
                  ref.read(tscdProvider.notifier).onChangedTKHaoMon(val, re);
                },
                items: lstTKHaoMon.map((e) => ComboboxItem(value: e['MaTK'], text: [e['MaTK'], e['TenTK']])).toList(),
              );
            },
          ),
        ],
        columnGroups: [
          TrinaColumnGroup(
            backgroundColor: Colors.blue.shade200,
            title: 'Giá trị khấu hao',
            fields: ['GiaTriKhauHao', 'LuyKe'],
          ),
        ],
      ).withPadding(all: 5),
    );
  }
}
