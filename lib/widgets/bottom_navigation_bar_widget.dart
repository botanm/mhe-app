import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_constants.dart';
import '../providers/auth.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  final bool isBottomNavVisible; // final ScrollController controller;
  final Duration duration;
  const BottomNavigationBarWidget({
    super.key,
    required this.isBottomNavVisible,
    this.duration = const Duration(milliseconds: 400),
    required this.navInfoList,
    required this.onDestinationSelectedHandler,
  });

  final List<Map<String, dynamic>> navInfoList;
  final Function(int i) onDestinationSelectedHandler;

  @override
  State<BottomNavigationBarWidget> createState() =>
      _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  // bool isVisible = true;
  //
  // @override
  // void initState() {
  //   super.initState();
  //
  //   widget.controller.addListener(listen);
  // }
  //
  // @override
  // void dispose() {
  //   widget.controller.removeListener(listen);
  //
  //   super.dispose();
  // }
  //
  // void listen() {
  //   final direction = widget.controller.position.userScrollDirection;
  //   if (direction == ScrollDirection.forward) {
  //     show();
  //   } else if (direction == ScrollDirection.reverse) {
  //     hide();
  //   }
  // }
  //
  // void show() {
  //   if (!isVisible) setState(() => isVisible = true);
  // }
  //
  // void hide() {
  //   if (isVisible) setState(() => isVisible = false);
  // }

  late final Auth apr;
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      apr = Provider.of<Auth>(context);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final List<NavigationDestination> destinations =
        widget.navInfoList.map((item) {
      return NavigationDestination(
        icon: Icon(item['icon']),
        selectedIcon: Icon(item['selectedIcon']),
        label: item['label'],
      );
    }).toList();
    return AnimatedContainer(
      duration: widget.duration,
      height:
          widget.isBottomNavVisible ? 56.0 : 0, // height: isVisible ? 56.0 : 0,
      child: Wrap(children: [
        NavigationBarTheme(
          data: NavigationBarThemeData(
              indicatorColor: kPrimaryLightColor,
              backgroundColor: KScaffoldBackgroundColor,
              labelTextStyle: WidgetStateProperty.all(
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
          child: NavigationBar(
            height: 56,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
            selectedIndex: apr.sidemenuIndex,
            onDestinationSelected: _changeDestination,
            destinations: destinations,
          ),
        ),
      ]),
    );
  }

  void _changeDestination(int index) {
    setState(() {
      apr.sidemenuIndex = index;
      widget.onDestinationSelectedHandler(index);
    });
  }
}
