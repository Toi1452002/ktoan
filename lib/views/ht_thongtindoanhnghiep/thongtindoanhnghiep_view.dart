import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/views/ht_thongtindoanhnghiep/thongtindoanhnghiep_function.dart';
import 'package:pm_ketoan/widgets/data_grid/data_grid.dart';
import 'package:pm_ketoan/widgets/dialog_windows/dialog_funtion.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:trina_grid/trina_grid.dart';

class ThongTinDoanhNghiepView extends ConsumerStatefulWidget {
  static const name = "Thông tin doanh nghiệp";

  static void show(BuildContext context) =>
      showCustomDialog(context, title: name.toUpperCase(), width: 1040, height: 700, child: ThongTinDoanhNghiepView());

  const ThongTinDoanhNghiepView({super.key});

  @override
  ConsumerState createState() => _ThongTinDoanhNghiepViewState();
}

class _ThongTinDoanhNghiepViewState extends ConsumerState<ThongTinDoanhNghiepView> {
  late TrinaGridStateManager stateManager;
  final fc = ThongTinDoanhNghiepFunction();

  @override
  void initState() {
    // TODO: implement initState
    loadData();
    super.initState();
  }

  void loadData() async {
    await Future.delayed(Duration(milliseconds: 100));
    await fc.getData(stateManager);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      child: DataGrid(
        onLoaded: (e) => stateManager = e.stateManager,
        onChange: (event) => fc.onChanged(event),
        columns: [
          DataGridColumn(title: ['', 'null'], width: 25, render: TypeRender.numIndex),
          DataGridColumn(title: ['Tiêu đề', 'TieuDe'], width: 300,textColor: TextColor.blue),
          DataGridColumn(title: ['Nội dung', 'NoiDung'], width: 690,isEdit: true),
        ],
      ).withPadding(all: 5),
    );
  }
}
