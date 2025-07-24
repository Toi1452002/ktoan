import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/views/hanghoa/function/donvitinh_function.dart';
import 'package:pm_ketoan/widgets/data_grid/data_grid.dart';
import 'package:pm_ketoan/widgets/dialog_windows/dialog_funtion.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:trina_grid/trina_grid.dart';

import '../../application/application.dart';

class DonViTinhView extends ConsumerStatefulWidget {
  const DonViTinhView({super.key});

  static const name = "ĐƠN VỊ TÍNH";

  static void show(BuildContext context) {
    showCustomDialog(context, title: name, width: 290, height: 500, child: DonViTinhView(), onClose: () {});
  }

  @override
  ConsumerState createState() => _DonViTinhViewState();
}

class _DonViTinhViewState extends ConsumerState<DonViTinhView> {
  late TrinaGridStateManager _stateManager;
  List<TrinaRow<dynamic>> rows = [];
  final DonViTinhFunction fc = DonViTinhFunction();
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(donViTinhProvider);

    if(state.isNotEmpty){
      _stateManager.removeAllRows();
      _stateManager.appendRows(state.map((e) {
        return TrinaRow(
          cells: {
            'null': TrinaCell(value: ''),
            'dl': TrinaCell(value: e['ID']),
            'DVT': TrinaCell(value: e['DVT']),
          },
        );
      }).toList());
      _stateManager.appendNewRows();
    }

    return DataGrid(
      hideFilter: true,
      onLoaded: (e)=>_stateManager = e.stateManager,
      onChange: (e)=> fc.onChangedData(e, _stateManager, ref),
      columns: [
        DataGridColumn(title: ['', 'null'], width: 25, render: TypeRender.numIndex),
        DataGridColumn(title: ['', 'dl'], width: 25, render: TypeRender.delete,onTapDelete: (val){
          print(val);
        }),
        DataGridColumn(title: ['Đơn vị tính', 'DVT'],isEdit: true),
      ],
      rows:[],
    );
  }
}
