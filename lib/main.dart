import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'config/themes/theme_config.dart';
import 'constants/app_routes.dart';
import 'providers/MenuAppController.dart';
import 'providers/auth.dart';
import 'providers/basics.dart';
import 'providers/i18n.dart';
import 'screens/main/main_screen.dart';
import 'utils/services/local_storage_service.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  final appInstances = await _initializeApp();

  FlutterNativeSplash.remove();

  runApp(MyApp(appInstances: appInstances));
}

Future<List<dynamic>> _initializeApp() async {
  // Initialize essential services
  // await Hive.initFlutter();
  await LocalStorageService.initialize(); // Initialize Hive

  final i18nInstance = i18n();
  final authInstance = Auth();
  final basicsInstance = Basics();

  // Run independent operations in parallel to reduce load time
  await Future.wait([
    // LocalStorageService.initialize(), // Initialize Hive
    authInstance.tryAutoLogin(),
    i18nInstance.i18nInit(),
    // basicsInstance.initialBasicsFetchAndSet(),
  ]);

  return [i18nInstance, authInstance, basicsInstance];
}

class MyApp extends StatelessWidget {
  final List<dynamic> appInstances;

  const MyApp({required this.appInstances, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => appInstances[0] as i18n, lazy: false),
        ChangeNotifierProvider(
            create: (_) => appInstances[1] as Auth, lazy: false),
        ChangeNotifierProvider(create: (_) => MenuAppController()),
        ChangeNotifierProxyProvider<Auth, Basics>(
          create: (_) => appInstances[2] as Basics,
          update: (_, auth, previous) =>
              previous!..update(auth.token ?? '', auth.userId ?? ''),
          lazy: false,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MOHE-APP',
        theme: theme,
        routes: routes,
        home: const InitialScreen(),
      ),
    );
  }
}

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<i18n>(
      builder: (ctx, i, _) => Directionality(
        textDirection: i.isRtl ? TextDirection.rtl : TextDirection.ltr,
        child: const MainScreen(),
      ),
    );
  }
}
