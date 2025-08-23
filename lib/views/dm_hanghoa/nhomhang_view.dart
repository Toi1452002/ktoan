import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/application/application.dart';
import 'package:pm_ketoan/widgets/dialog_windows/dialog_funtion.dart';
import 'package:pm_ketoan/widgets/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:trina_grid/trina_grid.dart';

import 'function/nhomhang_function.dart';

class NhomHangView extends ConsumerStatefulWidget {
  const NhomHangView({super.key});

  static const name = "NHÓM HÀNG";

  static void show(BuildContext context, void Function() onClose) {
    showCustomDialog(context, title: name, width: 270, height: 500, child: NhomHangView(), onClose: onClose);
  }

  @override
  ConsumerState createState() => _NhomHangViewState();
}

class _NhomHangViewState extends ConsumerState<NhomHangView> {
  late TrinaGridStateManager stateManager;
  NhomHangFunction fc = NhomHangFunction();

  @override
  Widget build(BuildContext context) {
    ref.listen(nhomHangProvider, (context, state){
      stateManager.removeAllRows();
      if(state.isNotEmpty){

        stateManager.appendRows(state.map((e)=>TrinaRow(cells: {
          'null': TrinaCell(value: ''),
          'dl': TrinaCell(value: e['ID']),
          'NhomHang': TrinaCell(value: e['NhomHang']),
        })).toList());
        stateManager.appendNewRows();
      }
    });


    return DataGrid(
      onLoaded: (e)=>stateManager = e.stateManager,
      onChange: (e)=>fc.onChangedData(e, stateManager, ref),
      columns: [
        DataGridColumn(title: ['', 'null'], width: 25, render: TypeRender.numIndex),
        DataGridColumn(
          title: ['', 'dl'],
          width: 25,
          render: TypeRender.delete,
          onTapDelete: (val, re) => fc.onTapDelete(ref, val, re!),
        ),
        DataGridColumn(title: ['Nhóm hàng', 'NhomHang'], isEdit: true),
      ],
    );
  }
}
