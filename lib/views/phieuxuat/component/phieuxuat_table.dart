import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/views/phieuxuat/function/phieuxuatct_function.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:trina_grid/trina_grid.dart';

import '../../../application/application.dart';
import '../../../widgets/widgets.dart';

class PhieuXuatTable extends ConsumerStatefulWidget {
  final int maID;
  final bool khoa;

  const PhieuXuatTable({super.key,  required this.maID, required this.khoa});

  @override
  ConsumerState createState() => _PhieuXuatTableState();
}

class _PhieuXuatTableState extends ConsumerState<PhieuXuatTable> {
  late TrinaGridStateManager _stateManager;
  List<Map<String, dynamic>> lstHangHoa = [];
  List<Map<String, dynamic>> lstTkNo = [];
  List<Map<String, dynamic>> lstTkCo = [];

  final fc =  PhieuXuatCTFunction();
  @override
  void initState() {
    // TODO: implement initState
    ref.read(phieuXuatCTProvider.notifier).getPXCT(widget.maID);
    super.initState();
  }
  void onLoadCBB() async {
    lstHangHoa = await fc.loadHH();
    lstTkNo = await fc.loadTkNo();
    lstTkCo = await fc.loadTkCo();
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    ref.listen(phieuXuatCTProvider, (_, state){
      _stateManager.removeAllRows();
      if(state.isNotEmpty){
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
                'TKgv': TrinaCell(value: e['TKgv']),
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
            'TKgv': TrinaCell(value: null),
            'TKkho': TrinaCell(value: null),
          },
        ),
      ]);
      onLoadCBB();
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
        DataGridColumn(title: ['Tên vật tư – hàng hóa', 'TenHH'], width: 300, isEdit: true),
        DataGridColumn(title: ['ĐVT', 'DVT'], width: 90, isEdit: true),
        DataGridColumn(title: ['Số lg', 'SoLg'], width: 90, isEdit: true, columnType: ColumnType.num),
        DataGridColumn(title: ['Đơn giá', 'DonGia'], width: 120, isEdit: true, columnType: ColumnType.num),
        DataGridColumn(title: ['Thành tiền', 'ThanhTien'], width: 120, isEdit: true, columnType: ColumnType.num),
        DataGridColumn(
          title: ['TK Nợ', 'TKgv'],
          padding: 0,
          width: 80,
          renderer: (re) {
            return Combobox(
              enabled: !widget.khoa,
              noBorder: true,
              noSearch: false,
              value: re.cell.value,
              columnWidth: [90, 210],
              items: lstTkNo.map((e) => ComboboxItem(value: e['MaTK'], text: [e['MaTK'], e['TenTK']])).toList(),
              menuWidth: 300,
              onTap: () {
                re.stateManager.setKeepFocus(true);
                re.stateManager.setCurrentCell(re.cell, re.rowIdx);
              },
              onChanged: (val) {
                re.cell.value = val;
                fc.updateTkNo(re, ref);
              },
            );
          },
        ),
        DataGridColumn(
          title: ['TK Có', 'TKkho'],
          padding: 0,
          width: 80,
          renderer: (re) {
            return Combobox(
              enabled: !widget.khoa,
              noBorder: true,
              noSearch: false,
              value: re.cell.value,
              columnWidth: [90, 210],
              items: lstTkCo.map((e) => ComboboxItem(value: e['MaTK'], text: [e['MaTK'], e['TenTK']])).toList(),
              menuWidth: 300,
              onTap: () {
                re.stateManager.setKeepFocus(true);
                re.stateManager.setCurrentCell(re.cell, re.rowIdx);
              },
              onChanged: (val) {
                re.cell.value = val;
                fc.updateTkCo(re, ref);
              },
            );
          },
        ),
      ],
    ).sized(height: 300);
  }
}
