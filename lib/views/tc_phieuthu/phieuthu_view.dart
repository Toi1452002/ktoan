import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/application/application.dart';
import 'package:pm_ketoan/core/core.dart';
import 'package:pm_ketoan/widgets/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';
import 'package:string_validator/string_validator.dart';

import 'component/phieuthu_component.dart';
import 'component/phieuthu_table.dart';
import 'function/phieuthu_function.dart';

class PhieuThuView extends ConsumerStatefulWidget {
  final String? phieu;
  const PhieuThuView({super.key, this.phieu});

  static const name = "Phiếu thu";

  static void show(BuildContext context,{String? phieu}) {
    showCustomDialog(context, title: name.toUpperCase(), width: 500, height: 650, child: PhieuThuView(phieu: phieu,));
  }

  @override
  ConsumerState createState() => _PhieuThuViewState();
}

class _PhieuThuViewState extends ConsumerState<PhieuThuView> {
  List<Map<String, dynamic>> lstKThu = [];
  List<Map<String, dynamic>> lstKhach = [];
  List<Map<String, dynamic>> lstBTK = [];
  final fc = PhieuThuFunction();
  final cpn = PhieuThuComponent();

  @override
  void initState() {
    ref.read(phieuThuProvider.notifier).get(phieu: widget.phieu);
    onLoadCBB();
    super.initState();
  }

  void onLoadCBB() async {
    lstKThu = await fc.loadKThu();
    lstKhach = await fc.loadKhach();
    lstBTK = await fc.loadBTK();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(phieuThuProvider);
    return Scaffold(
      backgroundColor: context.theme.colorScheme.border,
      headers: [
        AppBar(
          padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
          leading: [
            WidgetIconButton(type: IconType.add, onPressed: () => fc.addPage(ref)),
            WidgetIconButton(
              type: IconType.delete,
              enabled: state != null && !state.Khoa,
              onPressed: () => fc.delete(state!.ID!, ref),
            ),
            WidgetIconButton(type: IconType.print, onPressed: () {}),
          ],
          trailing: [
            Text('Người tạo').medium,
            WidgetTextField(
              readOnly: true,
              controller: TextEditingController(text: state?.CreatedBy ?? ''),
            ).sized(width: 120),
            TextButton(
              enabled: state != null,
              child: Text(state != null && !state.Khoa ? 'Khóa' : 'Sửa'),
              onPressed: () => fc.updateKhoa(ref, !state!.Khoa),
            ),
          ],
        ),
      ],
      child: state == null
          ? SizedBox()
          : Column(
              children: [
                OutlinedContainer(
                  padding: EdgeInsets.all(5),
                  child: Column(
                    spacing: 10,
                    children: [
                      WidgetCustomRow(
                        columnWidths: {0: 110, 2: 90},
                        items: [
                          Text('Ngày thu').medium,
                          WidgetDateBox(
                            onChanged: (val) => fc.updateNgayThu(ref, val!),
                            enabled: !state.Khoa,
                            initialDate: toDate(state.Ngay!),
                          ),
                          Row(children: [Gap(20), Text('Số phiếu').medium]),
                          WidgetTextField(
                            enabled: !state.Khoa,
                            controller: TextEditingController(text: state.Phieu),
                            readOnly: true,
                          ),
                        ],
                      ),
                      WidgetCustomRow(
                        columnWidths: {0: 110, 2: 90},
                        items: [
                          Text('Kiểu thu').medium,
                          Combobox(
                            value: state.MaTC,
                            enabled: !state.Khoa,
                            items: lstKThu.map((e) => ComboboxItem(value: e['MaNV'], text: [e['MoTa']])).toList(),
                            onChanged: (val) => fc.updateKThu(ref, val),
                          ),
                          Row(children: [Gap(20), Text('Mã khách').medium]),
                          cpn.cbbMaKhach(
                            lstKhach,
                            value: state.MaKhach,
                            enabled: !state.Khoa,
                            onChanged: (val) {
                              final x = lstKhach.firstWhere((e) => e['MaKhach'] == val);
                              fc.updateMaKhach(ref, val, x['TenKH']??'', x['DiaChi']??'');
                            },
                            onDoubleTap: (){
                              fc.showKhachHang(state.MaKhach!, context);
                            }
                          ),
                        ],
                      ),
                      WidgetCustomRow(
                        columnWidths: {0: 110},
                        items: [
                          Text('Tên khách').medium,
                          WidgetTextField(
                            enabled: !state.Khoa,
                            controller: TextEditingController(text: state.TenKhach),
                            onChanged: (val) => fc.updateTenKhach(ref, val),
                          ),
                        ],
                      ),
                      WidgetCustomRow(
                        columnWidths: {0: 110},
                        items: [
                          Text('Địa chỉ').medium,
                          WidgetTextField(
                            enabled: !state.Khoa,
                            controller: TextEditingController(text: state.DiaChi),
                            onChanged: (val) => fc.updateDiaChi(ref, val),
                          ),
                        ],
                      ),

                      WidgetCustomRow(
                        columnWidths: {0: 110},
                        items: [
                          Text('Người nộp tiền').medium,
                          WidgetTextField(
                            enabled: !state.Khoa,
                            controller: TextEditingController(text: state.NguoiNop),
                            onChanged: (val) => fc.updateNguoiNop(ref, val),
                          ),
                        ],
                      ),
                      WidgetCustomRow(
                        columnWidths: {0: 110},
                        items: [
                          Text('Người thu tiền').medium,
                          WidgetTextField(
                            enabled: !state.Khoa,
                            controller: TextEditingController(text: state.NguoiThu),
                            onChanged: (val) => fc.updateNguoiThu(ref, val),
                          ),
                        ],
                      ),
                      WidgetCustomRow(
                        columnWidths: {0: 110, 2: 50, 4: 50},
                        items: [
                          Text('Số tiền').medium,
                          WidgetTextField(
                            enabled: !state.Khoa,
                            textAlign: TextAlign.end,
                            controller: TextEditingController(text: Helper.numFormat(state.SoTien)),
                            hasFocus: (b) {
                              if (!b) fc.updateSoTien(ref, state.SoTien.toString(), notifier: true);
                            },
                            onChanged: (val) => fc.updateSoTien(ref, val),
                          ),
                          Row(children: [Gap(20), Text('Nợ').medium]),
                          cpn.cbbBTK(
                            lstBTK,
                            onChanged: (val) => fc.updateTKNo(ref, val),
                            value: state.TKNo,
                            enabled: !state.Khoa,
                          ),
                          Row(children: [Gap(20), Text('Có').medium]),
                          cpn.cbbBTK(
                            lstBTK,
                            onChanged: (val) => fc.updateTKCo(ref, val),
                            value: state.TKCo,
                            enabled: !state.Khoa,
                          ),
                        ],
                      ),
                      WidgetCustomRow(
                        columnWidths: {0: 110},
                        items: [
                          Text('Lý do nộp').medium,
                          WidgetTextField(
                            enabled: !state.Khoa,
                            controller: TextEditingController(text: state.NoiDung),
                            onChanged: (val) => fc.updateNoiDung(ref, val),
                          ),
                        ],
                      ),
                      WidgetCustomRow(
                        columnWidths: {0: 110, 2: 90},
                        items: [
                          Text('Số chứng từ').medium,
                          WidgetTextField(
                            enabled: !state.Khoa,
                            controller: TextEditingController(text: state.SoCT),
                            onChanged: (val) => fc.updateSoCT(ref, val),
                          ),
                          Row(children: [Gap(20), Text('PTTT').medium]),
                          cpn.cbbPTTT(
                            onChanged: (val) => fc.updatePTTT(ref, val),
                            value: state.PTTT,
                            enabled: !state.Khoa,
                          ),
                        ],
                      ),
                      PhieuThuTable(maID: state.ID!, khoa: state.Khoa),
                    ],
                  ),
                ).withPadding(all: 5),
                GroupButtonNumberPage(
                  text: "${state.STT}/${state.Count}",
                  first: () => fc.onMovePage(state.STT!, 0, ref),
                  last: () => fc.onMovePage(state.STT!, 3, ref),
                  back: () => fc.onMovePage(state.STT!, 1, ref),
                  next: () => fc.onMovePage(state.STT!, 2, ref),
                ).withPadding(left: 5),
              ],
            ),
    );
  }
}
