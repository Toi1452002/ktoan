import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pm_ketoan/application/application.dart';
import 'package:pm_ketoan/core/app_contraint/app_contraint.dart';
import 'package:pm_ketoan/data/data.dart';

class LoginFunction {
  Future<bool> getPathData() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['db'],
      type: FileType.custom,
      lockParentWindow: true,
    );
    if (result != null) {
      GetStorage().write(GetKey.pathData, result.paths.first);
      return true;
    }
    return false;
  }

  Future<void> login(String userName, String passWord, WidgetRef ref) async {
    if(userName.isEmpty && passWord.isEmpty) return;

    final rp = UserRepository();
    final user = await rp.login(userName, passWord);
    if (user != null) {
      ref.read(userInfoProvider.notifier).state = user;
    }
  }
}
