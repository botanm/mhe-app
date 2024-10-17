import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'config/themes/theme_config.dart';
import 'constants/app_routes.dart';
import 'providers/MenuAppController.dart';
import 'providers/auth.dart';
import 'providers/basics.dart';
import 'providers/core.dart';
import 'providers/i18n.dart';
import 'screens/main/main_screen.dart';
import 'utils/services/local_storage_service.dart';

void main() async {
  await Hive.initFlutter();
  await LocalStorageService.initialize(); // Initialize Hive

  i18n i18nInstance = i18n();
  Auth authInstance = Auth();
  Basics basicsInstance = Basics();
  await authInstance.tryAutoLogin();
  await i18nInstance.i18nInit();
  await basicsInstance.initialBasicsFetchAndSet();

  runApp(MyApp(
      i18nInstance: i18nInstance,
      authInstance: authInstance,
      basicsInstance: basicsInstance));
}

class MyApp extends StatelessWidget {
  const MyApp(
      {required this.i18nInstance,
      required this.authInstance,
      required this.basicsInstance,
      super.key});
  final i18n i18nInstance;
  final Auth authInstance;
  final Basics basicsInstance;
  // const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('*************** main build ***************');

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => i18nInstance),
        // ChangeNotifierProvider(create: (_) => i18n()),
        // ChangeNotifierProvider.value(
        //     value:
        //         i18nInstance), // Use ChangeNotifierProvider.value instead of ChangeNotifierProvider(create: (_) => i18nInstance), for providers that are already initialized. This can improve performance by avoiding unnecessary calls to create.

        // ChangeNotifierProvider.value(value: authInstance),
        ChangeNotifierProvider(create: (_) => authInstance),
        ChangeNotifierProvider(create: (_) => MenuAppController()),

        /// the following code is implemented Based on my try and error effort
        ChangeNotifierProxyProvider<Auth, Core>(
            create: (_) => Core(),
            update: (_, authInstance, previousCentersInstance) {
              if (previousCentersInstance != null) {
                return previousCentersInstance
                  ..update(authInstance.token ?? '', authInstance.userId ?? '',
                      authInstance.isStaff, authInstance.isSuperuser);
              } else {
                return Core();
              }
            }),
        ChangeNotifierProxyProvider<Auth, Basics>(
            create: (_) => basicsInstance,
            update: (_, authInstance, previousBasicsInstance) {
              if (previousBasicsInstance != null) {
                return previousBasicsInstance
                  ..update(authInstance.token ?? '', authInstance.userId ?? '');
              } else {
                return basicsInstance;
              }
            }),
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
