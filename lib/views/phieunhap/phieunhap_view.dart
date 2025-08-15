import 'package:pm_ketoan/application/application.dart';
import 'package:pm_ketoan/widgets/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';
import 'package:string_validator/string_validator.dart';

import '../../core/core.dart';
import 'component/phieunhap_component.dart';
import 'component/phieunhap_table.dart';
import 'function/phieunhap_function.dart';

class PhieuNhapView extends ConsumerStatefulWidget {
  final int? stt;
  const PhieuNhapView({super.key,this.stt});

  static const name = "Mua hàng";
  static const title = "Nhập mua hàng hóa";

  static void show(BuildContext context, {int? stt}) => showCustomDialog(
    context,
    title: title.toUpperCase(),
    width: 1150,
    height: 700,
    child: PhieuNhapView(stt: stt,),
    onClose: () {},
  );

  @override
  PhieuNhapViewState createState() => PhieuNhapViewState();
}

class PhieuNhapViewState extends ConsumerState<PhieuNhapView> {
  final cpn = PhieuNhapComponent();
  final fc = PhieuNhapFunction();

  List<Map<String, dynamic>> lstKieuNhap = [];
  List<Map<String, dynamic>> lstNC = [];
  List<Map<String, dynamic>> lstBTK = [];

  @override
  void initState() {
    loadCBB();
    ref.read(phieuNhapProvider.notifier).getPhieuNhap(stt: widget.stt);
    super.initState();
  }

  void loadCBB() async {
    lstKieuNhap = await fc.getKNhap();
    lstNC = await fc.getNCung();
    lstBTK = await fc.getBTK0();
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    final state = ref.watch(phieuNhapProvider);
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
                      WidgetTableRow(
                        columnWidths: cpn.wR1(),
                        items: [
                          Text('Ngày xuất').medium,
                          cpn.ngayXuat(
                            onChanged: (val) => fc.onChangeNgay(val!, ref),
                            initialDate: toDate(state.Ngay),
                            enabled: !state.Khoa!,
                          ),
                          Row(children: [Gap(30), Text('Số phiếu').medium]),
                          WidgetTextField(
                            readOnly: true,
                            controller: TextEditingController(text: state.Phieu),
                            enabled: !state.Khoa!,
                          ),
                          Row(children: [Gap(30), Text('Kiểu nhập').medium]),
                          cpn.kieuNhap(
                            lstKieuNhap,
                            onChanged: (val) => fc.onChangedKNhap(val, ref),
                            value: state.MaNX,
                            enabled: !state.Khoa!,
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
                      WidgetTableRow(
                        columnWidths: cpn.wR2(),
                        items: [
                          Text('Mã khách').medium,
                          cpn.maKhach(
                            lstNC,
                            context,
                            ref,
                            onChanged: (val) => fc.onChangedMaKhach(val, ref),
                            value: state.MaKhach,
                            enabled: !state.Khoa!,
                          ),
                          Row(
                            children: [
                              Gap(10),
                              WidgetTextField(
                                readOnly: true,
                                enabled: !state.Khoa!,
                                controller: TextEditingController(
                                  text: lstNC.firstWhere(
                                    (e) => e['MaKhach'] == state.MaKhach,
                                    orElse: () => {'TenKH': ''},
                                  )['TenKH'],
                                ),
                              ).expanded(),
                            ],
                          ),
                          Row(children: [Gap(30), Text('Số hóa đơn').medium]),
                          WidgetTextField(
                            controller: TextEditingController(text: state.SoCT),
                            enabled: !state.Khoa!,
                            onChanged: (val) => fc.onChangedSoCT(val, ref),
                          ),
                          SizedBox(),
                        ],
                      ),
                      WidgetTableRow(
                        columnWidths: cpn.wR3(),
                        items: [
                          Text('Diễn giải').medium,
                          WidgetTextField(
                            controller: TextEditingController(text: state.DienGiai),
                            enabled: !state.Khoa!,
                            onChanged: (val) => fc.onChangedDienGiai(val, ref),
                          ),
                          Row(children: [Gap(30), Text('Ngày hóa đơn').medium]),
                          DateTextbox(
                            onChanged: (val) => fc.onChangedNgayCT(val!, ref),
                            showClear: false,
                            initialDate: toDate(state.NgayCT),
                            enabled: !state.Khoa!,
                          ),
                          SizedBox(),
                        ],
                      ),
                      PhieuNhapTable(maID: state.ID!, khoa: state.Khoa!),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 10,
                        children: [
                          WidgetTableRow(
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

                              SizedBox(),
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
                          WidgetTableRow(
                            columnWidths: cpn.wR4(),
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
                              Row(children: [Gap(30), Text('Thuế suất').medium]),
                              WidgetTextField(
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
                              ),
                              Row(children: [Gap(30), Text('Tiền thuế').medium]),
                              WidgetTextField(
                                hasFocus: (b) {
                                  if (!b) fc.onChangedTienThue(state.TienThue!, ref, notifier: true);
                                },
                                textAlign: TextAlign.end,
                                controller: TextEditingController(text: Helper.numFormat(state.TienThue)),
                                enabled: !state.Khoa!,
                                onChanged: (val) => fc.onChangedTienThue(toDouble(val), ref),
                              ),
                            ],
                          ),
                          WidgetTableRow(
                            columnWidths: cpn.wR5(),
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
