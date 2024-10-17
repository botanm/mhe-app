import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/i18n.dart';
import '../widgets/background.dart';
import '../widgets/responsive.dart';
import '../widgets/user_detail_widget.dart';
import 'core/auth/login/components/side_image_widget.dart';

class UserDetailScreen extends StatelessWidget {
  static const routeName = '/user_detail';
  const UserDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final i18n i = Provider.of<i18n>(context, listen: false);
    bool isSmallSizeScreen = Responsive.w(context) < 1200;
    const SideImageWidget siw = SideImageWidget(
        // title: 'User detail',
        svgUrl: 'assets/icons/logo-ministry.svg');

    return Background(
      child: SingleChildScrollView(
        child: Directionality(
          textDirection: i.isRtl ? TextDirection.rtl : TextDirection.ltr,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (isSmallSizeScreen) siw,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isSmallSizeScreen)
                    const Expanded(
                      flex: 3,
                      child: siw,
                    ),
                  if (!isSmallSizeScreen) const Spacer(),
                  Expanded(
                    flex: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: UserDetailWidget(id: args['id']),
                    ),
                  ),
                  if (!isSmallSizeScreen) const Spacer(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
