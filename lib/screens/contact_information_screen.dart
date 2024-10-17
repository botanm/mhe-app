import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_constants.dart';
import '../providers/i18n.dart';
import '../widgets/footer_widget.dart';

class ContactInformationScreen extends StatelessWidget {
  static const routeName = '/contact-information';
  const ContactInformationScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final i = Provider.of<i18n>(context, listen: false);

    return Directionality(
        textDirection: i.isRtl ? TextDirection.rtl : TextDirection.ltr,
        child: Scaffold(
            appBar: AppBar(
              title: Text(i.tr('m96')),
            ),
            body: LayoutBuilder(
              builder: (ctx, constraints) => SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior
                    .onDrag, // to hide (pop off in the navigator) soft input keyboard with tap on screen
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: const IntrinsicHeight(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.email, color: kPrimaryColor),
                              SizedBox(width: 8),
                              Text('info.research@mhe-krg.org'),
                            ],
                          ),
                          SizedBox(height: 8),
                          // Row(
                          //   children: [
                          //     Icon(Icons.phone, color: kPrimaryColor),
                          //     SizedBox(width: 8),
                          //     Text('0964-750-4543603'),
                          //   ],
                          // ),
                          Spacer(),
                          FooterWidget()
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )));
  }
}
