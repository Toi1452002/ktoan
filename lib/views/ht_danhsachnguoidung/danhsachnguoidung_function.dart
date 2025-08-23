import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/application/application.dart';
import 'package:pm_ketoan/core/core.dart';
import 'package:pm_ketoan/data/data.dart';
import 'package:pm_ketoan/views/ht_danhsachnguoidung/thaydoitaikhoan_view.dart';
import 'package:pm_ketoan/views/ht_danhsachnguoidung/thongtinnguoidung_view.dart';
import 'package:trina_grid/trina_grid.dart';

class DanhSachNguoiDungFunction {
  void showInfo(BuildContext context, WidgetRef ref, {int? id}) async {
    if (id == null) {
      ThongTinNguoiDungView.show(context);
    } else {
      final user = await ref.read(userProvider.notifier).getUser(id);
      ThongTinNguoiDungView.show(context, user: user);
    }
  }

  void showThayDoiTaiKhoan(BuildContext context) {
    ThayDoiTaiKhoanView.show(context);
  }

  void thayDoiTaiKhoan(
    BuildContext context,
    WidgetRef ref, {
    int? id,
    required String userName,
    required String passWord,
  }) async {
    final result = await UserRepository().updateUser({"ID": id, "Username": userName, "Password": passWord});
    if (result) {
      // ref.read(userProvider.notifier).get();
      final btn = await CustomAlert.success('Cập nhật thành công, đăng nhập lại');
      if (btn == AlertButton.okButton) {
        ref.read(userInfoProvider.notifier).state = null;
        if (context.mounted) {
          Navigator.pop(context);
          Navigator.pop(context);
        }
      }
    }
  }

  Future<void> addUser(UserModel user, WidgetRef ref, BuildContext context) async {
    final result = await ref.read(userProvider.notifier).add(user);
    if (result != 0) {
      ref.read(userProvider.notifier).get();
      if (context.mounted) Navigator.pop(context);
    }
  }

  Future<void> updateUser(UserModel user, WidgetRef ref, BuildContext context) async {
    final result = await ref.read(userProvider.notifier).update(user);
    if (result != 0) {
      ref.read(userProvider.notifier).get();
      if (context.mounted) Navigator.pop(context);
    }
  }

  Future<void> onTapDelete(int val, TrinaColumnRendererContext re, int userID, WidgetRef ref) async {
    if (userID == 1) {
      final btn = await CustomAlert.question('Có chắc muốn xóa?');
      if (btn == AlertButton.okButton) {
        if (re.cell.value == 1) {
          CustomAlert.warning('Không thể xóa quản trị');
        } else {
          final result = await ref.read(userProvider.notifier).delete(val);
          if (result) {
            re.stateManager.removeCurrentRow();
          }
        }
      }
    }
  }
}
