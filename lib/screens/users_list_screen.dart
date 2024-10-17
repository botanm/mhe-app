import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../../constants/app_constants.dart';
import '../../providers/i18n.dart';
import '../providers/basics.dart';
import '../../widgets/responsive.dart';
import '../providers/core.dart';
import '../widgets/user_cards.dart';

class UsersListScreen extends StatefulWidget {
  const UsersListScreen({
    super.key,
    required this.type,
    required this.isBottomNavVisible,
    required this.onDirectionToggleHandler,
  });
  final String type;
  final bool isBottomNavVisible;
  final Function(bool v) onDirectionToggleHandler;

  @override
  State<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  bool _isInit = true;
  late bool _isBNV;
  late final i18n i;
  late final Basics bpr;
  late final Core cpr;

  late Future<void> _futureInstance;
  late Map<String, dynamic> typeInfo;
  late List<dynamic> container;
  late Future<void> Function(String) fetchAndSet;
  late Future<void> Function() onRefresh;
  late bool isNext;
  late bool isLoading;

  Future<void> _runFetchAndSet() async {
    if (container.isEmpty) {
      // to prevent re-call api with every switch between UsersListScreen and other TAPs in main_screen.dart
      await fetchAndSet('');
    }

    return;
  }

  void _initializeVariables() {
    typeInfo = cpr.getTypeInfo(widget.type);
    container = typeInfo['container'];
    fetchAndSet = typeInfo['fetchAndSet'];
    isNext = typeInfo['isNext'];
    isLoading = typeInfo['isLoading'];
    onRefresh = typeInfo['onRefresh'];
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      i = Provider.of<i18n>(context, listen: false);
      bpr = Provider.of<Basics>(context, listen: false);
      cpr = Provider.of<Core>(context);

      _isBNV = widget.isBottomNavVisible;
      _initializeVariables();

      _futureInstance = _runFetchAndSet();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(UsersListScreen oldWidget) {
    // _isBNV = widget.isBottomNavVisible;
    if (oldWidget.isBottomNavVisible != widget.isBottomNavVisible) {
      _isBNV = widget.isBottomNavVisible;
    }
    _initializeVariables();

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    bool isTablet = Responsive.isTablet(context);
    return FutureBuilder(
        future: _futureInstance,
        builder: (ctx, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return kCircularProgressIndicator;
          } else {
            if (asyncSnapshot.hasError) {
              // ...
              // Do error handling stuff
              return Center(child: Text('${asyncSnapshot.error}'));
              //return Center(child: Text('An error occurred!'));
            } else {
              return loadCardsScreen(isMobile, isTablet);
            }
          }
        });
  }

  Widget loadCardsScreen(bool isMobile, bool isTablet) {
    bool isWeb = kIsWeb;
    return NotificationListener<UserScrollNotification>(
      onNotification: (notification) {
        if (notification.direction == ScrollDirection.forward) {
          if (!_isBNV) {
            widget.onDirectionToggleHandler(true);
          }
        } else if (notification.direction == ScrollDirection.reverse) {
          if (_isBNV) {
            widget.onDirectionToggleHandler(false);
          }

          if (notification.metrics.pixels >=
                      notification.metrics.maxScrollExtent -
                          (isWeb ? 2000 : 3000) &&
                  !notification.metrics.outOfRange &&
                  isNext &&
                  !isLoading // to ensure the loading of previous request is complete, only in that case call new request to fetchAndSetUsers('')
              ) {
            fetchAndSet('');
          }
        }
        return true;
      },
      child: RefreshIndicator(
        onRefresh: onRefresh,
        color: kPrimaryColor,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                  height: isMobile ? defaultPadding / 3 : defaultPadding * 3),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        UserCards(
                          container: container,
                          isNext: isNext,
                        ),
                        if (isMobile) const SizedBox(height: defaultPadding),
                      ],
                    ),
                  ),
                  if (!isMobile) const SizedBox(width: defaultPadding),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
