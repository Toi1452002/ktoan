import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/application/application.dart';
import 'package:pm_ketoan/views/ht_danhsachnguoidung/danhsachnguoidung_function.dart';
import 'package:pm_ketoan/widgets/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';

import '../../core/core.dart';

class ThayDoiTaiKhoanView extends ConsumerWidget {
  ThayDoiTaiKhoanView({super.key});

  static const name = "Thay đổi tài khoản người dùng";

  static void show(BuildContext context) =>
      showCustomDialog(context, title: name.toUpperCase(), width: 500, height: 350, child: ThayDoiTaiKhoanView());

  final txtTenDangNhapCu = TextEditingController();
  final txtMatKhauCu = TextEditingController();
  final txtTenDangNhapMoi = TextEditingController();
  final txtMatKhauMoi = TextEditingController();
  final txtNhapLaiMatKhau = TextEditingController();

  void onSumit(WidgetRef ref, BuildContext context) async {
    final user = ref.read(userInfoProvider);
    if ([
      txtTenDangNhapCu.text,
      txtMatKhauCu.text,
      txtTenDangNhapMoi.text,
      txtMatKhauMoi.text,
      txtNhapLaiMatKhau.text,
    ].contains('')) {
      CustomAlert.error('Không được bỏ trống bất cứ ô nào');
      return;
    }

    if (txtTenDangNhapCu.text != user?.Username) {
      CustomAlert.error('Tên đăng nhập cũ không khớp');
      return;
    }
    if (txtMatKhauCu.text != user?.Password) {
      CustomAlert.error('Mật khẩu cũ không khớp');
      return;
    }

    if (txtNhapLaiMatKhau.text != txtMatKhauMoi.text) {
      CustomAlert.error('Nhập lại mật khẩu sai');
      return;
    }

    DanhSachNguoiDungFunction().thayDoiTaiKhoan(
      context,
      ref,
      id: user?.ID,
      userName: txtTenDangNhapMoi.text,
      passWord: txtNhapLaiMatKhau.text,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  items: [
                    Text('Tên đăng nhập cũ').medium,
                    WidgetTextField(controller: txtTenDangNhapCu),
                  ],
                ),
                WidgetCustomRow(
                  items: [
                    Text('Mật khẩu cũ').medium,
                    WidgetTextField(obscureText: true, controller: txtMatKhauCu),
                  ],
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
                  items: [
                    Text('Tên đăng nhập mới').medium,
                    WidgetTextField(controller: txtTenDangNhapMoi),
                  ],
                ),
                WidgetCustomRow(
                  items: [
                    Text('Mật khẩu mới').medium,
                    WidgetTextField(obscureText: true, controller: txtMatKhauMoi),
                  ],
                ),
                WidgetCustomRow(
                  items: [
                    Text('Nhập lại mật khẩu').medium,
                    WidgetTextField(obscureText: true, controller: txtNhapLaiMatKhau),
                  ],
                ),
              ],
            ),
          ),
          Button.primary(onPressed: () => onSumit(ref, context), child: Text('Chấp nhận')),
        ],
      ).withPadding(all: 10),
    );
  }
}
