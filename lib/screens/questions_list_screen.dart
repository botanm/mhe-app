import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../../constants/app_constants.dart';
import '../../providers/i18n.dart';
import '../providers/basics.dart';
import '../providers/core.dart';
import '../../widgets/responsive.dart';
import '../widgets/question_cards.dart';

class QuestionsListScreen extends StatefulWidget {
  const QuestionsListScreen({
    super.key,
    required this.type,
    required this.isBottomNavVisible,
    required this.onDirectionToggleHandler,
  });
  final String type;
  final bool isBottomNavVisible;
  final Function(bool v) onDirectionToggleHandler;

  @override
  State<QuestionsListScreen> createState() => _QuestionsListScreenState();
}

class _QuestionsListScreenState extends State<QuestionsListScreen> {
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
  void didUpdateWidget(QuestionsListScreen oldWidget) {
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
                        QuestionCards(
                          type: widget.type,
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

// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:frontend/providers/i18n.dart';
// import 'package:provider/provider.dart';

// import '../constants/app_constants.dart' as app_constants;
// import '../providers/basics.dart';
// import '../providers/questions.dart';
// import '../widgets/questions_listview.dart';

// class QuestionsWidget extends StatefulWidget {
//   // static const routeName = '/questions';
//   const QuestionsWidget(
//       {Key? key,
//       required this.isBottomNavVisible,
//       required this.onDirectionToggleHandler})
//       : super(key: key);
//   final bool isBottomNavVisible;
//   final Function(bool v) onDirectionToggleHandler;

//   @override
//   State<QuestionsWidget> createState() => _QuestionsWidgetState();
// }

// class _QuestionsWidgetState extends State<QuestionsWidget> {
//   late bool _isBNV;
//   late final i18n i;
//   late final Basics bpr;
//   late final Questions qpr;
//   late Future<void> _futureInstance;

//   Future<void> _runFetchAndSetInitialBasics() async {
//     await bpr.initialBasicsFetchAndSet();
//     if (qpr.questions.isEmpty) {
//       // to prevent re-call api with every switch between AnswersWidget and QuestionsWidget in primary_screen.dart

//       return qpr.fetchAndSetQuestions('');
//     }
//   }

//   @override
//   void initState() {
//     _isBNV = widget.isBottomNavVisible;
//     i = Provider.of<i18n>(context, listen: false);
//     qpr = Provider.of<Questions>(context, listen: false);
//     bpr = Provider.of<Basics>(context, listen: false);
//     _futureInstance = _runFetchAndSetInitialBasics();

//     super.initState();
//   }

//   @override
//   void didUpdateWidget(QuestionsWidget oldWidget) {
//     _isBNV = widget.isBottomNavVisible;
//     // if (oldWidget.isBottomNavVisible != widget.isBottomNavVisible) {
//     //  isBNV = widget.isBottomNavVisible;
//     // }

//     super.didUpdateWidget(oldWidget);
//   }

//   /// there 2 main way to load future data api from backend and show spinner while waiting to api response
//   /// First way: in initState() AND  didChangeDependencies()
//   /// here you should use "StatefulWidget" AND "_isLoading" variable and toggle output base on  "_isLoading ? CircularProgressIndicator() : ShowWidget()"
//   ///
//   /// Second Way: FutureBuilder()
//   /// But using the future builder is definitely the approach I would recommend because it's so elegant and it utilizes the tools Flutter gives you.
//   /// it, of course, also avoids rebuilding this entire widget trigger just because the _isLoading state changed.
//   /// Instead, it will really just rebuild the parts that do need rebuilding.
//   /// but be careful, if you had something which causes run build method of this widget again, then "fetchAndSetQuestions()" would of course, also be executed again.
//   /// Therefore, it is considered a better practice to add a new method which returns a future as implemented above "_obtainQuestionsFuture()"
//   /// By using this approach, you ensure that no new future is created just because your which it rebuilds

//   // bool _isLoading = false;
//   // late final Questions pr;
//   //
//   /// First way: in initState()
//   // @override
//   // void initState() {
//   //   // Provider.of<Questions>(context).fetchAndSetQuestions(); // WON'T WORK!
//   //   //if you add "listen: false" , you can use "provider"in "initState()" WITHOUT the "Future.delayed()" workaround
//   //   // but it is only for "provider", but for other "of(context)" would not work
//   //   // the below commented code which is "Future.delayed()" is work but it is not a normal way (not recommended)
//   //   // Future.delayed(Duration.zero).then((_) async {
//   //   //   setState(() {
//   //   //     _isLoading = true;
//   //   //   });
//   //   //   await Provider.of<Questions>(context).fetchAndSetQuestions();
//   //   //   setState(() {
//   //   //     _isLoading = false;
//   //   //   });
//   //   // });
//   //
//   //   pr = Provider.of<Questions>(context, listen: false);
//   //   // don't add "async" in "didChangeDependencies()" AND "initState()", because these aren't methods which return future normally,
//   //   // instead you override the build in methods, you shouldn't change what they return, so using async here would change what they return
//   //   // because async method always return future, but you can use ".then( () {} )"
//   //   // in "didChangeDependencies()" AND "initState()" while not use "Future.delayed()" ,it is not need to wrap "_isLoading = true;" in "setState", because this is run before "build" run.
//   //   _isLoading = true;
//   //   pr.fetchAndSetQuestions('').then((_) {
//   //     setState(() {
//   //       _isLoading = false;
//   //       // pr.fetchAndSetBookmarkQuestions();
//   //     });
//   //   });
//   //   super.initState();
//   // }
//   //

//   /// First way: in didChangeDependencies()
//   // // bool _isInit = true;
//   // // @override
//   // // void didChangeDependencies() {
//   // //   super.didChangeDependencies();
//   // //   pr = Provider.of<Questions>(context, listen: false);
//   // //   if (_isInit) {
//   // //     _isLoading = true;
//   // //     pr.fetchAndSetQuestions('').then((_) {
//   // //       setState(() {
//   // //         _isLoading = false;
//   // //         pr.fetchAndSetBookmarkQuestions();
//   // //       });
//   // //     });
//   // //   }
//   // //   _isInit = false;
//   // // }

//   @override
//   Widget build(BuildContext context) {
//     // print(
//     //     '#############################     questions_widget build     #############################');
//     return NestedScrollView(
//       // Setting floatHeaderSlivers to true is required in order to float
//       // the outer slivers over the inner scrollable.
//       floatHeaderSlivers: true,
//       headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
//         return <Widget>[
//           SliverAppBar(
//             elevation: 0.0,
//             floating: true,
//             pinned: true,
//             snap: true,
//             // snap: true,
//             backgroundColor: const Color(0xffF3F2F8),
//             title: Text(i.tr('Pending questions'),
//                 style: const TextStyle(color: Colors.black)),

//             expandedHeight: 150.0,

//             // forceElevated: true,
//           ),
//         ];
//       },
//       body: Builder(builder: (context) {
//         final innerScrollController = PrimaryScrollController.of(context)!;
//         // https://stackoverflow.com/questions/61093319/scroll-listeners-on-nestedscrollviews-outer-body
//         // if you use "NestedScrollView", there are two Scroller "inner", and "Outer". outer use in "SliverAppBar" while inner use in "body:" of "NestedScrollView"
//         // "PrimaryScrollController.of(context)!" is inner one, to check it is outer or inner just "print(PrimaryScrollController.of(context)!.position)"
//         // you have to use "!" at as "Null Safety"end of "PrimaryScrollController.of(context)!" because ScrollController is not nullable
//         // you must wrap "NotificationListener" in "Builder(builder: (context) {})" because of using ".of(context)"
//         // we have used "FloatingActionButton" inside "Builder(builder: (context) {})", because in outside of it "PrimaryScrollController.of(context)!" isn't controllable, even if you use it but it give you "outer" ScrollController info
//         return NotificationListener<UserScrollNotification>(
//           onNotification: (notification) {
//             // https://stackoverflow.com/questions/48035594/flutter-notificationlistener-with-scrollnotification-vs-scrollcontroller
//             // https://stackoverflow.com/a/56072729/17568454

//             if (notification.direction == ScrollDirection.forward) {
//               if (!_isBNV) {
//                 widget.onDirectionToggleHandler(true);
//               }
//             } else if (notification.direction == ScrollDirection.reverse) {
//               if (_isBNV) {
//                 widget.onDirectionToggleHandler(false);
//               }
//               if (notification.metrics.pixels >=
//                       notification.metrics.maxScrollExtent - 3000 &&
//                   !notification.metrics.outOfRange &&
//                   !qpr.isLoadingQuestions &&
//                   qpr.isNextQuestions) {
//                 // add "&& !pr.isLoading" to ensure the loading of previous request is complete, only in that case call new request to "fetchAndSetQuestions('')"
//                 //  && "pr.isNextQuestions" to ensure that the entire Questions are not loaded in backend
//                 qpr.fetchAndSetQuestions('');
//               }
//             }
//             return true;
//           },
//           child: Stack(
//             children: [
//               // read the documentation was written above about "FutureBuilder" and video recorded with name "FutureBuilder Deep Dive"
//               FutureBuilder(
//                   future: _futureInstance,
//                   builder: (ctx, asyncSnapshot) {
//                     if (asyncSnapshot.connectionState ==
//                         ConnectionState.waiting) {
//                       return app_constants.kCircularProgressIndicator;
//                     } else {
//                       if (asyncSnapshot.hasError) {
//                         // ...
//                         // Do error handling stuff
//                         return Center(child: Text('${asyncSnapshot.error}'));
//                         //return Center(child: Text('An error occurred!'));
//                       } else {
//                         return const QuestionsListView(
//                           type: 'questions',
//                         );
//                       }
//                     }
//                   }),
//               Visibility(
//                 visible: _isBNV,
//                 child: Positioned(
//                   bottom: 16,
//                   right: 16,
//                   child: FloatingActionButton(
//                     // we just put "FloatingActionButton" here to leave the main place of "FloatingActionButton"  in "Scaffold" to another action in future
//                     onPressed: () {
//                       // innerScrollController.jumpTo(0);
//                       // final double end = innerScrollController.position.maxScrollExtent;
//                       const double start = 0;
//                       innerScrollController.animateTo(
//                         start,
//                         duration: const Duration(seconds: 1),
//                         curve: Curves.easeIn,
//                       );
//                     },
//                     backgroundColor: Colors.black,
//                     child: const Icon(Icons.navigation),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }
