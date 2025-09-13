import 'package:pm_ketoan/data/data.dart';
import 'package:pm_ketoan/widgets/combobox.dart';
import 'package:pm_ketoan/widgets/dialog_windows/dialog_funtion.dart';
import 'package:pm_ketoan/widgets/widget_custom_row.dart';
import 'package:pm_ketoan/widgets/widget_textfield.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';

import 'function/thongtinkhachhang_function.dart';

class ThongTinKHView extends ConsumerStatefulWidget {
  final KhachHangModel? khachHangModel;
  final bool isUpdate;
  const ThongTinKHView({super.key, this.khachHangModel, this.isUpdate = true});

  static const name = "Thông tin khách hàng";

  static void show(BuildContext context, {KhachHangModel? khach, bool isUpdate = true}) {
    showCustomDialog(
      context,
      title: name.toUpperCase(),
      width: 700,
      height: 455,
      child: ThongTinKHView(khachHangModel: khach,isUpdate: isUpdate,),
    );
  }

  @override
  ConsumerState createState() => _ThongTinKHViewState();
}

class _ThongTinKHViewState extends ConsumerState<ThongTinKHView> {
  final maKH = TextEditingController();
  final tenKH = TextEditingController();
  final diaChi = TextEditingController();
  final dienThoai = TextEditingController();
  final diDong = TextEditingController();
  final fax = TextEditingController();
  final email = TextEditingController();
  final mst = TextEditingController();
  final stk = TextEditingController();
  final nganHang = TextEditingController();
  final ghiChu = TextEditingController();

  String loaiKhach = 'KH';
  bool theoDoi = true;
  final fc = ThongTinKhachHangFunction();

  @override
  void initState() {
    if(widget.khachHangModel!=null){
      final x = widget.khachHangModel;
      maKH.text = x!.MaKhach;
      tenKH.text = x.TenKH;
      diaChi.text = x.DiaChi;
      dienThoai.text = x.DienThoai;
      diDong.text = x.DiDong;
      fax.text = x.Fax;
      email.text = x.Email;
      mst.text = x.MST;
      stk.text = x.SoTK;
      nganHang.text = x.NganHang;
      ghiChu.text = x.GhiChu;
      theoDoi = x.TheoDoi;
      loaiKhach = x.LoaiKH!;
    }
    super.initState();
  }

  void onSubmit() {
    fc.onSubmit(
      ref,
      context,
      KhachHangModel(
        MaKhach: maKH.text,
        TenKH: tenKH.text,
        DiaChi: diaChi.text,
        DienThoai: dienThoai.text,
        DiDong: diDong.text,
        Fax: fax.text,
        Email: email.text,
        MST: mst.text,
        SoTK: stk.text,
        NganHang: nganHang.text,
        GhiChu: ghiChu.text,
        TheoDoi: theoDoi,
        LoaiKH: loaiKhach,

      ),
      isUpdate: widget.khachHangModel != null,
      maUpdate: widget.khachHangModel?.MaKhach ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.border,
      child: Column(
        children: [
          OutlinedContainer(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WidgetCustomRow(
                  columnWidths: {0: 120, 2: 120},
                  items: [
                    Text('Mã khách hàng').medium,
                    WidgetTextField(controller: maKH,enabled: widget.isUpdate,),

                    Row(children: [Gap(20), Text('Loại khách').medium]),
                    Combobox(
                      value: loaiKhach,
                      onChanged: (val) => setState(() {
                        loaiKhach = val;
                      }),
                      items: [
                        ComboboxItem(value: 'KH', text: ['Khách hàng']),
                        ComboboxItem(value: 'NC', text: ['Nhà cung']),
                        ComboboxItem(value: 'CH', text: ['Cả hai']),
                      ],
                    ),
                  ],
                ),

                WidgetCustomRow(
                  columnWidths: {0: 120, 2: 120},
                  items: [
                    Text('Tên khách hàng').medium,
                    WidgetTextField(controller: tenKH),
                  ],
                ),
                WidgetCustomRow(
                  columnWidths: {0: 120},
                  items: [
                    Text('Địa chỉ').medium,
                    WidgetTextField(controller: diaChi),
                  ],
                ),
                WidgetCustomRow(
                  columnWidths: {0: 120, 2: 120},
                  items: [
                    Text('Điện thoại').medium,
                    WidgetTextField(controller: dienThoai),
                    Row(children: [Gap(20), Text('Di động').medium]),
                    WidgetTextField(controller: diDong),
                  ],
                ),
                WidgetCustomRow(
                  columnWidths: {0: 120, 2: 120},
                  items: [
                    Text('Fax').medium,
                    WidgetTextField(controller: fax),
                    Row(children: [Gap(20), Text('Email').medium]),
                    WidgetTextField(controller: email),
                  ],
                ),
                WidgetCustomRow(
                  columnWidths: {0: 120, 2: 120},
                  items: [
                    Text('Mã số thuế').medium,
                    WidgetTextField(controller: mst),
                    Row(children: [Gap(20), Text('Số tài khoản').medium]),
                    WidgetTextField(controller: stk),
                  ],
                ),
                WidgetCustomRow(
                  columnWidths: {0: 120},
                  items: [
                    Text('Ngân hàng').medium,
                    WidgetTextField(controller: nganHang),
                  ],
                ),
                WidgetCustomRow(
                  columnWidths: {0: 120},
                  items: [
                    Text('Ghi chú').medium,
                    WidgetTextField(controller: ghiChu),
                  ],
                ),

                Checkbox(
                  state: theoDoi ? CheckboxState.checked : CheckboxState.unchecked,
                  onChanged: (val) => setState(() {
                    theoDoi = val.index == 0;
                  }),
                  trailing: Text('Khách đang theo dõi'),
                ).withPadding(left: 110),
              ],
            ).gap(10),
          ),
          Gap(10),
          Button.primary(onPressed: onSubmit, child: Text(widget.khachHangModel == null ? 'Thêm mới' : 'Cập nhật')),
        ],
      ).withPadding(all: 10),
    );
  }
}
