import 'package:flutter/material.dart';
import '../../../constants/app_constants.dart';

class TabPair {
  final Tab tab;
  final Widget view;
  TabPair({required this.tab, required this.view});
}

class TabBarAndTabViews extends StatefulWidget {
  const TabBarAndTabViews({
    super.key,
    required this.tabPairs,
  });
  final List<TabPair> tabPairs;

  @override
  _TabBarAndTabViewsState createState() => _TabBarAndTabViewsState();
}

class _TabBarAndTabViewsState extends State<TabBarAndTabViews>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: widget.tabPairs.length, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// https://www.youtube.com/watch?v=8x2Ssf5OxQ4
    /// https://www.flutterbricks.com/preview
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // give the tab bar a height [can change height to preferred height]
          Container(
            height: 45,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TabBar(
                      controller: _tabController,
                      // give the indicator a decoration (color and border radius)
                      // indicator: BoxDecoration(
                      //   borderRadius: BorderRadius.circular(
                      //     25.0,
                      //   ),
                      //   color: kPrimaryColor,
                      // ),
                      indicatorColor: kPrimaryColor,
                      labelColor: kPrimaryColor, //Colors.white,
                      unselectedLabelColor: Colors.black,
                      isScrollable: true,
                      tabs: widget.tabPairs
                          .map((tabPair) => tabPair.tab)
                          .toList()),
                ),
              ],
            ),
          ),
          const SizedBox(height: defaultPadding * 0.1),
          Expanded(
            child: Container(
              // padding: const EdgeInsets.all(defaultPadding),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: TabBarView(
                  controller: _tabController,
                  children:
                      widget.tabPairs.map((tabPair) => tabPair.view).toList()),
            ),
          ),
        ],
      ),
    );
  }
}
