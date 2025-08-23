import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/data/data.dart';
import 'package:pm_ketoan/views/ht_danhsachnguoidung/danhsachnguoidung_function.dart';
import 'package:pm_ketoan/widgets/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';

class ThongTinNguoiDungView extends ConsumerStatefulWidget {
  static const name = "Thông tin người dùng";

  static void show(BuildContext context, {UserModel? user}) => showCustomDialog(
    context,
    title: name.toUpperCase(),
    width: 500,
    height: 490,
    child: ThongTinNguoiDungView(user: user),
  );

  final UserModel? user;

  const ThongTinNguoiDungView({super.key, this.user});

  @override
  ConsumerState createState() => _ThongTinNguoiDungViewState();
}

class _ThongTinNguoiDungViewState extends ConsumerState<ThongTinNguoiDungView> {
  final fc = DanhSachNguoiDungFunction();

  int selectLevel = 1;
  final txtHoTen = TextEditingController();
  final txtDienThoai = TextEditingController();
  final txtDiaChi = TextEditingController();
  final txtEmail = TextEditingController();
  final txtGhiChu = TextEditingController();
  final txtUsername = TextEditingController();
  final txtPassword = TextEditingController();

  @override
  void initState() {
    if (widget.user != null) {
      final user = widget.user;
      txtHoTen.text = user!.HoTen;
      txtDienThoai.text = user.DienThoai;
      txtDiaChi.text = user.DiaChi;
      txtEmail.text = user.Email;
      txtGhiChu.text = user.GhiChu;
      txtUsername.text = user.Username;
      txtPassword.text = user.Password;
      selectLevel = user.Level;
    }
    super.initState();
  }

  void onSubmit() async {
    UserModel user = UserModel(
      Username: txtUsername.text,
      Password: txtPassword.text,
      Level: selectLevel,
      HoTen: txtHoTen.text,
      DienThoai: txtDienThoai.text,
      DiaChi: txtDiaChi.text,
      Email: txtEmail.text,
      GhiChu: txtGhiChu.text,
    );
    if (widget.user == null) {
      await fc.addUser(user, ref, context);
    } else {
      user = user.copyWith(ID: widget.user?.ID);
      await fc.updateUser(user, ref, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.border,
      child: Column(
        spacing: 20,
        children: [
          OutlinedContainer(
            padding: EdgeInsets.all(10),
            child: Column(
              spacing: 10,
              children: [
                WidgetCustomRow(
                  columnWidths: {0: 100},
                  items: [
                    Text('Họ và tên').medium,
                    WidgetTextField(controller: txtHoTen),
                  ],
                ),
                WidgetCustomRow(
                  columnWidths: {0: 100},
                  items: [
                    Text('Điện thoại').medium,
                    WidgetTextField(controller: txtDienThoai),
                  ],
                ),
                WidgetCustomRow(
                  columnWidths: {0: 100},
                  items: [
                    Text('Địa chỉ').medium,
                    WidgetTextField(controller: txtDiaChi),
                  ],
                ),
                WidgetCustomRow(
                  columnWidths: {0: 100},
                  items: [
                    Text('Email').medium,
                    WidgetTextField(controller: txtEmail),
                  ],
                ),
                WidgetCustomRow(
                  columnWidths: {0: 100},
                  items: [Text('Ghi chú').medium, WidgetTextField(maxLines: 2)],
                ),
              ],
            ),
          ),
          OutlinedContainer(
            padding: EdgeInsets.all(10),

            child: Column(
              spacing: 10,
              children: [
                WidgetCustomRow(
                  columnWidths: {0: 100},
                  items: [
                    Text('Username').medium,
                    WidgetTextField(controller: txtUsername),
                  ],
                ),
                WidgetCustomRow(
                  columnWidths: {0: 100},
                  items: [
                    Text('Password').medium,
                    WidgetTextField(obscureText: true, controller: txtPassword),
                  ],
                ),
                WidgetCustomRow(
                  columnWidths: {0: 100},
                  items: [
                    Text('Level').medium,
                    Combobox(
                      value: selectLevel,
                      items: [
                        ComboboxItem(value: 1, text: ['Cấp nhân viên']),
                        ComboboxItem(value: 2, text: ['Cấp quản trị']),
                      ],
                      onChanged: (val) {
                        setState(() {
                          selectLevel = val;
                          selectLevel = val;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Button.primary(onPressed: onSubmit, child: Text(widget.user == null ? 'Thêm mới' : 'Cập nhật')),
        ],
      ).withPadding(all: 10),
    );
  }
}
