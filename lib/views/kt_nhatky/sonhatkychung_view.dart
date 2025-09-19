import 'package:pm_ketoan/core/core.dart';
import 'package:pm_ketoan/data/data.dart';
import 'package:pm_ketoan/widgets/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trina_grid/trina_grid.dart';

class SoNhatKyChungView extends ConsumerStatefulWidget {
  const SoNhatKyChungView({super.key});

  static const name = "Sổ nhật ký chung";

  static void show(BuildContext context) =>
      showCustomDialog(context, title: name.toUpperCase(), width: 1000, height: 500, child: SoNhatKyChungView());

  @override
  ConsumerState createState() => _SoNhatKyChungViewState();
}

class _SoNhatKyChungViewState extends ConsumerState<SoNhatKyChungView> {
  late TrinaGridStateManager stateManager;
  DateTime tuNgay = DateTime.now().copyWith(day: 1);
  DateTime denNgay = DateTime.now();
  bool hideFilter = true;

  void onLoad() async {
    stateManager.removeAllRows();
    final data = await NhatKyRepository().getNKChung(Helper.yMd(tuNgay), Helper.yMd(denNgay));
    if (data.isNotEmpty) {
      stateManager.appendRows(
        data
            .map(
              (e) => TrinaRow(
                cells: {
                  'null': TrinaCell(value: ''),
                  'Ngay': TrinaCell(value: e['Ngay']),
                  'ChungTu': TrinaCell(value: e['ChungTu']),
                  'NgayCT': TrinaCell(value: e['NgayCT']),
                  'DienGiai': TrinaCell(value: e['DienGiai'] ?? ''),
                  'TKNo': TrinaCell(value: e['TKNo'] ?? ''),
                  'TKCo': TrinaCell(value: e['TKCo'] ?? ''),
                  'SoPS': TrinaCell(value: e['SoPS']),
                },
              ),
            )
            .toList(),
      );
    }

    setState(() {

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
            WidgetIconButton(type: IconType.filter, onPressed: () {
              setState(() {
                hideFilter = !hideFilter;
              });
            }),

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
                Gap(10),
                OutlineButton(onPressed: onLoad, child: Text('Thực hiện'),size: ButtonSize.small,),
              ],
            ),
          ],
        ),
      ],
      child: DataGrid(
        hideFilter: hideFilter,
        onLoaded: (e) {
          stateManager = e.stateManager;
          onLoad();
        },
        columns: [
          DataGridColumn(title: ['', 'null'], width: 25, render: TypeRender.numIndex),
          DataGridColumn(
            title: ['Ngày ghi sổ', 'Ngay'],
            width: 110,
            columnType: ColumnType.date,
            columnAlign: ColumnAlign.center,
          ),
          DataGridColumn(title: ['Số CT', 'ChungTu'], width: 80, columnAlign: ColumnAlign.center),
          DataGridColumn(
            title: ['Ngày CT', 'NgayCT'],
            width: 100,
            columnType: ColumnType.date,
            columnAlign: ColumnAlign.center,
          ),
          DataGridColumn(title: ['Diễn giải', 'DienGiai'], width: 300),
          DataGridColumn(title: ['TK nợ', 'TKNo'], width: 80, columnAlign: ColumnAlign.center),
          DataGridColumn(title: ['TK có', 'TKCo'], width: 80, columnAlign: ColumnAlign.center),
          DataGridColumn(title: ['Số phát sinh', 'SoPS'], width: 200, columnType: ColumnType.num, showFooter: true),
        ],
      ).withPadding(all: 5),
    );
  }
}
