import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pm_ketoan/application/user/user_notifier.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../core/app_contraint/menu_app.dart';
import '../../data/models/zmodel.dart';

final userInfoProvider = StateProvider<UserModel?>((ref) => null);

final userProvider = StateNotifierProvider.autoDispose<UserNotifier, List<UserModel>>((ref) {
  return UserNotifier();
});

final phanQuyenMenuProvider = StateProvider.autoDispose<List<TreeNode>>((ref) {
  List<TreeNode> result = [];

  mMenu.forEach((k, v) {
    List<TreeNode> a = [];
    mMenu1.forEach((k1, v1) {
      if (v1.parent == k) {
        if (v1.hasChild) {
          List<TreeNode> b = [];
          mMenu2.forEach((k2, v2) {
            if (v2.parent == k1) {
              b.add(TreeItem(data: v2.title));
            }
          });
          a.add(TreeItem(data: v1.title, children: b));
        } else {
          a.add(TreeItem(data: v1.title));
        }
      }
    });
    result.add(TreeItem(data: v.title, children: a));
  });

  return result;
});

final choPhepProvider = StateProvider.autoDispose<bool>((ref) {
  return true;
});
