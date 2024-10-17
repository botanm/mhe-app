import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_constants.dart';
import '../../../providers/auth.dart';
import '../../../providers/i18n.dart';
import '../../../widgets/animated_rail_widget.dart';
import '../../../widgets/responsive.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({
    super.key,
    required this.navInfoList,
    required this.onDestinationSelectedHandler,
  });

  final List<Map<String, dynamic>> navInfoList;
  final Function(int i) onDestinationSelectedHandler;
  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  late final i18n i;
  late final Auth apr;
  bool _isExtended = false;
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      i = Provider.of<i18n>(context, listen: false);
      apr = Provider.of<Auth>(context);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print("#############   side_menu   ##############");
    final bool isMobile = Responsive.isMobile(context);
    final bool isLargeMobile = Responsive.isLargeMobile(context);
    final bool isTablet = Responsive.isTablet(context);

    final List<NavigationRailDestination> destinations =
        widget.navInfoList.map((item) {
      return NavigationRailDestination(
        icon: Icon(item['icon']),
        selectedIcon: Icon(item['selectedIcon']),
        label: Text(item['label']),
      );
    }).toList();

    return isMobile || isLargeMobile || isTablet
        ? Drawer(child: _NR(destinations))
        : _NR(destinations);
  }

  NavigationRail _NR(List<NavigationRailDestination> destinations) =>
      NavigationRail(
        destinations: destinations,
        selectedIndex: apr.sidemenuIndex,
        extended: _isExtended,
        onDestinationSelected: _changeDestination,
        // labelType: NavigationRailLabelType.none, // must be .none OR it prompts error with extended: _isExtended,
        selectedLabelTextStyle: const TextStyle(color: kPrimaryColor),
        unselectedLabelTextStyle: const TextStyle(color: kPrimaryMediumColor),
        selectedIconTheme: const IconThemeData(color: kPrimaryColor),
        elevation: 8,
        useIndicator: true,
        indicatorColor: Colors.cyan[50],
        backgroundColor: KScaffoldBackgroundColor,
        leading: _buildLeading,
        trailing: apr.isAuth ? _buildTrailing : null,
        // minWidth: 100,
      );

  IconButton get _buildLeading => IconButton(
      onPressed: () => setState(() => _isExtended = !_isExtended),
      icon: const Icon(Icons.swap_horiz));

  AnimatedRailWidget get _buildTrailing => AnimatedRailWidget(
        press: () {
          apr.logout();
        },
        child: _isExtended
            ? Row(
                children: [
                  const Icon(
                    Icons.logout,
                    // size: 28,
                    color: KScaffoldBackgroundColor,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    i.tr('Logout'),
                    style: const TextStyle(
                        color: KScaffoldBackgroundColor, fontSize: 18),
                  )
                ],
              )
            : const Icon(
                Icons.logout,
                // size: 28,
                color: KScaffoldBackgroundColor,
              ),
      );

  void _changeDestination(int index) {
    setState(() {
      apr.sidemenuIndex = index;
      widget.onDestinationSelectedHandler(index);
    });
  }
}
