import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_constants.dart';
import '../../../widgets/responsive.dart';
import '../providers/auth.dart';
import '../providers/basics.dart';
import '../providers/i18n.dart';
import '../screens/dashboard/components/basics_rud_listtile.dart';
import '../utils/utils.dart';
import 'top_widget.dart';

class UserCards extends StatelessWidget {
  const UserCards({
    super.key,
    required this.container,
    required this.isNext,
  });
  final List<dynamic> container;
  final bool isNext;

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    final double w = Responsive.w(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // if (cpr.authToken.isNotEmpty)
          //   Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     children: [
          //       Text(
          //         i.tr("Accounts"),
          //         style: Theme.of(context).textTheme.titleLarge,
          //       ),
          //       ElevatedButton.icon(
          //         style: TextButton.styleFrom(
          //             padding: EdgeInsets.symmetric(
          //               horizontal: defaultPadding * 1.5,
          //               vertical: defaultPadding /
          //                   (Responsive.isMobile(context) ? 2 : 1),
          //             ),
          //             backgroundColor: kPrimaryColor),
          //         onPressed: () {},
          //         icon: const Icon(Icons.add, color: KScaffoldBackgroundColor),
          //         label: Text(i.tr("Add"),
          //             style: const TextStyle(color: KScaffoldBackgroundColor)),
          //       ),
          //     ],
          //   ),
          SizedBox(height: isMobile ? defaultPadding : defaultPadding * 3),
          Responsive(
            mobile: (BuildContext context) => UserCardsGridView(
              crossAxisCount: 1,
              childAspectRatio: 0.4,
              container: container,
              isNext: isNext,
            ),
            largeMobile: (BuildContext context) => UserCardsGridView(
              crossAxisCount: 1,
              childAspectRatio: 0.5,
              container: container,
              isNext: isNext,
            ),
            tablet: (BuildContext context) => UserCardsGridView(
              crossAxisCount: 1,
              childAspectRatio: 0.9,
              container: container,
              isNext: isNext,
            ),
            largeTablet: (BuildContext context) => UserCardsGridView(
              crossAxisCount: 2,
              childAspectRatio: 1 / 2, // w/h
              container: container,
              isNext: isNext,
            ),
            desktop: (BuildContext context) => UserCardsGridView(
              crossAxisCount: 2,
              childAspectRatio: 0.7, //w < 1300 ? 0.4 : 0.5, // 1/1.2 w/h
              container: container,
              isNext: isNext,
            ),
            largeDesktop: (BuildContext context) => UserCardsGridView(
              crossAxisCount: w < 1700 ? 3 : 4,
              childAspectRatio: w < 1700 ? 0.5 : 0.6, // 1/1.2 w/h
              container: container,
              isNext: isNext,
            ),
          ),
        ],
      ),
    );
  }
}

class UserCardsGridView extends StatelessWidget {
  const UserCardsGridView({
    super.key,
    required this.container,
    required this.isNext,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
  });
  final List<dynamic> container;
  final bool isNext;
  final int crossAxisCount;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    final i = Provider.of<i18n>(context, listen: false);

    final int containerLength = container.length;
    bool isMobile = Responsive.isMobile(context);

    return Column(
      children: [
        buildGridView(
          containerLength,
          context,
          container,
        ),
        SizedBox(height: isMobile ? defaultPadding : 3 * defaultPadding),
        buildNextLoader(isNext, i.tr('Nothing more to load')),
        if (!isMobile) const SizedBox(height: 3 * defaultPadding),
      ],
    );
  }

  GridView buildGridView(
      int containerLength, BuildContext context, List<dynamic> container) {
    List<double> cm = getCM(context);
    return GridView.builder(
      key: UniqueKey(),
      // physics: const NeverScrollableScrollPhysics(),
      // physics:
      //     const AlwaysScrollableScrollPhysics(), // without this RefreshIndicator is not work
      shrinkWrap: true,
      primary:
          false, // you MUST to make it false to disable scrolling, because you want to work on SingleChildScrollView in "user_list_screen.dart"
      itemCount: containerLength,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: cm[0],
        mainAxisSpacing: cm[1],
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) => UserCard(info: container[index]),
    );
  }

  List<double> getCM(BuildContext context) {
    double w = Responsive.w(context);
    double factor = 0.01; // 5% of the screen width

    if (w > 750 && w < 1024) {
      // Use a bigger factor for largeTablet screens
      factor = 0.02;
    }

    return [factor * w, factor * w * 1.2];
  }

  Widget buildNextLoader(bool isNext, String text) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        isNext
            ? kCircularProgressIndicator
            : Text(text,
                style: const TextStyle(
                    color: kPrimaryColor, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class UserCard extends StatelessWidget {
  const UserCard({
    super.key,
    required this.info,
  });

  final Map<String, dynamic> info;

  @override
  Widget build(BuildContext context) {
    final i18n i = Provider.of<i18n>(context, listen: false);
    final Basics bpr = Provider.of<Basics>(context, listen: false);
    final Auth apr = Provider.of<Auth>(context, listen: false);

    bool isAuth = apr.isAuth;
    final Map<String, dynamic>? me = apr.me;
    final bool isSuperuser = apr.isSuperuser;
    final bool isMe = info['id'] == me?['id'];
    bool isSuperuserOrMe = isAuth && (isSuperuser || isMe);
    final bool isStaff = apr.isStaff;

    List<dynamic> phone = info['phone'] ?? [];

    // List<String> generalSpecializationText = [];
    // if (info["ResearcherProfile"] != null) {
    //   List<dynamic> generalSpecializationIds =
    //       info["ResearcherProfile"]?["general_specialization_id"] ?? [];
    //   if (generalSpecializationIds.isNotEmpty) {
    //     generalSpecializationText = Utils.getTextById(
    //         generalSpecializationIds, bpr.categories, i.maSecBasicName[0]);
    //   }
    // }
    List<int> allParents = info['city'] == null
        ? []
        : Utils.getAllParents([], info['city'], bpr.cities);

    final allParentsText =
        Utils.joinTexts(allParents, bpr.cities, i.maSecBasicName[0], ' >>');

    final String? coverInitialImagePath = info['AnswererProfile'] == null
        ? null
        : info['AnswererProfile']['cover_image'];
    final String? avatarInitialImagePath = info['AnswererProfile'] == null
        ? null
        : info['AnswererProfile']['avatar'];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(40)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          TopWidget(
            cInitialImagePath: coverInitialImagePath,
            aInitialImagePath: avatarInitialImagePath,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(defaultPadding, defaultPadding,
                  defaultPadding, 2 * defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildBasicsRUDListTile(i, phone, isSuperuserOrMe, context,
                      apr, isStaff, isSuperuser, isMe),
                  const SizedBox(height: 40),
                  Text(
                    allParentsText,
                    style: const TextStyle(fontSize: 14),
                    // maxLines: 1,
                    // overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Text(
                      info['AnswererProfile'] == null
                          ? ""
                          : (info['AnswererProfile'][i.maSecAbout[0]] ?? ""),
                      style: const TextStyle(fontSize: 14),
                      maxLines: 20,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  // const Spacer(),
                  // Wrap(
                  //   alignment: WrapAlignment.spaceAround,
                  //   spacing: 3,
                  //   children: generalSpecializationText
                  //       .map((i) => Chip(
                  //             elevation: 1,
                  //             label: Text(
                  //               i,
                  //               style: const TextStyle(fontSize: 16),
                  //             ),
                  //             backgroundColor: KScaffoldBackgroundColor,
                  //           ))
                  //       .toList(),
                  // ),
                  const SizedBox(height: 4),
                  const Divider(thickness: 1.0, height: 0.0),
                  // const SizedBox(height: 12),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text(
                  //       "31 Research",
                  //       style: TextStyle(
                  //           fontSize: 20, fontWeight: FontWeight.bold),
                  //     ),
                  //     Text(
                  //       "Computer Engineering",
                  //       style: TextStyle(fontSize: 20),
                  //       // style: Theme.of(ctx)
                  //       //     .textTheme
                  //       //     .bodySmall!
                  //       //     .copyWith(color: Colors.black),
                  //     ),
                  //   ],
                  // )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  BasicsRUDListTile _buildBasicsRUDListTile(
      i18n i,
      List<dynamic> phone,
      bool isSuperuserOrMe,
      BuildContext context,
      Auth apr,
      bool isStaff,
      bool isSuperuser,
      bool isMe) {
    return BasicsRUDListTile(
      // leading: null, default
      title: Text(
        info[i.maSecUserName[0]],
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(info['email']),
          if (phone.isNotEmpty) Text(phone[0]),
        ],
      ),
      trailing: (isSuperuserOrMe)
          ? null // means let BasicsRUDListTile decide to choose one widget here
          : info['AnswererProfile'] != null
              ? onMoreInfoTap(context, apr, i)
              : const SizedBox.shrink(), //null, default
      isSuperuserOrMe: isSuperuserOrMe,
      showViewBtn:
          (info['AnswererProfile'] == null || !apr.isAuth) ? false : true,
      onViewHandler: () {
        final Map<String, dynamic> args = {
          'id': info['id'],
        };
        Navigator.of(context).pop(); // to pop off SMBS in the navigator
        Navigator.pushNamed(context, '/user_detail', arguments: args);
      },
      onEditHandler: () {
        final Map<String, dynamic> args = {
          'editedUserId': info['id'],
          'isChangePassword': false,
          'isViewOnly': false
        };
        Navigator.of(context).pop(); // to pop off SMBS in the navigator
        Navigator.pushNamed(context, '/register', arguments: args);
      },
      onResetHandler: (isStaff || isSuperuser) && !isMe
          ? () {
              final Map<String, dynamic> args = {
                'editedUserId': info['id'],
                'isChangePassword': true,
                'isViewOnly': false
              };
              Navigator.of(context).pop(); // to pop off SMBS in the navigator
              Navigator.pushNamed(context, '/register', arguments: args);
            }
          : null,
      deletePayload: {
        "message": i.tr('m25'),
        "name": 'user',
        "id": info['id'].toString(),
      },
    );
  }

  Widget onMoreInfoTap(BuildContext ctx, Auth apr, i18n i) {
    return TextButton.icon(
        label: Text(i.tr("More"), style: const TextStyle(color: kPrimaryColor)),
        onPressed: () {
          final Map<String, dynamic> args = {
            'id': info['id'],
          };
          apr.isAuth
              ? Navigator.pushNamed(ctx, '/user_detail', arguments: args)
              : Navigator.pushNamed(ctx, '/login');
        },
        icon: const Icon(
          Icons.info_outline_rounded,
          color: kPrimaryMediumColor,
        ));
  }
}
