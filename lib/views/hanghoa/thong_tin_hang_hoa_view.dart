import 'package:pm_ketoan/core/core.dart';
import 'package:pm_ketoan/data/data.dart';
import 'package:pm_ketoan/views/hanghoa/component/thongtinhanghoa_component.dart';
import 'package:pm_ketoan/views/hanghoa/function/thongtinhanghoa_function.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/widgets.dart';

class ThongTinHangHoaView extends ConsumerStatefulWidget {
  final HangHoaModel? hangHoaModel;
  const ThongTinHangHoaView({super.key, this.hangHoaModel});

  static const name = "Thông tin hàng hóa";

  static void show(BuildContext context, {HangHoaModel? hangHoa}) {
    showCustomDialog(
      context,
      title: name.toUpperCase(),
      width: 600,
      height: 390,
      child: ThongTinHangHoaView(hangHoaModel: hangHoa,),
      onClose: () {},
    );
  }

  @override
  ThongTinHangHoaViewState createState() => ThongTinHangHoaViewState();
}

class ThongTinHangHoaViewState extends ConsumerState<ThongTinHangHoaView> {
  final ThongTinHangHoaFunction fc = ThongTinHangHoaFunction();
  final ThongTinHangHoaComponent component = ThongTinHangHoaComponent();

  final txtMaHang = TextEditingController();
  final txtTenHang = TextEditingController();
  final txtGiaMua = TextEditingController();
  final txtGiaBan = TextEditingController();
  final txtGhiChu = TextEditingController();
  int? loaiHang;
  int? donViTinh;
  int? nhomHang;
  String? nhaCung;
  String khoNgamDinh = '156';

  bool tinhToanTonKho = true;
  bool matHangTheoDoi = true;

  FocusNode focusGiaMua = FocusNode();
  FocusNode focusGiaBan = FocusNode();

  List<Map<String, dynamic>> lstLoaiHang = [];
  List<Map<String, dynamic>> lstKho = [];
  List<Map<String, dynamic>> lstNhaCung = [];
  List<Map<String, dynamic>> lstDonViTinh = [];
  List<Map<String, dynamic>> lstNhomHang = [];

  @override
  void initState() {
    onGetLoaiHang();
    onGetKho();
    onGetNhaCung();
    onGetDonViTinh();
    onGetNhomHang();

    if(widget.hangHoaModel!=null){
      final x = widget.hangHoaModel;
      txtMaHang.text = x!.MaHH;
      txtTenHang.text = x.TenHH;
      txtGiaMua.text = Helper.numFormat(x.GiaMua)!;
      txtGiaBan.text = Helper.numFormat(x.GiaBan)!;
      txtGhiChu.text = x.GhiChu!;
      loaiHang = x.LoaiHHID;
      donViTinh = x.DVTID;
      nhomHang = x.NhomID;
      nhaCung = x.MaNC;
      khoNgamDinh = x.TKkho;
    }
    // TODO: implement initState
    super.initState();
  }

  void onGetLoaiHang() async {
    lstLoaiHang = await fc.getLoaiHang();
    setState(() {});
  }

  void onGetKho() async {
    lstKho = await fc.getKho();
    setState(() {});
  }

  void onGetNhaCung() async {
    lstNhaCung = await fc.getNhaCung();
    setState(() {});
  }

  void onGetDonViTinh() async {
    lstNhomHang = await fc.getNhomHang();
    setState(() {});
  }

  void onGetNhomHang() async {
    lstDonViTinh = await fc.getDonViTinh();
    setState(() {});
  }

  void onSubmit({int? id}) async {
    fc.submitHangHoa(
      ref,
      context,
      ma: txtMaHang.text,
      ten: txtTenHang.text,
      kho: khoNgamDinh,
      giaMua: txtGiaMua.text,
      giaBan: txtGiaBan.text,
      td: matHangTheoDoi,
      tt: tinhToanTonKho,
      donViTinh: donViTinh,
      ghiChu: txtGhiChu.text,
      loaiHang: loaiHang,
      nhaCung: nhaCung,
      nhomHang: nhomHang,
      id: widget.hangHoaModel?.ID,
      isUpdate: widget.hangHoaModel !=null
    );
  }

  @override
  Widget build(BuildContext context) {
    return component.view(context, [
      OutlinedContainer(
        padding: EdgeInsets.all(10),
        child: Column(
          spacing: 10,
          children: [
            WidgetTableRow(
              columnWidths: {0: FixedColumnWidth(80), 1: FixedColumnWidth(180), 3: FixedColumnWidth(180)},
              items: [
                Text('Mã hàng').medium,
                WidgetTextField(controller: txtMaHang, isUpperCase: true),
                Row(children: [Gap(10), Text('Loại hàng').medium]),

                Combobox(
                  value: loaiHang,
                  items: lstLoaiHang.map((e) => ComboboxItem(value: e['ID'], text: [e['LoaiHang']])).toList(),
                  onChanged: (val) {
                    setState(() {
                      loaiHang = val;
                    });
                  },
                ),
              ],
            ),

            WidgetTableRow(
              columnWidths: {0: FixedColumnWidth(80)},
              items: [
                Text('Tên hàng').medium,
                WidgetTextField(controller: txtTenHang),
              ],
            ),

            WidgetTableRow(
              columnWidths: {
                0: FixedColumnWidth(80),
                1: FixedColumnWidth(150),
                2: FixedColumnWidth(30),
                4: FixedColumnWidth(150),
                5: FixedColumnWidth(30),
              },
              items: [
                Text('Đơn vị tính').medium,
                Combobox(
                  value: donViTinh,
                  onChanged: (val) {
                    setState(() {
                      donViTinh = val;
                    });
                  },
                  items: lstDonViTinh.map((e) => ComboboxItem(value: e['ID'], text: [e['DVT']])).toList(),
                ),
                WidgetIconButton(type: IconType.play,onPressed: ()=>fc.showDonViTinh(context),),

                Row(children: [Gap(10), Text('Nhóm hàng').medium]),
                Combobox(
                  value: nhomHang,
                  onChanged: (val) {
                    setState(() {
                      nhomHang = val;
                    });
                  },
                  items: lstNhomHang.map((e) => ComboboxItem(value: e['ID'], text: [e['NhomHang']])).toList(),
                ),
                WidgetIconButton(type: IconType.play),
              ],
            ),

            WidgetTableRow(
              columnWidths: {0: FixedColumnWidth(80), 1: FixedColumnWidth(150), 3: FixedColumnWidth(180)},
              items: [
                Text('Nhà cung').medium,
                component.cbbNhaCung(
                  nhaCung,
                  lstNhaCung,
                  onChanged: (val) {
                    setState(() {
                      nhaCung = val;
                    });
                  },
                ),

                Row(children: [Gap(40), Text('Kho ngầm định').medium]),
                component.cbbKho(
                  khoNgamDinh,
                  lstKho,
                  onChanged: (val) {
                    setState(() {
                      khoNgamDinh = val;
                    });
                  },
                ),
              ],
            ),

            WidgetTableRow(
              columnWidths: {0: FixedColumnWidth(80), 1: FixedColumnWidth(150), 3: FixedColumnWidth(180)},
              items: [
                Text('Giá mua').medium,

                Focus(
                  onFocusChange: (b) => fc.onFocusChanged(b, txtGiaMua, focusGiaMua),
                  child: WidgetTextField(
                    focusNode: focusGiaMua,
                    controller: txtGiaMua,
                    isNumber: true,
                    textAlign: TextAlign.end,
                  ),
                ),
                Row(children: [Gap(40), Text('Giá bán').medium]),

                Focus(
                  onFocusChange: (b) => fc.onFocusChanged(b, txtGiaBan, focusGiaBan),
                  child: WidgetTextField(
                    focusNode: focusGiaBan,
                    controller: txtGiaBan,
                    isNumber: true,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),

            WidgetTableRow(
              columnWidths: {0: FixedColumnWidth(80)},
              items: [
                Text('Ghi chú').medium,
                WidgetTextField(controller: txtGhiChu),
              ],
            ),

            Gap(1),
            component.rCheck(
              tinhToanTonKho,
              matHangTheoDoi,
              c1: (val) {
                setState(() {
                  tinhToanTonKho = val.index == 0;
                });
              },
              c2: (val) {
                setState(() {
                  matHangTheoDoi = val.index == 0;
                });
              },
            ),
          ],
        ),
      ),
      Gap(10),
      PrimaryButton(child: Text(widget.hangHoaModel==null? 'Thêm mới' : 'Cập nhật'), onPressed: () {
        onSubmit();
      }),
    ]);
  }
}
