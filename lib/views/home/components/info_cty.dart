import 'dart:io';
import 'package:pm_ketoan/application/application.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';

class InfoCty extends ConsumerWidget {
  const InfoCty({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/images/01.jpg'), fit: BoxFit.cover),
      ),
      child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          width: 700,
          height: 250,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: context.theme.colorScheme.background.withValues(alpha: .8),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('PHẦN MỀM KẾ TOÁN').h4(),
              Text('PMN-KT Copyright by RBG - version 1.0').large(),
              // TextButton(child: Text('Được xây dựng bởi www.rgb.com.vn'),onPressed: (){},),
              Text('Tên: ').medium(),
              Gap(10),
              Text('ĐC: ').medium(),
              Gap(10),
              Text('Người dùng: ${ref.read(userInfoProvider)?.HoTen}').medium(),
              Spacer(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  PrimaryButton(
                    child: Text('Đăng xuất'),
                    onPressed: () {
                      ref.read(userInfoProvider.notifier).state = null;
                    },
                  ),
                  PrimaryButton(
                    child: Text('Thoát phần mềm'),
                    onPressed: () {
                      exit(0);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
