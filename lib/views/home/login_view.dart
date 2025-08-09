import 'dart:io';

import 'package:get_storage/get_storage.dart';
import 'package:pm_ketoan/core/app_contraint/app_contraint.dart';
import 'package:pm_ketoan/views/home/funtion/login_function.dart';
import 'package:pm_ketoan/widgets/widget_textfield.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';

class LoginView extends ConsumerStatefulWidget {
  LoginView({super.key});

  @override
  LoginViewState createState() => LoginViewState();
}

class LoginViewState extends ConsumerState<LoginView> {
  final txtTaiKhoan = TextEditingController();
  final txtMatKhau = TextEditingController();
  final LoginFunction fc = LoginFunction();

  void getPath() async {
    if (await fc.getPathData() == true) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.slate[600],
      child: Center(
        child: OutlinedContainer(
          width: 350,
          padding: const EdgeInsets.all(10),
          backgroundColor: context.theme.colorScheme.border,
          boxShadow: [BoxShadow(color: Colors.gray[700], blurRadius: 10, spreadRadius: 2, offset: const Offset(-5, 5))],
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'R',
                      style: TextStyle(fontSize: 40, color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: 'G',
                      style: TextStyle(fontSize: 40, color: Colors.green.shade700, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: 'B',
                      style: TextStyle(fontSize: 40, color: Colors.blue.shade700, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              // Text('Software and Website',style: Theme.of(context).textTheme.titleMedium!.copyWith(
              //     color: Colors.grey.shade600
              // ),),
              OutlinedContainer(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 15,

                  children: [
                    WidgetTextField( controller: txtTaiKhoan, autofocus: true, hintText: 'Username',),
                    WidgetTextField(
                      obscureText: true,
                      hintText: 'Password',
                      spacing: 48,
                      controller: txtMatKhau,
                      onSubmitted: (val) => fc.login(txtTaiKhoan.text, txtMatKhau.text, ref),
                    ),
                    Gap(5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        PrimaryButton(onPressed: getPath, child: Text('Dữ liệu')),
                        PrimaryButton(
                          child: Text('Vào'),
                          onPressed: () => fc.login(txtTaiKhoan.text, txtMatKhau.text, ref),
                        ),
                        PrimaryButton(
                          child: Text('Thoát'),
                          onPressed: () {
                            exit(0);
                          },
                        ),
                      ],
                    ),
                    Container(
                      height: 50,
                      width: double.infinity,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(color: context.theme.colorScheme.border),
                      child: SelectableText(
                        GetStorage().read(GetKey.pathData) ?? '',
                        style: TextStyle(color: Colors.blue.shade900),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
