import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/i18n.dart';
import 'dashboard/components/basics_list_appbar.dart';
import 'new_question_screen.dart';
import 'questions_list_screen.dart';

class MyQuestionsScreen extends StatelessWidget {
  static const routeName = '/myquestions';
  const MyQuestionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // print('*************** myquestions_screen build ***************');
    final i18n i = Provider.of<i18n>(context, listen: false);
    return Directionality(
      textDirection: i.isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(
              kToolbarHeight), // default appBar height: 56
          child: _buildAppBar(context, i),
        ),
        body: QuestionsListScreen(
            type: 'myquestions',
            isBottomNavVisible: true,
            onDirectionToggleHandler: (v) {
              // setState(() => isBottomNavVisible = v);
            }),
      ),
    );
  }

  BasicsListAppBar _buildAppBar(BuildContext context, i18n i) {
    return BasicsListAppBar(
      onAddHandler: () async {
        Navigator.pushNamed(context, NewQuestionScreen.routeName);
      },
      isSearchActive: false,
      onToggleSearchHandler: null,
      searchBox: null,
      isSecondaryActive: false,
      onToggleSecondaryHandler: null,
      title: i.tr('My Questions'),
    );
  }
}
