import 'package:provider/provider.dart';

import 'auth.dart';
import 'basics.dart';
import 'i18n.dart';
import 'core.dart';

var providers = [
  // ChangeNotifierProvider(create: (_) => i18nInstance),
  ChangeNotifierProvider(create: (_) => i18n()),
  ChangeNotifierProvider(create: (_) => Auth()),

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
      create: (_) => Basics(),
      update: (_, authInstance, previousBasicsInstance) {
        if (previousBasicsInstance != null) {
          return previousBasicsInstance
            ..update(authInstance.token ?? '', authInstance.userId ?? '');
        } else {
          return Basics();
        }
      }),
];
