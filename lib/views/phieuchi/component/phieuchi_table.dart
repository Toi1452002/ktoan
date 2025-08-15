import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:trina_grid/trina_grid.dart';

import '../../../application/phieuchi/phieuchi_provider.dart';
import '../../../widgets/widgets.dart';
import '../function/phieuchict_function.dart';

class PhieuChiTable extends ConsumerStatefulWidget {
  final int maID;
  final bool khoa;

  const PhieuChiTable({super.key, required this.maID, required this.khoa});

  @override
  ConsumerState createState() => _PhieuChiTableState();
}

class _PhieuChiTableState extends ConsumerState<PhieuChiTable> {
  late TrinaGridStateManager _stateManager;
  final fc = PhieuChiCTFunction();

  @override
  void initState() {
    ref.read(phieuChiCTProvider.notifier).get(widget.maID);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(phieuChiCTProvider, (_, state) {
      _stateManager.removeAllRows();
      if (state.isNotEmpty) {
        _stateManager.appendRows(
          state.map((e) {
            return TrinaRow(
              cells: {
                'null': TrinaCell(value: e['MaID']),
                'dl': TrinaCell(value: e['ID']),
                'DienGiai': TrinaCell(value: e['DienGiai'] ?? 0),
                'SoTien': TrinaCell(value: e['SoTien']),
              },
            );
          }).toList(),
        );
      }
      _stateManager.appendNewRows();
    });

    return DataGrid(
      mode: widget.khoa ? TrinaGridMode.readOnly : TrinaGridMode.normal,
      onLoaded: (e) => _stateManager = e.stateManager,
      onChange: (e) => fc.onChangedCell(e, ref, widget.maID, _stateManager),
      columns: [
        DataGridColumn(title: ['', 'null'], width: 25, render: TypeRender.numIndex),
        DataGridColumn(
          title: ['', 'dl'],
          width: 25,
          render: TypeRender.delete,
          onTapDelete: (val, event) {
            if (val != null && !widget.khoa) fc.delete(val, event!, ref);
          },
        ),
        DataGridColumn(title: ['Diễn giải', 'DienGiai'], width: 250, isEdit: true),
        DataGridColumn(title: ['Số tiền', 'SoTien'], width: 150, columnType: ColumnType.num, isEdit: true),
      ],
    ).sized(height: 160);
  }
}
