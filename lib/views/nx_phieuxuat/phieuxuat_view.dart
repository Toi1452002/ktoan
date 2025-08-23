import 'package:pm_ketoan/application/phieuxuat/phieuxuat_provider.dart';
import 'package:pm_ketoan/widgets/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';
import 'package:string_validator/string_validator.dart';

import '../../core/core.dart';
import 'component/phieuxuat_component.dart';
import 'component/phieuxuat_table.dart';
import 'function/phieuxuat_function.dart';

class PhieuXuatView extends ConsumerStatefulWidget {
  final int? stt;

  const PhieuXuatView({super.key, this.stt});

  static const name = "Bán hàng";
  static const title = "Xuất bán hàng hóa";

  static void show(BuildContext context, {int? stt}) => showCustomDialog(
    context,
    title: title.toUpperCase(),
    width: 1150,
    height: 700,
    child: PhieuXuatView(stt: stt),
    onClose: () {},
  );

  @override
  PhieuXuatViewState createState() => PhieuXuatViewState();
}

class PhieuXuatViewState extends ConsumerState<PhieuXuatView> {
  List<Map<String, dynamic>> lstKieuXuat = [];
  List<Map<String, dynamic>> lstKH = [];
  List<Map<String, dynamic>> lstBTK = [];
  final cpn = PhieuXuatComponent();
  final fc = PhieuXuatFunction();

  @override
  void initState() {
    // TODO: implement initState
    ref.read(phieuXuatProvider.notifier).getPhieuXuat(stt: widget.stt);

    loadCBB();
    super.initState();
  }

  void loadCBB() async {
    lstKieuXuat = await fc.getKXuat();
    lstKH = await fc.getKH();
    lstBTK = await fc.getBTK0();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(phieuXuatProvider);
    return Scaffold(
      backgroundColor: context.theme.colorScheme.border,
      headers: [
        AppBar(
          padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
          leading: [
            WidgetIconButton(type: IconType.add, onPressed: () => fc.onAdd(ref)),
            WidgetIconButton(
              type: IconType.delete,
              onPressed: () => fc.onDeletePhieu(state!.ID!, ref),
              enabled: state != null && !state.Khoa!,
            ),
            WidgetIconButton(type: IconType.print, onPressed: () {}),
          ],
          trailing: [
            Text('Người tạo').medium,
            WidgetTextField(
              readOnly: true,
              controller: TextEditingController(text: state?.CreatedBy ?? ''),
            ).sized(width: 150),
            TextButton(
              enabled: state != null,
              child: Text(state != null && !state.Khoa! ? 'Khóa' : 'Sửa'),
              onPressed: () => fc.onChangedKhoa(!state!.Khoa!, ref),
            ),
          ],
        ),
      ],
      child: state == null
          ? SizedBox()
          : Column(
              children: [
                OutlinedContainer(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    spacing: 10,
                    children: [
                      WidgetCustomRow(
                        columnWidths: cpn.wR1(),
                        items: [
                          Text('Ngày xuất').medium,
                          WidgetDateBox(
                            enabled: !state.Khoa!,
                            onChanged: (val) => fc.onChangedNgay(val!, ref),
                            initialDate: toDate(state.Ngay),
                          ),
                          Row(children: [Gap(30), Text('Số phiếu').medium]),
                          WidgetTextField(
                            readOnly: true,
                            enabled: !state.Khoa!,
                            controller: TextEditingController(text: state.Phieu),
                          ),
                          Row(children: [Gap(30), Text('Kiểu xuất').medium]),
                          cpn.kieuXuat(
                            lstKieuXuat,
                            enabled: !state.Khoa!,
                            value: state.MaNX,
                            onChanged: (val) => fc.onChangedKXuat(val, ref),
                          ),
                          Row(children: [Gap(30), Text('Ký hiệu hóa đơn').medium]),
                          WidgetTextField(
                            controller: TextEditingController(text: state.KyHieu),
                            enabled: !state.Khoa!,
                            onChanged: (val) => fc.onChangedKyHieu(val, ref),
                          ),
                          Row(
                            children: [
                              Gap(10),
                              cpn.pttt(
                                onChanged: (val) => fc.onChangedPTTT(val, ref),
                                value: state.PTTT,
                                enabled: !state.Khoa!,
                              ),
                            ],
                          ),
                        ],
                      ),
                      WidgetCustomRow(
                        columnWidths: cpn.wR2(),
                        items: [
                          Text('Mã khách').medium,
                          cpn.maKhach(
                            lstKH,
                            context,
                            ref,
                            value:state.MaKhach,
                            enabled: !state.Khoa!,
                            onChanged: (val) => fc.onChangedMaKhach(val, ref),
                          ),
                          Row(
                            children: [
                              Gap(10),
                              WidgetTextField(
                                readOnly: true,
                                enabled: !state.Khoa!,
                                controller: TextEditingController(
                                  text: lstKH.firstWhere(
                                    (e) => e['MaKhach'] == state.MaKhach,
                                    orElse: () => {'TenKH': ''},
                                  )['TenKH'],
                                ),
                              ).expanded(),
                            ],
                          ),
                          Row(children: [Gap(30), Text('Số hóa đơn').medium]),
                          WidgetTextField(
                            controller: TextEditingController(text: state.SoHD),
                            enabled: !state.Khoa!,
                            onChanged: (val) => fc.onChangedSoCT(val, ref),
                          ),
                          SizedBox(),
                        ],
                      ),
                      WidgetCustomRow(
                        columnWidths: cpn.wR3(),
                        items: [
                          Text('Diễn giải').medium,
                          WidgetTextField(
                            controller: TextEditingController(text: state.DienGiai),
                            enabled: !state.Khoa!,
                            onChanged: (val) => fc.onChangedDienGiai(val, ref),
                          ),
                          Row(children: [Gap(30), Text('Ngày hóa đơn').medium]),
                          WidgetDateBox(
                            onChanged: (val) => fc.onChangedNgayCT(val!, ref),
                            initialDate: toDate(state.NgayCT),
                            enabled: !state.Khoa!,
                          ),
                          SizedBox(),
                        ],
                      ),
                      PhieuXuatTable(khoa: state.Khoa!, maID: state.ID!),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 10,
                        children: [
                          WidgetCustomRow(
                            columnWidths: cpn.wR4(),
                            items: [
                              Text('TK Nợ/Có').medium,
                              cpn.tKhoan(
                                lstBTK,
                                onChanged: (val) => fc.onChangedTKNo(val, ref),
                                value: state.TKNo,
                                enabled: !state.Khoa!,
                              ),
                              cpn.tKhoan(
                                lstBTK,
                                onChanged: (val) => fc.onChangedTKCo(val, ref),
                                value: state.TKCo,
                                enabled: !state.Khoa!,
                              ),
                              Row(
                                children: [
                                  Gap(20),
                                  Checkbox(
                                    enabled: !state.Khoa!,
                                    state: state.KChiuThue! ? CheckboxState.checked : CheckboxState.unchecked,
                                    onChanged: (val) => fc.onChangedKChiuThue(val.index == 0, ref),
                                    trailing: Text('Không chịu thuế'),
                                  ),
                                ],
                              ),
                              SizedBox(),
                              Row(children: [Gap(50), Text('Cộng').medium]),
                              WidgetTextField(
                                isNumber: true,
                                textAlign: TextAlign.end,
                                controller: TextEditingController(text: Helper.numFormat(state.CongTien)),
                                enabled: !state.Khoa!,
                                readOnly: true,
                              ),
                            ],
                          ),
                          WidgetCustomRow(
                            columnWidths: cpn.wR5(),
                            items: [
                              Text('TK VAT').medium,
                              cpn.tKhoan(
                                lstBTK,
                                onChanged: (val) => fc.onChangedTKVatNo(val, ref),
                                value: state.TKVatNo,
                                enabled: !state.Khoa!,
                              ),
                              cpn.tKhoan(
                                lstBTK,
                                onChanged: (val) => fc.onChangedTKVatCo(val, ref),
                                value: state.TKVatCo,
                                enabled: !state.Khoa!,
                              ),
                              Row(children: [Gap(30), !state.KChiuThue! ? Text('Thuế suất').medium : SizedBox()]),
                              !state.KChiuThue!
                                  ? WidgetTextField(
                                      isDouble: true,
                                      textAlign: TextAlign.end,
                                      controller: TextEditingController(text: state.ThueSuat.toString()),
                                      enabled: !state.Khoa!,
                                      onChanged: (val) => fc.onChangedThueSuat(val, ref),
                                      hasFocus: (b) {
                                        if (!b) {
                                          double val = (state.CongTien! * state.ThueSuat) / 100;
                                          fc.onChangedTienThue(val, ref, notifier: true);
                                        }
                                      },
                                    )
                                  : SizedBox(),
                              Row(children: [Gap(30), Text('Tiền thuế').medium]),
                              WidgetTextField(
                                hasFocus: (b) {
                                  if (!b) fc.onChangedTienThue(state.TienThue!, ref, notifier: true);
                                },
                                textAlign: TextAlign.end,
                                controller: TextEditingController(text: Helper.numFormat(state.TienThue)),
                                enabled: !state.Khoa! && !state.KChiuThue!,
                                onChanged: (val) => fc.onChangedTienThue(toDouble(val), ref),
                              ),
                            ],
                          ),
                          WidgetCustomRow(
                            columnWidths: cpn.wR6(),
                            items: [
                              SizedBox(),
                              SizedBox(),
                              SizedBox(),
                              SizedBox(),
                              SizedBox(),
                              Text('Tổng cộng').medium,
                              WidgetTextField(
                                readOnly: true,
                                textAlign: TextAlign.end,
                                controller: TextEditingController(
                                  text: Helper.numFormat(state.CongTien! + state.TienThue!),
                                ),
                                enabled: !state.Khoa!,
                              ),
                            ],
                          ),
                        ],
                      ).sized(width: 740),
                    ],
                  ),
                ).withPadding(all: 10),
                GroupButtonNumberPage(
                  text: '${state.STT}/${state.countRow}',
                  first: () => fc.onMovePage(state.STT!, 0, ref),
                  last: () => fc.onMovePage(state.STT!, 3, ref),
                  back: () => fc.onMovePage(state.STT!, 1, ref),
                  next: () => fc.onMovePage(state.STT!, 2, ref),
                ).withPadding(left: 10),
              ],
            ),
    );
  }
}
