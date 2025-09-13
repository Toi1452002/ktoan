import 'package:pm_ketoan/application/ts_ccdc/ccdc_provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trina_grid/trina_grid.dart';

import '../../core/core.dart';
import '../../widgets/widgets.dart';

class CCDCView extends ConsumerStatefulWidget {
  const CCDCView({super.key});

  static const name = "Bảng phân bổ CCDC";
  static const title = "Bảng phân bổ công cụ dụng cụ";

  static void show(BuildContext context) {
    showCustomDialog(context, title: title.toUpperCase(), width: 1300, height: 600, child: CCDCView());
  }

  @override
  ConsumerState createState() => _CCDCViewState();
}

class _CCDCViewState extends ConsumerState<CCDCView> {
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
    lstHH = await ref.read(ccdcProvider.notifier).getListHH();
    lstTKChiPhi = await ref.read(ccdcProvider.notifier).getListTKChiPhi();
    lstTKHaoMon = await ref.read(ccdcProvider.notifier).getListHaoMon();
    tN = await ref.read(ccdcProvider.notifier).getTNgay();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(ccdcProvider, (_, state) {
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
                    'SoLuong': TrinaCell(value: e['SoLuong'] ?? 0),
                    'GiaTri': TrinaCell(value: e['GiaTri'] ?? 0),
                    'NgayMua': TrinaCell(value: Helper.dMy(e['NgayMua']) ?? ''),
                    'NgaySD': TrinaCell(value: Helper.dMy(e['NgaySD']) ?? ""),
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
            PrimaryButton(
              size: ButtonSize.small,
              child: Text('Thực hiện'),
              onPressed: () => ref.read(ccdcProvider.notifier).onThucHien(dN),
            ),
          ],
        ),
      ],
      child: DataGrid(
        onLoaded: (e) => _stateManager = e.stateManager,
        onChange: (e) => ref.read(ccdcProvider.notifier).onChanged(e),
        columns: [
          DataGridColumn(title: ['', 'null'], width: 25, render: TypeRender.numIndex),
          DataGridColumn(
            title: ['', 'dl'],
            width: 25,
            render: TypeRender.delete,
            onTapDelete: (val, event) => ref.read(ccdcProvider.notifier).delete(val, event!),
          ),
          DataGridColumn(title: ['Mã DC', 'MaHH'], width: 90,padding: 0,renderer: (re) {
            return Combobox(
              value: re.cell.value == '' ? null : re.cell.value,
              noSearch: false,
              noBorder: true,
              menuWidth: 280,

              columnWidth: [90, 190],
              items: lstHH.map((e) => ComboboxItem(value: e['MaHH'], text: [e['MaHH'], e['TenHH']])).toList(),
              onChanged: (val) {
                re.cell.value = val;
                ref.read(ccdcProvider.notifier).onChangedMaHH(val, re);
              },
              onDoubleTap: () {
                ref.read(ccdcProvider.notifier).showHangHoa(re.cell.value , context);
              },
            );
          }),
          DataGridColumn(title: ['Mô tả tài công cụ dụng cụ', 'TenHH'], width: 190, textStyle: ColumnTextStyle.blue()),
          DataGridColumn(title: ['Bộ phận\nsử dụng', 'BoPhanSD'], width: 80, isEdit: true),
          DataGridColumn(title: ['Số\nlượng', 'SoLuong'], width: 70, isEdit: true, columnType: ColumnType.num),
          DataGridColumn(title: ['Giá trị', 'GiaTri'], width: 100, isEdit: true,showFooter: true, columnType: ColumnType.num),
          DataGridColumn(title: ['Ngày mua', 'NgayMua'], width: 90, isEdit: true,columnAlign: ColumnAlign.center),
          DataGridColumn(title: ['Ngày đưa\nvào sử dụng', 'NgaySD'], width: 90, isEdit: true,columnAlign: ColumnAlign.center),
          DataGridColumn(
            title: ['Số tháng\nphân bổ', 'SoThangPB'],
            width: 70,
            isEdit: true,
            columnType: ColumnType.num,
            columnAlign: ColumnAlign.center,

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
          DataGridColumn(title: ['TK chi\nphí', 'TKChiPhi'], width: 70, padding: 0, renderer: (re) {
            return Combobox(
              noBorder: true,
              menuWidth: 250,
              columnWidth: [70, 180],
              value: re.cell.value == '' ? null : re.cell.value,
              onChanged: (val) {
                re.cell.value = val;
                re.stateManager.notifyListeners();
                ref.read(ccdcProvider.notifier).onChangedTKChiPhi(val, re);
              },
              items: lstTKChiPhi.map((e) => ComboboxItem(value: e['MaTK'], text: [e['MaTK'], e['TenTK']])).toList(),
            );
          }),
          DataGridColumn(title: ['TK hao\nmòn', 'TKHaoMon'], width: 70, padding: 0, renderer: (re) {
            return Combobox(
              noBorder: true,
              menuWidth: 250,
              columnWidth: [70, 180],
              value: re.cell.value == '' ? null : re.cell.value,
              onChanged: (val) {
                re.cell.value = val;
                re.stateManager.notifyListeners();
                ref.read(ccdcProvider.notifier).onChangedTKChiPhi(val, re);
              },
              items: lstTKChiPhi.map((e) => ComboboxItem(value: e['MaTK'], text: [e['MaTK'], e['TenTK']])).toList(),
            );
          }),
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
