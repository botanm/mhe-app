import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../constants/app_constants.dart';
import '../providers/i18n.dart';
import '../screens/core/auth/login/login_screen.dart';

import '../widgets/responsive.dart';

class Utils {
  static int ascendingSort(dynamic c1, dynamic c2) =>
      c1['ckb_name'].compareTo(c2['ckb_name']);

  static int getDialectIDByLanguageCode(String languageCode) {
    return i18n.locales
        .firstWhere((e) => e['language_code'] == languageCode)['id'] as int;
  }

  static String getLanguageCodeByDialectID(int dialectID) {
    return i18n.locales.firstWhere((e) => e['id'] == dialectID)['language_code']
        as String;
  }

  static openWarningSnackBar(context, String text) {
    // This should be called by an on pressed function
    // Example:
    // Button(
    //  onTap: (){
    //    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //   backgroundColor: Colors.blue,
    //   content: Text("Your Text"),
    //   duration: Duration(milliseconds: 1500),
    // ));
    // }
    //)

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: kPrimaryLightColor,
      content: Row(
        children: [
          const Icon(
            Icons.warning,
            color: Colors.black,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16, color: Colors.black),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      duration: const Duration(milliseconds: 4000),
    ));
  }

  static FractionallySizedBox handle(BuildContext context) {
    final theme = Theme.of(context);

    return FractionallySizedBox(
      widthFactor: 0.25,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 12.0,
        ),
        height: 5.0,
        decoration: BoxDecoration(
          color: theme.dividerColor,
          borderRadius: const BorderRadius.all(Radius.circular(2.5)),
        ),
      ),
    );
  }

  // static Future<void> onAnswerTap(
  //     {required BuildContext context,
  //     required int id,
  //     required bool isReAnswer}) async {
  //   if (Responsive.isMobile(context) || Responsive.isLargeMobile(context)) {
  //     await showModalBottomSheet(
  //       isDismissible: false,
  //       isScrollControlled: true, //to Maximize BottomSheet
  //       backgroundColor: Colors.white,
  //       shape: kBuildTopRoundedRectangleBorder,
  //       context: context,
  //       builder: (context) => FractionallySizedBox(
  //         heightFactor: 0.8,
  //         child: NewAnswerScreen(
  //           qID: id,
  //           args: isReAnswer ? {'answeredQuestionID': id} : null,
  //         ),
  //       ),
  //     );
  //   } else {
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return Dialog(
  //           elevation: 1,
  //           shape: const RoundedRectangleBorder(
  //               borderRadius: BorderRadius.all(Radius.circular(10))),
  //           child: SizedBox(
  //             width: 600,
  //             child: NewAnswerScreen(
  //               qID: id,
  //               args: isReAnswer ? {'answeredQuestionID': id} : null,
  //             ),
  //           ),
  //         );
  //       },
  //     );
  //   }
  // }

  static Future<void> showErrorDialog(
      BuildContext context, String message) async {
    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    final i18n i = Provider.of<i18n>(context, listen: false);
    if (isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (ctx) => Directionality(
          textDirection: i.isRtl ? TextDirection.rtl : TextDirection.ltr,
          child: CupertinoAlertDialog(
            title: Text(i.tr('m71')),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                child: Text(i.tr('Okay')),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) => Directionality(
          textDirection: i.isRtl ? TextDirection.rtl : TextDirection.ltr,
          child: AlertDialog(
            title: Text(i.tr('m71')),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                child: Text(i.tr('Okay')),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        ),
      );
    }
  }

  static Future<void> showSuccessDialog(
      BuildContext context, String message) async {
    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    final i18n i = Provider.of<i18n>(context, listen: false);
    if (isIOS) {
      showCupertinoDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => Directionality(
          textDirection: i.isRtl ? TextDirection.rtl : TextDirection.ltr,
          child: CupertinoAlertDialog(
            title: Column(
              children: [
                const Icon(
                  CupertinoIcons.check_mark_circled_solid,
                  color: Colors.green,
                  size: 50,
                ),
                const SizedBox(height: 10),
                Text(i.tr('Success')),
              ],
            ),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                child: Text(i.tr('Okay')),
                onPressed: () {
                  Navigator.of(ctx).pop();
                  Navigator.pushReplacementNamed(ctx, LoginScreen.routeName);
                },
              )
            ],
          ),
        ),
      );
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => Directionality(
          textDirection: i.isRtl ? TextDirection.rtl : TextDirection.ltr,
          child: AlertDialog(
            title: Column(
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 50,
                ),
                const SizedBox(height: 10),
                Text(i.tr('Success')),
              ],
            ),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                child: Text(i.tr('Okay')),
                onPressed: () {
                  Navigator.of(ctx).pop();
                  Navigator.pushReplacementNamed(ctx, LoginScreen.routeName);
                },
              )
            ],
          ),
        ),
      );
    }
  }

  static FractionallySizedBox buildHandle(BuildContext context) {
    final theme = Theme.of(context);

    return FractionallySizedBox(
      widthFactor: 0.25,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 12.0,
        ),
        height: 5.0,
        decoration: BoxDecoration(
          color: theme.dividerColor,
          borderRadius: const BorderRadius.all(Radius.circular(2.5)),
        ),
      ),
    );
  }

  static void showNewScreen(BuildContext context, Map<String, dynamic> args,
      String basicRouteName, Widget newScreenWidget) {
    Navigator.of(context).pop(); // to pop off SMBS in the navigator
    final double w = Responsive.w(context);
    if (w < 1200) {
      Navigator.pushNamed(context, basicRouteName, arguments: args);
    } else {
      showDialog(
          // barrierColor: kPrimaryLightColor.withOpacity(0.2),
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              elevation: 1,
              shape: kBuildTopRoundedRectangleBorder,
              child: FractionallySizedBox(
                heightFactor: 0.9,
                widthFactor: Responsive.isDesktop(context) ? 0.6 : 0.5,
                child: newScreenWidget,
              ),
            );
          });
    }
  }

  // static Future<void> handleDeleteTap({
  //   required BuildContext context,
  //   required i18n i,
  //   required Map<String, String> deletePayload,
  // }) async {
  //   Navigator.of(context).pop(); // to pop off the SMBS in the navigator.

  //   if (Responsive.isMobile(context) || Responsive.isLargeMobile(context)) {
  //     await showModalBottomSheet(
  //       shape: kBuildTopRoundedRectangleBorder,
  //       context: context,
  //       builder: (ctx) => DeleteWidget(deletePayload: deletePayload),
  //     );
  //   } else {
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return Dialog(
  //           elevation: 1,
  //           shape: const RoundedRectangleBorder(
  //               borderRadius: BorderRadius.all(Radius.circular(10))),
  //           child: SizedBox(
  //             width: 600,
  //             child: DeleteWidget(deletePayload: deletePayload),
  //           ),
  //         );
  //       },
  //     );
  //   }
  // }

  static String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
  }

  static List<String> getTextById(
      List<dynamic> elementIDs, List<dynamic> allElements, String mainName) {
    List<String> texts = [];
    for (var id in elementIDs) {
      final name = allElements.firstWhere((e) => e['id'] == id)[mainName];
      texts.add(name);
      // _listPointer.insert(0, _newElement); // at the start of the list
    }
    return texts;
  }

  static List<int> getAllParents(
      List<int> parents, int selfID, List<dynamic> allElements) {
    // parents.add(selfID);
    parents.insert(0, selfID); // at the start of the list

    int? parent = allElements.firstWhere((e) => e['id'] == selfID)['parent_id'];
    if (parent == null) {
      return parents;
    }

    getAllParents(parents, parent, allElements);

    return parents;
  }

  static String joinTexts(List<int> elements, List<dynamic> allElements,
      String text, String symbol) {
    return elements.map((id) {
      return allElements.firstWhere((element) => element['id'] == id)[text];
    }).join(symbol);
  }

  static Future openBrowserUrl(
      {required String url, bool inApp = false}) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(
        url,
        // mode: LaunchMode.inAppBrowserView,
      );
    }
  }

  // Method to extract branchId, refDate, and refNo from the URL if the structure matches
  static Map<String, String>? extractDocSearchUrlData(String url) {
    // Parsing the URL
    Uri uri = Uri.parse(url);

    // Check if the URL matches the expected structure
    // We expect at least 8 path segments based on the provided URL structure
    if (uri.pathSegments.length != 6) {
      return null; // Invalid structure, return null
    }

    // Check if the known parts of the URL structure are correct
    if (uri.pathSegments[0] != 'api' ||
        uri.pathSegments[1] != 'Mobile' ||
        uri.pathSegments[2] != 'Tracks') {
      return null; // Invalid structure, return null
    }

    // Extracting the necessary parts from the path segments
    String branchId = uri.pathSegments[3]; // 4th segment (index 3)
    String refDate = uri.pathSegments[4]; // 5th, 6th, 7th segments
    String refNo = uri.pathSegments[5]; // 8th segment (index 7)

    // Return the extracted data as a map
    return {
      'branchId': branchId,
      'refDate': refDate,
      'refNo': refNo,
    };
  }
}
