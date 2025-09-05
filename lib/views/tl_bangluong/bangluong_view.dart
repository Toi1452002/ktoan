import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/application/application.dart';
import 'package:pm_ketoan/views/tl_bangluong/bangluong_function.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:trina_grid/trina_grid.dart';

import '../../data/data.dart';
import '../../widgets/widgets.dart';

class BangLuongView extends ConsumerStatefulWidget {
  const BangLuongView({super.key});

  static const name = "Bảng thanh toán lương";
  static const title = "Bảng lương";

  static void show(BuildContext context) =>
      showCustomDialog(context, title: title.toUpperCase(), width: 1330, height: 600, child: BangLuongView());

  @override
  ConsumerState createState() => _BangLuongViewState();
}

class _BangLuongViewState extends ConsumerState<BangLuongView> {
  late TrinaGridStateManager stateManager;
  final fc = BangLuongFunction();
  final txtNam = TextEditingController(text: DateTime.now().year.toString());
  List<NhanVienModel> lstNhanVien = [];
  int selectThang = DateTime.now().month;

  @override
  void initState() {
    // TODO: implement initState
    loadCBB();
    super.initState();
  }

  void loadCBB() async {
    lstNhanVien = await fc.getListNV();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(bangLuongProvider, (_, state) {
      stateManager.removeAllRows();
      if (state.isNotEmpty) {
        stateManager.appendRows(
          state
              .map(
                (e) => TrinaRow(
                  cells: {
                    'null': TrinaCell(value: ''),
                    'dl': TrinaCell(value: e['ID']),
                    'MaNV': TrinaCell(value: e['MaNV']),
                    'HoTen': TrinaCell(value: e['HoTen']),
                    'ChucVu': TrinaCell(value: e['ChucVu']),
                    'LuongCoBan': TrinaCell(value: e['LuongCoBan']),
                    'PC1': TrinaCell(value: e['PC1'] ?? ''),
                    'PC2': TrinaCell(value: e['PC2'] ?? ''),
                    'LuongBHXH': TrinaCell(value: e['LuongBHXH'] ?? ''),
                    'GT1': TrinaCell(value: e['GT1'] ?? ''),
                    'NgayCong': TrinaCell(value: e['NgayCong'] ?? ''),
                    'LuongThoiGian': TrinaCell(value: e['LuongThoiGian'] ?? ''),
                    'TNchiuThue': TrinaCell(value: e['TNchiuThue'] ?? ''),
                    'GT2': TrinaCell(value: e['GT2'] ?? ''),
                    'TNtinhThue': TrinaCell(value: e['TNtinhThue'] ?? ''),
                    'ThueCN': TrinaCell(value: e['ThueCN'] ?? ''),
                    'ThucLanh': TrinaCell(value: e['ThucLanh'] ?? ''),
                    'TamUng': TrinaCell(value: e['TamUng'] ?? ''),
                    'ConLai': TrinaCell(value: e['ConLai'] ?? ''),
                  },
                ),
              )
              .toList(),
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
                ref.read(bangLuongProvider.notifier).getData(thang: selectThang.toString(), nam: txtNam.text);
              },
            ),
          ],
        ),
      ],
      child: DataGrid(
        columnHeight: 40,
        onLoaded: (e) => stateManager = e.stateManager,
        onChange: (event) => fc.onChangedCell(ref, event, selectThang, txtNam.text),
        onRowDoubleTap: (event)=>fc.showPCGT(context,event),
        columns: [
          DataGridColumn(title: ['', 'null'], width: 25, render: TypeRender.numIndex),
          DataGridColumn(
            title: ['', 'dl'],
            width: 25,
            render: TypeRender.delete,
            onTapDelete: (val, re) => fc.delete(ref, val, re!),
          ),
          DataGridColumn(
            title: ['Mã NV', 'MaNV'],
            width: 80,
            padding: 0,
            renderer: (re) {
              return Combobox(
                value: re.cell.value == '' ? null : re.cell.value,
                noBorder: true,
                noSearch: false,
                menuWidth: 220,
                onDoubleTap: () => fc.showNhanVien(context, ref, re.cell.value),
                columnWidth: [80, 140],
                items: lstNhanVien.map((e) => ComboboxItem(value: e.MaNV, text: [e.MaNV, e.HoTen!])).toList(),
                onChanged: (val) {
                  re.cell.value = val;
                  fc.onChangedMaNV(ref, re, selectThang, txtNam.text);
                },
              );
            },
          ),
          DataGridColumn(title: ['Tên nhân viên', 'HoTen'], width: 150, textStyle: ColumnTextStyle.blue()),
          DataGridColumn(title: ['Chức vụ', 'ChucVu'], width: 80, textStyle: ColumnTextStyle.blue()),
          DataGridColumn(
            title: ['Lương CB', 'LuongCoBan'],
            width: 80,
            showFooter: true,
            columnType: ColumnType.num,
            isEdit: true,
          ),
          DataGridColumn(
            title: ['Phụ cấp\ncó BH', 'PC1'],
            width: 80,
            showFooter: true,
            columnType: ColumnType.num,
            textStyle: ColumnTextStyle.red(),
          ),
          DataGridColumn(
            title: ['Phụ cấp\nkhông BH', 'PC2'],
            width: 80,
            showFooter: true,
            columnType: ColumnType.num,
            textStyle: ColumnTextStyle.red(),
          ),
          DataGridColumn(
            title: ['Lương\nBHXH', 'LuongBHXH'],
            width: 80,
            showFooter: true,
            columnType: ColumnType.num,
            textStyle: ColumnTextStyle.blue(),
          ),
          DataGridColumn(
            title: ['Giảm trừ\nBH', 'GT1'],
            width: 80,
            showFooter: true,
            columnType: ColumnType.num,
            textStyle: ColumnTextStyle.red(),
          ),
          DataGridColumn(
            title: ['Ngày\ncông', 'NgayCong'],
            width: 50,
            columnAlign: ColumnAlign.center,
            isEdit: true,
            columnType: ColumnType.num,
          ),
          DataGridColumn(
            title: ['Lương thời\ngian', 'LuongThoiGian'],
            width: 80,
            showFooter: true,
            columnType: ColumnType.num,
            textStyle: ColumnTextStyle.blue(),
          ),
          DataGridColumn(
            title: ['Thu nhập\nchịu thuế', 'TNchiuThue'],
            width: 80,
            showFooter: true,
            columnType: ColumnType.num,
            textStyle: ColumnTextStyle.blue(),
          ),
          DataGridColumn(
            title: ['Các khoản\ngiảm', 'GT2'],
            width: 80,
            showFooter: true,
            columnType: ColumnType.num,
            textStyle: ColumnTextStyle.red(),
          ),
          DataGridColumn(
            title: ['Thu nhập\ntính thuế', 'TNtinhThue'],
            width: 80,
            showFooter: true,
            columnType: ColumnType.num,
            textStyle: ColumnTextStyle.blue(),
          ),
          DataGridColumn(
            title: ['Thuế\nTNCN', 'ThueCN'],
            width: 80,
            showFooter: true,
            columnType: ColumnType.num,
            textStyle: ColumnTextStyle.blue(fontWeight: FontWeight.w500),
          ),
          DataGridColumn(
            title: ['Thực lãnh', 'ThucLanh'],
            width: 80,
            showFooter: true,
            columnType: ColumnType.num,
            textStyle: ColumnTextStyle.blue(),
          ),
          DataGridColumn(
            title: ['Tạm ứng', 'TamUng'],
            width: 80,
            showFooter: true,
            isEdit: true,
            columnType: ColumnType.num,
          ),
          DataGridColumn(
            title: ['Còn lại', 'ConLai'],
            width: 80,
            showFooter: true,
            columnType: ColumnType.num,
            textStyle: ColumnTextStyle.blue(),
          ),
        ],
      ).withPadding(all: 5),
    );
  }
}
