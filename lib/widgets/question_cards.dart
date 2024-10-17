import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_constants.dart';
import '../../../widgets/responsive.dart';
import '../providers/basics.dart';
import '../providers/core.dart';
import '../providers/i18n.dart';
import '../screens/new_question_screen.dart';
import 'action_sheet_widget.dart';
import 'circle_border_widget.dart';
import '../utils/utils.dart';
import 'menu_item_widget.dart';
import 'pop_up_menu_button_widget.dart';

class QuestionCards extends StatelessWidget {
  const QuestionCards({
    super.key,
    required this.type,
    required this.container,
    required this.isNext,
  });
  final String type;
  final List<dynamic> container;
  final bool isNext;

  @override
  Widget build(BuildContext context) {
    // final i = Provider.of<i18n>(context, listen: false);
    // final apr = Provider.of<Auth>(context, listen: false);
    // final cpr = Provider.of<Centers>(context, listen: false);

    final double w = Responsive.w(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const SizedBox(height: defaultPadding),
          Responsive(
            mobile: (BuildContext context) => QuestionCardsGridView(
              crossAxisCount: 1,
              childAspectRatio: 0.4,
              type: type,
              container: container,
              isNext: isNext,
            ),
            largeMobile: (BuildContext context) => QuestionCardsGridView(
              crossAxisCount: 1,
              childAspectRatio: 0.5,
              type: type,
              container: container,
              isNext: isNext,
            ),
            tablet: (BuildContext context) => QuestionCardsGridView(
              crossAxisCount: 1,
              childAspectRatio: 0.9,
              type: type,
              container: container,
              isNext: isNext,
            ),
            largeTablet: (BuildContext context) => QuestionCardsGridView(
              crossAxisCount: 2,
              childAspectRatio: 1 / 2, // w/h
              type: type,
              container: container,
              isNext: isNext,
            ),
            desktop: (BuildContext context) => QuestionCardsGridView(
              crossAxisCount: 2,
              childAspectRatio: 0.7, //w < 1300 ? 0.4 : 0.5, // 1/1.2 w/h
              type: type,
              container: container,
              isNext: isNext,
            ),
            largeDesktop: (BuildContext context) => QuestionCardsGridView(
              crossAxisCount: w < 1700 ? 3 : 4,
              childAspectRatio: w < 1700 ? 0.5 : 0.6, // 1/1.2 w/h
              type: type,
              container: container,
              isNext: isNext,
            ),
          ),
        ],
      ),
    );
  }
}

class QuestionCardsGridView extends StatelessWidget {
  const QuestionCardsGridView({
    super.key,
    required this.type,
    required this.container,
    required this.isNext,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
  });
  final String type;
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
      itemBuilder: (context, index) =>
          QuestionCard(type: type, info: container[index]),
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

class QuestionCard extends StatelessWidget {
  const QuestionCard({
    super.key,
    required this.info,
    required this.type,
  });

  final Map<String, dynamic> info;
  final String type;

// import flutter_cache_manager to perform customCachManager
  static final customCachManager = CacheManager(
    Config(
      "customCacheKey",
      stalePeriod: const Duration(days: 15),
      // maxNrOfCacheObjects: 100,
    ),
  );

  @override
  Widget build(BuildContext context) {
    // print('*************** question_card build ***************');
    final i = Provider.of<i18n>(context, listen: false);
    final bpr = Provider.of<Basics>(context, listen: false);
    final cpr = Provider.of<Core>(
      context,
    );

    final String mun = i.maSecUserName[0];
    final String mbn = i.maSecBasicName[0];

    final Map<String, dynamic> answererData =
        cpr.users.firstWhere((e) => e['id'] == info['selected_answerer']);
    final String answererName = answererData[mun];
    final String? answererImage = answererData['AnswererProfile']['avatar'];

    final Map<String, dynamic> theQuestionDialectData =
        bpr.findBasicById('dialect', info['dialect']);
    final bool isTheQuestionRTL =
        i.getLocaleIsRtl(theQuestionDialectData['language_code']);
    // final String dialectName = _theQuestionDialectData[mbn];

    final List<String> catText =
        Utils.getTextById(info['categories'], bpr.categories, mbn);
    // final List<String> subText =
    //     Utils.getTextById(qe['subjects'], bpr.subjects, mbn);
    // final List<String> topText =
    //     Utils.getTextById(qe['topics'], bpr.topics, mbn);

    final List<String> mergedTexts = catText; // catText + subText + topText;

    return Card(
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.white,
            Color(0xffF3F2F8),
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: Column(
          children: [
            _buildListTile(answererImage, answererName, context, i),
            _buildContent(isTheQuestionRTL),
            _buildCategories(mergedTexts),
            const FractionallySizedBox(
                widthFactor: 0.95, child: Divider(thickness: 1.0, height: 0.0)),
            // ReactionsWidget(id: qe['id'], type: type),
          ],
        ),
      ),
    );
  }

  Wrap _buildCategories(List<String> mergedTexts) {
    return Wrap(
      alignment: WrapAlignment.spaceAround,
      spacing: 3,
      children: mergedTexts
          .map((i) => Chip(
                label: Text(i, style: const TextStyle(color: Colors.black)),
                backgroundColor: Colors.white,
              ))
          .toList(),
    );
  }

  Container _buildContent(bool isTheQuestionRTL) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 8,
      ),
      child: Text(
        info['content'],
        textAlign: isTheQuestionRTL ? TextAlign.right : TextAlign.left,
      ),
    );
  }

  Widget _buildListTile(String? answererImage, String answererName,
      BuildContext context, i18n i) {
    Map<String, String> deletePayload = {
      "message": i.tr('m25'),
      "name": type,
      "id": info['id'].toString(),
    };

    final List<Widget> items = [
      MenuItemWidget(
        icon: Icons.edit,
        title: i.tr('Edit'),
        subtitle: i.tr('m22'),
        onTap: () {
          Navigator.of(context).pop(); // to pop off SMBS in the navigator
          Navigator.pushNamed(context, NewQuestionScreen.routeName, arguments: {
            'id': info['id'],
            'isEditAnsweredQuestion': type == "answeredQuestions",
          });
        },
      ),
      MenuItemWidget(
        icon: Icons.delete_outline,
        title: i.tr('Delete'),
        subtitle: i.tr(type == "questions" ? 'm23' : 'm24'),
        onTap: () => Utils.handleDeleteTap(
          context: context,
          i: i,
          deletePayload: deletePayload,
        ),
      ),
      if (type == "questions" || type == "answeredQuestions")
        MenuItemWidget(
          icon: Icons.record_voice_over_outlined,
          title: i.tr(type == "questions" ? 'Answer' : 'Re-answer'),
          subtitle: i.tr(type == "questions" ? 'm20' : 'm21'),
          onTap: () {
            Navigator.of(context).pop(); // to pop off SMBS in the navigator
            Utils.onAnswerTap(
                context: context,
                id: info['id'],
                isReAnswer: type == "answeredQuestions");
          },
        ),
    ];

    final bool isSmallScreen = Responsive.w(context) < 1200;

    return Material(
      color: Colors.transparent,
      //we wrap it with "Material", otherwise parent "Container" will block "splash" (ripple) effect to work
      child: ListTile(
        contentPadding: const EdgeInsets.all(0),
        leading: InkResponse(
          onTap: () {
            // Navigator.pushNamed(context, ProfileScreen.routeName,
            //     arguments: answererData['id']);
          },
          splashColor: Colors.orange,
          child: _buildAvatar(answererImage),
        ),
        title: Text(answererName),
        subtitle: _buildSubtitleRow(),
        trailing: isSmallScreen
            ? IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () => SMBSActionSheetWidget.show(
                  context: context,
                  items: items,
                ),
              )
            : PopupMenuButtonWidget(menuList: items),
        dense: true,
      ),
    );
  }

  Row _buildSubtitleRow() {
    return Row(
      children: [
        const Icon(Icons.favorite, color: Colors.orange, size: 15),
        const SizedBox(width: 2),
        Text(info['id'].toString()),
        Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey,
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(width: 4, height: 4),
            )),
        const Text('5 minute ago')
      ],
    );
  }

  CircleBorderWidget _buildAvatar(String? answererImage) {
    const double avatarRadius = 30;
    const color = kPrimaryColor;

    return CircleBorderWidget(
      // width: 1.0, // default
      gap: 1.0, // default
      borderColor: color, // default

      child: CircleAvatar(
        radius: avatarRadius,
        backgroundColor: const Color(0xffF3F2F8),
        backgroundImage: answererImage != null
            // ? NetworkImage(answerer_image)
            ? CachedNetworkImageProvider(
                answererImage,
                cacheManager: customCachManager,
              )
            : null,
        child: answererImage == null
            ? const Icon(Icons.person, color: Colors.black, size: 30)
            : null,
      ),
    );
  }
}
