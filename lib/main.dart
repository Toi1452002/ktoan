import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pm_ketoan/application/application.dart';
import 'package:pm_ketoan/views/views.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:window_manager/window_manager.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  await GetStorage.init();

  WindowOptions windowOptions = const WindowOptions(
    // size: Size(850, 600),
    minimumSize: Size(850, 600),
    center: true,
    title: 'KETOAN',
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
    windowButtonVisibility: false,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLogin = ref.watch(userInfoProvider);

    return ShadcnApp(
      home: isLogin ==null ? LoginView() : HomeView(),
      theme: ThemeData(
        colorScheme: ColorSchemes.lightBlue,
        typography: Typography.geist(
          base: TextStyle(fontWeight: FontWeight.normal, fontFamily: 'Arial'),
          medium: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
        radius: .2,
        platform: TargetPlatform.windows,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [Locale('vi', '')],
    );
  }
}
