import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class CustomAlert{
  static Future<AlertButton> error(String text, {String title = ''}) async {
    return await FlutterPlatformAlert.showAlert(
      options: PlatformAlertOptions(
          windows: WindowsAlertOptions(
              preferMessageBox: true
          )
      ),
      windowTitle: title,
      text: text,
      alertStyle: AlertButtonStyle.ok,
      iconStyle: IconStyle.error,
    );
  }

  static Future<AlertButton> success(String text, {String title = ''}) async {
    return await FlutterPlatformAlert.showAlert(
      options: PlatformAlertOptions(
          windows: WindowsAlertOptions(
              preferMessageBox: true
          )
      ),
      windowTitle: 'Success',
      text: text,
      alertStyle: AlertButtonStyle.ok,
      iconStyle: IconStyle.none,
    );
  }

  static Future<AlertButton> warning(String text, {String title = ''}) async {
    return await FlutterPlatformAlert.showAlert(
      options: PlatformAlertOptions(
          windows: WindowsAlertOptions(
              preferMessageBox: true
          )
      ),
      windowTitle: title,
      text: text,
      alertStyle: AlertButtonStyle.okCancel,
      iconStyle: IconStyle.warning,
    );
  }
  static Future<AlertButton> question(String text, {String title = ''}) async {
    return await FlutterPlatformAlert.showAlert(
      options: PlatformAlertOptions(
          windows: WindowsAlertOptions(
              preferMessageBox: true
          )
      ),
      windowTitle: title,
      text: text,
      alertStyle: AlertButtonStyle.okCancel,
      iconStyle: IconStyle.question,
    );
  }
}

void showDeleteSuccess(BuildContext context) async{
  showToast(context: context, builder: (context, overlay){
    return SurfaceCard(
      fillColor: Colors.green,
      filled: true,
      // borderColor: Colors.green,

      child: Basic(

        mainAxisAlignment: MainAxisAlignment.center,
        leading: Icon(PhosphorIcons.checkCircle(PhosphorIconsStyle.fill),color: Colors.white,),
        title: const Text('Xóa thành công',style: TextStyle(color: Colors.white),),
        trailingAlignment: Alignment.center,

        // content: Icon(PhosphorIcons.checkCircle(PhosphorIconsStyle.fill),color: Colors.white,),
        leadingAlignment: Alignment.center,
        trailing: IconButton.ghost(icon: Icon(Icons.close,color: Colors.white,), onPressed: () {
          overlay.close();
        }, size: ButtonSize.small),
      ),
    );
  }, location: ToastLocation.topRight);

}

void showWarning(BuildContext context, String text) async{
  showToast(context: context, builder: (context, overlay){
    return SurfaceCard(
      fillColor: Colors.orange,
      filled: true,
      // borderColor: Colors.green,

      child: Basic(

        mainAxisAlignment: MainAxisAlignment.center,
        leading: Icon(PhosphorIcons.warning(PhosphorIconsStyle.fill),color: Colors.white,),
        title: Text(text,style: TextStyle(color: Colors.white),),
        trailingAlignment: Alignment.center,

        // content: Icon(PhosphorIcons.checkCircle(PhosphorIconsStyle.fill),color: Colors.white,),
        leadingAlignment: Alignment.center,
        trailing: IconButton.ghost(icon: Icon(Icons.close,color: Colors.white,), onPressed: () {
          overlay.close();
        }, size: ButtonSize.small),
      ),
    );
  }, location: ToastLocation.topRight);

}