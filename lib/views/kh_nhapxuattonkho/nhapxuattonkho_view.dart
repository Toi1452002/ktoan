import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/core/core.dart';
import 'package:pm_ketoan/views/kh_nhapxuattonkho/nhapxuattonkho_function.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:trina_grid/trina_grid.dart';

import '../../widgets/widgets.dart';

class NhapXuatTonKhoView extends ConsumerStatefulWidget {
  static const name = "Nhập xuất tồn kho";

  static void show(BuildContext context) =>
      showCustomDialog(context, title: name.toUpperCase(), width: 1150, height: 600, child: NhapXuatTonKhoView());

  const NhapXuatTonKhoView({super.key});

  @override
  ConsumerState createState() => _NhapXuatTonKhoViewState();
}

class _NhapXuatTonKhoViewState extends ConsumerState<NhapXuatTonKhoView> {
  DateTime tuNgay = DateTime.now().copyWith(day: 1);
  DateTime denNgay = DateTime.now();
  String? selectBTK;

  List<Map<String, dynamic>> lstBTK = [];
  late TrinaGridStateManager _stateManager;
  final fc = NhapXuatTonKhoFunction();
  final txtTenTK = TextEditingController();

  @override
  void initState() {
    loadCBB();
    loadData();
    super.initState();
  }

  void loadCBB() async {
    lstBTK = await fc.loadBTK();
    setState(() {});
  }

  void loadData() async {
    await Future.delayed(Duration(milliseconds: 100));
    await fc.get(_stateManager, tN: tuNgay, dN: denNgay, kho: selectBTK ?? '');
  }

  _buildText(dynamic text, Color color) {
    return Container(
      color: color.withValues(alpha: .3),
      alignment: Alignment.centerRight,
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Text(Helper.numFormat(text)!, style: TextStyle(fontSize: 13)).medium,
    );
  }

  _buildColumn(List<String> title, double width, Color color) {
    return DataGridColumn(
      title: title,
      width: width,
      columnType: ColumnType.num,
      showFooter: true,
      padding: 0,
      headerColor: color,
      renderer: (re) {
        return _buildText(re.cell.value.toString(), color);
      },
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
            Gap(100),
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
                TextButton(onPressed: loadData, child: Text('Thực hiện')),
              ],
            ),
          ],
        ),
        AppBar(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
          leading: [
            Gap(175),
            Text('Tài khoản').medium,
            Combobox(
              menuWidth: 370,
              columnWidth: [100, 270],
              value: selectBTK,
              items: lstBTK.map((e) => ComboboxItem(value: e['MaTK'], text: [e['MaTK'], e['TenTK']])).toList(),
              onChanged: (val) {
                txtTenTK.text = lstBTK.firstWhere((e) => e['MaTK'] == val)['TenTK'];
                setState(() {
                  selectBTK = val;
                });

                loadData();
              },
            ).sized(width: 100),
            Gap(5),
            WidgetTextField(controller: txtTenTK, readOnly: true).sized(width: 250),
          ],
        ),
      ],
      child: DataGrid(
        onLoaded: (e) {
          _stateManager = e.stateManager;
        },
        columnGroups: [
          TrinaColumnGroup(title: 'TỒN ĐẦU KỲ', fields: ['SoTon', 'TienDauKy'], backgroundColor: Colors.green.shade200),
          TrinaColumnGroup(
            title: 'NHẬP TRONG KỲ',
            fields: ['SoLgN', 'TienNhap'],
            backgroundColor: Colors.orange.shade200,
          ),
          TrinaColumnGroup(
            title: 'XUẤT TRONG KỲ',
            fields: ['SoLgX', 'DonGiaXuat', 'TienXuat'],
            backgroundColor: Colors.blue.shade200,
          ),
          TrinaColumnGroup(
            title: 'TỒN CUỐI KỲ',
            fields: ['SoLgConLai', 'TienConTai'],
            backgroundColor: Colors.orange.shade200,
          ),
        ],
        columns: [
          DataGridColumn(title: ['', 'null'], width: 25, render: TypeRender.numIndex),
          DataGridColumn(title: ['Tên hàng', 'TenHH'], width: 250, textStyle: ColumnTextStyle.red()),
          DataGridColumn(title: ['ĐVT', 'DVT'], width: 50),
          _buildColumn(['SL', 'SoTon'], 70, Colors.green.shade200),
          _buildColumn(['T.Tiền', 'TienDauKy'], 100, Colors.green.shade200),
          _buildColumn(['SL', 'SoLgN'], 70, Colors.orange.shade200),
          _buildColumn(['T.Tiền', 'TienNhap'], 100, Colors.orange.shade200),
          _buildColumn(['SL', 'SoLgX'], 70, Colors.blue.shade200),
          _buildColumn(['Giá xuất', 'DonGiaXuat'], 100, Colors.blue.shade200),
          _buildColumn(['T.Tiền', 'TienXuat'], 100, Colors.blue.shade200),
          _buildColumn(['SL', 'SoLgConLai'], 70, Colors.orange.shade200),
          _buildColumn(['T.Tiền', 'TienConTai'], 100, Colors.orange.shade200),
        ],
      ).withPadding(all: 5),
    );
  }
}
