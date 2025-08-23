import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/application/application.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:trina_grid/trina_grid.dart';

import '../../../widgets/widgets.dart';
import '../function/phieunhapct_function.dart';

class PhieuNhapTable extends ConsumerStatefulWidget {
  final int maID;
  final bool khoa;

  const PhieuNhapTable({super.key, required this.maID, this.khoa = false});

  @override
  PhieuNhapTableState createState() => PhieuNhapTableState();
}

class PhieuNhapTableState extends ConsumerState<PhieuNhapTable> {
  late TrinaGridStateManager _stateManager;
  final fc = PhieuNhapCTFunction();
  List<Map<String, dynamic>> lstHangHoa = [];
  List<Map<String, dynamic>> lstBTK = [];

  @override
  void initState() {
    // TODO: implement initState
    ref.read(phieuNhapCTProvider.notifier).getPNCT(widget.maID);
    super.initState();
  }

  void loadCBB() async {
    lstHangHoa = await fc.loadHH();
    lstBTK = await fc.loadBTK();
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    ref.listen(phieuNhapCTProvider, (_, state) {
      _stateManager.removeAllRows();
      if (state.isNotEmpty) {
        _stateManager.appendRows(
          state
              .map(
                (e) => TrinaRow(
                  cells: {
                    'null': TrinaCell(value: e['MaID']),
                    'dl': TrinaCell(value: e['ID']),
                    'MaHH': TrinaCell(value: e['ItemID']),
                    'TenHH': TrinaCell(value: e['TenHH']),
                    'DVT': TrinaCell(value: e['DVT'] ?? ''),
                    'SoLg': TrinaCell(value: e['SoLg']),
                    'DonGia': TrinaCell(value: e['DonGia']),
                    'ThanhTien': TrinaCell(value: e['ThanhTien']),
                    'TKkho': TrinaCell(value: e['TKkho']),
                  },
                ),
              )
              .toList(),
        );

      }
      _stateManager.appendRows([
        TrinaRow(
          cells: {
            'null': TrinaCell(value: null),
            'dl': TrinaCell(value: null),
            'MaHH': TrinaCell(value: null),
            'TenHH': TrinaCell(value: ''),
            'DVT': TrinaCell(value: ''),
            'SoLg': TrinaCell(value: ''),
            'DonGia': TrinaCell(value: ''),
            'ThanhTien': TrinaCell(value: ''),
            'TKkho': TrinaCell(value: null),
          },
        ),
      ]);
      loadCBB();
    });

    return DataGrid(
      mode: widget.khoa ? TrinaGridMode.readOnly : TrinaGridMode.normal,
      onLoaded: (e) => _stateManager = e.stateManager,
      onChange: (re) => fc.onChanged(re, ref, _stateManager),
      columns: [
        DataGridColumn(title: ['', 'null'], width: 25, render: TypeRender.numIndex),
        DataGridColumn(
          title: ['', 'dl'],
          width: 25,
          render: TypeRender.delete,
          onTapDelete: (val, re) {
            if (val != null && !widget.khoa) fc.onDeleteRow(val, re!, ref);
          },
        ),
        DataGridColumn(
          padding: 0,
          title: ['Mã hàng', 'MaHH'],
          width: 150,
          renderer: (re) {
            return Combobox(
              enabled: !widget.khoa,
              noSearch: false,
              noBorder: true,
              value: lstHangHoa.firstWhere((e) => e['ID'] == re.cell.value, orElse: () => {'MaHH': null})['MaHH'],
              menuWidth: 540,
              columnWidth: [150, 300, 90],
              items: lstHangHoa
                  .map((e) => ComboboxItem(value: e['MaHH'], text: [e['MaHH'], e['TenHH'] ?? '', e['DVT'] ?? '']))
                  .toList(),
              onTap: () {
                re.stateManager.setKeepFocus(true);
                re.stateManager.setCurrentCell(re.cell, re.rowIdx);
              },
              onChanged: (val) {
                re.cell.value = lstHangHoa.firstWhere((e) => e['MaHH'] == val)['ID'];
                fc.onChangedMaHang(ref, re, widget.maID);
              },
            );
          },
        ),
        DataGridColumn(title: ['Tên vật tư – hàng hóag', 'TenHH'], width: 300, isEdit: true),
        DataGridColumn(title: ['ĐVT', 'DVT'], width: 90, isEdit: true),
        DataGridColumn(title: ['Số lg', 'SoLg'], width: 90, isEdit: true, columnType: ColumnType.num),
        DataGridColumn(title: ['Đơn giá', 'DonGia'], width: 120, isEdit: true, columnType: ColumnType.num),
        DataGridColumn(title: ['Thành tiền', 'ThanhTien'], width: 120, isEdit: true, columnType: ColumnType.num),
        DataGridColumn(
          title: ['TK kho', 'TKkho'],
          padding: 0,
          width: 90,
          renderer: (re) {
            return Combobox(
              enabled: !widget.khoa,
              noBorder: true,
              noSearch: false,
              value: re.cell.value,
              columnWidth: [90, 210],
              items: lstBTK.map((e) => ComboboxItem(value: e['MaTK'], text: [e['MaTK'], e['TenTK']])).toList(),
              menuWidth: 300,
              onTap: () {
                re.stateManager.setKeepFocus(true);
                re.stateManager.setCurrentCell(re.cell, re.rowIdx);
              },
              onChanged: (val) {
                re.cell.value = val;
                fc.updateKho(re, ref);
              },
            );
          },
        ),
      ],
    ).sized(height: 300);
  }
}
