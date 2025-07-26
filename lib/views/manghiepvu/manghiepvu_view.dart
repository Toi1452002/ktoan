import 'package:pm_ketoan/application/application.dart';
import 'package:pm_ketoan/views/manghiepvu/function/manghiepvu_function.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trina_grid/trina_grid.dart';

import '../../widgets/widgets.dart';

class MaNghiepVuView extends ConsumerStatefulWidget {
  const MaNghiepVuView({super.key});

  static const name = "Mã nghiệp vụ";

  static void show(BuildContext context) {
    showCustomDialog(context, title: name, width: 360, height: 600, child: MaNghiepVuView(), onClose: () {});
  }

  @override
  ConsumerState createState() => _MaNghiepVuViewState();
}

class _MaNghiepVuViewState extends ConsumerState<MaNghiepVuView> {
  late TrinaGridStateManager _stateManager;
  final fc = MaNghiepVuFunction();

  @override
  Widget build(BuildContext context) {
    ref.listen(maNghiepVuProvider, (_, state) {
      _stateManager.removeAllRows();
      if (state.isNotEmpty) {
        _stateManager.appendRows(
          state
              .map(
                (e) => TrinaRow(
                  cells: {
                    'null': TrinaCell(value: ''),
                    'dl': TrinaCell(value: e['ID']),
                    'MaNV': TrinaCell(value: e['MaNV']),
                    'MoTa': TrinaCell(value: e['MoTa']),
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
      onChange: (e) => fc.onChange(e, ref, _stateManager),
      columns: [
        DataGridColumn(title: ['', 'null'], width: 25, render: TypeRender.numIndex),
        DataGridColumn(
          title: ['', 'dl'],
          width: 25,
          render: TypeRender.delete,
          onTapDelete: (val, e) => fc.onTapDelete(ref, val, e!),
        ),
        DataGridColumn(title: ['Mã', 'MaNV'], width: 100, isEdit: true),
        DataGridColumn(title: ['Mô tả', 'MoTa'], width: 195, isEdit: true),
      ],
    );
  }
}
