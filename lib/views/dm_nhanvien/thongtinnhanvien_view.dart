import 'package:pm_ketoan/application/application.dart';
import 'package:pm_ketoan/core/core.dart';
import 'package:pm_ketoan/data/data.dart';
import 'package:pm_ketoan/views/dm_nhanvien/nhanvien_function.dart';
import 'package:pm_ketoan/widgets/data_grid/data_grid.dart';
import 'package:pm_ketoan/widgets/dialog_windows/dialog_funtion.dart';
import 'package:pm_ketoan/widgets/widget_datebox.dart';
import 'package:pm_ketoan/widgets/widget_custom_row.dart';
import 'package:pm_ketoan/widgets/widget_textfield.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';
import 'package:string_validator/string_validator.dart';
import 'package:trina_grid/trina_grid.dart';

class ThongTinNhanVienView extends ConsumerStatefulWidget {
  static const name = "Thông tin nhân viên";

  static void show(BuildContext context, {NhanVienModel? nv, bool udMa = true}) => showCustomDialog(
    context,
    title: name.toUpperCase(),
    width: 700,
    height: 530,
    child: ThongTinNhanVienView(nhanVien: nv, udMa: udMa),
  );

  final NhanVienModel? nhanVien;
  final bool udMa;

  const ThongTinNhanVienView({super.key, this.nhanVien, this.udMa = true});

  @override
  ConsumerState createState() => _ThongTinNhanVienViewState();
}

class _ThongTinNhanVienViewState extends ConsumerState<ThongTinNhanVienView> {
  final fc = NhanVienFunction();
  late TrinaGridStateManager _stateManager;

  final _txtMaNV = TextEditingController();
  final _txtHoTen = TextEditingController();
  final _txtDienThoai = TextEditingController();
  final _txtCCCD = TextEditingController();
  final _txtMST = TextEditingController();
  final _txtDiaChi = TextEditingController();
  final _txtGhiChu = TextEditingController();

  final _txtChucDanh = TextEditingController();
  final _txtTrinhDo = TextEditingController();
  final _txtChuyenMon = TextEditingController();
  final _txtLuongCB = TextEditingController(text: '0');
  bool _gioiTinh = false;
  bool _thoiVu = true;
  bool _khongCuTru = true;
  bool _coCamKet = false;
  bool _theoDoi = true;
  DateTime? _ngaySinh;
  DateTime? _ngayVaoLam;
  int indexTab = 0;

  void onSave() {
    NhanVienModel nv = NhanVienModel(
      MaNV: _txtMaNV.text.trim(),
      HoTen: _txtHoTen.text.trim(),
      Phai: _gioiTinh,
      NgaySinh: Helper.yMd(_ngaySinh),
      CCCD: _txtCCCD.text.trim(),
      MST: _txtMST.text.trim(),
      DiaChi: _txtDiaChi.text.trim(),
      DienThoai: _txtDienThoai.text.trim(),
      TrinhDo: _txtTrinhDo.text.trim(),
      ChuyenMon: _txtChuyenMon.text.trim(),
      NgayVao: Helper.yMd(_ngayVaoLam),
      ChucDanh: _txtChucDanh.text.trim(),
      LuongCB: Helper.numToDouble(_txtLuongCB.text),
      ThoiVu: _thoiVu,
      KhongCuTru: _khongCuTru,
      CoCK: _coCamKet,
      GhiChu: _txtGhiChu.text,
      TheoDoi: _theoDoi,
    );
    if (widget.nhanVien == null) {
      fc.addNV(nv, ref, context);
    } else {
      nv = nv.copyWith(ID: widget.nhanVien?.ID!);
      fc.updateNV(nv, ref, context);
    }
  }

  @override
  void initState() {
    if (widget.nhanVien != null) {
      final nv = widget.nhanVien;
      _txtMaNV.text = nv!.MaNV;
      _txtHoTen.text = nv.HoTen!;
      _ngaySinh = toDate(nv.NgaySinh);
      _gioiTinh = nv.Phai;
      _txtDienThoai.text = nv.DienThoai ?? '';
      _txtCCCD.text = nv.CCCD ?? '';
      _txtMST.text = nv.MST ?? '';
      _txtDiaChi.text = nv.DiaChi ?? '';
      _txtGhiChu.text = nv.GhiChu ?? '';
      _ngayVaoLam = toDate(nv.NgayVao);
      _txtChucDanh.text = nv.ChucDanh ?? "";
      _txtTrinhDo.text = nv.TrinhDo ?? '';
      _txtChuyenMon.text = nv.ChuyenMon ?? "";
      _thoiVu = nv.ThoiVu;
      _khongCuTru = nv.KhongCuTru;
      _coCamKet = nv.CoCK;
      _theoDoi = nv.TheoDoi;
      _txtLuongCB.text = Helper.numFormat(nv.LuongCB)!;
      ref.read(pcgtProvider.notifier).getPCGT(maNV: nv.MaNV);
    } else {
      ref.read(pcgtProvider.notifier).getPCGT();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(pcgtProvider, (context, state) {
      _stateManager.removeAllRows();
      _stateManager.appendRows(
        state.map((e) {
          return TrinaRow(
            cells: {
              'null': TrinaCell(value: e.MaPC),
              'MoTa': TrinaCell(value: e.MoTa),
              'SoTieuChuan': TrinaCell(value: e.SoTieuChuan),
            },
          );
        }).toList(),
      );
    });
    return Scaffold(
      backgroundColor: context.theme.colorScheme.border,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Tabs(
            index: indexTab,
            onChanged: (val) {
              setState(() {
                indexTab = val;
              });
            },
            children: [
              TabItem(child: Text('Thông tin cá nhân')),
              TabItem(child: Text('Phụ cấp + giảm trừ')),
            ],
          ),
          IndexedStack(
            index: indexTab,
            children: [
              OutlinedContainer(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    WidgetCustomRow(
                      columnWidths: {0: 100, 1: 200, 2: 110},
                      items: [
                        Text('Mã nhân viên').medium,
                        WidgetTextField(controller: _txtMaNV, enabled: widget.udMa),
                        Text('Họ và tên').medium.withMargin(left: 20),
                        WidgetTextField(controller: _txtHoTen),
                      ],
                    ),
                    WidgetCustomRow(
                      columnWidths: {0: 100, 1: 200, 2: 110},
                      items: [
                        Text('Ngày sinh').medium,
                        WidgetDateBox(
                          onChanged: (val) {
                            setState(() {
                              _ngaySinh = val;
                            });
                          },
                          initialDate: _ngaySinh,
                        ),
                        Text('Giới tínhn').medium.withMargin(left: 20),
                        Checkbox(
                          state: _gioiTinh ? CheckboxState.checked : CheckboxState.unchecked,
                          onChanged: (val) {
                            setState(() {
                              _gioiTinh = val.index == 0;
                            });
                          },
                          trailing: Text('Nữ'),
                        ),
                      ],
                    ),
                    WidgetCustomRow(
                      columnWidths: {0: 100, 1: 200, 2: 110},
                      items: [
                        Text('CCCD').medium,
                        WidgetTextField(controller: _txtCCCD),
                        Text('MST').medium.withMargin(left: 20),
                        WidgetTextField(controller: _txtMST),
                      ],
                    ),
                    WidgetCustomRow(
                      columnWidths: {0: 100},
                      items: [
                        Text('Địa chỉ').medium,
                        WidgetTextField(controller: _txtDiaChi),
                      ],
                    ),
                    WidgetCustomRow(
                      columnWidths: {0: 100, 1: 200, 2: 110},
                      items: [
                        Text('Điện thoại').medium,
                        WidgetTextField(controller: _txtDienThoai),
                        Text('Chức danh').medium.withMargin(left: 20),
                        WidgetTextField(controller: _txtChucDanh),
                      ],
                    ),
                    WidgetCustomRow(
                      columnWidths: {0: 100, 1: 200, 2: 110},
                      items: [
                        Text('Trình độ').medium,
                        WidgetTextField(controller: _txtTrinhDo),
                        Text('Chuyên môn').medium.withMargin(left: 20),
                        WidgetTextField(controller: _txtChuyenMon),
                      ],
                    ),
                    WidgetCustomRow(
                      columnWidths: {0: 100, 1: 200, 2: 110},

                      items: [
                        Text('Ngày vào làm').medium,
                        WidgetDateBox(
                          initialDate: _ngayVaoLam,
                          onChanged: (val) {
                            setState(() {
                              _ngayVaoLam = val;
                            });
                          },
                        ),
                        Text('Lương cơ bản').medium.withMargin(left: 20),
                        WidgetTextField(
                          isDouble: true,
                          textAlign: TextAlign.end,
                          controller: _txtLuongCB,
                          hasFocus: (b) {
                            if (!b && _txtLuongCB.text.isNotEmpty) {
                              _txtLuongCB.text = Helper.numFormat(_txtLuongCB.text)!;
                            }
                          },
                        ),
                      ],
                    ),
                    WidgetCustomRow(
                      columnWidths: {0: 100},
                      items: [
                        Text('Ghi chú').medium,
                        WidgetTextField(controller: _txtGhiChu),
                      ],
                    ),
                    WidgetCustomRow(
                      items: [
                        Checkbox(
                          state: _thoiVu ? CheckboxState.checked : CheckboxState.unchecked,
                          onChanged: (val) {
                            setState(() {
                              _thoiVu = val.index == 0;
                            });
                          },
                          trailing: Text('Thời vụ'),
                        ),
                        Visibility(
                          visible: _thoiVu,
                          child: Checkbox(
                            state: _khongCuTru ? CheckboxState.checked : CheckboxState.unchecked,
                            onChanged: (val) {
                              setState(() {
                                _khongCuTru = val.index == 0;
                                _coCamKet = !(val.index == 0);
                              });
                            },
                            trailing: Text('Không cư trú'),
                          ),
                        ),
                        Visibility(
                          visible: !_khongCuTru && _thoiVu,
                          child: Checkbox(
                            state: _coCamKet ? CheckboxState.checked : CheckboxState.unchecked,
                            onChanged: (val) {
                              setState(() {
                                _coCamKet = val.index == 0;
                              });
                            },
                            trailing: Text('Có cam kết 08'),
                          ),
                        ),
                      ],
                    ),
                    Checkbox(
                      state: _theoDoi ? CheckboxState.checked : CheckboxState.unchecked,
                      onChanged: (val) {
                        setState(() {
                          _theoDoi = val.index == 0;
                        });
                      },
                      trailing: Text('Đang làm việc'),
                    ),
                  ],
                ),
              ),
              OutlinedContainer(
                child: DataGrid(
                  onLoaded: (e) => _stateManager = e.stateManager,
                  onChange: (event) => fc.updatePCGT(event, ref),
                  columns: [
                    DataGridColumn(title: ['', 'null'], width: 25, render: TypeRender.numIndex),
                    DataGridColumn(title: ['Mô tả', 'MoTa'], textStyle: ColumnTextStyle.blue()),
                    DataGridColumn(
                      title: ['Tiêu chuẩn', 'SoTieuChuan'],
                      showFooter: true,
                      columnType: ColumnType.num,
                      isEdit: true,
                    ),
                  ],
                ),
              ),
            ],
          ).sized(height: 400),
          Gap(10),
          PrimaryButton(
            onPressed: onSave,
            child: Text(widget.nhanVien == null ? 'Thêm mới' : 'Cập nhật'),
          ).withAlign(Alignment.center),
        ],
      ).withPadding(all: 10),
    );
  }
}
