import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/app_constants.dart';
import '../../providers/MenuAppController.dart';
import '../../providers/auth.dart';
import '../../providers/basics.dart';
import '../../providers/i18n.dart';
import '../../utils/utils.dart';

import '../../widgets/avatar_widget.dart';
import '../../widgets/bottom_navigation_bar_widget.dart';
import '../../widgets/menu_picker.dart';
import '../../widgets/responsive.dart';
import '../core/settings/settings_screen.dart';
import '../mohe-app/document_tracking_screen.dart';
import '../employee_screen.dart';
import 'components/side_menu.dart';

class MainScreen extends StatefulWidget {
  static const routeName = '/main';

  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final MenuAppController menuAppController;

  bool _isInit = true;
  bool isBottomNavVisible = true;
  late final i18n i;
  late final Basics bpr;
  late final Auth apr;

  void _initializeProviders() {
    // menuAppController = Provider.of<MenuAppController>(context);
    // i = Provider.of<i18n>(context, listen: false);
    // bpr = Provider.of<Basics>(context, listen: false);
    // cpr = Provider.of<Centers>(context);
    // apr = Provider.of<Auth>(context, listen: false);

    menuAppController = context.read<MenuAppController>();
    i = context.read<i18n>();
    bpr = context.read<Basics>();
    apr = context.read<Auth>();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _initializeProviders();
      // _futureInstance = _runFetchAndSetInitialBasics();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print("#############   main_screen   ##############");
    int selectedSideMenuIndex = apr.sidemenuIndex;
    double w = Responsive.w(context);

    Center mainPageTitle = Center(
      child: Text(
        i.tr("m86").toUpperCase(),
        // textAlign: TextAlign.start,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 22,
          height: 1.1,
          fontWeight: FontWeight.bold,
          fontFamily: 'Itim',
        ),
      ),
    );
    final List<Map<String, dynamic>> screenPair = [
      {
        "label": 'QRCode',
        "icon": Icons.qr_code_2_outlined,
        "selectedIcon": Icons.qr_code_scanner_outlined,
        "screen": DocumentTrackingScreen(),
        "search": w < 750 ? const Text("نوسراو") : const Text("نوسراو"),
      },
      {
        "label": i.tr('Home'),
        "icon": Icons.house_outlined,
        "selectedIcon": Icons.house,
        "screen": const EmployeeScreen(),
        "search": w < 750 ? const SizedBox.shrink() : mainPageTitle,
      },
      // {
      //   "label": i.tr('researcher profile'),
      //   "icon": Icons.group_outlined,
      //   "selectedIcon": Icons.group_rounded,
      //   "screen": UsersListScreen(
      //       type: 'users',
      //       isBottomNavVisible: isBottomNavVisible,
      //       onDirectionToggleHandler: (v) {
      //         setState(() => isBottomNavVisible = v);
      //       }),
      //   "search": AdvancedSearchPickerMainAppbar(
      //     advancedSearch: const AdvancedSearch(searchForm: UserSearchForm()),
      //     searchContainer: cpr.userSearchData,
      //   )
      // },
      // if (apr.isSuperuser)
      //   {
      //     "label": i.tr('Settings'),
      //     "icon": Icons.settings_outlined,
      //     "selectedIcon": Icons.settings,
      //     "screen": const BasicsDashboardScreen(),
      //     "search": const SizedBox.shrink()
      //   },
    ];
    final List<Widget> searchList = screenPair
        .map((item) => item['search'])
        .whereType<Widget>()
        .cast<Widget>()
        .toList();

    final List<Map<String, dynamic>> navInfoList = screenPair.map((item) {
      return {
        'icon': item['icon'],
        'selectedIcon': item['selectedIcon'],
        'label': item['label'],
      };
    }).toList();

    void onDSHandler(int i) {
      switch (i) {
        // case 1:
        // cpr.onRefreshQuestions();
        // break;
        case 2:
          // cpr.onRefreshUsers();
          break;
        default:
          setState(() {});
      }
    }

    // double w = Responsive.w(context);
    // double h = Responsive.h(context);

    /// to hide drawer automatically when app come from mobile to desktop mode.
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if ((!Responsive.isMobile(context) ||
              !Responsive.isLargeMobile(context) ||
              !Responsive.isTablet(context)) &&
          menuAppController.scaffoldKey.currentState!.isDrawerOpen) {
        Navigator.pop(context);
      }
    });

    return Scaffold(
      // key: context.read<MenuAppController>().scaffoldKey, // Or this way
      key: menuAppController.scaffoldKey,
      drawer: _buildSideMenu(navInfoList, onDSHandler),
      endDrawer: _buildEndDrawer(),
      appBar: _buildAppBar(searchList[selectedSideMenuIndex]),
      body: _buildBody(context, navInfoList, onDSHandler,
          screenPair[selectedSideMenuIndex]['screen'] as Widget),
      bottomNavigationBar:
          _buildBNB(isBottomNavVisible, navInfoList, onDSHandler),
    );
  }

  BottomNavigationBarWidget? _buildBNB(
      bool isBottomNavVisible,
      List<Map<String, dynamic>> navInfoList,
      void Function(int i) onDSHandler) {
    final bool isMobile = Responsive.isMobile(context);
    final bool islargeMobile = Responsive.isLargeMobile(context);
    final bool isTablet = Responsive.isTablet(context);
    return ((isMobile || islargeMobile || isTablet) && !kIsWeb)
        ? BottomNavigationBarWidget(
            isBottomNavVisible: isBottomNavVisible,
            navInfoList: navInfoList,
            onDestinationSelectedHandler: onDSHandler,
          )
        : null;
  }

  Drawer _buildEndDrawer() => const Drawer(child: SettingsScreen());

  PreferredSize _buildAppBar(Widget searchWidget) {
    const double height = kToolbarHeight +
        25; //  kToolbarHeight is a constant defined in the Flutter framework that represents the default height of the app bar. You can adjust this value as needed for your specific use case
    return PreferredSize(
        preferredSize: Size.fromHeight(isBottomNavVisible ? kToolbarHeight : 0),
        child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            height: isBottomNavVisible ? height : 0,
            child: MainScreenAppBar(search: searchWidget)));
  }

  Row _buildBody(BuildContext context, List<Map<String, dynamic>> navInfoList,
      dynamic Function(int) onDSHandler, Widget screenWidget) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // We want this side menu only for large screen
        if (Responsive.isDesktop(context) ||
            Responsive.isLargeDesktop(context) ||
            Responsive.isLargeTablet(context))
          _buildSideMenu(navInfoList, onDSHandler),
        Expanded(
          // It takes 5/6 part of the screen
          // flex: 5,
          // child: _screens[_SMSelectedIndex],
          child: screenWidget,
        ),
      ],
    );
  }

  SideMenu _buildSideMenu(List<Map<String, dynamic>> navInfoList,
      dynamic Function(int) onDSHandler) {
    return SideMenu(
      navInfoList: navInfoList,
      onDestinationSelectedHandler: onDSHandler,
    );
  }
}

class MainScreenAppBar extends StatelessWidget {
  const MainScreenAppBar({
    super.key,
    required this.search,
  });
  final Widget search;

  @override
  Widget build(BuildContext context) {
    print("#############   MainScreenAppBar   ##############");
    final i18n i = Provider.of<i18n>(context, listen: false);
    final Auth apr = Provider.of<Auth>(context);
    final bool isAuth = apr.isAuth;
    double w = Responsive.w(context);

    return AppBar(
      title: FractionallySizedBox(
          widthFactor: Responsive.isDesktop(context) ? 0.5 : 1, child: search),
      centerTitle: true,
      backgroundColor: KScaffoldBackgroundColor,
      leadingWidth: 150,
      leading: Row(
        children: [
          if ((Responsive.isMobile(context) ||
                  Responsive.isLargeMobile(context) ||
                  Responsive.isTablet(context)) &&
              kIsWeb)
            IconButton(
                // onPressed: () => Scaffold.of(context).openDrawer(),// but warp it with Builder(builder: (context) { return IconButton()})
                onPressed: context.read<MenuAppController>().controlMenu,
                icon: const Icon(
                  Icons.menu,
                  color: kPrimaryColor,
                )),
          if (Responsive.isDesktop(context)) const Spacer(),
          // if (!Responsive.isMobile(context)) Image.asset("assets/images/logo.png")
        ],
      ),
      actions: [
        if (isAuth)
          const SettingsHandler()
        else
          ..._buildLoginRegisterBtn(
              context, i, i.tr('m64'), i.tr('Register'), w),
        SizedBox(width: w * 0.007)
      ],
    );
  }

  List<Widget> _buildLoginRegisterBtn(
      BuildContext ctx, i18n i, String s1, String s2, double w) {
    return [
      FractionallySizedBox(
        heightFactor: 0.6,
        child: Theme(
          data: Theme.of(ctx).copyWith(
              floatingActionButtonTheme: const FloatingActionButtonThemeData(
                  // extendedSizeConstraints: BoxConstraints.tightFor(height: 20),
                  )),
          child: FloatingActionButton.extended(
            heroTag: 'loginBtn',
            onPressed: () {
              Navigator.pushNamed(ctx, '/login');
            },
            // icon: Icon(Icons.app_registration_rounded),
            // extendedIconLabelSpacing: 16,
            extendedTextStyle: const TextStyle(fontWeight: FontWeight.bold),
            extendedPadding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 1),
            label: Text(
              s1,
              style: const TextStyle(
                fontFamily: 'Plex Sans Regular',
              ),
            ),
            backgroundColor: KScaffoldBackgroundColor,
            foregroundColor: Colors.black,
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          ),
        ),
      ),
      SizedBox(width: w * 0.007),
      // SizedBox(
      //   height: 35,
      //   width: 135,
      //   child: _buildSelectAppLanguage(ctx, i),
      // ),
      // FractionallySizedBox(
      //   heightFactor: 0.6,
      //   child: Theme(
      //     data: Theme.of(ctx).copyWith(
      //         floatingActionButtonTheme: const FloatingActionButtonThemeData(
      //             // extendedSizeConstraints: BoxConstraints.tightFor(height: 20),
      //             )),
      //     child: FloatingActionButton.extended(
      //       heroTag: 'registerBtn',
      //       onPressed: () {
      //         Navigator.pushNamed(ctx, RegisterScreen.routeName);
      //       },
      //       // icon: Icon(Icons.app_registration_rounded),
      //       // extendedIconLabelSpacing: 16,
      //       extendedTextStyle: const TextStyle(fontWeight: FontWeight.bold),
      //       extendedPadding:
      //           const EdgeInsets.symmetric(horizontal: 24, vertical: 1),
      //       label: Text(s2),
      //       backgroundColor: kPrimaryLightColor,
      //       foregroundColor: Colors.black,
      //       shape:
      //           RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      //     ),
      //   ),
      // ),
    ];
  }

  MenuPicker _buildSelectAppLanguage(BuildContext ctx, i18n i) {
    final int currentActiveLanguageID =
        Utils.getDialectIDByLanguageCode(i.locale);

    return MenuPicker(
      allElements: i18n.locales,
      maSecName: i.maSecBasicName,
      initialSelected: [
        currentActiveLanguageID
      ], // _userData['city'] == null ? [] : [_userData['city']], // WHEN  _userData['city'] IS NOT array
      multipleSelectionsAllowed:
          false, // careful: don't assign "true" when _authData['city'] is not "List", because in that time "selectedHandler" would return List<int>, NOT int
      selectedHandler: (id) {
        // Navigator.of(ctx).pop();
        i.changeLocale(Utils.getLanguageCodeByDialectID(id));
      },
      isScrollControlled:
          false, //to Maximize BottomSheet, if you set to "true", assign "heightFactor" < 1 ,ex 0.9 OTHERWISE 1
      heightFactor: 1,
      title: i.tr('Language'),
      // borderRadius: 40.0, // default
      selectedColorOfPicker: kPrimaryColor,
      selectButtonText: i.tr('Continue'),
      searchVisible: false,
      isSecondaryVisible: true,
      isEnabled: true,
      isValidated: true,
    );
  }
}

class SettingsHandler extends StatelessWidget {
  const SettingsHandler({super.key});

  // static final customCachManager = CacheManager(
  //   Config(
  //     "customCacheKey",
  //     stalePeriod: const Duration(days: 15),
  //     // maxNrOfCacheObjects: 100,
  //   ),
  // );

  @override
  Widget build(BuildContext context) {
    print('*************** UserAccountHandler build ***************');

    final apr = Provider.of<Auth>(context, listen: false);
    Map<String, dynamic>? me = apr.me;
    // Map<String, dynamic>? rp = me!['AnswererProfile'];
    String? avatarUrl = me!['photo'];

    return InkWell(
      onTap: () {
        // Scaffold.of(context).openEndDrawer();
        Responsive.isMobile(context) || Responsive.isLargeMobile(context)
            ? Navigator.pushNamed(context, SettingsScreen.routeName)
            : context.read<MenuAppController>().controlEndDrawer();
      },
      child: Row(
        children: [
          _buildAvatar(avatarUrl),
        ],
      ),
    );
  }

  Widget _buildAvatar(avatarUrl) {
    const double avatarRadius = 24;
    const color = kPrimaryColor;

    return AvatarWidget(
      imagePath: avatarUrl,
      size: avatarRadius,
      color: color,
    );
  }
}
