import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/app_constants.dart';
import '../../providers/basics.dart';
import '../../providers/i18n.dart';
import '../../providers/core.dart';
import '../../widgets/responsive.dart';

import 'components/category_list_screen.dart';
import 'components/city_types_list_screen.dart';
import 'components/city_List_screen.dart';
import 'components/dialect_list_screen.dart';
import 'components/privileges_list_screen.dart';
import 'components/roles_list_screen.dart';
import 'components/square_cards_statistics.dart';
import 'components/chart_statistics.dart';
import 'components/tabbar_tabview.dart';

class BasicsDashboardScreen extends StatefulWidget {
  const BasicsDashboardScreen({super.key});

  @override
  State<BasicsDashboardScreen> createState() => _BasicsDashboardScreenState();
}

class _BasicsDashboardScreenState extends State<BasicsDashboardScreen> {
  bool _isInit = true;
  late final i18n i;
  late final Basics bpr;
  late final Core cpr;
  final List<Color> _colors = [
    kPrimaryColor,
    const Color(0xFF26E5FF),
    const Color(0xFFFFCF26),
    kPrimaryMediumColor,
    const Color(0xFFEE2727),
    kPrimaryColor.withOpacity(0.1),
    kPrimaryLightColor,
    Colors.orange,
    Colors.amberAccent,
    Colors.blueAccent
  ];

  final List<String> _svgSrcs = [
    "assets/icons/Documents.svg",
    "assets/icons/google_drive.svg",
    "assets/icons/one_drive.svg",
    "assets/icons/drop_box.svg",
    "assets/icons/media.svg",
    "assets/icons/folder.svg",
    "assets/icons/unknown.svg",
    "assets/icons/menu_tran.svg",
    "assets/icons/menu_store.svg",
    "assets/icons/menu_task.svg",
  ];

  late Future<void> _futureInstance;
  late final List<dynamic> _roleStats;
  late final List<dynamic> _chartStats;
  late final List<dynamic> _rectangleStats;

  Future<void> _runFetchAndSetStats() async {
    try {
      await cpr.fetchAndSetStats();
      _roleStats = cpr.roleStats;
      _chartStats = cpr.chartStats;
      _rectangleStats = cpr.rectangleStats;
    } catch (error) {
      // Handle error
    }
  }

  void _initializeProviders() {
    i = Provider.of<i18n>(context, listen: false);
    bpr = Provider.of<Basics>(context, listen: false);
    cpr = Provider.of<Core>(context, listen: false);
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _initializeProviders();
      _futureInstance = _runFetchAndSetStats();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    bool isSmallScreen = Responsive.w(context) < 1024;

    return SingleChildScrollView(
      primary: false,
      padding: !isSmallScreen ? const EdgeInsets.all(defaultPadding) : null,
      child: FutureBuilder(
          future: _futureInstance,
          builder: (ctx, asyncSnapshot) {
            if (asyncSnapshot.connectionState == ConnectionState.waiting) {
              return kCircularProgressIndicator;
            } else {
              if (asyncSnapshot.hasError) {
                // ...
                // Do error handling stuff
                // return Center(child: Text('${asyncSnapshot.error}'));
                return const Center(child: Text('An error occurred!'));
              } else {
                return _loadBody(isSmallScreen);
              }
            }
          }),
    );
  }

  Column _loadBody(bool isMobile) {
    return Column(
      children: [
        if (isMobile) const SizedBox(height: defaultPadding / 3),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  _buildSquareCardsStatistics(),
                  _buildTabBarAndTabViews(),
                  if (isMobile) const SizedBox(height: defaultPadding),
                  if (isMobile &&
                      _chartStats.isNotEmpty &&
                      _rectangleStats.isNotEmpty)
                    _buildChartStatistics(),
                ],
              ),
            ),
            if (!isMobile) const SizedBox(width: defaultPadding),
            // On Mobile means if the screen is less than 850 we dont want to show it
            if (!isMobile &&
                _chartStats.isNotEmpty &&
                _rectangleStats.isNotEmpty)
              Expanded(
                flex: 2,
                child: _buildChartStatistics(),
              ),
          ],
        )
      ],
    );
  }

  ChartStatistics _buildChartStatistics() {
    return ChartStatistics(
      title: i.tr("category"),
      showChartSectionsTitle: false,
      chartSectionsColor: _colors,
      chartSectionsInfo: _getChartInfoAdaptation(i, _chartStats),
      rectangleCardsInfo: _getRectangleCardsInfoAdaptation(i, _rectangleStats),
    );
  }

  SizedBox _buildTabBarAndTabViews() {
    return SizedBox(
        height: 600,
        child: TabBarAndTabViews(
          tabPairs: _getTabPairs(),
        ));
  }

  SquareCardsStatistics _buildSquareCardsStatistics() {
    return SquareCardsStatistics(
      title: 'My users',
      btnLabel: 'Add New',
      statsInfo: _getSquareCardsInfoAdaptation(i, _roleStats),
    );
  }

  List<Map<String, dynamic>> _getSquareCardsInfoAdaptation(
      i18n i, List<dynamic> baseContainer) {
    return baseContainer
        .asMap()
        .entries
        .map<Map<String, dynamic>>((entry) {
          final index = entry.key;
          final e = entry.value;

          final int percentage =
              ((e['role_total_users'] / e['total']) * 100).round().toInt();
          return {
            'index': index,
            'color': _colors[index],
            'svgSrc': _svgSrcs[index],
            'title': e[i.maSecBasicName[0]],
            'percentage': percentage,
            'bottom_left': "${e['role_total_users']} ${i.tr("Account")}",
            'bottom_right': "$percentage%",
          };
        })
        .toList()
        .take(4)
        .toList(); // return a list of up to 4 items, or fewer
  }

  List<Map<String, dynamic>> _getChartInfoAdaptation(
      i18n i, List<dynamic> baseContainer) {
    return baseContainer
        .asMap()
        .entries
        .map<Map<String, dynamic>>((entry) {
          final index = entry.key;
          final e = entry.value;

          return {
            'index': index,
            'title': e[i.maSecBasicName[0]],
            'value': e['sub_total'],
            'chartCenterSubtitle':
                "${i.tr("of")} ${e['total']} ${i.tr("Question")}",
          };
        })
        .toList()
        .take(5)
        .toList();
    // return a list of up to 5 items, or fewer
  }

  List<Map<String, dynamic>> _getRectangleCardsInfoAdaptation(
      i18n i, List<dynamic> baseContainer) {
    return baseContainer
        .asMap()
        .entries
        .map<Map<String, dynamic>>((entry) {
          final index = entry.key;
          final e = entry.value;

          return {
            'index': index,
            'svgSrc': _svgSrcs[index],
            'title': e[i.maSecBasicName[0]],
            'subtitle': "${i.tr("of")} ${e['total']} ${i.tr("Question")}",
            'trailing': "${e['total']}"
          };
        })
        .toList()
        .take(10)
        .toList(); // return a list of up to 10 items, or fewer
  }

  List<TabPair> _getTabPairs() {
    List<String> tabs = [
      i.tr('role'),
      i.tr('privilege'),
      i.tr('dialect'),
      i.tr('city type'),
      i.tr('city'),
      i.tr('category'),
      // i.tr('subject'),
      // i.tr('topic'),
    ];
    List<Widget> views = [
      const RolesListScreen(),
      const PrivilegesListScreen(),
      const DialectListScreen(),
      const CityTypesListScreen(),
      const CityListScreen(),
      const CategoryListScreen(),
      // const SubjectListScreen(),
      // const TopicListScreen(),
    ];
    return tabs.map((e) {
      int i = tabs.indexOf(e);
      return TabPair(tab: Tab(text: e), view: views[i]);
    }).toList();
  }
}
