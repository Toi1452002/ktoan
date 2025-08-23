import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/application/application.dart';
import 'package:pm_ketoan/data/data.dart';
import 'package:pm_ketoan/views/ht_phanquyennguoidung/phanquyennguoidung_function.dart';
import 'package:pm_ketoan/widgets/combobox.dart';
import 'package:pm_ketoan/widgets/dialog_windows/dialog_funtion.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';

class PhanQuyenNguoiDungView extends ConsumerStatefulWidget {
  static const name = "Phân quyền người dùng";

  static void show(BuildContext context) {
    showCustomDialog(context, title: name.toUpperCase(), width: 600, height: 600, child: PhanQuyenNguoiDungView());
  }

  const PhanQuyenNguoiDungView({super.key});

  @override
  ConsumerState createState() => _PhanQuyenNguoiDungViewState();
}

class _PhanQuyenNguoiDungViewState extends ConsumerState<PhanQuyenNguoiDungView> {
  String? selectUser;
  MapEntry? selectMenu;
  List<UserModel> lstUser = [];

  final fc = PhanQuyenNguoiDungFunction();

  @override
  void initState() {
    // TODO: implement initState
    loadData();
    super.initState();
  }

  void loadData() async {
    lstUser = await fc.getUser();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final menu = ref.watch(phanQuyenMenuProvider);
    return Scaffold(
      backgroundColor: context.theme.colorScheme.border,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OutlinedContainer(
            padding: EdgeInsets.all(10),
            child: Column(
              spacing: 10,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Combobox(
                  menuWidth: 300,
                  value: selectUser,
                  columnWidth: [100, 200],
                  onChanged: (val) {
                    setState(() {
                      selectUser = val;
                    });
                    if (selectMenu != null && selectUser != null) {
                      fc.getChoPhep(val!, selectMenu?.value, selectMenu?.key, ref);
                    }
                  },
                  items: lstUser.map((e) => ComboboxItem(value: e.Username, text: [e.Username, e.HoTen])).toList(),
                ).sized(width: 180),
                Visibility(
                  visible: selectUser != null,
                  child: Checkbox(
                    state: ref.watch(choPhepProvider) ? CheckboxState.checked : CheckboxState.unchecked,
                    onChanged: (val) {
                      if (selectUser != null && selectMenu != null) {
                        fc.updateChoPhep(selectUser!, selectMenu?.value, selectMenu?.key, val.index == 0, ref);
                      }
                    },
                    trailing: Text('Được phép sử dụng'),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: OutlinedContainer(
              child: TreeView(
                nodes: menu,
                onSelectionChanged: TreeView.defaultSelectionHandler(menu, (value) {
                  ref.read(phanQuyenMenuProvider.notifier).state = value;
                }),
                builder: (context, node) {
                  return TreeItemView(
                    onExpand: TreeView.defaultItemExpandHandler(menu, node, (value) {
                      ref.read(phanQuyenMenuProvider.notifier).state = value;
                      // treeItems = value;
                    }),
                    onPressed: () {
                      final m = fc.getMa(node.data);
                      if (m != null && selectUser != null) {
                        fc.getChoPhep(selectUser!, m.value, m.key, ref);
                      }
                      setState(() {
                        selectMenu = m;
                      });
                    },
                    child: Text(node.data),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
