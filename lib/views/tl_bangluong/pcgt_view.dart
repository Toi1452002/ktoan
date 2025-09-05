import 'package:pm_ketoan/data/data.dart';
import 'package:pm_ketoan/widgets/data_grid/data_grid.dart';
import 'package:pm_ketoan/widgets/dialog_windows/dialog_funtion.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trina_grid/trina_grid.dart';

class PCGTView extends ConsumerStatefulWidget {
  const PCGTView({super.key, required this.maNV, required this.maPCGT});

  final String maNV;
  final String maPCGT;

  static const name = "PHỤ CẤP và GIẢM TRỪ";

  static void show(BuildContext context, String maNV, String maPCGT) {
    showCustomDialog(
      context,
      title: name,
      width: 360,
      height: 200,
      child: PCGTView(maNV: maNV, maPCGT: maPCGT),
    );
  }

  @override
  ConsumerState createState() => _PCGTViewState();
}

class _PCGTViewState extends ConsumerState<PCGTView> {
  late TrinaGridStateManager stateManager;

  @override
  void initState() {
    // TODO: implement initState
    onLoad();
    super.initState();
  }

  onLoad() async {
    final data = await NhanVienRepository().getPCGTBL(maNV: widget.maNV, ma: widget.maPCGT);
    stateManager.appendRows(
      data
          .map(
            (e) => TrinaRow(
              cells: {
                'null': TrinaCell(value: ''),
                'MoTa': TrinaCell(value: e['MoTa']),
                'SoTieuChuan': TrinaCell(value: e['SoTieuChuan']),
                'SoThucTe': TrinaCell(value: e['SoThucTe']),
              },
            ),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      child: DataGrid(
        onLoaded: (e) => stateManager = e.stateManager,
        columns: [
          DataGridColumn(title: ['', 'null'], width: 25, render: TypeRender.numIndex),
          DataGridColumn(title: ['Mô tả', 'MoTa'], width: 150, textStyle: ColumnTextStyle.blue()),
          DataGridColumn(title: ['Tiêu chuẩn', 'SoTieuChuan'], width: 80, columnType: ColumnType.num,showFooter: true),
          DataGridColumn(title: ['Thực tế', 'SoThucTe'], width: 80, columnType: ColumnType.num,showFooter: true),
        ],
      ).withPadding(all: 5),
    );
  }
}
