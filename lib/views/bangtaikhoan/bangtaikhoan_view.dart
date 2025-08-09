import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/application/application.dart';
import 'package:pm_ketoan/views/bangtaikhoan/function/bangtaikhoan_function.dart';
import 'package:pm_ketoan/widgets/data_grid/data_grid.dart';
import 'package:pm_ketoan/widgets/dialog_windows/dialog_funtion.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:trina_grid/trina_grid.dart';

class BangTaiKhoanView extends ConsumerStatefulWidget {
  const BangTaiKhoanView({super.key});

  static const name = "Bảng tài khoản";

  static void show(BuildContext context) => showCustomDialog(
    context,
    title: name.toUpperCase(),
    width: 970,
    height: 700,
    child: BangTaiKhoanView(),
    onClose: () {},
  );

  @override
  ConsumerState createState() => _BangTaiKhoanViewState();
}

class _BangTaiKhoanViewState extends ConsumerState<BangTaiKhoanView> {
  late TrinaGridStateManager _stateManager;
  final fc = BangTaiKhoanFunction();

  @override
  Widget build(BuildContext context) {
    ref.listen(bangTaiKhoanProvider, (_, state) {
      _stateManager.removeAllRows();
      if (state.isNotEmpty) {
        _stateManager.appendRows(
          state
              .map(
                (e) => TrinaRow(
                  cells: {
                    'null': TrinaCell(value: ''),
                    'dl': TrinaCell(value: e['ID']),
                    'MaTK': TrinaCell(value: e['MaTK'] ?? ''),
                    'TenTK': TrinaCell(value: e['TenTK']),
                    'TinhChat': TrinaCell(value: e['TinhChat'] ?? ''),
                    'GhiChu': TrinaCell(value: e['GhiChu'] ?? ''),
                    'MAXL': TrinaCell(value: e['MAXL'],renderer: (re){
                      return Text(re.cell.value == 0?'Con':'Mẹ',style: TextStyle(
                        color: re.cell.value == 0?  Colors.blue.shade700:Colors.red.shade700
                      ),).center();
                    }),
                  },
                ),
              )
              .toList(),
        );

        _stateManager.appendNewRows();
      }
    });

    return DataGrid(
      onLoaded: (e) => _stateManager = e.stateManager,
      rowColorCallback: (re){
        if(re.row.cells['MAXL']?.value == 1){
          return Colors.gray.shade200;
        }else{
          return Colors.transparent;
        }
      },
      onChange: (re)=>fc.onChange(re, ref, _stateManager),
      columns: [
        DataGridColumn(title: ['', 'null'], width: 25, render: TypeRender.numIndex),
        DataGridColumn(title: ['', 'dl'], width: 25, render: TypeRender.delete,onTapDelete: (val, re)=>fc.onTapDelete(ref, val, re!)),
        DataGridColumn(title: ['Mã TK', 'MaTK'], width: 100, isEdit: true),
        DataGridColumn(title: ['Mô tả', 'TenTK'], width: 350, isEdit: true),
        DataGridColumn(title: ['TC', 'TinhChat'], width: 70, isEdit: true,columnAlign: ColumnAlign.center),
        DataGridColumn(title: ['Ghi chú', 'GhiChu'], width: 250, isEdit: true),
        DataGridColumn(title: ['Nhóm', 'MAXL'], width: 100, isEdit: true,columnAlign: ColumnAlign.center),
      ],
    );
  }
}
