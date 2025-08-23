import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/views/ht_tuychon/tuychon_function.dart';
import 'package:pm_ketoan/widgets/dialog_windows/dialog_funtion.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';
import 'package:string_validator/string_validator.dart';

class TuyChonView extends ConsumerStatefulWidget {
  static const name = "Tùy chọn";

  static void show(BuildContext context) =>
      showCustomDialog(context, title: name.toUpperCase(), width: 500, height: 400, child: TuyChonView());

  const TuyChonView({super.key});

  @override
  ConsumerState createState() => _TuyChonViewState();
}

class _TuyChonViewState extends ConsumerState<TuyChonView> {
  int index = 0;
  int selectGiaVon = 1;
  List<Map<String, dynamic>> lstQL = [];
  Map<String, dynamic> mGiaVon = {};
  Map<String, int> qlState = {};
  final fc = TuyChonFunction();

  @override
  void initState() {
    // TODO: implement initState
    loadData();
    super.initState();
  }

  void loadData() async {
    lstQL = await fc.getQL();
    mGiaVon = await fc.getGV();
    selectGiaVon = mGiaVon['GiaTri'];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.border,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Tabs(
            index: index,
            onChanged: (val) {
              setState(() {
                index = val;
              });
            },
            children: [
              TabItem(child: Text('Quản lý')),
              TabItem(child: Text('Giá vốn')),
            ],
          ),
          IndexedStack(
            index: index,
            children: [
              OutlinedContainer(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                child: Column(
                  spacing: 20,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(lstQL.length, (index) {
                    final x = lstQL[index];
                    CheckboxState state = CheckboxState.unchecked;
                    if(!qlState.containsKey(x['Nhom'])){
                      qlState[x['Nhom']] = x['GiaTri'];
                    }
                    state = qlState[x['Nhom']] == 1 ? CheckboxState.checked : CheckboxState.unchecked;
                    return Checkbox(
                      state: state,
                      onChanged: (val) {
                        setState(() {
                          qlState[x['Nhom']] = val.index == 0 ? 1 : 0;
                        });
                      },
                      trailing: Text(x['MoTa']),
                    );
                  }),
                ),
              ),
              OutlinedContainer(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                child: RadioGroup(
                  value: selectGiaVon,
                  onChanged: (val) {
                    setState(() {
                      selectGiaVon = val;
                    });
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    children: [
                      RadioItem(value: 0, trailing: Text('Đơn giá cuối').medium),
                      RadioItem(value: 1, trailing: Text('Bình quân gia quyền').medium),
                      RadioItem(value: 2, trailing: Text('Công thức giá thành').medium),
                    ],
                  ),
                ),
              ),
            ],
          ).sized(height: 270),
          Gap(10),
          PrimaryButton(
            child: Text('Cập nhật'),
            onPressed: () {
              qlState.addAll({'gvPPT': selectGiaVon});
              fc.updateTuyChon(qlState, context);
            },
          ).withAlign(Alignment.center),
        ],
      ).withPadding(all: 10),
    );
  }
}
